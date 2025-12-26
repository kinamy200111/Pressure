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
    uiThemeColor = Color3.fromRGB(210, 50, 50)
}

local detectedMobs = {}
local lastScanTime = 0
local scanThread = nil

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
            oldest:Remove()
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

VisualsSection:AddButton("Manual Scan", function()
    print("[UI] Manual scan triggered")
    pcall(scanWorkspace)
    SafeNotify("Manual Scan", "Manual scan completed", 2)
end)

VisualsSection:AddButton("Clear Detected Mobs", function()
    detectedMobs = {}
    print("[UI] Cleared all detected mobs")
    SafeNotify("Cleared", "All detected mobs cleared", 2)
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

local MiscTab = Window:CreateTab("Misc")

local ControlSection = Window:CreateSection("Scanner Control", "Misc")

ControlSection:AddToggle("Enable Scanner", true, function(value)
    Settings.enabled = value
    if value then
        print("[UI] Scanner ENABLED")
        startScanner()
    else
        print("[UI] Scanner DISABLED")
        stopScanner()
    end
end)

ControlSection:AddButton("Force Re-enable Scanner", function()
    print("[UI] Scanner FORCE RE-ENABLED")
    startScanner()
    SafeNotify("Scanner", "Scanner force re-enabled", 2)
end)

ControlSection:AddButton("Test Notification", function()
    print("[UI] Testing notification...")
    SafeNotify("Test", "Test notification from RatHub", 5)
end)

local UISection = Window:CreateSection("UI Customization", "Misc")

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
    settings = Settings,
    getDetectedMobs = function() return detectedMobs end
}