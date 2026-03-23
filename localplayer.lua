--[[
@Name: LocalPlayer
@Author: FoarteBine
@Version: v1.0
]]

local Module = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    NoClip = false,
    Fly = false,
    FlySpeed = 50,
    FOV = 70
}

function Module:Init(api)
    local Main = api:Section("MOVEMENT")

    Main:Slider("WalkSpeed", 16, 250, 16, function(v)
        Settings.WalkSpeed = v
    end)

    Main:Slider("JumpPower", 50, 500, 50, function(v)
        Settings.JumpPower = v
    end)

    Main:Toggle("Infinite Jump", false, function(v)
        Settings.InfJump = v
    end)

    Main:Toggle("NoClip", false, function(v)
        Settings.NoClip = v
    end)

    local Flight = api:Section("FLIGHT")

    Flight:Toggle("Fly", false, function(v)
        Settings.Fly = v
    end)

    Flight:Slider("Fly Speed", 10, 300, 50, function(v)
        Settings.FlySpeed = v
    end)

    local Visuals = api:Section("VIEW")

    Visuals:Slider("Field of View", 70, 120, 70, function(v)
        Settings.FOV = v
        Camera.FieldOfView = v
    end)

    UserInputService.JumpRequest:Connect(function()
        if Settings.InfJump and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if hum then
                hum.WalkSpeed = Settings.WalkSpeed
                hum.JumpPower = Settings.JumpPower
            end

            if Settings.NoClip then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            if Settings.Fly and root then
                local moveDir = hum.MoveDirection
                local flyVec = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyVec = flyVec + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    flyVec = flyVec + Vector3.new(0, -1, 0)
                end
                
                root.Velocity = (moveDir * Settings.FlySpeed) + (flyVec * Settings.FlySpeed)
                if moveDir.Magnitude == 0 and flyVec.Magnitude == 0 then
                    root.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end

return Module