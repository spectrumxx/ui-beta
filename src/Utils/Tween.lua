--[[
    SpectrumX Tween Utility
    Sistema de animações suaves
--]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Tween = {}

-- Configurações padrão
Tween.DefaultDuration = 0.2
Tween.DefaultEasing = Enum.EasingStyle.Quad
Tween.DefaultDirection = Enum.EasingDirection.Out

-- ─── CRIAR TWEEN SIMPLES ──────────────────────────────────────────────────────
function Tween:Create(object, properties, duration, easingStyle, easingDirection)
    if not object or not object.Parent then return nil end
    
    duration = duration or self.DefaultDuration
    easingStyle = easingStyle or self.DefaultEasing
    easingDirection = easingDirection or self.DefaultDirection
    
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle,
        easingDirection
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    return tween
end

-- ─── PLAY TWEEN ───────────────────────────────────────────────────────────────
function Tween:Play(object, properties, duration, easingStyle, easingDirection)
    local tween = self:Create(object, properties, duration, easingStyle, easingDirection)
    if tween then
        tween:Play()
        return tween
    end
    return nil
end

-- ─── TWEEN COM CALLBACK ───────────────────────────────────────────────────────
function Tween:PlayWithCallback(object, properties, duration, callback, easingStyle, easingDirection)
    local tween = self:Create(object, properties, duration, easingStyle, easingDirection)
    if tween then
        if callback then
            tween.Completed:Connect(callback)
        end
        tween:Play()
        return tween
    end
    return nil
end

-- ─── TWEEN DE NÚMERO (PARA VALORES) ───────────────────────────────────────────
function Tween:Number(startValue, endValue, duration, callback, easingStyle, easingDirection)
    duration = duration or self.DefaultDuration
    easingStyle = easingStyle or self.DefaultEasing
    easingDirection = easingDirection or self.DefaultDirection
    
    local startTime = tick()
    local connection
    
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        
        -- Aplicar easing
        local easedProgress = self:ApplyEasing(progress, easingStyle, easingDirection)
        
        -- Interpolar valor
        local currentValue = startValue + (endValue - startValue) * easedProgress
        
        if callback then
            callback(currentValue)
        end
        
        if progress >= 1 then
            connection:Disconnect()
        end
    end)
    
    return connection
end

-- ─── APLICAR EASING ───────────────────────────────────────────────────────────
function Tween:ApplyEasing(progress, style, direction)
    -- Easing functions simplificadas
    if style == Enum.EasingStyle.Linear then
        return progress
    elseif style == Enum.EasingStyle.Quad then
        if direction == Enum.EasingDirection.In then
            return progress * progress
        elseif direction == Enum.EasingDirection.Out then
            return 1 - (1 - progress) * (1 - progress)
        else -- InOut
            if progress < 0.5 then
                return 2 * progress * progress
            else
                return 1 - math.pow(-2 * progress + 2, 2) / 2
            end
        end
    elseif style == Enum.EasingStyle.Cubic then
        if direction == Enum.EasingDirection.In then
            return progress * progress * progress
        elseif direction == Enum.EasingDirection.Out then
            return 1 - math.pow(1 - progress, 3)
        else -- InOut
            if progress < 0.5 then
                return 4 * progress * progress * progress
            else
                return 1 - math.pow(-2 * progress + 2, 3) / 2
            end
        end
    elseif style == Enum.EasingStyle.Back then
        local c1 = 1.70158
        local c3 = c1 + 1
        if direction == Enum.EasingDirection.In then
            return c3 * progress * progress * progress - c1 * progress * progress
        elseif direction == Enum.EasingDirection.Out then
            return 1 + c3 * math.pow(progress - 1, 3) + c1 * math.pow(progress - 1, 2)
        else -- InOut
            local c2 = c1 * 1.525
            if progress < 0.5 then
                return (math.pow(2 * progress, 2) * ((c2 + 1) * 2 * progress - c2)) / 2
            else
                return (math.pow(2 * progress - 2, 2) * ((c2 + 1) * (progress * 2 - 2) + c2) + 2) / 2
            end
        end
    elseif style == Enum.EasingStyle.Elastic then
        if direction == Enum.EasingDirection.Out then
            local c4 = (2 * math.pi) / 3
            if progress == 0 then return 0 end
            if progress == 1 then return 1 end
            return math.pow(2, -10 * progress) * math.sin((progress * 10 - 0.75) * c4) + 1
        end
    end
    
    return progress
end

-- ─── SPRING TWEEN ─────────────────────────────────────────────────────────────
function Tween:Spring(object, targetValue, speed, damping)
    speed = speed or 10
    damping = damping or 0.8
    
    local currentValue = object.Position
    local velocity = Vector2.new(0, 0)
    local connection
    
    connection = RunService.RenderStepped:Connect(function(dt)
        local displacement = Vector2.new(
            targetValue.X.Offset - currentValue.X.Offset,
            targetValue.Y.Offset - currentValue.Y.Offset
        )
        
        local force = displacement * speed
        velocity = (velocity + force * dt) * damping
        currentValue = UDim2.new(
            currentValue.X.Scale,
            currentValue.X.Offset + velocity.X * dt,
            currentValue.Y.Scale,
            currentValue.Y.Offset + velocity.Y * dt
        )
        
        object.Position = currentValue
        
        if displacement.Magnitude < 0.5 and velocity.Magnitude < 0.5 then
            object.Position = targetValue
            connection:Disconnect()
        end
    end)
    
    return connection
end

-- ─── SEQUENCE TWEEN ───────────────────────────────────────────────────────────
function Tween:Sequence(tweens)
    local currentIndex = 1
    
    local function playNext()
        if currentIndex > #tweens then return end
        
        local tweenData = tweens[currentIndex]
        currentIndex = currentIndex + 1
        
        local tween = self:PlayWithCallback(
            tweenData.object,
            tweenData.properties,
            tweenData.duration,
            function()
                if tweenData.callback then
                    tweenData.callback()
                end
                playNext()
            end,
            tweenData.easingStyle,
            tweenData.easingDirection
        )
    end
    
    playNext()
end

-- ─── PARALLEL TWEEN ───────────────────────────────────────────────────────────
function Tween:Parallel(tweens)
    for _, tweenData in ipairs(tweens) do
        self:Play(
            tweenData.object,
            tweenData.properties,
            tweenData.duration,
            tweenData.easingStyle,
            tweenData.easingDirection
        )
    end
end

-- ─── SHAKE EFFECT ─────────────────────────────────────────────────────────────
function Tween:Shake(object, intensity, duration)
    intensity = intensity or 10
    duration = duration or 0.5
    
    local originalPosition = object.Position
    local startTime = tick()
    local connection
    
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        
        if elapsed >= duration then
            object.Position = originalPosition
            connection:Disconnect()
            return
        end
        
        local decay = 1 - (elapsed / duration)
        local offsetX = (math.random() - 0.5) * intensity * decay
        local offsetY = (math.random() - 0.5) * intensity * decay
        
        object.Position = UDim2.new(
            originalPosition.X.Scale,
            originalPosition.X.Offset + offsetX,
            originalPosition.Y.Scale,
            originalPosition.Y.Offset + offsetY
        )
    end)
    
    return connection
end

-- ─── PULSE EFFECT ─────────────────────────────────────────────────────────────
function Tween:Pulse(object, minScale, maxScale, duration)
    minScale = minScale or 1
    maxScale = maxScale or 1.05
    duration = duration or 0.5
    
    local originalSize = object.Size
    local startTime = tick()
    local connection
    
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local progress = (elapsed % duration) / duration
        
        -- Onda senoidal
        local scale = minScale + (maxScale - minScale) * (0.5 + 0.5 * math.sin(progress * math.pi * 2))
        
        object.Size = UDim2.new(
            originalSize.X.Scale * scale,
            originalSize.X.Offset * scale,
            originalSize.Y.Scale * scale,
            originalSize.Y.Offset * scale
        )
    end)
    
    return connection
end

-- ─── STOP ALL TWEENS ──────────────────────────────────────────────────────────
function Tween:Stop(object)
    for _, child in ipairs(object:GetDescendants()) do
        if child:IsA("Tween"] then
            child:Cancel()
        end
    end
end

return Tween
