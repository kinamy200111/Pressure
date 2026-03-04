-- ESP Library для Matcha
local ESPLib = {}

local espObjects = {}
local running = false

local function getPosition(instance)
    if instance.Position then return instance.Position end
    for _, child in ipairs(instance:GetChildren()) do
        local pos = getPosition(child)
        if pos then return pos end
    end
    return nil
end

function ESPLib.start(types)
    if running then return end
    running = true
    
    types = types or {}
    
    local colors = {}
    for name, color in pairs(types) do
        colors[name] = color
    end
    
    local function createESP(obj, objType)
        if espObjects[obj] then return end
        local text = Drawing.new("Text")
        text.Text = objType
        text.Color = colors[objType] or Color3.fromRGB(255, 255, 255)
        text.Size = 16
        text.Font = Drawing.Fonts.SystemBold
        text.Outline = true
        text.Center = true
        text.Visible = true
        espObjects[obj] = text
    end
    
    local function scan()
        local descendants = workspace:GetDescendants()
        for _, obj in ipairs(descendants) do
            local attr = obj:GetAttribute("InteractionType")
            if attr and colors[attr] and not espObjects[obj] then
                createESP(obj, attr)
            end
        end
    end
    
    local function update()
        for obj, text in pairs(espObjects) do
            if obj and obj.Parent then
                local attr = obj:GetAttribute("InteractionType")
                if not attr or not colors[attr] then
                    text:Remove()
                    espObjects[obj] = nil
                else
                    local pos = getPosition(obj)
                    if pos then
                        local screenPos, onScreen = WorldToScreen(pos)
                        if onScreen then
                            text.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                            text.Visible = true
                        else
                            text.Visible = false
                        end
                    else
                        text.Visible = false
                    end
                end
            else
                text:Remove()
                espObjects[obj] = nil
            end
        end
    end
    
    scan()
    
    coroutine.wrap(function()
        while running do
            update()
            if tick() % 2 < 0.03 then scan() end
            task.wait(0.03)
        end
    end)()
end

function ESPLib.stop()
    running = false
    for _, text in pairs(espObjects) do
        text:Remove()
    end
    espObjects = {}
end

function ESPLib.count()
    local count = 0
    for _ in pairs(espObjects) do count = count + 1 end
    return count
end

return ESPLib
