local MdFuncs = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Theme = {
    Accent = Color3.fromRGB(0, 255, 170),
    Main = Color3.fromRGB(15, 15, 20),
    Stroke = Color3.fromRGB(0, 255, 170),
    TextActive = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 160),
    Element = Color3.fromRGB(25, 25, 30),
    Section = Color3.fromRGB(20, 20, 25)
}
local TI = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TI_Elastic = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
function MdFuncs:Init()
    if CoreGui:FindFirstChild("MdFuncs_Cyber_V2") then CoreGui.MdFuncs_Cyber_V2:Destroy() end
    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "MdFuncs_Cyber_V2"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 580, 0, 46)
    Main.Position = UDim2.new(0.5, -290, 0, 10)
    Main.BackgroundColor3 = Theme.Main
    Main.BackgroundTransparency = 0.05
    Main.ClipsDescendants = false
    local MC = Instance.new("UICorner", Main); MC.CornerRadius = UDim.new(0, 8)
    local MS = Instance.new("UIStroke", Main); MS.Color = Theme.Accent; MS.Transparency = 0.5; MS.Thickness = 1.5
    local Shadow = Instance.new("ImageLabel", Main)
    Shadow.Size = UDim2.new(1, 140, 1, 140)
    Shadow.Position = UDim2.new(0, -70, 0, -70)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897814"
    Shadow.ImageColor3 = Theme.Accent
    Shadow.ImageTransparency = 0.75
    Shadow.ZIndex = -1
    local Logo = Instance.new("TextLabel", Main)
    Logo.Size = UDim2.new(0, 120, 1, 0); Logo.Position = UDim2.new(1, -130, 0, 0)
    Logo.Text = "MdFuncs"; Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 18
    Logo.TextColor3 = Theme.Accent; Logo.BackgroundTransparency = 1; Logo.TextXAlignment = Enum.TextXAlignment.Right
    local TabsHolder = Instance.new("Frame", Main)
    TabsHolder.Size = UDim2.new(1, -140, 1, 0); TabsHolder.Position = UDim2.new(0, 15, 0, 0)
    TabsHolder.BackgroundTransparency = 1
    local TabsLayout = Instance.new("UIListLayout", TabsHolder)
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal; TabsLayout.Padding = UDim.new(0, 15)
    TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    local Pages = {}
    local CurrentPage = nil
    local CurrentTabBtn = nil
    local ResizeConnection = nil
    local function UpdatePageSize()
        if CurrentPage and CurrentTabBtn then
            local contentHeight = CurrentPage.UIListLayout.AbsoluteContentSize.Y + 25
            local absoluteY = Main.AbsolutePosition.Y + Main.AbsoluteSize.Y + 10
            local availableHeight = sg.AbsoluteSize.Y - absoluteY - 20
            local finalHeight = math.min(contentHeight, availableHeight)
            TS:Create(CurrentPage, TI, {
                Size = UDim2.new(0, 240, 0, finalHeight),
                Position = UDim2.new(0, CurrentTabBtn.AbsolutePosition.X - Main.AbsolutePosition.X, 0, 56)
            }):Play()
        end
    end
    sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdatePageSize)
    RunService.RenderStepped:Connect(function()
        if CurrentPage and CurrentPage.Visible then
             local targetX = CurrentTabBtn.AbsolutePosition.X - Main.AbsolutePosition.X
             if math.abs(CurrentPage.Position.X.Offset - targetX) > 1 then
                 CurrentPage.Position = UDim2.new(0, targetX, 0, 56)
             end
        end
    end)
    function Pages:Category(name)
        local TabBtn = Instance.new("TextButton", TabsHolder)
        TabBtn.Size = UDim2.new(0, 0, 1, 0); TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name:upper()
        TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 12
        TabBtn.TextColor3 = Theme.TextDim
        local Line = Instance.new("Frame", TabBtn)
        Line.Size = UDim2.new(0, 0, 0, 2); Line.Position = UDim2.new(0.5, 0, 1, 0)
        Line.BackgroundColor3 = Theme.Accent; Line.BorderSizePixel = 0
        Line.AnchorPoint = Vector2.new(0.5, 0)
        local Page = Instance.new("ScrollingFrame", Main)
        Page.Size = UDim2.new(0, 240, 0, 0); Page.Visible = false
        Page.BackgroundColor3 = Theme.Main; Page.BackgroundTransparency = 0.05
        Page.BorderSizePixel = 0; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ClipsDescendants = true
        Page.ZIndex = 5
        Instance.new("UICorner", Page).CornerRadius = UDim.new(0, 8)
        local PS = Instance.new("UIStroke", Page); PS.Color = Theme.Accent; PS.Transparency = 0.7
        local PL = Instance.new("UIListLayout", Page)
        PL.Name = "UIListLayout"
        PL.Padding = UDim.new(0, 8); PL.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PL.SortOrder = Enum.SortOrder.LayoutOrder
        Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 10); Instance.new("UIPadding", Page).PaddingBottom = UDim.new(0, 10)
        PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if CurrentPage == Page then UpdatePageSize() end
        end)
        TabBtn.MouseButton1Click:Connect(function()
            if CurrentPage == Page then
                TS:Create(Page, TI, {Size = UDim2.new(0, 240, 0, 0)}):Play()
                TS:Create(TabBtn, TI, {TextColor3 = Theme.TextDim}):Play()
                TS:Create(Line, TI, {Size = UDim2.new(0, 0, 0, 2)}):Play()
                task.delay(0.3, function() Page.Visible = false end)
                CurrentPage = nil; CurrentTabBtn = nil
            else
                if CurrentPage then
                    CurrentPage.Visible = false
                    TS:Create(CurrentTabBtn, TI, {TextColor3 = Theme.TextDim}):Play()
                    TS:Create(CurrentTabBtn:FindFirstChild("Frame"), TI, {Size = UDim2.new(0, 0, 0, 2)}):Play()
                end
                Page.Visible = true; CurrentPage = Page; CurrentTabBtn = TabBtn
                UpdatePageSize()
                TS:Create(TabBtn, TI, {TextColor3 = Theme.TextActive}):Play()
                TS:Create(Line, TI, {Size = UDim2.new(1, 4, 0, 2)}):Play()
            end
        end)
        TabBtn.MouseEnter:Connect(function()
            if CurrentTabBtn ~= TabBtn then TS:Create(TabBtn, TI, {TextColor3 = Color3.new(1,1,1)}):Play() end
        end)
        TabBtn.MouseLeave:Connect(function()
            if CurrentTabBtn ~= TabBtn then TS:Create(TabBtn, TI, {TextColor3 = Theme.TextDim}):Play() end
        end)
        local Container = {}
        local function CreateElementButton(parent, text, cb)
             local Btn = Instance.new("TextButton", parent)
            Btn.Size = UDim2.new(0.92, 0, 0, 32); Btn.BackgroundColor3 = Theme.Element
            Btn.Text = text; Btn.TextColor3 = Theme.TextActive; Btn.Font = Enum.Font.GothamMedium; Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            local BS = Instance.new("UIStroke", Btn); BS.Color = Theme.Accent; BS.Transparency = 0.9
            Btn.MouseEnter:Connect(function() TS:Create(BS, TI, {Transparency = 0.4}):Play() end)
            Btn.MouseLeave:Connect(function() TS:Create(BS, TI, {Transparency = 0.9}):Play() end)
            Btn.MouseButton1Down:Connect(function() TS:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(0.88, 0, 0, 30)}):Play() end)
            Btn.MouseButton1Up:Connect(function()
                TS:Create(Btn, TI_Elastic, {Size = UDim2.new(0.92, 0, 0, 32)}):Play()
                cb()
            end)
            return Btn
        end
        local function CreateElementToggle(parent, text, default, cb)
            local toggled = default or false
            local Btn = Instance.new("TextButton", parent)
            Btn.Size = UDim2.new(0.92, 0, 0, 32); Btn.BackgroundColor3 = Theme.Element
            Btn.Text = "  " .. text; Btn.TextColor3 = Theme.TextDim; Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Font = Enum.Font.GothamMedium; Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            local Check = Instance.new("Frame", Btn)
            Check.Size = UDim2.new(0, 18, 0, 18); Check.Position = UDim2.new(1, -28, 0.5, -9)
            Check.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 4)
            local CheckStroke = Instance.new("UIStroke", Check); CheckStroke.Color = Theme.TextDim; CheckStroke.Transparency = 0.8
            local Inner = Instance.new("Frame", Check)
            Inner.Size = UDim2.new(1, -4, 1, -4); Inner.Position = UDim2.new(0, 2, 0, 2)
            Inner.BackgroundColor3 = Theme.Accent; Inner.BackgroundTransparency = toggled and 0 or 1
            Instance.new("UICorner", Inner).CornerRadius = UDim.new(0, 2)
            local function Update()
                local txtCol = toggled and Theme.TextActive or Theme.TextDim
                TS:Create(Btn, TI, {TextColor3 = txtCol}):Play()
                TS:Create(Inner, TI, {BackgroundTransparency = toggled and 0 or 1}):Play()
                TS:Create(CheckStroke, TI, {Color = toggled and Theme.Accent or Theme.TextDim, Transparency = toggled and 0 or 0.8}):Play()
                if cb then cb(toggled) end
            end
            Update()
            Btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                Update()
            end)
        end
        local function CreateElementSlider(parent, text, min, max, default, cb)
            local Slider = Instance.new("Frame", parent)
            Slider.Size = UDim2.new(0.92, 0, 0, 42); Slider.BackgroundColor3 = Theme.Element
            Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 6)
            local Title = Instance.new("TextLabel", Slider)
            Title.Size = UDim2.new(1, -10, 0, 20); Title.Position = UDim2.new(0, 10, 0, 2)
            Title.Text = text; Title.TextColor3 = Theme.TextDim; Title.Font = Enum.Font.GothamBold; Title.TextSize = 11
            Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left
            local ValueText = Instance.new("TextLabel", Slider)
            ValueText.Size = UDim2.new(0, 40, 0, 20); ValueText.Position = UDim2.new(1, -45, 0, 2)
            ValueText.Text = tostring(default); ValueText.TextColor3 = Theme.Accent; ValueText.Font = Enum.Font.Code; ValueText.TextSize = 11
            ValueText.BackgroundTransparency = 1
            local Bar = Instance.new("Frame", Slider)
            Bar.Size = UDim2.new(0.9, 0, 0, 4); Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Instance.new("UICorner", Bar)
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", Fill)
            local Knob = Instance.new("Frame", Fill)
            Knob.Size = UDim2.new(0, 10, 0, 10); Knob.Position = UDim2.new(1, -5, 0.5, -5)
            Knob.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            local dragging = false
            Slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local con; con = RunService.RenderStepped:Connect(function()
                        if not dragging then con:Disconnect() return end
                        local mousePos = UIS:GetMouseLocation().X
                        local relativePos = math.clamp((mousePos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local val = math.floor(min + (max - min) * relativePos)
                        ValueText.Text = tostring(val)
                        Fill.Size = UDim2.new(relativePos, 0, 1, 0)
                        cb(val)
                        if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then dragging = false end
                    end)
                end
            end)
        end
        local function CreateElementInput(parent, text, placeholder, cb)
             local IF = Instance.new("Frame", parent)
            IF.Size = UDim2.new(0.92, 0, 0, 36); IF.BackgroundColor3 = Theme.Element
            Instance.new("UICorner", IF).CornerRadius = UDim.new(0, 6)
            local Box = Instance.new("TextBox", IF)
            Box.Size = UDim2.new(1, -20, 1, 0); Box.Position = UDim2.new(0, 10, 0, 0)
            Box.BackgroundTransparency = 1; Box.Text = ""; Box.PlaceholderText = placeholder or text
            Box.TextColor3 = Theme.TextActive; Box.Font = Enum.Font.Gotham; Box.TextSize = 12
            Box.PlaceholderColor3 = Theme.TextDim
            local Stroke = Instance.new("UIStroke", IF); Stroke.Color = Theme.Accent; Stroke.Transparency = 1; Stroke.Thickness = 1
            Box.Focused:Connect(function() TS:Create(Stroke, TI, {Transparency = 0.4}):Play() end)
            Box.FocusLost:Connect(function()
                TS:Create(Stroke, TI, {Transparency = 1}):Play()
                cb(Box.Text)
            end)
        end
        function Container:Section(name)
            local SectionMethods = {}
            local SecBtn = Instance.new("TextButton", Page)
            SecBtn.Size = UDim2.new(0.95, 0, 0, 28)
            SecBtn.BackgroundColor3 = Theme.Section
            SecBtn.Text = " " .. name
            SecBtn.TextColor3 = Theme.TextDim
            SecBtn.Font = Enum.Font.GothamBold; SecBtn.TextSize = 11
            SecBtn.TextXAlignment = Enum.TextXAlignment.Left
            SecBtn.AutoButtonColor = false
            Instance.new("UICorner", SecBtn).CornerRadius = UDim.new(0, 4)
            local Arrow = Instance.new("ImageLabel", SecBtn)
            Arrow.Size = UDim2.new(0, 16, 0, 16); Arrow.Position = UDim2.new(1, -20, 0.5, -8)
            Arrow.BackgroundTransparency = 1; Arrow.Image = "rbxassetid://6034818372"
            Arrow.ImageColor3 = Theme.TextDim
            local Content = Instance.new("Frame", Page)
            Content.Size = UDim2.new(1, 0, 0, 0)
            Content.BackgroundTransparency = 1
            Content.ClipsDescendants = true
            Content.Visible = false
            local ContentLayout = Instance.new("UIListLayout", Content)
            ContentLayout.Padding = UDim.new(0, 6); ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            local opened = false
            SecBtn.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    Content.Visible = true
                    local contentSize = ContentLayout.AbsoluteContentSize.Y + 10
                    TS:Create(Content, TI, {Size = UDim2.new(1, 0, 0, contentSize)}):Play()
                    TS:Create(Arrow, TI, {Rotation = 180, ImageColor3 = Theme.Accent}):Play()
                    TS:Create(SecBtn, TI, {TextColor3 = Theme.TextActive}):Play()
                else
                    TS:Create(Content, TI, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TS:Create(Arrow, TI, {Rotation = 0, ImageColor3 = Theme.TextDim}):Play()
                    TS:Create(SecBtn, TI, {TextColor3 = Theme.TextDim}):Play()
                    task.wait(0.4)
                    if not opened then Content.Visible = false end
                end
            end)
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if opened then
                    TS:Create(Content, TI, {Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)}):Play()
                end
            end)
            function SectionMethods:Button(t, c) CreateElementButton(Content, t, c) end
            function SectionMethods:Toggle(t, d, c) CreateElementToggle(Content, t, d, c) end
            function SectionMethods:Slider(t, min, max, def, c) CreateElementSlider(Content, t, min, max, def, c) end
            function SectionMethods:Input(t, p, c) CreateElementInput(Content, t, p, c) end
            return SectionMethods
        end
        function Container:Button(t, c) CreateElementButton(Page, t, c) end
        function Container:Toggle(t, d, c) CreateElementToggle(Page, t, d, c) end
        function Container:Slider(t, min, max, def, c) CreateElementSlider(Page, t, min, max, def, c) end
        function Container:Input(t, p, c) CreateElementInput(Page, t, p, c) end
        return Container
    end
    return Pages
end
return MdFuncs
