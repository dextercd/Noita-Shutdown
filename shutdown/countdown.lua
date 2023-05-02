local entity = GetUpdatedEntityID()
local sprite = EntityGetFirstComponent(entity, "SpriteComponent")

local num = tonumber(ComponentGetValue2(sprite, "text")) or 0
if num > 0 then
    ComponentSetValue2(sprite, "text", tostring(num - 1))
    EntityRefreshSprite(entity, sprite)
end
