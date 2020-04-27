local ffi = require 'ffi'

ffi.cdef[[
uint32_t GetLastError(void);

uint32_t FormatMessageA(
	uint32_t dwFlags,
	const void* lpSource,
	uint32_t dwMessageId,
	uint32_t dwLanguageId,
	char* lpBuffer,
	uint32_t nSize,
	va_list *Arguments
);

void* LocalFree(void*);

int ExitWindowsEx(uint32_t, uint32_t);
]]

function format_message(error_code)
	local flags =
		0x100 +  -- FORMAT_MESSAGE_ALLOCATE_BUFFER
		0x1000 + -- FORMAT_MESSAGE_FROM_SYSTEM
		0x200 +  -- FORMAT_MESSAGE_IGNORE_INSERTS
		0xff     -- FORMAT_MESSAGE_MAX_WIDTH_MASK

	local message = ffi.new('char*[1]')
	-- When using FORMAT_MESSAGE_ALLOCATE_BUFFER:
	-- Instead of passing a char* we pass a pointer to a char*, the function
	-- Allocates the memory it needs and places the pointer to that memory into
	-- the location we pass. Since this function normally takes a char* instead
	-- a char** we need to do this scary cast. We then need to free the memory
	-- with LocalFree.
	local message_ptr = ffi.cast('char*',  message)

	ffi.C.FormatMessageA(flags, nil, error_code, 0, message_ptr, 0, nil)

	if message[0] == nil then
		-- Well.. We couldn't get the error message for some reason..
		-- We can retrieve the error, and then get the error text with
		-- FormatMessageA! Oh wait..
		local err = ffi.C.GetLastError()
		error("Couldn't format error code, everything is f'ed: " .. err)
	end

	message_string = ffi.string(message[0])

	ffi.C.LocalFree(message)

	return message_string
end

function last_windows_error_string()
	local error_code = ffi.C.GetLastError()
	return '(' .. error_code .. ') ' .. format_message(error_code)
end

function shutdown()
	local exit_result = ffi.C.ExitWindowsEx(
		0x8, -- Power-off
		0x80000000) -- Planned, no major or minor reason. Update this when SHTDN_REASON_MAJOR_BAD_AT_GAME becomes available

	if exit_status == 0 then
		error("Sorry, couldn't shutdown. " .. last_windows_error_string())
	end
end

function OnPlayerDied( player_entity )
	local did_shutdown, shutdown_error = pcall(shutdown)
	if did_shutdown then
		GamePrint('Shutdown request successful. Bye!')
	else
		GamePrint("Sorry, couldn't shutdown. " .. shutdown_error)
	end
end
