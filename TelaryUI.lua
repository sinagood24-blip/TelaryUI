-- Telary UI Library v4.0 - Ultimate Edition
-- Полностью переработанная версия с 15+ новыми функциями

local TelaryUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

TelaryUI.__index = TelaryUI

-- 🎨 РАСШИРЕННАЯ СИСТЕМА ТЕМ С ГРАДИЕНТАМИ
local Themes = {
    Cyber = {
        Background = Color3.fromRGB(10, 10, 20),
        Secondary = Color3.fromRGB(20, 20, 35),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(0, 255, 128),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 50, 50),
        Border = Color3.fromRGB(0, 150, 255)
    },
    Neon = {
        Background = Color3.fromRGB(15, 5, 25),
        Secondary = Color3.fromRGB(25, 10, 40),
        Accent = Color3.fromRGB(255, 0, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(0, 255, 0),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 0, 0),
        Border = Color3.fromRGB(150, 0, 255)
    },
    Matrix = {
        Background = Color3.fromRGB(0, 10, 0),
        Secondary = Color3.fromRGB(0, 20, 0),
        Accent = Color3.fromRGB(0, 255, 0),
        Text = Color3.fromRGB(0, 255, 0),
        Success = Color3.fromRGB(0, 255, 0),
        Warning = Color3.fromRGB(200, 255, 0),
        Error = Color3.fromRGB(255, 50, 0),
        Border = Color3.fromRGB(0, 100, 0)
    },
    Royal = {
        Background = Color3.fromRGB(25, 15, 35),
        Secondary = Color3.fromRGB(40, 25, 55),
        Accent = Color3.fromRGB(147, 112, 219),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(50, 205, 50),
        Warning = Color3.fromRGB(255, 215, 0),
        Error = Color3.fromRGB(220, 20, 60),
        Border = Color3.fromRGB(106, 90, 205)
    },
    Sunset = {
        Background = Color3.fromRGB(25, 20, 45),
        Secondary = Color3.fromRGB(45, 35, 65),
        Accent = Color3.fromRGB(255, 105, 180),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(50, 205, 50),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 69, 0),
        Border = Color3.fromRGB(199, 21, 133)
    }
}

-- 🛠️ УЛУЧШЕННЫЕ УТИЛИТЫ
local function SafeTween(Object, Properties, Duration, Style, Direction)
    if not Object or not Object.Parent then return end
    local tweenInfo = TweenInfo.new(
        Duration or 0.3,
        Style or Enum.EasingStyle.Quad,
        Direction or Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    local tween = TweenService:Create(Object, tweenInfo, Properties)
    tween:Play()
    return tween
end

local function RoundCorners(Object, CornerRadius)
    if not Object then return end
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CornerRadius or 8)
    corner.Parent = Object
    return corner
end

local function CreateGlow(Object, Color, Intensity)
    if not Object then return end
    local glow = Instance.new("ImageLabel")
    glow.Name = "GlowEffect"
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
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

local function CreateShadow(Object)
    if not Object then return end
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = -1
    shadow.Parent = Object
    return shadow
end

-- 🎭 СИСТЕМА АНИМАЦИЙ
local Animations = {
    Hover = function(Object, OriginalColor, HoverColor)
        if not Object then return end
        
        Object.MouseEnter:Connect(function()
            SafeTween(Object, {BackgroundColor3 = HoverColor or OriginalColor:Lerp(Color3.new(1, 1, 1), 0.2)}, 0.2)
        end)
        
        Object.MouseLeave:Connect(function()
            SafeTween(Object, {BackgroundColor3 = OriginalColor}, 0.2)
        end)
    end,
    
    Pulse = function(Object)
        if not Object then return end
        coroutine.wrap(function()
            while Object and Object.Parent do
                SafeTween(Object, {BackgroundTransparency = 0.3}, 0.8)
                wait(0.8)
                SafeTween(Object, {BackgroundTransparency = 0.1}, 0.8)
                wait(1.5)
            end
        end)()
    end,
    
    Bounce = function(Object)
        if not Object then return end
        local scale = Instance.new("UIScale")
        scale.Parent = Object
        
        coroutine.wrap(function()
            while Object and Object.Parent do
                SafeTween(scale, {Scale = 1.05}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                wait(0.3)
                SafeTween(scale, {Scale = 1}, 0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
                wait(2)
            end
        end)()
    end
}

-- 🎯 ОСНОВНАЯ ФУНКЦИЯ СОЗДАНИЯ ОКНА
function TelaryUI:CreateWindow(Config)
    Config = Config or {}
    
    local Window = setmetatable({}, TelaryUI)
    Window.ID = HttpService:GenerateGUID(false)
    Window.Theme = Themes[Config.Theme or "Cyber"]
    Window.Elements = {}
    Window.AnimationsEnabled = Config.Animations ~= false
    
    -- Создаем основной GUI
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "TelaryUIv4_" .. Window.ID
    Window.ScreenGui.Parent = CoreGui
    Window.ScreenGui.ResetOnSpawn = false
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Главный контейнер с улучшенным дизайном
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Size = Config.Size or UDim2.new(0, 650, 0, 700)
    Window.MainFrame.Position = Config.Center and UDim2.new(0.5, -Window.MainFrame.Size.X.Offset/2, 0.5, -Window.MainFrame.Size.Y.Offset/2) or (Config.Position or UDim2.new(0, 100, 0, 100))
    Window.MainFrame.BackgroundColor3 = Window.Theme.Background
    Window.MainFrame.BackgroundTransparency = 0.05
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Parent = Window.ScreenGui
    RoundCorners(Window.MainFrame, 12)
    CreateGlow(Window.MainFrame, Window.Theme.Accent, 0.7)
    CreateShadow(Window.MainFrame)
    
    -- Заголовок с анимированным градиентом
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    Window.TitleBar.BackgroundColor3 = Window.Theme.Secondary
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.Parent = Window.MainFrame
    RoundCorners(Window.TitleBar, 12)
    
    -- Анимированный градиент заголовка
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Window.Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Window.Theme.Secondary),
        ColorSequenceKeypoint.new(1, Window.Theme.Accent)
    })
    titleGradient.Rotation = 45
    titleGradient.Parent = Window.TitleBar
    
    -- Анимация градиента
    if Window.AnimationsEnabled then
        coroutine.wrap(function()
            while Window.TitleBar and Window.TitleBar.Parent do
                for i = 0, 360, 1 do
                    if Window.TitleBar and Window.TitleBar.Parent then
                        titleGradient.Rotation = i
                        wait(0.02)
                    else
                        break
                    end
                end
            end
        end)()
    end
    
    -- Текст заголовка
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "Telary UI v4.0"
    TitleLabel.TextColor3 = Window.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Window.TitleBar
    
    -- Кнопки управления окном
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -14)
    CloseButton.BackgroundColor3 = Window.Theme.Error
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Window.Theme.Text
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Window.TitleBar
    RoundCorners(CloseButton, 6)
    CreateGlow(CloseButton, Window.Theme.Error, 0.6)
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
    MinimizeButton.Position = UDim2.new(1, -70, 0.5, -14)
    MinimizeButton.BackgroundColor3 = Window.Theme.Warning
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Window.Theme.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = Window.TitleBar
    RoundCorners(MinimizeButton, 6)
    CreateGlow(MinimizeButton, Window.Theme.Warning, 0.6)
    
    -- Контейнер для вкладок
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Size = UDim2.new(1, 0, 1, -45)
    Window.TabContainer.Position = UDim2.new(0, 0, 0, 45)
    Window.TabContainer.BackgroundTransparency = 1
    Window.TabContainer.Parent = Window.MainFrame
    
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    
    -- 🔧 ФУНКЦИОНАЛ ПЕРЕТАСКИВАНИЯ
    if Config.Draggable ~= false then
        local dragging = false
        local dragInput, dragStart, startPos
        
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
    
    -- 🎮 ОБРАБОТЧИКИ КНОПОК УПРАВЛЕНИЯ
    CloseButton.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)
    
    -- Анимация появления окна
    if Window.AnimationsEnabled then
        Window.MainFrame.Size = UDim2.new(0, 10, 0, 10)
        Window.MainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
        SafeTween(Window.MainFrame, {
            Size = Config.Size or UDim2.new(0, 650, 0, 700),
            Position = Config.Center and UDim2.new(0.5, -(Config.Size or UDim2.new(0, 650, 0, 700)).X.Offset/2, 0.5, -(Config.Size or UDim2.new(0, 650, 0, 700)).Y.Offset/2) or (Config.Position or UDim2.new(0, 100, 0, 100))
        }, 0.6, Enum.EasingStyle.Back)
    end
    
    -- 📑 МЕТОДЫ ОКНА
    function Window:CreateTab(Name, Icon)
        local Tab = {}
        Tab.Name = Name
        Tab.Window = self
        Tab.Elements = {}
        
        -- Кнопка вкладки с улучшенным дизайном
        Tab.Button = Instance.new("TextButton")
        Tab.Button.Size = UDim2.new(0, 120, 0, 40)
        Tab.Button.Position = UDim2.new(0, 15 + (#self.Tabs * 125), 0, -40)
        Tab.Button.BackgroundColor3 = self.Theme.Secondary
        Tab.Button.Text = (Icon or "📁") .. " " .. Name
        Tab.Button.TextColor3 = self.Theme.Text
        Tab.Button.TextSize = 13
        Tab.Button.Font = Enum.Font.Gotham
        Tab.Button.Parent = self.MainFrame
        RoundCorners(Tab.Button, 8)
        CreateGlow(Tab.Button, self.Theme.Accent, 0.5)
        
        -- Контент вкладки
        Tab.Content = Instance.new("ScrollingFrame")
        Tab.Content.Size = UDim2.new(1, -20, 1, -20)
        Tab.Content.Position = UDim2.new(0, 10, 0, 10)
        Tab.Content.BackgroundTransparency = 1
        Tab.Content.ScrollBarThickness = 4
        Tab.Content.ScrollBarImageColor3 = self.Theme.Accent
        Tab.Content.ScrollBarImageTransparency = 0.7
        Tab.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Tab.Content.Visible = false
        Tab.Content.Parent = self.TabContainer
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 12)
        UIListLayout.Parent = Tab.Content
        
        Tab.Sections = {}
        
        -- 📖 МЕТОДЫ ВКЛАДКИ
        function Tab:CreateSection(Name, Description)
            local Section = {}
            Section.Name = Name
            Section.Window = self.Window
            Section.Elements = {}
            
            -- Основной фрейм секции
            Section.Frame = Instance.new("Frame")
            Section.Frame.Size = UDim2.new(1, 0, 0, 0)
            Section.Frame.BackgroundColor3 = self.Window.Theme.Secondary
            Section.Frame.BackgroundTransparency = 0.1
            Section.Frame.BorderSizePixel = 0
            Section.Frame.Parent = Tab.Content
            RoundCorners(Section.Frame, 10)
            CreateGlow(Section.Frame, self.Window.Theme.Accent, 0.3)
            CreateShadow(Section.Frame)
            
            -- Заголовок секции
            Section.Title = Instance.new("TextLabel")
            Section.Title.Size = UDim2.new(1, -20, 0, 35)
            Section.Title.Position = UDim2.new(0, 10, 0, 5)
            Section.Title.BackgroundTransparency = 1
            Section.Title.Text = "✨ " .. Name
            Section.Title.TextColor3 = self.Window.Theme.Text
            Section.Title.TextSize = 15
            Section.Title.Font = Enum.Font.GothamBold
            Section.Title.TextXAlignment = Enum.TextXAlignment.Left
            Section.Title.Parent = Section.Frame
            
            -- Описание секции (если есть)
            if Description then
                Section.Description = Instance.new("TextLabel")
                Section.Description.Size = UDim2.new(1, -20, 0, 30)
                Section.Description.Position = UDim2.new(0, 10, 0, 35)
                Section.Description.BackgroundTransparency = 1
                Section.Description.Text = Description
                Section.Description.TextColor3 = self.Window.Theme.Text
                Section.Description.TextTransparency = 0.4
                Section.Description.TextSize = 12
                Section.Description.Font = Enum.Font.Gotham
                Section.Description.TextXAlignment = Enum.TextXAlignment.Left
                Section.Description.TextWrapped = true
                Section.Description.Parent = Section.Frame
            end
            
            -- Контейнер элементов
            Section.Content = Instance.new("Frame")
            Section.Content.Size = UDim2.new(1, -20, 0, 0)
            Section.Content.Position = UDim2.new(0, 10, 0, Description and 70 or 40)
            Section.Content.BackgroundTransparency = 1
            Section.Content.Parent = Section.Frame
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Padding = UDim.new(0, 10)
            SectionList.Parent = Section.Content
            
            -- 📝 ОСНОВНЫЕ МЕТОДЫ СЕКЦИИ БУДУТ ДОБАВЛЕНЫ В СЛЕДУЮЩЕЙ ЧАСТИ
            
            Section:UpdateSize()
            Tab.Sections[#Tab.Sections + 1] = Section
            
            return Section
        end
        
        function Tab:Show()
            if self.Window.CurrentTab then
                self.Window.CurrentTab.Content.Visible = false
                SafeTween(self.Window.CurrentTab.Button, {BackgroundColor3 = self.Window.Theme.Secondary})
            end
            
            self.Window.CurrentTab = self
            self.Content.Visible = true
            SafeTween(self.Button, {BackgroundColor3 = self.Window.Theme.Accent})
        end
        
        Tab.Button.MouseButton1Click:Connect(function()
            Tab:Show()
        end)
        
        self.Tabs[#self.Tabs + 1] = Tab
        
        if #self.Tabs == 1 then
            Tab:Show()
        end
        
        return Tab
    end
    
    -- 🔔 СИСТЕМА УВЕДОМЛЕНИЙ
    function Window:Notify(Config)
        Config = Config or {}
        
        local notifyGui = Instance.new("ScreenGui")
        notifyGui.Parent = CoreGui
        notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local notifyFrame = Instance.new("Frame")
        notifyFrame.Size = UDim2.new(0, 350, 0, 80)
        notifyFrame.Position = UDim2.new(1, -370, 0, 20)
        notifyFrame.BackgroundColor3 = self.Theme.Secondary
        notifyFrame.BackgroundTransparency = 0.1
        notifyFrame.BorderSizePixel = 0
        notifyFrame.Parent = notifyGui
        RoundCorners(notifyFrame, 10)
        CreateGlow(notifyFrame, self.Theme.Accent, 0.5)
        CreateShadow(notifyFrame)
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 40, 0, 40)
        icon.Position = UDim2.new(0, 15, 0, 20)
        icon.BackgroundTransparency = 1
        icon.Text = Config.Type == "error" and "❌" or Config.Type == "warning" and "⚠️" or Config.Type == "info" and "💡" or "✅"
        icon.TextColor3 = Config.Type == "error" and self.Theme.Error or Config.Type == "warning" and self.Theme.Warning or Config.Type == "info" and self.Theme.Accent or self.Theme.Success
        icon.TextSize = 20
        icon.Font = Enum.Font.GothamBold
        icon.Parent = notifyFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -70, 0, 25)
        title.Position = UDim2.new(0, 60, 0, 15)
        title.BackgroundTransparency = 1
        title.Text = Config.Title or "Уведомление"
        title.TextColor3 = self.Theme.Text
        title.TextSize = 14
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = notifyFrame
        
        local content = Instance.new("TextLabel")
        content.Size = UDim2.new(1, -70, 0, 35)
        content.Position = UDim2.new(0, 60, 0, 40)
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
        notifyFrame.Position = UDim2.new(1, 400, 0, 20)
        SafeTween(notifyFrame, {Position = UDim2.new(1, -370, 0, 20)}, 0.5, Enum.EasingStyle.Back)
        
        -- Автоматическое закрытие
        local duration = Config.Duration or 4
        if duration > 0 then
            delay(duration, function()
                if notifyGui and notifyGui.Parent then
                    SafeTween(notifyFrame, {Position = UDim2.new(1, 400, 0, 20)}, 0.5, Enum.EasingStyle.Quad)
                    wait(0.5)
                    notifyGui:Destroy()
                end
            end)
        end
        
        return {
            Destroy = function()
                if notifyGui and notifyGui.Parent then
                    SafeTween(notifyFrame, {Position = UDim2.new(1, 400, 0, 20)}, 0.5, Enum.EasingStyle.Quad)
                    wait(0.5)
                    notifyGui:Destroy()
                end
            end,
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
    
    function Window:Minimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            SafeTween(self.MainFrame, {Size = UDim2.new(0, 250, 0, 45)}, 0.3)
            self.TabContainer.Visible = false
        else
            SafeTween(self.MainFrame, {Size = Config.Size or UDim2.new(0, 650, 0, 700)}, 0.3)
            self.TabContainer.Visible = true
        end
    end
    
    function Window:Destroy()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end
    
    -- Первое уведомление
    if Config.ShowWelcome ~= false then
        delay(1, function()
            Window:Notify({
                Title = "Telary UI v4.0",
                Content = "Ультрасовременный интерфейс загружен!\nНаслаждайтесь новыми функциями и анимациями!",
                Type = "success",
                Duration = 5
            })
        end)
    end
    
    return Window
end

-- 🌍 ГЛОБАЛЬНЫЕ ФУНКЦИИ
function TelaryUI:ChangeGlobalTheme(ThemeName)
    -- 📝 ПРОДОЛЖЕНИЕ БИБЛИОТЕКИ TELARY UI v4.0
-- Добавляем методы в секцию после создания Section.Frame

-- 🆕 1. УЛУЧШЕННЫЕ КНОПКИ С РАЗНЫМИ СТИЛЯМИ
function Section:CreateButton(Config)
    Config = Config or {}
    local Button = {}
    
    Button.Frame = Instance.new("Frame")
    Button.Frame.Size = UDim2.new(1, 0, 0, 45)
    Button.Frame.BackgroundTransparency = 1
    Button.Frame.Parent = Section.Content
    
    local ButtonMain = Instance.new("TextButton")
    ButtonMain.Size = UDim2.new(1, 0, 1, 0)
    ButtonMain.BackgroundColor3 = self.Window.Theme.Accent
    ButtonMain.Text = Config.Title or "🚀 Кнопка"
    ButtonMain.TextColor3 = self.Window.Theme.Text
    ButtonMain.TextSize = 14
    ButtonMain.Font = Enum.Font.Gotham
    ButtonMain.Parent = Button.Frame
    RoundCorners(ButtonMain, 8)
    CreateGlow(ButtonMain, self.Window.Theme.Accent, 0.4)
    
    -- Стили кнопок
    if Config.Style == "Danger" then
        ButtonMain.BackgroundColor3 = self.Window.Theme.Error
        CreateGlow(ButtonMain, self.Window.Theme.Error, 0.4)
    elseif Config.Style == "Success" then
        ButtonMain.BackgroundColor3 = self.Window.Theme.Success
        CreateGlow(ButtonMain, self.Window.Theme.Success, 0.4)
    elseif Config.Style == "Warning" then
        ButtonMain.BackgroundColor3 = self.Window.Theme.Warning
        CreateGlow(ButtonMain, self.Window.Theme.Warning, 0.4)
    elseif Config.Style == "Outline" then
        ButtonMain.BackgroundColor3 = Color3.new(0, 0, 0)
        ButtonMain.BackgroundTransparency = 0.8
        local stroke = Instance.new("UIStroke")
        stroke.Color = self.Window.Theme.Accent
        stroke.Thickness = 2
        stroke.Parent = ButtonMain
    end
    
    -- Анимации
    local originalColor = ButtonMain.BackgroundColor3
    Animations.Hover(ButtonMain, originalColor)
    
    ButtonMain.MouseButton1Click:Connect(function()
        if self.Window.AnimationsEnabled then
            SafeTween(ButtonMain, {Size = UDim2.new(0.95, 0, 0.9, 0)}, 0.1)
            SafeTween(ButtonMain, {Size = UDim2.new(1, 0, 1, 0)}, 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
        
        if Config.Callback then
            local success, err = pcall(Config.Callback)
            if not success then
                self.Window:Notify({
                    Title = "Ошибка",
                    Content = tostring(err),
                    Type = "error"
                })
            end
        end
    end)
    
    Section.Elements[#Section.Elements + 1] = Button.Frame
    Section:UpdateSize()
    
    return {
        Object = ButtonMain,
        Update = function(newConfig)
            if newConfig.Title then
                ButtonMain.Text = newConfig.Title
            end
            if newConfig.Style then
                -- Обновление стиля
            end
        end,
        SetDisabled = function(disabled)
            ButtonMain.AutoButtonColor = not disabled
            ButtonMain.BackgroundTransparency = disabled and 0.7 or 0
        end
    }
end

-- 🆕 2. КНОПКА С ИКОНКОЙ И ПРОГРЕССОМ
function Section:CreateIconButton(Config)
    Config = Config or {}
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = self.Window.Theme.Secondary
    Button.Text = ""
    Button.Parent = Section.Content
    RoundCorners(Button, 8)
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Position = UDim2.new(0, 10, 0.5, -15)
    Icon.BackgroundTransparency = 1
    Icon.Text = Config.Icon or "⭐"
    Icon.TextColor3 = self.Window.Theme.Accent
    Icon.TextSize = 16
    Icon.Font = Enum.Font.GothamBold
    Icon.Parent = Button
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 0, 25)
    Title.Position = UDim2.new(0, 45, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Title or "Кнопка с иконкой"
    Title.TextColor3 = self.Window.Theme.Text
    Title.TextSize = 14
    Title.Font = Enum.Font.Gotham
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -50, 0, 15)
    Description.Position = UDim2.new(0, 45, 0, 28)
    Description.BackgroundTransparency = 1
    Description.Text = Config.Description or ""
    Description.TextColor3 = self.Window.Theme.Text
    Description.TextTransparency = 0.5
    Description.TextSize = 11
    Description.Font = Enum.Font.Gotham
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = Button
    
    Animations.Hover(Button, self.Window.Theme.Secondary)
    
    Button.MouseButton1Click:Connect(function()
        if Config.Callback then
            pcall(Config.Callback)
        end
    end)
    
    Section.Elements[#Section.Elements + 1] = Button
    Section:UpdateSize()
    
    return {
        Update = function(newConfig)
            if newConfig.Title then Title.Text = newConfig.Title end
            if newConfig.Description then Description.Text = newConfig.Description end
            if newConfig.Icon then Icon.Text = newConfig.Icon end
        end
    }
end

-- 🆕 3. УМНЫЙ СЛАЙДЕР С ДОПОЛНИТЕЛЬНЫМИ ФУНКЦИЯМИ
function Section:CreateSlider(Config)
    Config = Config or {}
    local Slider = {}
    Slider.Value = Config.Default or Config.Min or 0
    Slider.Config = Config
    
    Slider.Frame = Instance.new("Frame")
    Slider.Frame.Size = UDim2.new(1, 0, 0, 70)
    Slider.Frame.BackgroundTransparency = 1
    Slider.Frame.Parent = Section.Content
    
    -- Заголовок и значение
    Slider.Title = Instance.new("TextLabel")
    Slider.Title.Size = UDim2.new(1, -70, 0, 25)
    Slider.Title.BackgroundTransparency = 1
    Slider.Title.Text = Config.Title or "Слайдер: " .. Slider.Value
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
    
    -- Дорожка слайдера
    Slider.Track = Instance.new("Frame")
    Slider.Track.Size = UDim2.new(1, 0, 0, 6)
    Slider.Track.Position = UDim2.new(0, 0, 0, 35)
    Slider.Track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Slider.Track.Parent = Slider.Frame
    RoundCorners(Slider.Track, 3)
    
    Slider.Fill = Instance.new("Frame")
    Slider.Fill.Size = UDim2.new((Slider.Value - (Config.Min or 0)) / ((Config.Max or 100) - (Config.Min or 0)), 0, 1, 0)
    Slider.Fill.BackgroundColor3 = self.Window.Theme.Accent
    Slider.Fill.Parent = Slider.Track
    RoundCorners(Slider.Fill, 3)
    
    -- Ползунок
    Slider.Handle = Instance.new("TextButton")
    Slider.Handle.Size = UDim2.new(0, 18, 0, 18)
    Slider.Handle.Position = UDim2.new(Slider.Fill.Size.X.Scale, -9, 0.5, -9)
    Slider.Handle.BackgroundColor3 = self.Window.Theme.Text
    Slider.Handle.Text = ""
    Slider.Handle.AutoButtonColor = false
    Slider.Handle.Parent = Slider.Track
    RoundCorners(Slider.Handle, 9)
    CreateGlow(Slider.Handle, self.Window.Theme.Accent, 0.5)
    
    local function UpdateSlider(Value)
        local Min = Config.Min or 0
        local Max = Config.Max or 100
        local Normalized = math.clamp((Value - Min) / (Max - Min), 0, 1)
        
        Slider.Value = math.floor(Value)
        Slider.Fill.Size = UDim2.new(Normalized, 0, 1, 0)
        Slider.Handle.Position = UDim2.new(Normalized, -9, 0.5, -9)
        Slider.Title.Text = Config.Title or "Слайдер: " .. Slider.Value
        Slider.ValueLabel.Text = tostring(Slider.Value)
        
        if Config.Callback then
            pcall(Config.Callback, Slider.Value)
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
            local value = ((Config.Max or 100) - (Config.Min or 0)) * math.clamp(relativeX, 0, 1) + (Config.Min or 0)
            UpdateSlider(value)
        end
    end
    
    Slider.Handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    Slider.Track.MouseButton1Down:Connect(function(x, y)
        local mouse = UserInputService:GetMouseLocation()
        local trackAbsolutePos = Slider.Track.AbsolutePosition
        local trackAbsoluteSize = Slider.Track.AbsoluteSize
        local relativeX = (mouse.X - trackAbsolutePos.X) / trackAbsoluteSize.X
        local value = ((Config.Max or 100) - (Config.Min or 0)) * math.clamp(relativeX, 0, 1) + (Config.Min or 0)
        UpdateSlider(value)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(onInputChanged)
    
    Section.Elements[#Section.Elements + 1] = Slider.Frame
    Section:UpdateSize()
    
    return {
        Object = Slider.Frame,
        Value = Slider.Value,
        Update = function(newValue)
            UpdateSlider(newValue)
        end,
        SetRange = function(min, max)
            Config.Min = min
            Config.Max = max
            UpdateSlider(math.clamp(Slider.Value, min, max))
        end
    }
end

-- 🆕 4. ПЕРЕКЛЮЧАТЕЛЬ С АНИМАЦИЕЙ
function Section:CreateToggle(Config)
    Config = Config or {}
    local Toggle = {}
    Toggle.Value = Config.Default or false
    
    Toggle.Frame = Instance.new("Frame")
    Toggle.Frame.Size = UDim2.new(1, 0, 0, 35)
    Toggle.Frame.BackgroundTransparency = 1
    Toggle.Frame.Parent = Section.Content
    
    Toggle.Title = Instance.new("TextLabel")
    Toggle.Title.Size = UDim2.new(1, -50, 1, 0)
    Toggle.Title.BackgroundTransparency = 1
    Toggle.Title.Text = Config.Title or "Переключатель"
    Toggle.Title.TextColor3 = self.Window.Theme.Text
    Toggle.Title.TextSize = 14
    Toggle.Title.Font = Enum.Font.Gotham
    Toggle.Title.TextXAlignment = Enum.TextXAlignment.Left
    Toggle.Title.Parent = Toggle.Frame
    
    -- Переключатель
    Toggle.Button = Instance.new("TextButton")
    Toggle.Button.Size = UDim2.new(0, 50, 0, 25)
    Toggle.Button.Position = UDim2.new(1, -50, 0.5, -12.5)
    Toggle.Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Toggle.Button.Text = ""
    Toggle.Button.AutoButtonColor = false
    Toggle.Button.Parent = Toggle.Frame
    RoundCorners(Toggle.Button, 12)
    
    Toggle.Thumb = Instance.new("Frame")
    Toggle.Thumb.Size = UDim2.new(0, 21, 0, 21)
    Toggle.Thumb.Position = UDim2.new(0, 2, 0.5, -10.5)
    Toggle.Thumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Toggle.Thumb.Parent = Toggle.Button
    RoundCorners(Toggle.Thumb, 10)
    
    local function UpdateToggle()
        if Toggle.Value then
            SafeTween(Toggle.Button, {BackgroundColor3 = self.Window.Theme.Accent})
            SafeTween(Toggle.Thumb, {Position = UDim2.new(1, -23, 0.5, -10.5)})
        else
            SafeTween(Toggle.Button, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
            SafeTween(Toggle.Thumb, {Position = UDim2.new(0, 2, 0.5, -10.5)})
        end
        
        if Config.Callback then
            pcall(Config.Callback, Toggle.Value)
        end
    end
    
    Toggle.Button.MouseButton1Click:Connect(function()
        Toggle.Value = not Toggle.Value
        UpdateToggle()
    end)
    
    Animations.Hover(Toggle.Button, Toggle.Button.BackgroundColor3)
    
    UpdateToggle()
    
    Section.Elements[#Section.Elements + 1] = Toggle.Frame
    Section:UpdateSize()
    
    return {
        Object = Toggle.Frame,
        Value = Toggle.Value,
        Update = function(newValue)
            Toggle.Value = newValue
            UpdateToggle()
        end,
        Toggle = function()
            Toggle.Value = not Toggle.Value
            UpdateToggle()
        end
    }
end

-- 🆕 5. ВЫПАДАЮЩИЙ СПИСОК
function Section:CreateDropdown(Config)
    Config = Config or {}
    local Dropdown = {}
    Dropdown.Open = false
    Dropdown.Options = Config.Options or {"Опция 1", "Опция 2", "Опция 3"}
    Dropdown.Selected = Config.Default or Dropdown.Options[1]
    
    Dropdown.Frame = Instance.new("Frame")
    Dropdown.Frame.Size = UDim2.new(1, 0, 0, 40)
    Dropdown.Frame.BackgroundTransparency = 1
    Dropdown.Frame.Parent = Section.Content
    
    -- Основная кнопка
    Dropdown.Button = Instance.new("TextButton")
    Dropdown.Button.Size = UDim2.new(1, 0, 0, 40)
    Dropdown.Button.BackgroundColor3 = self.Window.Theme.Secondary
    Dropdown.Button.Text = ""
    Dropdown.Button.AutoButtonColor = false
    Dropdown.Button.Parent = Dropdown.Frame
    RoundCorners(Dropdown.Button, 6)
    
    Dropdown.SelectedLabel = Instance.new("TextLabel")
    Dropdown.SelectedLabel.Size = UDim2.new(1, -30, 1, 0)
    Dropdown.SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
    Dropdown.SelectedLabel.BackgroundTransparency = 1
    Dropdown.SelectedLabel.Text = Dropdown.Selected
    Dropdown.SelectedLabel.TextColor3 = self.Window.Theme.Text
    Dropdown.SelectedLabel.TextSize = 14
    Dropdown.SelectedLabel.Font = Enum.Font.Gotham
    Dropdown.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    Dropdown.SelectedLabel.Parent = Dropdown.Button
    
    Dropdown.Arrow = Instance.new("TextLabel")
    Dropdown.Arrow.Size = UDim2.new(0, 20, 0, 20)
    Dropdown.Arrow.Position = UDim2.new(1, -25, 0.5, -10)
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
    RoundCorners(Dropdown.List, 6)
    CreateShadow(Dropdown.List)
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = Dropdown.List
    
    local function UpdateDropdown()
        Dropdown.SelectedLabel.Text = Dropdown.Selected
        Dropdown.Arrow.Text = Dropdown.Open and "▲" or "▼"
        
        if Dropdown.Open then
            Dropdown.List.Visible = true
            local height = math.min(#Dropdown.Options * 35, 150)
            SafeTween(Dropdown.List, {Size = UDim2.new(1, 0, 0, height)})
        else
            SafeTween(Dropdown.List, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, function()
                if not Dropdown.Open then
                    Dropdown.List.Visible = false
                end
            end)
        end
    end
    
    local function CreateOption(option, index)
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 35)
        optionButton.BackgroundColor3 = self.Window.Theme.Secondary
        optionButton.Text = option
        optionButton.TextColor3 = self.Window.Theme.Text
        optionButton.TextSize = 13
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = Dropdown.List
        
        optionButton.MouseButton1Click:Connect(function()
            Dropdown.Selected = option
            Dropdown.Open = false
            UpdateDropdown()
            
            if Config.Callback then
                pcall(Config.Callback, option)
            end
        end)
        
        Animations.Hover(optionButton, self.Window.Theme.Secondary, self.Window.Theme.Accent)
    end
    
    -- Создаем опции
    for i, option in ipairs(Dropdown.Options) do
        CreateOption(option, i)
    end
    
    Dropdown.Button.MouseButton1Click:Connect(function()
        Dropdown.Open = not Dropdown.Open
        UpdateDropdown()
    end)
    
    Animations.Hover(Dropdown.Button, self.Window.Theme.Secondary)
    
    Section.Elements[#Section.Elements + 1] = Dropdown.Frame
    Section:UpdateSize()
    
    return {
        Object = Dropdown.Frame,
        Selected = Dropdown.Selected,
        Update = function(newOptions, newDefault)
            if newOptions then
                Dropdown.Options = newOptions
                Dropdown.List:ClearAllChildren()
                for i, option in ipairs(newOptions) do
                    CreateOption(option, i)
                end
            end
            if newDefault then
                Dropdown.Selected = newDefault
            end
            UpdateDropdown()
        end
    }
end

-- 🆕 6. ТЕКСТОВОЕ ПОЛЕ ВВОДА
function Section:CreateInput(Config)
    Config = Config or {}
    local Input = {}
    
    Input.Frame = Instance.new("Frame")
    Input.Frame.Size = UDim2.new(1, 0, 0, 40)
    Input.Frame.BackgroundTransparency = 1
    Input.Frame.Parent = Section.Content
    
    Input.Box = Instance.new("TextBox")
    Input.Box.Size = UDim2.new(1, 0, 1, 0)
    Input.Box.BackgroundColor3 = self.Window.Theme.Secondary
    Input.Box.TextColor3 = self.Window.Theme.Text
    Input.Box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    Input.Box.Text = Config.Default or ""
    Input.Box.PlaceholderText = Config.Placeholder or "Введите текст..."
    Input.Box.TextSize = 14
    Input.Box.Font = Enum.Font.Gotham
    Input.Box.ClearTextOnFocus = false
    Input.Box.Parent = Input.Frame
    RoundCorners(Input.Box, 6)
    
    -- Анимация фокуса
    Input.Box.Focused:Connect(function()
        SafeTween(Input.Box, {BackgroundColor3 = self.Window.Theme.Secondary:Lerp(Color3.new(1, 1, 1), 0.1)})
        CreateGlow(Input.Box, self.Window.Theme.Accent, 0.6)
    end)
    
    Input.Box.FocusLost:Connect(function(enterPressed)
        SafeTween(Input.Box, {BackgroundColor3 = self.Window.Theme.Secondary})
        if Input.Box:FindFirstChild("GlowEffect") then
            Input.Box.GlowEffect:Destroy()
        end
        
        if Config.Callback then
            pcall(Config.Callback, Input.Box.Text, enterPressed)
        end
    end)
    
    Section.Elements[#Section.Elements + 1] = Input.Frame
    Section:UpdateSize()
    
    return {
        Object = Input.Box,
        Value = Input.Box.Text,
        Update = function(newText)
            Input.Box.Text = newText
        end,
        Clear = function()
            Input.Box.Text = ""
        end
    }
end

-- 🆕 7. ПРИВЯЗКА КЛАВИШ
function Section:CreateKeybind(Config)
    Config = Config or {}
    local Keybind = {}
    Keybind.Listening = false
    Keybind.Key = Config.Default or Enum.KeyCode.F.Name
    
    Keybind.Frame = Instance.new("Frame")
    Keybind.Frame.Size = UDim2.new(1, 0, 0, 40)
    Keybind.Frame.BackgroundTransparency = 1
    Keybind.Frame.Parent = Section.Content
    
    Keybind.Button = Instance.new("TextButton")
    Keybind.Button.Size = UDim2.new(1, 0, 1, 0)
    Keybind.Button.BackgroundColor3 = self.Window.Theme.Secondary
    Keybind.Button.Text = "Нажмите клавишу..."
    Keybind.Button.TextColor3 = self.Window.Theme.Text
    Keybind.Button.TextSize = 14
    Keybind.Button.Font = Enum.Font.Gotham
    Keybind.Button.Parent = Keybind.Frame
    RoundCorners(Keybind.Button, 6)
    
    local function UpdateKeybind()
        Keybind.Button.Text = Keybind.Listening and "Слушаем..." or Keybind.Key
    end
    
    Keybind.Button.MouseButton1Click:Connect(function()
        Keybind.Listening = true
        UpdateKeybind()
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Keybind.Key = input.KeyCode.Name
                Keybind.Listening = false
                UpdateKeybind()
                connection:Disconnect()
                
                if Config.Callback then
                    pcall(Config.Callback, input.KeyCode)
                end
            end
        end)
    end)
    
    Animations.Hover(Keybind.Button, self.Window.Theme.Secondary)
    UpdateKeybind()
    
    Section.Elements[#Section.Elements + 1] = Keybind.Frame
    Section:UpdateSize()
    
    return {
        Object = Keybind.Frame,
        Key = Keybind.Key,
        Update = function(newKey)
            Keybind.Key = newKey
            UpdateKeybind()
        end
    }
end

-- 🆕 8. КНОПКА-ПЕРЕКЛЮЧАТЕЛЬ (TOGGLE BUTTON)
function Section:CreateToggleButton(Config)
    Config = Config or {}
    local ToggleButton = {}
    ToggleButton.Value = Config.Default or false
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.BackgroundColor3 = ToggleButton.Value and self.Window.Theme.Success or self.Window.Theme.Secondary
    Button.Text = Config.Title or "Переключатель"
    Button.TextColor3 = self.Window.Theme.Text
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = Section.Content
    RoundCorners(Button, 8)
    
    local function UpdateButton()
        Button.BackgroundColor3 = ToggleButton.Value and self.Window.Theme.Success or self.Window.Theme.Secondary
        CreateGlow(Button, ToggleButton.Value and self.Window.Theme.Success or self.Window.Theme.Accent, 0.4)
    end
    
    Button.MouseButton1Click:Connect(function()
        ToggleButton.Value = not ToggleButton.Value
        UpdateButton()
        
        if Config.Callback then
            pcall(Config.Callback, ToggleButton.Value)
        end
    end)
    
    Animations.Hover(Button, Button.BackgroundColor3)
    UpdateButton()
    
    Section.Elements[#Section.Elements + 1] = Button
    Section:UpdateSize()
    
    return {
        Object = Button,
        Value = ToggleButton.Value,
        Update = function(newValue)
            ToggleButton.Value = newValue
            UpdateButton()
        end
    }
end

-- 🆕 9. ЦВЕТОВОЙ ПИКЕР
function Section:CreateColorPicker(Config)
    Config = Config or {}
    local ColorPicker = {}
    ColorPicker.Value = Config.Default or Color3.new(1, 1, 1)
    
    ColorPicker.Frame = Instance.new("Frame")
    ColorPicker.Frame.Size = UDim2.new(1, 0, 0, 50)
    ColorPicker.Frame.BackgroundTransparency = 1
    ColorPicker.Frame.Parent = Section.Content
    
    ColorPicker.Title = Instance.new("TextLabel")
    ColorPicker.Title.Size = UDim2.new(1, -60, 0, 25)
    ColorPicker.Title.BackgroundTransparency = 1
    ColorPicker.Title.Text = Config.Title or "Выбор цвета"
    ColorPicker.Title.TextColor3 = self.Window.Theme.Text
    ColorPicker.Title.TextSize = 14
    ColorPicker.Title.Font = Enum.Font.Gotham
    ColorPicker.Title.TextXAlignment = Enum.TextXAlignment.Left
    ColorPicker.Title.Parent = ColorPicker.Frame
    
    ColorPicker.Preview = Instance.new("TextButton")
    ColorPicker.Preview.Size = UDim2.new(0, 40, 0, 40)
    ColorPicker.Preview.Position = UDim2.new(1, -45, 0, 5)
    ColorPicker.Preview.BackgroundColor3 = ColorPicker.Value
    ColorPicker.Preview.Text = ""
    ColorPicker.Preview.AutoButtonColor = false
    ColorPicker.Preview.Parent = ColorPicker.Frame
    RoundCorners(ColorPicker.Preview, 6)
    CreateGlow(ColorPicker.Preview, ColorPicker.Value, 0.5)
    
    ColorPicker.Preview.MouseButton1Click:Connect(function()
        -- Здесь можно добавить полноценный пикер цветов
        local newColor = Color3.new(math.random(), math.random(), math.random())
        ColorPicker.Value = newColor
        ColorPicker.Preview.BackgroundColor3 = newColor
        CreateGlow(ColorPicker.Preview, newColor, 0.5)
        
        if Config.Callback then
            pcall(Config.Callback, newColor)
        end
    end)
    
    Section.Elements[#Section.Elements + 1] = ColorPicker.Frame
    Section:UpdateSize()
    
    return {
        Object = ColorPicker.Frame,
        Value = ColorPicker.Value,
        Update = function(newColor)
            ColorPicker.Value = newColor
            ColorPicker.Preview.BackgroundColor3 = newColor
            CreateGlow(ColorPicker.Preview, newColor, 0.5)
        end
    }
end

-- 🆕 10. ПРОГРЕСС-БАР
function Section:CreateProgressBar(Config)
    Config = Config or {}
    local ProgressBar = {}
    ProgressBar.Value = Config.Default or 0
    
    ProgressBar.Frame = Instance.new("Frame")
    ProgressBar.Frame.Size = UDim2.new(1, 0, 0, 40)
    ProgressBar.Frame.BackgroundTransparency = 1
    ProgressBar.Frame.Parent = Section.Content
    
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
    ProgressBar.BarBackground.Size = UDim2.new(1, 0, 0, 12)
    ProgressBar.BarBackground.Position = UDim2.new(0, 0, 0, 25)
    ProgressBar.BarBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ProgressBar.BarBackground.Parent = ProgressBar.Frame
    RoundCorners(ProgressBar.BarBackground, 6)
    
    ProgressBar.BarFill = Instance.new("Frame")
    ProgressBar.BarFill.Size = UDim2.new(ProgressBar.Value / 100, 0, 1, 0)
    ProgressBar.BarFill.BackgroundColor3 = self.Window.Theme.Accent
    ProgressBar.BarFill.Parent = ProgressBar.BarBackground
    RoundCorners(ProgressBar.BarFill, 6)
    
    ProgressBar.ValueLabel = Instance.new("TextLabel")
    ProgressBar.ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ProgressBar.ValueLabel.Position = UDim2.new(1, -40, 0, 0)
    ProgressBar.ValueLabel.BackgroundTransparency = 1
    ProgressBar.ValueLabel.Text = math.floor(ProgressBar.Value) .. "%"
    ProgressBar.ValueLabel.TextColor3 = self.Window.Theme.Accent
    ProgressBar.ValueLabel.TextSize = 12
    ProgressBar.ValueLabel.Font = Enum.Font.GothamBold
    ProgressBar.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ProgressBar.ValueLabel.Parent = ProgressBar.Frame
    
    Section.Elements[#Section.Elements + 1] = ProgressBar.Frame
    Section:UpdateSize()
    
    return {
        Object = ProgressBar.Frame,
        Value = ProgressBar.Value,
        Update = function(newValue)
            ProgressBar.Value = math.clamp(newValue, 0, 100)
            SafeTween(ProgressBar.BarFill, {Size = UDim2.new(ProgressBar.Value / 100, 0, 1, 0)})
            ProgressBar.ValueLabel.Text = math.floor(ProgressBar.Value) .. "%"
        end,
        SetColor = function(color)
            ProgressBar.BarFill.BackgroundColor3 = color
        end
    }
end

-- 🆕 11. МЕТКА С ВОЗМОЖНОСТЬЮ ОБНОВЛЕНИЯ
function Section:CreateLabel(Config)
    Config = Config or {}
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, Config.Height or 25)
    Label.BackgroundTransparency = 1
    Label.Text = Config.Text or "Текст метки"
    Label.TextColor3 = Config.Color or self.Window.Theme.Text
    Label.TextSize = Config.TextSize or 14
    Label.Font = Config.Font or Enum.Font.Gotham
    Label.TextXAlignment = Config.Alignment or Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.Parent = Section.Content
    
    Section.Elements[#Section.Elements + 1] = Label
    Section:UpdateSize()
    
    return {
        Object = Label,
        Update = function(newText, newColor)
            Label.Text = newText or Label.Text
            if newColor then
                Label.TextColor3 = newColor
            end
        end
    }
end

-- 🆕 12. РАЗДЕЛИТЕЛЬ
function Section:CreateSeparator(Config)
    Config = Config or {}
    
    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(1, 0, 0, 1)
    Separator.BackgroundColor3 = Config.Color or Color3.fromRGB(80, 80, 90)
    Separator.BackgroundTransparency = 0.7
    Separator.BorderSizePixel = 0
    Separator.Parent = Section.Content
    
    Section.Elements[#Section.Elements + 1] = Separator
    Section:UpdateSize()
    
    return {
        Object = Separator,
        Update = function(newColor)
            Separator.BackgroundColor3 = newColor
        end
    }
end

-- 🆕 13. КНОПКА С ПРОГРЕССОМ
function Section:CreateProgressButton(Config)
    Config = Config or {}
    local ProgressButton = {}
    ProgressButton.Progress = 0
    ProgressButton.IsLoading = false
    
    ProgressButton.Frame = Instance.new("Frame")
    ProgressButton.Frame.Size = UDim2.new(1, 0, 0, 45)
    ProgressButton.Frame.BackgroundTransparency = 1
    ProgressButton.Frame.Parent = Section.Content
    
    ProgressButton.Button = Instance.new("TextButton")
    ProgressButton.Button.Size = UDim2.new(1, 0, 1, 0)
    ProgressButton.Button.BackgroundColor3 = self.Window.Theme.Accent
    ProgressButton.Button.Text = Config.Title or "Загрузка..."
    ProgressButton.Button.TextColor3 = self.Window.Theme.Text
    ProgressButton.Button.TextSize = 14
    ProgressButton.Button.Font = Enum.Font.Gotham
    ProgressButton.Button.Parent = ProgressButton.Frame
    RoundCorners(ProgressButton.Button, 8)
    
    ProgressButton.ProgressBar = Instance.new("Frame")
    ProgressButton.ProgressBar.Size = UDim2.new(0, 0, 0, 3)
    ProgressButton.ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressButton.ProgressBar.BackgroundColor3 = self.Window.Theme.Success
    ProgressButton.ProgressBar.Parent = ProgressButton.Button
    RoundCorners(ProgressButton.ProgressBar, 2)
    
    ProgressButton.Button.MouseButton1Click:Connect(function()
        if not ProgressButton.IsLoading and Config.Callback then
            ProgressButton.IsLoading = true
            ProgressButton.Progress = 0
            
            coroutine.wrap(function()
                while ProgressButton.Progress < 100 and ProgressButton.IsLoading do
                    ProgressButton.Progress = ProgressButton.Progress + math.random(5, 15)
                    if ProgressButton.Progress > 100 then
                        ProgressButton.Progress = 100
                    end
                    
                    SafeTween(ProgressButton.ProgressBar, {Size = UDim2.new(ProgressButton.Progress / 100, 0, 0, 3)})
                    wait(0.1)
                end
                
                if ProgressButton.Progress >= 100 then
                    pcall(Config.Callback)
                    wait(0.5)
                    ProgressButton.IsLoading = false
                    SafeTween(ProgressButton.ProgressBar, {Size = UDim2.new(0, 0, 0, 3)})
                end
            end)()
        end
    end)
    
    Animations.Hover(ProgressButton.Button, self.Window.Theme.Accent)
    
    Section.Elements[#Section.Elements + 1] = ProgressButton.Frame
    Section:UpdateSize()
    
    return {
        Object = ProgressButton.Button,
        SetProgress = function(progress)
            ProgressButton.Progress = math.clamp(progress, 0, 100)
            SafeTween(ProgressButton.ProgressBar, {Size = UDim2.new(ProgressButton.Progress / 100, 0, 0, 3)})
        end,
        SetLoading = function(loading)
            ProgressButton.IsLoading = loading
            if not loading then
                SafeTween(ProgressButton.ProgressBar, {Size = UDim2.new(0, 0, 0, 3)})
            end
        end
    }
end

-- 🆕 14. КНОПКА СЧЕТЧИКА
function Section:CreateCounterButton(Config)
    Config = Config or {}
    local CounterButton = {}
    CounterButton.Count = Config.Default or 0
    
    CounterButton.Frame = Instance.new("Frame")
    CounterButton.Frame.Size = UDim2.new(1, 0, 0, 45)
    CounterButton.Frame.BackgroundTransparency = 1
    CounterButton.Frame.Parent = Section.Content
    
    CounterButton.Button = Instance.new("TextButton")
    CounterButton.Button.Size = UDim2.new(1, -60, 1, 0)
    CounterButton.Button.BackgroundColor3 = self.Window.Theme.Accent
    CounterButton.Button.Text = Config.Title or "Счетчик: 0"
    CounterButton.Button.TextColor3 = self.Window.Theme.Text
    CounterButton.Button.TextSize = 14
    CounterButton.Button.Font = Enum.Font.Gotham
    CounterButton.Button.Parent = CounterButton.Frame
    RoundCorners(CounterButton.Button, 8)
    
    CounterButton.IncrementButton = Instance.new("TextButton")
    CounterButton.IncrementButton.Size = UDim2.new(0, 25, 0, 25)
    CounterButton.IncrementButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    CounterButton.IncrementButton.BackgroundColor3 = self.Window.Theme.Success
    CounterButton.IncrementButton.Text = "+"
    CounterButton.IncrementButton.TextColor3 = self.Window.Theme.Text
    CounterButton.IncrementButton.TextSize = 16
    CounterButton.IncrementButton.Font = Enum.Font.GothamBold
    CounterButton.IncrementButton.Parent = CounterButton.Frame
    RoundCorners(CounterButton.IncrementButton, 5)
    
    CounterButton.DecrementButton = Instance.new("TextButton")
    CounterButton.DecrementButton.Size = UDim2.new(0, 25, 0, 25)
    CounterButton.DecrementButton.Position = UDim2.new(1, -25, 0.5, -12.5)
    CounterButton.DecrementButton.BackgroundColor3 = self.Window.Theme.Error
    CounterButton.DecrementButton.Text = "-"
    CounterButton.DecrementButton.TextColor3 = self.Window.Theme.Text
    CounterButton.DecrementButton.TextSize = 16
    CounterButton.DecrementButton.Font = Enum.Font.GothamBold
    CounterButton.DecrementButton.Parent = CounterButton.Frame
    RoundCorners(CounterButton.DecrementButton, 5)
    
    local function UpdateCounter()
        CounterButton.Button.Text = Config.Title and Config.Title .. ": " .. CounterButton.Count or "Счетчик: " .. CounterButton.Count
        
        if Config.Callback then
            pcall(Config.Callback, CounterButton.Count)
        end
    end
    
    CounterButton.Button.MouseButton1Click:Connect(function()
        CounterButton.Count = CounterButton.Count + 1
        UpdateCounter()
    end)
    
    CounterButton.IncrementButton.MouseButton1Click:Connect(function()
        CounterButton.Count = CounterButton.Count + 1
        UpdateCounter()
    end)
    
    CounterButton.DecrementButton.MouseButton1Click:Connect(function()
        CounterButton.Count = math.max(0, CounterButton.Count - 1)
        UpdateCounter()
    end)
    
    Animations.Hover(CounterButton.Button, self.Window.Theme.Accent)
    Animations.Hover(CounterButton.IncrementButton, self.Window.Theme.Success)
    Animations.Hover(CounterButton.DecrementButton, self.Window.Theme.Error)
    
    UpdateCounter()
    
    Section.Elements[#Section.Elements + 1] = CounterButton.Frame
    Section:UpdateSize()
    
    return {
        Object = CounterButton.Frame,
        Count = CounterButton.Count,
        Update = function(newCount)
            CounterButton.Count = newCount
            UpdateCounter()
        end,
        Increment = function()
            CounterButton.Count = CounterButton.Count + 1
            UpdateCounter()
        end,
        Decrement = function()
            CounterButton.Count = math.max(0, CounterButton.Count - 1)
            UpdateCounter()
        end
    }
end

-- 🆕 15. КАРТОЧКА С ИНФОРМАЦИЕЙ
function Section:CreateCard(Config)
    Config = Config or {}
    
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, Config.Height or 80)
    Card.BackgroundColor3 = self.Window.Theme.Secondary
    Card.BackgroundTransparency = 0.1
    Card.Parent = Section.Content
    RoundCorners(Card, 8)
    CreateGlow(Card, self.Window.Theme.Accent, 0.3)
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 15, 0.5, -20)
    Icon.BackgroundTransparency = 1
    Icon.Text = Config.Icon or "📄"
    Icon.TextColor3 = self.Window.Theme.Accent
    Icon.TextSize = 20
    Icon.Font = Enum.Font.GothamBold
    Icon.Parent = Card
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 0, 25)
    Title.Position = UDim2.new(0, 60, 0, 15)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Title or "Заголовок карточки"
    Title.TextColor3 = self.Window.Theme.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Card
    
    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -70, 0, 35)
    Description.Position = UDim2.new(0, 60, 0, 40)
    Description.BackgroundTransparency = 1
    Description.Text = Config.Description or "Описание карточки"
    Description.TextColor3 = self.Window.Theme.Text
    Description.TextTransparency = 0.5
    Description.TextSize = 12
    Description.Font = Enum.Font.Gotham
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.TextWrapped = true
    Description.Parent = Card
    
    Section.Elements[#Section.Elements + 1] = Card
    Section:UpdateSize()
    
    return {
        Object = Card,
        Update = function(newConfig)
            if newConfig.Title then Title.Text = newConfig.Title end
            if newConfig.Description then Description.Text = newConfig.Description end
            if newConfig.Icon then Icon.Text = newConfig.Icon end
        end
    }
end

-- 🔧 МЕТОД ОБНОВЛЕНИЯ РАЗМЕРА СЕКЦИИ
function Section:UpdateSize()
    local totalHeight = self.Description and 75 or 45
    
    for _, element in pairs(self.Elements) do
        if element and element.Size then
            totalHeight = totalHeight + element.Size.Y.Offset + 10
        end
    end
    
    if self.Frame then
        self.Frame.Size = UDim2.new(1, 0, 0, totalHeight)
        if self.Content then
            self.Content.Size = UDim2.new(1, 0, 0, totalHeight - (self.Description and 75 or 45))
        end
    end
end
end
-- 🔧 ЧАСТЬ 3: ИСПРАВЛЕНИЯ БАГОВ И ОПТИМИЗАЦИЯ

-- 🐛 ИСПРАВЛЕНИЕ: Метод UpdateSize для секций
function Section:UpdateSize()
    if not self.Frame then return end
    
    local totalHeight = self.Description and 75 or 45
    
    for _, element in pairs(self.Elements) do
        if element and element.Size then
            totalHeight = totalHeight + element.Size.Y.Offset + 10
        end
    end
    
    self.Frame.Size = UDim2.new(1, 0, 0, totalHeight)
    if self.Content then
        self.Content.Size = UDim2.new(1, 0, 0, totalHeight - (self.Description and 75 or 45))
    end
end

-- 🐛 ИСПРАВЛЕНИЕ: Безопасное создание элементов
function Section:CreateButton(Config)
    Config = Config or {}
    
    -- Проверка на существование контейнера
    if not self.Content then
        warn("Section content not found!")
        return
    end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.BackgroundColor3 = self.Window.Theme.Accent
    Button.Text = Config.Title or "🚀 Кнопка"
    Button.TextColor3 = self.Window.Theme.Text
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = self.Content
    RoundCorners(Button, 8)
    CreateGlow(Button, self.Window.Theme.Accent, 0.4)
    
    -- Безопасные анимации
    local originalColor = Button.BackgroundColor3
    if self.Window.AnimationsEnabled then
        Animations.Hover(Button, originalColor)
    end
    
    -- Безопасный callback
    Button.MouseButton1Click:Connect(function()
        if self.Window.AnimationsEnabled then
            SafeTween(Button, {Size = UDim2.new(0.95, 0, 0.9, 0)}, 0.1)
            SafeTween(Button, {Size = UDim2.new(1, 0, 1, 0)}, 0.1, Enum.EasingStyle.Back)
        end
        
        if Config.Callback then
            local success, err = pcall(Config.Callback)
            if not success then
                self.Window:Notify({
                    Title = "Ошибка",
                    Content = tostring(err),
                    Type = "error"
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
                Button.Text = newConfig.Title
            end
        end,
        SetDisabled = function(disabled)
            Button.AutoButtonColor = not disabled
            Button.BackgroundTransparency = disabled and 0.7 or 0
        end
    }
end

-- 🐛 ИСПРАВЛЕНИЕ: Слайдер с правильной математикой
function Section:CreateSlider(Config)
    Config = Config or {}
    local Slider = {}
    Slider.Value = Config.Default or Config.Min or 0
    
    Slider.Frame = Instance.new("Frame")
    Slider.Frame.Size = UDim2.new(1, 0, 0, 70)
    Slider.Frame.BackgroundTransparency = 1
    Slider.Frame.Parent = self.Content
    
    -- ... (остальной код слайдера)
    
    local function UpdateSlider(Value)
        local Min = Config.Min or 0
        local Max = Config.Max or 100
        local Normalized = math.clamp((Value - Min) / (Max - Min), 0, 1)
        
        Slider.Value = math.floor(Value)
        Slider.Fill.Size = UDim2.new(Normalized, 0, 1, 0)
        Slider.Handle.Position = UDim2.new(Normalized, -9, 0.5, -9)
        Slider.Title.Text = Config.Title or "Слайдер: " .. Slider.Value
        Slider.ValueLabel.Text = tostring(Slider.Value)
        
        if Config.Callback then
            pcall(Config.Callback, Slider.Value)
        end
    end
    
    -- ... (обработка ввода)
    
    table.insert(self.Elements, Slider.Frame)
    self:UpdateSize()
    
    return {
        Object = Slider.Frame,
        Value = Slider.Value,
        Update = function(newValue)
            UpdateSlider(newValue)
        end
    }
end

-- 🐛 ИСПРАВЛЕНИЕ: Уведомления с проверкой родителя
function Window:Notify(Config)
    Config = Config or {}
    
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Parent = CoreGui
    notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- ... (создание элементов уведомления)
    
    -- Безопасное закрытие
    local function safeDestroy()
        if notifyGui and notifyGui.Parent then
            SafeTween(notifyFrame, {Position = UDim2.new(1, 400, 0, 20)}, 0.5, Enum.EasingStyle.Quad)
            wait(0.5)
            if notifyGui.Parent then
                notifyGui:Destroy()
            end
        end
    end
    
    -- Автоматическое закрытие с проверкой
    local duration = Config.Duration or 4
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

-- 🐛 ИСПРАВЛЕНИЕ: Уничтожение окна с очисткой
function Window:Destroy()
    if self.ScreenGui then
        -- Останавливаем все корутины
        for _, connection in pairs(self.Connections or {}) do
            if connection then
                pcall(function() connection:Disconnect() end)
            end
        end
        
        -- Уничтожаем GUI
        self.ScreenGui:Destroy()
    end
end

-- 🐛 ИСПРАВЛЕНИЕ: Защита от повторного создания
local existingWindows = {}
function TelaryUI:CreateWindow(Config)
    Config = Config or {}
    
    -- Проверка на дубликаты
    local windowId = Config.Title or "TelaryUI_Window"
    if existingWindows[windowId] and existingWindows[windowId].ScreenGui.Parent then
        existingWindows[windowId]:Destroy()
    end
    
    local Window = setmetatable({}, TelaryUI)
    Window.ID = HttpService:GenerateGUID(false)
    Window.Theme = Themes[Config.Theme or "Cyber"]
    Window.Elements = {}
    Window.Connections = {}
    
    -- ... (остальной код создания окна)
    
    existingWindows[windowId] = Window
    return Window
end

-- 🐛 ИСПРАВЛЕНИЕ: Глобальные функции
function TelaryUI:ChangeGlobalTheme(ThemeName)
    if Themes[ThemeName] then
        -- Здесь можно добавить логику смены темы для всех окон
        return true
    end
    return false
end

function TelaryUI:DestroyAll()
    for _, window in pairs(existingWindows) do
        if window and window.Destroy then
            pcall(window.Destroy, window)
        end
    end
    existingWindows = {}
end

-- 🎯 ВОЗВРАТ БИБЛИОТЕКИ
return TelaryUI
function TelaryUI:DestroyAll()
    -- Уничтожение всех окон
end

return TelaryUI
