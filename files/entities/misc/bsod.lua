dofile("data/scripts/lib/coroutines.lua")

local entity_id = GetUpdatedEntityID()
local children = EntityGetAllChildren(entity_id)
local completed = children[2]
local qr_code = children[3]
local stop_code = children[4]

local completed_sprite = EntityGetFirstComponentIncludingDisabled(
        completed, 'SpriteComponent')

local qr_code_sprite = EntityGetFirstComponentIncludingDisabled(
        qr_code, 'SpriteComponent')

local stop_code_sprite = EntityGetFirstComponentIncludingDisabled(
        stop_code, 'SpriteComponent')

local player_id = EntityGetWithTag( "player_unit" )[1]
local damage_model = EntityGetFirstComponentIncludingDisabled(
        player_id, 'DamageModelComponent')

function animate_completed()
    local wait_times = {20, 14, 17, 60, 50, 30, 22, 15, 33, 60, 20, 70, 130}
    for index, wait_time in ipairs(wait_times) do
        local animation_name = tostring(index - 1)
        ComponentSetValue2(completed_sprite, 'rect_animation', animation_name)
        wait(wait_time)
    end
end

function random_animation(sprite_component, max_anim_number)
    ComponentSetValue2(
        sprite_component,
        'rect_animation',
        tostring(Random(max_anim_number - 1))
    )
end

random_animation(stop_code_sprite, 7)
random_animation(qr_code_sprite, 9)

async(function()
    animate_completed()
    ComponentSetValue2(damage_model, 'kill_now', true)
end)
