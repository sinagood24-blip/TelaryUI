--[[
   Telary UI Library v2.0
   Enhanced Edition - Modern UI Library for Roblox
   Features: Themes, Animations, New Elements, Better Performance
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local TelaryUI = {}
TelaryUI.__index = TelaryUI

-- Расширенная цветовая схема с темами
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(85, 255, 85),
        Warning = Color3.fromRGB(255, 170, 0),
        Error = Color3.fromRGB(255, 85, 85),
        Border = Color3.fromRGB(60, 60, 80)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Secondary = Color3.fromRGB(225, 225, 235),
        Accent = Color3.fromRGB(0, 120, 215),
        Text = Color3.fromRGB(30, 30, 30),
        Success = Color3.fromRGB(45, 200, 45),
        Warning = Color3.fromRGB(215, 140, 0),
        Error = Color3.fromRGB(215, 45, 45),
        Border = Color3.fromRGB(200, 200, 210)
    },
    Purple = {
        Background = Color3.fromRGB(30, 25, 45),
        Secondary = Color3.fromRGB(45, 35, 65),
        Accent = Color3.fromRGB(170, 85, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(85, 255, 85),
        Warning = Color3.fromRGB(255, 170, 0),
        Error = Color3.fromRGB(255, 85, 85),
        Border = Color3.fromRGB(70, 60, 90)
    }
}

-- Утилиты
local function Tween(Object, Properties, Duration, Style)
    local TweenInfo = TweenInfo.new(Duration or 0.3, Style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Tween = TweenService:Create(Object, TweenInfo, Properties)
    Tween:Play()
    return Tween
end

local function RoundCorners(Object, CornerRadius)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, CornerRadius or 8)
    UICorner.Parent = Object
    return UICorner
end

local function CreateShadow(Object)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.Parent = Object
    return Shadow
end

-- Новый класс для управления конфигурацией
local Configuration = {
    CurrentTheme = "Dark",
    SaveSettings = false,
    SettingsKey = "TelaryUI_Settings"
}

function Configuration:Save()
    if not self.SaveSettings then return end
    
    local data = {
        Theme = self.CurrentTheme,
        Windows = {}
    }
    
    -- Сохраняем позиции окон и т.д.
    for _, window in pairs(TelaryUI.Windows or {}) do
        if window and window.MainFrame then
            data.Windows[window.ID] = {
                Position = window.MainFrame.Position,
                Visible = window.MainFrame.Visible
            }
        end
    end
    
    pcall(function()
        writefile(self.SettingsKey .. ".json", HttpService:JSONEncode(data))
    end)
end

function Configuration:Load()
    if not self.SaveSettings then return end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(self.SettingsKey .. ".json"))
    end)
    
    if success and data then
        self.CurrentTheme = data.Theme or "Dark"
        return data
    end
    return nil
end

-- Система анимаций
local Animations = {
    Hover = function(Object)
        Object.MouseEnter:Connect(function()
            Tween(Object, {BackgroundColor3 = Object.BackgroundColor3:Lerp(Color3.new(1, 1, 1), 0.1)})
        end)
        
        Object.MouseLeave:Connect(function()
            Tween(Object, {BackgroundColor3 = Themes[Configuration.CurrentTheme].Accent})
        end)
    end,
    
    Pulse = function(Object)
        local pulse = Instance.new("UIScale")
        pulse.Parent = Object
        
        coroutine.wrap(function()
            while Object and Object.Parent do
                Tween(pulse, {Scale = 1.05}, 0.5, Enum.EasingStyle.Quad)
                wait(0.5)
                Tween(pulse, {Scale = 1}, 0.5, Enum.EasingStyle.Quad)
                wait(2)
            end
        end)()
    end,
    
    Shake = function(Object, Intensity)
        local startPos = Object.Position
        for i = 1, 5 do
            local offset = UDim2.new(0, math.random(-Intensity, Intensity), 0, math.random(-Intensity, Intensity))
            Tween(Object, {Position = startPos + offset}, 0.05)
            wait(0.05)
        end
        Tween(Object, {Position = startPos}, 0.1)
    end
}

-- Создание окна с улучшенным дизайном
function TelaryUI:CreateWindow(Config)
    Config = Config or {}
    
    local Window = setmetatable({}, TelaryUI)
    Window.ID = HttpService:GenerateGUID(false)
    Window.Theme = Themes[Configuration.CurrentTheme]
    
    -- Инициализация окон
    if not TelaryUI.Windows then TelaryUI.Windows = {} end
    table.insert(TelaryUI.Windows, Window)
    
    -- Создаем основной GUI
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "TelaryUI_" .. Window.ID
    Window.ScreenGui.Parent = CoreGui
    Window.ScreenGui.ResetOnSpawn = false
    
    -- Главный контейнер
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Size = Config.Size or UDim2.new(0, 550, 0, 600)
    Window.MainFrame.Position = Config.Center and UDim2.new(0.5, -Window.MainFrame.Size.X.Offset/2, 0.5, -Window.MainFrame.Size.Y.Offset/2) or (Config.Position or UDim2.new(0, 100, 0, 100))
    Window.MainFrame.BackgroundColor3 = Window.Theme.Background
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Parent = Window.ScreenGui
    RoundCorners(Window.MainFrame, 12)
    
    -- Улучшенная тень
    CreateShadow(Window.MainFrame)
    
    -- Заголовок с градиентом
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    Window.TitleBar.BackgroundColor3 = Window.Theme.Secondary
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.Parent = Window.MainFrame
    RoundCorners(Window.TitleBar, 12)
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Window.Theme.Accent),
        ColorSequenceKeypoint.new(1, Window.Theme.Secondary)
    })
    TitleGradient.Rotation = 90
    TitleGradient.Parent = Window.TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "Telary UI v2.0"
    TitleLabel.TextColor3 = Window.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Window.TitleBar
    
    -- Кнопки управления окном
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 7)
    CloseButton.BackgroundColor3 = Window.Theme.Error
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Window.Theme.Text
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Window.TitleBar
    RoundCorners(CloseButton, 6)
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 7)
    MinimizeButton.BackgroundColor3 = Window.Theme.Warning
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Window.Theme.Text
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = Window.TitleBar
    RoundCorners(MinimizeButton, 6)
    
    -- Контейнер для вкладок
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Size = UDim2.new(1, 0, 1, -45)
    Window.TabContainer.Position = UDim2.new(0, 0, 0, 45)
    Window.TabContainer.BackgroundTransparency = 1
    Window.TabContainer.Parent = Window.MainFrame
    
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    
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
    
    -- Обработчики кнопок
    CloseButton.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)
    
    -- Анимация появления
    Window.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Tween(Window.MainFrame, {Size = Config.Size or UDim2.new(0, 550, 0, 600)}, 0.5, Enum.EasingStyle.Back)
    
    -- НОВЫЕ МЕТОДЫ ОКНА
    
    function Window:Minimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            Tween(self.MainFrame, {Size = UDim2.new(0, 200, 0, 45)}, 0.3)
            self.TabContainer.Visible = false
        else
            Tween(self.MainFrame, {Size = Config.Size or UDim2.new(0, 550, 0, 600)}, 0.3)
            self.TabContainer.Visible = true
        end
    end
    
    function Window:ChangeTheme(ThemeName)
        if Themes[ThemeName] then
            Configuration.CurrentTheme = ThemeName
            self.Theme = Themes[ThemeName]
            self:UpdateTheme()
        end
    end
    
    function Window:UpdateTheme()
        -- Обновляем цвета всех элементов
        self.MainFrame.BackgroundColor3 = self.Theme.Background
        self.TitleBar.BackgroundColor3 = self.Theme.Secondary
        
        -- Обновляем градиент
        local gradient = self.TitleBar:FindFirstChildOfClass("UIGradient")
        if gradient then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, self.Theme.Accent),
                ColorSequenceKeypoint.new(1, self.Theme.Secondary)
            })
        end
    end
    
    function Window:CreateTab(Name, Icon)
        local Tab = {}
        Tab.Name = Name
        Tab.Window = self
        
        -- Кнопка вкладки
        Tab.Button = Instance.new("TextButton")
        Tab.Button.Size = UDim2.new(0, 120, 0, 40)
        Tab.Button.Position = UDim2.new(0, 10 + (#self.Tabs * 130), 0, -40)
        Tab.Button.BackgroundColor3 = self.Theme.Secondary
        Tab.Button.Text = (Icon or "📁") .. " " .. Name
        Tab.Button.TextColor3 = self.Theme.Text
        Tab.Button.TextSize = 14
        Tab.Button.Font = Enum.Font.Gotham
        Tab.Button.Parent = self.MainFrame
        RoundCorners(Tab.Button, 8)
        
        -- Контент вкладки
        Tab.Content = Instance.new("ScrollingFrame")
        Tab.Content.Size = UDim2.new(1, -20, 1, -20)
        Tab.Content.Position = UDim2.new(0, 10, 0, 10)
        Tab.Content.BackgroundTransparency = 1
        Tab.Content.ScrollBarThickness = 5
        Tab.Content.ScrollBarImageColor3 = self.Theme.Accent
        Tab.Content.Visible = false
        Tab.Content.Parent = self.TabContainer
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 12)
        UIListLayout.Parent = Tab.Content
        
        Tab.Sections = {}
        
        -- НОВЫЕ ЭЛЕМЕНТЫ ДЛЯ ВКЛАДКИ
        
        function Tab:CreateSection(Name)
            local Section = {}
            Section.Name = Name
            
            Section.Frame = Instance.new("Frame")
            Section.Frame.Size = UDim2.new(1, 0, 0, 0)
            Section.Frame.BackgroundColor3 = self.Window.Theme.Secondary
            Section.Frame.BorderSizePixel = 0
            Section.Frame.Parent = Tab.Content
            RoundCorners(Section.Frame, 10)
            CreateShadow(Section.Frame)
            
            Section.Title = Instance.new("TextLabel")
            Section.Title.Size = UDim2.new(1, -20, 0, 35)
            Section.Title.Position = UDim2.new(0, 10, 0, 0)
            Section.Title.BackgroundTransparency = 1
            Section.Title.Text = "📂 " .. Name
            Section.Title.TextColor3 = self.Window.Theme.Text
            Section.Title.TextSize = 16
            Section.Title.Font = Enum.Font.GothamBold
            Section.Title.TextXAlignment = Enum.TextXAlignment.Left
            Section.Title.Parent = Section.Frame
            
            Section.Content = Instance.new("Frame")
            Section.Content.Size = UDim2.new(1, -20, 0, 0)
            Section.Content.Position = UDim2.new(0, 10, 0, 40)
            Section.Content.BackgroundTransparency = 1
            Section.Content.Parent = Section.Frame
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Padding = UDim.new(0, 10)
            SectionList.Parent = Section.Content
            
            Section.Elements = {}
            
            -- НОВЫЕ МЕТОДЫ СЕКЦИИ
            
            function Section:CreateButton(Config)
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.BackgroundColor3 = self.Window.Theme.Accent
                Button.Text = Config.Title or "Button"
                Button.TextColor3 = self.Window.Theme.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.Gotham
                Button.Parent = Section.Content
                RoundCorners(Button, 6)
                
                -- Анимация при наведении
                Animations.Hover(Button)
                
                Button.MouseButton1Click:Connect(function()
                    if Config.Callback then
                        local success, err = pcall(Config.Callback)
                        if not success then
                            self.Window:Notify({
                                Title = "Ошибка",
                                Content = "Ошибка в callback: " .. tostring(err),
                                Type = "Error"
                            })
                        end
                    end
                end)
                
                Section.Elements[#Section.Elements + 1] = Button
                Section:UpdateSize()
                
                return {
                    Object = Button,
                    Update = function(newConfig)
                        if newConfig.Title then
                            Button.Text = newConfig.Title
                        end
                        if newConfig.Callback then
                            Config.Callback = newConfig.Callback
                        end
                    end
                }
            end
            
            function Section:CreateToggle(Config)
                local Toggle = {}
                Toggle.Value = Config.Default or false
                Toggle.Config = Config
                
                Toggle.Frame = Instance.new("Frame")
                Toggle.Frame.Size = UDim2.new(1, 0, 0, 40)
                Toggle.Frame.BackgroundTransparency = 1
                Toggle.Frame.Parent = Section.Content
                
                Toggle.Button = Instance.new("TextButton")
                Toggle.Button.Size = UDim2.new(1, 0, 1, 0)
                Toggle.Button.BackgroundColor3 = Toggle.Value and self.Window.Theme.Success or Color3.fromRGB(80, 80, 100)
                Toggle.Button.Text = (Toggle.Value and "✅ " or "❌ ") .. (Config.Title or "Toggle")
                Toggle.Button.TextColor3 = self.Window.Theme.Text
                Toggle.Button.TextSize = 14
                Toggle.Button.Font = Enum.Font.Gotham
                Toggle.Button.Parent = Toggle.Frame
                RoundCorners(Toggle.Button, 6)
                
                Toggle.Button.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    Toggle.Button.BackgroundColor3 = Toggle.Value and self.Window.Theme.Success or Color3.fromRGB(80, 80, 100)
                    Toggle.Button.Text = (Toggle.Value and "✅ " or "❌ ") .. (Config.Title or "Toggle")
                    
                    if Config.Callback then
                        local success, err = pcall(Config.Callback, Toggle.Value)
                        if not success then
                            self.Window:Notify({
                                Title = "Ошибка",
                                Content = "Ошибка в callback: " .. tostring(err),
                                Type = "Error"
                            })
                        end
                    end
                end)
                
                Section.Elements[#Section.Elements + 1] = Toggle.Frame
                Section:UpdateSize()
                
                return {
                    Object = Toggle.Button,
                    Value = Toggle.Value,
                    Update = function(newValue)
                        Toggle.Value = newValue
                        Toggle.Button.BackgroundColor3 = Toggle.Value and self.Window.Theme.Success or Color3.fromRGB(80, 80, 100)
                        Toggle.Button.Text = (Toggle.Value and "✅ " or "❌ ") .. (Config.Title or "Toggle")
                    end
                }
            end
            
            function Section:CreateSlider(Config)
                local Slider = {}
                Slider.Value = Config.Default or Config.Min or 0
                Slider.Config = Config
                
                Slider.Frame = Instance.new("Frame")
                Slider.Frame.Size = UDim2.new(1, 0, 0, 70)
                Slider.Frame.BackgroundTransparency = 1
                Slider.Frame.Parent = Section.Content
                
                Slider.Title = Instance.new("TextLabel")
                Slider.Title.Size = UDim2.new(1, 0, 0, 25)
                Slider.Title.BackgroundTransparency = 1
                Slider.Title.Text = Config.Title or "Slider: " .. Slider.Value
                Slider.Title.TextColor3 = self.Window.Theme.Text
                Slider.Title.TextSize = 14
                Slider.Title.Font = Enum.Font.Gotham
                Slider.Title.TextXAlignment = Enum.TextXAlignment.Left
                Slider.Title.Parent = Slider.Frame
                
                Slider.ValueLabel = Instance.new("TextLabel")
                Slider.ValueLabel.Size = UDim2.new(0, 60, 0, 25)
                Slider.ValueLabel.Position = UDim2.new(1, -60, 0, 0)
                Slider.ValueLabel.BackgroundTransparency = 1
                Slider.ValueLabel.Text = tostring(Slider.Value)
                Slider.ValueLabel.TextColor3 = self.Window.Theme.Accent
                Slider.ValueLabel.TextSize = 14
                Slider.ValueLabel.Font = Enum.Font.GothamBold
                Slider.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                Slider.ValueLabel.Parent = Slider.Frame
                
                Slider.Track = Instance.new("Frame")
                Slider.Track.Size = UDim2.new(1, 0, 0, 8)
                Slider.Track.Position = UDim2.new(0, 0, 0, 35)
                Slider.Track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                Slider.Track.Parent = Slider.Frame
                RoundCorners(Slider.Track, 4)
                
                Slider.Fill = Instance.new("Frame")
                Slider.Fill.Size = UDim2.new((Slider.Value - (Config.Min or 0)) / ((Config.Max or 100) - (Config.Min or 0)), 0, 1, 0)
                Slider.Fill.BackgroundColor3 = self.Window.Theme.Accent
                Slider.Fill.Parent = Slider.Track
                RoundCorners(Slider.Fill, 4)
                
                Slider.Handle = Instance.new("TextButton")
                Slider.Handle.Size = UDim2.new(0, 18, 0, 18)
                Slider.Handle.Position = UDim2.new(Slider.Fill.Size.X.Scale, -9, 0.5, -9)
                Slider.Handle.BackgroundColor3 = self.Window.Theme.Text
                Slider.Handle.Text = ""
                Slider.Handle.Parent = Slider.Track
                RoundCorners(Slider.Handle, 9)
                
                local Dragging = false
                
                local function UpdateSlider(Value)
                    local Min = Config.Min or 0
                    local Max = Config.Max or 100
                    local Normalized = math.clamp((Value - Min) / (Max - Min), 0, 1)
                    
                    Slider.Value = math.floor(Value)
                    Slider.Fill.Size = UDim2.new(Normalized, 0, 1, 0)
                    Slider.Handle.Position = UDim2.new(Normalized, -9, 0.5, -9)
                    Slider.Title.Text = Config.Title or "Slider: " .. Slider.Value
                    Slider.ValueLabel.Text = tostring(Slider.Value)
                    
                    if Config.Callback then
                        local success, err = pcall(Config.Callback, Slider.Value)
                        if not success then
                            self.Window:Notify({
                                Title = "Ошибка",
                                Content = "Ошибка в callback: " .. tostring(err),
                                Type = "Error"
                            })
                        end
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
                
                return {
                    Object = Slider.Frame,
                    Value = Slider.Value,
                    Update = function(newValue)
                        UpdateSlider(newValue)
                    end
                }
            end
            
            function Section:CreateDropdown(Config)
                local Dropdown = {}
                Dropdown.Open = false
                Dropdown.Options = Config.Options or {}
                Dropdown.Selected = Config.Default or ""
                Dropdown.Config = Config
                
                Dropdown.Frame = Instance.new("Frame")
                Dropdown.Frame.Size = UDim2.new(1, 0, 0, 40)
                Dropdown.Frame.BackgroundTransparency = 1
                Dropdown.Frame.Parent = Section.Content
                
                Dropdown.Button = Instance.new("TextButton")
                Dropdown.Button.Size = UDim2.new(1, 0, 0, 40)
                Dropdown.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                Dropdown.Button.Text = "▼ " .. (Dropdown.Selected ~= "" and Dropdown.Selected or (Config.Title or "Select"))
                Dropdown.Button.TextColor3 = self.Window.Theme.Text
                Dropdown.Button.TextSize = 14
                Dropdown.Button.Font = Enum.Font.Gotham
                Dropdown.Button.Parent = Dropdown.Frame
                RoundCorners(Dropdown.Button, 6)
                
                Dropdown.List = Instance.new("Frame")
                Dropdown.List.Size = UDim2.new(1, 0, 0, 0)
                Dropdown.List.Position = UDim2.new(0, 0, 0, 45)
                Dropdown.List.BackgroundColor3 = self.Window.Theme.Secondary
                Dropdown.List.Visible = false
                Dropdown.List.Parent = Dropdown.Frame
                RoundCorners(Dropdown.List, 6)
                CreateShadow(Dropdown.List)
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Parent = Dropdown.List
                
                function Dropdown:Refresh(NewOptions, KeepCurrent)
                    self.Options = NewOptions or self.Options
                    
                    -- Очищаем старые кнопки
                    for _, Child in pairs(self.List:GetChildren()) do
                        if Child:IsA("TextButton") then
                            Child:Destroy()
                        end
                    end
                    
                    -- Создаем новые кнопки
                    for _, Option in pairs(self.Options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Size = UDim2.new(1, -10, 0, 35)
                        OptionButton.Position = UDim2.new(0, 5, 0, 0)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
                        OptionButton.Text = Option
                        OptionButton.TextColor3 = self.Window.Theme.Text
                        OptionButton.TextSize = 12
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.Parent = self.List
                        RoundCorners(OptionButton, 4)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            self.Selected = Option
                            self.Button.Text = "▼ " .. Option
                            self.Open = false
                            self.List.Visible = false
                            
                            if self.Config.Callback then
                                local success, err = pcall(self.Config.Callback, Option)
                                if not success then
                                    self.Window:Notify({
                                        Title = "Ошибка",
                                        Content = "Ошибка в callback: " .. tostring(err),
                                        Type = "Error"
                                    })
                                end
                            end
                        end)
                    end
                    
                    self.List.Size = UDim2.new(1, 0, 0, #self.Options * 35)
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
                
                return {
                    Object = Dropdown.Frame,
                    Selected = Dropdown.Selected,
                    Refresh = Dropdown.Refresh
                }
            end
            
            -- НОВЫЕ ЭЛЕМЕНТЫ v2.0
            
            function Section:CreateInput(Config)
                local Input = {}
                Input.Value = Config.Default or ""
                Input.Config = Config
                
                Input.Frame = Instance.new("Frame")
                Input.Frame.Size = UDim2.new(1, 0, 0, 40)
                Input.Frame.BackgroundTransparency = 1
                Input.Frame.Parent = Section.Content
                
                Input.Box = Instance.new("TextBox")
                Input.Box.Size = UDim2.new(1, 0, 1, 0)
                Input.Box.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                Input.Box.TextColor3 = self.Window.Theme.Text
                Input.Box.Text = Input.Value
                Input.Box.PlaceholderText = Config.Placeholder or "Введите текст..."
                Input.Box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                Input.Box.TextSize = 14
                Input.Box.Font = Enum.Font.Gotham
                Input.Box.Parent = Input.Frame
                RoundCorners(Input.Box, 6)
                
                Input.Box.FocusLost:Connect(function(enterPressed)
                    Input.Value = Input.Box.Text
                    if Config.Callback then
                        local success, err = pcall(Config.Callback, Input.Value, enterPressed)
                        if not success then
                            self.Window:Notify({
                                Title = "Ошибка",
                                Content = "Ошибка в callback: " .. tostring(err),
                                Type = "Error"
                            })
                        end
                    end
                end)
                
                Section.Elements[#Section.Elements + 1] = Input.Frame
                Section:UpdateSize()
                
                return {
                    Object = Input.Box,
                    Value = Input.Value,
                    Update = function(newValue)
                        Input.Box.Text = newValue
                        Input.Value = newValue
                    end
                }
            end
            
            function Section:CreateLabel(Config)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 30)
                Label.BackgroundTransparency = 1
                Label.Text = Config.Text or "Label"
                Label.TextColor3 = self.Window.Theme.Text
                Label.TextSize = Config.TextSize or 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Config.Alignment or Enum.TextXAlignment.Left
                Label.Parent = Section.Content
                
                Section.Elements[#Section.Elements + 1] = Label
                Section:UpdateSize()
                
                return {
                    Object = Label,
                    Update = function(newText)
                        Label.Text = newText
                    end
                }
            end
            
            function Section:CreateKeybind(Config)
                local Keybind = {}
                Keybind.Key = Config.Default or Enum.KeyCode.Unknown
                Keybind.Listening = false
                Keybind.Config = Config
                
                Keybind.Frame = Instance.new("Frame")
                Keybind.Frame.Size = UDim2.new(1, 0, 0, 40)
                Keybind.Frame.BackgroundTransparency = 1
                Keybind.Frame.Parent = Section.Content
                
                Keybind.Button = Instance.new("TextButton")
                Keybind.Button.Size = UDim2.new(1, 0, 1, 0)
                Keybind.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                Keybind.Button.Text = "Keybind: " .. tostring(Keybind.Key.Name)
                Keybind.Button.TextColor3 = self.Window.Theme.Text
                Keybind.Button.TextSize = 14
                Keybind.Button.Font = Enum.Font.Gotham
                Keybind.Button.Parent = Keybind.Frame
                RoundCorners(Keybind.Button, 6)
                
                Keybind.Button.MouseButton1Click:Connect(function()
                    Keybind.Listening = true
                    Keybind.Button.Text = "Нажмите клавишу..."
                    Keybind.Button.BackgroundColor3 = self.Window.Theme.Accent
                end)
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if Keybind.Listening and not gameProcessed then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            Keybind.Key = input.KeyCode
                            Keybind.Button.Text = "Keybind: " .. input.KeyCode.Name
                            Keybind.Listening = false
                            Keybind.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                            
                            if Config.Callback then
                                pcall(Config.Callback, input.KeyCode)
                            end
                        end
                    end
                end)
                
                Section.Elements[#Section.Elements + 1] = Keybind.Frame
                Section:UpdateSize()
                
                return {
                    Object = Keybind.Button,
                    Key = Keybind.Key,
                    Update = function(newKey)
                        Keybind.Key = newKey
                        Keybind.Button.Text = "Keybind: " .. newKey.Name
                    end
                }
            end
            
            function Section:UpdateSize()
                local TotalHeight = 45 -- Заголовок + отступы
                for _, Element in pairs(self.Elements) do
                    TotalHeight += Element.Size.Y.Offset + 10
                end
                self.Frame.Size = UDim2.new(1, 0, 0, TotalHeight)
                self.Content.Size = UDim2.new(1, 0, 0, TotalHeight - 45)
            end
            
            Section:UpdateSize()
            Tab.Sections[#Tab.Sections + 1] = Section
            
            return Section
        end
        
        function Tab:Show()
            if self.Window.CurrentTab then
                self.Window.CurrentTab.Content.Visible = false
                Tween(self.Window.CurrentTab.Button, {BackgroundColor3 = self.Window.Theme.Secondary})
            end
            
            self.Window.CurrentTab = self
            self.Content.Visible = true
            Tween(self.Button, {BackgroundColor3 = self.Window.Theme.Accent})
        end
        
        self.Button.MouseButton1Click:Connect(function()
            self:Show()
        end)
        
        self.Tabs[#self.Tabs + 1] = self
        
        if #self.Tabs == 1 then
            self:Show()
        end
        
        return self
    end
    
    -- УЛУЧШЕННАЯ СИСТЕМА УВЕДОМЛЕНИЙ
    
    function Window:Notify(Config)
        local NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Parent = CoreGui
        
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Size = UDim2.new(0, 350, 0, 80)
        NotifyFrame.Position = UDim2.new(1, -370, 0, 20)
        NotifyFrame.BackgroundColor3 = self.Theme.Secondary
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Parent = NotifyGui
        RoundCorners(NotifyFrame, 10)
        CreateShadow(NotifyFrame)
        
        -- Иконка уведомления
        local Icon = Instance.new("TextLabel")
        Icon.Size = UDim2.new(0, 40, 0, 40)
        Icon.Position = UDim2.new(0, 15, 0, 20)
        Icon.BackgroundTransparency = 1
        Icon.Text = Config.Type == "Error" and "❌" or Config.Type == "Warning" and "⚠️" or "✅"
        Icon.TextColor3 = Config.Type == "Error" and self.Theme.Error or Config.Type == "Warning" and self.Theme.Warning or self.Theme.Success
        Icon.TextSize = 20
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = NotifyFrame
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -70, 0, 25)
        Title.Position = UDim2.new(0, 60, 0, 15)
        Title.BackgroundTransparency = 1
        Title.Text = Config.Title or "Notification"
        Title.TextColor3 = self.Theme.Text
        Title.TextSize = 16
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = NotifyFrame
        
        local Content = Instance.new("TextLabel")
        Content.Size = UDim2.new(1, -70, 0, 35)
        Content.Position = UDim2.new(0, 60, 0, 40)
        Content.BackgroundTransparency = 1
        Content.Text = Config.Content or ""
        Content.TextColor3 = self.Theme.Text
        Content.TextSize = 14
        Content.Font = Enum.Font.Gotham
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextYAlignment = Enum.TextYAlignment.Top
        Content.Parent = NotifyFrame
        
        -- Анимация появления
        NotifyFrame.Position = UDim2.new(1, 350, 0, 20)
        Tween(NotifyFrame, {Position = UDim2.new(1, -370, 0, 20)}, 0.5, Enum.EasingStyle.Back)
        
        wait(Config.Duration or 5)
        
        -- Анимация исчезновения
        Tween(NotifyFrame, {Position = UDim2.new(1, 350, 0, 20)}, 0.5, Enum.EasingStyle.Quad)
        wait(0.5)
        NotifyGui:Destroy()
    end
    
    function Window:Destroy()
        self.ScreenGui:Destroy()
        -- Удаляем из списка окон
        for i, win in pairs(TelaryUI.Windows or {}) do
            if win == self then
                table.remove(TelaryUI.Windows, i)
                break
            end
        end
    end
    
    -- Первое уведомление
    Window:Notify({
        Title = "Telary UI v2.0",
        Content = "Улучшенная библиотека успешно загружена!",
        Duration = 4,
        Type = "Success"
    })
    
    return Window
end

-- ГЛОБАЛЬНЫЕ ФУНКЦИИ БИБЛИОТЕКИ

function TelaryUI:ChangeGlobalTheme(ThemeName)
    if Themes[ThemeName] then
        Configuration.CurrentTheme = ThemeName
        for _, window in pairs(self.Windows or {}) do
            if window and window.ChangeTheme then
                window:ChangeTheme(ThemeName)
            end
        end
    end
end

function TelaryUI:GetWindows()
    return self.Windows or {}
end

function TelaryUI:DestroyAll()
    for _, window in pairs(self.Windows or {}) do
        if window and window.Destroy then
            window:Destroy()
        end
    end
    self.Windows = {}
end

-- Загрузка конфигурации
Configuration:Load()

return TelaryUI
