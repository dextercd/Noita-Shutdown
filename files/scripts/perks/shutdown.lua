dofile('data/scripts/lib/coroutines.lua')

local entity_id = GetUpdatedEntityID()
local damage_model = EntityGetFirstComponentIncludingDisabled(
        entity_id, 'DamageModelComponent')

function is_dead()
    local hp = ComponentGetValue2(damage_model, 'hp')
    return hp <= 0
end

function shutdown_sequence()
    local bsod = EntityLoad('mods/shutdown/files/entities/misc/bsod.xml')

    local dummy_gui = GuiCreate()
    local screenx, screeny = GuiGetScreenDimensions(dummy_gui)

    scale = screeny / 1080

    EntitySetTransform(bsod, 0, 0, nil, scale, scale)
    EntityApplyTransform(bsod, 0, 0, nil, scale, scale)
end

async(function()
    while not is_dead() do
        wait(1)
    end

    shutdown_sequence()
end)
