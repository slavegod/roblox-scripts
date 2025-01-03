--[[
    reworked aimbot by krigsprofitör (1afbb8d916894a4ca5af2ac53615f576)
    created for https://discord.gg/ZTkMV9yD
]]

-- silence unknown constants for vsc
--local getgenv, cloneref, Drawing

getgenv().aimbot_config = {
    aimbot_settings = {
        aimbot_toggle_key = Enum.KeyCode.O, -- toggles the aimbot on / off (includes FOV); find keycodes at https://create.roblox.com/docs/reference/engine/enums/KeyCode
        aimbot_key = Enum.UserInputType.MouseButton2, -- use the aimbot with this key
        aimbot_fov = 130,

        aimbot_aimpart = "Head", -- snaps to this head
        aimbot_distance = 125, -- won't target past this distance

        team_check = true, -- won't target people on your team
        dead_check = true, -- won't target dead people
        wall_check = true, -- doesn't act like it can wallbang people
        whitelisted_player = {}, -- whitelisted players, case sensitive
        whitelist_friends = true, -- whitelists your friends
        invisible_check = true, -- anti admin junk

        sticky = true, -- toggles if the aimbot will stay on a singular target and won't go off if anyone passes the field
        follow = true, -- I made this exclusively for hvhing, or in situations where someone is going fast as shit around you and you can't keep up

        highlight = true, -- shows who you are currently targetting
        notifications = true, -- shows status of various stuff
    },
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/slavegod/roblox-scripts/refs/heads/main/src/aimbot-rework.lua"))()
