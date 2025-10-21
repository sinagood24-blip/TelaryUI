--[[
   Telary UI Library v3.0 - Ultimate Edition
   Modern, Fast, Feature-Rich UI Library for Roblox
   Fixed bugs, Added glow effects, New elements, Better performance
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local TelaryUI = {}
TelaryUI.__index = TelaryUI

-- Вспомогательные функции ДО основного кода
local function SafeTween(Object, Properties, Duration, Style)
    if not Object or not Object.Parent then return end
    local success, result = pcall(function()
        local TweenInfo = TweenInfo.new(Duration or 0.3, Style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Tween = TweenService:Create(Object, TweenInfo, Properties)
        Tween:Play()
        return Tween
    end)
    return result
end

local function RoundCorners(Object, CornerRadius)
    if not Object then return end
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, CornerRadius or 8)
    UICorner.Parent = Object
    return UICorner
end

local function CreateGlow(Object, Color, Intensity)
    if not Object then return end
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "GlowEffect"
    Glow.Size = UDim2.new(1, 20, 1, 20)
    Glow.Position = UDim2.new(0, -10, 0, -10)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://8992230675"
    Glow.ImageColor3 = Color or Color3.new(1, 1, 1)
    Glow.ImageTransparency = 0.8
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(23, 23, 277, 277)
    Glow.ZIndex = -1
    Glow.Parent = Object
    return Glow
end

local function CreateAdvancedShadow(Object)
    if not Object then return end
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 15, 1, 15)
    Shadow.Position = UDim2.new(0, -7, 0, -7)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = Object
    return Shadow
end

local function CreateWindowControlButton(Window, Text, Color, Position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 30, 0, 30)
    Button.Position = Position
    Button.BackgroundColor3 = Color
    Button.Text = Text
    Button.TextColor3 = Window.Theme.Text
    Button.TextSize = 16
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Window.TitleBar
    RoundCorners(Button, 6)
    CreateGlow(Button, Color, 0.5)
    return Button
end

local function SetupWindowDragging(Window)
    local Dragging, DragInput, DragStart, StartPos
    
    local function Update(input)
        if not Window.MainFrame then return end
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

local function SetupWindowControls(Window, CloseButton, MinimizeButton, SettingsButton)
    if CloseButton then
        CloseButton.MouseButton1Click:Connect(function()
            Window:Destroy()
        end)
    end
    
    if MinimizeButton then
        MinimizeButton.MouseButton1Click:Connect(function()
            Window:Minimize()
        end)
    end
    
    if SettingsButton then
        SettingsButton.MouseButton1Click:Connect(function()
            Window:ShowSettings()
        end)
    end
end

-- Расширенная цветовая схема с неоновыми темами
local Themes = {
    Cyber = {
        Background = Color3.fromRGB(10, 10, 20),
        Secondary = Color3.fromRGB(20, 20, 35),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(0, 255, 128),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 50, 50),
        Border = Color3.fromRGB(0, 150, 255),
        Glow = Color3.fromRGB(0, 200, 255)
    },
    Neon = {
        Background = Color3.fromRGB(15, 5, 25),
        Secondary = Color3.fromRGB(25, 10, 40),
        Accent = Color3.fromRGB(255, 0, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(0, 255, 0),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 0, 0),
        Border = Color3.fromRGB(150, 0, 255),
        Glow = Color3.fromRGB(255, 0, 255)
    },
    Matrix = {
        Background = Color3.fromRGB(0, 10, 0),
        Secondary = Color3.fromRGB(0, 20, 0),
        Accent = Color3.fromRGB(0, 255, 0),
        Text = Color3.fromRGB(0, 255, 0),
        Success = Color3.fromRGB(0, 255, 0),
        Warning = Color3.fromRGB(200, 255, 0),
        Error = Color3.fromRGB(255, 50, 0),
        Border = Color3.fromRGB(0, 100, 0),
        Glow = Color3.fromRGB(0, 255, 0)
    },
    Dark = {
        Background = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(65, 105, 225),
        Text = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(50, 205, 50),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(220, 20, 60),
        Border = Color3.fromRGB(70, 70, 90),
        Glow = Color3.fromRGB(100, 100, 255)
    }
}

-- Конфигурация с автсохранением
local Configuration = {
    CurrentTheme = "Cyber",
    SaveSettings = true,
    SettingsKey = "TelaryUIv3_Settings"
}

-- Улучшенная система анимаций
local Animations = {
    Hover = function(Object, Theme)
        if not Object then return end
        local originalColor = Object.BackgroundColor3
        
        Object.MouseEnter:Connect(function()
            SafeTween(Object, {BackgroundColor3 = originalColor:Lerp(Color3.new(1, 1, 1), 0.15)})
        end)
        
        Object.MouseLeave:Connect(function()
            SafeTween(Object, {BackgroundColor3 = originalColor})
        end)
    end
}

-- Основная функция создания окна
function TelaryUI:CreateWindow(Config)
    Config = Config or {}
    
    local Window = setmetatable({}, TelaryUI)
    Window.ID = HttpService:GenerateGUID(false)
    Window.Theme = Themes[Configuration.CurrentTheme]
    Window.Elements = {}
    
    -- Создаем основной GUI
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "TelaryUIv3_" .. Window.ID
    Window.ScreenGui.Parent = CoreGui
    Window.ScreenGui.ResetOnSpawn = false
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Главный контейнер с улучшенным дизайном
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Size = Config.Size or UDim2.new(0, 600, 0, 650)
    Window.MainFrame.Position = Config.Center and UDim2.new(0.5, -Window.MainFrame.Size.X.Offset/2, 0.5, -Window.MainFrame.Size.Y.Offset/2) or (Config.Position or UDim2.new(0, 100, 0, 100))
    Window.MainFrame.BackgroundColor3 = Window.Theme.Background
    Window.MainFrame.BackgroundTransparency = 0.1
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Parent = Window.ScreenGui
    RoundCorners(Window.MainFrame, 15)
    
    -- Свечение и тень
    CreateGlow(Window.MainFrame, Window.Theme.Glow, 0.3)
    CreateAdvancedShadow(Window.MainFrame)
    
    -- Заголовок с анимированным градиентом
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    Window.TitleBar.BackgroundColor3 = Window.Theme.Secondary
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.Parent = Window.MainFrame
    RoundCorners(Window.TitleBar, 15)
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Window.Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Window.Theme.Secondary),
        ColorSequenceKeypoint.new(1, Window.Theme.Accent)
    })
    TitleGradient.Rotation = 45
    TitleGradient.Parent = Window.TitleBar
    
    -- Анимация градиента
    coroutine.wrap(function()
        while Window.TitleBar and Window.TitleBar.Parent do
            for i = 0, 360, 2 do
                if Window.TitleBar and Window.TitleBar.Parent then
                    TitleGradient.Rotation = i
                    wait(0.03)
                else
                    break
                end
            end
        end
    end)()
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "Telary UI v3.0"
    TitleLabel.TextColor3 = Window.Theme.Text
    TitleLabel.TextSize = 20
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Window.TitleBar
    
    -- Кнопки управления с иконками
    local CloseButton = CreateWindowControlButton(Window, "×", Window.Theme.Error, UDim2.new(1, -45, 0, 10))
    local MinimizeButton = CreateWindowControlButton(Window, "−", Window.Theme.Warning, UDim2.new(1, -85, 0, 10))
    local SettingsButton = CreateWindowControlButton(Window, "⚙️", Window.Theme.Accent, UDim2.new(1, -125, 0, 10))
    
    -- Контейнер для вкладок
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Size = UDim2.new(1, 0, 1, -50)
    Window.TabContainer.Position = UDim2.new(0, 0, 0, 50)
    Window.TabContainer.BackgroundTransparency = 1
    Window.TabContainer.Parent = Window.MainFrame
    
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    
    -- Функционал перетаскивания
    if Config.Draggable ~= false then
        SetupWindowDragging(Window)
    end
    
    -- Обработчики кнопок
    SetupWindowControls(Window, CloseButton, MinimizeButton, SettingsButton)
    
    -- Анимация появления
    SafeTween(Window.MainFrame, {Size = Config.Size or UDim2.new(0, 600, 0, 650)}, 0.6, Enum.EasingStyle.Back)
    
    -- Основные методы окна
    function Window:CreateTab(Name, Icon)
        local Tab = {}
        Tab.Name = Name
        Tab.Window = self
        Tab.Elements = {}
        
        -- Кнопка вкладки с улучшенным дизайном
        Tab.Button = Instance.new("TextButton")
        Tab.Button.Size = UDim2.new(0, 130, 0, 45)
        Tab.Button.Position = UDim2.new(0, 15 + (#self.Tabs * 140), 0, -45)
        Tab.Button.BackgroundColor3 = self.Theme.Secondary
        Tab.Button.Text = (Icon or "📁") .. " " .. Name
        Tab.Button.TextColor3 = self.Theme.Text
        Tab.Button.TextSize = 14
        Tab.Button.Font = Enum.Font.Gotham
        Tab.Button.Parent = self.MainFrame
        RoundCorners(Tab.Button, 10)
        CreateGlow(Tab.Button, self.Theme.Accent, 0.3)
        
        -- Контент вкладки
        Tab.Content = Instance.new("ScrollingFrame")
        Tab.Content.Size = UDim2.new(1, -20, 1, -20)
        Tab.Content.Position = UDim2.new(0, 10, 0, 10)
        Tab.Content.BackgroundTransparency = 1
        Tab.Content.ScrollBarThickness = 6
        Tab.Content.ScrollBarImageColor3 = self.Theme.Accent
        Tab.Content.ScrollBarImageTransparency = 0.5
        Tab.Content.Visible = false
        Tab.Content.Parent = self.TabContainer
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 15)
        UIListLayout.Parent = Tab.Content
        
        Tab.Sections = {}
        
        function Tab:CreateSection(Name)
            local Section = {}
            Section.Name = Name
            Section.Elements = {}
            
            Section.Frame = Instance.new("Frame")
            Section.Frame.Size = UDim2.new(1, 0, 0, 0)
            Section.Frame.BackgroundColor3 = self.Window.Theme.Secondary
            Section.Frame.BackgroundTransparency = 0.1
            Section.Frame.BorderSizePixel = 0
            Section.Frame.Parent = Tab.Content
            RoundCorners(Section.Frame, 12)
            CreateGlow(Section.Frame, self.Window.Theme.Glow, 0.2)
            CreateAdvancedShadow(Section.Frame)
            
            Section.Title = Instance.new("TextLabel")
            Section.Title.Size = UDim2.new(1, -20, 0, 40)
            Section.Title.Position = UDim2.new(0, 10, 0, 0)
            Section.Title.BackgroundTransparency = 1
            Section.Title.Text = "✨ " .. Name
            Section.Title.TextColor3 = self.Window.Theme.Text
            Section.Title.TextSize = 16
            Section.Title.Font = Enum.Font.GothamBold
            Section.Title.TextXAlignment = Enum.TextXAlignment.Left
            Section.Title.Parent = Section.Frame
            
            Section.Content = Instance.new("Frame")
            Section.Content.Size = UDim2.new(1, -20, 0, 0)
            Section.Content.Position = UDim2.new(0, 10, 0, 45)
            Section.Content.BackgroundTransparency = 1
            Section.Content.Parent = Section.Frame
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Padding = UDim.new(0, 12)
            SectionList.Parent = Section.Content
            
            function Section:CreateButton(Config)
                Config = Config or {}
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 45)
                Button.BackgroundColor3 = self.Window.Theme.Accent
                Button.Text = Config.Title or "🚀 Кнопка"
                Button.TextColor3 = self.Window.Theme.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.Gotham
                Button.Parent = Section.Content
                RoundCorners(Button, 8)
                CreateGlow(Button, self.Window.Theme.Glow, 0.4)
                
                -- Анимации
                Animations.Hover(Button, self.Window.Theme)
                
                Button.MouseButton1Click:Connect(function()
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
                
                Section.Elements[#Section.Elements + 1] = Button
                Section:UpdateSize()
                
                return {
                    Object = Button,
                    Update = function(newConfig)
                        if newConfig.Title then
                            Button.Text = newConfig.Title
                        end
                    end
                }
            end
            
            function Section:UpdateSize()
                local TotalHeight = 50
                for _, Element in pairs(self.Elements) do
                    if Element and Element.Size then
                        TotalHeight += Element.Size.Y.Offset + 12
                    end
                end
                if self.Frame then
                    self.Frame.Size = UDim2.new(1, 0, 0, TotalHeight)
                    if self.Content then
                        self.Content.Size = UDim2.new(1, 0, 0, TotalHeight - 50)
                    end
                end
            end
            
            Section:UpdateSize()
            Tab.Sections[#Tab.Sections + 1] = Section
            
            return Section
        end
        
        function Tab:Show()
            if self.Window.CurrentTab then
                if self.Window.CurrentTab.Content then
                    self.Window.CurrentTab.Content.Visible = false
                end
                if self.Window.CurrentTab.Button then
                    SafeTween(self.Window.CurrentTab.Button, {BackgroundColor3 = self.Window.Theme.Secondary})
                end
            end
            
            self.Window.CurrentTab = self
            if self.Content then
                self.Content.Visible = true
            end
            if self.Button then
                SafeTween(self.Button, {BackgroundColor3 = self.Window.Theme.Accent})
            end
        end
        
        if Tab.Button then
            Tab.Button.MouseButton1Click:Connect(function()
                Tab:Show()
            end)
        end
        
        self.Tabs[#self.Tabs + 1] = Tab
        
        if #self.Tabs == 1 then
            Tab:Show()
        end
        
        return Tab
    end
    
    -- Улучшенная система уведомлений
    function Window:Notify(Config)
        Config = Config or {}
        
        local NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Parent = CoreGui
        NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Size = UDim2.new(0, 380, 0, 90)
        NotifyFrame.Position = UDim2.new(1, -400, 0, 20)
        NotifyFrame.BackgroundColor3 = self.Theme.Secondary
        NotifyFrame.BackgroundTransparency = 0.1
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Parent = NotifyGui
        RoundCorners(NotifyFrame, 12)
        CreateGlow(NotifyFrame, self.Theme.Glow, 0.4)
        CreateAdvancedShadow(NotifyFrame)
        
        local Icon = Instance.new("TextLabel")
        Icon.Size = UDim2.new(0, 50, 0, 50)
        Icon.Position = UDim2.new(0, 15, 0, 20)
        Icon.BackgroundTransparency = 1
        Icon.Text = Config.Type == "error" and "❌" or Config.Type == "warning" and "⚠️" or "✅"
        Icon.TextColor3 = Config.Type == "error" and self.Theme.Error or Config.Type == "warning" and self.Theme.Warning or self.Theme.Success
        Icon.TextSize = 24
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = NotifyFrame
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -80, 0, 30)
        Title.Position = UDim2.new(0, 70, 0, 15)
        Title.BackgroundTransparency = 1
        Title.Text = Config.Title or "Уведомление"
        Title.TextColor3 = self.Theme.Text
        Title.TextSize = 16
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = NotifyFrame
        
        local Content = Instance.new("TextLabel")
        Content.Size = UDim2.new(1, -80, 0, 40)
        Content.Position = UDim2.new(0, 70, 0, 45)
        Content.BackgroundTransparency = 1
        Content.Text = Config.Content or ""
        Content.TextColor3 = self.Theme.Text
        Content.TextSize = 14
        Content.Font = Enum.Font.Gotham
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextYAlignment = Enum.TextYAlignment.Top
        Content.Parent = NotifyFrame
        
        -- Анимация появления
        NotifyFrame.Position = UDim2.new(1, 400, 0, 20)
        SafeTween(NotifyFrame, {Position = UDim2.new(1, -400, 0, 20)}, 0.5, Enum.EasingStyle.Back)
        
        wait(Config.Duration or 4)
        
        -- Анимация исчезновения
        SafeTween(NotifyFrame, {Position = UDim2.new(1, 400, 0, 20)}, 0.5, Enum.EasingStyle.Quad)
        wait(0.5)
        NotifyGui:Destroy()
    end
    
    function Window:Minimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            SafeTween(self.MainFrame, {Size = UDim2.new(0, 250, 0, 50)}, 0.3)
            self.TabContainer.Visible = false
        else
            SafeTween(self.MainFrame, {Size = Config.Size or UDim2.new(0, 600, 0, 650)}, 0.3)
            self.TabContainer.Visible = true
        end
    end
    
    function Window:ShowSettings()
        self:Notify({
            Title = "Настройки",
            Content = "Окно настроек в разработке...",
            Type = "warning"
        })
    end
    
    function Window:Destroy()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end
    
    -- Первое уведомление
    Window:Notify({
        Title = "Telary UI v3.0",
        Content = "Ультрасовременный интерфейс загружен!\nНаслаждайтесь новым дизайном и анимациями!",
        Type = "success",
        Duration = 5
    })
    
    return Window
end

-- Глобальные функции
function TelaryUI:ChangeGlobalTheme(ThemeName)
    if Themes[ThemeName] then
        Configuration.CurrentTheme = ThemeName
    end
end

function TelaryUI:DestroyAll()
    -- Уничтожение всех окон
end

return TelaryUI
