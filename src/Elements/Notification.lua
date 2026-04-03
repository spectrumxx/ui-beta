--[[
    SpectrumX Notification Element
    Sistema de notificações toast
--]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Notification = {}

-- Estado
Notification.ScreenGui = nil
Notification.ActiveNotifications = {}
Notification.MaxNotifications = 5
Notification.NotificationHeight = 70
Notification.NotificationSpacing = 10
Notification.DefaultDuration = 5

-- ─── INICIALIZAR ──────────────────────────────────────────────────────────────
function Notification:Init(parent)
    self.ScreenGui = parent
end

-- ─── CRIAR NOTIFICAÇÃO ────────────────────────────────────────────────────────
function Notification:New(config)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    
    local title = config.Title or "Notificação"
    local content = config.Content or ""
    local subContent = config.SubContent or nil
    local duration = config.Duration or self.DefaultDuration
    local type = config.Type or "Info" -- Info, Success, Warning, Error
    
    -- Determinar cor baseada no tipo
    local accentColor = Theme.Accent
    if type == "Success" then
        accentColor = Theme.Success
    elseif type == "Warning" then
        accentColor = Theme.Warning
    elseif type == "Error" then
        accentColor = Theme.Error
    elseif type == "Info" then
        accentColor = Theme.Info
    end
    
    -- Container da notificação
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.BackgroundColor3 = Theme.Surface
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, 20, 1, -100)
    notification.Size = UDim2.new(0, 300, 0, subContent and 85 or 70)
    notification.ZIndex = 1000
    notification.Parent = self.ScreenGui
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    -- Borda de destaque
    local stroke = Instance.new("UIStroke")
    stroke.Color = accentColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = notification
    
    -- Gradiente de fundo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Surface),
        ColorSequenceKeypoint.new(1, Theme.SurfaceElevated)
    })
    gradient.Rotation = 90
    gradient.Parent = notification
    
    -- Barra de progresso
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.BackgroundColor3 = accentColor
    progressBar.BorderSizePixel = 0
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.ZIndex = 1002
    progressBar.Parent = notification
    
    -- Indicador de tipo (barra lateral)
    local typeIndicator = Instance.new("Frame")
    typeIndicator.Name = "TypeIndicator"
    typeIndicator.BackgroundColor3 = accentColor
    typeIndicator.BorderSizePixel = 0
    typeIndicator.Position = UDim2.new(0, 0, 0, 0)
    typeIndicator.Size = UDim2.new(0, 4, 1, 0)
    typeIndicator.ZIndex = 1001
    typeIndicator.Parent = notification
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 10)
    indicatorCorner.Parent = typeIndicator
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 16, 0, 10)
    titleLabel.Size = UDim2.new(1, -32, 0, 18)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 1001
    titleLabel.Parent = notification
    
    -- Conteúdo
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.BackgroundTransparency = 1
    contentLabel.Position = UDim2.new(0, 16, 0, 30)
    contentLabel.Size = UDim2.new(1, -32, 0, subContent and 20 or 30)
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.Text = content
    contentLabel.TextColor3 = Theme.TextSecondary
    contentLabel.TextSize = 12
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.ZIndex = 1001
    contentLabel.Parent = notification
    
    -- Sub-conteúdo (opcional)
    if subContent then
        local subContentLabel = Instance.new("TextLabel")
        subContentLabel.Name = "SubContent"
        subContentLabel.BackgroundTransparency = 1
        subContentLabel.Position = UDim2.new(0, 16, 0, 52)
        subContentLabel.Size = UDim2.new(1, -32, 0, 25)
        subContentLabel.Font = Enum.Font.Gotham
        subContentLabel.Text = subContent
        subContentLabel.TextColor3 = Theme.TextMuted
        subContentLabel.TextSize = 11
        subContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        subContentLabel.TextWrapped = true
        subContentLabel.ZIndex = 1001
        subContentLabel.Parent = notification
    end
    
    -- Botão fechar (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -24, 0, 6)
    closeBtn.Size = UDim2.new(0, 18, 0, 18)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.TextMuted
    closeBtn.TextSize = 16
    closeBtn.ZIndex = 1002
    closeBtn.Parent = notification
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            TextColor3 = Theme.Error
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            TextColor3 = Theme.TextMuted
        }):Play()
    end)
    
    -- Gerenciar posição
    local index = #self.ActiveNotifications + 1
    table.insert(self.ActiveNotifications, 1, notification)
    
    -- Remover notificações antigas se exceder o máximo
    while #self.ActiveNotifications > self.MaxNotifications do
        local old = table.remove(self.ActiveNotifications)
        if old and old.Parent then
            old:Destroy()
        end
    end
    
    -- Atualizar posições
    self:UpdatePositions()
    
    -- Animação de entrada
    notification.Position = UDim2.new(1, 20, 1, -100)
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -((index * (self.NotificationHeight + self.NotificationSpacing)) + 20))
    }):Play()
    
    -- Animação da barra de progresso
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    }):Play()
    
    -- Função de fechar
    local function closeNotification()
        -- Remover da lista
        for i, notif in ipairs(self.ActiveNotifications) do
            if notif == notification then
                table.remove(self.ActiveNotifications, i)
                break
            end
        end
        
        -- Animação de saída
        TweenService:Create(notification, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, notification.Position.Y.Scale, notification.Position.Y.Offset)
        }):Play()
        
        task.delay(0.2, function()
            if notification and notification.Parent then
                notification:Destroy()
            end
            self:UpdatePositions()
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(closeNotification)
    
    -- Auto-fechar após duração
    task.delay(duration, function()
        if notification and notification.Parent then
            closeNotification()
        end
    end)
    
    -- Retornar objeto da notificação
    local notificationObj = {
        Frame = notification,
        Close = closeNotification
    }
    
    return notificationObj
end

-- ─── ATUALIZAR POSIÇÕES ───────────────────────────────────────────────────────
function Notification:UpdatePositions()
    for i, notification in ipairs(self.ActiveNotifications) do
        if notification and notification.Parent then
            local targetY = -((i * (self.NotificationHeight + self.NotificationSpacing)) + 20)
            TweenService:Create(notification, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -320, 1, targetY)
            }):Play()
        end
    end
end

-- ─── LIMPAR TODAS ─────────────────────────────────────────────────────────────
function Notification:ClearAll()
    for _, notification in ipairs(self.ActiveNotifications) do
        if notification and notification.Parent then
            notification:Destroy()
        end
    end
    self.ActiveNotifications = {}
end

return Notification
