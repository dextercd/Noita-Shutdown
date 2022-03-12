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

            local damage_model = EntityGetFirstComponentIncludingDisabled(
                    entity_who_picked, 'DamageModelComponent')

            -- Delay OnPlayerDied until the kill_now flag is set by bsod.lua
            ComponentSetValue2(damage_model, 'wait_for_kill_flag_on_death', true)

            EntityAddComponent2(entity_who_picked, 'LuaComponent', {
                script_source_file = "mods/shutdown/files/scripts/perks/shutdown.lua",
                enable_coroutines = true,
                execute_every_n_frame = -1,
                execute_on_added = true,
                execute_times = 1,
            })
        end,
    })
