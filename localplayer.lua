--[[
@Name: LocalPlayer
@Author: FoarteBine
@Version: v1.1
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

local BV, BG = nil, nil

local function StopFlying()
    if BV then BV:Destroy() BV = nil end
    if BG then BG:Destroy() BG = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

function Module:Init(api)
    local Main = api:Section("MOVEMENT")

    Main:Slider("WalkSpeed", 16, 250, 16, function(v) Settings.WalkSpeed = v end)
    Main:Slider("JumpPower", 50, 500, 50, function(v) Settings.JumpPower = v end)
    
    Main:Toggle("Infinite Jump", false, function(v) 
        Settings.InfJump = v 
    end)

    Main:Toggle("NoClip", false, function(v) 
        Settings.NoClip = v 
    end)

    local Flight = api:Section("FLIGHT")

    Flight:Toggle("Fly", false, function(v)
        Settings.Fly = v
        if not v then StopFlying() end
    end)

    Flight:Slider("Fly Speed", 10, 500, 50, function(v)
        Settings.FlySpeed = v
    end)

    local Visuals = api:Section("VIEW")

    Visuals:Slider("Field of View", 70, 120, 70, function(v)
        Settings.FOV = v
        Camera.FieldOfView = v
    end)

    RunService.RenderStepped:Connect(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local root = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if Settings.Fly then
            if not BV then
                BV = Instance.new("BodyVelocity", root)
                BV.MaxForce = Vector3.new(1, 1, 1) * 10^6
                
                BG = Instance.new("BodyGyro", root)
                BG.MaxTorque = Vector3.new(1, 1, 1) * 10^6
                BG.P = 10^4
                
                if hum then hum.PlatformStand = true end
            end
            
            BG.CFrame = Camera.CFrame
            
            local direction = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end

            BV.Velocity = direction * Settings.FlySpeed
        else
            if BV then StopFlying() end
        end

        if hum then
            hum.WalkSpeed = Settings.WalkSpeed
            hum.JumpPower = Settings.JumpPower
        end

        if Settings.NoClip then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if Settings.InfJump and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

return Module
