table.insert(perk_list,
    {
        id = 'SHUTDOWN',
        ui_name = 'Shutdown',
        ui_description = 'Your computer will turn off when you lose.',
        ui_icon = 'mods/shutdown/files/ui_gfx/perk_icons/shutdown.png',
        perk_icon = 'mods/shutdown/files/item_gfx/perks/shutdown.png',
        stackable = STACKABLE_NO,
        usable_by_enemies = false,
        func = function(entity_perk_item, entity_who_picked, item_name)
            EntityLoad('mods/shutdown/files/entities/misc/warning_text.xml')

            GameAddFlagRun('shutdown_on_death')
            GameAddFlagRun('shutdown_reason_perk')
        end,
    })
