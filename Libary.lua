-- Khởi tạo thư viện NovaUI
local NovaUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Hàm tạo cửa sổ chính
function NovaUI:CreateWindow(options)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaUI"
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = options.IgnoreGuiInset or false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Window = Instance.new("Frame")
    Window.Size = options.Size or UDim2.new(0, 600, 0, 500)
    Window.Position = UDim2.new(0.5, -300, 0.5, -250)
    Window.BackgroundColor3 = options.Theme and options.Theme.WindowBg or Color3.fromRGB(20, 20, 25)
    Window.BorderSizePixel = 0
    Window.Parent = ScreenGui
    Window.ClipsDescendants = true
    Window.Active = true
    Window.Selectable = true

    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 12)
    WindowCorner.Parent = Window

    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = options.Acrylic and 0.8 or 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = Window

    local AcrylicBlur = Instance.new("Frame")
    AcrylicBlur.Size = UDim2.new(1, 0, 1, 0)
    AcrylicBlur.BackgroundTransparency = options.Acrylic and 0.5 or 1
    AcrylicBlur.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    AcrylicBlur.Parent = Window

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = options.Theme and options.Theme.TitleBar or Color3.fromRGB(30, 30, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Window

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = options.Title or "NovaUI"
    Title.TextColor3 = options.Theme and options.Theme.TitleText or Color3.fromRGB(200, 200, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    Title.Size = UDim2.new(0, Title.TextBounds.X + 20, 1, 0)

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(0, 0, 1, 0)
    SubTitle.Position = UDim2.new(0, Title.Size.X.Offset + 20, 0, 0)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = options.SubTitle or ""
    SubTitle.TextColor3 = options.Theme and options.Theme.SubTitleText or Color3.fromRGB(150, 150, 200)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 14
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = TitleBar
    SubTitle.Size = UDim2.new(0, SubTitle.TextBounds.X + 20, 1, 0)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    MinimizeButton.BackgroundColor3 = options.Theme and options.Theme.MinimizeButton or Color3.fromRGB(255, 200, 0)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.TextSize = 20
    MinimizeButton.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = options.Theme and options.Theme.CloseButton or Color3.fromRGB(255, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 20
    CloseButton.Parent = TitleBar

    local TabsContainer = Instance.new("Frame")
    TabsContainer.Size = UDim2.new(1, -10, 1, -50)
    TabsContainer.Position = UDim2.new(0, 5, 0, 45)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = Window

    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        TweenService:Create(Window, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = isMinimized and UDim2.new(0, 600, 0, 40) or options.Size or UDim2.new(0, 600, 0, 500)}):Play()
        MinimizeButton.Text = isMinimized and "+" or "-"
        TabsContainer.Visible = not isMinimized
    end)

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Window, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)

    local dragging = false
    local dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local Tabs = {}
    local Config = options.Config or {}
    local MinimizeKey = options.MinimizeKey or Enum.KeyCode.LeftControl

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == MinimizeKey and not dragging then
            isMinimized = not isMinimized
            TweenService:Create(Window, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = isMinimized and UDim2.new(0, 600, 0, 40) or options.Size or UDim2.new(0, 600, 0, 500)}):Play()
            MinimizeButton.Text = isMinimized and "+" or "-"
            TabsContainer.Visible = not isMinimized
        end
    end)

    local function AddNotification(noteOptions)
        local NoteFrame = Instance.new("Frame")
        NoteFrame.Size = UDim2.new(0, 300, 0, 100)
        NoteFrame.Position = UDim2.new(1, 0, 1, -110)
        NoteFrame.BackgroundColor3 = options.Theme and options.Theme.NotificationBg or Color3.fromRGB(30, 30, 40)
        NoteFrame.BorderSizePixel = 0
        NoteFrame.Parent = ScreenGui

        local NoteCorner = Instance.new("UICorner")
        NoteCorner.CornerRadius = UDim.new(0, 8)
        NoteCorner.Parent = NoteFrame

        local NoteShadow = Instance.new("ImageLabel")
        NoteShadow.Size = UDim2.new(1, 20, 1, 20)
        NoteShadow.Position = UDim2.new(0, -10, 0, -10)
        NoteShadow.BackgroundTransparency = 1
        NoteShadow.Image = "rbxassetid://6014261993"
        NoteShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        NoteShadow.ImageTransparency = 0.7
        NoteShadow.ScaleType = Enum.ScaleType.Slice
        NoteShadow.SliceCenter = Rect.new(10, 10, 118, 118)
        NoteShadow.Parent = NoteFrame

        local NoteTitle = Instance.new("TextLabel")
        NoteTitle.Size = UDim2.new(1, -10, 0, 25)
        NoteTitle.Position = UDim2.new(0, 5, 0, 5)
        NoteTitle.BackgroundTransparency = 1
        NoteTitle.Text = noteOptions.Title or "Notification"
        NoteTitle.TextColor3 = options.Theme and options.Theme.NotificationTitle or Color3.fromRGB(200, 200, 255)
        NoteTitle.Font = Enum.Font.SourceSansBold
        NoteTitle.TextSize = 16
        NoteTitle.Parent = NoteFrame

        local NoteDesc = Instance.new("TextLabel")
        NoteDesc.Size = UDim2.new(1, -10, 0, 60)
        NoteDesc.Position = UDim2.new(0, 5, 0, 30)
        NoteDesc.BackgroundTransparency = 1
        NoteDesc.Text = noteOptions.Description or "Message here."
        NoteDesc.TextColor3 = options.Theme and options.Theme.NotificationText or Color3.fromRGB(255, 255, 255)
        NoteDesc.Font = Enum.Font.SourceSans
        NoteDesc.TextSize = 14
        NoteDesc.TextWrapped = true
        NoteDesc.Parent = NoteFrame

        TweenService:Create(NoteFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -310, 1, -110)}):Play()
        wait(noteOptions.Duration or 5)
        TweenService:Create(NoteFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 0, 1, -110)}):Play()
        wait(0.3)
        NoteFrame:Destroy()
    end

    function Tabs:AddTab(tabOptions)
        local Tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, tabOptions.TabWidth or 140, 0, 40)
        TabButton.Position = UDim2.new(0, #Tabs * (tabOptions.TabWidth or 140), 0, 0)
        TabButton.BackgroundColor3 = options.Theme and options.Theme.TabInactive or Color3.fromRGB(40, 40, 50)
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.Parent = TitleBar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = tabOptions.Icon or ""
        TabIcon.Parent = TabButton

        local TabText = Instance.new("TextLabel")
        TabText.Size = UDim2.new(1, -30, 1, 0)
        TabText.Position = UDim2.new(0, 25, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = tabOptions.Title or "Tab"
        TabText.TextColor3 = options.Theme and options.Theme.TabText or Color3.fromRGB(200, 200, 255)
        TabText.Font = Enum.Font.SourceSansBold
        TabText.TextSize = 16
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = TabsContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 5)
        ContentPadding.Parent = TabContent

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = options.Theme and options.Theme.TabInactive or Color3.fromRGB(40, 40, 50)
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = options.Theme and options.Theme.TabActive or Color3.fromRGB(60, 60, 80)
            TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.TabActiveHover or Color3.fromRGB(70, 70, 90)}):Play()
        end)

        TabButton.MouseEnter:Connect(function()
            if not TabContent.Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.TabHover or Color3.fromRGB(50, 50, 60)}):Play()
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if not TabContent.Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.TabInactive or Color3.fromRGB(40, 40, 50)}):Play()
            end
        end)

        function Tab:AddSection(sectionOptions)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.BackgroundColor3 = options.Theme and options.Theme.SectionBg or Color3.fromRGB(25, 25, 30)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            SectionFrame.ClipsDescendants = true

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, -10, 0, 30)
            SectionTitle.Position = UDim2.new(0, 5, 0, 5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionOptions.Title or "Section"
            SectionTitle.TextColor3 = options.Theme and options.Theme.SectionText or Color3.fromRGB(200, 200, 255)
            SectionTitle.Font = Enum.Font.SourceSansBold
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame

            local SectionContent = Instance.new("Frame")
            SectionContent.Size = UDim2.new(1, -10, 1, -40)
            SectionContent.Position = UDim2.new(0, 5, 0, 35)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = SectionFrame

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Padding = UDim.new(0, 8)
            SectionLayout.Parent = SectionContent

            SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 45)

            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 45)
            end)

            return SectionContent
        end

        function Tab:AddButton(btnOptions)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, btnOptions.Description and 65 or 45)
            Button.BackgroundColor3 = options.Theme and options.Theme.ButtonBg or Color3.fromRGB(50, 100, 255)
            Button.BorderSizePixel = 0
            Button.Text = btnOptions.Title or "Button"
            Button.TextColor3 = options.Theme and options.Theme.ButtonText or Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.SourceSansBold
            Button.TextSize = 16
            Button.Parent = TabContent

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button

            local ButtonShadow = Instance.new("ImageLabel")
            ButtonShadow.Size = UDim2.new(1, 20, 1, 20)
            ButtonShadow.Position = UDim2.new(0, -10, 0, -10)
            ButtonShadow.BackgroundTransparency = 1
            ButtonShadow.Image = "rbxassetid://6014261993"
            ButtonShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            ButtonShadow.ImageTransparency = 0.8
            ButtonShadow.ScaleType = Enum.ScaleType.Slice
            ButtonShadow.SliceCenter = Rect.new(10, 10, 118, 118)
            ButtonShadow.Parent = Button

            local ButtonDesc = Instance.new("TextLabel")
            ButtonDesc.Size = UDim2.new(1, -10, 0, 20)
            ButtonDesc.Position = UDim2.new(0, 5, 1, -25)
            ButtonDesc.BackgroundTransparency = 1
            ButtonDesc.Text = btnOptions.Description or ""
            ButtonDesc.TextColor3 = options.Theme and options.Theme.ButtonDesc or Color3.fromRGB(180, 180, 255)
            ButtonDesc.Font = Enum.Font.SourceSans
            ButtonDesc.TextSize = 14
            ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
            ButtonDesc.Parent = Button

            Button.MouseButton1Click:Connect(btnOptions.Callback or function() end)
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.ButtonHover or Color3.fromRGB(70, 120, 255)}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.ButtonBg or Color3.fromRGB(50, 100, 255)}):Play()
            end)
        end

        function Tab:AddImageButton(imgBtnOptions)
            local ImageButton = Instance.new("ImageButton")
            ImageButton.Size = UDim2.new(1, -10, 0, imgBtnOptions.Height or 120)
            ImageButton.BackgroundColor3 = options.Theme and options.Theme.ImageButtonBg or Color3.fromRGB(40, 40, 50)
            ImageButton.BorderSizePixel = 0
            ImageButton.Image = imgBtnOptions.Image or "rbxassetid://0"
            ImageButton.Parent = TabContent

            local ImageCorner = Instance.new("UICorner")
            ImageCorner.CornerRadius = UDim.new(0, 8)
            ImageCorner.Parent = ImageButton

            local ImageShadow = Instance.new("ImageLabel")
            ImageShadow.Size = UDim2.new(1, 20, 1, 20)
            ImageShadow.Position = UDim2.new(0, -10, 0, -10)
            ImageShadow.BackgroundTransparency = 1
            ImageShadow.Image = "rbxassetid://6014261993"
            ImageShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            ImageShadow.ImageTransparency = 0.8
            ImageShadow.ScaleType = Enum.ScaleType.Slice
            ImageShadow.SliceCenter = Rect.new(10, 10, 118, 118)
            ImageShadow.Parent = ImageButton

            local ImageTitle = Instance.new("TextLabel")
            ImageTitle.Size = UDim2.new(1, -10, 0, 25)
            ImageTitle.Position = UDim2.new(0, 5, 0, 5)
            ImageTitle.BackgroundTransparency = 1
            ImageTitle.Text = imgBtnOptions.Title or "Image Button"
            ImageTitle.TextColor3 = options.Theme and options.Theme.ImageButtonText or Color3.fromRGB(220, 220, 255)
            ImageTitle.Font = Enum.Font.SourceSansBold
            ImageTitle.TextSize = 16
            ImageTitle.TextXAlignment = Enum.TextXAlignment.Left
            ImageTitle.Parent = ImageButton

            ImageButton.MouseButton1Click:Connect(imgBtnOptions.Callback or function() end)
            ImageButton.MouseEnter:Connect(function()
                TweenService:Create(ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.ImageButtonHover or Color3.fromRGB(50, 50, 60)}):Play()
            end)
            ImageButton.MouseLeave:Connect(function()
                TweenService:Create(ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.ImageButtonBg or Color3.fromRGB(40, 40, 50)}):Play()
            end)
        end

        function Tab:AddToggle(toggleId, toggleOptions)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, toggleOptions.Description and 65 or 45)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = TabContent

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.7, 0, 0, 25)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleOptions.Title or "Toggle"
            ToggleLabel.TextColor3 = options.Theme and options.Theme.ToggleText or Color3.fromRGB(220, 220, 255)
            ToggleLabel.Font = Enum.Font.SourceSans
            ToggleLabel.TextSize = 16
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local ToggleDesc = Instance.new("TextLabel")
            ToggleDesc.Size = UDim2.new(0.7, 0, 0, 20)
            ToggleDesc.Position = UDim2.new(0, 0, 0, 25)
            ToggleDesc.BackgroundTransparency = 1
            ToggleDesc.Text = toggleOptions.Description or ""
            ToggleDesc.TextColor3 = options.Theme and options.Theme.ToggleDesc or Color3.fromRGB(180, 180, 255)
            ToggleDesc.Font = Enum.Font.SourceSans
            ToggleDesc.TextSize = 14
            ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
            ToggleDesc.Parent = ToggleFrame

            local ToggleButton = Instance.new("Frame")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -45, 0, 5)
            ToggleButton.BackgroundColor3 = options.Theme and options.Theme.ToggleBg or Color3.fromRGB(80, 80, 80)
            ToggleButton.Parent = ToggleFrame

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 10)
            ToggleCorner.Parent = ToggleButton

            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = toggleOptions.Default and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Parent = ToggleButton

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(0, 8)
            CircleCorner.Parent = ToggleCircle

            local state = toggleOptions.Default or false
            ToggleButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = state and (options.Theme and options.Theme.ToggleOn or Color3.fromRGB(50, 255, 100)) or (options.Theme and options.Theme.ToggleBg or Color3.fromRGB(80, 80, 80))}):Play()
                    if toggleOptions.Callback then toggleOptions.Callback(state) end
                    Config[toggleId] = state
                end
            end)
            if Config[toggleId] ~= nil then
                state = Config[toggleId]
                ToggleCircle.Position = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
                ToggleButton.BackgroundColor3 = state and (options.Theme and options.Theme.ToggleOn or Color3.fromRGB(50, 255, 100)) or (options.Theme and options.Theme.ToggleBg or Color3.fromRGB(80, 80, 80))
            end
        end

        function Tab:AddSlider(sliderId, sliderOptions)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, sliderOptions.Description and 85 or 65)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = TabContent

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 25)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderOptions.Title or "Slider"
            SliderLabel.TextColor3 = options.Theme and options.Theme.SliderText or Color3.fromRGB(220, 220, 255)
            SliderLabel.Font = Enum.Font.SourceSans
            SliderLabel.TextSize = 16
            SliderLabel.Parent = SliderFrame

            local SliderDesc = Instance.new("TextLabel")
            SliderDesc.Size = UDim2.new(1, 0, 0, 20)
            SliderDesc.Position = UDim2.new(0, 0, 0, 25)
            SliderDesc.BackgroundTransparency = 1
            SliderDesc.Text = sliderOptions.Description or ""
            SliderDesc.TextColor3 = options.Theme and options.Theme.SliderDesc or Color3.fromRGB(180, 180, 255)
            SliderDesc.Font = Enum.Font.SourceSans
            SliderDesc.TextSize = 14
            SliderDesc.TextXAlignment = Enum.TextXAlignment.Left
            SliderDesc.Parent = SliderFrame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, 0, 0, 15)
            SliderBar.Position = UDim2.new(0, 0, 0, sliderOptions.Description and 50 or 30)
            SliderBar.BackgroundColor3 = options.Theme and options.Theme.SliderBar or Color3.fromRGB(40, 40, 50)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((sliderOptions.Default - sliderOptions.Min) / (sliderOptions.Max - sliderOptions.Min), 0, 1, 0)
            Fill.BackgroundColor3 = options.Theme and options.Theme.SliderFill or Color3.fromRGB(50, 100, 255)
            Fill.BorderSizePixel = 0
            Fill.Parent = SliderBar

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(0, 8)
            BarCorner.Parent = SliderBar

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 8)
            FillCorner.Parent = Fill

            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -55, 0, -25)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(sliderOptions.Default or sliderOptions.Min)
            SliderValue.TextColor3 = options.Theme and options.Theme.SliderValue or Color3.fromRGB(200, 200, 255)
            SliderValue.Font = Enum.Font.SourceSans
            SliderValue.TextSize = 14
            SliderValue.Parent = SliderBar

            local value = sliderOptions.Default or sliderOptions.Min
            local draggingSlider = false
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    local mouse = Players.LocalPlayer:GetMouse()
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if draggingSlider then
                            local percent = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                            value = sliderOptions.Min + (sliderOptions.Max - sliderOptions.Min) * percent
                            value = math.floor(value * (10 ^ (sliderOptions.Rounding or 0))) / (10 ^ (sliderOptions.Rounding or 0))
                            TweenService:Create(Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                            SliderValue.Text = tostring(value)
                            if sliderOptions.Callback then sliderOptions.Callback(value) end
                            Config[sliderId] = value
                        end
                    end)
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            draggingSlider = false
                            connection:Disconnect()
                        end
                    end)
                end
            end)
            if Config[sliderId] ~= nil then
                value = Config[sliderId]
                Fill.Size = UDim2.new((value - sliderOptions.Min) / (sliderOptions.Max - sliderOptions.Min), 0, 1, 0)
                SliderValue.Text = tostring(value)
            end
        end

        function Tab:AddDropdown(dropdownId, dropdownOptions)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -10, 0, dropdownOptions.Description and 65 or 45)
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Parent = TabContent

            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(0.5, 0, 0, 25)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = dropdownOptions.Title or "Dropdown"
            DropdownLabel.TextColor3 = options.Theme and options.Theme.DropdownText or Color3.fromRGB(220, 220, 255)
            DropdownLabel.Font = Enum.Font.SourceSans
            DropdownLabel.TextSize = 16
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame

            local DropdownDesc = Instance.new("TextLabel")
            DropdownDesc.Size = UDim2.new(0.5, 0, 0, 20)
            DropdownDesc.Position = UDim2.new(0, 0, 0, 25)
            DropdownDesc.BackgroundTransparency = 1
            DropdownDesc.Text = dropdownOptions.Description or ""
            DropdownDesc.TextColor3 = options.Theme and options.Theme.DropdownDesc or Color3.fromRGB(180, 180, 255)
            DropdownDesc.Font = Enum.Font.SourceSans
            DropdownDesc.TextSize = 14
            DropdownDesc.TextXAlignment = Enum.TextXAlignment.Left
            DropdownDesc.Parent = DropdownFrame

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 160, 0, 35)
            DropdownButton.Position = UDim2.new(1, -165, 0, dropdownOptions.Description and 25 or 5)
            DropdownButton.BackgroundColor3 = options.Theme and options.Theme.DropdownBg or Color3.fromRGB(40, 40, 50)
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = dropdownOptions.Default or "Select..."
            DropdownButton.TextColor3 = options.Theme and options.Theme.DropdownText or Color3.fromRGB(255, 255, 255)
            DropdownButton.Font = Enum.Font.SourceSans
            DropdownButton.TextSize = 16
            DropdownButton.Parent = DropdownFrame

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownButton

            local DropdownArrow = Instance.new("ImageLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
            DropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Image = "rbxassetid://6034818372"
            DropdownArrow.Parent = DropdownButton

            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Size = UDim2.new(0, 160, 0, 0)
            OptionsFrame.Position = UDim2.new(1, -165, 0, dropdownOptions.Description and 60 or 40)
            OptionsFrame.BackgroundColor3 = options.Theme and options.Theme.DropdownOptionsBg or Color3.fromRGB(30, 30, 40)
            OptionsFrame.BorderSizePixel = 0
            OptionsFrame.Visible = false
            OptionsFrame.Parent = DropdownFrame

            local OptionsCorner = Instance.new("UICorner")
            OptionsCorner.CornerRadius = UDim.new(0, 8)
            OptionsCorner.Parent = OptionsFrame

            local OptionsList = Instance.new("UIListLayout")
            OptionsList.Parent = OptionsFrame

            local OptionsPadding = Instance.new("UIPadding")
            OptionsPadding.PaddingTop = UDim.new(0, 5)
            OptionsPadding.Parent = OptionsFrame

            local isOpen = false
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                OptionsFrame.Visible = isOpen
                TweenService:Create(OptionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = isOpen and UDim2.new(0, 160, 0, math.min(#dropdownOptions.Options * 35, 140)) or UDim2.new(0, 160, 0, 0)}):Play()
                TweenService:Create(DropdownArrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Rotation = isOpen and 180 or 0}):Play()
            end)

            for _, option in pairs(dropdownOptions.Options or {}) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 35)
                OptionButton.BackgroundColor3 = options.Theme and options.Theme.DropdownOption or Color3.fromRGB(40, 40, 50)
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = options.Theme and options.Theme.DropdownOptionText or Color3.fromRGB(255, 255, 255)
                OptionButton.Font = Enum.Font.SourceSans
                OptionButton.TextSize = 16
                OptionButton.Parent = OptionsFrame

                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = option
                    OptionsFrame.Visible = false
                    isOpen = false
                    TweenService:Create(DropdownArrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Rotation = 0}):Play()
                    if dropdownOptions.Callback then dropdownOptions.Callback(option) end
                    Config[dropdownId] = option
                end)
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.DropdownOptionHover or Color3.fromRGB(50, 50, 60)}):Play()
                end)
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = options.Theme and options.Theme.DropdownOption or Color3.fromRGB(40, 40, 50)}):Play()
                end)
            end
            if Config[dropdownId] ~= nil then
                DropdownButton.Text = Config[dropdownId]
            end
        end

        function Tab:AddTextbox(textboxId, textboxOptions)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(1, -10, 0, textboxOptions.Description and 65 or 45)
            TextboxFrame.BackgroundTransparency = 1
            TextboxFrame.Parent = TabContent

            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(0.5, 0, 0, 25)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = textboxOptions.Title or "Textbox"
            TextboxLabel.TextColor3 = options.Theme and options.Theme.TextboxText or Color3.fromRGB(220, 220, 255)
            TextboxLabel.Font = Enum.Font.SourceSans
            TextboxLabel.TextSize = 16
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame

            local TextboxDesc = Instance.new("TextLabel")
            TextboxDesc.Size = UDim2.new(0.5, 0, 0, 20)
            TextboxDesc.Position = UDim2.new(0, 0, 0, 25)
            TextboxDesc.BackgroundTransparency = 1
            TextboxDesc.Text = textboxOptions.Description or ""
            TextboxDesc.TextColor3 = options.Theme and options.Theme.TextboxDesc or Color3.fromRGB(180, 180, 255)
            TextboxDesc.Font = Enum.Font.SourceSans
            TextboxDesc.TextSize = 14
            TextboxDesc.TextXAlignment = Enum.TextXAlignment.Left
            TextboxDesc.Parent = TextboxFrame

            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(0, 160, 0, 35)
            Textbox.Position = UDim2.new(1, -165, 0, textboxOptions.Description and 25 or 5)
            Textbox.BackgroundColor3 = options.Theme and options.Theme.TextboxBg or Color3.fromRGB(40, 40, 50)
            Textbox.BorderSizePixel = 0
            Textbox.Text = textboxOptions.Default or ""
            Textbox.TextColor3 = options.Theme and options.Theme.TextboxInput or Color3.fromRGB(255, 255, 255)
            Textbox.Font = Enum.Font.SourceSans
            Textbox.TextSize = 16
            Textbox.ClearTextOnFocus = textboxOptions.ClearTextOnFocus or false
            Textbox.Parent = TextboxFrame

            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = Textbox

            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed and textboxOptions.Callback then
                    textboxOptions.Callback(Textbox.Text)
                    Config[textboxId] = Textbox.Text
                end
            end)
            if Config[textboxId] ~= nil then
                Textbox.Text = Config[textboxId]
            end
        end

        function Tab:AddKeybind(keybindId, keybindOptions)
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, -10, 0, keybindOptions.Description and 65 or 45)
            KeybindFrame.BackgroundTransparency = 1
            KeybindFrame.Parent = TabContent

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(0.5, 0, 0, 25)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = keybindOptions.Title or "Keybind"
            KeybindLabel.TextColor3 = options.Theme and options.Theme.KeybindText or Color3.fromRGB(220, 220, 255)
            KeybindLabel.Font = Enum.Font.SourceSans
            KeybindLabel.TextSize = 16
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame

            local KeybindDesc = Instance.new("TextLabel")
            KeybindDesc.Size = UDim2.new(0.5, 0, 0, 20)
            KeybindDesc.Position = UDim2.new(0, 0, 0, 25)
            KeybindDesc.BackgroundTransparency = 1
            KeybindDesc.Text = keybindOptions.Description or ""
            KeybindDesc.TextColor3 = options.Theme and options.Theme.KeybindDesc or Color3.fromRGB(180, 180, 255)
            KeybindDesc.Font = Enum.Font.SourceSans
            KeybindDesc.TextSize = 14
            KeybindDesc.TextXAlignment = Enum.TextXAlignment.Left
            KeybindDesc.Parent = KeybindFrame

            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 100, 0, 35)
            KeybindButton.Position = UDim2.new(1, -105, 0, keybindOptions.Description and 25 or 5)
            KeybindButton.BackgroundColor3 = options.Theme and options.Theme.KeybindBg or Color3.fromRGB(40, 40, 50)
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Text = keybindOptions.Default and keybindOptions.Default.Name or "None"
            KeybindButton.TextColor3 = options.Theme and options.Theme.KeybindText or Color3.fromRGB(255, 255, 255)
            KeybindButton.Font = Enum.Font.SourceSans
            KeybindButton.TextSize = 16
            KeybindButton.Parent = KeybindFrame

            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindButton

            local key = keybindOptions.Default
            local waiting = false
            KeybindButton.MouseButton1Click:Connect(function()
                waiting = true
                KeybindButton.Text = "[...]"
            end)

            UserInputService.InputBegan:Connect(function(input)
                if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    KeybindButton.Text = key.Name
                    waiting = false
                    if keybindOptions.Callback then keybindOptions.Callback(key) end
                    Config[keybindId] = key.Name
                end
            end)
            if Config[keybindId] ~= nil then
                KeybindButton.Text = Config[keybindId]
                key = Enum.KeyCode[Config[keybindId]]
            end
        end

        function Tab:AddLabel(labelOptions)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -10, 0, 35)
            Label.BackgroundTransparency = 1
            Label.Text = labelOptions.Text or "Label"
            Label.TextColor3 = options.Theme and options.Theme.LabelText or Color3.fromRGB(220, 220, 255)
            Label.Font = Enum.Font.SourceSans
            Label.TextSize = 16
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabContent
        end

        function Tab:AddParagraph(paragraphOptions)
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Size = UDim2.new(1, -10, 0, 0)
            ParagraphFrame.BackgroundTransparency = 1
            ParagraphFrame.Parent = TabContent

            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, 0, 0, 25)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = paragraphOptions.Title or "Paragraph"
            ParagraphTitle.TextColor3 = options.Theme and options.Theme.ParagraphTitle or Color3.fromRGB(220, 220, 255)
            ParagraphTitle.Font = Enum.Font.SourceSansBold
            ParagraphTitle.TextSize = 16
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.Parent = ParagraphFrame

            local ParagraphText = Instance.new("TextLabel")
            ParagraphText.Size = UDim2.new(1, 0, 0, 0)
            ParagraphText.Position = UDim2.new(0, 0, 0, 25)
            ParagraphText.BackgroundTransparency = 1
            ParagraphText.Text = paragraphOptions.Content or "Content here."
            ParagraphText.TextColor3 = options.Theme and options.Theme.ParagraphText or Color3.fromRGB(180, 180, 255)
            ParagraphText.Font = Enum.Font.SourceSans
            ParagraphText.TextSize = 14
            ParagraphText.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphText.TextWrapped = true
            ParagraphText.Parent = ParagraphFrame

            ParagraphText.Size = UDim2.new(1, 0, 0, ParagraphText.TextBounds.Y)
            ParagraphFrame.Size = UDim2.new(1, -10, 0, ParagraphText.TextBounds.Y + 35)
        end

        function Tab:AddColorPicker(colorId, colorOptions)
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(1, -10, 0, colorOptions.Description and 65 or 45)
            ColorFrame.BackgroundTransparency = 1
            ColorFrame.Parent = TabContent

            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(0.5, 0, 0, 25)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = colorOptions.Title or "Color Picker"
            ColorLabel.TextColor3 = options.Theme and options.Theme.ColorPickerText or Color3.fromRGB(220, 220, 255)
            ColorLabel.Font = Enum.Font.SourceSans
            ColorLabel.TextSize = 16
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame

            local ColorDesc = Instance.new("TextLabel")
            ColorDesc.Size = UDim2.new(0.5, 0, 0, 20)
            ColorDesc.Position = UDim2.new(0, 0, 0, 25)
            ColorDesc.BackgroundTransparency = 1
            ColorDesc.Text = colorOptions.Description or ""
            ColorDesc.TextColor3 = options.Theme and options.Theme.ColorPickerDesc or Color3.fromRGB(180, 180, 255)
            ColorDesc.Font = Enum.Font.SourceSans
            ColorDesc.TextSize = 14
            ColorDesc.TextXAlignment = Enum.TextXAlignment.Left
            ColorDesc.Parent = ColorFrame

            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(0, 40, 0, 35)
            ColorButton.Position = UDim2.new(1, -45, 0, colorOptions.Description and 25 or 5)
            ColorButton.BackgroundColor3 = colorOptions.Default or Color3.fromRGB(255, 255, 255)
            ColorButton.BorderSizePixel = 0
            ColorButton.Text = ""
            ColorButton.Parent = ColorFrame

            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 8)
            ColorCorner.Parent = ColorButton

            local PickerFrame = Instance.new("Frame")
            PickerFrame.Size = UDim2.new(0, 200, 0, 200)
            PickerFrame.Position = UDim2.new(1, -210, 0, colorOptions.Description and 65 or 45)
            PickerFrame.BackgroundColor3 = options.Theme and options.Theme.ColorPickerBg or Color3.fromRGB(30, 30, 40)
            PickerFrame.BorderSizePixel = 0
            PickerFrame.Visible = false
            PickerFrame.Parent = ColorFrame

            local PickerCorner = Instance.new("UICorner")
            PickerCorner.CornerRadius = UDim.new(0, 8)
            PickerCorner.Parent = PickerFrame

            local ColorCanvas = Instance.new("ImageLabel")
            ColorCanvas.Size = UDim2.new(0, 160, 0, 160)
            ColorCanvas.Position = UDim2.new(0, 10, 0, 10)
            ColorCanvas.BackgroundTransparency = 1
            ColorCanvas.Image = "rbxassetid://698052001"
            ColorCanvas.Parent = PickerFrame

            local ColorSelector = Instance.new("Frame")
            ColorSelector.Size = UDim2.new(0, 8, 0, 8)
            ColorSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorSelector.BorderSizePixel = 2
            ColorSelector.Parent = ColorCanvas

            local HueBar = Instance.new("ImageLabel")
            HueBar.Size = UDim2.new(0, 20, 0, 160)
            HueBar.Position = UDim2.new(0, 175, 0, 10)
            HueBar.BackgroundTransparency = 1
            HueBar.Image = "rbxassetid://698052001"
            HueBar.Parent = PickerFrame

            local HueSelector = Instance.new("Frame")
            HueSelector.Size = UDim2.new(1, 0, 0, 4)
            HueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSelector.BorderSizePixel = 1
            HueSelector.Parent = HueBar

            local currentColor = colorOptions.Default or Color3.fromRGB(255, 255, 255)
            local h, s, v = currentColor:ToHSV()
            ColorSelector.Position = UDim2.new(s, 0, 1 - v, 0)
            HueSelector.Position = UDim2.new(0, 0, h, 0)

            local isOpen = false
            ColorButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                PickerFrame.Visible = isOpen
            end)

            local function updateColor()
                local hue = HueSelector.Position.Y.Scale
                local sat = ColorSelector.Position.X.Scale
                local val = 1 - ColorSelector.Position.Y.Scale
                currentColor = Color3.fromHSV(hue, sat, val)
                ColorButton.BackgroundColor3 = currentColor
                if colorOptions.Callback then colorOptions.Callback(currentColor) end
                Config[colorId] = {currentColor.R * 255, currentColor.G * 255, currentColor.B * 255}
            end

            ColorCanvas.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                    local dragging = true
                    local mouse = Players.LocalPlayer:GetMouse()
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if dragging then
                            local x = math.clamp(mouse.X - ColorCanvas.AbsolutePosition.X, 0, ColorCanvas.AbsoluteSize.X)
                            local y = math.clamp(mouse.Y - ColorCanvas.AbsolutePosition.Y, 0, ColorCanvas.AbsoluteSize.Y)
                            ColorSelector.Position = UDim2.new(0, x, 0, y)
                            updateColor()
                        end
                    end)
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                            connection:Disconnect()
                        end
                    end)
                end
            end)

            HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                    local dragging = true
                    local mouse = Players.LocalPlayer:GetMouse()
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if dragging then
                            local y = math.clamp(mouse.Y - HueBar.AbsolutePosition.Y, 0, HueBar.AbsoluteSize.Y)
                            HueSelector.Position = UDim2.new(0, 0, 0, y)
                            updateColor()
                        end
                    end)
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                            connection:Disconnect()
                        end
                    end)
                end
            end)
            if Config[colorId] ~= nil then
                currentColor = Color3.fromRGB(unpack(Config[colorId]))
                ColorButton.BackgroundColor3 = currentColor
                h, s, v = currentColor:ToHSV()
                ColorSelector.Position = UDim2.new(s, 0, 1 - v, 0)
                HueSelector.Position = UDim2.new(0, 0, h, 0)
            end
        end

        Tab.AddNotification = AddNotification
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Tabs, Tab)
        if #Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = options.Theme and options.Theme.TabActive or Color3.fromRGB(70, 70, 90)
        end
        return Tab
    end

    return Tabs
end

-- Định nghĩa Theme
local Theme = {
    WindowBg = Color3.fromRGB(20, 20, 25),
    TitleBar = Color3.fromRGB(30, 30, 40),
    TitleText = Color3.fromRGB(200, 200, 255),
    SubTitleText = Color3.fromRGB(150, 150, 200),
    MinimizeButton = Color3.fromRGB(255, 200, 0),
    CloseButton = Color3.fromRGB(255, 50, 50),
    TabInactive = Color3.fromRGB(40, 40, 50),
    TabActive = Color3.fromRGB(60, 60, 80),
    TabHover = Color3.fromRGB(50, 50, 60),
    TabActiveHover = Color3.fromRGB(70, 70, 90),
    TabText = Color3.fromRGB(200, 200, 255),
    SectionBg = Color3.fromRGB(25, 25, 30),
    SectionText = Color3.fromRGB(200, 200, 255),
    ButtonBg = Color3.fromRGB(50, 100, 255),
    ButtonHover = Color3.fromRGB(70, 120, 255),
    ButtonText = Color3.fromRGB(255, 255, 255),
    ButtonDesc = Color3.fromRGB(180, 180, 255),
    ImageButtonBg = Color3.fromRGB(40, 40, 50),
    ImageButtonHover = Color3.fromRGB(50, 50, 60),
    ImageButtonText = Color3.fromRGB(220, 220, 255),
    ToggleText = Color3.fromRGB(220, 220, 255),
    ToggleDesc = Color3.fromRGB(180, 180, 255),
    ToggleBg = Color3.fromRGB(80, 80, 80),
    ToggleOn = Color3.fromRGB(50, 255, 100),
    SliderText = Color3.fromRGB(220, 220, 255),
    SliderDesc = Color3.fromRGB(180, 180, 255),
    SliderBar = Color3.fromRGB(40, 40, 50),
    SliderFill = Color3.fromRGB(50, 100, 255),
    SliderValue = Color3.fromRGB(200, 200, 255),
    DropdownText = Color3.fromRGB(220, 220, 255),
    DropdownDesc = Color3.fromRGB(180, 180, 255),
    DropdownBg = Color3.fromRGB(40, 40, 50),
    DropdownOptionsBg = Color3.fromRGB(30, 30, 40),
    DropdownOption = Color3.fromRGB(40, 40, 50),
    DropdownOptionHover = Color3.fromRGB(50, 50, 60),
    DropdownOptionText = Color3.fromRGB(255, 255, 255),
    TextboxText = Color3.fromRGB(220, 220, 255),
    TextboxDesc = Color3.fromRGB(180, 180, 255),
    TextboxBg = Color3.fromRGB(40, 40, 50),
    TextboxInput = Color3.fromRGB(255, 255, 255),
    KeybindText = Color3.fromRGB(220, 220, 255),
    KeybindDesc = Color3.fromRGB(180, 180, 255),
    KeybindBg = Color3.fromRGB(40, 40, 50),
    LabelText = Color3.fromRGB(220, 220, 255),
    ParagraphTitle = Color3.fromRGB(220, 220, 255),
    ParagraphText = Color3.fromRGB(180, 180, 255),
    ColorPickerText = Color3.fromRGB(220, 220, 255),
    ColorPickerDesc = Color3.fromRGB(180, 180, 255),
    ColorPickerBg = Color3.fromRGB(30, 30, 40),
    NotificationBg = Color3.fromRGB(30, 30, 40),
    NotificationTitle = Color3.fromRGB(200, 200, 255),
    NotificationText = Color3.fromRGB(255, 255, 255)
}

local Config = {}
