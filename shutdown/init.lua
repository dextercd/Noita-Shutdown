ModLuaFileAppend(
    'data/scripts/perks/perk_list.lua',
    'mods/shutdown/files/scripts/perks/pl_shutdown_perk.lua')

local ffi = require 'ffi'
dofile_once("data/scripts/perks/perk.lua")

ffi.cdef[[
uint32_t GetLastError(void);

uint32_t FormatMessageA(
    uint32_t dwFlags,
    const void* lpSource,
    uint32_t dwMessageId,
    uint32_t dwLanguageId,
    char* lpBuffer,
    uint32_t nSize,
    va_list* Arguments
);

void* LocalFree(void* hMem);

typedef struct {
    uint32_t LowPart;
    int32_t HighPart;
} LUID;

typedef struct {
    LUID Luid;
    uint32_t Attributes;
} LUID_AND_ATTRIBUTES;

typedef struct {
    uint32_t PrivilegeCount;
    LUID_AND_ATTRIBUTES Privileges[1];
} TOKEN_PRIVILEGES;

void* GetCurrentProcess(void);

int OpenProcessToken(
    void* ProcessHandle,
    uint32_t DesiredAccess,
    void** TokenHandle);

int LookupPrivilegeValueA(
    const char* lpSystemName,
    const char* lpName,
    LUID* lpLuid);

int AdjustTokenPrivileges(
    void* TokenHandle,
    int DisableAllPrivileges,
    TOKEN_PRIVILEGES* NewState,
    uint32_t BufferLength,
    TOKEN_PRIVILEGES* PreviousState,
    uint32_t* ReturnLength);

int ExitWindowsEx(uint32_t uFlags, uint32_t dwReason);

const char* wine_get_version();
]]

function get_symbol(lib, symbol)
    return lib[symbol]
end

function symbol_exists(lib, symbol)
    local ok, value = pcall(get_symbol, lib, symbol)
    return ok
end

function format_message(error_code)
    local flags =
        0x100  + -- FORMAT_MESSAGE_ALLOCATE_BUFFER
        0x1000 + -- FORMAT_MESSAGE_FROM_SYSTEM
        0x200  + -- FORMAT_MESSAGE_IGNORE_INSERTS
        0xff     -- FORMAT_MESSAGE_MAX_WIDTH_MASK

    local message_arr = ffi.new('char*[1]')
    -- When using FORMAT_MESSAGE_ALLOCATE_BUFFER:
    -- Instead of passing a char* we pass a pointer to a char*, the function
    -- allocates the memory it needs and places the pointer to that memory into
    -- the location we pass. Since this function normally takes a char* instead
    -- a char** we need to do this scary cast. We then need to free the memory
    -- with LocalFree.
    local message_ptr = ffi.cast('char*', message_arr)

    ffi.C.FormatMessageA(flags, nil, error_code, 0, message_ptr, 0, nil)
    local message = message_arr[0]

    if message == nil then
        -- Well, We couldn't get the error message for some reason. We can
        -- retrieve the error, and then get the error text with FormatMessageA!
        -- Oh wait..
        local err = ffi.C.GetLastError()
        error("Couldn't format error code, everything is f'ed: " .. tostring(err))
    end

    local message_string = ffi.string(message)

    ffi.C.LocalFree(message)

    return message_string
end

function last_windows_error_string()
    local error_code = ffi.C.GetLastError()
    return '(' .. tostring(error_code) .. ') ' .. format_message(error_code)
end

function linux_shutdown()
    -- This is too easy. Feels like cheating :-(
    os.execute("start /unix /usr/bin/shutdown +0")
end

function windows_shutdown()
    local advapi = ffi.load('advapi32')

    local process_token = ffi.new('void*[0]')
    if advapi.OpenProcessToken(ffi.C.GetCurrentProcess(), 0x8 + 0x20, process_token) == 0 then
        error("Couldn't open access token of current process: " + last_windows_error_string())
    end

    local token_privileges = ffi.new('TOKEN_PRIVILEGES')

    -- Get LUID of shutdown privilege
    if advapi.LookupPrivilegeValueA(nil, 'SeShutdownPrivilege', token_privileges.Privileges[0].Luid) == 0 then
        error("Couldn't get shutdown LUID: " .. last_windows_error_string())
    end

    -- Enable shutdown privilege
    token_privileges.PrivilegeCount = 1
    token_privileges.Privileges[0].Attributes = 2 -- SE_PRIVILEGE_ENABLED

    if advapi.AdjustTokenPrivileges(process_token[0], 0, token_privileges, 0, nil, nil) == 0 then
        error("Couldn't adjust token privileges: " .. last_windows_error_string())
    end

    if ffi.C.GetLastError() ~= 0 then
        error("Couldn't enable shutdown privilege.")
    end

    local exit_result = ffi.C.ExitWindowsEx(
        0x8, -- Power-off
        0x80000000) -- Planned, no major or minor reason. Update this when SHTDN_REASON_MAJOR_BAD_AT_GAME becomes available

    if exit_status == 0 then
        error('Shutdown request failed: ' .. last_windows_error_string())
    end
end

function shutdown()
    if symbol_exists(ffi.load("ntdll"), "wine_get_version") then
        return linux_shutdown()
    else
        return windows_shutdown()
    end
end

function did_win()
    return GameHasFlagRun('ending_game_completed')
end

function shutdown_enabled()
    return GameHasFlagRun('shutdown_on_death')
end

function OnPlayerSpawned(player_entity)
    if GameHasFlagRun('shutdown_initialised') then
        return
    end
    GameAddFlagRun('shutdown_initialised')

    if ModSettingGet('shutdown.shutdown_perk') == 'no_perk' then
        local x, y = EntityGetTransform(player_entity)
        local perk = perk_spawn(x, y, 'SHUTDOWN')
        perk_pickup(perk, player_entity, EntityGetName(perk), false, false)
    end
end

function do_shutdown()
    local did_shutdown, shutdown_error = pcall(shutdown)
    if did_shutdown then
        GamePrint('Shutdown request successful. Bye!')
    else
        GamePrint('Error: ' .. shutdown_error)
        GamePrint("Sorry, couldn't shutdown. Instead, please turn off your computer manually.")
    end
end

function OnPlayerDied(player_entity)
    if not did_win() and shutdown_enabled() then
        do_shutdown()
    end
end

function ConfigureAsyncShutdown()
    OnPlayerDied = nil
    function OnWorldPreUpdate()
        if GameGetFrameNum() % 30 == 0 then
            if GameHasFlagRun('shutdown_do_async') then
                do_shutdown()
            end
        end
    end
end


if ModIsEnabled("evaisa.arena") then
    ModLuaFileAppend(
        "mods/evaisa.mp/data/gamemodes.lua",
        "mods/shutdown/integrations/arena.lua"
    )
    ConfigureAsyncShutdown()
end
