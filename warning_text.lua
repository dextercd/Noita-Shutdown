dofile('data/scripts/lib/coroutines.lua')

function delay()
	wait(3 * 60)
end

async(function()
	for i=1,3 do
		GamePrint("Warning, shutdown mod is enabled. Please make sure you've saved all open documents, unsaved changes may be lost.")
		delay()
	end
end)
