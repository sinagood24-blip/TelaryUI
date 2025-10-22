-- Telary UI Library v4.5 - Fixed Version
-- Ультимативная библиотека пользовательского интерфейса для Roblox

local TelaryUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")

TelaryUI.__index = TelaryUI

-- 🎨 СИСТЕМА ТЕМ
local Themes = {
    Cyber = {
        Background = Color3.fromRGB(10, 10, 20),
        Secondary = Color3.fromRGB(20, 20, 35),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(0, 255, 128),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 50, 50)
    },
    Neon = {
        Background = Color3.fromRGB(15, 5, 25),
        Secondary = Color3.fromRGB(25, 10, 40),
        Accent = Color3.fromRGB(255, 0, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(0, 255, 0),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 0, 0)
    },
    Matrix = {
        Background = Color3.fromRGB(0, 10, 0),
        Secondary = Color3.fromRGB(0, 20, 0),
        Accent = Color3.fromRGB(0, 255, 0),
        Text = Color3.fromRGB(0, 255, 0),
        Success = Color3.fromRGB(0, 255, 0),
        Warning = Color3.fromRGB(200, 255, 0),
        Error = Color3.fromRGB(255, 50, 0)
    }
}

-- 🛠️ УТИЛИТЫ
local function SafeTween(Object, Properties, Duration, Style, Direction)
    if not Object or not Object.Parent then return nil end
    local tweenInfo = TweenInfo.new(Duration or 0.3, Style or Enum.EasingStyle.Quad, Direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(Object, tweenInfo, Properties)
    tween:Play()
    return tween
end

local function RoundCorners(Object, CornerRadius)
    if not Object then return nil end
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CornerRadius or 8)
    corner.Parent = Object
    return corner
end

local function CreateGlow(Object, Color, Intensity, SizeIncrease)
    if not Object then return nil end
    local glow = Instance.new("ImageLabel")
    glow.Name = "TelaryGlow"
    glow.Size = UDim2.new(1, SizeIncrease or 20, 1, SizeIncrease or 20)
    glow.Position = UDim2.new(0, -(SizeIncrease or 20)/2, 0, -(SizeIncrease or 20)/2)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://8992230675"
    glow.ImageColor3 = Color or Color3.new(1, 1, 1)
    glow.ImageTransparency = Intensity or 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.ZIndex = -1
    glow.Parent = Object
    return glow
end

-- 🎭 АНИМАЦИИ
local Animations = {
    Hover = function(Object, OriginalColor, HoverColor, Duration)
        if not Object then return end
        local connection1, connection2
        
        connection1 = Object.MouseEnter:Connect(function()
            SafeTween(Object, {BackgroundColor3 = HoverColor or OriginalColor:Lerp(Color3.new(1, 1, 1), 0.2)}, Duration or 0.2)
        end)
        
        connection2 = Object.MouseLeave:Connect(function()
            SafeTween(Object, {BackgroundColor3 = OriginalColor}, Duration or 0.2)
        end)
        
        return {connection1, connection2}
    end
}

-- 🔧 КОНФИГУРАЦИЯ
local GlobalConfig = {
    AnimationsEnabled = true,
    SoundEnabled = false,
    NotificationsEnabled = true
}

-- 🎯 СОЗДАНИЕ ОКНА
function TelaryUI:CreateWindow(Config)
    Config = Config or {}
    
    local Window = setmetatable({}, TelaryUI)
    Window.ID = HttpService:GenerateGUID(false)
    Window.Theme = Themes[Config.Theme or "Cyber"] or Themes.Cyber
    Window.Elements = {}
    Window.AnimationsEnabled = Config.Animations ~= false and GlobalConfig.AnimationsEnabled
    
    -- Создаем ScreenGui
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "TelaryUI_" .. Window.ID
    Window.ScreenGui.Parent = CoreGui
    Window.ScreenGui.ResetOnSpawn = false
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Главный фрейм
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Size = Config.Size or UDim2.new(0, 500, 0, 400)
    Window.MainFrame.Position = Config.Center and UDim2.new(0.5, -250, 0.5, -200) or (Config.Position or UDim2.new(0, 100, 0, 100))
    Window.MainFrame.BackgroundColor3 = Window.Theme.Background
    Window.MainFrame.BackgroundTransparency = 0.05
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Parent = Window.ScreenGui
    RoundCorners(Window.MainFrame, 12)
    CreateGlow(Window.MainFrame, Window.Theme.Accent, 0.7, 25)
    
    -- Панель заголовка
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    Window.TitleBar.BackgroundColor3 = Window.Theme.Secondary
    Window.TitleBar.BackgroundTransparency = 0.1
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.Parent = Window.MainFrame
    RoundCorners(Window.TitleBar, 12)
    
    -- Заголовок
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "Telary UI"
    TitleLabel.TextColor3 = Window.Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Window.TitleBar
    
    -- Кнопки управления
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
    CloseButton.BackgroundColor3 = Window.Theme.Error
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Window.Theme.Text
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Window.TitleBar
    RoundCorners(CloseButton, 6)
    
    -- Контейнер для контента
    Window.ContentFrame = Instance.new("Frame")
    Window.ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    Window.ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    Window.ContentFrame.BackgroundTransparency = 1
    Window.ContentFrame.Parent = Window.MainFrame
    
    -- Функционал перетаскивания
    if Config.Draggable ~= false then
        local dragging, dragInput, dragStart, startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            Window.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
        
        Window.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Window.MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        Window.TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end
    
    -- Обработчик закрытия
    CloseButton.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)
    
    -- Анимация появления
    if Window.AnimationsEnabled then
        Window.MainFrame.Size = UDim2.new(0, 10, 0, 10)
        Window.MainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
        Window.MainFrame.BackgroundTransparency = 1
        
        SafeTween(Window.MainFrame, {
            Size = Config.Size or UDim2.new(0, 500, 0, 400),
            Position = Config.Center and UDim2.new(0.5, -250, 0.5, -200) or (Config.Position or UDim2.new(0, 100, 0, 100)),
            BackgroundTransparency = 0.05
        }, 0.8, Enum.EasingStyle.Back)
    end
    
    -- Регистрация окна
    if not TelaryUI.Windows then TelaryUI.Windows = {} end
    TelaryUI.Windows[Window.ID] = Window
    
    return Window
end

-- 📑 МЕТОДЫ ОКНА
function TelaryUI:CreateTab(Name)
    local Tab = {}
    Tab.Name = Name
    Tab.Window = self
    Tab.Elements = {}
    
    -- Контент вкладки
    Tab.Content = Instance.new("ScrollingFrame")
    Tab.Content.Size = UDim2.new(1, -20, 1, -20)
    Tab.Content.Position = UDim2.new(0, 10, 0, 10)
    Tab.Content.BackgroundTransparency = 1
    Tab.Content.ScrollBarThickness = 6
    Tab.Content.ScrollBarImageColor3 = self.Theme.Accent
    Tab.Content.ScrollBarImageTransparency = 0.7
    Tab.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Tab.Content.Visible = false
    Tab.Content.Parent = self.ContentFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = Tab.Content
    
    Tab.Sections = {}
    
    -- Метод создания секции
    function Tab:CreateSection(Name)
        local Section = {}
        Section.Name = Name
        Section.Window = self.Window
        Section.Elements = {}
        
        -- Фрейм секции
        Section.Frame = Instance.new("Frame")
        Section.Frame.Size = UDim2.new(0.95, 0, 0, 0)
        Section.Frame.AnchorPoint = Vector2.new(0.5, 0)
        Section.Frame.Position = UDim2.new(0.5, 0, 0, 0)
        Section.Frame.BackgroundColor3 = self.Window.Theme.Secondary
        Section.Frame.BackgroundTransparency = 0.1
        Section.Frame.BorderSizePixel = 0
        Section.Frame.Parent = Tab.Content
        RoundCorners(Section.Frame, 8)
        
        -- Заголовок секции
        Section.Title = Instance.new("TextLabel")
        Section.Title.Size = UDim2.new(1, -20, 0, 30)
        Section.Title.Position = UDim2.new(0, 10, 0, 5)
        Section.Title.BackgroundTransparency = 1
        Section.Title.Text = "• " .. Name
        Section.Title.TextColor3 = self.Window.Theme.Text
        Section.Title.TextSize = 14
        Section.Title.Font = Enum.Font.GothamBold
        Section.Title.TextXAlignment = Enum.TextXAlignment.Left
        Section.Title.Parent = Section.Frame
        
        -- Контент секции
        Section.Content = Instance.new("Frame")
        Section.Content.Size = UDim2.new(1, -20, 0, 0)
        Section.Content.Position = UDim2.new(0, 10, 0, 35)
        Section.Content.BackgroundTransparency = 1
        Section.Content.Parent = Section.Frame
        
        local SectionList = Instance.new("UIListLayout")
        SectionList.Padding = UDim.new(0, 8)
        SectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        SectionList.Parent = Section.Content
        
        -- Обновление размера
        function Section:UpdateSize()
            if not self.Frame then return end
            local totalHeight = 40
            for _, element in pairs(self.Elements) do
                if element and element.AbsoluteSize then
                    totalHeight = totalHeight + element.AbsoluteSize.Y + 8
                end
            end
            self.Frame.Size = UDim2.new(0.95, 0, 0, totalHeight)
        end

        -- 🆕 КНОПКА
        function Section:CreateButton(Config)
            Config = Config or {}
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = self.Window.Theme.Accent
            Button.Text = Config.Title or "Кнопка"
            Button.TextColor3 = self.Window.Theme.Text
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.TextWrapped = true
            Button.Parent = self.Content
            RoundCorners(Button, 6)
            
            -- Анимация наведения
            if self.Window.AnimationsEnabled then
                Animations.Hover(Button, Button.BackgroundColor3)
            end
            
            -- Обработчик клика
            Button.MouseButton1Click:Connect(function()
                if self.Window.AnimationsEnabled then
                    SafeTween(Button, {Size = UDim2.new(0.98, 0, 0.95, 0)}, 0.1)
                    SafeTween(Button, {Size = UDim2.new(1, 0, 1, 0)}, 0.1, Enum.EasingStyle.Back)
                end
                
                if Config.Callback then
                    local success, err = pcall(Config.Callback)
                    if not success then
                        warn("Ошибка в callback кнопки:", err)
                    end
                end
            end)
            
            table.insert(self.Elements, Button)
            self:UpdateSize()
            
            return {
                Object = Button,
                Update = function(newConfig)
                    if newConfig.Title then
                        Button.Text = newConfig.Title
                    end
                end,
                SetDisabled = function(disabled)
                    Button.AutoButtonColor = not disabled
                    Button.BackgroundTransparency = disabled and 0.7 or 0
                    Button.TextTransparency = disabled and 0.5 or 0
                end
            }
        end

        -- 🆕 ПЕРЕКЛЮЧАТЕЛЬ
        function Section:CreateToggle(Config)
            Config = Config or {}
            local Toggle = {}
            Toggle.Value = Config.Default or false
            
            Toggle.Frame = Instance.new("Frame")
            Toggle.Frame.Size = UDim2.new(1, 0, 0, 30)
            Toggle.Frame.BackgroundTransparency = 1
            Toggle.Frame.Parent = self.Content
            
            Toggle.Label = Instance.new("TextLabel")
            Toggle.Label.Size = UDim2.new(1, -50, 1, 0)
            Toggle.Label.BackgroundTransparency = 1
            Toggle.Label.Text = Config.Title or "Переключатель"
            Toggle.Label.TextColor3 = self.Window.Theme.Text
            Toggle.Label.TextSize = 14
            Toggle.Label.Font = Enum.Font.Gotham
            Toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
            Toggle.Label.Parent = Toggle.Frame
            
            -- Переключатель
            Toggle.Button = Instance.new("TextButton")
            Toggle.Button.Size = UDim2.new(0, 40, 0, 20)
            Toggle.Button.Position = UDim2.new(1, -45, 0.5, -10)
            Toggle.Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            Toggle.Button.Text = ""
            Toggle.Button.AutoButtonColor = false
            Toggle.Button.Parent = Toggle.Frame
            RoundCorners(Toggle.Button, 10)
            
            Toggle.Thumb = Instance.new("Frame")
            Toggle.Thumb.Size = UDim2.new(0, 16, 0, 16)
            Toggle.Thumb.Position = UDim2.new(0, 2, 0.5, -8)
            Toggle.Thumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            Toggle.Thumb.Parent = Toggle.Button
            RoundCorners(Toggle.Thumb, 8)
            
            function Toggle:UpdateState()
                if self.Value then
                    SafeTween(self.Button, {BackgroundColor3 = self.Window.Theme.Accent}, 0.2)
                    SafeTween(self.Thumb, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                else
                    SafeTween(self.Button, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}, 0.2)
                    SafeTween(self.Thumb, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                end
                if Config.Callback then
                    pcall(Config.Callback, self.Value)
                end
            end
            
            Toggle.Button.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                Toggle:UpdateState()
            end)
            
            Toggle:UpdateState()
            
            table.insert(self.Elements, Toggle.Frame)
            self:UpdateSize()
            
            return {
                Object = Toggle.Frame,
                Value = Toggle.Value,
                Update = function(newValue)
                    Toggle.Value = newValue
                    Toggle:UpdateState()
                end
            }
        end

        -- 🆕 СЛАЙДЕР
        function Section:CreateSlider(Config)
            Config = Config or {}
            local Slider = {}
            Slider.Value = Config.Default or Config.Min or 0
            Slider.Min = Config.Min or 0
            Slider.Max = Config.Max or 100
            
            Slider.Frame = Instance.new("Frame")
            Slider.Frame.Size = UDim2.new(1, 0, 0, 60)
            Slider.Frame.BackgroundTransparency = 1
            Slider.Frame.Parent = self.Content
            
            -- Заголовок и значение
            Slider.Title = Instance.new("TextLabel")
            Slider.Title.Size = UDim2.new(1, -50, 0, 20)
            Slider.Title.BackgroundTransparency = 1
            Slider.Title.Text = Config.Title or "Слайдер"
            Slider.Title.TextColor3 = self.Window.Theme.Text
            Slider.Title.TextSize = 14
            Slider.Title.Font = Enum.Font.Gotham
            Slider.Title.TextXAlignment = Enum.TextXAlignment.Left
            Slider.Title.Parent = Slider.Frame
            
            Slider.ValueLabel = Instance.new("TextLabel")
            Slider.ValueLabel.Size = UDim2.new(0, 45, 0, 20)
            Slider.ValueLabel.Position = UDim2.new(1, -45, 0, 0)
            Slider.ValueLabel.BackgroundTransparency = 1
            Slider.ValueLabel.Text = tostring(math.floor(Slider.Value))
            Slider.ValueLabel.TextColor3 = self.Window.Theme.Accent
            Slider.ValueLabel.TextSize = 14
            Slider.ValueLabel.Font = Enum.Font.GothamBold
            Slider.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            Slider.ValueLabel.Parent = Slider.Frame
            
            -- Дорожка слайдера
            Slider.Track = Instance.new("Frame")
            Slider.Track.Size = UDim2.new(1, 0, 0, 6)
            Slider.Track.Position = UDim2.new(0, 0, 0, 35)
            Slider.Track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            Slider.Track.Parent = Slider.Frame
            RoundCorners(Slider.Track, 3)
            
            Slider.Fill = Instance.new("Frame")
            Slider.Fill.Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
            Slider.Fill.BackgroundColor3 = self.Window.Theme.Accent
            Slider.Fill.Parent = Slider.Track
            RoundCorners(Slider.Fill, 3)
            
            function Slider:UpdateValue(Value)
                local newValue = math.clamp(Value, self.Min, self.Max)
                self.Value = newValue
                local normalized = (self.Value - self.Min) / (self.Max - self.Min)
                self.Fill.Size = UDim2.new(normalized, 0, 1, 0)
                self.ValueLabel.Text = tostring(math.floor(self.Value))
                if Config.Callback then
                    pcall(Config.Callback, self.Value)
                end
            end
            
            -- Обработка ввода
            local dragging = false
            
            local function updateFromMouse()
                local mouse = UserInputService:GetMouseLocation()
                local trackAbsolutePos = Slider.Track.AbsolutePosition
                local trackAbsoluteSize = Slider.Track.AbsoluteSize
                local relativeX = (mouse.X - trackAbsolutePos.X) / trackAbsoluteSize.X
                local value = (Slider.Max - Slider.Min) * math.clamp(relativeX, 0, 1) + Slider.Min
                Slider:UpdateValue(value)
            end
            
            Slider.Track.MouseButton1Down:Connect(function()
                dragging = true
                updateFromMouse()
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateFromMouse()
                end
            end)
            
            table.insert(self.Elements, Slider.Frame)
            self:UpdateSize()
            
            return {
                Object = Slider.Frame,
                Value = Slider.Value,
                Update = function(newValue)
                    Slider:UpdateValue(newValue)
                end
            }
        end

        self:UpdateSize()
        table.insert(Tab.Sections, Section)
        return Section
    end
    
    -- Активация первой вкладки
    if #self.Tabs == 0 then
        Tab.Content.Visible = true
    end
    
    table.insert(self.Tabs, Tab)
    return Tab
end

-- 🔔 УВЕДОМЛЕНИЯ
function TelaryUI:Notify(Config)
    Config = Config or {}
    if not GlobalConfig.NotificationsEnabled then return end
    
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "TelaryNotification"
    notifyGui.Parent = CoreGui
    notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Size = UDim2.new(0, 300, 0, 80)
    notifyFrame.Position = UDim2.new(1, 320, 0, 20)
    notifyFrame.BackgroundColor3 = self.Theme.Secondary
    notifyFrame.BackgroundTransparency = 0.1
    notifyFrame.BorderSizePixel = 0
    notifyFrame.Parent = notifyGui
    RoundCorners(notifyFrame, 8)
    
    local iconMap = {
        success = "✅",
        error = "❌", 
        warning = "⚠️",
        info = "💡"
    }
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 10, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Text = iconMap[Config.Type] or "📢"
    icon.TextColor3 = Config.Type == "error" and self.Theme.Error or 
                     Config.Type == "warning" and self.Theme.Warning or 
                     Config.Type == "info" and self.Theme.Accent or 
                     self.Theme.Success
    icon.TextSize = 20
    icon.Font = Enum.Font.GothamBold
    icon.Parent = notifyFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 25)
    title.Position = UDim2.new(0, 55, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = Config.Title or "Уведомление"
    title.TextColor3 = self.Theme.Text
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notifyFrame
    
    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -60, 0, 45)
    content.Position = UDim2.new(0, 55, 0, 35)
    content.BackgroundTransparency = 1
    content.Text = Config.Content or ""
    content.TextColor3 = self.Theme.Text
    content.TextTransparency = 0.3
    content.TextSize = 12
    content.Font = Enum.Font.Gotham
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.TextWrapped = true
    content.Parent = notifyFrame
    
    -- Анимация появления
    SafeTween(notifyFrame, {
        Position = UDim2.new(1, -320, 0, 20)
    }, 0.5, Enum.EasingStyle.Back)
    
    -- Автоматическое закрытие
    local duration = Config.Duration or 5
    if duration > 0 then
        delay(duration, function()
            if notifyGui and notifyGui.Parent then
                SafeTween(notifyFrame, {
                    Position = UDim2.new(1, 320, 0, notifyFrame.Position.Y.Offset)
                }, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                    if notifyGui.Parent then
                        notifyGui:Destroy()
                    end
                end)
            end
        end)
    end
    
    return {
        Destroy = function()
            if notifyGui and notifyGui.Parent then
                notifyGui:Destroy()
            end
        end
    }
end

-- 🎯 УНИЧТОЖЕНИЕ ОКНА
function TelaryUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    if TelaryUI.Windows then
        TelaryUI.Windows[self.ID] = nil
    end
end

-- 🌍 ГЛОБАЛЬНЫЕ ФУНКЦИИ
function TelaryUI:GetAvailableThemes()
    local themeList = {}
    for name, _ in pairs(Themes) do
        table.insert(themeList, name)
    end
    table.sort(themeList)
    return themeList
end

function TelaryUI:CreateDemoWindow()
    local demoWindow = self:CreateWindow({
        Title = "Telary UI - Демо",
        Size = UDim2.new(0, 450, 0, 500),
        Theme = "Cyber",
        Center = true
    })
    
    local mainTab = demoWindow:CreateTab("Главная")
    local demoSection = mainTab:CreateSection("Демонстрация")
    
    demoSection:CreateButton({
        Title = "Тестовая кнопка",
        Callback = function()
            demoWindow:Notify({
                Title = "Успех!",
                Content = "Кнопка работает корректно!",
                Type = "success",
                Duration = 3
            })
        end
    })
    
    demoSection:CreateToggle({
        Title = "Пример переключателя",
        Default = true,
        Callback = function(value)
            print("Переключатель:", value)
        end
    })
    
    demoSection:CreateSlider({
        Title = "Пример слайдера",
        Min = 0,
        Max = 100,
        Default = 50,
        Callback = function(value)
            print("Слайдер:", value)
        end
    })
    
    return demoWindow
end

-- 🚀 ИНИЦИАЛИЗАЦИЯ
function TelaryUI:Initialize()
    print("✅ Telary UI инициализирована!")
    print("🎨 Доступные темы:", table.concat(self:GetAvailableThemes(), ", "))
end

-- Автоматическая инициализация
coroutine.wrap(function()
    wait(1)
    TelaryUI:Initialize()
end)()

return TelaryUI
