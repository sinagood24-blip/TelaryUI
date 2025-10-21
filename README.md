📚 Custom UI Library - Полный гайд по использованию
🎯 Введение

Custom UI Library - это мощная и красивая библиотека для создания интерфейсов в Roblox, вдохновленная Rayfield. Библиотека предлагает современный дизайн, плавные анимации и простой в использовании API.
📥 Установка
lua

-- Добавьте в начало вашего скрипта:
local CustomUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/custom-ui/main/library.lua"))()

🏗️ Создание окна
Базовое окно
lua

local Window = CustomUI:CreateWindow({
    Title = "Мое меню",          -- Заголовок окна
    Size = UDim2.new(0, 500, 0, 450),  -- Размер окна
    Center = true,               -- Центрировать на экране
    Draggable = true             -- Возможность перетаскивания
})

Все параметры окна
lua

local Window = CustomUI:CreateWindow({
    Title = "Меню взломщика",    -- Заголовок окна
    Size = UDim2.new(0, 550, 0, 500),  -- Размер (Ширина, Высота)
    Position = UDim2.new(0, 100, 0, 100), -- Позиция (если Center = false)
    Center = true,               -- Авто-центрирование
    Draggable = true             -- Перетаскивание за заголовок
})

📑 Работа с вкладками
Создание вкладки
lua

local MainTab = Window:CreateTab("Главная", "🏠")      -- С иконкой
local SettingsTab = Window:CreateTab("Настройки")     -- Без иконки

📊 Создание элементов UI
Секции
lua

local CharacterSection = MainTab:CreateSection("Персонаж")
local VisualSection = MainTab:CreateSection("Визуал")
local TeleportSection = MainTab:CreateSection("Телепортация")

Кнопки (Buttons)
lua

CharacterSection:CreateButton({
    Title = "Телепорт на спавн",
    Callback = function()
        print("Кнопка нажата!")
        -- Ваш код здесь
    end
})

Переключатели (Toggles)
lua

local NoclipToggle = CharacterSection:CreateToggle({
    Title = "Режим ноклип",
    Default = false,  -- Начальное состояние
    Callback = function(Value)
        if Value then
            print("Ноклип включен")
        else
            print("Ноклип выключен")
        end
    end
})

Слайдеры (Sliders)
lua

local SpeedSlider = CharacterSection:CreateSlider({
    Title = "Скорость передвижения",
    Min = 16,        -- Минимальное значение
    Max = 200,       -- Максимальное значение  
    Default = 16,    -- Значение по умолчанию
    Callback = function(Value)
        print("Скорость установлена: " .. Value)
        -- Изменяем скорость персонажа
    end
})

Выпадающие списки (Dropdowns)
lua

local PlayersDropdown = CharacterSection:CreateDropdown({
    Title = "Телепорт к игроку",
    Options = {"Игрок1", "Игрок2", "Игрок3"},  -- Список опций
    Default = "Игрок1",  -- Выбранная опция по умолчанию
    Callback = function(Selected)
        print("Выбран: " .. Selected)
        -- Телепорт к игроку
    end
})

-- Динамическое обновление списка
PlayersDropdown:Refresh({"НовыйИгрок1", "НовыйИгрок2"})

🔔 Система уведомлений
Простое уведомление
lua

Window:Notify({
    Title = "Успех!",
    Content = "Операция выполнена успешно",
    Duration = 3  -- Секунды
})

Расширенное уведомление
lua

Window:Notify({
    Title = "Внимание!",
    Content = "Это важное сообщение для пользователя",
    Duration = 5  -- Показывать 5 секунд
})

🎨 Цветовая схема

Библиотека использует встроенную цветовую схему:

    Основной фон: Темно-синий (#191923)

    Акцентный цвет: Синий (#0096FF)

    Текст: Белый (#FFFFFF)

    Успех: Зеленый (#55FF55)

    Ошибка: Красный (#FF5555)
