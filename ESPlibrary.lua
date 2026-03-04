-- Pressure ESP Library for Matcha
local PressureEsp = {}

local espInstances = {}
local running = false

local function getPosition(instance)
    if instance.Position then return instance.Position end
    for _, child in ipairs(instance:GetChildren()) do
        local pos = getPosition(child)
        if pos then return pos end
    end
    return nil
end

function PressureEsp.new(instance)
    local self = setmetatable({}, { __index = PressureEsp })
    self.instance = instance
    self.objects = {}
    self.position = getPosition(instance)
    table.insert(espInstances, self)
    
    if not running then
        running = true
        self:startLoop()
    end
    
    return self
end

function PressureEsp:AddEsp(color)
    local box = Drawing.new("Square")
    box.Color = color or Color3.fromRGB(255, 255, 255)
    box.Thickness = 2
    box.Filled = false
    box.Visible = true
    self.objects.esp = box
    return self
end

function PressureEsp:AddTitle(color, text)
    local title = Drawing.new("Text")
    title.Text = text or "Unknown"
    title.Color = color or Color3.fromRGB(255, 255, 255)
    title.Size = 16
    title.Font = Drawing.Fonts.SystemBold
    title.Outline = true
    title.Center = true
    title.Visible = true
    self.objects.title = title
    return self
end

function PressureEsp:AddDistance(color)
    local distance = Drawing.new("Text")
    distance.Text = "0m"
    distance.Color = color or Color3.fromRGB(255, 255, 255)
    distance.Size = 12
    distance.Font = Drawing.Fonts.System
    distance.Outline = true
    distance.Center = true
    distance.Visible = true
    self.objects.distance = distance
    return self
end

function PressureEsp:AddGlow(color, size)
    local glow = Drawing.new("Square")
    glow.Color = color or Color3.fromRGB(255, 255, 255)
    glow.Thickness = size or 8
    glow.Filled = false
    glow.Visible = true
    self.objects.glow = glow
    return self
end

function PressureEsp:SetFont(fontIndex)
    for _, obj in pairs(self.objects) do
        if obj:IsA("Text") then
            obj.Font = fontIndex or Drawing.Fonts.System
        end
    end
    return self
end

function PressureEsp:Destroy()
    for _, obj in pairs(self.objects) do
        obj:Remove()
    end
    for i, esp in ipairs(espInstances) do
        if esp == self then
            table.remove(espInstances, i)
            break
        end
    end
end

function PressureEsp:startLoop()
    coroutine.wrap(function()
        while running and #espInstances > 0 do
            for _, esp in ipairs(espInstances) do
                if esp.instance and esp.instance.Parent then
                    local pos = getPosition(esp.instance)
                    if pos then
                        local screenPos, onScreen = WorldToScreen(pos)
                        if onScreen then
                            local camera = workspace.CurrentCamera
                            local dist = (camera.Position - pos).Magnitude
                            
                            if esp.objects.esp then
                                local size = math.max(30, 100 - dist/10)
                                esp.objects.esp.Position = Vector2.new(screenPos.X - size/2, screenPos.Y - size/2)
                                esp.objects.esp.Size = Vector2.new(size, size)
                            end
                            
                            if esp.objects.glow then
                                local glowSize = math.max(40, 120 - dist/10)
                                esp.objects.glow.Position = Vector2.new(screenPos.X - glowSize/2, screenPos.Y - glowSize/2)
                                esp.objects.glow.Size = Vector2.new(glowSize, glowSize)
                            end
                            
                            if esp.objects.title then
                                esp.objects.title.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                            end
                            
                            if esp.objects.distance then
                                esp.objects.distance.Position = Vector2.new(screenPos.X, screenPos.Y + 20)
                                esp.objects.distance.Text = math.floor(dist) .. "m"
                            end
                        else
                            if esp.objects.esp then esp.objects.esp.Visible = false end
                            if esp.objects.glow then esp.objects.glow.Visible = false end
                            if esp.objects.title then esp.objects.title.Visible = false end
                            if esp.objects.distance then esp.objects.distance.Visible = false end
                        end
                    end
                else
                    esp:Destroy()
                end
            end
            task.wait(0.03)
        end
        running = false
    end)()
end

function PressureEsp:StopAll()
    for _, esp in ipairs(espInstances) do
        esp:Destroy()
    end
    espInstances = {}
    running = false
end

return PressureEsp
