if getgenv().aimbot_loaded then return end

local services = {
    workspace = cloneref(game:GetService("Workspace")),
    runservice = cloneref(game:GetService("RunService")),
    userinputservice = cloneref(game:GetService("UserInputService")),
    players = cloneref(game:GetService("Players")),
}

local local_player = services.players.LocalPlayer
local current_camera = services.workspace.CurrentCamera

local settings = getgenv().aimbot_config.aimbot_settings

local aimbot_enabled = true
local aimed_at = nil

local fov_circle = Drawing.new("Circle")
fov_circle.Visible = true
fov_circle.Thickness = 2
fov_circle.Color = Color3.fromRGB(255, 255, 255)
fov_circle.Filled = false
fov_circle.Radius = settings.aimbot_fov
fov_circle.Position = current_camera.ViewportSize / 2

local check_whitelist = function(player)
    for _, name in ipairs(settings.whitelisted_player) do
        if player.Name == name then
            return true
        end
    end
    return false
end

local check_team = function(player)
    if not settings.team_check then return true end
    
    if player.Team == local_player.Team then
        return true
    end
    return false
end

local update_drawings = function()
    local camera_viewport = current_camera.ViewportSize
    fov_circle.Position = camera_viewport / 2
    fov_circle.Radius = settings.aimbot_fov
end

local look_at = function(target)
    local look_vector = (target - current_camera.CFrame.Position).unit
    local new_cframe = CFrame.new(current_camera.CFrame.Position, current_camera.CFrame.Position + look_vector)
    current_camera.CFrame = new_cframe
end

local is_visible = function(player)
    if not settings.wall_check then return true end
    
    local PlayerCharacter = player.Character
    local LocalPlayerCharacter = local_player.Character
    
    if not (PlayerCharacter and LocalPlayerCharacter) then return false end
    
    local PlayerRoot = PlayerCharacter:FindFirstChild(settings.aimbot_aimpart) or PlayerCharacter:FindFirstChild("HumanoidRootPart")
    if not PlayerRoot then return false end
    
    local CastPoints, IgnoreList = {PlayerRoot.Position}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringParts = current_camera:GetPartsObscuringTarget(CastPoints, IgnoreList)
    
    for _, part in ipairs(ObscuringParts) do
        if part.CanCollide and part.Transparency < 1 then
            return false
        end
    end
    
    return true
end

local get_closest = function()
    local nearest = nil
    local last = math.huge
    local player_mouse_position = current_camera.ViewportSize / 2
    
    for _, player in ipairs(services.players:GetPlayers()) do
        if aimed_at == nil then
            if not check_whitelist(player) and player ~= local_player and player.Character then
                local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    local ePos, isVisible = current_camera:WorldToViewportPoint(HumanoidRootPart.Position)
                    local distance = (Vector2.new(ePos.x, ePos.y) - player_mouse_position).Magnitude
                    
                    if isVisible and 
                    distance < settings.aimbot_fov and 
                    (HumanoidRootPart.Position - local_player.Character.HumanoidRootPart.Position).Magnitude < settings.aimbot_distance and 
                    is_visible(player) and 
                    HumanoidRootPart.Material ~= Enum.Material.ForceField and 
                    check_team(player) and 
                    player.Character:FindFirstChild("Humanoid").Health > 0 then
                        if distance < last then
                            last = distance
                            nearest = player
                            if settings.sticky then
                                aimed_at = player
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

local aiming = false

services.userinputservice.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == settings.aimbot_key and not gameProcessed and aimbot_enabled then
        aiming = true
    end
end)

services.userinputservice.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == settings.aimbot_key and not gameProcessed then
        aiming = false
    end
end)

services.runservice.RenderStepped:Connect(function()
    update_drawings()
    if aiming then
        if aimed_at.Character.Humanoid.Health < 1 then aimed_at = nil end
        local closest
        if settings.sticky then
            if aimed_at and aimed_at.Character:FindFirstChild(settings.aimbot_aimpart) then
                look_at(aimed_at.Character:FindFirstChild(settings.aimbot_aimpart).Position)
            end
        else
            closest = get_closest()
            if closest and closest.Character:FindFirstChild(settings.aimbot_aimpart) then
                look_at(closest.Character:FindFirstChild(settings.aimbot_aimpart).Position)
            end
        end
    end
end)

getgenv().aimbot_loaded = true
