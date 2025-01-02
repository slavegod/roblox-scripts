
--[[
    reworked aimbot by krigsprofitör (1afbb8d916894a4ca5af2ac53615f576)
    created for https://discord.gg/ZTkMV9yD
]]

-- silence unknown constants for vsc
local getgenv

getgenv().aimbot_config = {
    aimbot_settings = {
        
    },
}

-- improve functionality?
loadstring(game:HttpGet("https://raw.githubusercontent.com/slavegod/roblox-scripts/refs/heads/main/src/aimbot-rework.lua"))()
