local entity = GetUpdatedEntityID()

local deaths_left = tonumber(GlobalsGetValue("shutdown_deaths_left"))

local ui_countdown = EntityLoad("mods/shutdown/countdown.xml", 0, 0)
local sprite = EntityGetFirstComponent(ui_countdown, "SpriteComponent")

local start_value = 0
if deaths_left > 0 then
    start_value = deaths_left + 1
end

ComponentSetValue2(sprite, "text", tostring(start_value))
EntityRefreshSprite(entity, sprite)
