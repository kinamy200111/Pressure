-- ESPsystem.lua - Модуль ESP для Pressure
-- Интегрированная версия для Rathub
-- Авто-рескан управляется из основного скрипта!

local ESP = {}

-- Настройки
ESP.Settings = {
    KeycardESP = false,
    DoorESP = false,
    ItemsESP = false,
    CurrencyESP = false,
    MaxDistance = 150
    -- Авто-рескан УДАЛЕН - используется из pressure.lua
}

-- Внутренние таблицы
local espObjects = {}
local trackedMobs = {"Angler", "Blitz", "Pinkie", "Pandemonium", "Froger", "Chainsmoker",
    "RidgeAngler","RidgeBlitz","RidgePinkie","RidgePandemonium","RidgeFroger","RidgeChainsmoker","A60","Harbinger"}

-- Вспомогательные функции
local function tableLength(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

local function getPosition(instance)
    if instance.Position then
        return instance.Position
    end
    
    for _, child in ipairs(instance:GetChildren()) do
        local pos = getPosition(child)
        if pos then
            return pos
        end
    end
    
    return nil
end

local function getObjectType(instance)
    local success, attr = pcall(function()
        return instance:GetAttribute("InteractionType")
    end)
    
    if success and attr then
        return attr
    end
    
    return nil
end

local function parseCurrencyAmount(name)
    local amount = name:match("%d+")
    if amount then
        return tonumber(amount)
    end
    return nil
end

local function isMob(name)
    for _, mob in ipairs(trackedMobs) do
        if name == mob then return true end
    end
    return false
end

-- Создание ESP для объекта
local function createESPForObject(obj, objType)
    if espObjects[obj] then
        return false
    end
    
    local color = Color3.fromRGB(255, 255, 255)
    local displayName = obj.Name
    
    if objType == "KeyCard" then
        color = Color3.fromRGB(0, 255, 0)
    elseif objType == "InnerKeyCard" then
        color = Color3.fromRGB(0, 200, 0)
    elseif objType == "RidgeKeyCard" then
        color = Color3.fromRGB(0, 150, 0)
    elseif objType == "PasswordPaper" then
        color = Color3.fromRGB(255, 200, 0)
        displayName = "Password"
    elseif objType == "CurrencyBase" then
        color = Color3.fromRGB(255, 215, 0)
        local amount = parseCurrencyAmount(obj.Name)
        if amount then
            displayName = "$" .. amount
        else
            displayName = "Currency"
        end
    elseif objType == "ItemBase" then
        color = Color3.fromRGB(100, 200, 255)
        displayName = obj.Name
    end
    
    local text = Drawing.new("Text")
    text.Text = displayName
    text.Color = color
    text.Size = 16
    text.Font = Drawing.Fonts.SystemBold
    text.Outline = true
    text.Center = true
    text.Visible = true
    
    espObjects[obj] = {
        text = text,
        objType = objType,
        lastSeen = tick()
    }
    
    return true
end

local function removeESPForObject(obj)
    if espObjects[obj] then
        if espObjects[obj].text then
            espObjects[obj].text:Remove()
        end
        espObjects[obj] = nil
    end
end

-- Проверка, должен ли объект отображаться с учетом настроек
local function shouldShowObject(objType)
    if objType == "KeyCard" or objType == "InnerKeyCard" or objType == "RidgeKeyCard" or objType == "PasswordPaper" then
        return ESP.Settings.KeycardESP
    elseif objType == "CurrencyBase" then
        return ESP.Settings.CurrencyESP
    elseif objType == "ItemBase" then
        return ESP.Settings.ItemsESP
    end
    return false
end

-- Обновление всех ESP объектов
local function updateAllESP()
    local player = game.Players.LocalPlayer
    local hrp = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local playerPos = hrp and hrp.Position or nil
    
    for obj, espData in pairs(espObjects) do
        if obj and obj.Parent and not isMob(obj.Name) then -- Игнорируем мобов
            local currentType = getObjectType(obj)
            
            -- Проверяем, должен ли объект отображаться
            local shouldShow = shouldShowObject(currentType)
            
            if not shouldShow then
                -- Если объект не должен отображаться, удаляем его ESP
                removeESPForObject(obj)
            elseif currentType ~= espData.objType then
                -- Если тип изменился, обновляем
                removeESPForObject(obj)
                if shouldShowObject(currentType) then
                    createESPForObject(obj, currentType)
                end
            else
                -- Обновляем текст для динамических объектов
                if espData.objType == "CurrencyBase" then
                    local amount = parseCurrencyAmount(obj.Name)
                    if amount then
                        espData.text.Text = "$" .. amount
                    end
                elseif espData.objType == "ItemBase" then
                    espData.text.Text = obj.Name
                end
                
                local pos = getPosition(obj)
                
                if pos and playerPos then
                    -- Проверка дистанции
                    local dist = (pos - playerPos).Magnitude
                    if dist <= ESP.Settings.MaxDistance then
                        local screenPos, onScreen = WorldToScreen(pos)
                        
                        if onScreen and screenPos.X > -500 and screenPos.X < 5000 and screenPos.Y > -500 and screenPos.Y < 5000 then
                            espData.text.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                            espData.text.Visible = true
                            espData.lastSeen = tick()
                        else
                            espData.text.Visible = false
                        end
                    else
                        espData.text.Visible = false
                    end
                else
                    espData.text.Visible = false
                end
            end
        else
            -- Объект больше не существует или это моб
            removeESPForObject(obj)
        end
    end
end

-- Функция для ESP дверей (отдельная логика)
local doorESP = {}

local function updateDoorESP()
    if not ESP.Settings.DoorESP then
        -- Очищаем ESP дверей если выключено
        for obj, text in pairs(doorESP) do
            if text then
                text:Remove()
            end
        end
        doorESP = {}
        return
    end
    
    local player = game.Players.LocalPlayer
    local hrp = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local playerPos = hrp and hrp.Position or nil
    
    local gameplay = workspace:FindFirstChild("GameplayFolder")
    if not gameplay then return end
    
    local rooms = gameplay:FindFirstChild("Rooms")
    if not rooms then return end
    
    local currentDoors = {}
    
    for _, room in ipairs(rooms:GetChildren()) do
        local exits = room:FindFirstChild("Exits")
        if exits then
            for _, door in ipairs(exits:GetChildren()) do
                local part = door:IsA("BasePart") and door or door:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    currentDoors[part] = true
                    
                    if not doorESP[part] then
                        -- Создаем ESP для двери
                        local text = Drawing.new("Text")
                        text.Text = "DOOR"
                        text.Color = Color3.fromRGB(255, 165, 0)
                        text.Size = 16
                        text.Font = Drawing.Fonts.SystemBold
                        text.Outline = true
                        text.Center = true
                        text.Visible = true
                        doorESP[part] = text
                    end
                    
                    -- Обновляем позицию
                    if playerPos then
                        local dist = (part.Position - playerPos).Magnitude
                        if dist <= ESP.Settings.MaxDistance then
                            local screenPos, onScreen = WorldToScreen(part.Position)
                            if onScreen then
                                doorESP[part].Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                                doorESP[part].Visible = true
                            else
                                doorESP[part].Visible = false
                            end
                        else
                            doorESP[part].Visible = false
                        end
                    end
                end
            end
        end
    end
    
    -- Удаляем ESP для несуществующих дверей
    for obj, text in pairs(doorESP) do
        if not currentDoors[obj] then
            text:Remove()
            doorESP[obj] = nil
        end
    end
end

-- Функция для принудительного сканирования (вызывается из pressure.lua)
function ESP.ForceRescan()
    -- Очищаем существующие ESP объекты
    for obj, espData in pairs(espObjects) do
        if espData.text then
            espData.text:Remove()
        end
    end
    espObjects = {}
    
    -- Сканируем заново
    local gameplayFolder = workspace:FindFirstChild("GameplayFolder")
    if not gameplayFolder then return end
    
    local rooms = gameplayFolder:FindFirstChild("Rooms")
    if not rooms then return end
    
    for _, room in ipairs(rooms:GetChildren()) do
        local descendants = room:GetDescendants()
        for _, obj in ipairs(descendants) do
            local objType = getObjectType(obj)
            if objType and shouldShowObject(objType) then
                createESPForObject(obj, objType)
            end
        end
    end
end

-- Публичные функции для управления ESP
function ESP.StartKeycard()
    ESP.Settings.KeycardESP = true
    ESP.ForceRescan() -- Сразу сканируем при включении
end

function ESP.StopKeycard()
    ESP.Settings.KeycardESP = false
    -- Очистка произойдет автоматически в updateAllESP
end

function ESP.StartItems()
    ESP.Settings.ItemsESP = true
    ESP.ForceRescan()
end

function ESP.StopItems()
    ESP.Settings.ItemsESP = false
end

function ESP.StartCurrency()
    ESP.Settings.CurrencyESP = true
    ESP.ForceRescan()
end

function ESP.StopCurrency()
    ESP.Settings.CurrencyESP = false
end

function ESP.StartDoors()
    ESP.Settings.DoorESP = true
end

function ESP.StopDoors()
    ESP.Settings.DoorESP = false
end

function ESP.SetMaxDistance(distance)
    ESP.Settings.MaxDistance = math.max(25, math.floor(distance))
end

-- Основной цикл обновления (только отрисовка, без авто-сканирования)
function ESP.Start()
    spawn(function()
        while true do
            -- Обновляем обычные ESP объекты
            updateAllESP()
            
            -- Обновляем ESP дверей
            updateDoorESP()
            
            task.wait(0.03)
        end
    end)
    
    -- Первоначальное сканирование
    ESP.ForceRescan()
end

-- Запускаем ESP при загрузке модуля
ESP.Start()

return ESP
