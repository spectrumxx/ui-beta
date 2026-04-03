--[[
    SpectrumX Utils Module
    Módulo de utilitários da UI Library
--]]

local Utils = {}

-- Carregar submódulos
Utils.Tween = require(script.Tween)
Utils.Event = require(script.Event)
Utils.Responsive = require(script.Responsive)

-- ─── CRIAR UICORNER ───────────────────────────────────────────────────────────
function Utils:CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 8)
    corner.Parent = parent
    return corner
end

-- ─── CRIAR UIStroke ───────────────────────────────────────────────────────────
function Utils:CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(39, 39, 42)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- ─── CRIAR UIGradient ─────────────────────────────────────────────────────────
function Utils:CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(color1 or Color3.new(1, 1, 1), color2 or Color3.new(0, 0, 0))
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

-- ─── CRIAR UISizeConstraint ───────────────────────────────────────────────────
function Utils:CreateSizeConstraint(parent, minSize, maxSize)
    local constraint = Instance.new("UISizeConstraint")
    constraint.MinSize = minSize or Vector2.new(0, 0)
    constraint.MaxSize = maxSize or Vector2.new(math.huge, math.huge)
    constraint.Parent = parent
    return constraint
end

-- ─── CRIAR UIAspectRatioConstraint ────────────────────────────────────────────
function Utils:CreateAspectRatio(parent, ratio)
    local constraint = Instance.new("UIAspectRatioConstraint")
    constraint.AspectRatio = ratio or 1
    constraint.Parent = parent
    return constraint
end

-- ─── CRIAR UIPadding ──────────────────────────────────────────────────────────
function Utils:CreatePadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.Parent = parent
    return padding
end

-- ─── CRIAR UIListLayout ───────────────────────────────────────────────────────
function Utils:CreateListLayout(parent, padding, direction)
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, padding or 8)
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.Parent = parent
    return layout
end

-- ─── CRIAR UIGridLayout ───────────────────────────────────────────────────────
function Utils:CreateGridLayout(parent, cellSize, padding)
    local layout = Instance.new("UIGridLayout")
    layout.CellSize = cellSize or UDim2.new(0, 100, 0, 100)
    layout.CellPadding = padding or UDim2.new(0, 8, 0, 8)
    layout.Parent = parent
    return layout
end

-- ─── CRIAR UIPageLayout ───────────────────────────────────────────────────────
function Utils:CreatePageLayout(parent)
    local layout = Instance.new("UIPageLayout")
    layout.Animated = true
    layout.Circular = false
    layout.EasingDirection = Enum.EasingDirection.Out
    layout.EasingStyle = Enum.EasingStyle.Quad
    layout.Padding = UDim.new(0, 0)
    layout.TweenTime = 0.3
    layout.Parent = parent
    return layout
end

-- ─── VERIFICAR SE É ASSET ID ──────────────────────────────────────────────────
function Utils:IsAssetId(value)
    if type(value) ~= "string" then return false end
    return value:match("^rbxassetid://") ~= nil or value:match("^%d+$") ~= nil
end

-- ─── FORMATAR ASSET ID ────────────────────────────────────────────────────────
function Utils:FormatAssetId(value)
    if type(value) == "number" then
        return "rbxassetid://" .. value
    elseif type(value) == "string" then
        if value:match("^rbxassetid://") then
            return value
        elseif value:match("^%d+$") then
            return "rbxassetid://" .. value
        end
    end
    return nil
end

-- ─── CLAMP ────────────────────────────────────────────────────────────────────
function Utils:Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- ─── LERP ─────────────────────────────────────────────────────────────────────
function Utils:Lerp(a, b, t)
    return a + (b - a) * t
end

-- ─── MAP RANGE ────────────────────────────────────────────────────────────────
function Utils:MapRange(value, inMin, inMax, outMin, outMax)
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

-- ─── ROUND ────────────────────────────────────────────────────────────────────
function Utils:Round(value, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(value * mult + 0.5) / mult
end

-- ─── FORMATAR TEMPO ───────────────────────────────────────────────────────────
function Utils:FormatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d", mins, secs)
end

-- ─── FORMATAR NÚMERO ──────────────────────────────────────────────────────────
function Utils:FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    end
    return tostring(num)
end

-- ─── DEBOUNCE ─────────────────────────────────────────────────────────────────
function Utils:Debounce(func, delay)
    delay = delay or 0.1
    local canRun = true
    
    return function(...)
        if not canRun then return end
        canRun = false
        func(...)
        task.delay(delay, function()
            canRun = true
        end)
    end
end

-- ─── THROTTLE ─────────────────────────────────────────────────────────────────
function Utils:Throttle(func, interval)
    interval = interval or 0.1
    local lastRun = 0
    
    return function(...)
        local now = tick()
        if now - lastRun >= interval then
            lastRun = now
            func(...)
        end
    end
end

-- ─── DELAYED CALL ─────────────────────────────────────────────────────────────
function Utils:Delay(seconds, callback)
    task.delay(seconds, callback)
end

-- ─── REPEAT CALL ──────────────────────────────────────────────────────────────
function Utils:RepeatCall(interval, callback, count)
    local current = 0
    
    local function loop()
        if count and current >= count then return end
        current = current + 1
        callback(current)
        task.delay(interval, loop)
    end
    
    loop()
end

return Utils
