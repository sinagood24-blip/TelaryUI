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
            
            -- 🆕 1. УЛУЧШЕННЫЕ КНОПКИ С РАЗНЫМИ СТИЛЯМИ
            function Section:CreateButton(Config)
                Config = Config or {}
                
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
                end
                
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

            -- 🆕 4. ПЕРЕКЛЮЧАТЕЛЬ С АНИМАЦИЕЙ
            function Section:CreateToggle(Config)
                Config = Config or {}
                local Toggle = {}
                Toggle.Value = Config.Default or false
                
                Toggle.Frame = Instance.new("Frame")
                Toggle.Frame.Size = UDim2.new(1, 0, 0, 35)
                Toggle.Frame.BackgroundTransparency = 1
                Toggle.Frame.Parent = self.Content
                
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
                
                table.insert(self.Elements, Toggle.Frame)
                self:UpdateSize()
                
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

            -- 🆕 10. ПРОГРЕСС-БАР
            function Section:CreateProgressBar(Config)
                Config = Config or {}
                local ProgressBar = {}
                ProgressBar.Value = Config.Default or 0
                
                ProgressBar.Frame = Instance.new("Frame")
                ProgressBar.Frame.Size = UDim2.new(1, 0, 0, 40)
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
                
                table.insert(self.Elements, ProgressBar.Frame)
                self:UpdateSize()
                
                return {
                    Object = ProgressBar.Frame,
                    Value = ProgressBar.Value,
                    Update = function(newValue)
                        ProgressBar.Value = math.clamp(newValue, 0, 100)
                        SafeTween(ProgressBar.BarFill, {Size = UDim2.new(ProgressBar.Value / 100, 0, 1, 0)})
                        ProgressBar.ValueLabel.Text = math.floor(ProgressBar.Value) .. "%"
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
                Label.Parent = self.Content
                
                table.insert(self.Elements, Label)
                self:UpdateSize()
                
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

            -- 🔧 МЕТОД ОБНОВЛЕНИЯ РАЗМЕРА СЕКЦИИ
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

-- 🎯 ВОЗВРАТ БИБЛИОТЕКИ
return TelaryUI
