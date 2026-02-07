--[[
@Name: Visuals
@Author: FoarteBine
@Version: v3.1
]]

local Module = {}

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    Enabled = false,
    MaxDist = 2000,
    NoFog = false,
    FullBright = false,
    Box = false,
    HealthBar = false,
    Name = false,
    Distance = false,
    Tracer = false,
    StateIcons = false,
    PartEspEnabled = false,
    PartList = {},
    HitboxEnabled = false,
    HitboxSize = 2,
    HitboxShow = false
}

local Cache = {}
local PartCache = {}
local OriginalLighting = {
    FogEnd = Lighting.FogEnd,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    GlobalShadows = Lighting.GlobalShadows
}

local Icons = {
    Walking = "rbxassetid://117030571122427",
    Idle    = "rbxassetid://114666164258248",
    Jump    = "rbxassetid://132943442694668",
    Swim    = "rbxassetid://123260751807425",
    Dead    = "rbxassetid://104191266659021"
}

local function Draw(type, props)
    local obj = Drawing.new(type)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function GetStateIcon(hum)
    if not hum or hum.Health <= 0 then return Icons.Dead end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then return Icons.Jump end
    if state == Enum.HumanoidStateType.Swimming then return Icons.Swim end
    if hum.MoveDirection.Magnitude > 0.1 then return Icons.Walking end
    return Icons.Idle
end

local function CreateESP(plr)
    if Cache[plr] then return end
    
    local gui = Instance.new("BillboardGui")
    gui.Name = "StateIcon_" .. plr.Name
    gui.Size = UDim2.new(0, 35, 0, 35)
    gui.AlwaysOnTop = true
    gui.ExtentsOffset = Vector3.new(0, 3, 0)
    gui.Enabled = false
    gui.Parent = CoreGui
    
    local img = Instance.new("ImageLabel")
    img.Parent = gui
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(1, 0, 1, 0)
    img.Image = Icons.Idle

    Cache[plr] = {
        Box = Draw("Square", {Thickness = 1, Filled = false, Transparency = 1, Color = Color3.new(1,1,1), Visible = false}),
        HealthOutline = Draw("Square", {Thickness = 1, Filled = true, Color = Color3.new(0,0,0), Transparency = 1, Visible = false}),
        HealthBar = Draw("Square", {Thickness = 1, Filled = true, Transparency = 1, Visible = false}),
        Name = Draw("Text", {Size = 13, Center = true, Outline = true, Color = Color3.new(1,1,1), Visible = false}),
        Distance = Draw("Text", {Size = 11, Center = true, Outline = true, Color = Color3.new(1,1,1), Visible = false}),
        Tracer = Draw("Line", {Thickness = 1, Color = Color3.new(1,1,1), Transparency = 1, Visible = false}),
        IconGui = gui,
        IconImg = img
    }
end

local function CreatePartESP(obj)
    if PartCache[obj] then return end
    PartCache[obj] = {
        Box = Draw("Square", {Thickness = 1, Color = Color3.new(1,1,0), Visible = false}),
        Text = Draw("Text", {Size = 12, Center = true, Outline = true, Color = Color3.new(1,1,1), Visible = false})
    }
end

local function Update()
    for plr, esp in pairs(Cache) do
        local char = plr.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        local hum = char and char:FindFirstChild("Humanoid")
        local head = char and char:FindFirstChild("Head")

        if Settings.Enabled and char and root and hum and hum.Health > 0 and plr ~= LocalPlayer then
            local pos, vis = Camera:WorldToViewportPoint(root.Position)
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0

            if vis and dist <= Settings.MaxDist then
                local size = Vector2.new(2000 / pos.Z, 2500 / pos.Z)
                local top = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)

                esp.Box.Visible = Settings.Box
                if Settings.Box then
                    esp.Box.Size = size
                    esp.Box.Position = top
                end

                if Settings.HealthBar then
                    local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    esp.HealthOutline.Visible = true
                    esp.HealthOutline.Size = Vector2.new(4, size.Y)
                    esp.HealthOutline.Position = Vector2.new(top.X - 6, top.Y)
                    esp.HealthBar.Visible = true
                    esp.HealthBar.Size = Vector2.new(2, size.Y * hp)
                    esp.HealthBar.Position = Vector2.new(top.X - 5, top.Y + (size.Y * (1 - hp)))
                    esp.HealthBar.Color = Color3.fromHSV(hp * 0.3, 1, 1)
                else
                    esp.HealthOutline.Visible = false
                    esp.HealthBar.Visible = false
                end

                esp.Name.Visible = Settings.Name
                if Settings.Name then
                    esp.Name.Text = plr.Name
                    esp.Name.Position = Vector2.new(pos.X, top.Y - 15)
                end

                esp.Distance.Visible = Settings.Distance
                if Settings.Distance then
                    esp.Distance.Text = math.floor(dist) .. "m"
                    esp.Distance.Position = Vector2.new(pos.X, top.Y + size.Y + 2)
                end

                esp.Tracer.Visible = Settings.Tracer
                if Settings.Tracer then
                    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.Tracer.To = Vector2.new(pos.X, pos.Y + (size.Y / 2))
                end

                if Settings.StateIcons and head then
                    esp.IconGui.Enabled = true
                    esp.IconGui.Adornee = head
                    esp.IconImg.Image = GetStateIcon(hum)
                else
                    esp.IconGui.Enabled = false
                end

                if Settings.HitboxEnabled then
                    root.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    root.Transparency = Settings.HitboxShow and 0.7 or 1
                    root.CanCollide = false
                end
            else
                esp.Box.Visible = false; esp.HealthBar.Visible = false; esp.HealthOutline.Visible = false
                esp.Name.Visible = false; esp.Distance.Visible = false; esp.Tracer.Visible = false; esp.IconGui.Enabled = false
            end
        else
            esp.Box.Visible = false; esp.HealthBar.Visible = false; esp.HealthOutline.Visible = false
            esp.Name.Visible = false; esp.Distance.Visible = false; esp.Tracer.Visible = false; esp.IconGui.Enabled = false
        end
    end

    if Settings.PartEspEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and table.find(Settings.PartList, obj.Name) then
                CreatePartESP(obj)
                local data = PartCache[obj]
                local pPos, pVis = Camera:WorldToViewportPoint(obj.Position)
                if pVis then
                    data.Box.Visible = true
                    data.Box.Size = Vector2.new(1000/pPos.Z, 1000/pPos.Z)
                    data.Box.Position = Vector2.new(pPos.X - data.Box.Size.X/2, pPos.Y - data.Box.Size.Y/2)
                    data.Text.Visible = true
                    data.Text.Text = obj.Name
                    data.Text.Position = Vector2.new(pPos.X, pPos.Y + (data.Box.Size.Y/2) + 2)
                else
                    data.Box.Visible = false; data.Text.Visible = false
                end
            end
        end
    else
        for _, d in pairs(PartCache) do d.Box.Visible = false; d.Text.Visible = false end
    end
end

local function RemoveESP(plr)
    if Cache[plr] then
        for _, v in pairs(Cache[plr]) do
            if typeof(v) == "userdata" then v:Remove() elseif typeof(v) == "Instance" then v:Destroy() end
        end
        Cache[plr] = nil
    end
end

function Module:Init(api)
    local Basic = api:Section("1. Basic Visuals")
    Basic:Toggle("No Fog", false, function(v)
        Settings.NoFog = v
        Lighting.FogEnd = v and 100000 or OriginalLighting.FogEnd
    end)
    Basic:Toggle("Fullbright", false, function(v)
        Settings.FullBright = v
        if v then
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1,1,1)
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        end
    end)

    local PlayerSec = api:Section("2. Player ESP")
    PlayerSec:Toggle("Enable ESP", false, function(v) Settings.Enabled = v end)
    PlayerSec:Toggle("Boxes", false, function(v) Settings.Box = v end)
    PlayerSec:Toggle("Health Bar", false, function(v) Settings.HealthBar = v end)
    PlayerSec:Toggle("Names", false, function(v) Settings.Name = v end)
    PlayerSec:Toggle("Distance", false, function(v) Settings.Distance = v end)
    PlayerSec:Toggle("Tracers", false, function(v) Settings.Tracer = v end)
    PlayerSec:Toggle("State Icons", false, function(v) Settings.StateIcons = v end)

    local PartSec = api:Section("3. Part ESP")
    local CurrentInput = ""
    PartSec:Input("Part Name", "Name...", function(t) CurrentInput = t end)
    PartSec:Button("Add Part", function() if CurrentInput ~= "" then table.insert(Settings.PartList, CurrentInput) end end)
    PartSec:Button("Clear Parts", function() 
        for _, d in pairs(PartCache) do d.Box:Remove() d.Text:Remove() end
        PartCache = {}
        Settings.PartList = {} 
    end)
    PartSec:Toggle("Enable Part ESP", false, function(v) Settings.PartEspEnabled = v end)

    local HitboxSec = api:Section("4. Hitbox Expander")
    HitboxSec:Toggle("Enable Hitbox", false, function(v)
        Settings.HitboxEnabled = v
        if not v then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
                    p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end)
    HitboxSec:Slider("Size", 2, 20, 2, function(v) Settings.HitboxSize = v end)
    HitboxSec:Toggle("Visualise", false, function(v) Settings.HitboxShow = v end)

    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
    Players.PlayerAdded:Connect(CreateESP)
    Players.PlayerRemoving:Connect(RemoveESP)
    RunService.RenderStepped:Connect(Update)
end

return Module
