dofile('data/scripts/lib/mod_settings.lua')

local mod_id = 'shutdown'
mod_settings_version = 1
mod_settings =
{
    {
        category_id = 'require_new_game',
        ui_name = 'New Game settings',
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
