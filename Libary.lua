-- GrokUI: Một UI host framework với giao diện giống Fluent, hỗ trợ loadstring
local GrokUI = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Khởi tạo cửa sổ chính
function GrokUI:CreateWindow(config)
    local Window = {}
    Window.Title = config.Title or "GrokUI"
    Window.SubTitle = config.SubTitle or ""
    Window.Size = config.Size or UDim2.new(0, 580, 0, 400)
    Window.MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    Window.Tabs = {}

    -- Tạo ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GrokUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Tạo khung chính
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Màu nền giống Fluent
    MainFrame.Position = UDim2.new(0.5, -Window.Size.X.Offset / 2, 0.5, -Window.Size.Y.Offset / 2)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(40, 40, 40)
    UIStroke.Thickness = 1
    UIStroke.Parent = MainFrame

    -- Tạo thanh tiêu đề
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BorderSizePixel = 0

    local TitleText = Instance.new("TextLabel")
    TitleText.Parent = TitleBar
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.Size = UDim2.new(1, -30, 1, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = Window.Title .. (Window.SubTitle ~= "" and " - " .. Window.SubTitle or "")
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left

    -- Tạo vùng chứa tab
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 160, 1, -40)
    TabContainer.BorderSizePixel = 0

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.Position = UDim2.new(0, 5, 0, 5)
    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.ScrollBarThickness = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabList
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    -- Tạo vùng nội dung
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 160, 0, 40)
    ContentContainer.Size = UDim2.new(1, -160, 1, -40)

    local PageLayout = Instance.new("UIPageLayout")
    PageLayout.Parent = ContentContainer
    PageLayout.EasingStyle = Enum.EasingStyle.Quad
    PageLayout.TweenTime = 0.3

    -- Hiệu ứng mở cửa sổ
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = Window.Size}):Play()

    -- Làm cửa sổ có thể kéo
    local function MakeDraggable(topBar, frame)
        local dragging, dragInput, dragStart, startPos
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        topBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        topBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    MakeDraggable(TitleBar, MainFrame)

    -- Ẩn/Hiện cửa sổ
    local hidden = false
    function Window:Toggle()
        hidden = not hidden
        if hidden then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = Window.Size}):Play()
        end
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Window.MinimizeKey then
            Window:Toggle()
        end
    end)

    -- Hàm thêm tab
    function Window:AddTab(config)
        local Tab = {}
        Tab.Title = config.Title or "Tab"
        Tab.Icon = config.Icon or ""

        -- Tạo nút tab
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabList
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0, 8)
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Image = Tab.Icon

        local TabTitle = Instance.new("TextLabel")
        TabTitle.Name = "TabTitle"
        TabTitle.Parent = TabButton
        TabTitle.BackgroundTransparency = 1
        TabTitle.Position = UDim2.new(0, 40, 0, 0)
        TabTitle.Size = UDim2.new(1, -50, 1, 0)
        TabTitle.Font = Enum.Font.Gotham
        TabTitle.Text = Tab.Title
        TabTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabTitle.TextSize = 14
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left

        -- Tạo trang nội dung
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = Tab.Title
        TabPage.Parent = ContentContainer
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)

        local PageLayoutList = Instance.new("UIListLayout")
        PageLayoutList.Parent = TabPage
        PageLayoutList.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayoutList.Padding = UDim.new(0, 8)

        -- Cập nhật CanvasSize tự động
        PageLayoutList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayoutList.AbsoluteContentSize.Y + 10)
        end)

        -- Chuyển tab khi nhấn
        TabButton.MouseButton1Click:Connect(function()
            PageLayout:JumpTo(TabPage)
            for _, btn in pairs(TabList:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    btn:FindFirstChild("TabTitle").TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TabTitle.TextColor3 = Color3.fromRGB(100, 150, 255) -- Điểm nhấn màu xanh giống Fluent
        end)

        -- Mặc định chọn tab đầu tiên
        if #Window.Tabs == 0 then
            TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TabTitle.TextColor3 = Color3.fromRGB(100, 150, 255)
            PageLayout:JumpTo(TabPage)
        end

        table.insert(Window.Tabs, Tab)

        -- Hàm thêm section
        function Tab:AddSection(title)
            local Section = Instance.new("Frame")
            Section.Parent = TabPage
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.new(1, -10, 0, 30)

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.Size = UDim2.new(1, -20, 1, 0)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = title
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            local SectionDivider = Instance.new("Frame")
            SectionDivider.Parent = Section
            SectionDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SectionDivider.Size = UDim2.new(1, -10, 0, 1)
            SectionDivider.Position = UDim2.new(0, 5, 1, -1)
            SectionDivider.BorderSizePixel = 0

            return Section
        end

        -- Hàm thêm button
        function Tab:AddButton(config)
            local Button = Instance.new("TextButton")
            Button.Parent = TabPage
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.Text = config.Title or "Button"
            Button.Font = Enum.Font.Gotham
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.BorderSizePixel = 0

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(40, 40, 40)
            ButtonStroke.Thickness = 1
            ButtonStroke.Parent = Button

            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)

            Button.MouseEnter:Connect(function()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 150, 255)}):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 40)}):Play()
            end)

            return Button
        end

        -- Hàm thêm toggle
        function Tab:AddToggle(config)
            local Toggle = {}
            Toggle.Value = config.Default or false

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = TabPage
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            ToggleFrame.BorderSizePixel = 0

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame

            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = Color3.fromRGB(40, 40, 40)
            ToggleStroke.Thickness = 1
            ToggleStroke.Parent = ToggleFrame

            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Parent = ToggleFrame
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
            ToggleTitle.Size = UDim2.new(1, -60, 1, 0)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = config.Title or "Toggle"
            ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.TextSize = 14
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleButton = Instance.new("Frame")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ToggleButton.Position = UDim2.new(1, -40, 0, 10)
            ToggleButton.Size = UDim2.new(0, 24, 0, 20)
            ToggleButton.BorderSizePixel = 0

            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(0, 10)
            ToggleButtonCorner.Parent = ToggleButton

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Parent = ToggleButton
            ToggleIndicator.BackgroundColor3 = Toggle.Value and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 60)
            ToggleIndicator.Position = Toggle.Value and UDim2.new(0.5, 0, 0, 2) or UDim2.new(0, 2, 0, 2)
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.BorderSizePixel = 0

            local ToggleIndicatorCorner = Instance.new("UICorner")
            ToggleIndicatorCorner.CornerRadius = UDim.new(0, 8)
            ToggleIndicatorCorner.Parent = ToggleIndicator

            local ToggleButtonClick = Instance.new("TextButton")
            ToggleButtonClick.Parent = ToggleFrame
            ToggleButtonClick.BackgroundTransparency = 1
            ToggleButtonClick.Size = UDim2.new(1, 0, 1, 0)
            ToggleButtonClick.Text = ""

            ToggleButtonClick.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                    Position = Toggle.Value and UDim2.new(0.5, 0, 0, 2) or UDim2.new(0, 2, 0, 2),
                    BackgroundColor3 = Toggle.Value and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 60)
                }):Play()
                if config.Callback then
                    config.Callback(Toggle.Value)
                end
            end)

            ToggleButtonClick.MouseEnter:Connect(function()
                TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 150, 255)}):Play()
            end)

            ToggleButtonClick.MouseLeave:Connect(function()
                TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 40)}):Play()
            end)

            function Toggle:Set(value)
                Toggle.Value = value
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                    Position = Toggle.Value and UDim2.new(0.5, 0, 0, 2) or UDim2.new(0, 2, 0, 2),
                    BackgroundColor3 = Toggle.Value and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 60)
                }):Play()
                if config.Callback then
                    config.Callback(Toggle.Value)
                end
            end

            return Toggle
        end

        -- Hàm thêm dropdown
        function Tab:AddDropdown(config)
            local Dropdown = {}
            Dropdown.Value = config.Default or config.Values[1]
            local isOpen = false

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = TabPage
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.BorderSizePixel = 0

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame

            local DropdownStroke = Instance.new("UIStroke")
            DropdownStroke.Color = Color3.fromRGB(40, 40, 40)
            DropdownStroke.Thickness = 1
            DropdownStroke.Parent = DropdownFrame

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.Text = config.Title .. ": " .. Dropdown.Value
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownButton.TextSize = 14
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
            DropdownButton.TextXOffset = 10

            local DropdownArrow = Instance.new("ImageLabel")
            DropdownArrow.Parent = DropdownButton
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Position = UDim2.new(1, -30, 0, 10)
            DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
            DropdownArrow.Image = "rbxassetid://3926305904"
            DropdownArrow.ImageRectOffset = Vector2.new(964, 764)
            DropdownArrow.ImageRectSize = Vector2.new(36, 36)
            DropdownArrow.ImageColor3 = Color3.fromRGB(200, 200, 200)

            local DropdownList = Instance.new("Frame")
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            DropdownList.Position = UDim2.new(0, 0, 1, 5)
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.BorderSizePixel = 0
            DropdownList.ClipsDescendants = true

            local DropdownListCorner = Instance.new("UICorner")
            DropdownListCorner.CornerRadius = UDim.new(0, 6)
            DropdownListCorner.Parent = DropdownList

            local DropdownListStroke = Instance.new("UIStroke")
            DropdownListStroke.Color = Color3.fromRGB(40, 40, 40)
            DropdownListStroke.Thickness = 1
            DropdownListStroke.Parent = DropdownList

            local DropdownListLayout = Instance.new("UIListLayout")
            DropdownListLayout.Parent = DropdownList
            DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownListLayout.Padding = UDim.new(0, 4)

            -- Tạo các mục trong dropdown
            for _, value in pairs(config.Values) do
                local Item = Instance.new("TextButton")
                Item.Parent = DropdownList
                Item.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Item.Size = UDim2.new(1, -4, 0, 30)
                Item.Position = UDim2.new(0, 2, 0, 0)
                Item.Text = value
                Item.Font = Enum.Font.Gotham
                Item.TextColor3 = Color3.fromRGB(200, 200, 200)
                Item.TextSize = 14
                Item.BorderSizePixel = 0

                local ItemCorner = Instance.new("UICorner")
                ItemCorner.CornerRadius = UDim.new(0, 4)
                ItemCorner.Parent = Item

                Item.MouseButton1Click:Connect(function()
                    Dropdown.Value = value
                    DropdownButton.Text = config.Title .. ": " .. Dropdown.Value
                    TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    isOpen = false
                    if config.Callback then
                        config.Callback(Dropdown.Value)
                    end
                end)

                Item.MouseEnter:Connect(function()
                    TweenService:Create(Item, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                end)

                Item.MouseLeave:Connect(function()
                    TweenService:Create(Item, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                end)
            end

            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetSize = isOpen and UDim2.new(1, 0, 0, #config.Values * 34 + 4) or UDim2.new(1, 0, 0, 0)
                TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = targetSize}):Play()
                TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = isOpen and 180 or 0}):Play()
            end)

            DropdownButton.MouseEnter:Connect(function()
                TweenService:Create(DropdownStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 150, 255)}):Play()
            end)

            DropdownButton.MouseLeave:Connect(function()
                TweenService:Create(DropdownStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 40)}):Play()
            end)

            function Dropdown:Set(value)
                Dropdown.Value = value
                DropdownButton.Text = config.Title .. ": " .. Dropdown.Value
                if config.Callback then
                    config.Callback(Dropdown.Value)
                end
            end

            return Dropdown
        end

        return Tab
    end

    -- Hàm thông báo
    function Window:Notify(config)
        local Notification = Instance.new("Frame")
        Notification.Parent = ScreenGui
        Notification.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Notification.Position = UDim2.new(1, -210, 1, -10)
        Notification.Size = UDim2.new(0, 200, 0, 60)
        Notification.BorderSizePixel = 0

        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 6)
        NotifCorner.Parent = Notification

        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = Color3.fromRGB(40, 40, 40)
        NotifStroke.Thickness = 1
        NotifStroke.Parent = Notification

        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Parent = Notification
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.Size = UDim2.new(1, -20, 0, 20)
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.Text = config.Title or "Notification"
        NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left

        local NotifText = Instance.new("TextLabel")
        NotifText.Parent = Notification
        NotifText.BackgroundTransparency = 1
        NotifText.Position = UDim2.new(0, 10, 0, 25)
        NotifText.Size = UDim2.new(1, -20, 0, 30)
        NotifText.Font = Enum.Font.Gotham
        NotifText.Text = config.Content or "Message"
        NotifText.TextColor3 = Color3.fromRGB(200, 200, 200)
        NotifText.TextSize = 12
        NotifText.TextXAlignment = Enum.TextXAlignment.Left

        spawn(function()
            wait(config.Duration or 5)
            TweenService:Create(Notification, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 1, -10)}):Play()
            wait(0.5)
            Notification:Destroy()
        end)

        TweenService:Create(Notification, TweenInfo.new(0.5), {Position = UDim2.new(1, -210, 1, -10)}):Play()
    end

    return Window
end

-- Tạo ImageButton để bật/tắt UI
function GrokUI:CreateToggleButton(config)
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleButtonGui"
    ToggleGui.Parent = CoreGui

    local ImageButton = Instance.new("ImageButton")
    ImageButton.Parent = ToggleGui
    ImageButton.Position = config.Position or UDim2.new(0.1, 0, 0.1, 0)
    ImageButton.Size = config.Size or UDim2.new(0, 50, 0, 50)
    ImageButton.BackgroundTransparency = 1
    ImageButton.Image = config.Image or "rbxassetid://92984205310992"
    ImageButton.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = ImageButton

    local window = config.Window
    ImageButton.MouseButton1Click:Connect(function()
        window:Toggle()
    end)

    return ImageButton
end

-- Trả về GrokUI để sử dụng
return GrokUI
