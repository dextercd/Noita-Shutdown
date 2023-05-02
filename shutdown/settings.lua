dofile('data/scripts/lib/mod_settings.lua')

local mod_id = 'shutdown'
mod_settings_version = 1
mod_settings =
{
    {
        category_id = 'shutdown.normal_game',
        ui_name = 'Normal Runs',
        ui_description = 'Changes to these settings only take effect in new games.',

        settings = {
            {
                id = 'shutdown_perk',
                ui_name = 'Shutdown perk',
                ui_description =
                    'Add a perk for the shutdown effect or enable it immediately?',
                value_default = 'no_perk',
                values = {{'no_perk', 'Enable by default'}, {'perk', 'Require perk'}},
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            }
        }
    },
    {
        category_id = 'shutdown.noita_arena',
        ui_name = 'Noita Arena Integration',
        ui_description = 'How the Shutdown mod works in the Noita Arena',

        settings = {
            {
                id = 'arena_death_streak',
                ui_name = 'Death streak',
                ui_description = 'Deaths in a row until shutdown',
                value_default = 3,
                value_min = 1,
                value_max = 5,
                scope = MOD_SETTING_SCOPE_RUNTIME,
            }
        }
    }
}

function ModSettingsUpdate(init_scope)
    mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
    mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end
