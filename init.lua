local ffi = require 'ffi'

ffi.cdef[[
int ExitWindowsEx(uint32_t, uint32_t);
]]


function OnPlayerDied( player_entity )
	local exit_result = ffi.C.ExitWindowsEx(0x8, 0x80000000)

	if exit_result ~= 0 then
		GamePrint('Shutdown request successful. Bye!')
	else
		GamePrint("Sorry, couldn't shutdown.")
	end

end
