📚 Telary UI Library - Полный гайд по использованию
🎯 Введение

Custom UI Library - это мощная и красивая библиотека для создания интерфейсов в Roblox, вдохновленная Rayfield. Библиотека предлагает современный дизайн, плавные анимации и простой в использовании API.
📥 Установка
lua

-- Добавьте в начало вашего скрипта:
local CustomUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/TelaryUI/main/TelaryUI.lua"))()

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

📝 Практические примеры
Пример 1: Меню для игры
lua

local CustomUI = loadstring(game:HttpGet("URL_БИБЛИОТЕКИ"))()

local Window = CustomUI:CreateWindow({
    Title = "🎮 Меню взломщика",
    Size = UDim2.new(0, 500, 0, 450),
    Center = true
})

local MainTab = Window:CreateTab("Главная", "🏠")

-- Секция персонажа
local CharacterSection = MainTab:CreateSection("Персонаж")

CharacterSection:CreateToggle({
    Title = "Бесконечный прыжок",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
        else
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
})

CharacterSection:CreateSlider({
    Title = "Скорость",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Секция телепортации
local TeleportSection = MainTab:CreateSection("Телепортация")

TeleportSection:CreateButton({
    Title = "Телепорт на спавн",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        Window:Notify({
            Title = "Телепорт",
            Content = "Успешно телепортирован на спавн!"
        })
    end
})

Пример 2: Динамическое обновление
lua

local players = {"Игрок1", "Игрок2"}

local dropdown = Section:CreateDropdown({
    Title = "Игроки",
    Options = players,
    Callback = function(Selected)
        print("Выбран: " .. Selected)
    end
})

-- Обновление списка игроков
game:GetService("Players").PlayerAdded:Connect(function(player)
    table.insert(players, player.Name)
    dropdown:Refresh(players)
end)

⚡ Советы и лучшие практики
1. Организация кода
lua

-- Плохо
Tab:CreateSection("Персонаж"):CreateButton({Title = "Кнопка1"})
Tab:CreateSection("Персонаж"):CreateToggle({Title = "Тоггл1"})

-- Хорошо
local CharacterSection = Tab:CreateSection("Персонаж")
CharacterSection:CreateButton({Title = "Кнопка1"})
CharacterSection:CreateToggle({Title = "Тоггл1"})

2. Обработка ошибок
lua

CharacterSection:CreateButton({
    Title = "Опасное действие",
    Callback = function()
        local success, err = pcall(function()
            -- Код который может вызвать ошибку
        end)
        
        if not success then
            Window:Notify({
                Title = "Ошибка",
                Content = "Что-то пошло не так: " .. err
            })
        end
    end
})

3. Оптимизация
lua

-- Используйте переменные для часто используемых элементов
local humanoid = game.Players.LocalPlayer.Character.Humanoid

SpeedSlider:CreateSlider({
    Callback = function(Value)
        humanoid.WalkSpeed = Value  -- Используем существующую переменную
    end
})

🔧 Расширенные возможности
Получение значений элементов
lua

local toggle = Section:CreateToggle({
    Title = "Мой тоггл",
    Default = false
})

-- Проверить состояние
print(toggle.Value)

-- Изменить состояние программно
toggle.Value = true
toggle.Button.Text = "✅ Мой тоггл"

Кастомные обработчики событий
lua

local button = Section:CreateButton({
    Title = "Моя кнопка"
})

-- Добавляем дополнительные события
button.MouseEnter:Connect(function()
    print("Курсор над кнопкой")
end)

button.MouseLeave:Connect(function()
    print("Курсор ушел с кнопки")
end)

🐛 Решение проблем
Окно не появляется

    Проверьте правильность URL библиотеки

    Убедитесь что скрипт выполняется

    Проверьте нет ли ошибок в Output

Элементы не работают

    Проверьте callback функции

    Убедитесь что нет синтаксических ошибок

    Проверьте правильность параметров

Производительность

    Не создавайте элементы в циклах без необходимости

    Используйте Destroy() для удаления ненужных окон

    Избегайте частых обновлений интерфейса

📞 Поддержка

Если у вас возникли проблемы:

    Проверьте синтаксис

    Убедитесь что все callback функции определены

    Проверьте консоль на наличие ошибок

    Следуйте примерам из этого гайда
