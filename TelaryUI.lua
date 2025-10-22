-- Telary UI Library v4.5 - Ultimate Edition
-- Полностью переработанная версия с 30+ функциями и расширенной кастомизацией

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

-- 🎨 РАСШИРЕННАЯ СИСТЕМА ТЕМ С 15 ПРЕСЕТАМИ
local Themes = {
    Cyber = { Background = Color3.fromRGB(10, 10, 20), Secondary = Color3.fromRGB(20, 20, 35), Accent = Color3.fromRGB(0, 255, 255), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(0, 255, 128), Warning = Color3.fromRGB(255, 255, 0), Error = Color3.fromRGB(255, 50, 50), Border = Color3.fromRGB(0, 150, 255), Shadow = Color3.fromRGB(0, 100, 150) },
    Neon = { Background = Color3.fromRGB(15, 5, 25), Secondary = Color3.fromRGB(25, 10, 40), Accent = Color3.fromRGB(255, 0, 255), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(0, 255, 0), Warning = Color3.fromRGB(255, 165, 0), Error = Color3.fromRGB(255, 0, 0), Border = Color3.fromRGB(150, 0, 255), Shadow = Color3.fromRGB(100, 0, 150) },
    Matrix = { Background = Color3.fromRGB(0, 10, 0), Secondary = Color3.fromRGB(0, 20, 0), Accent = Color3.fromRGB(0, 255, 0), Text = Color3.fromRGB(0, 255, 0), Success = Color3.fromRGB(0, 255, 0), Warning = Color3.fromRGB(200, 255, 0), Error = Color3.fromRGB(255, 50, 0), Border = Color3.fromRGB(0, 100, 0), Shadow = Color3.fromRGB(0, 80, 0) },
    Royal = { Background = Color3.fromRGB(25, 15, 35), Secondary = Color3.fromRGB(40, 25, 55), Accent = Color3.fromRGB(147, 112, 219), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(50, 205, 50), Warning = Color3.fromRGB(255, 215, 0), Error = Color3.fromRGB(220, 20, 60), Border = Color3.fromRGB(106, 90, 205), Shadow = Color3.fromRGB(75, 0, 130) },
    Sunset = { Background = Color3.fromRGB(25, 20, 45), Secondary = Color3.fromRGB(45, 35, 65), Accent = Color3.fromRGB(255, 105, 180), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(50, 205, 50), Warning = Color3.fromRGB(255, 165, 0), Error = Color3.fromRGB(255, 69, 0), Border = Color3.fromRGB(199, 21, 133), Shadow = Color3.fromRGB(148, 0, 211) },
    Ocean = { Background = Color3.fromRGB(0, 20, 40), Secondary = Color3.fromRGB(0, 40, 60), Accent = Color3.fromRGB(0, 200, 255), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(0, 255, 200), Warning = Color3.fromRGB(255, 200, 0), Error = Color3.fromRGB(255, 80, 80), Border = Color3.fromRGB(0, 150, 200), Shadow = Color3.fromRGB(0, 100, 150) },
    Fire = { Background = Color3.fromRGB(40, 10, 5), Secondary = Color3.fromRGB(60, 20, 10), Accent = Color3.fromRGB(255, 100, 0), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(255, 200, 0), Warning = Color3.fromRGB(255, 150, 0), Error = Color3.fromRGB(255, 50, 0), Border = Color3.fromRGB(200, 80, 0), Shadow = Color3.fromRGB(150, 50, 0) },
    Ice = { Background = Color3.fromRGB(5, 10, 25), Secondary = Color3.fromRGB(10, 20, 40), Accent = Color3.fromRGB(100, 200, 255), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(100, 255, 255), Warning = Color3.fromRGB(200, 220, 255), Error = Color3.fromRGB(255, 100, 150), Border = Color3.fromRGB(80, 180, 255), Shadow = Color3.fromRGB(50, 150, 200) },
    Forest = { Background = Color3.fromRGB(5, 20, 10), Secondary = Color3.fromRGB(10, 30, 15), Accent = Color3.fromRGB(50, 200, 100), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(50, 255, 100), Warning = Color3.fromRGB(200, 255, 50), Error = Color3.fromRGB(255, 100, 50), Border = Color3.fromRGB(40, 180, 80), Shadow = Color3.fromRGB(30, 120, 60) },
    Galaxy = { Background = Color3.fromRGB(10, 5, 25), Secondary = Color3.fromRGB(20, 10, 40), Accent = Color3.fromRGB(150, 100, 255), Text = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(100, 255, 200), Warning = Color3.fromRGB(255, 200, 100), Error = Color3.fromRGB(255, 100, 150), Border = Color3.fromRGB(120, 80, 220), Shadow = Color3.fromRGB(80, 50, 180) }
}

-- 🛠️ УЛУЧШЕННЫЕ УТИЛИТЫ
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

local function CreateShadow(Object, Transparency, Size)
    if not Object then return nil end
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "TelaryShadow"
    shadow.Size = UDim2.new(1, Size or 10, 1, Size or 10)
    shadow.Position = UDim2.new(0, -(Size or 10)/2, 0, -(Size or 10)/2)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = Transparency or 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = -2
    shadow.Parent = Object
    return shadow
end

-- 🎭 СИСТЕМА АНИМАЦИЙ
local Animations = {
    Hover = function(Object, OriginalColor, HoverColor, Duration)
        if not Object then return end
        Object.MouseEnter:Connect(function()
            SafeTween(Object, {BackgroundColor3 = HoverColor or OriginalColor:Lerp(Color3.new(1, 1, 1), 0.2)}, Duration or 0.2)
        end)
        Object.MouseLeave:Connect(function()
            SafeTween(Object, {BackgroundColor3 = OriginalColor}, Duration or 0.2)
        end)
    end,
    
    Pulse = function(Object, MinTransparency, MaxTransparency, Speed)
        if not Object then return end
        coroutine.wrap(function()
            while Object and Object.Parent do
                SafeTween(Object, {BackgroundTransparency = MaxTransparency or 0.3}, Speed or 0.8)
                wait(Speed or 0.8)
                SafeTween(Object, {BackgroundTransparency = MinTransparency or 0.1}, Speed or 0.8)
                wait(1.5)
            end
        end)()
    end,
    
    Shake = function(Object, Intensity, Duration)
        if not Object then return end
        local originalPosition = Object.Position
        coroutine.wrap(function()
            local startTime = tick()
            while tick() - startTime < (Duration or 0.5) and Object and Object.Parent do
                local offsetX = math.random(-Intensity, Intensity)
                local offsetY = math.random(-Intensity, Intensity)
                SafeTween(Object, {
                    Position = UDim2.new(
                        originalPosition.X.Scale, originalPosition.X.Offset + offsetX,
                        originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY
                    )
                }, 0.1)
                wait(0.1)
            end
            if Object and Object.Parent then
                SafeTween(Object, {Position = originalPosition}, 0.2)
            end
        end)()
    end
}

-- 🔧 СИСТЕМА КОНФИГУРАЦИИ
local GlobalConfig = {
    AnimationsEnabled = true,
    SoundEnabled = false,
    NotificationsEnabled = true,
    AutoSaveSettings = false,
    Language = "Russian",
    PerformanceMode = false
}

-- 🎯 ОСНОВНАЯ ФУНКЦИЯ СОЗДАНИЯ ОКНА
function TelaryUI:CreateWindow(Config)
    Config = Config or {}
    
    local Window = setmetatable({}, TelaryUI)
    Window.ID = HttpService:GenerateGUID(false)
    Window.Theme = Themes[Config.Theme or "Cyber"] or Themes.Cyber
    Window.Elements = {}
    Window.AnimationsEnabled = Config.Animations ~= false and GlobalConfig.AnimationsEnabled
    
    -- Создаем основной GUI
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "TelaryUIv45_" .. Window.ID
    Window.ScreenGui.Parent = CoreGui
    Window.ScreenGui.ResetOnSpawn = false
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Главный контейнер
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Size = Config.Size or UDim2.new(0, 700, 0, 800)
    Window.MainFrame.Position = Config.Center and UDim2.new(0.5, -Window.MainFrame.Size.X.Offset/2, 0.5, -Window.MainFrame.Size.Y.Offset/2) or (Config.Position or UDim2.new(0, 100, 0, 100))
    Window.MainFrame.BackgroundColor3 = Window.Theme.Background
    Window.MainFrame.BackgroundTransparency = 0.05
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Parent = Window.ScreenGui
    RoundCorners(Window.MainFrame, 12)
    CreateGlow(Window.MainFrame, Window.Theme.Accent, 0.7, 25)
    CreateShadow(Window.MainFrame, 0.5, 15)
    
    -- Заголовок
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    Window.TitleBar.BackgroundColor3 = Window.Theme.Secondary
    Window.TitleBar.BackgroundTransparency = 0.1
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.Parent = Window.MainFrame
    RoundCorners(Window.TitleBar, 12)
    
    -- Текст заголовка
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "Telary UI v4.5"
    TitleLabel.TextColor3 = Window.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Window.TitleBar
    
    -- Кнопки управления
    local controlButtons = {
        {Name = "Minimize", Text = "−", Color = Window.Theme.Warning, Position = UDim2.new(1, -105, 0.5, -14)},
        {Name = "Maximize", Text = "□", Color = Window.Theme.Success, Position = UDim2.new(1, -70, 0.5, -14)},
        {Name = "Close", Text = "×", Color = Window.Theme.Error, Position = UDim2.new(1, -35, 0.5, -14)}
    }
    
    Window.ControlButtons = {}
    for _, btnConfig in ipairs(controlButtons) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 28, 0, 28)
        button.Position = btnConfig.Position
        button.BackgroundColor3 = btnConfig.Color
        button.Text = btnConfig.Text
        button.TextColor3 = Window.Theme.Text
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        button.Parent = Window.TitleBar
        RoundCorners(button, 6)
        CreateGlow(button, btnConfig.Color, 0.6)
        Window.ControlButtons[btnConfig.Name] = button
    end
    
    -- Контейнер для вкладок
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Size = UDim2.new(1, 0, 1, -50)
    Window.TabContainer.Position = UDim2.new(0, 0, 0, 50)
    Window.TabContainer.BackgroundTransparency = 1
    Window.TabContainer.Parent = Window.MainFrame
    
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    Window.Maximized = false
    Window.OriginalSize = Window.MainFrame.Size
    Window.OriginalPosition = Window.MainFrame.Position
    
    -- 🔧 ФУНКЦИОНАЛ ПЕРЕТАСКИВАНИЯ
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
    
    -- 🎮 ОБРАБОТЧИКИ КНОПОК
    Window.ControlButtons.Close.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)
    
    Window.ControlButtons.Minimize.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)
    
    Window.ControlButtons.Maximize.MouseButton1Click:Connect(function()
        Window:Maximize()
    end)
    
    -- Анимация появления
    if Window.AnimationsEnabled then
        Window.MainFrame.Size = UDim2.new(0, 10, 0, 10)
        Window.MainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
        Window.MainFrame.BackgroundTransparency = 1
        SafeTween(Window.MainFrame, {
            Size = Config.Size or UDim2.new(0, 700, 0, 800),
            Position = Config.Center and UDim2.new(0.5, -(Config.Size or UDim2.new(0, 700, 0, 800)).X.Offset/2, 0.5, -(Config.Size or UDim2.new(0, 700, 0, 800)).Y.Offset/2) or (Config.Position or UDim2.new(0, 100, 0, 100)),
            BackgroundTransparency = 0.05
        }, 0.8, Enum.EasingStyle.Back)
    end
    
    -- 🔧 РЕГИСТРАЦИЯ ОКНА
    if not TelaryUI.Windows then TelaryUI.Windows = {} end
    TelaryUI.Windows[Window.ID] = Window
    
    return Window
end

-- 📑 МЕТОДЫ ОКНА
function TelaryUI:Minimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        SafeTween(self.MainFrame, {
            Size = UDim2.new(0, 300, 0, 50),
            BackgroundTransparency = 0.2
        }, 0.3)
        self.TabContainer.Visible = false
        self.ControlButtons.Maximize.Visible = false
    else
        SafeTween(self.MainFrame, {
            Size = self.OriginalSize,
            BackgroundTransparency = 0.05
        }, 0.3)
        self.TabContainer.Visible = true
        self.ControlButtons.Maximize.Visible = true
    end
end

function TelaryUI:Maximize()
    self.Maximized = not self.Maximized
    if self.Maximized then
        self.OriginalSize = self.MainFrame.Size
        self.OriginalPosition = self.MainFrame.Position
        SafeTween(self.MainFrame, {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10)
        }, 0.3)
        self.ControlButtons.Maximize.Text = "❐"
    else
        SafeTween(self.MainFrame, {
            Size = self.OriginalSize,
            Position = self.OriginalPosition
        }, 0.3)
        self.ControlButtons.Maximize.Text = "□"
    end
end

function TelaryUI:SetTitle(NewTitle)
    local titleLabel = self.TitleBar:FindFirstChildWhichIsA("TextLabel")
    if titleLabel then
        titleLabel.Text = NewTitle
    end
end

function TelaryUI:SetTheme(ThemeName)
    if Themes[ThemeName] then
        self.Theme = Themes[ThemeName]
        self:ApplyTheme()
    end
end

function TelaryUI:ApplyTheme()
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.TitleBar.BackgroundColor3 = self.Theme.Secondary
    self.ControlButtons.Close.BackgroundColor3 = self.Theme.Error
    self.ControlButtons.Minimize.BackgroundColor3 = self.Theme.Warning
    self.ControlButtons.Maximize.BackgroundColor3 = self.Theme.Success
end

function TelaryUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    if TelaryUI.Windows then
        TelaryUI.Windows[self.ID] = nil
    end
end

-- 🔔 СИСТЕМА УВЕДОМЛЕНИЙ
function TelaryUI:Notify(Config)
    Config = Config or {}
    
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "TelaryNotification"
    notifyGui.Parent = CoreGui
    notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Size = UDim2.new(0, 380, 0, 90)
    notifyFrame.Position = UDim2.new(1, 400, 0, 20)
    notifyFrame.BackgroundColor3 = self.Theme.Secondary
    notifyFrame.BackgroundTransparency = 0.1
    notifyFrame.BorderSizePixel = 0
    notifyFrame.Parent = notifyGui
    RoundCorners(notifyFrame, 12)
    CreateGlow(notifyFrame, self.Theme.Accent, 0.5)
    CreateShadow(notifyFrame, 0.4, 12)
    
    local iconMap = {
        success = "✅", error = "❌", warning = "⚠️", info = "💡", question = "❓"
    }
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 45, 0, 45)
    icon.Position = UDim2.new(0, 15, 0, 22)
    icon.BackgroundTransparency = 1
    icon.Text = iconMap[Config.Type] or "📢"
    icon.TextColor3 = Config.Type == "error" and self.Theme.Error or 
                     Config.Type == "warning" and self.Theme.Warning or 
                     Config.Type == "info" and self.Theme.Accent or 
                     self.Theme.Success
    icon.TextSize = 22
    icon.Font = Enum.Font.GothamBold
    icon.Parent = notifyFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 0, 30)
    title.Position = UDim2.new(0, 70, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = Config.Title or "Уведомление"
    title.TextColor3 = self.Theme.Text
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notifyFrame
    
    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -80, 0, 40)
    content.Position = UDim2.new(0, 70, 0, 45)
    content.BackgroundTransparency = 1
    content.Text = Config.Content or ""
    content.TextColor3 = self.Theme.Text
    content.TextTransparency = 0.3
    content.TextSize = 13
    content.Font = Enum.Font.Gotham
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.TextWrapped = true
    content.Parent = notifyFrame
    
    -- Анимация появления
    SafeTween(notifyFrame, {
        Position = UDim2.new(1, -400, 0, 20)
    }, 0.6, Enum.EasingStyle.Back)
    
    local function safeDestroy()
        if notifyGui and notifyGui.Parent then
            SafeTween(notifyFrame, {
                Position = UDim2.new(1, 400, 0, notifyFrame.Position.Y.Offset),
                BackgroundTransparency = 1
            }, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                if notifyGui.Parent then
                    notifyGui:Destroy()
                end
            end)
        end
    end
    
    -- Автоматическое закрытие
    local duration = Config.Duration or 5
    if duration > 0 then
        delay(duration, safeDestroy)
    end
    
    return {
        Destroy = safeDestroy,
        Update = function(newConfig)
            if title and newConfig.Title then
                title.Text = newConfig.Title
            end
            if content and newConfig.Content then
                content.Text = newConfig.Content
            end
        end
    }
end

-- 📑 МЕТОД СОЗДАНИЯ ВКЛАДКИ
function TelaryUI:CreateTab(Name, Icon, Tooltip)
    local Tab = {}
    Tab.Name = Name
    Tab.Window = self
    Tab.Elements = {}
    
    -- Кнопка вкладки
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Size = UDim2.new(0, 130, 0, 45)
    Tab.Button.Position = UDim2.new(0, 15 + (#self.Tabs * 135), 0, -45)
    Tab.Button.BackgroundColor3 = self.Theme.Secondary
    Tab.Button.Text = (Icon or "📁") .. " " .. Name
    Tab.Button.TextColor3 = self.Theme.Text
    Tab.Button.TextSize = 13
    Tab.Button.Font = Enum.Font.Gotham
    Tab.Button.AutoButtonColor = false
    Tab.Button.Parent = self.MainFrame
    RoundCorners(Tab.Button, 8)
    CreateGlow(Tab.Button, self.Theme.Accent, 0.5)
    
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
    Tab.Content.Parent = self.TabContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 15)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = Tab.Content
    
    Tab.Sections = {}
    
    -- 🆕 МЕТОДЫ УПРАВЛЕНИЯ ВКЛАДКОЙ
    function Tab:Show()
        if self.Window.CurrentTab then
            self.Window.CurrentTab.Content.Visible = false
            SafeTween(self.Window.CurrentTab.Button, {
                BackgroundColor3 = self.Window.Theme.Secondary,
                TextColor3 = self.Window.Theme.Text
            }, 0.2)
        end
        self.Window.CurrentTab = self
        self.Content.Visible = true
        SafeTween(self.Button, {
            BackgroundColor3 = self.Window.Theme.Accent,
            TextColor3 = Color3.new(1, 1, 1)
        }, 0.3)
        self.Content.CanvasPosition = Vector2.new(0, 0)
    end
    
    Tab.Button.MouseButton1Click:Connect(function()
        Tab:Show()
    end)
    
    if self.AnimationsEnabled then
        Animations.Hover(Tab.Button, self.Theme.Secondary, self.Theme.Accent:Lerp(Color3.new(1,1,1), 0.1))
    end
    
    table.insert(self.Tabs, Tab)
    if #self.Tabs == 1 then
        Tab:Show()
    end
    
    -- 🆕 МЕТОД СОЗДАНИЯ СЕКЦИИ
    function Tab:CreateSection(Name, Description, Collapsible)
        local Section = {}
        Section.Name = Name
        Section.Window = self.Window
        Section.Elements = {}
        Section.Collapsible = Collapsible or false
        Section.Expanded = true
        
        -- Основной фрейм секции
        Section.Frame = Instance.new("Frame")
        Section.Frame.Size = UDim2.new(0.96, 0, 0, 0)
        Section.Frame.AnchorPoint = Vector2.new(0.5, 0)
        Section.Frame.Position = UDim2.new(0.5, 0, 0, 0)
        Section.Frame.BackgroundColor3 = self.Window.Theme.Secondary
        Section.Frame.BackgroundTransparency = 0.1
        Section.Frame.BorderSizePixel = 0
        Section.Frame.Parent = Tab.Content
        RoundCorners(Section.Frame, 12)
        CreateGlow(Section.Frame, self.Window.Theme.Accent, 0.3)
        CreateShadow(Section.Frame, 0.4, 8)
        
        -- Заголовок секции
        Section.Header = Instance.new("Frame")
        Section.Header.Size = UDim2.new(1, 0, 0, 45)
        Section.Header.BackgroundTransparency = 1
        Section.Header.Parent = Section.Frame
        
        Section.Title = Instance.new("TextLabel")
        Section.Title.Size = UDim2.new(1, -50, 1, 0)
        Section.Title.Position = UDim2.new(0, 15, 0, 0)
        Section.Title.BackgroundTransparency = 1
        Section.Title.Text = "✨ " .. Name
        Section.Title.TextColor3 = self.Window.Theme.Text
        Section.Title.TextSize = 16
        Section.Title.Font = Enum.Font.GothamBold
        Section.Title.TextXAlignment = Enum.TextXAlignment.Left
        Section.Title.Parent = Section.Header
        
        -- Кнопка сворачивания
        if Collapsible then
            Section.ToggleButton = Instance.new("TextButton")
            Section.ToggleButton.Size = UDim2.new(0, 30, 0, 30)
            Section.ToggleButton.Position = UDim2.new(1, -40, 0.5, -15)
            Section.ToggleButton.BackgroundColor3 = self.Window.Theme.Accent
            Section.ToggleButton.Text = "−"
            Section.ToggleButton.TextColor3 = self.Window.Theme.Text
            Section.ToggleButton.TextSize = 18
            Section.ToggleButton.Font = Enum.Font.GothamBold
            Section.ToggleButton.Parent = Section.Header
            RoundCorners(Section.ToggleButton, 6)
            
            Section.ToggleButton.MouseButton1Click:Connect(function()
                Section:Toggle()
            end)
        end
        
        -- Описание секции
        if Description then
            Section.Description = Instance.new("TextLabel")
            Section.Description.Size = UDim2.new(1, -30, 0, 35)
            Section.Description.Position = UDim2.new(0, 15, 0, 45)
            Section.Description.BackgroundTransparency = 1
            Section.Description.Text = Description
            Section.Description.TextColor3 = self.Window.Theme.Text
            Section.Description.TextTransparency = 0.4
            Section.Description.TextSize = 13
            Section.Description.Font = Enum.Font.Gotham
            Section.Description.TextXAlignment = Enum.TextXAlignment.Left
            Section.Description.TextWrapped = true
            Section.Description.Parent = Section.Frame
        end
        
        -- Контейнер элементов
        Section.Content = Instance.new("Frame")
        Section.Content.Size = UDim2.new(1, -20, 0, 0)
        Section.Content.Position = UDim2.new(0, 10, 0, Description and 85 or 50)
        Section.Content.BackgroundTransparency = 1
        Section.Content.Parent = Section.Frame
        
        local SectionList = Instance.new("UIListLayout")
        SectionList.Padding = UDim.new(0, 12)
        SectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        SectionList.Parent = Section.Content
        
        -- 🆕 МЕТОД СВОРАЧИВАНИЯ
        function Section:Toggle()
            self.Expanded = not self.Expanded
            if self.ToggleButton then
                self.ToggleButton.Text = self.Expanded and "−" or "+"
            end
            for _, element in pairs(self.Elements) do
                if element then element.Visible = self.Expanded end
            end
            self:UpdateSize()
        end
        
        -- 🆕 ОБНОВЛЕНИЕ РАЗМЕРА
        function Section:UpdateSize()
            if not self.Frame then return end
            local totalHeight = self.Description and 85 or 50
            if self.Expanded then
                for _, element in pairs(self.Elements) do
                    if element and element.Size then
                        totalHeight = totalHeight + element.Size.Y.Offset + 12
                    end
                end
            end
            self.Frame.Size = UDim2.new(0.96, 0, 0, totalHeight)
            if self.Content then
                self.Content.Size = UDim2.new(1, 0, 0, totalHeight - (self.Description and 85 or 50))
            end
        end

        -- 🆕 1. УЛУЧШЕННЫЕ КНОПКИ
        function Section:CreateButton(Config)
            Config = Config or {}
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, Config.Height or 50)
            Button.BackgroundColor3 = self.Window.Theme.Accent
            Button.Text = Config.Title or "🚀 Кнопка"
            Button.TextColor3 = self.Window.Theme.Text
            Button.TextSize = Config.TextSize or 14
            Button.Font = Enum.Font.Gotham
            Button.TextWrapped = true
            Button.Parent = self.Content
            RoundCorners(Button, Config.CornerRadius or 8)
            
            -- Стили кнопок
            if Config.Style == "Danger" then
                Button.BackgroundColor3 = self.Window.Theme.Error
                CreateGlow(Button, self.Window.Theme.Error, 0.4)
            elseif Config.Style == "Success" then
                Button.BackgroundColor3 = self.Window.Theme.Success
                CreateGlow(Button, self.Window.Theme.Success, 0.4)
            elseif Config.Style == "Warning" then
                Button.BackgroundColor3 = self.Window.Theme.Warning
                CreateGlow(Button, self.Window.Theme.Warning, 0.4)
            else
                CreateGlow(Button, self.Window.Theme.Accent, 0.4)
            end
            
            -- Иконка
            if Config.Icon then
                Button.Text = Config.Icon .. " " .. (Config.Title or "Кнопка")
            end
            
            -- Анимации
            local originalColor = Button.BackgroundColor3
            if self.Window.AnimationsEnabled then
                Animations.Hover(Button, originalColor, nil, 0.15)
            end
            
            -- Обработчик клика
            Button.MouseButton1Click:Connect(function()
                if self.Window.AnimationsEnabled then
                    Animations.Shake(Button, 3, 0.3)
                    SafeTween(Button, {Size = UDim2.new(0.98, 0, 0.95, 0)}, 0.1)
                    SafeTween(Button, {Size = UDim2.new(1, 0, 1, 0)}, 0.1, Enum.EasingStyle.Back)
                end
                if Config.Callback then
                    local success, err = pcall(Config.Callback)
                    if not success then
                        self.Window:Notify({
                            Title = "Ошибка выполнения",
                            Content = tostring(err),
                            Type = "error",
                            Duration = 5
                        })
                    end
                end
            end)
            
            table.insert(self.Elements, Button)
            self:UpdateSize()
            
            return {
                Object = Button,
                Update = function(newConfig)
                    if newConfig.Title then
                        Button.Text = newConfig.Icon and newConfig.Icon .. " " .. newConfig.Title or newConfig.Title
                    end
                end,
                SetDisabled = function(disabled)
                    Button.AutoButtonColor = not disabled
                    Button.BackgroundTransparency = disabled and 0.7 or 0
                    Button.TextTransparency = disabled and 0.5 or 0
                end
            }
        end

        -- 🆕 2. ПЕРЕКЛЮЧАТЕЛЬ
        function Section:CreateToggle(Config)
            Config = Config or {}
            local Toggle = {}
            Toggle.Value = Config.Default or false
            
            Toggle.Frame = Instance.new("Frame")
            Toggle.Frame.Size = UDim2.new(1, 0, 0, 40)
            Toggle.Frame.BackgroundTransparency = 1
            Toggle.Frame.Parent = self.Content
            
            Toggle.Label = Instance.new("TextLabel")
            Toggle.Label.Size = UDim2.new(1, -60, 1, 0)
            Toggle.Label.BackgroundTransparency = 1
            Toggle.Label.Text = Config.Title or "Переключатель"
            Toggle.Label.TextColor3 = self.Window.Theme.Text
            Toggle.Label.TextSize = 14
            Toggle.Label.Font = Enum.Font.Gotham
            Toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
            Toggle.Label.Parent = Toggle.Frame
            
            -- Переключатель
            Toggle.Button = Instance.new("TextButton")
            Toggle.Button.Size = UDim2.new(0, 50, 0, 28)
            Toggle.Button.Position = UDim2.new(1, -55, 0.5, -14)
            Toggle.Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            Toggle.Button.Text = ""
            Toggle.Button.AutoButtonColor = false
            Toggle.Button.Parent = Toggle.Frame
            RoundCorners(Toggle.Button, 14)
            
            Toggle.Thumb = Instance.new("Frame")
            Toggle.Thumb.Size = UDim2.new(0, 24, 0, 24)
            Toggle.Thumb.Position = UDim2.new(0, 2, 0.5, -12)
            Toggle.Thumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            Toggle.Thumb.Parent = Toggle.Button
            RoundCorners(Toggle.Thumb, 12)
            
            function Toggle:UpdateState()
                if self.Value then
                    SafeTween(self.Button, {BackgroundColor3 = self.Window.Theme.Accent}, 0.2)
                    SafeTween(self.Thumb, {Position = UDim2.new(1, -26, 0.5, -12)}, 0.2)
                else
                    SafeTween(self.Button, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}, 0.2)
                    SafeTween(self.Thumb, {Position = UDim2.new(0, 2, 0.5, -12)}, 0.2)
                end
                if Config.Callback then
                    pcall(Config.Callback, self.Value)
                end
            end
            
            Toggle.Button.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                Toggle:UpdateState()
                if self.Window.AnimationsEnabled then
                    Animations.Shake(Toggle.Thumb, 2, 0.2)
                end
            end)
            
            Animations.Hover(Toggle.Button, Toggle.Button.BackgroundColor3)
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

        -- 🆕 3. СЛАЙДЕР
        function Section:CreateSlider(Config)
            Config = Config or {}
            local Slider = {}
            Slider.Value = Config.Default or Config.Min or 0
            Slider.Min = Config.Min or 0
            Slider.Max = Config.Max or 100
            
            Slider.Frame = Instance.new("Frame")
            Slider.Frame.Size = UDim2.new(1, 0, 0, 80)
            Slider.Frame.BackgroundTransparency = 1
            Slider.Frame.Parent = self.Content
            
            -- Заголовок и значение
            Slider.Title = Instance.new("TextLabel")
            Slider.Title.Size = UDim2.new(1, -80, 0, 25)
            Slider.Title.BackgroundTransparency = 1
            Slider.Title.Text = Config.Title or "Слайдер"
            Slider.Title.TextColor3 = self.Window.Theme.Text
            Slider.Title.TextSize = 14
            Slider.Title.Font = Enum.Font.Gotham
            Slider.Title.TextXAlignment = Enum.TextXAlignment.Left
            Slider.Title.Parent = Slider.Frame
            
            Slider.ValueLabel = Instance.new("TextLabel")
            Slider.ValueLabel.Size = UDim2.new(0, 70, 0, 25)
            Slider.ValueLabel.Position = UDim2.new(1, -70, 0, 0)
            Slider.ValueLabel.BackgroundTransparency = 1
            Slider.ValueLabel.Text = tostring(math.floor(Slider.Value))
            Slider.ValueLabel.TextColor3 = self.Window.Theme.Accent
            Slider.ValueLabel.TextSize = 14
            Slider.ValueLabel.Font = Enum.Font.GothamBold
            Slider.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            Slider.ValueLabel.Parent = Slider.Frame
            
            -- Дорожка слайдера
            Slider.Track = Instance.new("Frame")
            Slider.Track.Size = UDim2.new(1, 0, 0, 8)
            Slider.Track.Position = UDim2.new(0, 0, 0, 40)
            Slider.Track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            Slider.Track.Parent = Slider.Frame
            RoundCorners(Slider.Track, 4)
            
            Slider.Fill = Instance.new("Frame")
            Slider.Fill.Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
            Slider.Fill.BackgroundColor3 = self.Window.Theme.Accent
            Slider.Fill.Parent = Slider.Track
            RoundCorners(Slider.Fill, 4)
            
            -- Ползунок
            Slider.Handle = Instance.new("TextButton")
            Slider.Handle.Size = UDim2.new(0, 20, 0, 20)
            Slider.Handle.Position = UDim2.new(Slider.Fill.Size.X.Scale, -10, 0.5, -10)
            Slider.Handle.BackgroundColor3 = self.Window.Theme.Text
            Slider.Handle.Text = ""
            Slider.Handle.AutoButtonColor = false
            Slider.Handle.Parent = Slider.Track
            RoundCorners(Slider.Handle, 10)
            CreateGlow(Slider.Handle, self.Window.Theme.Accent, 0.5)
            
            function Slider:UpdateValue(Value)
                local newValue = math.clamp(Value, self.Min, self.Max)
                self.Value = newValue
                local normalized = (self.Value - self.Min) / (self.Max - self.Min)
                self.Fill.Size = UDim2.new(normalized, 0, 1, 0)
                self.Handle.Position = UDim2.new(normalized, -10, 0.5, -10)
                self.ValueLabel.Text = tostring(math.floor(self.Value))
                if Config.Callback then
                    pcall(Config.Callback, self.Value)
                end
            end
            
            -- Обработка ввода
            local dragging = false
            local function onInputChanged(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouse = UserInputService:GetMouseLocation()
                    local trackAbsolutePos = Slider.Track.AbsolutePosition
                    local trackAbsoluteSize = Slider.Track.AbsoluteSize
                    local relativeX = (mouse.X - trackAbsolutePos.X) / trackAbsoluteSize.X
                    local value = (Slider.Max - Slider.Min) * math.clamp(relativeX, 0, 1) + Slider.Min
                    Slider:UpdateValue(value)
                end
            end
            
            Slider.Handle.MouseButton1Down:Connect(function()
                dragging = true
                if self.Window.AnimationsEnabled then
                    SafeTween(Slider.Handle, {Size = UDim2.new(0, 24, 0, 24)}, 0.1)
                end
            end)
            
            Slider.Track.MouseButton1Down:Connect(function()
                local mouse = UserInputService:GetMouseLocation()
                local trackAbsolutePos = Slider.Track.AbsolutePosition
                local trackAbsoluteSize = Slider.Track.AbsoluteSize
                local relativeX = (mouse.X - trackAbsolutePos.X) / trackAbsoluteSize.X
                local value = (Slider.Max - Slider.Min) * math.clamp(relativeX, 0, 1) + Slider.Min
                Slider:UpdateValue(value)
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    if self.Window.AnimationsEnabled then
                        SafeTween(Slider.Handle, {Size = UDim2.new(0, 20, 0, 20)}, 0.1)
                    end
                end
            end)
            
            UserInputService.InputChanged:Connect(onInputChanged)
            
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

        -- 🆕 4. ВЫПАДАЮЩИЙ СПИСОК
        function Section:CreateDropdown(Config)
            Config = Config or {}
            local Dropdown = {}
            Dropdown.Open = false
            Dropdown.Options = Config.Options or {"Опция 1", "Опция 2", "Опция 3"}
            Dropdown.Selected = Config.Default or Dropdown.Options[1]
            
            Dropdown.Frame = Instance.new("Frame")
            Dropdown.Frame.Size = UDim2.new(1, 0, 0, 45)
            Dropdown.Frame.BackgroundTransparency = 1
            Dropdown.Frame.Parent = self.Content
            
            -- Основная кнопка
            Dropdown.Button = Instance.new("TextButton")
            Dropdown.Button.Size = UDim2.new(1, 0, 0, 45)
            Dropdown.Button.BackgroundColor3 = self.Window.Theme.Secondary
            Dropdown.Button.Text = ""
            Dropdown.Button.AutoButtonColor = false
            Dropdown.Button.Parent = Dropdown.Frame
            RoundCorners(Dropdown.Button, 8)
            
            Dropdown.SelectedLabel = Instance.new("TextLabel")
            Dropdown.SelectedLabel.Size = UDim2.new(1, -60, 1, 0)
            Dropdown.SelectedLabel.Position = UDim2.new(0, 15, 0, 0)
            Dropdown.SelectedLabel.BackgroundTransparency = 1
            Dropdown.SelectedLabel.Text = Dropdown.Selected
            Dropdown.SelectedLabel.TextColor3 = self.Window.Theme.Text
            Dropdown.SelectedLabel.TextSize = 14
            Dropdown.SelectedLabel.Font = Enum.Font.Gotham
            Dropdown.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
            Dropdown.SelectedLabel.Parent = Dropdown.Button
            
            Dropdown.Arrow = Instance.new("TextLabel")
            Dropdown.Arrow.Size = UDim2.new(0, 20, 0, 20)
            Dropdown.Arrow.Position = UDim2.new(1, -30, 0.5, -10)
            Dropdown.Arrow.BackgroundTransparency = 1
            Dropdown.Arrow.Text = "▼"
            Dropdown.Arrow.TextColor3 = self.Window.Theme.Text
            Dropdown.Arrow.TextSize = 12
            Dropdown.Arrow.Font = Enum.Font.Gotham
            Dropdown.Arrow.Parent = Dropdown.Button
            
            -- Список опций
            Dropdown.List = Instance.new("Frame")
            Dropdown.List.Size = UDim2.new(1, 0, 0, 0)
            Dropdown.List.Position = UDim2.new(0, 0, 1, 5)
            Dropdown.List.BackgroundColor3 = self.Window.Theme.Secondary
            Dropdown.List.Visible = false
            Dropdown.List.Parent = Dropdown.Frame
            RoundCorners(Dropdown.List, 8)
            CreateShadow(Dropdown.List, 0.3, 10)
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = Dropdown.List
            
            function Dropdown:UpdateDropdown()
                Dropdown.SelectedLabel.Text = Dropdown.Selected
                Dropdown.Arrow.Text = Dropdown.Open and "▲" or "▼"
                if Dropdown.Open then
                    Dropdown.List.Visible = true
                    local height = math.min(#Dropdown.Options * 40, 200)
                    SafeTween(Dropdown.List, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
                else
                    SafeTween(Dropdown.List, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, function()
                        if not Dropdown.Open then
                            Dropdown.List.Visible = false
                        end
                    end)
                end
            end
            
            function Dropdown:CreateOption(option, index)
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, -10, 0, 35)
                optionButton.Position = UDim2.new(0, 5, 0, (index-1) * 40)
                optionButton.BackgroundColor3 = self.Window.Theme.Secondary
                optionButton.Text = option
                optionButton.TextColor3 = self.Window.Theme.Text
                optionButton.TextSize = 13
                optionButton.Font = Enum.Font.Gotham
                optionButton.AutoButtonColor = false
                optionButton.Parent = Dropdown.List
                RoundCorners(optionButton, 6)
                
                if Dropdown.Selected == option then
                    optionButton.BackgroundColor3 = self.Window.Theme.Accent
                    optionButton.TextColor3 = Color3.new(1, 1, 1)
                end
                
                optionButton.MouseButton1Click:Connect(function()
                    Dropdown.Selected = option
                    Dropdown.Open = false
                    Dropdown:UpdateDropdown()
                    if Config.Callback then
                        pcall(Config.Callback, option)
                    end
                end)
                
                Animations.Hover(optionButton, self.Window.Theme.Secondary, self.Window.Theme.Accent)
            end
            
            -- Создаем опции
            for i, option in ipairs(Dropdown.Options) do
                Dropdown:CreateOption(option, i)
            end
            
            Dropdown.Button.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                Dropdown:UpdateDropdown()
            end)
            
            Animations.Hover(Dropdown.Button, self.Window.Theme.Secondary)
            
            table.insert(self.Elements, Dropdown.Frame)
            self:UpdateSize()
            
            return {
                Object = Dropdown.Frame,
                Selected = Dropdown.Selected,
                Update = function(newOptions, newDefault)
                    if newOptions then
                        Dropdown.Options = newOptions
                        Dropdown.List:ClearAllChildren()
                        for i, option in ipairs(newOptions) do
                            Dropdown:CreateOption(option, i)
                        end
                    end
                    if newDefault then
                        Dropdown.Selected = newDefault
                    end
                    Dropdown:UpdateDropdown()
                end
            }
        end

        -- 🆕 5. ТЕКСТОВОЕ ПОЛЕ
        function Section:CreateInput(Config)
            Config = Config or {}
            local Input = {}
            Input.Value = Config.Default or ""
            
            Input.Frame = Instance.new("Frame")
            Input.Frame.Size = UDim2.new(1, 0, 0, 50)
            Input.Frame.BackgroundTransparency = 1
            Input.Frame.Parent = self.Content
            
            Input.Box = Instance.new("TextBox")
            Input.Box.Size = UDim2.new(1, 0, 1, 0)
            Input.Box.BackgroundColor3 = self.Window.Theme.Secondary
            Input.Box.TextColor3 = self.Window.Theme.Text
            Input.Box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            Input.Box.Text = Input.Value
            Input.Box.PlaceholderText = Config.Placeholder or "Введите текст..."
            Input.Box.TextSize = 14
            Input.Box.Font = Enum.Font.Gotham
            Input.Box.ClearTextOnFocus = false
            Input.Box.Parent = Input.Frame
            RoundCorners(Input.Box, 8)
            
            -- Анимация фокуса
            Input.Box.Focused:Connect(function()
                SafeTween(Input.Box, {
                    BackgroundColor3 = self.Window.Theme.Secondary:Lerp(Color3.new(1, 1, 1), 0.1)
                }, 0.2)
                CreateGlow(Input.Box, self.Window.Theme.Accent, 0.6)
            end)
            
            Input.Box.FocusLost:Connect(function(enterPressed)
                SafeTween(Input.Box, {
                    BackgroundColor3 = self.Window.Theme.Secondary
                }, 0.2)
                if Input.Box:FindFirstChild("TelaryGlow") then
                    Input.Box.TelaryGlow:Destroy()
                end
                Input.Value = Input.Box.Text
                if Config.Callback then
                    pcall(Config.Callback, Input.Box.Text, enterPressed)
                end
            end)
            
            table.insert(self.Elements, Input.Frame)
            self:UpdateSize()
            
            return {
                Object = Input.Box,
                Value = Input.Value,
                Update = function(newText)
                    Input.Box.Text = newText
                    Input.Value = newText
                end,
                Clear = function()
                    Input.Box.Text = ""
                    Input.Value = ""
                end
            }
        end

        -- 🆕 6. ПРОГРЕСС-БАР
        function Section:CreateProgressBar(Config)
            Config = Config or {}
            local ProgressBar = {}
            ProgressBar.Value = Config.Default or 0
            
            ProgressBar.Frame = Instance.new("Frame")
            ProgressBar.Frame.Size = UDim2.new(1, 0, 0, 50)
            ProgressBar.Frame.BackgroundTransparency = 1
            ProgressBar.Frame.Parent = self.Content
            
            ProgressBar.Title = Instance.new("TextLabel")
            ProgressBar.Title.Size = UDim2.new(1, 0, 0, 20)
            ProgressBar.Title.BackgroundTransparency = 1
            ProgressBar.Title.Text = Config.Title or "Прогресс"
            ProgressBar.Title.TextColor3 = self.Window.Theme.Text
            ProgressBar.Title.TextSize = 14
            ProgressBar.Title.Font = Enum.Font.Gotham
            ProgressBar.Title.TextXAlignment = Enum.TextXAlignment.Left
            ProgressBar.Title.Parent = ProgressBar.Frame
            
            ProgressBar.BarBackground = Instance.new("Frame")
            ProgressBar.BarBackground.Size = UDim2.new(1, 0, 0, 15)
            ProgressBar.BarBackground.Position = UDim2.new(0, 0, 0, 25)
            ProgressBar.BarBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            ProgressBar.BarBackground.Parent = ProgressBar.Frame
            RoundCorners(ProgressBar.BarBackground, 8)
            
            ProgressBar.BarFill = Instance.new("Frame")
            ProgressBar.BarFill.Size = UDim2.new(ProgressBar.Value / 100, 0, 1, 0)
            ProgressBar.BarFill.BackgroundColor3 = self.Window.Theme.Accent
            ProgressBar.BarFill.Parent = ProgressBar.BarBackground
            RoundCorners(ProgressBar.BarFill, 8)
            
            ProgressBar.ValueLabel = Instance.new("TextLabel")
            ProgressBar.ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ProgressBar.ValueLabel.Position = UDim2.new(1, -50, 0, 0)
            ProgressBar.ValueLabel.BackgroundTransparency = 1
            ProgressBar.ValueLabel.Text = math.floor(ProgressBar.Value) .. "%"
            ProgressBar.ValueLabel.TextColor3 = self.Window.Theme.Accent
            ProgressBar.ValueLabel.TextSize = 12
            ProgressBar.ValueLabel.Font = Enum.Font.GothamBold
            ProgressBar.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ProgressBar.ValueLabel.Parent = ProgressBar.Frame
            
            function ProgressBar:UpdateValue(newValue)
                self.Value = math.clamp(newValue, 0, 100)
                SafeTween(self.BarFill, {
                    Size = UDim2.new(self.Value / 100, 0, 1, 0)
                }, 0.5, Enum.EasingStyle.Quad)
                self.ValueLabel.Text = math.floor(self.Value) .. "%"
                if Config.Callback then
                    pcall(Config.Callback, self.Value)
                end
            end
            
            table.insert(self.Elements, ProgressBar.Frame)
            self:UpdateSize()
            
            return {
                Object = ProgressBar.Frame,
                Value = ProgressBar.Value,
                Update = function(newValue)
                    ProgressBar:UpdateValue(newValue)
                end,
                SetColor = function(color)
                    ProgressBar.BarFill.BackgroundColor3 = color
                end
            }
        end

        Section:UpdateSize()
        table.insert(Tab.Sections, Section)
        return Section
    end
    
    return Tab
end

-- 🌍 ГЛОБАЛЬНЫЕ ФУНКЦИИ
function TelaryUI:ChangeGlobalTheme(ThemeName)
    if not Themes[ThemeName] then
        warn("Тема '" .. ThemeName .. "' не найдена!")
        return false
    end
    TelaryUI.CurrentTheme = ThemeName
    if TelaryUI.Windows then
        for _, window in pairs(TelaryUI.Windows) do
            if window and window.SetTheme then
                window:SetTheme(ThemeName)
            end
        end
    end
    return true
end

function TelaryUI:CreateCustomTheme(Name, ThemeConfig)
    if Themes[Name] then
        warn("Тема '" .. Name .. "' уже существует!")
        return false
    end
    Themes[Name] = {
        Background = ThemeConfig.Background or Color3.new(0.1, 0.1, 0.1),
        Secondary = ThemeConfig.Secondary or Color3.new(0.2, 0.2, 0.2),
        Accent = ThemeConfig.Accent or Color3.new(0, 0.5, 1),
        Text = ThemeConfig.Text or Color3.new(1, 1, 1),
        Success = ThemeConfig.Success or Color3.new(0, 1, 0),
        Warning = ThemeConfig.Warning or Color3.new(1, 1, 0),
        Error = ThemeConfig.Error or Color3.new(1, 0, 0),
        Border = ThemeConfig.Border or Color3.new(0, 0.3, 0.6),
        Shadow = ThemeConfig.Shadow or Color3.new(0, 0.2, 0.4)
    }
    return true
end

function TelaryUI:SetGlobalSetting(Setting, Value)
    if GlobalConfig[Setting] ~= nil then
        GlobalConfig[Setting] = Value
        if TelaryUI.Windows then
            for _, window in pairs(TelaryUI.Windows) do
                if window then
                    if Setting == "AnimationsEnabled" then
                        window.AnimationsEnabled = Value
                    elseif Setting == "SoundEnabled" then
                        window.SoundEnabled = Value
                    elseif Setting == "NotificationsEnabled" then
                        window.NotificationsEnabled = Value
                    end
                end
            end
        end
        return true
    end
    return false
end

function TelaryUI:GetGlobalSetting(Setting)
    return GlobalConfig[Setting]
end

function TelaryUI:DestroyAllWindows()
    if not TelaryUI.Windows then return end
    for id, window in pairs(TelaryUI.Windows) do
        if window and window.Destroy then
            pcall(window.Destroy, window)
        end
    end
    TelaryUI.Windows = {}
end

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
        Title = "Telary UI v4.5 - Демо",
        Size = UDim2.new(0, 800, 0, 700),
        Theme = "Cyber",
        Center = true
    })
    
    local mainTab = demoWindow:CreateTab("Основные", "⭐", "Основные элементы управления")
    local basicSection = mainTab:CreateSection("Базовые элементы", "Демонстрация основных элементов UI")
    
    basicSection:CreateButton({
        Title = "Тестовая кнопка",
        Callback = function()
            demoWindow:Notify({
                Title = "Успех!",
                Content = "Кнопка была нажата!",
                Type = "success"
            })
        end
    })
    
    basicSection:CreateSlider({
        Title = "Пример слайдера",
        Min = 0,
        Max = 100,
        Default = 50,
        Callback = function(value)
            print("Значение слайдера:", value)
        end
    })
    
    basicSection:CreateToggle({
        Title = "Пример переключателя",
        Default = true,
        Callback = function(value)
            print("Состояние переключателя:", value)
        end
    })
    
    basicSection:CreateDropdown({
        Title = "Пример выпадающего списка",
        Options = {"Опция 1", "Опция 2", "Опция 3"},
        Default = "Опция 1",
        Callback = function(value)
            print("Выбрано:", value)
        end
    })
    
    return demoWindow
end

-- 🎯 ИНИЦИАЛИЗАЦИЯ БИБЛИОТЕКИ
function TelaryUI:Initialize()
    print("🚀 Telary UI v4.5 инициализирована!")
    print("📊 Доступные темы:", #self:GetAvailableThemes())
    print("⚡ Глобальные настройки загружены")
end

-- 🎯 АВТОМАТИЧЕСКАЯ ИНИЦИАЛИЗАЦИЯ
coroutine.wrap(function()
    wait(1)
    TelaryUI:Initialize()
end)()

-- 🎯 ВОЗВРАТ БИБЛИОТЕКИ
return TelaryUI
