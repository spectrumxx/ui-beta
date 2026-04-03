--[[
    SpectrumX Event Utility
    Sistema de gerenciamento de eventos customizados
--]]

local Event = {}

-- Armazenamento de eventos
Event.Connections = {}
Event.Listeners = {}

-- ─── CONectar EVENTO ──────────────────────────────────────────────────────────
function Event:Connect(signal, callback)
    if not signal or not callback then return nil end
    
    local connection = signal:Connect(callback)
    table.insert(self.Connections, connection)
    
    return connection
end

-- ─── DESCONECTAR EVENTO ───────────────────────────────────────────────────────
function Event:Disconnect(connection)
    if connection then
        connection:Disconnect()
        for i, conn in ipairs(self.Connections) do
            if conn == connection then
                table.remove(self.Connections, i)
                break
            end
        end
    end
end

-- ─── DESCONECTAR TODOS ────────────────────────────────────────────────────────
function Event:DisconnectAll()
    for _, connection in ipairs(self.Connections) do
        if connection then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    self.Connections = {}
end

-- ─── REGISTRAR LISTENER CUSTOMIZADO ───────────────────────────────────────────
function Event:On(eventName, callback)
    if not self.Listeners[eventName] then
        self.Listeners[eventName] = {}
    end
    
    table.insert(self.Listeners[eventName], callback)
    
    -- Retornar função para remover listener
    return function()
        self:Off(eventName, callback)
    end
end

-- ─── REMOVER LISTENER ─────────────────────────────────────────────────────────
function Event:Off(eventName, callback)
    if not self.Listeners[eventName] then return end
    
    for i, cb in ipairs(self.Listeners[eventName]) do
        if cb == callback then
            table.remove(self.Listeners[eventName], i)
            break
        end
    end
end

-- ─── DISPARAR EVENTO ──────────────────────────────────────────────────────────
function Event:Trigger(eventName, ...)
    if not self.Listeners[eventName] then return end
    
    for _, callback in ipairs(self.Listeners[eventName]) do
        task.spawn(function(...)
            local success, err = pcall(callback, ...)
            if not success then
                warn("[SpectrumX Event Error] " .. tostring(err))
            end
        end, ...)
    end
end

-- ─── ONCE (DISPARAR APENAS UMA VEZ) ───────────────────────────────────────────
function Event:Once(eventName, callback)
    local function wrapper(...)
        self:Off(eventName, wrapper)
        callback(...)
    end
    
    return self:On(eventName, wrapper)
end

-- ─── INPUT BEGAN HELPER ───────────────────────────────────────────────────────
function Event:OnInputBegan(inputType, callback)
    local UserInputService = game:GetService("UserInputService")
    
    return self:Connect(UserInputService.InputBegan, function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == inputType then
            callback(input)
        end
    end)
end

-- ─── INPUT ENDED HELPER ───────────────────────────────────────────────────────
function Event:OnInputEnded(inputType, callback)
    local UserInputService = game:GetService("UserInputService")
    
    return self:Connect(UserInputService.InputEnded, function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == inputType then
            callback(input)
        end
    end)
end

-- ─── KEY PRESSED HELPER ───────────────────────────────────────────────────────
function Event:OnKeyPressed(keyCode, callback)
    local UserInputService = game:GetService("UserInputService")
    
    return self:Connect(UserInputService.InputBegan, function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == keyCode then
            callback(input)
        end
    end)
end

-- ─── MOUSE CLICK HELPER ───────────────────────────────────────────────────────
function Event:OnClick(object, callback)
    return self:Connect(object.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            callback(input)
        end
    end)
end

-- ─── HOVER HELPER ─────────────────────────────────────────────────────────────
function Event:OnHover(object, onEnter, onLeave)
    local connections = {}
    
    table.insert(connections, self:Connect(object.MouseEnter, function()
        if onEnter then onEnter() end
    end))
    
    table.insert(connections, self:Connect(object.MouseLeave, function()
        if onLeave then onLeave() end
    end))
    
    return connections
end

-- ─── PROPERTY CHANGED HELPER ──────────────────────────────────────────────────
function Event:OnPropertyChanged(object, property, callback)
    return self:Connect(object:GetPropertyChangedSignal(property), function()
        callback(object[property])
    end)
end

-- ─── VIEWPORT SIZE CHANGED ────────────────────────────────────────────────────
function Event:OnViewportSizeChanged(callback)
    local camera = workspace.CurrentCamera
    if camera then
        return self:Connect(camera:GetPropertyChangedSignal("ViewportSize"), function()
            callback(camera.ViewportSize)
        end)
    end
    return nil
end

-- ─── DEBOUNCE ─────────────────────────────────────────────────────────────────
function Event:Debounce(callback, delay)
    delay = delay or 0.1
    local canRun = true
    
    return function(...)
        if not canRun then return end
        canRun = false
        
        callback(...)
        
        task.delay(delay, function()
            canRun = true
        end)
    end
end

-- ─── THROTTLE ─────────────────────────────────────────────────────────────────
function Event:Throttle(callback, interval)
    interval = interval or 0.1
    local lastRun = 0
    
    return function(...)
        local now = tick()
        if now - lastRun >= interval then
            lastRun = now
            callback(...)
        end
    end
end

return Event
