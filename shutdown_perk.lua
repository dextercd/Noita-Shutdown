table.insert(perk_list,
    {
        id = 'SHUTDOWN',
        ui_name = 'Shutdown',
        ui_description = 'Your computer will turn off when you lose.',
        ui_icon = 'mods/shutdown/ui_icon.png',
        perk_icon = 'mods/shutdown/perk_icon.png',
        stackable = STACKABLE_NO,
        usable_by_enemies = false,
        func = function(entity_perk_item, entity_who_picked, item_name)
            EntityLoad('mods/shutdown/warning_text.xml')

            GameAddFlagRun('shutdown_on_death')
            GameAddFlagRun('shutdown_reason_perk')
        end,
    })
