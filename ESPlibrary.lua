-- ESP Library for Matcha
local ESP = {}

local espObjects = {}
local scanner = nil
local running = false

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

function ESP:AddType(interactionType, settings)
    if not self.types then
        self.types = {}
    end

    settings = settings or {}
    self.types[interactionType] = {
        color = settings.color or Color3.fromRGB(255, 255, 255),
        displayName = settings.displayName or interactionType,
        enabled = settings.enabled ~= false
    }
end

function ESP:RemoveType(interactionType)
    if self.types and self.types[interactionType] then
        self.types[interactionType] = nil
    end
end

function ESP:SetTypes(types)
    self.types = types
end

function ESP:SetChunkSize(size)
    self.chunkSize = size or 30
    if scanner then
        scanner.chunkSize = self.chunkSize
    end
end

function ESP:SetScanInterval(seconds)
    self.scanInterval = seconds or 30
    if scanner then
        scanner.scanInterval = self.scanInterval
    end
end

function ESP:SetOffset(yOffset)
    self.yOffset = yOffset or -30
end

function ESP:SetFont(font)
    self.font = font or Drawing.Fonts.SystemBold
end

function ESP:SetTextSize(size)
    self.textSize = size or 16
end

function ESP:SetOutline(outline)
    self.outline = outline ~= false
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

local function createESPForObject(obj, objType, lib)
    if espObjects[obj] then
        return false
    end

    local typeSettings = lib.types and lib.types[objType] or {
        color = Color3.fromRGB(255, 255, 255),
        displayName = objType or "Unknown"
    }

    if not typeSettings.enabled then
        return false
    end

    local text = Drawing.new("Text")
    text.Text = typeSettings.displayName
    text.Color = typeSettings.color
    text.Size = lib.textSize or 16
    text.Font = lib.font or Drawing.Fonts.SystemBold
    text.Outline = lib.outline ~= false
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

local function updateAllESP(lib)
    for obj, espData in pairs(espObjects) do
        if obj and obj.Parent then
            local currentType = getObjectType(obj)

            if currentType ~= espData.objType then
                removeESPForObject(obj)
                if lib.types and lib.types[currentType] and lib.types[currentType].enabled then
                    createESPForObject(obj, currentType, lib)
                end
            else
                local pos = getPosition(obj)

                if pos then
                    local screenPos, onScreen = WorldToScreen(pos)

                    if onScreen then
                        if screenPos.X > -500 and screenPos.X < 5000 and 
                           screenPos.Y > -500 and screenPos.Y < 5000 then

                            local yOffset = lib.yOffset or -30
                            espData.text.Position = Vector2.new(screenPos.X, screenPos.Y + yOffset)
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
            removeESPForObject(obj)
        end
    end
end

local ChunkScanner = {}
ChunkScanner.__index = ChunkScanner

function ChunkScanner.new(lib)
    local self = setmetatable({}, ChunkScanner)
    self.lib = lib
    self.allFolders = {}
    self.currentChunk = 1
    self.chunkSize = lib.chunkSize or 30
    self.scanComplete = false
    self.foundObjects = {}
    self.lastFullScan = 0
    self.scanInterval = lib.scanInterval or 30
    return self
end

function ChunkScanner:collectFolders()
    self.allFolders = {}
    self.foundObjects = {}

    local gameplayFolder = workspace:FindFirstChild("GameplayFolder")
    if gameplayFolder then
        local rooms = gameplayFolder:FindFirstChild("Rooms")
        if rooms then
            for _, room in ipairs(rooms:GetChildren()) do
                table.insert(self.allFolders, room)

                local interactables = room:FindFirstChild("Interactables")
                if interactables then
                    for _, obj in ipairs(interactables:GetChildren()) do
                        table.insert(self.allFolders, obj)
                    end
                end

                local spawnLocations = room:FindFirstChild("SpawnLocations")
                if spawnLocations then
                    for _, spawn in ipairs(spawnLocations:GetChildren()) do
                        table.insert(self.allFolders, spawn)
                    end
                end
            end
        end
    end

    if #self.allFolders == 0 then
        for _, child in ipairs(workspace:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then
                table.insert(self.allFolders, child)
            end
        end
    end
end

function ChunkScanner:scanChunk()
    if #self.allFolders == 0 then
        self:collectFolders()
        if #self.allFolders == 0 then
            return 0
        end
    end

    local startIdx = self.currentChunk
    local endIdx = math.min(startIdx + self.chunkSize - 1, #self.allFolders)
    local found = 0

    for i = startIdx, endIdx do
        local folder = self.allFolders[i]
        if folder and folder.Parent then
            local descendants = folder:GetDescendants()
            for _, obj in ipairs(descendants) do
                local objType = getObjectType(obj)
                if objType and self.lib.types and self.lib.types[objType] and self.lib.types[objType].enabled then
                    self.foundObjects[obj] = true
                    found = found + 1

                    if not espObjects[obj] then
                        createESPForObject(obj, objType, self.lib)
                    end
                end
            end
        end
    end

    self.currentChunk = endIdx + 1
    if self.currentChunk > #self.allFolders then
        self.currentChunk = 1
        self.scanComplete = true
        self:cleanupRemoved()
    end

    return found
end

function ChunkScanner:cleanupRemoved()
    for obj, _ in pairs(espObjects) do
        if not self.foundObjects[obj] then
            removeESPForObject(obj)
        end
    end
    self.foundObjects = {}
end

function ChunkScanner:fullScan()
    self:collectFolders()
    self.currentChunk = 1
    self.scanComplete = false
    self.lastFullScan = tick()
end

function ChunkScanner:update()
    local currentTime = tick()

    if currentTime - self.lastFullScan > self.scanInterval then
        self:fullScan()
    end

    if not self.scanComplete then
        self:scanChunk()
    end
end

function ESP:Start()
    if running then return end
    running = true
    
    scanner = ChunkScanner.new(self)
    scanner:fullScan()

    local frameCount = 0
    local lastCount = 0

    coroutine.wrap(function()
        while running do
            frameCount = frameCount + 1

            updateAllESP(self)

            if scanner then
                scanner:update()
            end

            if frameCount % 150 == 0 then
                local currentCount = tableLength(espObjects)
                if currentCount ~= lastCount then
                    print("ESP активных объектов: " .. currentCount)
                    lastCount = currentCount
                end
            end

            task.wait(0.03)
        end
    end)()
end

function ESP:Stop()
    running = false
    for obj, espData in pairs(espObjects) do
        if espData.text then
            espData.text:Remove()
        end
    end
    espObjects = {}
    scanner = nil
    print("ESP остановлен")
end

function ESP:Clear()
    for obj, espData in pairs(espObjects) do
        if espData.text then
            espData.text:Remove()
        end
    end
    espObjects = {}
    if scanner then
        scanner.foundObjects = {}
    end
end

function ESP:GetActiveCount()
    return tableLength(espObjects)
end

return ESP
