loadstring(game:HttpGet("https://arcanecheats.xyz/api/matcha/uilib"))()
repeat wait() until Arcane

local Settings = {
    targetMobs = {
        Angler = true, Blitz = true, Pinkie = true, Pandemonium = true,
        Froger = true, Chainsmoker = true, RidgeAngler = true,
        RidgeBlitz = true, RidgePinkie = true, RidgePandemonium = true,
        RidgeFroger = true, RidgeChainsmoker = true, A60 = true
    },
    mobColors = {
        Angler = Color3.new(0, 1, 0), Blitz = Color3.new(1, 0, 0),
        Pinkie = Color3.new(1, 0.5, 0.8), Pandemonium = Color3.new(0.5, 0, 1),
        Froger = Color3.new(0, 1, 1), Chainsmoker = Color3.new(0.5, 0.5, 0.5),
        RidgeAngler = Color3.new(0, 0.8, 0), RidgeBlitz = Color3.new(0.8, 0, 0),
        RidgePinkie = Color3.new(0.8, 0.4, 0.6), RidgePandemonium = Color3.new(0.4, 0, 0.8),
        RidgeFroger = Color3.new(0, 0.8, 0.8), RidgeChainsmoker = Color3.new(0.4, 0.4, 0.4),
        A60 = Color3.new(1, 1, 0)
    },
    scanCooldown = 0.1,
    enabled = true,
    showNotifications = true,
    notificationColor = Color3.fromRGB(210, 50, 50),
    uiThemeColor = Color3.fromRGB(210, 50, 50),
    keycardESPEnabled = false,
    autoRescanKeycards = true,
    autoRescanInterval = 1,
    rescanInterval = 300,
    refreshKeybind = "None",
    lastKeycardScanTime = 0,
    rescanActive = false
}

local detectedMobs = {}
local lastScanTime = 0
local scanThread = nil
local keycardESPThread = nil
local keycardESPItems = {}
local rescanThread = nil

local NotificationSystem = {
    activeNotifications = {},
    nextYPosition = 0,
    notificationHeight = 60,
    spacing = 5,
    maxNotifications = 5
}

function NotificationSystem:CreateNotification(title, text, duration, customColor)
    local colorToUse = customColor or Settings.notificationColor
    
    if #self.activeNotifications >= self.maxNotifications then
        local oldest = table.remove(self.activeNotifications, 1)
        if oldest then
            oldest.background:Remove()
            oldest.accent:Remove()
            oldest.title:Remove()
            oldest.text:Remove()
            oldest.progress:Remove()
            self.nextYPosition = self.nextYPosition - (self.notificationHeight + self.spacing)
        end
    end
    
    local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    
    local startX = viewportSize.X - 320
    local startY = viewportSize.Y - 100 - self.nextYPosition
    
    local background = Drawing.new("Square")
    background.Filled = true
    background.Color = Color3.fromRGB(25, 25, 25)
    background.Transparency = 0.3
    background.Position = Vector2.new(startX, startY)
    background.Size = Vector2.new(300, self.notificationHeight)
    background.Visible = true
    background.ZIndex = 999
    
    local accent = Drawing.new("Square")
    accent.Filled = true
    accent.Color = colorToUse
    accent.Transparency = 0.7
    accent.Position = Vector2.new(startX, startY)
    accent.Size = Vector2.new(5, self.notificationHeight)
    accent.Visible = true
    accent.ZIndex = 1000
    
    local titleText = Drawing.new("Text")
    titleText.Text = title
    titleText.Color = Color3.fromRGB(255, 255, 255)
    titleText.Size = 18
    titleText.Outline = true
    titleText.Center = false
    titleText.Position = Vector2.new(startX + 15, startY + 10)
    titleText.Visible = true
    titleText.ZIndex = 1001
    
    local descText = Drawing.new("Text")
    descText.Text = text
    descText.Color = Color3.fromRGB(200, 200, 200)
    descText.Size = 14
    descText.Outline = true
    descText.Center = false
    descText.Position = Vector2.new(startX + 15, startY + 35)
    descText.Visible = true
    descText.ZIndex = 1001
    
    local progressBar = Drawing.new("Square")
    progressBar.Filled = true
    progressBar.Color = colorToUse
    progressBar.Transparency = 0.5
    progressBar.Position = Vector2.new(startX, startY + self.notificationHeight - 3)
    progressBar.Size = Vector2.new(300, 3)
    progressBar.Visible = true
    progressBar.ZIndex = 1000
    
    local notification = {
        background = background,
        accent = accent,
        title = titleText,
        text = descText,
        progress = progressBar,
        startTime = os.clock(),
        duration = duration or 5,
        targetY = startY,
        color = colorToUse
    }
    
    table.insert(self.activeNotifications, notification)
    self.nextYPosition = self.nextYPosition + (self.notificationHeight + self.spacing)
    
    return notification
end

function NotificationSystem:UpdateNotificationColors()
    for _, notif in ipairs(self.activeNotifications) do
        notif.accent.Color = Settings.notificationColor
        notif.progress.Color = Settings.notificationColor
    end
end

function NotificationSystem:Update()
    local currentTime = os.clock()
    local toRemove = {}
    
    for i, notif in ipairs(self.activeNotifications) do
        local elapsed = currentTime - notif.startTime
        local progress = math.min(elapsed / notif.duration, 1)
        
        notif.progress.Size = Vector2.new(300 * (1 - progress), 3)
        
        if elapsed >= notif.duration then
            local fadeProgress = math.min((elapsed - notif.duration) / 0.5, 1)
            local alpha = 1 - fadeProgress
            
            notif.background.Transparency = 0.3 + (0.7 * fadeProgress)
            notif.accent.Transparency = 0.7 + (0.3 * fadeProgress)
            notif.title.Transparency = alpha
            notif.text.Transparency = alpha
            notif.progress.Transparency = 0.5 + (0.5 * fadeProgress)
            
            if fadeProgress >= 1 then
                table.insert(toRemove, i)
            end
        end
    end
    
    for i = #toRemove, 1, -1 do
        local idx = toRemove[i]
        local notif = table.remove(self.activeNotifications, idx)
        if notif then
            notif.background:Remove()
            notif.accent:Remove()
            notif.title:Remove()
            notif.text:Remove()
            notif.progress:Remove()
        end
    end
    
    if #toRemove > 0 then
        self.nextYPosition = 0
        for i, notif in ipairs(self.activeNotifications) do
            local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
            local targetY = viewportSize.Y - 100 - self.nextYPosition
            
            local deltaY = targetY - notif.targetY
            notif.targetY = targetY
            
            notif.background.Position = Vector2.new(notif.background.Position.X, targetY)
            notif.accent.Position = Vector2.new(notif.accent.Position.X, targetY)
            notif.title.Position = Vector2.new(notif.title.Position.X, targetY + 10)
            notif.text.Position = Vector2.new(notif.text.Position.X, targetY + 35)
            notif.progress.Position = Vector2.new(notif.progress.Position.X, targetY + NotificationSystem.notificationHeight - 3)
            
            self.nextYPosition = self.nextYPosition + (NotificationSystem.notificationHeight + NotificationSystem.spacing)
        end
    end
end

local function SafeNotify(title, text, duration, mobType)
    local colorToUse = Settings.notificationColor
    
    if mobType and Settings.mobColors[mobType] then
        colorToUse = Settings.mobColors[mobType]
    end
    
    NotificationSystem:CreateNotification(title, text, duration or 5, colorToUse)
    Arcane:Log(title .. ": " .. text, 2)
end

local function setMouseLock(locked)
    if setrobloxinput then
        setrobloxinput(not locked)
    end
end

local function scanWorkspace()
    if not Settings.enabled then 
        return 
    end
    
    local currentTime = os.clock()
    if currentTime - lastScanTime < Settings.scanCooldown then 
        return 
    end
    lastScanTime = currentTime

    local success, children = pcall(function()
        return workspace:GetChildren()
    end)
    
    if not success or not children then
        return
    end
    
    local currentFrameMobs = {}

    for i = 1, #children do
        local obj = children[i]
        local objName = obj.Name
        
        for mobType, enabled in pairs(Settings.targetMobs) do
            if enabled and objName == mobType then
                local mobId = objName .. "_" .. tostring(i)
                currentFrameMobs[mobId] = true
                
                if not detectedMobs[mobId] then
                    detectedMobs[mobId] = {
                        type = mobType, 
                        time = currentTime
                    }
                    
                    if Settings.showNotifications then
                        SafeNotify("MOB DETECTED!", mobType .. " detected", 3, mobType)
                    end
                    print("[MOB SCANNER] Found new: " .. mobType)
                end
                break
            end
        end
    end
    
    for mobId, data in pairs(detectedMobs) do
        if not currentFrameMobs[mobId] then
            detectedMobs[mobId] = nil
        end
    end
end

local function startScanner()
    if scanThread then 
        return 
    end
    
    Settings.enabled = true
    scanThread = spawn(function()
        print("[MOB SCANNER] Scanner started")
        
        while Settings.enabled do
            pcall(scanWorkspace)
            
            pcall(function()
                NotificationSystem:Update()
            end)
            
            wait(Settings.scanCooldown)
        end
        
        print("[MOB SCANNER] Scanner stopped")
        scanThread = nil
    end)
end

local function stopScanner()
    Settings.enabled = false
    print("[SCANNER] Stop signal sent")
end

local function findKeycards()
    local foundKeycards = {}
    
    local success, rooms = pcall(function()
        local gameplayFolder = workspace:WaitForChild("GameplayFolder", 2)
        if gameplayFolder then
            return gameplayFolder:WaitForChild("Rooms", 2)
        end
        return nil
    end)
    
    if not success or not rooms then
        print("[KEYCARD FINDER] Rooms not found")
        return foundKeycards
    end
    
    local success2, descendants = pcall(function()
        return rooms:GetDescendants()
    end)
    
    if not success2 or not descendants then
        print("[KEYCARD FINDER] Failed to get descendants")
        return foundKeycards
    end
    
    for _, obj in ipairs(descendants) do
        local success3, interactionType = pcall(function()
            return obj:GetAttribute("InteractionType")
        end)
        
        if success3 and (interactionType == "KeyCard" or interactionType == "PasswordPaper" or interactionType == "InnerKeyCard") then
            local success4, proxyPart = pcall(function()
                return obj:FindFirstChild("ProxyPart")
            end)
            
            if success4 and proxyPart then
                local displayName = "KeyCard"
                if interactionType == "PasswordPaper" then
                    displayName = "Password"
                elseif interactionType == "InnerKeyCard" then
                    displayName = "InnerKey"
                end
                
                local boxColor = Color3.fromRGB(0, 255, 0)
                if interactionType == "PasswordPaper" then
                    boxColor = Color3.fromRGB(0, 150, 255)
                elseif interactionType == "InnerKeyCard" then
                    boxColor = Color3.fromRGB(255, 255, 0)
                end
                
                local box = Drawing.new("Square")
                box.Filled = false
                box.Color = boxColor
                box.Size = Vector2.new(40, 40)
                box.Visible = false
                box.Thickness = 2
                
                local text = Drawing.new("Text")
                text.Color = Color3.fromRGB(255, 255, 255)
                text.Center = true
                text.Size = 16
                text.Outline = true
                text.Visible = false
                
                table.insert(foundKeycards, {
                    model = obj,
                    part = proxyPart,
                    box = box,
                    text = text,
                    type = interactionType,
                    displayName = displayName,
                    boxColor = boxColor
                })
            end
        end
    end
    
    print("[KEYCARD FINDER] Found " .. #foundKeycards .. " items")
    return foundKeycards
end

local function cleanupKeycardESP()
    print("[CLEANUP] Cleaning up Keycard ESP...")
    
    Settings.keycardESPEnabled = false
    Settings.autoRescanKeycards = false
    Settings.rescanActive = false
    
    wait(0.1)
    
    for _, esp in ipairs(keycardESPItems) do
        if esp.box then 
            esp.box:Remove() 
        end
        if esp.text then 
            esp.text:Remove() 
        end
    end
    
    keycardESPItems = {}
    keycardESPThread = nil
    rescanThread = nil
    
    print("[CLEANUP] Keycard ESP cleaned up")
end

local function performAutoRescan()
    if not Settings.keycardESPEnabled then
        print("[AUTO-RESCAN] ESP disabled, skipping rescan")
        return
    end
    
    if Settings.rescanActive then
        print("[AUTO-RESCAN] Rescan already in progress")
        return
    end
    
    Settings.rescanActive = true
    print("[AUTO-RESCAN] Starting auto-rescan...")
    
    local oldESP = keycardESPItems
    keycardESPItems = {}
    
    local newKeycards = findKeycards()
    
    if #newKeycards > 0 then
        print("[AUTO-RESCAN] Found " .. #newKeycards .. " items")
        
        for _, esp in ipairs(oldESP) do
            if esp.box then
                esp.box:Remove()
            end
            if esp.text then
                esp.text:Remove()
            end
        end
        
        keycardESPItems = newKeycards
        
        local keycardCount = 0
        local passwordCount = 0
        local innerKeyCount = 0
        
        for _, esp in ipairs(keycardESPItems) do
            if esp.type == "KeyCard" then
                keycardCount = keycardCount + 1
            elseif esp.type == "PasswordPaper" then
                passwordCount = passwordCount + 1
            elseif esp.type == "InnerKeyCard" then
                innerKeyCount = innerKeyCount + 1
            end
        end
        
        SafeNotify("Auto-Rescan", 
            "Completed successfully!\n" ..
            "Keycards: " .. keycardCount .. 
            "\nPasswords: " .. passwordCount .. 
            "\nInner Keys: " .. innerKeyCount ..
            "\nTotal: " .. #keycardESPItems .. " items", 3)
            
        print("[AUTO-RESCAN] Keycards: " .. keycardCount .. ", Passwords: " .. passwordCount .. ", Inner Keys: " .. innerKeyCount)
        
        if Settings.keycardESPEnabled then
            if keycardESPThread then
                Settings.keycardESPEnabled = false
                wait(0.1)
                keycardESPThread = nil
            end
            
            Settings.keycardESPEnabled = true
            
            local function startDrawingThread()
                if keycardESPThread then
                    return
                end
                
                keycardESPThread = spawn(function()
                    print("[KEYCARD ESP] Drawing thread started")
                    
                    while Settings.keycardESPEnabled do
                        wait(0)
                        
                        local activeCount = 0
                        
                        for i = #keycardESPItems, 1, -1 do
                            local esp = keycardESPItems[i]
                            
                            if esp.model and esp.model.Parent and esp.part and esp.part.Parent then
                                local pos, onScreen = WorldToScreen(esp.part.Position)
                                
                                if onScreen then
                                    esp.box.Position = Vector2.new(pos.X - 20, pos.Y - 20)
                                    esp.box.Visible = true
                                    
                                    esp.text.Position = Vector2.new(pos.X, pos.Y + 25)
                                    esp.text.Text = esp.displayName
                                    esp.text.Visible = true
                                    
                                    activeCount = activeCount + 1
                                else
                                    esp.box.Visible = false
                                    esp.text.Visible = false
                                end
                            else
                                esp.box:Remove()
                                esp.text:Remove()
                                table.remove(keycardESPItems, i)
                                print("[KEYCARD ESP] Removed invalid item")
                            end
                        end
                    end
                    
                    print("[KEYCARD ESP] Drawing thread stopped")
                    cleanupKeycardESP()
                end)
            end
            
            startDrawingThread()
        end
    else
        print("[AUTO-RESCAN] No items found")
        SafeNotify("Auto-Rescan", "No items found", 2)
    end
    
    Settings.rescanActive = false
end

local function startAutoRescan()
    if rescanThread then
        Settings.autoRescanKeycards = false
        wait(0.1)
        rescanThread = nil
    end
    
    if not Settings.autoRescanKeycards then
        return
    end
    
    rescanThread = spawn(function()
        print("[AUTO-RESCAN] Thread started with interval: " .. Settings.autoRescanInterval .. " seconds")
        
        local lastAutoRescanTime = os.clock()
        
        while Settings.autoRescanKeycards and Settings.keycardESPEnabled do
            wait(1)
            
            local currentTime = os.clock()
            
            if currentTime - lastAutoRescanTime >= Settings.autoRescanInterval then
                print("[AUTO-RESCAN] Time to rescan! Last auto scan was " .. (currentTime - lastAutoRescanTime) .. " seconds ago")
                
                performAutoRescan()
                
                lastAutoRescanTime = currentTime
            end
        end
        
        print("[AUTO-RESCAN] Thread stopped")
        rescanThread = nil
    end)
end

local function startKeycardESP()
    if keycardESPThread then
        Settings.keycardESPEnabled = false
        wait(0.1)
        keycardESPThread = nil
    end
    
    Settings.keycardESPEnabled = true
    Settings.lastKeycardScanTime = os.clock()
    
    keycardESPItems = findKeycards()
    
    if #keycardESPItems == 0 then
        SafeNotify("Keycard ESP", "No items found", 3)
        print("[KEYCARD ESP] No items found on initial scan")
        return
    end
    
    print("[KEYCARD ESP] Starting with " .. #keycardESPItems .. " items")
    
    local keycardCount = 0
    local passwordCount = 0
    local innerKeyCount = 0
    
    for _, esp in ipairs(keycardESPItems) do
        if esp.type == "KeyCard" then
            keycardCount = keycardCount + 1
        elseif esp.type == "PasswordPaper" then
            passwordCount = passwordCount + 1
        elseif esp.type == "InnerKeyCard" then
            innerKeyCount = innerKeyCount + 1
        end
    end
    
    SafeNotify("Keycard ESP", 
        "ESP Activated!\n" ..
        "Keycards: " .. keycardCount .. 
        "\nPasswords: " .. passwordCount .. 
        "\nInner Keys: " .. innerKeyCount ..
        "\nTotal: " .. #keycardESPItems .. " items", 3)
    
    keycardESPThread = spawn(function()
        print("[KEYCARD ESP] Drawing thread started")
        
        while Settings.keycardESPEnabled do
            wait(0)
            
            local activeCount = 0
            
            for i = #keycardESPItems, 1, -1 do
                local esp = keycardESPItems[i]
                
                if esp.model and esp.model.Parent and esp.part and esp.part.Parent then
                    local pos, onScreen = WorldToScreen(esp.part.Position)
                    
                    if onScreen then
                        esp.box.Position = Vector2.new(pos.X - 20, pos.Y - 20)
                        esp.box.Visible = true
                        
                        esp.text.Position = Vector2.new(pos.X, pos.Y + 25)
                        esp.text.Text = esp.displayName
                        esp.text.Visible = true
                        
                        activeCount = activeCount + 1
                    else
                        esp.box.Visible = false
                        esp.text.Visible = false
                    end
                else
                    esp.box:Remove()
                    esp.text:Remove()
                    table.remove(keycardESPItems, i)
                    print("[KEYCARD ESP] Removed invalid item")
                end
            end
        end
        
        print("[KEYCARD ESP] Drawing thread stopped")
        cleanupKeycardESP()
    end)
    
    if Settings.autoRescanKeycards then
        startAutoRescan()
    end
end

local function forceRescanKeycards()
    print("[FORCE RESCAN] Manual rescan triggered")
    
    if Settings.keycardESPEnabled then
        performAutoRescan()
    else
        print("[FORCE RESCAN] ESP not enabled, enabling first...")
        Settings.keycardESPEnabled = true
        startKeycardESP()
    end
end

Arcane:AddTheme("RatHubCustom", {
    Background = Color3.fromRGB(15, 15, 15),
    Section = Color3.fromRGB(25, 25, 25),
    Accent = Settings.uiThemeColor,
    Outline = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(230, 230, 230),
    TextDark = Color3.fromRGB(140, 140, 140),
    Button = Color3.fromRGB(35, 35, 35)
})

local Window = Arcane:CreateWindow("RatHub - Mob Scanner", Vector2.new(900, 700), "RatHubCustom")
Window:CreateTabSection("Scanner Tabs")

local VisualsTab = Window:CreateTab("Visuals")

local VisualsSection = Window:CreateSection("Entities Detection", "Visuals")

local mobOptions = {
    "Angler", "Blitz", "Pinkie", "Pandemonium", "Froger", "Chainsmoker",
    "RidgeAngler", "RidgeBlitz", "RidgePinkie", "RidgePandemonium",
    "RidgeFroger", "RidgeChainsmoker", "A60"
}
local defaultSelected = {}
for _, mob in ipairs(mobOptions) do
    table.insert(defaultSelected, mob)
end

VisualsSection:AddMultipleDropdown("Detect Mobs", mobOptions, defaultSelected, function(selected)
    print("[UI] Updated mob selection:")
    for _, mob in ipairs(mobOptions) do
        local isFound = false
        for _, selMob in ipairs(selected) do
            if selMob == mob then
                isFound = true
                break
            end
        end
        Settings.targetMobs[mob] = isFound
    end
end)

VisualsSection:AddSlider("Scan Speed", {
    Min = 10,
    Max = 1000,
    Default = 100,
    Callback = function(value)
        Settings.scanCooldown = value / 1000
        print("[UI] Scan cooldown: " .. value .. "ms")
    end
})

VisualsSection:AddToggle("Show Notifications", true, function(value)
    Settings.showNotifications = value
    print("[UI] Notifications: " .. (value and "ENABLED" or "DISABLED"))
end)

local ItemESPSection = Window:CreateSection("ItemESP", "Visuals")

ItemESPSection:AddToggle("ESP Keycard", false, function(value)
    Settings.keycardESPEnabled = value
    print("[UI] Keycard ESP: " .. (value and "ENABLED" or "DISABLED"))
    
    if value then
        startKeycardESP()
    else
        Settings.keycardESPEnabled = false
        
        if keycardESPThread then
            wait(0.1)
            keycardESPThread = nil
        end
        
        if rescanThread then
            Settings.autoRescanKeycards = false
            wait(0.1)
            rescanThread = nil
        end
        
        cleanupKeycardESP()
    end
end)

ItemESPSection:AddToggle("Auto Rescan Keycards", true, function(value)
    Settings.autoRescanKeycards = value
    print("[UI] Auto-rescan: " .. (value and "ENABLED" or "DISABLED"))
    
    if value and Settings.keycardESPEnabled then
        startAutoRescan()
    elseif not value and rescanThread then
        rescanThread = nil
    end
end)

ItemESPSection:AddSlider("Auto Rescan Interval", {
    Min = 1,
    Max = 60,
    Default = 1,
    Callback = function(value)
        Settings.autoRescanInterval = value
        print("[UI] Auto rescan interval: " .. value .. " seconds")
        
        if Settings.autoRescanKeycards and Settings.keycardESPEnabled and rescanThread then
            rescanThread = nil
            startAutoRescan()
        end
    end
})

ItemESPSection:AddSlider("Rescan Interval", {
    Min = 10,
    Max = 600,
    Default = 300,
    Callback = function(value)
        Settings.rescanInterval = value
        print("[UI] Rescan interval: " .. value .. "s")
    end
})

ItemESPSection:AddKeybind("Refresh Keybind", "None", function()
    if Settings.keycardESPEnabled then
        cleanupKeycardESP()
        wait(0.1)
        startKeycardESP()
        SafeNotify("Keycard ESP", "Keycards refreshed", 2)
    else
        print("[KEYBIND] Enable ESP first to refresh")
    end
end, false)

ItemESPSection:AddButton("Force Rescan Now", function()
    forceRescanKeycards()
end)

local ColorsSection = Window:CreateSection("Mob Colors", "Visuals")

for _, mob in ipairs(mobOptions) do
    ColorsSection:AddColorPicker(mob .. " Color", Settings.mobColors[mob], function(color)
        Settings.mobColors[mob] = color
        print("[UI] " .. mob .. " color updated")
    end)
end

ColorsSection:AddButton("Reset All Colors", function()
    local defaultColors = {
        Angler = Color3.new(0, 1, 0), Blitz = Color3.new(1, 0, 0),
        Pinkie = Color3.new(1, 0.5, 0.8), Pandemonium = Color3.new(0.5, 0, 1),
        Froger = Color3.new(0, 1, 1), Chainsmoker = Color3.new(0.5, 0.5, 0.5),
        RidgeAngler = Color3.new(0, 0.8, 0), RidgeBlitz = Color3.new(0.8, 0, 0),
        RidgePinkie = Color3.new(0.8, 0.4, 0.6), RidgePandemonium = Color3.new(0.4, 0, 0.8),
        RidgeFroger = Color3.new(0, 0.8, 0.8), RidgeChainsmoker = Color3.new(0.4, 0.4, 0.4),
        A60 = Color3.new(1, 1, 0)
    }
    
    for mob, color in pairs(defaultColors) do
        Settings.mobColors[mob] = color
    end
    print("[UI] All colors reset to default")
end)

local MiscTab = Window:CreateTab("Settings")

local SystemSection = Window:CreateSection("System", "Settings")

SystemSection:AddToggle("Enable Scanner", true, function(value)
    Settings.enabled = value
    if value then
        print("[UI] Scanner ENABLED")
        startScanner()
    else
        print("[UI] Scanner DISABLED")
        stopScanner()
    end
end)

SystemSection:AddButton("Force Re-enable Scanner", function()
    print("[UI] Scanner FORCE RE-ENABLED")
    startScanner()
    SafeNotify("Scanner", "Scanner force re-enabled", 2)
end)

local UISection = Window:CreateSection("UI Customization", "Settings")

UISection:AddColorPicker("Notification Color", Settings.notificationColor, function(color)
    Settings.notificationColor = color
    NotificationSystem:UpdateNotificationColors()
    print("[UI] Notification color updated")
end)

UISection:AddButton("Reset Notification Color", function()
    Settings.notificationColor = Color3.fromRGB(210, 50, 50)
    NotificationSystem:UpdateNotificationColors()
    print("[UI] Notification color reset")
end)

local DebugSection = Window:CreateSection("Debug", "Settings")

DebugSection:AddButton("Test Notification", function()
    print("[DEBUG] Testing notification...")
    SafeNotify("Test", "Test notification from RatHub", 5)
end)

DebugSection:AddButton("Manual Scan", function()
    print("[DEBUG] Manual scan triggered")
    local countBefore = 0
    for _ in pairs(detectedMobs) do
        countBefore = countBefore + 1
    end
    
    pcall(scanWorkspace)
    
    local countAfter = 0
    for _ in pairs(detectedMobs) do
        countAfter = countAfter + 1
    end
    
    local newMobs = countAfter - countBefore
    if newMobs > 0 then
        SafeNotify("Manual Scan", "Found " .. newMobs .. " new mobs", 3)
    else
        SafeNotify("Manual Scan", "No new mobs found", 2)
    end
end)

DebugSection:AddButton("Scanner Status", function()
    local count = 0
    for _ in pairs(detectedMobs) do
        count = count + 1
    end
    
    print("[DEBUG] Scanner Status:")
    print("  Enabled: " .. tostring(Settings.enabled))
    print("  Detected mobs: " .. count)
    print("  Scan delay: " .. (Settings.scanCooldown * 1000) .. "ms")
    
    SafeNotify("Status", 
        "Scanner: " .. (Settings.enabled and "ON" or "OFF") ..
        "\nMobs: " .. count .. " detected" ..
        "\nDelay: " .. (Settings.scanCooldown * 1000) .. "ms", 5)
end)

DebugSection:AddButton("Print Detected Mobs", function()
    print("[DEBUG] Currently detected mobs:")
    if next(detectedMobs) == nil then
        print("  No mobs detected")
        SafeNotify("Debug", "No mobs detected", 2)
    else
        for mobId, data in pairs(detectedMobs) do
            print("  - " .. data.type .. " (ID: " .. mobId .. ")")
        end
        SafeNotify("Debug", "Printed mobs to console", 2)
    end
end)

DebugSection:AddButton("Keycard ESP Status", function()
    print("[DEBUG] Keycard ESP Status:")
    print("  Enabled: " .. tostring(Settings.keycardESPEnabled))
    print("  Auto-rescan: " .. tostring(Settings.autoRescanKeycards))
    print("  Auto rescan interval: " .. Settings.autoRescanInterval .. "s")
    print("  Rescan interval: " .. Settings.rescanInterval .. "s")
    print("  Found items: " .. #keycardESPItems)
    print("  Last scan: " .. (os.clock() - Settings.lastKeycardScanTime) .. " seconds ago")
    
    if Settings.rescanActive then
        print("  Rescan status: ACTIVE")
    else
        print("  Rescan status: INACTIVE")
    end
    
    if rescanThread then
        print("  Rescan thread: ACTIVE")
    else
        print("  Rescan thread: INACTIVE")
    end
    
    local keycardCount = 0
    local passwordCount = 0
    local innerKeyCount = 0
    
    for _, esp in ipairs(keycardESPItems) do
        if esp.type == "KeyCard" then
            keycardCount = keycardCount + 1
        elseif esp.type == "PasswordPaper" then
            passwordCount = passwordCount + 1
        elseif esp.type == "InnerKeyCard" then
            innerKeyCount = innerKeyCount + 1
        end
    end
    
    if #keycardESPItems > 0 then
        SafeNotify("Keycard ESP", 
            "ESP: " .. (Settings.keycardESPEnabled and "ON" or "OFF") ..
            "\nAuto-rescan: " .. (Settings.autoRescanKeycards and "ON" or "OFF") ..
            "\nKeycards: " .. keycardCount .. 
            "\nPasswords: " .. passwordCount .. 
            "\nInner Keys: " .. innerKeyCount ..
            "\nTotal: " .. #keycardESPItems .. " items", 5)
    else
        SafeNotify("Keycard ESP", "No items found", 3)
    end
end)

print("[MOB SCANNER] =================================")
print("[MOB SCANNER] RatHub Mob Scanner Initialized")
print("[MOB SCANNER] Press F1 to open/close UI")
print("[MOB SCANNER] =================================")

SafeNotify("RatHub Mob Scanner", "Successfully initialized!", 5)

startScanner()

Window:Finalize()

spawn(function()
    while true do
        pcall(function()
            NotificationSystem:Update()
        end)
        wait(0.033)
    end
end)

return {
    start = startScanner,
    stop = stopScanner,
    scan = scanWorkspace,
    SafeNotify = SafeNotify,
    cleanupKeycardESP = cleanupKeycardESP,
    settings = Settings,
    getDetectedMobs = function() return detectedMobs end
}
