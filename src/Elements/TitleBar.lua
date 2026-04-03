--[[
    SpectrumX TitleBar Element
    Barra de título da janela com controles
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local TitleBar = {}

-- ─── CRIAR TITLEBAR ───────────────────────────────────────────────────────────
function TitleBar:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local TitleBarElement = {}
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = "TitleBar"
    frame.BackgroundColor3 = Theme.Header or Color3.fromRGB(12, 12, 12)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.ZIndex = 100
    frame.Parent = parent
    
    -- Cantos arredondados (apenas em cima)
    -- Usar um frame de clip para simular cantos arredondados apenas no topo
    
    -- Gradiente sutil
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Header or Color3.fromRGB(12, 12, 12)),
        ColorSequenceKeypoint.new(1, Theme.Surface or Color3.fromRGB(18, 18, 18))
    })
    gradient.Rotation = 90
    gradient.Parent = frame
    
    -- Ícone (opcional)
    local iconOffset = 12
    if config.Icon then
        local iconFrame = Instance.new("Frame")
        iconFrame.Name = "IconFrame"
        iconFrame.BackgroundColor3 = Theme.Accent
        iconFrame.BorderSizePixel = 0
        iconFrame.Position = UDim2.new(0, 12, 0.5, -12)
        iconFrame.Size = UDim2.new(0, 24, 0, 24)
        iconFrame.ZIndex = 101
        iconFrame.Parent = frame
        
        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(0, 6)
        iconCorner.Parent = iconFrame
        
        -- Verificar se é Asset ID
        local Utils = require(script.Parent.Parent.Utils)
        if Utils:IsAssetId(config.Icon) then
            local iconImg = Instance.new("ImageLabel")
            iconImg.Name = "IconImage"
            iconImg.BackgroundTransparency = 1
            iconImg.Size = UDim2.new(1, 0, 1, 0)
            iconImg.Image = Utils:FormatAssetId(config.Icon)
            iconImg.ZIndex = 102
            iconImg.Parent = iconFrame
        else
            local iconLabel = Instance.new("TextLabel")
            iconLabel.Name = "IconLabel"
            iconLabel.BackgroundTransparency = 1
            iconLabel.Size = UDim2.new(1, 0, 1, 0)
            iconLabel.Font = Enum.Font.GothamBold
            iconLabel.Text = config.Icon:sub(1, 1)
            iconLabel.TextColor3 = Color3.new(1, 1, 1)
            iconLabel.TextSize = 14
            iconLabel.ZIndex = 102
            iconLabel.Parent = iconFrame
        end
        
        iconOffset = 44
    end
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, iconOffset, 0, 0)
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = config.Title or "SpectrumX"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 101
    titleLabel.Parent = frame
    
    -- Subtítulo (opcional)
    if config.SubTitle then
        titleLabel.Size = UDim2.new(0, 200, 0, 26)
        titleLabel.Position = UDim2.new(0, iconOffset, 0, 2)
        
        local subtitleLabel = Instance.new("TextLabel")
        subtitleLabel.Name = "SubTitle"
        subtitleLabel.BackgroundTransparency = 1
        subtitleLabel.Position = UDim2.new(0, iconOffset, 0, 26)
        subtitleLabel.Size = UDim2.new(0, 200, 0, 18)
        subtitleLabel.Font = Enum.Font.Gotham
        subtitleLabel.Text = config.SubTitle
        subtitleLabel.TextColor3 = Theme.TextMuted
        subtitleLabel.TextSize = 11
        subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtitleLabel.ZIndex = 101
        subtitleLabel.Parent = frame
    end
    
    -- Botões de controle
    local buttonY = 0.5
    local buttonSize = UDim2.new(0, 28, 0, 24)
    
    -- Botão Minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Position = UDim2.new(1, -72, buttonY, -12)
    minimizeBtn.Size = buttonSize
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = Theme.TextMuted
    minimizeBtn.TextSize = 12
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.ZIndex = 101
    minimizeBtn.Parent = frame
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = minimizeBtn
    
    -- Botão Fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(1, -38, buttonY, -12)
    closeBtn.Size = buttonSize
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.TextMuted
    closeBtn.TextSize = 16
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 101
    closeBtn.Parent = frame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    -- Hover effects
    minimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.Accent,
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            TextColor3 = Theme.TextMuted
        }):Play()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.Error,
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            TextColor3 = Theme.TextMuted
        }):Play()
    end)
    
    -- Eventos
    if config.Window then
        minimizeBtn.MouseButton1Click:Connect(function()
            config.Window:Minimize()
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            config.Window:Destroy()
        end)
    end
    
    -- Referências
    TitleBarElement.Frame = frame
    TitleBarElement.TitleLabel = titleLabel
    TitleBarElement.MinimizeBtn = minimizeBtn
    TitleBarElement.CloseBtn = closeBtn
    
    -- Métodos
    function TitleBarElement:SetTitle(text)
        titleLabel.Text = text
    end
    
    function TitleBarElement:SetSubTitle(text)
        local subtitle = frame:FindFirstChild("SubTitle")
        if subtitle then
            subtitle.Text = text
        end
    end
    
    function TitleBarElement:Destroy()
        frame:Destroy()
    end
    
    return TitleBarElement
end

return TitleBar
