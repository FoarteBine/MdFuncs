local Module = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MdNotifications"
ScreenGui.Parent = CoreGui
ScreenGui.DisplayOrder = 999

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = ScreenGui
Container.Size = UDim2.new(0, 300, 1, -20)
Container.Position = UDim2.new(1, -310, 0, 10)
Container.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout")
Layout.Parent = Container
Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 8)

local Types = {
    Info = {Color = Color3.fromRGB(0, 170, 255), Icon = "rbxassetid://6031275941"},
    Success = {Color = Color3.fromRGB(85, 255, 127), Icon = "rbxassetid://6031068433"},
    Error = {Color = Color3.fromRGB(255, 85, 85), Icon = "rbxassetid://6031091007"},
    Warning = {Color = Color3.fromRGB(255, 170, 0), Icon = "rbxassetid://6023454774"}
}

function Module:Spawn(data)
    itle = data.Title or "SYSTEM"
    local text = data.Text or ""
    local duration = data.Duration or 5
    local nType = data.Type or "Info"
    local theme = Types[nType] or Types.Info

    local Frame = Instance.new("Frame")
    Frame.Parent = Container
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 0, 60)
    Frame.ClipsDescendants = true
    Frame.Transparency = 1

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 4)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = theme.Color
    Stroke.Thickness = 1
    Stroke.Transparency = 0.5

    local TitleLabel = Instance.new("TextLabel", Frame)
    TitleLabel.Text = title:upper()
    TitleLabel.Size = UDim2.new(1, -40, 0, 20)
    TitleLabel.Position = UDim2.new(0, 35, 0, 6)
    TitleLabel.TextColor3 = theme.Color
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1

    local DescLabel = Instance.new("TextLabel", Frame)
    DescLabel.Text = text
    DescLabel.Size = UDim2.new(1, -45, 0, 30)
    DescLabel.Position = UDim2.new(0, 35, 0, 24)
    DescLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.BackgroundTransparency = 1

    local Icon = Instance.new("ImageLabel", Frame)
    Icon.Image = theme.Icon
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0, 10, 0, 7)
    Icon.ImageColor3 = theme.Color
    Icon.BackgroundTransparency = 1

    local TimerBar = Instance.new("Frame", Frame)
    TimerBar.Size = UDim2.new(1, 0, 0, 2)
    TimerBar.Position = UDim2.new(0, 0, 1, -2)
    TimerBar.BackgroundColor3 = theme.Color
    TimerBar.BorderSizePixel = 0

    TweenService:Create(Frame, TweenInfo.new(0.4), {Transparency = 0}):Play()
    
    task.spawn(function()
        local t = TweenService:Create(TimerBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)})
        t:Play()
        task.wait(duration)
        local h = TweenService:Create(Frame, TweenInfo.new(0.4), {Position = UDim2.new(1.5, 0, 0, 0)})
        h:Play()
        h.Completed:Connect(function() Frame:Destroy() end)
    end)
end

function Module:Init(api)
    local s = api:Section("NOTIFY TEST")
    s:Button("Show Info", function()
        self:Spawn({Title = "Info", Text = "Information message", Type = "Info"})
    end)
    s:Button("Show Success", function()
        self:Spawn({Title = "Success", Text = "Operation completed", Type = "Success"})
    end)
    s:Button("Show Error", function()
        self:Spawn({Title = "Error", Text = "Something went wrong", Type = "Error"})
    end)
end

return Module
