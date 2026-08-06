-- PressureRecode by RATHUB | Matcha

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

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
        A200=true, Anglemonium=true, Sebastian=true
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
    },
}
local function T(key) return (L[Settings.lang] or L.EN)[key] or key end

-- ===================== PERF INTERVALS =====================
local PERF = {
    Low   = { render=1/20, scan=2,   livePos=false, rescan=10 },
    Mid   = { render=1/60, scan=1,   livePos=false, rescan=5  },
    High  = { render=0,    scan=0,   livePos=true,  rescan=2  },
    Ultra = { render=0,    scan=0,   livePos=true,  rescan=1  },
}
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
    local all = rooms:GetDescendants()
    for _, obj in ipairs(all) do
        local okN, name = pcall(function() return obj.Name end)
        if not (okN and name) then continue end

        if KEYCARD_NAMES[name] then
            local kcType = KEYCARD_NAMES[name]
            if Settings.keycardESPEnabled and Settings.keycardTypes[kcType] then
                pcall(createKeycardESP, obj, name)
            end
        end

        if Settings.fakeDoorESPEnabled and name == "Trickster" then
            pcall(createFakeDoorESP, obj)
        end

        -- Currency by name pattern
        if Settings.currencyESPEnabled and name:sub(1,8) == "Currency" then
            local okC, cls = pcall(function() return obj.ClassName end)
            if okC and cls == "Model" then
                local amount = parseCurrencyAmount(name)
                local rich = (not Settings.currencyRichEnabled) or (amount and amount >= 25)
                if rich then pcall(createCurrencyESP, obj) end
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

    if AutoHideSystem.isHiding then
        -- hide everything while autohide active
        for _, d in pairs(espObjects)      do
            if d.text  then d.text.Visible  = false end
            if d.dot   then d.dot.Visible   = false end
            if d.box2d then d.box2d.Visible = false end
            updateBox3d(d.box3d, nil, nil, nil, false)
        end
        for _, d in pairs(espDoorObjects)  do
            if d.text then d.text.Visible = false end
            if d.dot  then d.dot.Visible  = false end
        end
        for _, d in pairs(espFakeDoorObjs) do
            if d.text then d.text.Visible = false end
            if d.dot  then d.dot.Visible  = false end
        end
        for _, d in pairs(espMobObjects)   do
            if d.text then d.text.Visible = false end
            if d.dot  then d.dot.Visible  = false end
        end
        return
    end

    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local playerPos = hrp and hrp.Position

    local function inRange(pos)
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

-- ===================== AUTOHIDE =====================
AutoHideSystem = {
    enabled=Settings.autoHideEnabled,
    isHiding=false,
    originalPosition=nil,
    holdLoop=false,
    lastCheck=0,
    mobGoneAt=nil,
    UNHIDE_DELAY=2.0,
}

local function getHRP()
    local p = game.Players.LocalPlayer
    if not p or not p.Character then return nil end
    return p.Character:FindFirstChild("HumanoidRootPart")
end

-- generation counter prevents two concurrent forceTeleport calls fighting each other
local _tpGen = 0
local function forceTeleport(pos)
    _tpGen = _tpGen + 1
    local myGen = _tpGen
    for i = 1, 6 do
        if _tpGen ~= myGen then return end
        local h = getHRP()
        if h then
            h.AssemblyLinearVelocity = Vector3.new(0,0,0)
            h.Position = pos
        end
        wait()
    end
end

local AUTO_HIDE_MOBS = {
    Angler=true, Blitz=true, Pinkie=true, Pandemonium=true, Froger=true, Chainsmoker=true,
    RidgeAngler=true, RidgeBlitz=true, RidgePinkie=true, RidgePandemonium=true,
    RidgeFroger=true, RidgeChainsmoker=true, A60=true, Harbinger=true,
    Bleach=true, Anglemonium=true,
}

local function autoHideMobPresent()
    -- check workspace top-level and one level deep (GameplayFolder etc.)
    local function checkChildren(parent)
        for _, obj in ipairs(parent:GetChildren()) do
            local ok, name = pcall(function() return obj.Name end)
            if ok and AUTO_HIDE_MOBS[name] then return true end
        end
        return false
    end
    if checkChildren(workspace) then return true end
    local gf = workspace:FindFirstChild("GameplayFolder")
    if gf and checkChildren(gf) then return true end
    return false
end

function AutoHideSystem:hide()
    if self.isHiding then return end
    local h = getHRP()
    if not h then return end
    self.originalPosition = h.Position
    self.isHiding = true
    self.holdLoop = true
    self.mobGoneAt = nil
    local hidePos = self.originalPosition + Vector3.new(0, 1000, 0)
    spawn(function() forceTeleport(hidePos) end)
    spawn(function()
        while self.holdLoop do
            local hr = getHRP()
            if hr then hr.AssemblyLinearVelocity = Vector3.new(0,0,0) end
            wait()
        end
    end)
end

function AutoHideSystem:unhide()
    if not self.isHiding then return end
    self.holdLoop = false
    self.mobGoneAt = nil
    local sp = self.originalPosition
    self.originalPosition = nil
    spawn(function()
        if sp then forceTeleport(sp) end
        self.isHiding = false  -- mark done only after teleport finishes
    end)
end

function AutoHideSystem:update()
    if not self.enabled then
        if self.isHiding then self:unhide() end
        return
    end
    local now = os.clock()
    if now - self.lastCheck < 0.05 then return end
    self.lastCheck = now
    if autoHideMobPresent() then
        self.mobGoneAt = nil  -- mob present, reset gone timer
        if not self.isHiding then self:hide() end
    else
        if self.isHiding then
            if not self.mobGoneAt then
                self.mobGoneAt = now
            elseif now - self.mobGoneAt >= self.UNHIDE_DELAY then
                self:unhide()
            end
        end
    end
end

spawn(function()
    while true do AutoHideSystem:update(); wait() end
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
        lang         = Settings.lang,
        espLimitOn   = Settings.espLimitEnabled,
        espLimit     = Settings.espLimit,
        showKickTimer= Settings.showKickTimer,
        showLabel    = Settings.showLabel,
        showDot      = Settings.showDot,
        showDist     = Settings.showDist,
        showBox2d    = Settings.showBox2d,
        showBox3d    = Settings.showBox3d,
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
    ap("lang",        "lang")
    ap("espLimitOn",  "espLimitEnabled")
    ap("espLimit",    "espLimit")
    ap("showKickTimer","showKickTimer")
    ap("showLabel",   "showLabel")
    ap("showDot",     "showDot")
    ap("showDist",    "showDist")
    ap("showBox2d",   "showBox2d")
    ap("showBox3d",   "showBox3d")
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

local function buildUI()
    UI.RemoveTab(_tabName)
    local _p = tostring(math.floor(tick()) % 99991) .. "_"
    UI.AddTab(_tabName, function(tab)

    -- Matcha Toggle always sends v=true on every click. Flip state manually.
    local function tog(section, id, label, key, action)
        section:Toggle(id, label, Settings[key], function(v)
            Settings[key] = not Settings[key]
            if action then action(Settings[key]) end
        end)
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
    disp:Combo("perf", T("perfMode"), {"Low","Mid","High","Ultra"}, Settings.perfMode, function(v)
        Settings.perfMode = v
    end)
    disp:Combo("lang", T("language"), {"EN","RU"}, Settings.lang, function(v)
        if v == Settings.lang then return end
        Settings.lang = v
        task.spawn(buildUI)
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

    -- Misc
    local misc = tab:Section(T("misc"), "Right")
    tog(misc, _p.."kick_timer", T("showKickTimer"), "showKickTimer", nil)

    -- Config
    local cfg = tab:Section(T("cnfig"), "Right")
    cfg:Button(T("saveConfig"), function()
        saveConfig()
    end)
    cfg:Button(T("loadConfig"), function()
        autoLoadConfig(); ForceRescanESP(); task.spawn(buildUI)
    end)

    end)
end

buildUI()

