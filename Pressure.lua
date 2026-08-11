-- PressureRecode by RATHUB | Matcha

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local _p = "0_"   -- UI widget id prefix (set by buildUI); declared early so all loops can read it

-- ===================== SETTINGS =====================
Settings = {
    keycardESPEnabled   = false,
    keycardTypes        = { Normal=true, Inner=true, Ridge=true, Password=true },
    doorESPEnabled      = false,
    fakeDoorESPEnabled  = false,
    itemsESPEnabled     = false,
    currencyESPEnabled  = false,
    currencyRichEnabled = false,
    neostykESPEnabled   = false,
    lockerESPEnabled    = false,
    lockerDistEnabled   = true,
    lockerDist          = 80,
    batteryESPEnabled   = false,
    leverESPEnabled     = false,
    trapESPEnabled      = false,
    oxygenESPEnabled    = false,
    mobsESPEnabled      = false,
    mobsESPList = {
        Angler=true, Blitz=true, Pinkie=true, Pandemonium=true,
        Froger=true, Chainsmoker=true, A60=true, Harbinger=true,
        Painter=true, Bleach=true, NoGood=true, WitchingHour=true,
        A200=true, Anglemonium=true, Sebastian=true,
        Pinkimonium=true, Frogermonium=true, Blitzmonium=true, Blitzemonium=true,
        Pandesmoker=true, DiVineRoot=true
    },
    autoRescanEnabled = true,
    rescanInterval    = 5,
    useDistanceLimit  = false,
    distanceFrom      = 0,
    distanceTo        = 1500,
    autoHideEnabled   = false,
    perfMode          = "Mid",
    lang              = "EN",
    espLimitEnabled   = false,
    espLimit          = 200,
    showKickTimer     = false,
    -- display options
    showLabel  = true,
    showDot    = true,
    showDist   = false,
    showBox2d  = false,
    showBox3d  = false,
    -- HUD options
    hudEnabled = false,
    hudLayout  = "Vertical",
    hudSign    = true,
}

-- ===================== HUD LIVE DATA =====================
HUDData = {
    enemy=nil, enemyTier=nil,
    items=0, currencies=0, currencyTotal=0, maxCurrency=0, neostyk=0, password=nil,
}

-- ===================== LOCALIZATION =====================
local L = {
    EN = {
        tab="Pressure", stuffESP="Stuff ESP", entityESP="Entity ESP",
        exploits="Exploits", display="Display", config="Config", misc="Misc",
        keycardESP="Keycard ESP", doorESP="Door ESP", fakeDoorESP="Fake Door ESP",
        itemESP="Item ESP", neostykESP="Neostyk ESP", lockerESP="Locker ESP",
        batteryESP="Battery ESP", leverESP="Lever ESP", trapESP="Trap ESP",
        oxygenESP="Oxygen ESP", currencyESP="Currency ESP", richOnly="  Rich (>=$25)",
        mobESP="Mob ESP", distLimit="Distance limit", distFrom="  From",
        distTo="  To", forceRescan="Force rescan", debugScan="Debug scan",
        showName="Show name", showDist="Show distance", showDot="Show dot",
        show2dBox="Show 2D box", show3dBox="Show 3D box", autoHide="AutoHide",
        autoHideTip="Teleports to Y+1000 when a mob appears.",
        saveConfig="Save config", loadConfig="Load config",
        configTip="Config auto-loads on script start.",
        perfMode="Performance", language="Language",
        espLimit="ESP limit", espLimitEnable="Enable ESP limit",
        showKickTimer="Show locker kick timer",
        kickTimerPrefix="Kick in: ",
        lockerDist="  Locker range", lockerDistEnable="  Limit locker range",
        hud="HUD", hudLayout="HUD layout", hudSign="Mob warning sign",
        currentEnemy="Current Enemy", noEnemy="Here still no any enemy",
        itemsHud="Items", itemsFound="Items found", countHud="Count",
        assetsHud="Data-Assets", modeHud="Mode:", richHud="Rich", defaultHud="Default",
        noRich="No rich values", currencyHud="Currency", codeHud="Code",
        neostykHud="NEOSTYK", passHud="PASSWORDPAPER",
        passwordCodeHud="Password Code", noPassword="No password paper",
        tierDanger="TIER DANGER",
    },
    RU = {
        tab="Давление", stuffESP="Предметы ESP", entityESP="Сущности ESP",
        exploits="Эксплойты", display="Отображение", config="Конфиг", misc="Прочее",
        keycardESP="Карточки ESP", doorESP="Двери ESP", fakeDoorESP="Ложные двери ESP",
        itemESP="Предметы ESP", neostykESP="Неостык ESP", lockerESP="Шкафы ESP",
        batteryESP="Батарейки ESP", leverESP="Рычаги ESP", trapESP="Ловушки ESP",
        oxygenESP="Кислород ESP", currencyESP="Валюта ESP", richOnly="  Только богатые (>=$25)",
        mobESP="Мобы ESP", distLimit="Лимит дистанции", distFrom="  От",
        distTo="  До", forceRescan="Принудительный пересканировать", debugScan="Дебаг сканирование",
        showName="Показать имя", showDist="Показать дистанцию", showDot="Показать точку",
        show2dBox="Показать 2D бокс", show3dBox="Показать 3D бокс", autoHide="АвтоСкрытие",
        autoHideTip="Телепортирует на Y+1000 при появлении моба.",
        saveConfig="Сохранить конфиг", loadConfig="Загрузить конфиг",
        configTip="Конфиг загружается автоматически при старте.",
        perfMode="Производительность", language="Язык",
        espLimit="Лимит ESP", espLimitEnable="Включить лимит ESP",
        showKickTimer="Таймер выброса из шкафа",
        kickTimerPrefix="Выброс через: ",
        lockerDist="  Радиус шкафов", lockerDistEnable="  Лимит радиуса шкафов",
        hud="HUD", hudLayout="Раскладка HUD", hudSign="Знак предупреждения о мобах",
        currentEnemy="Текущий враг", noEnemy="Пока врагов нет",
        itemsHud="Предметы", itemsFound="Найдено предметов", countHud="Кол-во",
        assetsHud="Дата-ассеты", modeHud="Режим:", richHud="Богатый", defaultHud="Обычный",
        noRich="Богатых нет", currencyHud="Валюта", codeHud="Код",
        neostykHud="NEOSTYK", passHud="PASSWORDPAPER",
        passwordCodeHud="Код пароля", noPassword="Пароля нет",
        tierDanger="УРОВЕНЬ ОПАСНОСТИ",
    },
}
local function T(key) return (L[Settings.lang] or L.EN)[key] or key end

-- ===================== PERF INTERVALS =====================
local PERF = {
    Low   = { render=1/15, scan=2,   livePos=false, rescan=10 },
    Mid   = { render=1/60, scan=1,   livePos=false, rescan=5  },
    High  = { render=0,    scan=0.5, livePos=true,  rescan=2  },
    Ultra = { render=0,    scan=0.25,livePos=true,  rescan=1  },
}
local PERF_NAMES = { "Low", "Mid", "High", "Ultra" }
local function getPerfInterval()  return (PERF[Settings.perfMode] or PERF.Mid).render  end
local function getScanInterval()  return (PERF[Settings.perfMode] or PERF.Mid).scan    end
local function getLivePos()       return (PERF[Settings.perfMode] or PERF.Mid).livePos end
local function getRescanInterval() return (PERF[Settings.perfMode] or PERF.Mid).rescan end

-- ===================== RARITY =====================
local MOB_COMMON  = { Angler=true, Froger=true, Blitz=true, Pinkie=true, Chainsmoker=true }
local MOB_RARE    = { Pandemonium=true, A60=true, A200=true, Bleach=true }

local function getMobColor(name)
    local simple = name:gsub("Ridge","")
    if simple == "Saboterousrusrer" then simple = "Sebastian" end
    if MOB_COMMON[simple] then return Color3.fromRGB(255,80,80) end
    if MOB_RARE[simple]   then return Color3.fromHex("#906bff") end
    return Color3.fromHex("#ffcc00")
end

-- ===================== ESP TABLES =====================
espObjects      = {}   -- key = tostring(obj.Address)
espDoorObjects  = {}   -- key = exit:GetFullName()
espFakeDoorObjs = {}   -- key = tostring(obj.Address)
espMobObjects   = {}   -- key = tostring(mob.Address)

-- ===================== DRAWING HELPERS =====================
local function makeText(label, color, size)
    local t = Drawing.new("Text")
    t.Text    = label
    t.Color   = color
    t.Size    = size or 16
    t.Font    = Drawing.Fonts.SystemBold
    t.Outline = true
    t.Center  = true
    t.Visible = false
    return t
end

local function makeDot(color)
    local c = Drawing.new("Circle")
    c.Radius  = 4
    c.Color   = color
    c.Filled  = true
    c.Visible = false
    return c
end

local function makeBox2d(color)
    local b = Drawing.new("Square")
    b.Color     = color
    b.Filled    = false
    b.Thickness = 1
    b.Visible   = false
    return b
end

local function makeBox3d(color)
    local lines = {}
    for i = 1, 12 do
        local l = Drawing.new("Line")
        l.Color     = color
        l.Thickness = 1
        l.Visible   = false
        lines[i] = l
    end
    return lines
end

local function removeBox3d(lines)
    if lines then
        for _, l in ipairs(lines) do l:Remove() end
    end
end

local function updateBox3d(lines, pos, playerPos, color, visible, halfSize)
    if not lines then return end
    if not visible or not pos or not playerPos then
        for _, l in ipairs(lines) do l.Visible = false end
        return
    end
    local half = halfSize or 2
    local corners3d = {
        pos + Vector3.new(-half,  half, -half),
        pos + Vector3.new( half,  half, -half),
        pos + Vector3.new( half,  half,  half),
        pos + Vector3.new(-half,  half,  half),
        pos + Vector3.new(-half, -half, -half),
        pos + Vector3.new( half, -half, -half),
        pos + Vector3.new( half, -half,  half),
        pos + Vector3.new(-half, -half,  half),
    }
    local s = {}
    local anyOn = false
    for i, c3 in ipairs(corners3d) do
        local sp, on = WorldToScreen(c3)
        s[i] = {sp=sp, on=on}
        if on then anyOn = true end
    end
    -- 12 edges of a cube
    local edges = {
        {1,2},{2,3},{3,4},{4,1},  -- top face
        {5,6},{6,7},{7,8},{8,5},  -- bottom face
        {1,5},{2,6},{3,7},{4,8},  -- verticals
    }
    for i, e in ipairs(edges) do
        local a, b = s[e[1]], s[e[2]]
        if a.on and b.on then
            lines[i].From    = a.sp
            lines[i].To      = b.sp
            lines[i].Color   = color
            lines[i].Visible = true
        else
            lines[i].Visible = false
        end
    end
end

local function getPosition(instance)
    local ok, pos = pcall(function() return instance.Position end)
    if ok and pos then return pos end
    local ok2, children = pcall(function() return instance:GetChildren() end)
    if ok2 then
        for _, child in ipairs(children) do
            local p = getPosition(child)
            if p then return p end
        end
    end
    return nil
end

local function getModelHalfSize(instance)
    local ok, parts = pcall(function() return instance:GetDescendants() end)
    if not ok then return 2 end
    local minX, minY, minZ =  math.huge,  math.huge,  math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
    local found = false
    for _, p in ipairs(parts) do
        local os, sz  = pcall(function() return p.Size     end)
        local op, pos = pcall(function() return p.Position end)
        if os and op and sz and pos then
            found = true
            minX = math.min(minX, pos.X - sz.X/2); maxX = math.max(maxX, pos.X + sz.X/2)
            minY = math.min(minY, pos.Y - sz.Y/2); maxY = math.max(maxY, pos.Y + sz.Y/2)
            minZ = math.min(minZ, pos.Z - sz.Z/2); maxZ = math.max(maxZ, pos.Z + sz.Z/2)
        end
    end
    if not found then return 2 end
    return math.max((maxX-minX)/2, (maxY-minY)/2, (maxZ-minZ)/2)
end

local function parseCurrencyAmount(name)
    local n = name:match("%d+")
    return n and tonumber(n) or nil
end

-- ===================== KEYCARD NAME MAP =====================
local KEYCARD_NAMES = {
    NormalKeyCard = "Normal",
    InnerKeyCard  = "Inner",
    RidgeKeyCard  = "Ridge",
    PasswordPaper = "Password",
}
local KEYCARD_COLORS = {
    NormalKeyCard = Color3.fromRGB(0,255,0),
    InnerKeyCard  = Color3.fromRGB(28,57,187),
    RidgeKeyCard  = Color3.fromRGB(169,169,169),
    PasswordPaper = Color3.fromHex("#d5d1f0"),
}

local function getPasswordCode(obj)
    local ok, code = pcall(function() return obj:FindFirstChild("Code") end)
    if not (ok and code) then return nil end
    local ok2, gui = pcall(function() return code:FindFirstChild("SurfaceGui") end)
    if not (ok2 and gui) then return nil end
    local ok3, lbl = pcall(function() return gui:FindFirstChild("TextLabel") end)
    if not (ok3 and lbl) then return nil end
    local ok4, txt = pcall(function() return lbl.Text end)
    if ok4 and txt and txt ~= "" then return txt end
    return nil
end

-- ===================== CREATE ESP =====================
local function createKeycardESP(obj, modelName)
    local addr = tostring(obj.Address)
    if espObjects[addr] then return end
    local label
    if modelName == "PasswordPaper" then
        local code = getPasswordCode(obj)
        label = code and ("Password: "..code) or "Password"
    else
        label = modelName:gsub("KeyCard"," Keycard")
    end
    local color = KEYCARD_COLORS[modelName] or Color3.fromRGB(255,255,255)
    local pos = getPosition(obj)
    local half = getModelHalfSize(obj)
    espObjects[addr] = {
        text=makeText(label,color,16), dot=makeDot(color),
        box2d=makeBox2d(color), box3d=makeBox3d(color),
        obj=obj, kind="keycard", modelName=modelName, cachedPos=pos,
        color=color, halfSize=half, baseLabel=label
    }
end

local function createCurrencyESP(obj)
    local addr = tostring(obj.Address)
    if espObjects[addr] then return end
    local amount = parseCurrencyAmount(obj.Name)
    local label = amount and ("$"..amount) or "Currency"
    local color = Color3.fromRGB(60,179,113)
    local pos = getPosition(obj)
    local half = getModelHalfSize(obj)
    espObjects[addr] = {
        text=makeText(label,color,16), dot=makeDot(color),
        box2d=makeBox2d(color), box3d=makeBox3d(color),
        obj=obj, kind="currency", cachedPos=pos,
        color=color, halfSize=half, baseLabel=label
    }
end

local function createItemESP(obj)
    local addr = tostring(obj.Address)
    if espObjects[addr] then return end
    local color = Color3.fromRGB(135,206,250)
    local pos = getPosition(obj)
    local half = getModelHalfSize(obj)
    local label = obj.Name
    espObjects[addr] = {
        text=makeText(label,color,16), dot=makeDot(color),
        box2d=makeBox2d(color), box3d=makeBox3d(color),
        obj=obj, kind="item", cachedPos=pos,
        color=color, halfSize=half, baseLabel=label
    }
end

local function createGenericESP(obj, kind, label, color)
    local addr = tostring(obj.Address)
    if espObjects[addr] then return end
    local pos = getPosition(obj)
    local half = getModelHalfSize(obj)
    local has3d = kind ~= "locker"
    espObjects[addr] = {
        text=makeText(label,color,16), dot=makeDot(color),
        box2d=makeBox2d(color), box3d=has3d and makeBox3d(color) or nil,
        obj=obj, kind=kind, cachedPos=pos,
        color=color, halfSize=half, baseLabel=label
    }
end

local function createDoorESP(part, key)
    if espDoorObjects[key] then return end
    local color = Color3.fromRGB(255,165,0)
    local ok, pos = pcall(function() return part.Position end)
    espDoorObjects[key] = {
        text=makeText("Door",color,16), dot=makeDot(color),
        part=part, cachedPos=ok and pos or nil,
        color=color, baseLabel="Door"
    }
end

local function createMobESP(mob, displayName)
    local addr = tostring(mob.Address)
    if espMobObjects[addr] then return end
    local color = getMobColor(displayName)
    espMobObjects[addr] = {
        text=makeText(displayName,color,18), dot=makeDot(color),
        obj=mob, color=color, baseLabel=displayName
    }
end

local function createFakeDoorESP(obj)
    local addr = tostring(obj.Address)
    if espFakeDoorObjs[addr] then return end
    local color = Color3.fromRGB(255,50,50)
    local label = obj.Name
    local pos = nil
    -- look for RootPosition part directly in obj
    local rp = obj:FindFirstChild("RootPosition")
    if rp then
        local ok, p = pcall(function() return rp.Position end)
        if ok and p then pos = p end
    end
    -- fallback: TricksterDoor.RootPosition
    if not pos then
        local door = obj:FindFirstChild("TricksterDoor")
        if door then
            local rp2 = door:FindFirstChild("RootPosition")
            if rp2 then
                local ok, p = pcall(function() return rp2.Position end)
                if ok and p then pos = p end
            end
        end
    end
    if not pos then pos = getPosition(obj) end
    espFakeDoorObjs[addr] = {
        text=makeText(label,color,16), dot=makeDot(color),
        obj=obj, cachedPos=pos, color=color, baseLabel=label
    }
end

local function removeFakeDoorESP(addr)
    local d = espFakeDoorObjs[addr]
    if d then
        if d.text then d.text:Remove() end
        if d.dot  then d.dot:Remove()  end
        espFakeDoorObjs[addr] = nil
    end
end
-- ===================== REMOVE ESP =====================
local function removeESP(addr)
    local d = espObjects[addr]
    if d then
        if d.text then d.text:Remove() end
        if d.dot  then d.dot:Remove()  end
        if d.box2d then d.box2d:Remove() end
        removeBox3d(d.box3d)
        espObjects[addr] = nil
    end
end

local function removeDoorESP(key)
    local d = espDoorObjects[key]
    if d then
        if d.text then d.text:Remove() end
        if d.dot  then d.dot:Remove()  end
        espDoorObjects[key] = nil
    end
end

local function removeMobESP(addr)
    local d = espMobObjects[addr]
    if d then
        if d.text then d.text:Remove() end
        if d.dot  then d.dot:Remove()  end
        espMobObjects[addr] = nil
    end
end

local function clearAllESP()
    for addr,_ in pairs(espObjects)      do removeESP(addr)         end
    for key,_  in pairs(espDoorObjects)  do removeDoorESP(key)      end
    for addr,_ in pairs(espFakeDoorObjs) do removeFakeDoorESP(addr) end
    for addr,_ in pairs(espMobObjects)   do removeMobESP(addr)      end
end

-- ===================== SCAN =====================
local lastScanTime = 0

function scanRooms()
    local gf = workspace:FindFirstChild("GameplayFolder")
    local rooms = gf and gf:FindFirstChild("Rooms")
    if not rooms then return end
    HUDData.items = 0
    HUDData.currencies = 0
    HUDData.currencyTotal = 0
    HUDData.maxCurrency = 0
    HUDData.neostyk = 0
    HUDData.password = nil
    local all = rooms:GetDescendants()
    for _, obj in ipairs(all) do
        local okN, name = pcall(function() return obj.Name end)
        if not (okN and name) then continue end

        if KEYCARD_NAMES[name] then
            local kcType = KEYCARD_NAMES[name]
            if kcType == "Password" and not HUDData.password then
                HUDData.password = getPasswordCode(obj)
            end
            if Settings.keycardESPEnabled and Settings.keycardTypes[kcType] then
                pcall(createKeycardESP, obj, name)
            end
        end

        if Settings.fakeDoorESPEnabled and name == "Trickster" then
            pcall(createFakeDoorESP, obj)
        end

        -- Currency by name pattern
        if name:sub(1,8) == "Currency" then
            local okC, cls = pcall(function() return obj.ClassName end)
            if okC and cls == "Model" then
                local amount = parseCurrencyAmount(name)
                HUDData.currencies = HUDData.currencies + 1
                HUDData.currencyTotal = HUDData.currencyTotal + (amount or 0)
                if amount and amount > HUDData.maxCurrency then HUDData.maxCurrency = amount end
                if Settings.currencyESPEnabled then
                    local rich = (not Settings.currencyRichEnabled) or (amount and amount >= 25)
                    if rich then pcall(createCurrencyESP, obj) end
                end
            end
        end

        -- Locker by name
        if Settings.lockerESPEnabled and name == "Locker" then
            local okC, cls = pcall(function() return obj.ClassName end)
            if okC and cls == "Model" then
                pcall(createGenericESP, obj, "locker", "Locker", Color3.fromRGB(180,140,80))
            end
        end

        local okA, attr = pcall(function() return obj:GetAttribute("InteractionType") end)
        if okA and attr then
            if attr == "ItemBase" then
                HUDData.items = HUDData.items + 1
            elseif attr == "NeoStykPickup" then
                HUDData.neostyk = HUDData.neostyk + 1
            end
            if Settings.itemsESPEnabled and attr == "ItemBase" then
                pcall(createGenericESP, obj, "item", name, Color3.fromRGB(135,206,250))
            elseif Settings.neostykESPEnabled and attr == "NeoStykPickup" then
                pcall(createGenericESP, obj, "neostyk", name, Color3.fromRGB(255,100,100))
            elseif Settings.batteryESPEnabled and attr == "Battery" then
                pcall(createGenericESP, obj, "battery", "Battery", Color3.fromRGB(255,255,0))
            elseif Settings.leverESPEnabled and attr == "Lever" then
                pcall(createGenericESP, obj, "lever", "Lever", Color3.fromRGB(200,100,255))
            elseif Settings.trapESPEnabled and (attr == "Tripwire" or attr == "Landmine") then
                pcall(createGenericESP, obj, "trap", attr, Color3.fromRGB(255,50,50))
            elseif Settings.oxygenESPEnabled and attr == "OxygenTank" then
                pcall(createGenericESP, obj, "oxygen", "Oxygen", Color3.fromRGB(100,200,255))
            end
        end
    end
end

local _rescanPending = false
function ForceRescanESP()
    if _rescanPending then return end
    _rescanPending = true
    task.defer(function()
        _rescanPending = false
        for addr,_ in pairs(espObjects)      do removeESP(addr)         end
        for addr,_ in pairs(espFakeDoorObjs) do removeFakeDoorESP(addr) end
        scanRooms()
        if Settings.doorESPEnabled then
            lastDoorScan = 0
            scanDoors()
        end
    end)
end

-- ===================== DOOR SCANNER =====================
local lastDoorScan = 0
function scanDoors()
    if not Settings.doorESPEnabled then
        for k,_ in pairs(espDoorObjects) do removeDoorESP(k) end
        return
    end
    local now = tick()
    if now - lastDoorScan < 2 then return end
    lastDoorScan = now

    local gf = workspace:FindFirstChild("GameplayFolder")
    local rooms = gf and gf:FindFirstChild("Rooms")
    if not rooms then return end

    local found = {}
    for _, room in ipairs(rooms:GetChildren()) do
        local exits = room:FindFirstChild("Exits")
        if exits then
            for _, exit in ipairs(exits:GetChildren()) do
                local part = exit:IsA("BasePart") and exit or exit:FindFirstChildWhichIsA("BasePart")
                if part then
                    local key = exit:GetFullName()
                    found[key] = part
                    if not espDoorObjects[key] then createDoorESP(part, key) end
                end
            end
        end
    end
    for k,_ in pairs(espDoorObjects) do
        if not found[k] then removeDoorESP(k) end
    end
end

-- Maps raw instance names to readable display names (used by ESP, HUD and sign).
-- Must be defined before scanMobs and hudMobInfo.
local function mobDisplayName(name)
    local simple = name:gsub("Ridge","")
    if simple == "StatueRoot" then return "Statue" end
    if simple == "Saboterousrusrer" then return "Sebastian" end
    if simple == "DiVineRoot" then return "Wall Dweller" end
    return simple
end

-- ===================== MOB SCANNER =====================
function scanMobs()
    if not Settings.mobsESPEnabled then
        for addr,_ in pairs(espMobObjects) do removeMobESP(addr) end
        return
    end

    local found = {}
    -- workspace direct children
    for _, obj in ipairs(workspace:GetChildren()) do
        local ok, name = pcall(function() return obj.Name end)
        if ok and name and Settings.mobsESPList[name] then
            local addr = tostring(obj.Address)
            found[addr] = true
            if not espMobObjects[addr] then createMobESP(obj, name) end
        end
    end
    -- Painter and Sebastian inside rooms
    local gf = workspace:FindFirstChild("GameplayFolder")
    local rooms = gf and gf:FindFirstChild("Rooms")
    if rooms then
        for _, room in ipairs(rooms:GetChildren()) do
            if Settings.mobsESPList.Painter then
                local p = room:FindFirstChild("Painter")
                if p then
                    local addr = tostring(p.Address)
                    found[addr] = true
                    if not espMobObjects[addr] then createMobESP(p, "Painter") end
                end
            end
            if Settings.mobsESPList.Sebastian then
                local s = room:FindFirstChild("Saboterousrusrer")
                if s then
                    local addr = tostring(s.Address)
                    found[addr] = true
                    if not espMobObjects[addr] then createMobESP(s, "Sebastian") end
                end
            end
        end
    end
    -- mobs under GameplayFolder.Monsters (e.g. DiVineRoot / Wall Dweller)
    local gfMon = workspace:FindFirstChild("GameplayFolder")
    local monsters = gfMon and gfMon:FindFirstChild("Monsters")
    if monsters then
        for _, obj in ipairs(monsters:GetChildren()) do
            local ok, name = pcall(function() return obj.Name end)
            if ok and name and Settings.mobsESPList[name] then
                local addr = tostring(obj.Address)
                found[addr] = true
                if not espMobObjects[addr] then
                    createMobESP(obj, mobDisplayName(name))
                end
            end
        end
    end
    -- remove gone mobs
    for addr,_ in pairs(espMobObjects) do
        if not found[addr] then removeMobESP(addr) end
    end
end

-- ===================== UPDATE POSITIONS =====================
local function applyStatic(data, pos, playerPos)
    if not pos then
        if data.text  then data.text.Visible  = false end
        if data.dot   then data.dot.Visible   = false end
        if data.box2d then data.box2d.Visible = false end
        updateBox3d(data.box3d, nil, nil, nil, false)
        return
    end
    local sp, onScreen = WorldToScreen(pos)
    if onScreen then
        local dist = playerPos and math.floor((pos - playerPos).Magnitude) or 0
        local col = data.color or Color3.new(1,1,1)
        if data.dot then
            data.dot.Position = Vector2.new(sp.X, sp.Y)
            data.dot.Visible  = Settings.showDot
        end
        if data.text then
            local lbl = data.baseLabel or (data.text.Text)
            if Settings.showDist then
                data.text.Text = lbl .. " [" .. dist .. "]"
            else
                data.text.Text = lbl
            end
            data.text.Position = Vector2.new(sp.X, sp.Y)
            data.text.Visible  = Settings.showLabel
        end
        if data.box2d then
            local sz = math.clamp(3000 / (dist + 1), 6, 80)
            data.box2d.Size     = Vector2.new(sz, sz)
            data.box2d.Position = Vector2.new(sp.X - sz/2, sp.Y - sz/2)
            data.box2d.Visible  = Settings.showBox2d
        end
        if data.box3d then
            updateBox3d(data.box3d, pos, playerPos, col, Settings.showBox3d, data.halfSize)
        end
    else
        if data.text  then data.text.Visible  = false end
        if data.dot   then data.dot.Visible   = false end
        if data.box2d then data.box2d.Visible = false end
        updateBox3d(data.box3d, nil, nil, nil, false)
    end
end

local _lastRender = 0
local _kickTimerText = nil

local function getKickTimerDrawing()
    if not _kickTimerText then
        _kickTimerText = Drawing.new("Text")
        _kickTimerText.Color   = Color3.fromRGB(255,80,80)
        _kickTimerText.Size    = 20
        _kickTimerText.Font    = Drawing.Fonts.SystemBold
        _kickTimerText.Outline = true
        _kickTimerText.Center  = true
        _kickTimerText.Visible = false
    end
    return _kickTimerText
end

local function updatePositions()
    local now = tick()
    local interval = getPerfInterval()
    if interval > 0 and (now - _lastRender) < interval then return end
    _lastRender = now

    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local playerPos = hrp and hrp.Position

    local function inRange(pos)
        if AutoHideSystem.isHiding then return true end
        if not Settings.useDistanceLimit or not playerPos or not pos then return true end
        local d = (pos - playerPos).Magnitude
        return d >= Settings.distanceFrom and d <= Settings.distanceTo
    end

    -- collect visible stuff ESP sorted by distance for limit
    local stuffVisible = {}
    for addr, data in pairs(espObjects) do
        local okP, hasParent = pcall(function() return data.obj and data.obj.Parent ~= nil end)
        if not (okP and hasParent) then removeESP(addr); continue end

        local enabled = false
        if     data.kind == "keycard"  then enabled = Settings.keycardESPEnabled
        elseif data.kind == "currency" then
            enabled = Settings.currencyESPEnabled
            if enabled and Settings.currencyRichEnabled then
                local _, amt = pcall(function() return parseCurrencyAmount(data.obj.Name) end)
                if amt and amt < 25 then enabled = false end
            end
        elseif data.kind == "item"     then enabled = Settings.itemsESPEnabled
        elseif data.kind == "neostyk"  then enabled = Settings.neostykESPEnabled
        elseif data.kind == "locker" then
            enabled = Settings.lockerESPEnabled
            if enabled and Settings.lockerDistEnabled and playerPos and data.cachedPos then
                enabled = (data.cachedPos - playerPos).Magnitude <= Settings.lockerDist
            end
        elseif data.kind == "battery"  then enabled = Settings.batteryESPEnabled
        elseif data.kind == "lever"    then enabled = Settings.leverESPEnabled
        elseif data.kind == "trap"     then enabled = Settings.trapESPEnabled
        elseif data.kind == "oxygen"   then enabled = Settings.oxygenESPEnabled
        end

        if not enabled then removeESP(addr); continue end

        -- in High mode, refresh position every frame for smooth movement
        if getLivePos() then
            local lp2 = getPosition(data.obj)
            if lp2 then data.cachedPos = lp2 end
        end
        local pos = data.cachedPos
        if not inRange(pos) then
            if data.text  then data.text.Visible  = false end
            if data.dot   then data.dot.Visible   = false end
            if data.box2d then data.box2d.Visible = false end
            updateBox3d(data.box3d, nil, nil, nil, false)
            continue
        end

        -- locker PlayerIn color
        if data.kind == "locker" then
            local ok, folder = pcall(function() return data.obj:FindFirstChild("Folder") end)
            if ok and folder then
                local ok2, pi = pcall(function() return folder:FindFirstChild("PlayerIn") end)
                local occupied = ok2 and pi and pi.Value
                local col = occupied and Color3.fromRGB(128,0,0) or Color3.fromRGB(180,140,80)
                data.color = col
                if data.text  then data.text.Color  = col end
                if data.dot   then data.dot.Color   = col end
                if data.box2d then data.box2d.Color = col end
            end
        end

        local dist = playerPos and pos and (pos - playerPos).Magnitude or 0
        stuffVisible[#stuffVisible+1] = {data=data, pos=pos, dist=dist, addr=addr}
    end

    -- sort by distance, apply limit
    table.sort(stuffVisible, function(a,b) return a.dist < b.dist end)
    local limit = Settings.espLimitEnabled and Settings.espLimit or math.huge
    for i, entry in ipairs(stuffVisible) do
        if i <= limit then
            applyStatic(entry.data, entry.pos, playerPos)
        else
            local d = entry.data
            if d.text  then d.text.Visible  = false end
            if d.dot   then d.dot.Visible   = false end
            if d.box2d then d.box2d.Visible = false end
            updateBox3d(d.box3d, nil, nil, nil, false)
        end
    end

    -- door ESP
    for key, data in pairs(espDoorObjects) do
        local okP, hasParent = pcall(function() return data.part and data.part.Parent ~= nil end)
        if not (okP and hasParent) then removeDoorESP(key); continue end
        if Settings.doorESPEnabled and inRange(data.cachedPos) then
            applyStatic(data, data.cachedPos, playerPos)
        else
            if data.text then data.text.Visible = false end
            if data.dot  then data.dot.Visible  = false end
        end
    end

    -- fake door ESP
    for addr, data in pairs(espFakeDoorObjs) do
        local okP, hasParent = pcall(function() return data.obj and data.obj.Parent ~= nil end)
        if not (okP and hasParent) then removeFakeDoorESP(addr); continue end
        if Settings.fakeDoorESPEnabled and inRange(data.cachedPos) then
            applyStatic(data, data.cachedPos, playerPos)
        else
            if data.text then data.text.Visible = false end
            if data.dot  then data.dot.Visible  = false end
        end
    end

    -- mob ESP
    for addr, data in pairs(espMobObjects) do
        local okP, hasParent = pcall(function() return data.obj and data.obj.Parent ~= nil end)
        if not (okP and hasParent) then removeMobESP(addr); continue end
        local pos = getPosition(data.obj)
        if pos and Settings.mobsESPEnabled and inRange(pos) then
            applyStatic(data, pos, playerPos)
        else
            if data.text then data.text.Visible = false end
            if data.dot  then data.dot.Visible  = false end
        end
    end

    -- locker kick timer
    local kt = getKickTimerDrawing()
    if Settings.showKickTimer and playerPos then
        local found = false
        for _, data in pairs(espObjects) do
            if data.kind == "locker" and data.cachedPos then
                local dist = (data.cachedPos - playerPos).Magnitude
                if dist < 8 then
                    local ok, folder = pcall(function() return data.obj:FindFirstChild("Folder") end)
                    if ok and folder then
                        local ok2, pi = pcall(function() return folder:FindFirstChild("PlayerIn") end)
                        if ok2 and pi and pi.Value then
                            local remaining = data.obj:GetAttribute("ClaustrophobiaStartTime") or 0
                            local cam = workspace.CurrentCamera
                            local cx = cam and cam.ViewportSize and cam.ViewportSize.X/2 or 960
                            local cy = cam and cam.ViewportSize and cam.ViewportSize.Y/2 or 540
                            kt.Text     = T("kickTimerPrefix") .. string.format("%.1f", math.max(0, remaining)) .. "s"
                            kt.Position = Vector2.new(cx, cy - 60)
                            kt.Visible  = true
                            found = true
                            break
                        end
                    end
                end
            end
        end
        if not found then kt.Visible = false end
    else
        kt.Visible = false
    end
end

-- ===================== MOB NOTIFICATIONS =====================
local detectedMobs = {}
local NOTIFY_MOBS = {
    "Angler","Blitz","Pinkie","Pandemonium","Froger","Chainsmoker",
    "RidgeAngler","RidgeBlitz","RidgePinkie","RidgePandemonium","RidgeFroger","RidgeChainsmoker",
    "A60","Harbinger","Bleach","WitchingHour","Anglemonium"
}
local NOTIFY_SET = {}
for _, n in ipairs(NOTIFY_MOBS) do NOTIFY_SET[n] = true end

function checkMobNotifications()
    local current = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        local ok, name = pcall(function() return obj.Name end)
        if ok and name and NOTIFY_SET[name] then
            current[name] = true
            if not detectedMobs[name] then
                detectedMobs[name] = true
                notify(name .. " spawned", "RATHUB", 4)
            end
        end
    end
    local gf = workspace:FindFirstChild("GameplayFolder")
    local rooms = gf and gf:FindFirstChild("Rooms")
    if rooms then
        for _, room in ipairs(rooms:GetChildren()) do
            if room:FindFirstChild("Painter") then
                current["__Painter__"] = true
                if not detectedMobs["__Painter__"] then
                    detectedMobs["__Painter__"] = true
                    notify("Painter spawned", "RATHUB", 4)
                end
            end
            if room:FindFirstChild("Saboterousrusrer") then
                current["__Sebastian__"] = true
                if not detectedMobs["__Sebastian__"] then
                    detectedMobs["__Sebastian__"] = true
                    notify("Sebastian spawned", "RATHUB", 4)
                end
            end
        end
    end
    for k,_ in pairs(detectedMobs) do
        if not current[k] then detectedMobs[k] = nil end
    end
end

-- ===================== HUD =====================
local HUD_RICH_THRESHOLD = 25

local HUD_RANK_ORDER = { ["S+"]=0, S=1, A=2, B=3, C=4, D=5 }
local HUD_RANK_RGB = {
    D    = Color3.fromRGB(107,114,128),
    C    = Color3.fromRGB(34,197,94),
    B    = Color3.fromRGB(59,130,246),
    A    = Color3.fromRGB(168,85,247),
    S    = Color3.fromRGB(8,145,178),
    ["S+"] = Color3.fromRGB(6,182,212),
}
local HUD_MOB_TIERS = {
    Angler="D", Statue="D",
    Froger="C", Blitz="C", NoGood="C",
    Pinkie="B", Chainsmoker="B",
    A60="A", A200="A", Bleach="A", DiVineRoot="A",
    Pandemonium="S", Anglemonium="S",
    Pinkimonium="S", Frogermonium="S", Blitzmonium="S", Blitzemonium="S", Pandesmoker="S",
    Harbinger="S+",
}

-- Only these names can ever be shown as "current enemy" / sign target
local HUD_MOB_NAMES = {}
for n in pairs(HUD_MOB_TIERS) do
    HUD_MOB_NAMES[n] = true
    HUD_MOB_NAMES["Ridge"..n] = true
end
HUD_MOB_NAMES["StatueRoot"] = true
HUD_MOB_NAMES["Saboterousrusrer"] = true
HUD_MOB_NAMES["DiVineRoot"] = true
HUD_MOB_NAMES["Painter"] = true

local HUD_COLORS = {
    bg      = Color3.fromRGB(5,  15,  28),
    panel   = Color3.fromRGB(5,  9,   18),
    accent  = Color3.fromRGB(8,  145, 178),
    accentL = Color3.fromRGB(34, 211, 238),
    muted   = Color3.fromRGB(74, 122, 133),
    dim     = Color3.fromRGB(30, 58,  69),
    text    = Color3.fromRGB(207,250,254),
    green   = Color3.fromRGB(163,230,53),
    purple  = Color3.fromRGB(129,140,248),
    yellow  = Color3.fromRGB(250,204,21),
    cyan    = Color3.fromRGB(103,232,249),
}

local function hudMobInfo(name)
    local simple = name:gsub("Ridge","")
    return mobDisplayName(name), HUD_MOB_TIERS[simple] or "?"
end

local function updateHUDData()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local ppos = hrp and hrp.Position
    local bestName, bestTier, bestOrd, bestDist = nil, nil, 99, math.huge

    local function consider(obj)
        local ok, name = pcall(function() return obj.Name end)
        if not (ok and name) then return end
        local displayName, tier = hudMobInfo(name)
        if not HUD_MOB_NAMES[name] and not HUD_MOB_NAMES[displayName] then return end
        local ord = HUD_RANK_ORDER[tier] or 99
        local pos = getPosition(obj)
        local dist = ppos and pos and (pos - ppos).Magnitude or 0
        if ord < bestOrd or (ord == bestOrd and dist < bestDist) then
            bestOrd, bestDist, bestName, bestTier = ord, dist, displayName, tier
        end
    end

    for _, obj in ipairs(workspace:GetChildren()) do consider(obj) end
    local gf = workspace:FindFirstChild("GameplayFolder")
    if gf then
        local monsters = gf:FindFirstChild("Monsters")
        if monsters then
            for _, obj in ipairs(monsters:GetChildren()) do consider(obj) end
        end
        local rooms = gf:FindFirstChild("Rooms")
        if rooms then
            for _, room in ipairs(rooms:GetChildren()) do
                local p = room:FindFirstChild("Painter")
                if p then consider(p) end
                local s = room:FindFirstChild("Saboterousrusrer")
                if s then consider(s) end
            end
        end
    end
    HUDData.enemy     = bestName
    HUDData.enemyTier = bestTier
end

-- ---- HUD rendering ----
local hudObjects = {}
local hudTexts   = {}
local hudRecolor = {}
local hudSignObjs    = {}
local hudSignVisible = false
local hudSignEnemy   = nil
local hudSignUntil   = 0

local function hudObj(t)
    local o = Drawing.new(t)
    table.insert(hudObjects, o)
    return o
end

local function hudDestroy()
    for _, o in ipairs(hudObjects) do
        pcall(function() o:Remove() end)
    end
    hudObjects = {}
    hudTexts   = {}
    hudRecolor = {}
    hudSignObjs    = {}
    hudSignVisible = false
    hudSignEnemy   = nil
end

local function hudPanel(x, y, w, h)
    local bg = hudObj("Square"); bg.Filled = true; bg.Color = HUD_COLORS.panel
    bg.Position = Vector2.new(x,y); bg.Size = Vector2.new(w,h)
    bg.Visible = true; bg.ZIndex = 20

    local fr = hudObj("Square"); fr.Filled = false; fr.Color = HUD_COLORS.accent
    fr.Transparency = 0.75; fr.Thickness = 1
    fr.Position = Vector2.new(x,y); fr.Size = Vector2.new(w,h)
    fr.Visible = true; fr.ZIndex = 21
end

local function hudAccentLine(x, y, w, col)
    local l = hudObj("Line"); l.From = Vector2.new(x,y); l.To = Vector2.new(x+w,y)
    l.Color = col or HUD_COLORS.accent; l.Thickness = 2; l.Visible = true; l.ZIndex = 22
end

local function hudDivider(x, y, w)
    local l = hudObj("Line"); l.From = Vector2.new(x,y); l.To = Vector2.new(x+w,y)
    l.Color = Color3.fromRGB(255,255,255); l.Transparency = 0.91; l.Thickness = 1
    l.Visible = true; l.ZIndex = 22
end

local function hudLabel(str, x, y, sz, col, center, font, z)
    local t = hudObj("Text"); t.Text = str; t.Color = col or HUD_COLORS.text; t.Size = sz or 12
    t.Font = font or Drawing.Fonts.SystemBold; t.Position = Vector2.new(x,y)
    t.Center = center or false; t.Outline = true; t.Visible = true; t.ZIndex = z or 25
    return t
end

local function hudSectionLbl(str, x, y)
    return hudLabel(str, x, y, 9, HUD_COLORS.muted, false, Drawing.Fonts.System, 25)
end

local function hudSet(id, str, col)
    local t = hudTexts[id]
    if not t then return end
    if str ~= nil then t.Text = str end
    if col ~= nil then t.Color = col end
end

local function hudBuildSign(SWx, SHy)
    local function so(t)
        local o = hudObj(t)
        table.insert(hudSignObjs, o)
        return o
    end
    local SGN_W, SGN_H = 200, 170
    local SGN_X, SGN_Y = SWx - SGN_W - 16, 50

    local bg = so("Square"); bg.Filled = true; bg.Color = HUD_COLORS.panel
    bg.Position = Vector2.new(SGN_X,SGN_Y); bg.Size = Vector2.new(SGN_W,SGN_H)
    bg.Visible = true; bg.ZIndex = 20

    local brd = so("Square"); brd.Filled = false; brd.Color = HUD_COLORS.accent; brd.Thickness = 2
    brd.Position = Vector2.new(SGN_X,SGN_Y); brd.Size = Vector2.new(SGN_W,SGN_H)
    brd.Visible = true; brd.ZIndex = 21
    table.insert(hudRecolor, brd)

    for _, y in ipairs({SGN_Y, SGN_Y+SGN_H-3}) do
        local bar = so("Square"); bar.Filled = true; bar.Color = HUD_COLORS.accent
        bar.Position = Vector2.new(SGN_X,y); bar.Size = Vector2.new(SGN_W,3)
        bar.Visible = true; bar.ZIndex = 22
        table.insert(hudRecolor, bar)
    end

    local cx = SGN_X + SGN_W/2
    local tip, base, half = SGN_Y+15, SGN_Y+82, 42
    for _, pts in ipairs({
        {Vector2.new(cx,tip),       Vector2.new(cx-half,base)},
        {Vector2.new(cx,tip),       Vector2.new(cx+half,base)},
        {Vector2.new(cx-half,base), Vector2.new(cx+half,base)},
    }) do
        local l = so("Line"); l.From = pts[1]; l.To = pts[2]
        l.Color = HUD_COLORS.accent; l.Thickness = 2; l.Visible = true; l.ZIndex = 23
        table.insert(hudRecolor, l)
    end

    local excl = so("Text"); excl.Text = "!"; excl.Color = HUD_COLORS.accent; excl.Size = 28
    excl.Font = Drawing.Fonts.SystemBold; excl.Center = true; excl.Outline = false
    excl.Position = Vector2.new(cx,tip+19); excl.Visible = true; excl.ZIndex = 24
    table.insert(hudRecolor, excl)

    local d1 = so("Line"); d1.From = Vector2.new(SGN_X+14,SGN_Y+90)
    d1.To = Vector2.new(SGN_X+SGN_W-14,SGN_Y+90)
    d1.Color = HUD_COLORS.accent; d1.Thickness = 1; d1.Transparency = 0.6
    d1.Visible = true; d1.ZIndex = 22
    table.insert(hudRecolor, d1)

    local nm = so("Text"); nm.Text = ""; nm.Color = HUD_COLORS.text; nm.Size = 16
    nm.Font = Drawing.Fonts.SystemBold; nm.Center = true; nm.Outline = true
    nm.Position = Vector2.new(cx,SGN_Y+98); nm.Visible = true; nm.ZIndex = 24
    hudTexts["signName"] = nm

    local d2 = so("Line"); d2.From = Vector2.new(SGN_X+14,SGN_Y+124)
    d2.To = Vector2.new(SGN_X+SGN_W-14,SGN_Y+124)
    d2.Color = HUD_COLORS.accent; d2.Thickness = 1; d2.Transparency = 0.75
    d2.Visible = true; d2.ZIndex = 22
    table.insert(hudRecolor, d2)

    local lbl = so("Text"); lbl.Text = T("tierDanger"); lbl.Color = HUD_COLORS.muted; lbl.Size = 10
    lbl.Font = Drawing.Fonts.System; lbl.Center = false; lbl.Outline = false
    lbl.Position = Vector2.new(SGN_X+12,SGN_Y+135); lbl.Visible = true; lbl.ZIndex = 24

    local rnk = so("Text"); rnk.Text = ""; rnk.Color = HUD_COLORS.accent; rnk.Size = 22
    rnk.Font = Drawing.Fonts.SystemBold; rnk.Center = false; rnk.Outline = true
    rnk.Position = Vector2.new(SGN_X+SGN_W-26,SGN_Y+130); rnk.Visible = true; rnk.ZIndex = 24
    hudTexts["signRank"] = rnk
    table.insert(hudRecolor, rnk)
end

local function hudBuildVertical()
    local HX, HY, HW = 16, 50, 250
    local H_ENEMY, H_ITEMS, H_ASSETS, H_NEO, H_PASS = 38, 32, 56, 32, 38
    local TOTAL_H = H_ENEMY + H_ITEMS + H_ASSETS + H_NEO + H_PASS
    hudPanel(HX, HY, HW, TOTAL_H)

    local RX = HX + HW - 56
    local cy = HY

    hudAccentLine(HX, cy, HW, HUD_COLORS.accent)
    hudSectionLbl(T("currentEnemy"), HX+10, cy+6)
    hudTexts["vEnemy"] = hudLabel("", HX+18, cy+20, 14, HUD_COLORS.accentL, false)
    cy = cy + H_ENEMY; hudDivider(HX+6, cy, HW-12)

    hudSectionLbl(T("itemsHud"), HX+10, cy+6)
    hudLabel(T("itemsFound"), HX+10, cy+18, 11, HUD_COLORS.muted, false, Drawing.Fonts.System)
    hudTexts["vItems"] = hudLabel("", RX, cy+17, 13, HUD_COLORS.green, false, Drawing.Fonts.Monospace)
    cy = cy + H_ITEMS; hudDivider(HX+6, cy, HW-12)

    hudSectionLbl(T("assetsHud"), HX+10, cy+6)
    hudLabel(T("modeHud"), HX+10, cy+20, 9, HUD_COLORS.dim, false, Drawing.Fonts.System)
    hudTexts["vMode"] = hudLabel("", HX+56, cy+20, 9, HUD_COLORS.muted, false, Drawing.Fonts.System)
    hudTexts["vAsset"] = hudLabel("", RX, cy+36, 13, HUD_COLORS.muted, false, Drawing.Fonts.Monospace)
    cy = cy + H_ASSETS; hudDivider(HX+6, cy, HW-12)

    hudSectionLbl(T("neostykHud"), HX+10, cy+6)
    hudLabel(T("countHud"), HX+10, cy+18, 11, HUD_COLORS.muted, false, Drawing.Fonts.System)
    hudTexts["vNeo"] = hudLabel("", RX, cy+17, 13, HUD_COLORS.purple, false, Drawing.Fonts.Monospace)
    cy = cy + H_NEO; hudDivider(HX+6, cy, HW-12)

    hudAccentLine(HX, cy, HW, HUD_COLORS.accentL)
    hudSectionLbl(T("passHud"), HX+10, cy+6)
    hudTexts["vPass"] = hudLabel("", HX+18, cy+16, 15, HUD_COLORS.cyan, false, Drawing.Fonts.Monospace)
end

local function hudBuildHorizontal()
    local HX, HY = 16, 50
    local CELL_H, INNER_PAD = 72, 8
    local W = { enemy=140, items=100, assets=150, neo=100, pass=130 }
    local totalW = W.enemy + W.items + W.assets + W.neo + W.pass

    hudPanel(HX, HY, totalW, CELL_H)
    hudAccentLine(HX, HY, totalW, HUD_COLORS.accent)
    local cx = HX

    hudSectionLbl(T("currentEnemy"), cx+8, HY+INNER_PAD)
    hudTexts["hEnemy"] = hudLabel("", cx+14, HY+22, 13, HUD_COLORS.accentL, false)
    local vl1 = hudObj("Line"); vl1.From = Vector2.new(cx+W.enemy,HY+8)
    vl1.To = Vector2.new(cx+W.enemy,HY+CELL_H-8)
    vl1.Color = HUD_COLORS.accent; vl1.Transparency = 0.75; vl1.Thickness = 1
    vl1.Visible = true; vl1.ZIndex = 22
    cx = cx + W.enemy

    hudSectionLbl(T("itemsHud"), cx+8, HY+INNER_PAD)
    hudLabel(T("itemsFound"), cx+8, HY+24, 9, HUD_COLORS.muted, false, Drawing.Fonts.System)
    hudTexts["hItems"] = hudLabel("", cx+8, HY+34, 22, HUD_COLORS.green, false, Drawing.Fonts.Monospace)
    local vl2 = hudObj("Line"); vl2.From = Vector2.new(cx+W.items,HY+8)
    vl2.To = Vector2.new(cx+W.items,HY+CELL_H-8)
    vl2.Color = HUD_COLORS.accent; vl2.Transparency = 0.75; vl2.Thickness = 1
    vl2.Visible = true; vl2.ZIndex = 22
    cx = cx + W.items

    hudSectionLbl(T("assetsHud"), cx+8, HY+INNER_PAD)
    hudTexts["hMode"] = hudLabel("", cx+8, HY+22, 9, HUD_COLORS.muted, false, Drawing.Fonts.System)
    hudTexts["hAsset"] = hudLabel("", cx+8, HY+36, 11, HUD_COLORS.muted, false, Drawing.Fonts.Monospace)
    local vl3 = hudObj("Line"); vl3.From = Vector2.new(cx+W.assets,HY+8)
    vl3.To = Vector2.new(cx+W.assets,HY+CELL_H-8)
    vl3.Color = HUD_COLORS.accent; vl3.Transparency = 0.75; vl3.Thickness = 1
    vl3.Visible = true; vl3.ZIndex = 22
    cx = cx + W.assets

    hudSectionLbl(T("neostykHud"), cx+8, HY+INNER_PAD)
    hudLabel(T("countHud"), cx+8, HY+24, 9, HUD_COLORS.muted, false, Drawing.Fonts.System)
    hudTexts["hNeo"] = hudLabel("", cx+8, HY+34, 22, HUD_COLORS.purple, false, Drawing.Fonts.Monospace)
    local vl4 = hudObj("Line"); vl4.From = Vector2.new(cx+W.neo,HY+8)
    vl4.To = Vector2.new(cx+W.neo,HY+CELL_H-8)
    vl4.Color = HUD_COLORS.accent; vl4.Transparency = 0.75; vl4.Thickness = 1
    vl4.Visible = true; vl4.ZIndex = 22
    cx = cx + W.neo

    hudAccentLine(cx, HY, W.pass, HUD_COLORS.accentL)
    hudSectionLbl(T("passHud"), cx+8, HY+INNER_PAD)
    hudTexts["hPass"] = hudLabel("", cx+8, HY+28, 15, HUD_COLORS.cyan, false, Drawing.Fonts.Monospace)
end

local function hudSync()
    updateHUDData()

    local e = HUDData.enemy
    local eName = e or T("noEnemy")
    local eCol  = e and (HUD_RANK_RGB[HUDData.enemyTier] or HUD_COLORS.accentL) or HUD_COLORS.text
    hudSet("vEnemy", eName, eCol)
    hudSet("hEnemy", eName, eCol)

    -- warning sign: triggers once per new mob, shows 3 seconds, stays off
    -- while the same mob is still present
    local now = os.clock()
    if e then
        if e ~= hudSignEnemy then
            hudSignEnemy   = e
            hudSignVisible = true
            hudSignUntil   = now + 3
        end
    else
        hudSignEnemy   = nil
        hudSignVisible = false
    end
    if hudSignVisible and now > hudSignUntil then
        hudSignVisible = false
    end
    hudSet("signName", hudSignVisible and e or "")
    for _, o in ipairs(hudSignObjs) do o.Visible = hudSignVisible end
    if hudSignVisible then
        local signCol = HUD_RANK_RGB[HUDData.enemyTier] or HUD_COLORS.accent
        for _, o in ipairs(hudRecolor) do o.Color = signCol end
        hudSet("signRank", tostring(HUDData.enemyTier))
    end

    local rich = Settings.currencyRichEnabled
    local modeStr = rich and T("richHud") or T("defaultHud")
    local modeCol = rich and HUD_COLORS.yellow or HUD_COLORS.muted
    local hasRich = HUDData.maxCurrency >= HUD_RICH_THRESHOLD
    local valCol  = hasRich and HUD_COLORS.yellow or HUD_COLORS.green
    local passTxt = HUDData.password or T("noPassword")

    hudSet("vItems", tostring(HUDData.items), HUD_COLORS.green)
    hudSet("hItems", tostring(HUDData.items), HUD_COLORS.green)
    hudSet("vMode", modeStr, modeCol)
    hudSet("hMode", modeStr, modeCol)
    hudSet("vAsset", tostring(HUDData.currencyTotal), valCol)
    hudSet("hAsset", tostring(HUDData.currencyTotal), valCol)
    hudSet("vNeo", tostring(HUDData.neostyk), HUD_COLORS.purple)
    hudSet("hNeo", tostring(HUDData.neostyk), HUD_COLORS.purple)
    hudSet("vPass", passTxt, HUD_COLORS.cyan)
    hudSet("hPass", passTxt, HUD_COLORS.cyan)
end

local function hudBuild(layout, showSign, size)
    if showSign then hudBuildSign(size.X, size.Y) end
    if layout == "Horizontal" then hudBuildHorizontal() else hudBuildVertical() end
end

spawn(function()
    local lastKey = ""
    while true do
        wait(0.1)
        local cam = workspace.CurrentCamera
        local size = cam and cam.ViewportSize
        local want = Settings.hudEnabled
        local key = ""
        if want then
            key = string.format("%s|%s|%d|%d",
                Settings.hudLayout, tostring(Settings.hudSign),
                size and size.X or 0, size and size.Y or 0)
        end
        if key ~= lastKey then
            hudDestroy()
            if want then hudBuild(Settings.hudLayout, Settings.hudSign, size) end
            lastKey = key
        end
        if want then hudSync() end
    end
end)

-- ===================== AUTOHIDE =====================
AutoHideSystem = {
    enabled=Settings.autoHideEnabled,
    isHiding=false,
    originalPosition=nil,
}

local function getHRP()
    local p = game.Players.LocalPlayer
    if not p or not p.Character then return nil end
    return p.Character:FindFirstChild("HumanoidRootPart")
end

local AUTO_HIDE_MOBS = {
    Angler=true, Blitz=true, Pinkie=true, Pandemonium=true, Froger=true, Chainsmoker=true,
    RidgeAngler=true, RidgeBlitz=true, RidgePinkie=true, RidgePandemonium=true,
    RidgeFroger=true, RidgeChainsmoker=true, A60=true, Harbinger=true,
    Bleach=true, Anglemonium=true,
}
for _, n in ipairs({"Anglemonium","Pinkimonium","Frogermonium","Blitzmonium","Blitzemonium","Pandesmoker"}) do
    AUTO_HIDE_MOBS[n] = true
    AUTO_HIDE_MOBS["Ridge"..n] = true
end

local function autoHideMobPresent()
    for _, obj in ipairs(workspace:GetChildren()) do
        local ok, name = pcall(function() return obj.Name end)
        if ok and AUTO_HIDE_MOBS[name] then return true end
    end
    return false
end

function AutoHideSystem:hide()
    if self.isHiding then return end
    local h = getHRP()
    if not h then return end
    self.originalPosition = h.Position
    self.isHiding = true
    h.AssemblyLinearVelocity = Vector3.new(0,0,0)
    h.Position = self.originalPosition + Vector3.new(0, 1000, 0)
end

function AutoHideSystem:unhide()
    if not self.isHiding then return end
    local sp = self.originalPosition
    self.originalPosition = nil
    self.isHiding = false
    local h = getHRP()
    if sp and h then
        h.AssemblyLinearVelocity = Vector3.new(0,0,0)
        h.Position = sp
    end
end

function AutoHideSystem:update()
    if not self.enabled then
        if self.isHiding then self:unhide() end
        return
    end
    if autoHideMobPresent() then
        if not self.isHiding then self:hide() end
    else
        if self.isHiding then self:unhide() end
    end
end

spawn(function()
    while true do
        -- keep AutoHide in sync with the GUI switch even if a click is dropped
        local ok, st = pcall(function() return UI.GetValue(_p .. "autohide") == true end)
        if ok and type(st) == "boolean" then
            Settings.autoHideEnabled = st
            AutoHideSystem.enabled   = st
        end
        AutoHideSystem:update()
        wait()
    end
end)

-- ===================== MAIN LOOP =====================
local RunService = game:GetService("RunService")

RunService.RenderStepped:Connect(function()
    updatePositions()
end)

spawn(function()
    while true do
        local si = getScanInterval()
        if si > 0 then wait(si) else wait() end
        scanDoors()
        scanMobs()
        checkMobNotifications()
        if Settings.autoRescanEnabled then
            local now = tick()
            if now - lastScanTime > getRescanInterval() then
                lastScanTime = now
                scanRooms()
            end
        end
    end
end)

spawn(scanRooms)

-- ===================== CONFIG =====================
local CONFIG_FILE = "PressureESP_config.json"
local HttpService  = game:GetService("HttpService")

local function saveConfig()
    local cfg = {
        keycardESP   = Settings.keycardESPEnabled,
        doorESP      = Settings.doorESPEnabled,
        fakeDoorESP  = Settings.fakeDoorESPEnabled,
        itemsESP     = Settings.itemsESPEnabled,
        currencyESP  = Settings.currencyESPEnabled,
        richOnly     = Settings.currencyRichEnabled,
        neostykESP   = Settings.neostykESPEnabled,
        lockerESP    = Settings.lockerESPEnabled,
        lockerDistOn = Settings.lockerDistEnabled,
        lockerDist   = Settings.lockerDist,
        batteryESP   = Settings.batteryESPEnabled,
        leverESP     = Settings.leverESPEnabled,
        trapESP      = Settings.trapESPEnabled,
        oxygenESP    = Settings.oxygenESPEnabled,
        mobsESP      = Settings.mobsESPEnabled,
        distLimit    = Settings.useDistanceLimit,
        distFrom     = Settings.distanceFrom,
        distTo       = Settings.distanceTo,
        autoHide     = Settings.autoHideEnabled,
        perfMode     = Settings.perfMode,
        espLimitOn   = Settings.espLimitEnabled,
        espLimit     = Settings.espLimit,
        showKickTimer= Settings.showKickTimer,
        showLabel    = Settings.showLabel,
        showDot      = Settings.showDot,
        showDist     = Settings.showDist,
        showBox2d    = Settings.showBox2d,
        showBox3d    = Settings.showBox3d,
        hudOn        = Settings.hudEnabled,
        hudLayout    = Settings.hudLayout,
        hudSign      = Settings.hudSign,
    }
    local ok, err = pcall(writefile, CONFIG_FILE, HttpService:JSONEncode(cfg))
    notify(ok and "Config saved" or ("Save failed: "..tostring(err)), "RATHUB", 3)
end

local function autoLoadConfig()
    local ok1, exists = pcall(isfile, CONFIG_FILE)
    if not (ok1 and exists) then return end
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not (ok2 and type(data) == "table") then return end
    local function ap(key, field) if data[key] ~= nil then Settings[field] = data[key] end end
    ap("keycardESP",  "keycardESPEnabled")
    ap("doorESP",     "doorESPEnabled")
    ap("fakeDoorESP", "fakeDoorESPEnabled")
    ap("itemsESP",    "itemsESPEnabled")
    ap("currencyESP", "currencyESPEnabled")
    ap("richOnly",    "currencyRichEnabled")
    ap("neostykESP",  "neostykESPEnabled")
    ap("lockerESP",   "lockerESPEnabled")
    ap("lockerDistOn","lockerDistEnabled")
    ap("lockerDist",  "lockerDist")
    ap("batteryESP",  "batteryESPEnabled")
    ap("leverESP",    "leverESPEnabled")
    ap("trapESP",     "trapESPEnabled")
    ap("oxygenESP",   "oxygenESPEnabled")
    ap("mobsESP",     "mobsESPEnabled")
    ap("distLimit",   "useDistanceLimit")
    ap("distFrom",    "distanceFrom")
    ap("distTo",      "distanceTo")
    ap("perfMode",    "perfMode")
    ap("espLimitOn",  "espLimitEnabled")
    ap("espLimit",    "espLimit")
    ap("showKickTimer","showKickTimer")
    ap("showLabel",   "showLabel")
    ap("showDot",     "showDot")
    ap("showDist",    "showDist")
    ap("showBox2d",   "showBox2d")
    ap("showBox3d",   "showBox3d")
    ap("hudOn",       "hudEnabled")
    ap("hudLayout",   "hudLayout")
    ap("hudSign",     "hudSign")
    if data.autoHide ~= nil then
        Settings.autoHideEnabled  = data.autoHide
        AutoHideSystem.enabled    = data.autoHide
    end
    notify("Config loaded", "RATHUB", 2)
end

-- Auto-load before UI so toggle defaults reflect saved state
autoLoadConfig()

-- ===================== UI =====================
local _tabName = "Pressure"
local toggleRegistry = {}

-- Combo callbacks may deliver either the 0-based index or the item text.
-- Resolve both cases to the actual selected item text.
local function comboText(items, v)
    if type(v) == "number" then
        return items[math.floor(v) + 1]
    elseif type(v) == "string" then
        for _, it in ipairs(items) do
            if it == v then return v end
        end
    end
    return nil
end

local function buildUI()
    UI.RemoveTab(_tabName)
    _p = tostring(math.floor(tick()) % 99991) .. "_"
    toggleRegistry = {}
    UI.AddTab(_tabName, function(tab)

    -- Source of truth is the widget itself: mirror its value into Settings.
    local function tog(section, id, label, key, action)
        section:Toggle(id, label, Settings[key] or false, function()
            local st = UI.GetValue(id) == true
            Settings[key] = st
            if action then action(st) end
        end)
        toggleRegistry[key] = id
    end

    local stuff = tab:Section(T("stuffESP"), "Left")

    tog(stuff, _p.."esp_kc",      T("keycardESP"),    "keycardESPEnabled",   ForceRescanESP)
    stuff:Spacing()
    tog(stuff, _p.."esp_items",   T("itemESP"),        "itemsESPEnabled",     ForceRescanESP)
    tog(stuff, _p.."esp_neostyk", T("neostykESP"),     "neostykESPEnabled",   ForceRescanESP)
    tog(stuff, _p.."esp_locker",  T("lockerESP"),      "lockerESPEnabled",    ForceRescanESP)
    tog(stuff, _p.."locker_dist_on", T("lockerDistEnable"), "lockerDistEnabled", nil)
    stuff:SliderInt(_p.."locker_dist", T("lockerDist"), 5, 1500, Settings.lockerDist, function(v)
        Settings.lockerDist = v
    end)
    tog(stuff, _p.."esp_battery", T("batteryESP"),     "batteryESPEnabled",   ForceRescanESP)
    tog(stuff, _p.."esp_lever",   T("leverESP"),       "leverESPEnabled",     ForceRescanESP)
    tog(stuff, _p.."esp_trap",    T("trapESP"),        "trapESPEnabled",      ForceRescanESP)
    tog(stuff, _p.."esp_oxygen",  T("oxygenESP"),      "oxygenESPEnabled",    ForceRescanESP)
    stuff:Spacing()
    tog(stuff, _p.."esp_curr",    T("currencyESP"),    "currencyESPEnabled",  ForceRescanESP)
    tog(stuff, _p.."esp_rich",    T("richOnly"),       "currencyRichEnabled", ForceRescanESP)
    stuff:Spacing()
    tog(stuff, _p.."esp_doors",   T("doorESP"),        "doorESPEnabled",      function(v)
        if v then lastDoorScan = 0; scanDoors()
        else for k,_ in pairs(espDoorObjects) do removeDoorESP(k) end end
    end)
    tog(stuff, _p.."esp_fakedoor",T("fakeDoorESP"),    "fakeDoorESPEnabled",  ForceRescanESP)
    stuff:Spacing()
    tog(stuff, _p.."dist_on",     T("distLimit"),      "useDistanceLimit",    nil)
    stuff:SliderInt(_p.."dist_from", T("distFrom"), 0, 29000, Settings.distanceFrom, function(v)
        Settings.distanceFrom = v
    end)
    stuff:SliderInt(_p.."dist_to", T("distTo"), 1, 30000, Settings.distanceTo, function(v)
        Settings.distanceTo = v
    end)
    stuff:Spacing()
    tog(stuff, _p.."esp_lim_on",  T("espLimitEnable"), "espLimitEnabled",     nil)
    stuff:SliderInt(_p.."esp_lim", T("espLimit"), 1, 30000, Settings.espLimit, function(v)
        Settings.espLimit = v
    end)
    stuff:Spacing()
    stuff:Button(T("forceRescan"), function()
        ForceRescanESP()
    end)
    stuff:Button(T("debugScan"), function()
        local gf = workspace:FindFirstChild("GameplayFolder")
        local rooms = gf and gf:FindFirstChild("Rooms")
        if not rooms then notify("No Rooms found", "DEBUG", 5); return end
        local all = rooms:GetDescendants()
        local kc, items, curr = 0, 0, 0
        for _, obj in ipairs(all) do
            local okN, name = pcall(function() return obj.Name end)
            if okN and name then
                if KEYCARD_NAMES[name] then kc = kc + 1 end
                local okA, attr = pcall(function() return obj:GetAttribute("InteractionType") end)
                if okA and attr then
                    if attr == "ItemBase"     then items = items + 1 end
                    if attr == "CurrencyBase" then curr  = curr  + 1 end
                end
            end
        end
        notify("KC:"..kc.." Items:"..items.." Curr:"..curr.." Total:"..#all, "DEBUG", 8)
    end)

    -- Display options
    local disp = tab:Section(T("display"), "Left")
    tog(disp, _p.."show_label", T("showName"),  "showLabel", nil)
    tog(disp, _p.."show_dist",  T("showDist"),  "showDist",  nil)
    tog(disp, _p.."show_dot",   T("showDot"),   "showDot",   nil)
    tog(disp, _p.."show_box2d", T("show2dBox"), "showBox2d", nil)
    tog(disp, _p.."show_box3d", T("show3dBox"), "showBox3d", nil)
    disp:Spacing()
    local perfIdx = 1
    for i, pn in ipairs(PERF_NAMES) do
        if pn == Settings.perfMode then perfIdx = i - 1 end
    end
    disp:Combo(_p.."perf", T("perfMode"), PERF_NAMES, perfIdx, function()
        local ok, t = pcall(function() return comboText(PERF_NAMES, UI.GetValue(_p.."perf")) end)
        if ok and t then Settings.perfMode = t end
    end)

    -- Entity ESP
    local ent = tab:Section(T("entityESP"), "Left")
    tog(ent, _p.."esp_mobs", T("mobESP"), "mobsESPEnabled", function(v)
        if not v then for addr,_ in pairs(espMobObjects) do removeMobESP(addr) end end
    end)
    ent:Spacing()

    -- Exploits
    local expl = tab:Section(T("exploits"), "Right")
    tog(expl, _p.."autohide", T("autoHide"), "autoHideEnabled", function(v)
        AutoHideSystem.enabled = v
        if not v and AutoHideSystem.isHiding then AutoHideSystem:unhide() end
    end)

    -- HUD
    local hudSec = tab:Section(T("hud"), "Right")
    tog(hudSec, _p.."hud_on", T("hud"), "hudEnabled", nil)
    hudSec:Combo(_p.."hud_layout", T("hudLayout"), {"Vertical","Horizontal"}, Settings.hudLayout == "Horizontal" and 1 or 0, function()
        local ok, t = pcall(function() return comboText({"Vertical","Horizontal"}, UI.GetValue(_p.."hud_layout")) end)
        if ok and t then Settings.hudLayout = t end
    end)
    tog(hudSec, _p.."hud_sign", T("hudSign"), "hudSign", nil)

    -- Misc
    local misc = tab:Section(T("misc"), "Right")
    tog(misc, _p.."kick_timer", T("showKickTimer"), "showKickTimer", nil)

    -- Config
    local cfg = tab:Section(T("config"), "Right")
    cfg:Button(T("saveConfig"), function()
        saveConfig()
    end)
    cfg:Button(T("loadConfig"), function()
        autoLoadConfig(); ForceRescanESP(); task.spawn(buildUI)
    end)

    end)
end

buildUI()

-- Periodically mirror every toggle widget into Settings so switches can
-- never desync from the actual functionality.
spawn(function()
    while true do
        wait(0.25)
        for key, id in pairs(toggleRegistry) do
            local ok, st = pcall(function() return UI.GetValue(id) == true end)
            if ok and type(st) == "boolean" then
                Settings[key] = st
                if key == "autoHideEnabled" then
                    AutoHideSystem.enabled = st
                end
            end
        end
    end
end)

