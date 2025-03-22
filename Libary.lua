local NovaUI = loadstring([[
    local NovaUI = {}

    -- Hàm tạo Window
    function NovaUI:CreateWindow(options)
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "NovaUI"
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        ScreenGui.ResetOnSpawn = false

        local Window = Instance.new("Frame")
        Window.Size = options.Size or UDim2.new(0, 550, 0, 450)
        Window.Position = UDim2.new(0.5, -(Window.Size.X.Offset / 2), 0.5, -(Window.Size.Y.Offset / 2))
        Window.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Window.BorderSizePixel = 0
        Window.Parent = ScreenGui

        local WindowCorner = Instance.new("UICorner")
        WindowCorner.CornerRadius = UDim.new(0, 10)
        WindowCorner.Parent = Window

        local TitleBar = Instance.new("Frame")
        TitleBar.Size = UDim2.new(1, 0, 0, 35)
        TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        TitleBar.BorderSizePixel = 0
        TitleBar.Parent = Window
        
        local TitleBar = Instance.new("Frame")
        TitleBar.Size = UDim2.new(1, 0, 0, 35)
        TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        TitleBar.BorderSizePixel = 0
        TitleBar.Parent = Window

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -50, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = options.Title or "NovaUI"
        Title.TextColor3 = Color3.fromRGB(200, 200, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 18
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = TitleBar

        local TabsContainer = Instance.new("Frame")
        TabsContainer.Size = UDim2.new(1, -10, 1, -45)
        TabsContainer.Position = UDim2.new(0, 5, 0, 40)
        TabsContainer.BackgroundTransparency = 1
        TabsContainer.Parent = Window

        local Tabs = {}
        
        local function AddNotification(noteOptions)
            local NoteFrame = Instance.new("Frame")
            NoteFrame.Size = UDim2.new(0, 250, 0, 80)
            NoteFrame.Position = UDim2.new(1, -260, 1, -90)
            NoteFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            NoteFrame.BorderSizePixel = 0
            NoteFrame.Parent = ScreenGui

            local NoteCorner = Instance.new("UICorner")
            NoteCorner.CornerRadius = UDim.new(0, 6)
            NoteCorner.Parent = NoteFrame

            local NoteTitle = Instance.new("TextLabel")
            NoteTitle.Size = UDim2.new(1, -10, 0, 20)
            NoteTitle.Position = UDim2.new(0, 5, 0, 5)
            NoteTitle.BackgroundTransparency = 1
            NoteTitle.Text = noteOptions.Title or "Notification"
            NoteTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
            NoteTitle.Font = Enum.Font.SourceSansBold
            NoteTitle.TextSize = 16
            NoteTitle.Parent = NoteFrame

            local NoteDesc = Instance.new("TextLabel")
            NoteDesc.Size = UDim2.new(1, -10, 0, 40)
            NoteDesc.Position = UDim2.new(0, 5, 0, 25)
            NoteDesc.BackgroundTransparency = 1
            NoteDesc.Text = noteOptions.Description or "This is a notification."
            NoteDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
            NoteDesc.Font = Enum.Font.SourceSans
            NoteDesc.TextSize = 14
            NoteDesc.TextWrapped = true
            NoteDesc.Parent = NoteFrame

            wait(noteOptions.Duration or 3)
            NoteFrame:Destroy()
        end
        
        function Tabs:AddTab(tabOptions)
            local Tab = {}
            local TabButton = Instance.new("TextButton")
            TabButton.Size = UDim2.new(0, tabOptions.TabWidth or 130, 0, 35)
            TabButton.Position = UDim2.new(0, #Tabs * (tabOptions.TabWidth or 130), 0, 0)
            TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            TabButton.BorderSizePixel = 0
            TabButton.Text = tabOptions.Title or "Tab"
            TabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
            TabButton.Font = Enum.Font.SourceSansBold
            TabButton.TextSize = 16
            TabButton.Parent = TitleBar

            local TabCorner = Instance.new("UICorner")
            TabCorner.CornerRadius = UDim.new(0, 5)
            TabCorner.Parent = TabButton

            local TabContent = Instance.new("Frame")
            TabContent.Size = UDim2.new(1, 0, 1, 0)
            TabContent.BackgroundTransparency = 1
            TabContent.Visible = false
            TabContent.Parent = TabsContainer

            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 8)
            ContentLayout.Parent = TabContent
            
            -- Chuyển đổi Tab
            TabButton.MouseButton1Click:Connect(function()
                for _, tab in pairs(Tabs) do
                    tab.Content.Visible = false
                    tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                end
                TabContent.Visible = true
                TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end)

            -- Hàm thêm Button
            function Tab:AddButton(btnOptions)
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, -10, 0, 40)
                Button.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
                Button.BorderSizePixel = 0
                Button.Text = btnOptions.Title or "Button"
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.Font = Enum.Font.SourceSans
                Button.TextSize = 16
                Button.Parent = TabContent

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button

                Button.MouseButton1Click:Connect(btnOptions.Callback or function()
                    print("NovaUI Button: " .. btnOptions.Title)
                end)
            end
            
            function Tab:AddToggle(toggleId, toggleOptions)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = TabContent

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(0.75, 0, 1, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleOptions.Title or "Toggle"
                ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
                ToggleLabel.Font = Enum.Font.SourceSans
                ToggleLabel.TextSize = 16
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 35, 0, 20)
                ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
                ToggleButton.BackgroundColor3 = toggleOptions.Default and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(80, 80, 80)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 5)
                ToggleCorner.Parent = ToggleButton

                local state = toggleOptions.Default or false
                ToggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    ToggleButton.BackgroundColor3 = state and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(80, 80, 80)
                    if toggleOptions.Callback then toggleOptions.Callback(state) end
                end)
            end

            -- Hàm thêm Slider
            function Tab:AddSlider(sliderId, sliderOptions)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, -10, 0, 60)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = TabContent

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, 0, 0, 20)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = sliderOptions.Title or "Slider"
                SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
                SliderLabel.Font = Enum.Font.SourceSans
                SliderLabel.TextSize = 16
                SliderLabel.Parent = SliderFrame

                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, 0, 0, 12)
                SliderBar.Position = UDim2.new(0, 0, 0, 30)
                SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = SliderFrame

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((sliderOptions.Default - sliderOptions.Min) / (sliderOptions.Max - sliderOptions.Min), 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
                Fill.BorderSizePixel = 0
                Fill.Parent = SliderBar
                
                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(0, 6)
                BarCorner.Parent = SliderBar
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 6)
                FillCorner.Parent = Fill

                local value = sliderOptions.Default or sliderOptions.Min
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mouse = game.Players.LocalPlayer:GetMouse()
                        local connection
                        connection = mouse.Move:Connect(function()
                            local percent = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                            value = sliderOptions.Min + (sliderOptions.Max - sliderOptions.Min) * percent
                            Fill.Size = UDim2.new(percent, 0, 1, 0)
                            if sliderOptions.Callback then sliderOptions.Callback(value) end
                        end)
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                connection:Disconnect()
                            end
                        end)
                    end
                end)
            end
            
            
            function Tab:AddDropdown(dropdownId, dropdownOptions)
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Parent = TabContent

                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = dropdownOptions.Title or "Dropdown"
                DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
                DropdownLabel.Font = Enum.Font.SourceSans
                DropdownLabel.TextSize = 16
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(0, 150, 0, 30)
                DropdownButton.Position = UDim2.new(1, -155, 0.5, -15)
                DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Text = dropdownOptions.Default or "Select..."
                DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownButton.Font = Enum.Font.SourceSans
                DropdownButton.TextSize = 14
                DropdownButton.Parent = DropdownFrame
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = DropdownButton

                local OptionsFrame = Instance.new("Frame")
                OptionsFrame.Size = UDim2.new(0, 150, 0, 0)
                OptionsFrame.Position = UDim2.new(1, -155, 0, 35)
                OptionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                OptionsFrame.BorderSizePixel = 0
                OptionsFrame.Visible = false
                OptionsFrame.Parent = DropdownFrame

                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Parent = OptionsFrame

                local isOpen = false
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    OptionsFrame.Visible = isOpen
                    OptionsFrame.Size = isOpen and UDim2.new(0, 150, 0, math.min(#dropdownOptions.Options * 30, 120)) or UDim2.new(0, 150, 0, 0)
                end)
                
                for _, option in pairs(dropdownOptions.Options or {}) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.Font = Enum.Font.SourceSans
                    OptionButton.TextSize = 14
                    OptionButton.Parent = OptionsFrame

                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = option
                        OptionsFrame.Visible = false
                        isOpen = false
                        if dropdownOptions.Callback then dropdownOptions.Callback(option) end
                    end)
                end
            end
            
            function Tab:AddTextbox(textboxId, textboxOptions)
                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Size = UDim2.new(1, -10, 0, 40)
                TextboxFrame.BackgroundTransparency = 1
                TextboxFrame.Parent = TabContent

                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Size = UDim2.new(0.5, 0, 1, 0)
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Text = textboxOptions.Title or "Textbox"
                TextboxLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
                TextboxLabel.Font = Enum.Font.SourceSans
                TextboxLabel.TextSize = 16
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextboxLabel.Parent = TextboxFrame

                local Textbox = Instance.new("TextBox")
                Textbox.Size = UDim2.new(0, 150, 0, 30)
                Textbox.Position = UDim2.new(1, -155, 0.5, -15)
                Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                Textbox.BorderSizePixel = 0
                Textbox.Text = textboxOptions.Default or ""
                Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                Textbox.Font = Enum.Font.SourceSans
                Textbox.TextSize = 14
                Textbox.Parent = TextboxFrame
                
                local TextboxCorner = Instance.new("UICorner")
                TextboxCorner.CornerRadius = UDim.new(0, 6)
                TextboxCorner.Parent = Textbox

                Textbox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and textboxOptions.Callback then
                        textboxOptions.Callback(Textbox.Text)
                    end
                end)
            end

            -- Hàm thêm Keybind
            function Tab:AddKeybind(keybindId, keybindOptions)
                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Size = UDim2.new(1, -10, 0, 40)
                KeybindFrame.BackgroundTransparency = 1
                KeybindFrame.Parent = TabContent

                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Size = UDim2.new(0.5, 0, 1, 0)
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Text = keybindOptions.Title or "Keybind"
                KeybindLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
                KeybindLabel.Font = Enum.Font.SourceSans
                KeybindLabel.TextSize = 16
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                KeybindLabel.Parent = KeybindFrame
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Size = UDim2.new(0, 80, 0, 30)
                KeybindButton.Position = UDim2.new(1, -85, 0.5, -15)
                KeybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                KeybindButton.BorderSizePixel = 0
                KeybindButton.Text = keybindOptions.Default and keybindOptions.Default.Name or "None"
                KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindButton.Font = Enum.Font.SourceSans
                KeybindButton.TextSize = 14
                KeybindButton.Parent = KeybindFrame

                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 6)
                KeybindCorner.Parent = KeybindButton

                local key = keybindOptions.Default
                local waiting = false
                KeybindButton.MouseButton1Click:Connect(function()
                    waiting = true
                    KeybindButton.Text = "Press a key..."
                end)

                game:GetService("UserInputService").InputBegan:Connect(function(input)
                    if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        KeybindButton.Text = key.Name
                        waiting = false
                        if keybindOptions.Callback then keybindOptions.Callback(key) end
                    end
                end)
            end
            
            function Tab:AddLabel(labelOptions)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -10, 0, 30)
                Label.BackgroundTransparency = 1
                Label.Text = labelOptions.Text or "Label"
                Label.TextColor3 = Color3.fromRGB(220, 220, 255)
                Label.Font = Enum.Font.SourceSans
                Label.TextSize = 16
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = TabContent
            end

            -- Hàm thêm Notification (gắn vào Tab để gọi từ ngoài)
            Tab.AddNotification = AddNotification

            Tab.Button = TabButton
            Tab.Content = TabContent
            table.insert(Tabs, Tab)
            if #Tabs == 1 then -- Hiển thị tab đầu tiên mặc định
                TabContent.Visible = true
                TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end
            return Tab
        end

        return Tabs
    end

    return NovaUI
]])()

-- Ví dụ sử dụng
local Window = NovaUI:CreateWindow({
    Title = "NovaUI - Full Features",
    Size = UDim2.new(0, 550, 0, 450)
})

local MainTab = Window:AddTab({
    Title = "Main",
    TabWidth = 130
})

MainTab:AddButton({
    Title = "Test Button",
    Callback = function()
        print("NovaUI: Button clicked!")
    end
})