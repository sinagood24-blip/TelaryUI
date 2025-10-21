--[[
   Custom GUI Library - Rayfield Style
   Created by ScriptHub
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local CustomUILibrary = {}
CustomUILibrary.__index = CustomUILibrary

-- Цветовая схема
local Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(85, 255, 85),
    Warning = Color3.fromRGB(255, 170, 0),
    Error = Color3.fromRGB(255, 85, 85)
}

-- Утилиты
local function Tween(Object, Properties, Duration)
    local Tween = TweenService:Create(Object, TweenInfo.new(Duration or 0.3), Properties)
    Tween:Play()
    return Tween
end

local function RoundCorners(Object, CornerRadius)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, CornerRadius or 8)
    UICorner.Parent = Object
    return UICorner
end

-- Создание окна
function CustomUILibrary:CreateWindow(Config)
    Config = Config or {}
    
    local Window = {}
    setmetatable(Window, CustomUILibrary)
    
    -- Создаем основной GUI
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "CustomUILibrary"
    Window.ScreenGui.Parent = CoreGui
    
    -- Главный фрейм
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Size = Config.Size or UDim2.new(0, 500, 0, 450)
    Window.MainFrame.Position = Config.Center and UDim2.new(0.5, -Window.MainFrame.Size.X.Offset/2, 0.5, -Window.MainFrame.Size.Y.Offset/2) or (Config.Position or UDim2.new(0, 100, 0, 100))
    Window.MainFrame.BackgroundColor3 = Theme.Background
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Parent = Window.ScreenGui
    RoundCorners(Window.MainFrame, 12)
    
    -- Тень
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.Parent = Window.MainFrame
    
    -- Заголовок
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    Window.TitleBar.BackgroundColor3 = Theme.Secondary
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.Parent = Window.MainFrame
    RoundCorners(Window.TitleBar, 12)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "Custom UI"
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Window.TitleBar
    
    -- Кнопка закрытия
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Theme.Error
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Window.TitleBar
    RoundCorners(CloseButton, 6)
    
    CloseButton.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)
    
    -- Контейнер для вкладок
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Size = UDim2.new(1, 0, 1, -40)
    Window.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    Window.TabContainer.BackgroundTransparency = 1
    Window.TabContainer.Parent = Window.MainFrame
    
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Функционал перетаскивания
    if Config.Draggable ~= false then
        local Dragging, DragInput, DragStart, StartPos
        
        local function Update(input)
            local Delta = input.Position - DragStart
            Window.MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
        
        Window.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = input.Position
                StartPos = Window.MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        
        Window.TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                DragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                Update(input)
            end
        end)
    end
    
    -- Анимация появления
    Window.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Tween(Window.MainFrame, {Size = Config.Size or UDim2.new(0, 500, 0, 450)}, 0.5)
    
    function Window:CreateTab(Name, Icon)
        local Tab = {}
        Tab.Name = Name
        
        -- Кнопка вкладки
        Tab.Button = Instance.new("TextButton")
        Tab.Button.Size = UDim2.new(0, 120, 0, 35)
        Tab.Button.Position = UDim2.new(0, 10 + (#Window.Tabs * 130), 0, -35)
        Tab.Button.BackgroundColor3 = Theme.Secondary
        Tab.Button.Text = (Icon or "📁") .. " " .. Name
        Tab.Button.TextColor3 = Theme.Text
        Tab.Button.TextSize = 14
        Tab.Button.Font = Enum.Font.Gotham
        Tab.Button.Parent = Window.MainFrame
        RoundCorners(Tab.Button, 8)
        
        -- Контент вкладки
        Tab.Content = Instance.new("ScrollingFrame")
        Tab.Content.Size = UDim2.new(1, -20, 1, -20)
        Tab.Content.Position = UDim2.new(0, 10, 0, 10)
        Tab.Content.BackgroundTransparency = 1
        Tab.Content.ScrollBarThickness = 5
        Tab.Content.ScrollBarImageColor3 = Theme.Accent
        Tab.Content.Visible = false
        Tab.Content.Parent = Window.TabContainer
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.Parent = Tab.Content
        
        Tab.Sections = {}
        
        function Tab:CreateSection(Name)
            local Section = {}
            
            Section.Frame = Instance.new("Frame")
            Section.Frame.Size = UDim2.new(1, 0, 0, 0)
            Section.Frame.BackgroundColor3 = Theme.Secondary
            Section.Frame.BorderSizePixel = 0
            Section.Frame.Parent = Tab.Content
            RoundCorners(Section.Frame, 8)
            
            Section.Title = Instance.new("TextLabel")
            Section.Title.Size = UDim2.new(1, -20, 0, 30)
            Section.Title.Position = UDim2.new(0, 10, 0, 0)
            Section.Title.BackgroundTransparency = 1
            Section.Title.Text = "📂 " .. Name
            Section.Title.TextColor3 = Theme.Text
            Section.Title.TextSize = 16
            Section.Title.Font = Enum.Font.GothamBold
            Section.Title.TextXAlignment = Enum.TextXAlignment.Left
            Section.Title.Parent = Section.Frame
            
            Section.Content = Instance.new("Frame")
            Section.Content.Size = UDim2.new(1, -20, 0, 0)
            Section.Content.Position = UDim2.new(0, 10, 0, 35)
            Section.Content.BackgroundTransparency = 1
            Section.Content.Parent = Section.Frame
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Padding = UDim.new(0, 8)
            SectionList.Parent = Section.Content
            
            Section.Elements = {}
            
            function Section:CreateButton(Config)
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = Theme.Accent
                Button.Text = Config.Title or "Button"
                Button.TextColor3 = Theme.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.Gotham
                Button.Parent = Section.Content
                RoundCorners(Button, 6)
                
                Button.MouseButton1Click:Connect(function()
                    if Config.Callback then
                        Config.Callback()
                    end
                end)
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = Color3.fromRGB(20, 130, 230)})
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.Accent})
                end)
                
                Section.Elements[#Section.Elements + 1] = Button
                Section:UpdateSize()
                
                return Button
            end
            
            function Section:CreateToggle(Config)
                local Toggle = {}
                Toggle.Value = Config.Default or false
                
                Toggle.Frame = Instance.new("Frame")
                Toggle.Frame.Size = UDim2.new(1, 0, 0, 35)
                Toggle.Frame.BackgroundTransparency = 1
                Toggle.Frame.Parent = Section.Content
                
                Toggle.Button = Instance.new("TextButton")
                Toggle.Button.Size = UDim2.new(1, 0, 1, 0)
                Toggle.Button.BackgroundColor3 = Toggle.Value and Theme.Success or Color3.fromRGB(80, 80, 100)
                Toggle.Button.Text = (Toggle.Value and "✅ " or "❌ ") .. (Config.Title or "Toggle")
                Toggle.Button.TextColor3 = Theme.Text
                Toggle.Button.TextSize = 14
                Toggle.Button.Font = Enum.Font.Gotham
                Toggle.Button.Parent = Toggle.Frame
                RoundCorners(Toggle.Button, 6)
                
                Toggle.Button.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    Toggle.Button.BackgroundColor3 = Toggle.Value and Theme.Success or Color3.fromRGB(80, 80, 100)
                    Toggle.Button.Text = (Toggle.Value and "✅ " or "❌ ") .. (Config.Title or "Toggle")
                    
                    if Config.Callback then
                        Config.Callback(Toggle.Value)
                    end
                end)
                
                Section.Elements[#Section.Elements + 1] = Toggle.Frame
                Section:UpdateSize()
                
                return Toggle
            end
            
            function Section:CreateSlider(Config)
                local Slider = {}
                Slider.Value = Config.Default or Config.Min or 0
                
                Slider.Frame = Instance.new("Frame")
                Slider.Frame.Size = UDim2.new(1, 0, 0, 60)
                Slider.Frame.BackgroundTransparency = 1
                Slider.Frame.Parent = Section.Content
                
                Slider.Title = Instance.new("TextLabel")
                Slider.Title.Size = UDim2.new(1, 0, 0, 20)
                Slider.Title.BackgroundTransparency = 1
                Slider.Title.Text = Config.Title or "Slider: " .. Slider.Value
                Slider.Title.TextColor3 = Theme.Text
                Slider.Title.TextSize = 14
                Slider.Title.Font = Enum.Font.Gotham
                Slider.Title.TextXAlignment = Enum.TextXAlignment.Left
                Slider.Title.Parent = Slider.Frame
                
                Slider.Track = Instance.new("Frame")
                Slider.Track.Size = UDim2.new(1, 0, 0, 6)
                Slider.Track.Position = UDim2.new(0, 0, 0, 30)
                Slider.Track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                Slider.Track.Parent = Slider.Frame
                RoundCorners(Slider.Track, 3)
                
                Slider.Fill = Instance.new("Frame")
                Slider.Fill.Size = UDim2.new((Slider.Value - (Config.Min or 0)) / ((Config.Max or 100) - (Config.Min or 0)), 0, 1, 0)
                Slider.Fill.BackgroundColor3 = Theme.Accent
                Slider.Fill.Parent = Slider.Track
                RoundCorners(Slider.Fill, 3)
                
                Slider.Handle = Instance.new("TextButton")
                Slider.Handle.Size = UDim2.new(0, 16, 0, 16)
                Slider.Handle.Position = UDim2.new(Slider.Fill.Size.X.Scale, -8, 0.5, -8)
                Slider.Handle.BackgroundColor3 = Theme.Text
                Slider.Handle.Text = ""
                Slider.Handle.Parent = Slider.Track
                RoundCorners(Slider.Handle, 8)
                
                local Dragging = false
                
                local function UpdateSlider(Value)
                    local Min = Config.Min or 0
                    local Max = Config.Max or 100
                    local Normalized = math.clamp((Value - Min) / (Max - Min), 0, 1)
                    
                    Slider.Value = math.floor(Value)
                    Slider.Fill.Size = UDim2.new(Normalized, 0, 1, 0)
                    Slider.Handle.Position = UDim2.new(Normalized, -8, 0.5, -8)
                    Slider.Title.Text = Config.Title or "Slider: " .. Slider.Value
                    
                    if Config.Callback then
                        Config.Callback(Slider.Value)
                    end
                end
                
                Slider.Handle.MouseButton1Down:Connect(function()
                    Dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)
                
                Slider.Track.MouseButton1Down:Connect(function(X, Y)
                    local RelativeX = X - Slider.Track.AbsolutePosition.X
                    local Percent = math.clamp(RelativeX / Slider.Track.AbsoluteSize.X, 0, 1)
                    local Value = ((Config.Max or 100) - (Config.Min or 0)) * Percent + (Config.Min or 0)
                    UpdateSlider(Value)
                end)
                
                UserInputService.InputChanged:Connect(function(Input)
                    if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local Mouse = UserInputService:GetMouseLocation()
                        local RelativeX = Mouse.X - Slider.Track.AbsolutePosition.X
                        local Percent = math.clamp(RelativeX / Slider.Track.AbsoluteSize.X, 0, 1)
                        local Value = ((Config.Max or 100) - (Config.Min or 0)) * Percent + (Config.Min or 0)
                        UpdateSlider(Value)
                    end
                end)
                
                Section.Elements[#Section.Elements + 1] = Slider.Frame
                Section:UpdateSize()
                
                return Slider
            end
            
            function Section:CreateDropdown(Config)
                local Dropdown = {}
                Dropdown.Open = false
                Dropdown.Options = Config.Options or {}
                Dropdown.Selected = Config.Default or ""
                
                Dropdown.Frame = Instance.new("Frame")
                Dropdown.Frame.Size = UDim2.new(1, 0, 0, 35)
                Dropdown.Frame.BackgroundTransparency = 1
                Dropdown.Frame.Parent = Section.Content
                
                Dropdown.Button = Instance.new("TextButton")
                Dropdown.Button.Size = UDim2.new(1, 0, 0, 35)
                Dropdown.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                Dropdown.Button.Text = "▼ " .. (Dropdown.Selected ~= "" and Dropdown.Selected or (Config.Title or "Select"))
                Dropdown.Button.TextColor3 = Theme.Text
                Dropdown.Button.TextSize = 14
                Dropdown.Button.Font = Enum.Font.Gotham
                Dropdown.Button.Parent = Dropdown.Frame
                RoundCorners(Dropdown.Button, 6)
                
                Dropdown.List = Instance.new("Frame")
                Dropdown.List.Size = UDim2.new(1, 0, 0, 0)
                Dropdown.List.Position = UDim2.new(0, 0, 0, 40)
                Dropdown.List.BackgroundColor3 = Theme.Secondary
                Dropdown.List.Visible = false
                Dropdown.List.Parent = Dropdown.Frame
                RoundCorners(Dropdown.List, 6)
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Parent = Dropdown.List
                
                function Dropdown:Refresh(NewOptions, KeepCurrent)
                    Dropdown.Options = NewOptions or Dropdown.Options
                    
                    -- Очищаем старые кнопки
                    for _, Child in pairs(Dropdown.List:GetChildren()) do
                        if Child:IsA("TextButton") then
                            Child:Destroy()
                        end
                    end
                    
                    -- Создаем новые кнопки
                    for _, Option in pairs(Dropdown.Options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Size = UDim2.new(1, 0, 0, 30)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
                        OptionButton.Text = Option
                        OptionButton.TextColor3 = Theme.Text
                        OptionButton.TextSize = 12
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.Parent = Dropdown.List
                        RoundCorners(OptionButton, 4)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            Dropdown.Selected = Option
                            Dropdown.Button.Text = "▼ " .. Option
                            Dropdown.Open = false
                            Dropdown.List.Visible = false
                            
                            if Config.Callback then
                                Config.Callback(Option)
                            end
                        end)
                    end
                    
                    Dropdown.List.Size = UDim2.new(1, 0, 0, #Dropdown.Options * 30)
                end
                
                Dropdown.Button.MouseButton1Click:Connect(function()
                    Dropdown.Open = not Dropdown.Open
                    Dropdown.List.Visible = Dropdown.Open
                    Dropdown.Button.Text = (Dropdown.Open and "▲ " or "▼ ") .. (Dropdown.Selected ~= "" and Dropdown.Selected or (Config.Title or "Select"))
                end)
                
                -- Инициализация
                Dropdown:Refresh()
                
                Section.Elements[#Section.Elements + 1] = Dropdown.Frame
                Section:UpdateSize()
                
                return Dropdown
            end
            
            function Section:UpdateSize()
                local TotalHeight = 40 -- Заголовок + отступы
                for _, Element in pairs(Section.Elements) do
                    TotalHeight += Element.Size.Y.Offset + 8
                end
                Section.Frame.Size = UDim2.new(1, 0, 0, TotalHeight)
                Section.Content.Size = UDim2.new(1, 0, 0, TotalHeight - 40)
            end
            
            Section:UpdateSize()
            Tab.Sections[#Tab.Sections + 1] = Section
            
            return Section
        end
        
        function Tab:Show()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                Tween(Window.CurrentTab.Button, {BackgroundColor3 = Theme.Secondary})
            end
            
            Window.CurrentTab = Tab
            Tab.Content.Visible = true
            Tween(Tab.Button, {BackgroundColor3 = Theme.Accent})
        end
        
        Tab.Button.MouseButton1Click:Connect(function()
            Tab:Show()
        end)
        
        Window.Tabs[#Window.Tabs + 1] = Tab
        
        if #Window.Tabs == 1 then
            Tab:Show()
        end
        
        return Tab
    end
    
    function Window:Notify(Config)
        local NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Parent = CoreGui
        
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Size = UDim2.new(0, 300, 0, 70)
        NotifyFrame.Position = UDim2.new(1, -320, 0, 20)
        NotifyFrame.BackgroundColor3 = Theme.Secondary
        NotifyFrame.Parent = NotifyGui
        RoundCorners(NotifyFrame, 8)
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -20, 0, 25)
        Title.Position = UDim2.new(0, 10, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = Config.Title or "Notification"
        Title.TextColor3 = Theme.Text
        Title.TextSize = 16
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = NotifyFrame
        
        local Content = Instance.new("TextLabel")
        Content.Size = UDim2.new(1, -20, 0, 30)
        Content.Position = UDim2.new(0, 10, 0, 35)
        Content.BackgroundTransparency = 1
        Content.Text = Config.Content or ""
        Content.TextColor3 = Theme.Text
        Content.TextSize = 14
        Content.Font = Enum.Font.Gotham
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextYAlignment = Enum.TextYAlignment.Top
        Content.Parent = NotifyFrame
        
        -- Анимация появления
        NotifyFrame.Position = UDim2.new(1, 300, 0, 20)
        Tween(NotifyFrame, {Position = UDim2.new(1, -320, 0, 20)}, 0.5)
        
        wait(Config.Duration or 5)
        
        -- Анимация исчезновения
        Tween(NotifyFrame, {Position = UDim2.new(1, 300, 0, 20)}, 0.5)
        wait(0.5)
        NotifyGui:Destroy()
    end
    
    function Window:Destroy()
        self.ScreenGui:Destroy()
    end
    
    -- Первое уведомление
    Window:Notify({
        Title = "Custom UI Library",
        Content = "Библиотека успешно загружена!",
        Duration = 4
    })
    
    return Window
end

return CustomUILibrary
