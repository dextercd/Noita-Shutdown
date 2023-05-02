-- Mod changed in some way? Early exit to avoid breaking things
if
    not ArenaGameplay or
    not ArenaGameplay.KillCheck
then
    return
end

local last_death_round_nr = nil
local death_streak = 0

local real_KillCheck = ArenaGameplay.KillCheck
ArenaGameplay.KillCheck = function(...)
    local died = GameHasFlagRun("player_died")

    local ret = {real_KillCheck(...)}

    pcall(function()
        if died then
            local round_nr = tonumber(GlobalsGetValue("holyMountainCount", "0")) or 0
            if last_death_round_nr == nil or last_death_round_nr + 1 < round_nr then
                death_streak = 0
            end

            last_death_round_nr = round_nr
            death_streak = death_streak + 1

            local deaths_target = math.floor(ModSettingGet("shutdown.arena_death_streak")) 
            local deaths_left = deaths_target - death_streak

            GlobalsSetValue("shutdown_deaths_left", deaths_left)
            if deaths_left <= 0 then
                GameAddFlagRun('shutdown_do_async')
            end

            local countdown_indirect = EntityLoad("mods/shutdown/countdown_indirect.xml", 0, 0)
        end
    end)

    return unpack(ret)
end
