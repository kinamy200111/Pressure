-- Minimal ESP Library for Matcha
local ESP = {}

local espObjects = {}
local running = false
local types = {}
local config = {
    offset = -30,
    textSize = 16,
    outline = true
}

local function getPosition(instance)
    if instance.Position then
        return instance.Position
    end
    for _, child in ipairs(instance:GetChildren()) do
        local pos = getPosition(child)
        if pos then return pos end
    end
    return nil
end

local function getObjectType(instance)
    local success, attr = pcall(function()
        return instance:GetAttribute("InteractionType")
    end)
    return success and attr or nil
end

function ESP.AddType(name, settings)
    types[name] = {
        color = settings.color or Color3.fromRGB(255, 255, 255),
        displayName = settings.displayName or name,
        enabled = true
    }
end

function ESP.SetOffset(offset)
    config.offset = offset or -30
end

function ESP.SetTextSize(size)
    config.textSize = size or 16
end

function ESP.SetOutline(outline)
    config.outline = outline ~= false
end

function ESP.Start()
    if running then return end
    running = true
    
    local function scan()
        local descendants = workspace:GetDescendants()
        for _, obj in ipairs(descendants) do
            local objType = getObjectType(obj)
            if objType and types[objType] and not espObjects[obj] then
                local text = Drawing.new("Text")
                text.Text = types[objType].displayName
                text.Color = types[objType].color
                text.Size = config.textSize
                text.Font = Drawing.Fonts.SystemBold
                text.Outline = config.outline
                text.Center = true
                text.Visible = true
                espObjects[obj] = text
            end
        end
    end
    
    local function update()
        for obj, text in pairs(espObjects) do
            if obj and obj.Parent then
                local pos = getPosition(obj)
                if pos then
                    local screenPos, onScreen = WorldToScreen(pos)
                    if onScreen then
                        text.Position = Vector2.new(screenPos.X, screenPos.Y + config.offset)
                        text.Visible = true
                    else
                        text.Visible = false
                    end
                else
                    text.Visible = false
                end
            else
                text:Remove()
                espObjects[obj] = nil
            end
        end
    end
    
    local function cleanup()
        for obj, text in pairs(espObjects) do
            local objType = getObjectType(obj)
            if not objType or not types[objType] then
                text:Remove()
                espObjects[obj] = nil
            end
        end
    end
    
    scan()
    
    coroutine.wrap(function()
        while running do
            update()
            if tick() % 2 < 0.03 then
                scan()
                cleanup()
            end
            task.wait(0.03)
        end
    end)()
end

function ESP.Stop()
    running = false
    for _, text in pairs(espObjects) do
        text:Remove()
    end
    espObjects = {}
end

return ESP
