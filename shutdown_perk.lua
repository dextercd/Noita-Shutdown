table.insert(perk_list,
	{
		id = 'SHUTDOWN',
		ui_name = 'Shutdown on death',
		ui_description = 'Your computer will turn off when you lose.',
		ui_icon = 'mods/Noita-Shutdown/ui_icon.png',
		perk_icon = 'mods/Noita-Shutdown/perk_icon.png',
		func = function(entity_perk_item, entity_who_picked, item_name)
			EntityLoad('mods/Noita-Shutdown/warning_text.xml')

			GameAddFlagRun('shutdown_on_death')
			GameAddFlagRun('shutdown_reason_perk')
		end,
	})
