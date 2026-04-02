--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                         SpectrumX UI Library v2.1                        ║
    ║                    Professional UI Library for Roblox                    ║
    ╚══════════════════════════════════════════════════════════════════════════╝
    
    Melhorias na v2.1:
    - Notificações com barra de progresso corrigida (sem borda estranha)
    - Elementos mais compactos nas abas
    - Scroll mais suave e responsivo (PC e Mobile)
    - Suporte a ícones Lucide
    - Slider com input numérico clicável
    - Novo componente LabelToggle com label inferior
    - Ícone de dropdown customizável via Asset ID
    
    Uso:
        local SpectrumX = loadstring(readfile("path/to/SpectrumX.lua"))()
        local Window = SpectrumX:CreateWindow({Title = "Meu Script", Icon = "⭐"})
        local Tab = Window:CreateTab({Name = "Main", Icon = "rbxassetid://123456"})
--]]

local SpectrumX = {}
SpectrumX.__index = SpectrumX

-- ─── SERVIÇOS ─────────────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ─── THEME ────────────────────────────────────────────────────────────────────
SpectrumX.Theme = {
    -- Cores base
    Background = Color3.fromRGB(8, 8, 8),
    Header = Color3.fromRGB(12, 12, 12),
    Sidebar = Color3.fromRGB(10, 10, 10),
    Card = Color3.fromRGB(16, 16, 16),
    CardHover = Color3.fromRGB(24, 24, 24),
    Input = Color3.fromRGB(22, 22, 22),
    InputHover = Color3.fromRGB(30, 30, 30),
    
    -- Cores de destaque (vermelho)
    Accent = Color3.fromRGB(220, 35, 35),
    AccentHover = Color3.fromRGB(255, 55, 55),
    AccentSecondary = Color3.fromRGB(255, 100, 100),
    AccentDark = Color3.fromRGB(140, 20, 20),
    
    -- Texto
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(190, 190, 190),
    TextMuted = Color3.fromRGB(120, 120, 120),
    
    -- Estados
    Success = Color3.fromRGB(60, 220, 100),
    Warning = Color3.fromRGB(255, 190, 60),
    Info = Color3.fromRGB(80, 160, 255),
    Error = Color3.fromRGB(255, 55, 55),
    
    -- Bordas
    Border = Color3.fromRGB(35, 35, 35),
    BorderBright = Color3.fromRGB(55, 55, 55),
    
    -- Toggle
    ToggleOff = Color3.fromRGB(35, 35, 35),
    ToggleOn = Color3.fromRGB(220, 35, 35),
}

-- ─── CONFIGURAÇÕES ────────────────────────────────────────────────────────────
SpectrumX.Config = {
    AnimationSpeed = 0.2,
    CornerRadius = 8,
    ShadowEnabled = true,
    ShadowIntensity = 0.7,
}

-- ─── ÍCONES LUCIDE (MAPEAMENTO) ───────────────────────────────────────────────
-- Mapeamento de nomes de ícones Lucide para códigos Unicode/SVG simplificados
SpectrumX.LucideIcons = {
    -- Navegação
    ["home"] = "🏠",
    ["settings"] = "⚙️",
    ["user"] = "👤",
    ["users"] = "👥",
    ["menu"] = "☰",
    ["more-horizontal"] = "⋯",
    ["more-vertical"] = "⋮",
    ["chevron-left"] = "‹",
    ["chevron-right"] = "›",
    ["chevron-up"] = "▲",
    ["chevron-down"] = "▼",
    ["arrow-left"] = "←",
    ["arrow-right"] = "→",
    ["arrow-up"] = "↑",
    ["arrow-down"] = "↓",
    
    -- Ações
    ["plus"] = "+",
    ["minus"] = "−",
    ["x"] = "✕",
    ["check"] = "✓",
    ["search"] = "🔍",
    ["trash"] = "🗑️",
    ["edit"] = "✏️",
    ["copy"] = "📋",
    ["download"] = "⬇️",
    ["upload"] = "⬆️",
    ["refresh"] = "↻",
    ["rotate-cw"] = "↻",
    ["rotate-ccw"] = "↺",
    ["play"] = "▶️",
    ["pause"] = "⏸️",
    ["stop"] = "⏹️",
    ["skip-forward"] = "⏭️",
    ["skip-back"] = "⏮️",
    
    -- Estado
    ["eye"] = "👁️",
    ["eye-off"] = "🚫",
    ["lock"] = "🔒",
    ["unlock"] = "🔓",
    ["shield"] = "🛡️",
    ["shield-check"] = "✓",
    ["alert"] = "⚠️",
    ["alert-circle"] = "⚠️",
    ["alert-triangle"] = "⚠️",
    ["info"] = "ℹ️",
    ["help"] = "❓",
    ["check-circle"] = "✓",
    ["x-circle"] = "✕",
    
    -- Comunicação
    ["message"] = "💬",
    ["mail"] = "✉️",
    ["bell"] = "🔔",
    ["bell-off"] = "🔕",
    ["phone"] = "📞",
    
    -- Arquivos
    ["file"] = "📄",
    ["folder"] = "📁",
    ["image"] = "🖼️",
    ["video"] = "🎬",
    ["music"] = "🎵",
    
    -- Outros
    ["star"] = "⭐",
    ["heart"] = "❤️",
    ["zap"] = "⚡",
    ["flame"] = "🔥",
    ["moon"] = "🌙",
    ["sun"] = "☀️",
    ["cloud"] = "☁️",
    ["wifi"] = "📶",
    ["battery"] = "🔋",
    ["cpu"] = "💻",
    ["code"] = "</>",
    ["terminal"] = "⌨️",
    ["gamepad"] = "🎮",
    ["target"] = "🎯",
    ["crosshair"] = "⌖",
    ["map"] = "🗺️",
    ["compass"] = "🧭",
    ["clock"] = "🕐",
    ["calendar"] = "📅",
    ["save"] = "💾",
    ["share"] = "🔗",
    ["link"] = "🔗",
    ["external-link"] = "↗️",
    ["filter"] = "🔽",
    ["sliders"] = "⚙️",
    ["toggle-left"] = "◀️",
    ["toggle-right"] = "▶️",
    ["power"] = "⏻️",
}

-- ─── ESCALA RESPONSIVA ────────────────────────────────────────────────────────
local ScaleData = {
    IsMobile = false,
    ScaleFactor = 1,
    BaseResolution = Vector2.new(1920, 1080)
}

function SpectrumX:UpdateScale()
    local success, camera = pcall(function() return workspace.CurrentCamera end)
    if not success or not camera then return end
    
    local viewport = camera.ViewportSize
    if viewport.X == 0 then return end
    
    ScaleData.IsMobile = UserInputService.TouchEnabled and (viewport.X < 1200 or viewport.Y < 700)
    
    local scale = math.min(viewport.X / ScaleData.BaseResolution.X, viewport.Y / ScaleData.BaseResolution.Y)
    
    if ScaleData.IsMobile then
        ScaleData.ScaleFactor = math.clamp(scale, 0.85, 1.2)
    else
        ScaleData.ScaleFactor = math.clamp(scale, 0.7, 1.1)
    end
end

function SpectrumX:S(value)
    if type(value) == "number" then
        return math.floor(value * ScaleData.ScaleFactor)
    elseif typeof(value) == "UDim2" then
        return UDim2.new(
            value.X.Scale,
            math.floor(value.X.Offset * ScaleData.ScaleFactor),
            value.Y.Scale,
            math.floor(value.Y.Offset * ScaleData.ScaleFactor)
        )
    elseif typeof(value) == "UDim" then
        return UDim.new(value.Scale, math.floor(value.Offset * ScaleData.ScaleFactor))
    end
    return value
end

-- ─── UTILITÁRIOS BÁSICOS ──────────────────────────────────────────────────────
function SpectrumX:Tween(obj, props, time, style, direction)
    if not obj or not obj.Parent then return nil end
    
    local tweenInfo = TweenInfo.new(
        time or self.Config.AnimationSpeed,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

function SpectrumX:CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, self.Config.CornerRadius)
    corner.Parent = parent
    return corner
end

function SpectrumX:CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or self.Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

function SpectrumX:CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(color1 or Color3.new(1,1,1), color2 or Color3.new(0,0,0))
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

-- ─── SISTEMA DE SOMBRAS PROFISSIONAL ──────────────────────────────────────────
function SpectrumX:CreateShadow(parent, size, intensity)
    if not self.Config.ShadowEnabled then return nil end
    
    size = size or 20
    intensity = intensity or self.Config.ShadowIntensity
    
    local shadowFolder = Instance.new("Folder")
    shadowFolder.Name = "Shadow"
    shadowFolder.Parent = parent
    
    -- Múltiplas camadas para sombra suave
    local layers = 4
    for i = 1, layers do
        local layer = Instance.new("Frame")
        layer.Name = "Layer" .. i
        layer.AnchorPoint = Vector2.new(0.5, 0.5)
        layer.BackgroundColor3 = Color3.new(0, 0, 0)
        layer.BackgroundTransparency = intensity + ((1 - intensity) * (i / layers) * 0.5)
        layer.BorderSizePixel = 0
        layer.Position = UDim2.new(0.5, 0, 0.5, 0)
        layer.Size = UDim2.new(1, size + (i * 3), 1, size + (i * 3))
        layer.ZIndex = math.max(0, parent.ZIndex - 1)
        layer.Parent = shadowFolder
        self:CreateCorner(layer, UDim.new(0, (self.Config.CornerRadius or 8) + i))
    end
    
    return shadowFolder
end

-- ─── SOMBRA SIMPLES ───────────────────────────────────────────────────────────
function SpectrumX:CreateSimpleShadow(parent, size, transparency)
    if not self.Config.ShadowEnabled then return nil end
    
    local shadow = Instance.new("Frame")
    shadow.Name = "SimpleShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.75
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, size or 16, 1, size or 16)
    shadow.ZIndex = math.max(0, parent.ZIndex - 1)
    shadow.Parent = parent
    self:CreateCorner(shadow)
    
    return shadow
end

-- ─── DRAGGABLE ────────────────────────────────────────────────────────────────
function SpectrumX:MakeDraggable(frame, handle)
    handle = handle or frame
    
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ─── RIPPLE EFFECT ────────────────────────────────────────────────────────────
function SpectrumX:CreateRipple(parent, position)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.ZIndex = parent.ZIndex + 10
    
    -- Ripple menor (1.2x em vez de 1.5x)
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 1.2
    
    -- Posição inicial mais precisa
    local startX, startY
    if position then
        startX = position.X - parent.AbsolutePosition.X
        startY = position.Y - parent.AbsolutePosition.Y
    else
        startX = parent.AbsoluteSize.X / 2
        startY = parent.AbsoluteSize.Y / 2
    end
    
    ripple.Position = UDim2.new(0, startX, 0, startY)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Parent = parent
    self:CreateCorner(ripple, UDim.new(1, 0))
    
    -- Animar - expandir do centro
    self:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.4)
    
    task.delay(0.4, function()
        if ripple and ripple.Parent then
            ripple:Destroy()
        end
    end)
end

-- ─── HELPERS DE ÍCONE ─────────────────────────────────────────────────────────
function SpectrumX:IsAssetId(value)
    if type(value) ~= "string" then return false end
    return value:match("^rbxassetid://") ~= nil or value:match("^%d+$") ~= nil
end

function SpectrumX:FormatAssetId(value)
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

-- NOVO: Verificar se é ícone Lucide
function SpectrumX:IsLucideIcon(value)
    if type(value) ~= "string" then return false end
    return self.LucideIcons[value:lower()] ~= nil
end

-- NOVO: Obter ícone Lucide
function SpectrumX:GetLucideIcon(name)
    if type(name) ~= "string" then return nil end
    return self.LucideIcons[name:lower()]
end

function SpectrumX:CreateIcon(parent, iconData, size, color)
    size = size or UDim2.new(0, 20, 0, 20)
    color = color or self.Theme.Text
    
    -- Verifica se é Asset ID
    local assetId = self:FormatAssetId(iconData)
    if assetId then
        local img = Instance.new("ImageLabel")
        img.Name = "Icon"
        img.BackgroundTransparency = 1
        img.Size = size
        img.Image = assetId
        img.ImageColor3 = color
        img.Parent = parent
        
        local aspect = Instance.new("UIAspectRatioConstraint")
        aspect.Parent = img
        
        return img, "image"
    -- NOVO: Verifica se é ícone Lucide
    elseif self:IsLucideIcon(iconData) then
        local lucideIcon = self:GetLucideIcon(iconData)
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Icon"
        lbl.BackgroundTransparency = 1
        lbl.Size = size
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = lucideIcon
        lbl.TextColor3 = color
        lbl.TextSize = size.Y.Offset or 16
        lbl.Parent = parent
        
        return lbl, "lucide"
    else
        -- É texto/emoji
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Icon"
        lbl.BackgroundTransparency = 1
        lbl.Size = size
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = tostring(iconData):sub(1, 2)
        lbl.TextColor3 = color
        lbl.TextSize = size.Y.Offset or 16
        lbl.Parent = parent
        
        return lbl, "text"
    end
end

-- ─── REGISTRO DE DROPDOWNS ────────────────────────────────────────────────────
function SpectrumX:_RegisterDropdown(list, button, closeFunction)
    if not self._dropdowns then self._dropdowns = {} end
    table.insert(self._dropdowns, {
        List = list,
        Button = button,
        Close = closeFunction
    })
    if not self.Dropdowns then self.Dropdowns = {} end
    table.insert(self.Dropdowns, list)
end

function SpectrumX:_CloseDropdownsOnClick(position)
    if not self._dropdowns then return end
    
    for _, dropdown in ipairs(self._dropdowns) do
        if dropdown.List and dropdown.List.Visible then
            local listPos = dropdown.List.AbsolutePosition
            local listSize = dropdown.List.AbsoluteSize
            local btnPos = dropdown.Button.AbsolutePosition
            local btnSize = dropdown.Button.AbsoluteSize
            
            local inList = position.X >= listPos.X and position.X <= listPos.X + listSize.X and
                          position.Y >= listPos.Y and position.Y <= listPos.Y + listSize.Y
            local inBtn = position.X >= btnPos.X and position.X <= btnPos.X + btnSize.X and
                         position.Y >= btnPos.Y and position.Y <= btnPos.Y + btnSize.Y
            
            if not inList and not inBtn then
                task.spawn(dropdown.Close)
            end
        end
    end
end



-- ─── CREATE WINDOW ────────────────────────────────────────────────────────────
function SpectrumX:CreateWindow(config)
    config = config or {}
    local window = setmetatable({}, self)
    
    self:UpdateScale()
    
    -- Destruir UI anterior se existir
    if PlayerGui:FindFirstChild("SpectrumX") then
        PlayerGui.SpectrumX:Destroy()
    end
    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("SpectrumX") then
        coreGui.SpectrumX:Destroy()
    end

    -- ScreenGui principal
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SpectrumX"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.DisplayOrder = 999999

    -- CoreGui fica acima da TopBar, chat e qualquer GUI nativa do Roblox
    local okCG = pcall(function() self.ScreenGui.Parent = coreGui end)
    if not okCG then self.ScreenGui.Parent = PlayerGui end
    
    -- Tabelas de controle
    self._notifications = {}
    self.Dropdowns = {}
    self._dropdowns = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Dimensões da janela
    local windowWidth = ScaleData.IsMobile and self:S(440) or self:S(700)
    local windowHeight = ScaleData.IsMobile and self:S(580) or self:S(460)
    
    -- Frame principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Position = config.Position or UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    self.MainFrame.Size = config.Size or UDim2.new(0, windowWidth, 0, windowHeight)
    self.MainFrame.Active = true
    self.MainFrame.Visible = true
    self.MainFrame.ZIndex = 10
    self.MainFrame.Parent = self.ScreenGui
    self:CreateCorner(self.MainFrame, UDim.new(0, 12))
    
    -- Borda de destaque
    local mainStroke = self:CreateStroke(self.MainFrame, self.Theme.Accent, 1.5, 0)
    
    -- ─── HEADER ─────────────────────────────────────────────────────────────────
    local headerHeight = self:S(56)
    
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.BackgroundColor3 = self.Theme.Header
    self.Header.BorderSizePixel = 0
    self.Header.Size = UDim2.new(1, 0, 0, headerHeight)
    self.Header.ZIndex = 12
    self.Header.Parent = self.MainFrame
    self:CreateCorner(self.Header, UDim.new(0, 10))
    
    -- Ícone do header
    local iconX = self:S(16)
    local hasIconAsset = config.IconAssetId and self:IsAssetId(config.IconAssetId)
    -- NOVO: Suporte a ícone Lucide no header
    local hasLucideIcon = config.Icon and self:IsLucideIcon(config.Icon)
    
    if hasIconAsset then
        local assetId = self:FormatAssetId(config.IconAssetId)
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "HeaderIcon"
        iconImg.BackgroundTransparency = 1
        iconImg.Position = UDim2.new(0, iconX, 0.5, -self:S(16))
        iconImg.Size = UDim2.new(0, self:S(32), 0, self:S(32))
        iconImg.Image = assetId
        iconImg.ScaleType = Enum.ScaleType.Stretch  -- Cobre todo o espaço
        iconImg.ZIndex = 14
        iconImg.Parent = self.Header
    elseif hasLucideIcon then
        -- NOVO: Ícone Lucide no header
        local iconBg = Instance.new("Frame")
        iconBg.Name = "IconBg"
        iconBg.BackgroundColor3 = self.Theme.Accent
        iconBg.Position = UDim2.new(0, iconX, 0.5, -self:S(15))
        iconBg.Size = UDim2.new(0, self:S(30), 0, self:S(30))
        iconBg.ZIndex = 14
        iconBg.Parent = self.Header
        self:CreateCorner(iconBg, UDim.new(0, 6))
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "IconLabel"
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.Font = Enum.Font.GothamBlack
        iconLabel.Text = self:GetLucideIcon(config.Icon)
        iconLabel.TextColor3 = Color3.new(1, 1, 1)
        iconLabel.TextSize = self:S(16)
        iconLabel.ZIndex = 15
        iconLabel.Parent = iconBg
    else
        -- Ícone padrão (letra)
        local iconBg = Instance.new("Frame")
        iconBg.Name = "IconBg"
        iconBg.BackgroundColor3 = self.Theme.Accent
        iconBg.Position = UDim2.new(0, iconX, 0.5, -self:S(15))
        iconBg.Size = UDim2.new(0, self:S(30), 0, self:S(30))
        iconBg.ZIndex = 14
        iconBg.Parent = self.Header
        self:CreateCorner(iconBg, UDim.new(0, 6))
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "IconLabel"
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.Font = Enum.Font.GothamBlack
        iconLabel.Text = config.Icon or "S"
        iconLabel.TextColor3 = Color3.new(1, 1, 1)
        iconLabel.TextSize = self:S(16)
        iconLabel.ZIndex = 15
        iconLabel.Parent = iconBg
    end
    
    -- Título
    local titleX = iconX + self:S(44)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, titleX, 0, 0)
    titleLabel.Size = UDim2.new(0, self:S(300), 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = config.Title or "Spectrum X"
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = self:S(18)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 14
    titleLabel.Parent = self.Header
    self:CreateGradient(titleLabel, self.Theme.Text, self.Theme.AccentSecondary, 0)
    
    -- Subtítulo (opcional)
    if config.Subtitle then
        titleLabel.Size = UDim2.new(0, self:S(300), 0, self:S(28))
        titleLabel.Position = UDim2.new(0, titleX, 0, self:S(6))
        
        local subtitleLabel = Instance.new("TextLabel")
        subtitleLabel.Name = "Subtitle"
        subtitleLabel.BackgroundTransparency = 1
        subtitleLabel.Position = UDim2.new(0, titleX, 0, self:S(30))
        subtitleLabel.Size = UDim2.new(0, self:S(300), 0, self:S(16))
        subtitleLabel.Font = Enum.Font.Gotham
        subtitleLabel.Text = config.Subtitle
        subtitleLabel.TextColor3 = self.Theme.TextMuted
        subtitleLabel.TextSize = self:S(10)
        subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtitleLabel.ZIndex = 14
        subtitleLabel.Parent = self.Header
    end
    
    -- Botão minimizar
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinimizeBtn"
    minBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    minBtn.Position = UDim2.new(1, -self:S(42), 0.5, -self:S(12))
    minBtn.Size = UDim2.new(0, self:S(28), 0, self:S(24))
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Text = "—"
    minBtn.TextColor3 = self.Theme.TextMuted
    minBtn.TextSize = self:S(13)
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 14
    minBtn.Parent = self.Header
    self:CreateCorner(minBtn, UDim.new(0, 6))
    
    minBtn.MouseEnter:Connect(function()
        self:Tween(minBtn, {BackgroundColor3 = self.Theme.Accent, TextColor3 = Color3.new(1,1,1)}, 0.15)
    end)
    minBtn.MouseLeave:Connect(function()
        self:Tween(minBtn, {BackgroundColor3 = Color3.fromRGB(35,35,35), TextColor3 = self.Theme.TextMuted}, 0.15)
    end)
    minBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
    end)
    
    -- ─── SIDEBAR ────────────────────────────────────────────────────────────────
    local sidebarWidth = self:S(64)
    
    -- Wrapper da sidebar
    local sidebarWrap = Instance.new("Frame")
    sidebarWrap.Name = "SidebarWrap"
    sidebarWrap.BackgroundColor3 = self.Theme.Sidebar
    sidebarWrap.BorderSizePixel = 0
    sidebarWrap.Position = UDim2.new(0, 0, 0, headerHeight + 2)
    sidebarWrap.Size = UDim2.new(0, sidebarWidth, 1, -(headerHeight + 2))
    sidebarWrap.ClipsDescendants = true
    sidebarWrap.ZIndex = 11
    sidebarWrap.Parent = self.MainFrame
    self:CreateCorner(sidebarWrap, UDim.new(0, 10))
    
    -- Linha separadora
    local sidebarLine = Instance.new("Frame")
    sidebarLine.Name = "SidebarLine"
    sidebarLine.BackgroundColor3 = self.Theme.Border
    sidebarLine.BorderSizePixel = 0
    sidebarLine.Position = UDim2.new(1, -1, 0, 0)
    sidebarLine.Size = UDim2.new(0, 1, 1, 0)
    sidebarLine.ZIndex = 12
    sidebarLine.Parent = sidebarWrap
    
    -- ScrollingFrame da sidebar - CORREÇÃO: Scroll mais suave
    self.Sidebar = Instance.new("ScrollingFrame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Position = UDim2.new(0, 0, 0, 0)
    self.Sidebar.Size = UDim2.new(1, 0, 1, 0)
    self.Sidebar.ScrollBarThickness = 2
    self.Sidebar.ScrollBarImageColor3 = self.Theme.Accent
    self.Sidebar.ScrollBarImageTransparency = 0.6
    self.Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
    -- CORREÇÃO: Scroll mais pesado e responsivo
    self.Sidebar.ScrollingEnabled = true
    self.Sidebar.VerticalScrollBarInset = Enum.ScrollBarInset.None
    self.Sidebar.ZIndex = 11
    self.Sidebar.Parent = sidebarWrap
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, self:S(8))
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = self.Sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, self:S(12))
    sidebarPadding.PaddingBottom = UDim.new(0, self:S(12))
    sidebarPadding.Parent = self.Sidebar
    
    -- Auto-resize canvas
    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + self:S(24))
    end)
    
    -- ─── CONTENT AREA ───────────────────────────────────────────────────────────
    local contentX = sidebarWidth + self:S(10)
    
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Position = UDim2.new(0, contentX, 0, headerHeight + self:S(10))
    self.ContentArea.Size = UDim2.new(1, -(contentX + self:S(10)), 1, -(headerHeight + self:S(16)))
    self.ContentArea.ZIndex = 11
    self.ContentArea.Parent = self.MainFrame
    
    -- Criar botão flutuante
    self:_CreateFloatingButton(config)
    
    -- Fechar dropdowns ao clicar fora
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            self:_CloseDropdownsOnClick(input.Position)
        end
    end)
    
    -- Atualizar escala quando mudar tamanho da tela
    local success, camera = pcall(function() return workspace.CurrentCamera end)
    if success and camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            self:UpdateScale()
        end)
    end
    
    -- Tornar arrastável
    self:MakeDraggable(self.MainFrame, self.Header)
    
    return window
end



-- ─── FLOATING BUTTON ──────────────────────────────────────────────────────────
function SpectrumX:_CreateFloatingButton(config)
    config = config or {}
    local btnSize = self:S(52)
    
    self.FloatBtn = Instance.new("ImageButton")
    self.FloatBtn.Name = "FloatBtn"
    self.FloatBtn.BackgroundColor3 = self.Theme.Accent
    self.FloatBtn.Position = UDim2.new(0, 20, 0.5, 0)
    self.FloatBtn.Size = UDim2.new(0, btnSize, 0, btnSize)
    self.FloatBtn.Image = ""
    self.FloatBtn.AutoButtonColor = false
    self.FloatBtn.ZIndex = 100
    self.FloatBtn.Parent = self.ScreenGui
    self:CreateCorner(self.FloatBtn, UDim.new(0, 14))
    
    -- Ícone do botão flutuante (pode ser diferente do header!)
    -- Prioridade: FloatIconAssetId > FloatIcon > IconAssetId > Icon > "S"
    local floatIconAsset = config.FloatIconAssetId or config.FloatIcon or config.IconAssetId or config.Icon or "S"
    local hasFloatIconAsset = config.FloatIconAssetId and self:IsAssetId(config.FloatIconAssetId)
    local hasIconAssetForFloat = config.FloatIcon and self:IsAssetId(config.FloatIcon)
    -- NOVO: Suporte Lucide no botão flutuante
    local hasLucideFloat = config.FloatIcon and self:IsLucideIcon(config.FloatIcon)
    local hasLucideIcon = config.Icon and self:IsLucideIcon(config.Icon)
    
    if hasFloatIconAsset then
        -- Asset ID específico do botão flutuante
        local assetId = self:FormatAssetId(config.FloatIconAssetId)
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.BackgroundTransparency = 1
        iconImg.Size = UDim2.new(0.7, 0, 0.7, 0)  -- Maior cobertura
        iconImg.Position = UDim2.new(0.15, 0, 0.15, 0)
        iconImg.Image = assetId
        iconImg.ScaleType = Enum.ScaleType.Stretch  -- Cobre todo o espaço
        iconImg.ZIndex = 102
        iconImg.Parent = self.FloatBtn
    elseif hasIconAssetForFloat then
        -- FloatIcon é um Asset ID
        local assetId = self:FormatAssetId(config.FloatIcon)
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.BackgroundTransparency = 1
        iconImg.Size = UDim2.new(0.7, 0, 0.7, 0)
        iconImg.Position = UDim2.new(0.15, 0, 0.15, 0)
        iconImg.Image = assetId
        iconImg.ScaleType = Enum.ScaleType.Stretch
        iconImg.ZIndex = 102
        iconImg.Parent = self.FloatBtn
    elseif hasLucideFloat then
        -- NOVO: Lucide no botão flutuante
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.Font = Enum.Font.GothamBlack
        iconLabel.Text = self:GetLucideIcon(config.FloatIcon)
        iconLabel.TextColor3 = Color3.new(1, 1, 1)
        iconLabel.TextSize = self:S(22)
        iconLabel.ZIndex = 102
        iconLabel.Parent = self.FloatBtn
    elseif hasLucideIcon then
        -- NOVO: Lucide do header
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.Font = Enum.Font.GothamBlack
        iconLabel.Text = self:GetLucideIcon(config.Icon)
        iconLabel.TextColor3 = Color3.new(1, 1, 1)
        iconLabel.TextSize = self:S(22)
        iconLabel.ZIndex = 102
        iconLabel.Parent = self.FloatBtn
    else
        -- Texto/emoji
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.Font = Enum.Font.GothamBlack
        iconLabel.Text = floatIconAsset
        iconLabel.TextColor3 = Color3.new(1, 1, 1)
        iconLabel.TextSize = self:S(22)
        iconLabel.ZIndex = 102
        iconLabel.Parent = self.FloatBtn
    end
    
    -- Hover effects
    self.FloatBtn.MouseEnter:Connect(function()
        self:Tween(self.FloatBtn, {BackgroundColor3 = self.Theme.AccentHover}, 0.15)
    end)
    
    self.FloatBtn.MouseLeave:Connect(function()
        self:Tween(self.FloatBtn, {BackgroundColor3 = self.Theme.Accent}, 0.15)
    end)
    
    -- Drag do botão flutuante
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    self.FloatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.FloatBtn.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.FloatBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.FloatBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Clique para mostrar/esconder
    self.FloatBtn.MouseButton1Click:Connect(function()
        if not dragging then
            local visible = not self.MainFrame.Visible
            self.MainFrame.Visible = visible
            
            if visible then
                self.MainFrame.BackgroundTransparency = 1
                self:Tween(self.MainFrame, {BackgroundTransparency = 0}, 0.25)
            end
        end
    end)
end

-- ─── CREATE TAB ───────────────────────────────────────────────────────────────
function SpectrumX:CreateTab(config)
    config = config or {}
    local tabId = config.Name or "Tab"
    local tabIcon = config.Icon or tabId:sub(1, 1)
    local btnSize = self:S(46)
    
    -- Botão da tab
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabId .. "Tab"
    tabBtn.BackgroundColor3 = self.Theme.Card
    tabBtn.Size = UDim2.new(0, btnSize, 0, btnSize)
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 13
    tabBtn.Parent = self.Sidebar
    self:CreateCorner(tabBtn, UDim.new(0, 10))
    
    -- Ícone da tab (suporta Asset ID, Lucide ou texto)
    local hasIconAsset = config.Icon and self:IsAssetId(config.Icon)
    local hasIconAssetId = config.IconAssetId and self:IsAssetId(config.IconAssetId)
    -- NOVO: Suporte Lucide na tab
    local hasLucideIcon = config.Icon and self:IsLucideIcon(config.Icon)
    
    if hasIconAsset or hasIconAssetId then
        local assetId = hasIconAsset and self:FormatAssetId(config.Icon) or self:FormatAssetId(config.IconAssetId)
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.BackgroundTransparency = 1
        iconImg.Position = UDim2.new(0.5, -12, 0.5, -12)
        iconImg.Size = UDim2.new(0, 24, 0, 24)
        iconImg.Image = assetId
        iconImg.ImageColor3 = self.Theme.TextMuted
        iconImg.ScaleType = Enum.ScaleType.Stretch
        iconImg.ZIndex = 14
        iconImg.Parent = tabBtn
    elseif hasLucideIcon then
        -- NOVO: Lucide na tab
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Text = self:GetLucideIcon(config.Icon)
        iconLabel.TextColor3 = self.Theme.TextMuted
        iconLabel.TextSize = self:S(18)
        iconLabel.ZIndex = 14
        iconLabel.Parent = tabBtn
    else
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Text = tabIcon
        iconLabel.TextColor3 = self.Theme.TextMuted
        iconLabel.TextSize = self:S(16)
        iconLabel.ZIndex = 14
        iconLabel.Parent = tabBtn
    end
    
    -- Tooltip
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tooltip.BorderSizePixel = 0
    tooltip.Position = UDim2.new(1, self:S(10), 0.5, -self:S(11))
    tooltip.Size = UDim2.new(0, 0, 0, self:S(22))
    tooltip.AutomaticSize = Enum.AutomaticSize.X
    tooltip.Font = Enum.Font.GothamSemibold
    tooltip.Text = "  " .. tabId .. "  "
    tooltip.TextColor3 = self.Theme.Text
    tooltip.TextSize = self:S(11)
    tooltip.Visible = false
    tooltip.ZIndex = 1000
    tooltip.Parent = tabBtn
    self:CreateCorner(tooltip, UDim.new(0, 5))
    self:CreateStroke(tooltip, self.Theme.Border, 1, 0.3)
    
    -- Hover effects
    tabBtn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tabId then
            self:Tween(tabBtn, {BackgroundColor3 = self.Theme.CardHover}, 0.15)
        end
        tooltip.Visible = true
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabId then
            self:Tween(tabBtn, {BackgroundColor3 = self.Theme.Card}, 0.15)
        end
        tooltip.Visible = false
    end)
    
    -- Container da página
    local page = Instance.new("Frame")
    page.Name = tabId .. "Page"
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.ZIndex = 11
    page.Parent = self.ContentArea
    
    -- Divisor central
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.BackgroundColor3 = self.Theme.Border
    divider.BorderSizePixel = 0
    divider.Position = UDim2.new(0.5, -1, 0, 0)
    divider.Size = UDim2.new(0, 1, 1, 0)
    divider.ZIndex = 11
    divider.Parent = page
    
    -- Função helper para criar lado - CORREÇÃO: Scroll mais suave
    local function createSide(position, size, name)
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = name
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.Position = position
        scrollFrame.Size = size
        -- CORREÇÃO: Scroll mais fino e sem efeito escuro
        scrollFrame.ScrollBarThickness = 2
        scrollFrame.ScrollBarImageColor3 = self.Theme.Accent
        scrollFrame.ScrollBarImageTransparency = 0.6
        -- CORREÇÃO: Remover efeito de scroll escuro
        scrollFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        -- CORREÇÃO: Scroll apenas vertical para evitar balanço lateral
        scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        scrollFrame.ZIndex = 11
        scrollFrame.Parent = page
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        -- CORREÇÃO: Padding menor para elementos mais compactos
        layout.Padding = UDim.new(0, self:S(6))
        layout.Parent = scrollFrame
        
        local padding = Instance.new("UIPadding")
        padding.PaddingBottom = UDim.new(0, self:S(10))
        -- CORREÇÃO: Padding lateral menor
        padding.PaddingLeft = UDim.new(0, self:S(4))
        padding.PaddingRight = UDim.new(0, self:S(4))
        padding.Parent = scrollFrame
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + self:S(20))
        end)
        
        return scrollFrame
    end
    
    local left = createSide(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), "Left")
    local right = createSide(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), "Right")
    
    -- Salvar dados da tab
    local tabData = {
        Button = tabBtn,
        Container = page,
        Left = left,
        Right = right,
        Id = tabId
    }
    self.Tabs[tabId] = tabData
    
    -- Evento de clique
    tabBtn.MouseButton1Click:Connect(function()
        self:SelectTab(tabId)
    end)
    
    -- Selecionar primeira tab automaticamente
    if not self.CurrentTab then
        self:SelectTab(tabId)
    end
    
    return tabData
end

-- ─── SELECT TAB ───────────────────────────────────────────────────────────────
function SpectrumX:SelectTab(tabId)
    for id, data in pairs(self.Tabs) do
        local icon = data.Button:FindFirstChild("Icon")
        
        if id == tabId then
            -- Ativar esta tab
            data.Container.Visible = true
            self:Tween(data.Button, {BackgroundColor3 = self.Theme.Accent}, 0.2)
            
            if icon then
                if icon:IsA("TextLabel") then
                    self:Tween(icon, {TextColor3 = Color3.new(1, 1, 1)}, 0.2)
                elseif icon:IsA("ImageLabel") then
                    self:Tween(icon, {ImageColor3 = Color3.new(1, 1, 1)}, 0.2)
                end
            end
        else
            -- Desativar outras tabs
            data.Container.Visible = false
            self:Tween(data.Button, {BackgroundColor3 = self.Theme.Card}, 0.2)
            
            if icon then
                if icon:IsA("TextLabel") then
                    self:Tween(icon, {TextColor3 = self.Theme.TextMuted}, 0.2)
                elseif icon:IsA("ImageLabel") then
                    self:Tween(icon, {ImageColor3 = self.Theme.TextMuted}, 0.2)
                end
            end
        end
    end
    
    self.CurrentTab = tabId
end

-- ─── CREATE SECTION ───────────────────────────────────────────────────────────
function SpectrumX:CreateSection(parent, text, color)
    -- CORREÇÃO: Altura menor para seção
    local wrap = Instance.new("Frame")
    wrap.Name = "Section_" .. text
    wrap.BackgroundTransparency = 1
    wrap.Size = UDim2.new(1, 0, 0, self:S(22))
    wrap.ZIndex = 12
    wrap.Parent = parent
    
    -- Linha decorativa
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.BackgroundColor3 = color or self.Theme.Accent
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.ZIndex = 11
    line.Parent = wrap
    
    -- Texto da seção
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundColor3 = self.Theme.Background
    label.BorderSizePixel = 0
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Position = UDim2.new(0, self:S(6), 0, 0)
    label.Size = UDim2.new(0, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = "  " .. text .. "  "
    label.TextColor3 = color or self.Theme.Accent
    label.TextSize = self:S(10)
    label.ZIndex = 13
    label.Parent = wrap
    
    return wrap
end



-- ─── CREATE TOGGLE ────────────────────────────────────────────────────────────
function SpectrumX:CreateToggle(parent, config)
    config = config or {}
    local text = config.Text or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    -- CORREÇÃO: Altura menor
    local height = self:S(42)
    
    local frame = Instance.new("Frame")
    frame.Name = "Toggle_" .. text
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    self:CreateStroke(frame, self.Theme.Border, 1, 0.5)
    
    -- Efeito hover
    local hoverFill = Instance.new("Frame")
    hoverFill.Name = "HoverFill"
    hoverFill.BackgroundColor3 = Color3.new(1, 1, 1)
    hoverFill.BackgroundTransparency = 1
    hoverFill.BorderSizePixel = 0
    hoverFill.Size = UDim2.new(1, 0, 1, 0)
    hoverFill.ZIndex = 0
    hoverFill.Parent = frame
    self:CreateCorner(hoverFill)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self:S(12), 0, 0)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = self.Theme.Text
    label.TextSize = self:S(12)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.ZIndex = 13
    label.Parent = frame
    
    -- Track do toggle - CORREÇÃO: Tamanho menor
    local trackWidth, trackHeight = self:S(42), self:S(22)
    local track = Instance.new("TextButton")
    track.Name = "Track"
    track.AutoButtonColor = false
    track.BackgroundColor3 = default and self.Theme.ToggleOn or self.Theme.ToggleOff
    track.Position = UDim2.new(1, -trackWidth - self:S(12), 0.5, -trackHeight/2)
    track.Size = UDim2.new(0, trackWidth, 0, trackHeight)
    track.Text = ""
    track.ZIndex = 14
    track.Parent = frame
    self:CreateCorner(track, UDim.new(1, 0))
    self:CreateStroke(track, default and self.Theme.Accent or self.Theme.Border, 1, default and 0.2 or 0.5)
    
    local trackStroke = track:FindFirstChildOfClass("UIStroke")
    
    -- Knob - CORREÇÃO: Tamanho menor
    local knobSize = self:S(16)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Position = default and UDim2.new(1, -knobSize - self:S(3), 0.5, -knobSize/2)
                             or UDim2.new(0, self:S(3), 0.5, -knobSize/2)
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.ZIndex = 15
    knob.Parent = track
    self:CreateCorner(knob, UDim.new(1, 0))
    self:CreateStroke(knob, Color3.fromRGB(200, 200, 200), 1, 0.3)
    
    local state = default
    
    local function update(newState, animated)
        local time = animated == false and 0 or 0.2
        state = newState
        
        if state then
            self:Tween(track, {BackgroundColor3 = self.Theme.ToggleOn}, time)
            if trackStroke then
                self:Tween(trackStroke, {Color = self.Theme.Accent, Transparency = 0.2}, time)
            end
            self:Tween(knob, {
                Position = UDim2.new(1, -knobSize - self:S(3), 0.5, -knobSize/2)
            }, time, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            self:Tween(track, {BackgroundColor3 = self.Theme.ToggleOff}, time)
            if trackStroke then
                self:Tween(trackStroke, {Color = self.Theme.Border, Transparency = 0.5}, time)
            end
            self:Tween(knob, {
                Position = UDim2.new(0, self:S(3), 0.5, -knobSize/2)
            }, time, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end
    
    track.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        update(state)
    end)
    
    -- Hover
    frame.MouseEnter:Connect(function()
        self:Tween(hoverFill, {BackgroundTransparency = 0.97}, 0.15)
    end)
    
    frame.MouseLeave:Connect(function()
        self:Tween(hoverFill, {BackgroundTransparency = 1}, 0.15)
    end)
    
    return {
        Frame = frame,
        GetState = function() return state end,
        SetState = function(s) state = s; callback(state); update(state) end,
    }
end

-- ─── CREATE BUTTON ────────────────────────────────────────────────────────────
function SpectrumX:CreateButton(parent, config)
    config = config or {}
    local text = config.Text or "Button"
    local style = config.Style or "default"
    local callback = config.Callback or function() end
    
    -- CORREÇÃO: Altura menor
    local height = self:S(36)
    
    local frame = Instance.new("Frame")
    frame.Name = "Button_" .. text
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ZIndex = 12
    frame.Parent = parent
    
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextSize = self:S(12)
    btn.ZIndex = 13
    btn.Parent = frame
    self:CreateCorner(btn)
    
    local color, textColor
    if style == "accent" then
        btn.BackgroundColor3 = self.Theme.Accent
        textColor = Color3.new(1, 1, 1)
        color = self.Theme.Accent
    elseif style == "warning" then
        btn.BackgroundColor3 = Color3.fromRGB(40, 25, 0)
        textColor = self.Theme.Warning
        color = self.Theme.Warning
    elseif style == "info" then
        btn.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
        textColor = self.Theme.Info
        color = self.Theme.Info
    elseif style == "danger" then
        btn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
        textColor = self.Theme.Error
        color = self.Theme.Error
    else -- default/outline
        btn.BackgroundColor3 = self.Theme.Card
        textColor = self.Theme.Text
        color = self.Theme.Border
    end
    
    btn.TextColor3 = textColor
    
    local stroke = self:CreateStroke(btn, color, 1.2, style == "accent" and 1 or 0.4)
    
    if style == "accent" then
        self:CreateGradient(btn, self.Theme.Accent, self.Theme.AccentDark, 90)
    end
    
    -- Container para ripple
    local rippleHolder = Instance.new("Frame")
    rippleHolder.Name = "RippleHolder"
    rippleHolder.BackgroundTransparency = 1
    rippleHolder.BorderSizePixel = 0
    rippleHolder.Size = UDim2.new(1, 0, 1, 0)
    rippleHolder.ClipsDescendants = true
    rippleHolder.ZIndex = btn.ZIndex + 1
    rippleHolder.Parent = btn
    self:CreateCorner(rippleHolder)
    
    -- Hover
    btn.MouseEnter:Connect(function()
        if style == "accent" then
            self:Tween(btn, {BackgroundColor3 = self.Theme.AccentHover}, 0.15)
        else
            self:Tween(btn, {BackgroundColor3 = self.Theme.CardHover}, 0.15)
            if stroke then
                self:Tween(stroke, {Transparency = 0.1}, 0.15)
            end
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if style == "accent" then
            self:Tween(btn, {BackgroundColor3 = self.Theme.Accent}, 0.15)
        else
            self:Tween(btn, {BackgroundColor3 = self.Theme.Card}, 0.15)
            if stroke then
                self:Tween(stroke, {Transparency = style == "accent" and 1 or 0.4}, 0.15)
            end
        end
    end)
    
    -- Clique
    btn.MouseButton1Click:Connect(function()
        self:CreateRipple(btn, UserInputService:GetMouseLocation())
        callback()
    end)
    
    return {
        Frame = frame,
        Button = btn,
        SetText = function(t) btn.Text = t end,
        SetCallback = function(cb) callback = cb end,
    }
end

-- ─── CREATE INPUT ─────────────────────────────────────────────────────────────
function SpectrumX:CreateInput(parent, config)
    config = config or {}
    local labelText = config.Label or "Input"
    local default = config.Default or ""
    local placeholder = config.Placeholder or "Digite aqui..."
    local callback = config.Callback or function() end
    
    -- CORREÇÃO: Altura menor
    local height = self:S(56)
    
    local frame = Instance.new("Frame")
    frame.Name = "Input_" .. labelText
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    
    local stroke = self:CreateStroke(frame, self.Theme.Border, 1, 0.4)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self:S(12), 0, self:S(8))
    label.Size = UDim2.new(1, -self:S(24), 0, self:S(14))
    label.Font = Enum.Font.GothamSemibold
    label.Text = labelText
    label.TextColor3 = self.Theme.TextMuted
    label.TextSize = self:S(9)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = frame
    
    -- TextBox
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.BackgroundColor3 = self.Theme.Input
    textBox.Position = UDim2.new(0, self:S(10), 0, self:S(24))
    textBox.Size = UDim2.new(1, -self:S(20), 0, self:S(24))
    textBox.Font = Enum.Font.Gotham
    textBox.Text = tostring(default)
    textBox.PlaceholderText = placeholder
    textBox.PlaceholderColor3 = self.Theme.TextMuted
    textBox.TextColor3 = self.Theme.Text
    textBox.TextSize = self:S(12)
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 14
    textBox.Parent = frame
    self:CreateCorner(textBox, UDim.new(0, 5))
    
    -- Foco
    textBox.Focused:Connect(function()
        self:Tween(stroke, {Color = self.Theme.Accent, Transparency = 0.1}, 0.2)
        self:Tween(label, {TextColor3 = self.Theme.Accent}, 0.2)
    end)
    
    textBox.FocusLost:Connect(function()
        self:Tween(stroke, {Color = self.Theme.Border, Transparency = 0.4}, 0.2)
        self:Tween(label, {TextColor3 = self.Theme.TextMuted}, 0.2)
        callback(textBox.Text)
    end)
    
    return {
        Frame = frame,
        TextBox = textBox,
        GetText = function() return textBox.Text end,
        SetText = function(t) textBox.Text = t end,
    }
end

-- ─── CREATE NUMBER INPUT ──────────────────────────────────────────────────────
function SpectrumX:CreateNumberInput(parent, config)
    config = config or {}
    local labelText = config.Label or "Number"
    local default = config.Default or 0
    local min = config.Min or -math.huge
    local max = config.Max or math.huge
    local callback = config.Callback or function() end
    
    -- CORREÇÃO: Altura menor
    local height = self:S(56)
    
    local frame = Instance.new("Frame")
    frame.Name = "NumberInput_" .. labelText
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    
    local stroke = self:CreateStroke(frame, self.Theme.Border, 1, 0.4)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self:S(12), 0, self:S(8))
    label.Size = UDim2.new(1, -self:S(24), 0, self:S(14))
    label.Font = Enum.Font.GothamSemibold
    label.Text = labelText
    label.TextColor3 = self.Theme.TextMuted
    label.TextSize = self:S(9)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = frame
    
    -- TextBox
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.BackgroundColor3 = self.Theme.Input
    textBox.Position = UDim2.new(0, self:S(10), 0, self:S(24))
    textBox.Size = UDim2.new(1, -self:S(20), 0, self:S(24))
    textBox.Font = Enum.Font.GothamBold
    textBox.Text = tostring(default)
    textBox.TextColor3 = self.Theme.Text
    textBox.TextSize = self:S(12)
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 14
    textBox.Parent = frame
    self:CreateCorner(textBox, UDim.new(0, 5))
    
    -- Foco
    textBox.Focused:Connect(function()
        self:Tween(stroke, {Color = self.Theme.Accent, Transparency = 0.1}, 0.2)
        self:Tween(label, {TextColor3 = self.Theme.Accent}, 0.2)
    end)
    
    textBox.FocusLost:Connect(function()
        self:Tween(stroke, {Color = self.Theme.Border, Transparency = 0.4}, 0.2)
        self:Tween(label, {TextColor3 = self.Theme.TextMuted}, 0.2)
        
        local value = tonumber(textBox.Text)
        if value then
            value = math.clamp(value, min, max)
            textBox.Text = tostring(value)
            callback(value)
        else
            textBox.Text = tostring(default)
        end
    end)
    
    return {
        Frame = frame,
        TextBox = textBox,
        GetValue = function() return tonumber(textBox.Text) end,
        SetValue = function(v)
            v = math.clamp(v, min, max)
            textBox.Text = tostring(v)
        end,
    }
end



-- ─── CREATE SLIDER ────────────────────────────────────────────────────────────
-- CORREÇÃO: Agora com valor clicável que funciona como input numérico
function SpectrumX:CreateSlider(parent, config)
    config = config or {}
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback or function() end
    local decimals = config.Decimals or 0  -- NOVO: Número de casas decimais
    
    -- CORREÇÃO: Altura menor
    local height = self:S(56)
    
    local frame = Instance.new("Frame")
    frame.Name = "Slider_" .. text
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    self:CreateStroke(frame, self.Theme.Border, 1, 0.4)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self:S(12), 0, self:S(8))
    label.Size = UDim2.new(0.5, 0, 0, self:S(16))
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = self.Theme.Text
    label.TextSize = self:S(11)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = frame
    
    -- NOVO: Valor display clicável (funciona como input)
    local valueBg = Instance.new("TextButton")
    valueBg.Name = "ValueBg"
    valueBg.BackgroundColor3 = self.Theme.Accent
    valueBg.Position = UDim2.new(1, -self:S(50), 0, self:S(6))
    valueBg.Size = UDim2.new(0, self:S(44), 0, self:S(20))
    valueBg.AutoButtonColor = false
    valueBg.Text = ""
    valueBg.ZIndex = 14
    valueBg.Parent = frame
    self:CreateCorner(valueBg, UDim.new(0, 5))
    
    -- Label do valor (mostra o número)
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    -- Formatar com casas decimais
    local formatStr = "%0." .. decimals .. "f"
    valueLabel.Text = string.format(formatStr, default)
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.TextSize = self:S(10)
    valueLabel.ZIndex = 15
    valueLabel.Parent = valueBg
    
    -- NOVO: TextBox invisível para input (aparece ao clicar)
    local valueInput = Instance.new("TextBox")
    valueInput.Name = "ValueInput"
    valueInput.BackgroundColor3 = self.Theme.Input
    valueInput.Position = UDim2.new(1, -self:S(54), 0, self:S(4))
    valueInput.Size = UDim2.new(0, self:S(52), 0, self:S(24))
    valueInput.Font = Enum.Font.GothamBold
    valueInput.Text = string.format(formatStr, default)
    valueInput.TextColor3 = self.Theme.Text
    valueInput.TextSize = self:S(10)
    valueInput.ClearTextOnFocus = true
    valueInput.Visible = false
    valueInput.ZIndex = 16
    valueInput.Parent = frame
    self:CreateCorner(valueInput, UDim.new(0, 5))
    
    -- Stroke para o input
    local inputStroke = self:CreateStroke(valueInput, self.Theme.Accent, 1.5, 0)
    
    -- Track background
    local trackHeight = self:S(5)
    local trackBg = Instance.new("Frame")
    trackBg.Name = "TrackBg"
    trackBg.BackgroundColor3 = self.Theme.Input
    trackBg.Position = UDim2.new(0, self:S(12), 1, -self:S(18))
    trackBg.Size = UDim2.new(1, -self:S(24), 0, trackHeight)
    trackBg.ZIndex = 13
    trackBg.Parent = frame
    self:CreateCorner(trackBg, UDim.new(1, 0))
    
    -- Fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = self.Theme.Accent
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.ZIndex = 14
    fill.Parent = trackBg
    self:CreateCorner(fill, UDim.new(1, 0))
    self:CreateGradient(fill, self.Theme.Accent, self.Theme.AccentDark, 0)
    
    -- Knob - CORREÇÃO: Tamanho menor
    local knobSize = self:S(14)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Position = UDim2.new((default - min) / (max - min), -knobSize/2, 0.5, -knobSize/2)
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.ZIndex = 15
    knob.Parent = trackBg
    self:CreateCorner(knob, UDim.new(1, 0))
    self:CreateStroke(knob, self.Theme.Accent, 2, 0)
    
    local dragging = false
    local currentValue = default
    
    -- NOVO: Função para formatar valor
    local function formatValue(val)
        if decimals == 0 then
            return tostring(math.floor(val))
        else
            return string.format(formatStr, val)
        end
    end
    
    local function update(input)
        local percent = math.clamp(
            (input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X,
            0, 1
        )
        local value = min + (max - min) * percent
        -- Arredondar para casas decimais especificadas
        if decimals > 0 then
            value = math.floor(value * (10^decimals)) / (10^decimals)
        else
            value = math.floor(value)
        end
        currentValue = value
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, -knobSize/2, 0.5, -knobSize/2)
        local formatted = formatValue(value)
        valueLabel.Text = formatted
        valueInput.Text = formatted
        callback(value)
    end
    
    -- NOVO: Clique no valor para editar
    valueBg.MouseButton1Click:Connect(function()
        valueLabel.Visible = false
        valueBg.Visible = false
        valueInput.Visible = true
        valueInput:CaptureFocus()
    end)
    
    -- NOVO: Ao perder foco do input
    valueInput.FocusLost:Connect(function()
        local inputValue = tonumber(valueInput.Text)
        if inputValue then
            inputValue = math.clamp(inputValue, min, max)
            -- Arredondar
            if decimals > 0 then
                inputValue = math.floor(inputValue * (10^decimals)) / (10^decimals)
            else
                inputValue = math.floor(inputValue)
            end
            currentValue = inputValue
            
            local percent = (inputValue - min) / (max - min)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -knobSize/2, 0.5, -knobSize/2)
            
            local formatted = formatValue(inputValue)
            valueLabel.Text = formatted
            valueInput.Text = formatted
            callback(inputValue)
        else
            -- Restaurar valor anterior se inválido
            valueInput.Text = formatValue(currentValue)
        end
        
        valueInput.Visible = false
        valueLabel.Visible = true
        valueBg.Visible = true
    end)
    
    -- Hover no valor
    valueBg.MouseEnter:Connect(function()
        self:Tween(valueBg, {BackgroundColor3 = self.Theme.AccentHover}, 0.15)
    end)
    
    valueBg.MouseLeave:Connect(function()
        self:Tween(valueBg, {BackgroundColor3 = self.Theme.Accent}, 0.15)
    end)
    
    trackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return {
        Frame = frame,
        GetValue = function() return currentValue end,
        SetValue = function(v)
            v = math.clamp(v, min, max)
            -- Arredondar
            if decimals > 0 then
                v = math.floor(v * (10^decimals)) / (10^decimals)
            else
                v = math.floor(v)
            end
            currentValue = v
            local percent = (v - min) / (max - min)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -knobSize/2, 0.5, -knobSize/2)
            local formatted = formatValue(v)
            valueLabel.Text = formatted
            valueInput.Text = formatted
        end,
    }
end

-- ─── HELPER: POSIÇÃO DO DROPDOWN ──────────────────────────────────────────────
local function getDropdownPosition(button, layout, maxHeight)
    local btnPos = button.AbsolutePosition
    local btnSize = button.AbsoluteSize
    local contentHeight = layout.AbsoluteContentSize.Y + 12
    local targetHeight = math.min(contentHeight, maxHeight)
    
    local success, camera = pcall(function() return workspace.CurrentCamera end)
    local screenHeight = (success and camera) and camera.ViewportSize.Y or 768
    
    local targetY = btnPos.Y + btnSize.Y + 4
    if targetY + targetHeight > screenHeight then
        targetY = btnPos.Y - targetHeight - 4
    end
    
    return UDim2.fromOffset(btnPos.X, targetY), targetHeight, contentHeight
end

-- ─── CREATE DROPDOWN ────────────────────────────────────────────────────────────
-- CORREÇÃO: Ícone de dropdown customizável via Asset ID
function SpectrumX:CreateDropdown(parent, config)
    config = config or {}
    local labelText = config.Label or "Dropdown"
    local options = config.Options or {}
    local default = config.Default
    local callback = config.Callback or function() end
    -- NOVO: Asset ID customizável para o ícone de dropdown
    local arrowIconAssetId = config.ArrowIconAssetId or nil  -- Asset ID para seta
    local arrowOpenIconAssetId = config.ArrowOpenIconAssetId or arrowIconAssetId  -- Asset ID quando aberto
    
    -- CORREÇÃO: Altura menor
    local height = self:S(56)
    
    local frame = Instance.new("Frame")
    frame.Name = "Dropdown_" .. labelText
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ClipsDescendants = false
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    self:CreateStroke(frame, self.Theme.Border, 1, 0.4)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self:S(12), 0, self:S(8))
    label.Size = UDim2.new(1, -self:S(24), 0, self:S(12))
    label.Font = Enum.Font.GothamSemibold
    label.Text = labelText
    label.TextColor3 = self.Theme.TextMuted
    label.TextSize = self:S(9)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = frame
    
    -- Botão do dropdown
    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = "DropBtn"
    dropBtn.BackgroundColor3 = self.Theme.Input
    dropBtn.AutoButtonColor = false
    dropBtn.Position = UDim2.new(0, self:S(10), 0, self:S(22))
    dropBtn.Size = UDim2.new(1, -self:S(20), 0, self:S(26))
    dropBtn.Font = Enum.Font.GothamSemibold
    dropBtn.Text = "  " .. (default or "Selecionar...")
    dropBtn.TextColor3 = default and self.Theme.Text or self.Theme.TextMuted
    dropBtn.TextSize = self:S(11)
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.ZIndex = 14
    dropBtn.Parent = frame
    self:CreateCorner(dropBtn, UDim.new(0, 5))
    
    local dropStroke = self:CreateStroke(dropBtn, self.Theme.Border, 1, 0.4)
    
    -- NOVO: Seta customizável via Asset ID ou texto padrão
    local arrow
    if arrowIconAssetId and self:IsAssetId(arrowIconAssetId) then
        -- Usar Asset ID para ícone
        local assetId = self:FormatAssetId(arrowIconAssetId)
        arrow = Instance.new("ImageLabel")
        arrow.Name = "Arrow"
        arrow.BackgroundTransparency = 1
        arrow.Position = UDim2.new(1, -self:S(26), 0, 0)
        arrow.Size = UDim2.new(0, self:S(22), 1, 0)
        arrow.Image = assetId
        arrow.ImageColor3 = self.Theme.Accent
        arrow.ScaleType = Enum.ScaleType.Fit
        arrow.ZIndex = 15
        arrow.Parent = dropBtn
    else
        -- Texto padrão (▾)
        arrow = Instance.new("TextLabel")
        arrow.Name = "Arrow"
        arrow.BackgroundTransparency = 1
        arrow.Position = UDim2.new(1, -self:S(26), 0, 0)
        arrow.Size = UDim2.new(0, self:S(22), 1, 0)
        arrow.Font = Enum.Font.GothamBold
        arrow.Text = "▾"
        arrow.TextColor3 = self.Theme.Accent
        arrow.TextSize = self:S(12)
        arrow.ZIndex = 15
        arrow.Parent = dropBtn
    end
    
    -- Lista do dropdown
    local dropList = Instance.new("ScrollingFrame")
    dropList.Name = "DropList"
    dropList.BackgroundColor3 = self.Theme.Card
    dropList.Size = UDim2.new(0, 0, 0, 0)
    dropList.ScrollBarThickness = 3
    dropList.ScrollBarImageColor3 = self.Theme.Accent
    dropList.Visible = false
    dropList.ZIndex = 100
    dropList.BorderSizePixel = 0
    dropList.Parent = self.ScreenGui
    self:CreateCorner(dropList, UDim.new(0, 8))
    self:CreateStroke(dropList, self.Theme.Accent, 1.5, 0.2)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, self:S(3))
    listLayout.Parent = dropList
    
    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingBottom = UDim.new(0, 5)
    listPadding.PaddingLeft = UDim.new(0, 5)
    listPadding.PaddingRight = UDim.new(0, 5)
    listPadding.Parent = dropList
    
    local selected = default
    local isOpen = false
    local maxHeight = self:S(200)
    
    local function closeDropdown()
        if not isOpen then return end
        isOpen = false
        self:Tween(dropList, {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)}, 0.2)
        -- NOVO: Trocar ícone se Asset ID diferente para estado fechado
        if arrowOpenIconAssetId and arrowIconAssetId and arrow:IsA("ImageLabel") then
            arrow.Image = self:FormatAssetId(arrowIconAssetId)
        else
            self:Tween(arrow, {Rotation = 0}, 0.2)
        end
        if dropStroke then
            self:Tween(dropStroke, {Color = self.Theme.Border, Transparency = 0.4}, 0.2)
        end
        task.wait(0.2)
        if dropList and dropList.Parent then
            dropList.Visible = false
        end
    end
    
    self:_RegisterDropdown(dropList, dropBtn, closeDropdown)
    
    local function populate()
        for _, child in ipairs(dropList:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        for _, option in ipairs(options) do
            local isSelected = option == selected
            
            local row = Instance.new("Frame")
            row.BackgroundColor3 = isSelected and Color3.fromRGB(40, 10, 10) or self.Theme.Input
            row.Size = UDim2.new(1, 0, 0, self:S(28))
            row.ZIndex = 101
            row.Parent = dropList
            self:CreateCorner(row, UDim.new(0, 5))
            
            if isSelected then
                self:CreateStroke(row, self.Theme.Accent, 1, 0.2)
                
                -- Indicador
                local dot = Instance.new("Frame")
                dot.BackgroundColor3 = self.Theme.Accent
                dot.Position = UDim2.new(0, self:S(8), 0.5, -self:S(4))
                dot.Size = UDim2.new(0, self:S(8), 0, self:S(8))
                dot.ZIndex = 102
                dot.Parent = row
                self:CreateCorner(dot, UDim.new(1, 0))
            end
            
            local rowBtn = Instance.new("TextButton")
            rowBtn.BackgroundTransparency = 1
            rowBtn.Size = UDim2.new(1, 0, 1, 0)
            rowBtn.Font = Enum.Font.GothamSemibold
            rowBtn.Text = (isSelected and "   " or "  ") .. option
            rowBtn.TextColor3 = isSelected and self.Theme.AccentSecondary or self.Theme.TextSecondary
            rowBtn.TextSize = self:S(11)
            rowBtn.TextXAlignment = Enum.TextXAlignment.Left
            rowBtn.ZIndex = 102
            rowBtn.Parent = row
            
            local rowPad = Instance.new("UIPadding")
            rowPad.PaddingLeft = UDim.new(0, self:S(12))
            rowPad.Parent = rowBtn
            
            rowBtn.MouseButton1Click:Connect(function()
                selected = option
                dropBtn.Text = "  " .. option
                dropBtn.TextColor3 = self.Theme.Text
                callback(option)
                closeDropdown()
            end)
            
            rowBtn.MouseEnter:Connect(function()
                if not isSelected then
                    self:Tween(row, {BackgroundColor3 = self.Theme.CardHover}, 0.1)
                end
            end)
            
            rowBtn.MouseLeave:Connect(function()
                if not isSelected then
                    self:Tween(row, {BackgroundColor3 = self.Theme.Input}, 0.1)
                end
            end)
        end
    end
    
    dropBtn.MouseEnter:Connect(function()
        self:Tween(dropBtn, {BackgroundColor3 = self.Theme.InputHover}, 0.15)
    end)
    
    dropBtn.MouseLeave:Connect(function()
        self:Tween(dropBtn, {BackgroundColor3 = self.Theme.Input}, 0.15)
    end)
    
    dropBtn.MouseButton1Click:Connect(function()
        if isOpen then
            closeDropdown()
            return
        end
        
        -- Fechar outros dropdowns
        for _, dd in ipairs(self.Dropdowns) do
            if dd ~= dropList then dd.Visible = false end
        end
        
        populate()
        local pos, targetH, contentH = getDropdownPosition(dropBtn, listLayout, maxHeight)
        dropList.Position = pos
        dropList.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
        dropList.CanvasSize = UDim2.new(0, 0, 0, contentH)
        dropList.Visible = true
        
        self:Tween(dropList, {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, targetH)}, 0.25,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        -- NOVO: Trocar ícone se Asset ID diferente para estado aberto
        if arrowOpenIconAssetId and arrow:IsA("ImageLabel") then
            arrow.Image = self:FormatAssetId(arrowOpenIconAssetId)
        else
            self:Tween(arrow, {Rotation = 180}, 0.2)
        end
        if dropStroke then
            self:Tween(dropStroke, {Color = self.Theme.Accent, Transparency = 0.2}, 0.2)
        end
        isOpen = true
    end)
    
    return {
        Frame = frame,
        GetValue = function() return selected end,
        SetValue = function(v)
            selected = v
            dropBtn.Text = "  " .. (v or "Selecionar...")
        end,
        SetOptions = function(newOptions)
            options = newOptions
            if isOpen then populate() end
        end,
    }
end



-- ─── CREATE MULTI DROPDOWN ────────────────────────────────────────────────────
-- CORREÇÃO: Ícone de dropdown customizável via Asset ID
function SpectrumX:CreateMultiDropdown(parent, config)
    config = config or {}
    local labelText = config.Label or "Multi Select"
    local options = config.Options or {}
    local default = config.Default or {}
    local callback = config.Callback or function() end
    -- NOVO: Asset ID customizável para o ícone de dropdown
    local arrowIconAssetId = config.ArrowIconAssetId or nil
    local arrowOpenIconAssetId = config.ArrowOpenIconAssetId or arrowIconAssetId
    
    -- CORREÇÃO: Altura menor
    local height = self:S(56)
    
    local frame = Instance.new("Frame")
    frame.Name = "MultiDropdown_" .. labelText
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ClipsDescendants = false
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    self:CreateStroke(frame, self.Theme.Border, 1, 0.4)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self:S(12), 0, self:S(8))
    label.Size = UDim2.new(1, -self:S(24), 0, self:S(12))
    label.Font = Enum.Font.GothamSemibold
    label.Text = labelText
    label.TextColor3 = self.Theme.TextMuted
    label.TextSize = self:S(9)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = frame
    
    -- Botão
    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = "DropBtn"
    dropBtn.BackgroundColor3 = self.Theme.Input
    dropBtn.AutoButtonColor = false
    dropBtn.Position = UDim2.new(0, self:S(10), 0, self:S(22))
    dropBtn.Size = UDim2.new(1, -self:S(20), 0, self:S(26))
    dropBtn.Font = Enum.Font.GothamSemibold
    dropBtn.Text = "  Selecionar..."
    dropBtn.TextColor3 = self.Theme.TextMuted
    dropBtn.TextSize = self:S(11)
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.ZIndex = 14
    dropBtn.Parent = frame
    self:CreateCorner(dropBtn, UDim.new(0, 5))
    
    local dropStroke = self:CreateStroke(dropBtn, self.Theme.Border, 1, 0.4)
    
    -- NOVO: Seta customizável via Asset ID ou texto padrão
    local arrow
    if arrowIconAssetId and self:IsAssetId(arrowIconAssetId) then
        local assetId = self:FormatAssetId(arrowIconAssetId)
        arrow = Instance.new("ImageLabel")
        arrow.Name = "Arrow"
        arrow.BackgroundTransparency = 1
        arrow.Position = UDim2.new(1, -self:S(26), 0, 0)
        arrow.Size = UDim2.new(0, self:S(22), 1, 0)
        arrow.Image = assetId
        arrow.ImageColor3 = self.Theme.Accent
        arrow.ScaleType = Enum.ScaleType.Fit
        arrow.ZIndex = 15
        arrow.Parent = dropBtn
    else
        arrow = Instance.new("TextLabel")
        arrow.Name = "Arrow"
        arrow.BackgroundTransparency = 1
        arrow.Position = UDim2.new(1, -self:S(26), 0, 0)
        arrow.Size = UDim2.new(0, self:S(22), 1, 0)
        arrow.Font = Enum.Font.GothamBold
        arrow.Text = "▾"
        arrow.TextColor3 = self.Theme.Accent
        arrow.TextSize = self:S(12)
        arrow.ZIndex = 15
        arrow.Parent = dropBtn
    end
    
    -- Lista
    local dropList = Instance.new("ScrollingFrame")
    dropList.Name = "MultiDropList"
    dropList.BackgroundColor3 = self.Theme.Card
    dropList.Size = UDim2.new(0, 0, 0, 0)
    dropList.ScrollBarThickness = 3
    dropList.ScrollBarImageColor3 = self.Theme.Accent
    dropList.Visible = false
    dropList.ZIndex = 100
    dropList.BorderSizePixel = 0
    dropList.Parent = self.ScreenGui
    self:CreateCorner(dropList, UDim.new(0, 8))
    self:CreateStroke(dropList, self.Theme.Accent, 1.5, 0.2)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, self:S(3))
    listLayout.Parent = dropList
    
    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingBottom = UDim.new(0, 5)
    listPadding.PaddingLeft = UDim.new(0, 5)
    listPadding.PaddingRight = UDim.new(0, 5)
    listPadding.Parent = dropList
    
    local selected = {}
    for _, v in ipairs(default) do table.insert(selected, v) end
    local isOpen = false
    local maxHeight = self:S(200)
    
    local function updateText()
        if #selected == 0 then
            dropBtn.Text = "  Selecionar..."
            dropBtn.TextColor3 = self.Theme.TextMuted
        elseif #selected == 1 then
            dropBtn.Text = "  " .. selected[1]
            dropBtn.TextColor3 = self.Theme.Text
        else
            dropBtn.Text = "  " .. #selected .. " selecionados"
            dropBtn.TextColor3 = self.Theme.Text
        end
    end
    
    local function closeDropdown()
        if not isOpen then return end
        isOpen = false
        self:Tween(dropList, {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)}, 0.2)
        -- NOVO: Trocar ícone se Asset ID diferente
        if arrowOpenIconAssetId and arrowIconAssetId and arrow:IsA("ImageLabel") then
            arrow.Image = self:FormatAssetId(arrowIconAssetId)
        else
            self:Tween(arrow, {Rotation = 0}, 0.2)
        end
        if dropStroke then
            self:Tween(dropStroke, {Color = self.Theme.Border, Transparency = 0.4}, 0.2)
        end
        task.wait(0.2)
        if dropList and dropList.Parent then
            dropList.Visible = false
        end
    end
    
    self:_RegisterDropdown(dropList, dropBtn, closeDropdown)
    
    local function getPriority(name)
        for i, v in ipairs(selected) do
            if v == name then return i end
        end
        return nil
    end
    
    local function toggle(name)
        for i, v in ipairs(selected) do
            if v == name then
                table.remove(selected, i)
                return
            end
        end
        table.insert(selected, name)
    end
    
    local function populate()
        for _, child in ipairs(dropList:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        for _, option in ipairs(options) do
            local priority = getPriority(option)
            local isSelected = priority ~= nil
            
            local row = Instance.new("Frame")
            row.BackgroundColor3 = isSelected and Color3.fromRGB(40, 10, 10) or self.Theme.Input
            row.Size = UDim2.new(1, 0, 0, self:S(28))
            row.ZIndex = 101
            row.Parent = dropList
            self:CreateCorner(row, UDim.new(0, 5))
            
            if isSelected then
                self:CreateStroke(row, self.Theme.Accent, 1, 0.2)
                
                -- Badge com número
                local badge = Instance.new("TextLabel")
                badge.BackgroundColor3 = self.Theme.Accent
                badge.Position = UDim2.new(0, self:S(6), 0.5, -self:S(9))
                badge.Size = UDim2.new(0, self:S(18), 0, self:S(18))
                badge.Font = Enum.Font.GothamBold
                badge.Text = tostring(priority)
                badge.TextColor3 = Color3.new(1, 1, 1)
                badge.TextSize = self:S(10)
                badge.ZIndex = 102
                badge.Parent = row
                self:CreateCorner(badge, UDim.new(1, 0))
            end
            
            local rowBtn = Instance.new("TextButton")
            rowBtn.BackgroundTransparency = 1
            rowBtn.Size = UDim2.new(1, 0, 1, 0)
            rowBtn.Font = Enum.Font.GothamSemibold
            rowBtn.Text = (isSelected and "      " or "  ") .. option
            rowBtn.TextColor3 = isSelected and self.Theme.AccentSecondary or self.Theme.TextSecondary
            rowBtn.TextSize = self:S(11)
            rowBtn.TextXAlignment = Enum.TextXAlignment.Left
            rowBtn.ZIndex = 102
            rowBtn.Parent = row
            
            local rowPad = Instance.new("UIPadding")
            rowPad.PaddingLeft = UDim.new(0, self:S(12))
            rowPad.Parent = rowBtn
            
            rowBtn.MouseButton1Click:Connect(function()
                toggle(option)
                callback(selected)
                updateText()
                populate()
            end)
            
            rowBtn.MouseEnter:Connect(function()
                if not isSelected then
                    self:Tween(row, {BackgroundColor3 = self.Theme.CardHover}, 0.1)
                end
            end)
            
            rowBtn.MouseLeave:Connect(function()
                if not isSelected then
                    self:Tween(row, {BackgroundColor3 = self.Theme.Input}, 0.1)
                end
            end)
        end
    end
    
    dropBtn.MouseEnter:Connect(function()
        self:Tween(dropBtn, {BackgroundColor3 = self.Theme.InputHover}, 0.15)
    end)
    
    dropBtn.MouseLeave:Connect(function()
        self:Tween(dropBtn, {BackgroundColor3 = self.Theme.Input}, 0.15)
    end)
    
    dropBtn.MouseButton1Click:Connect(function()
        if isOpen then
            closeDropdown()
            return
        end
        
        for _, dd in ipairs(self.Dropdowns) do
            if dd ~= dropList then dd.Visible = false end
        end
        
        populate()
        local pos, targetH, contentH = getDropdownPosition(dropBtn, listLayout, maxHeight)
        dropList.Position = pos
        dropList.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
        dropList.CanvasSize = UDim2.new(0, 0, 0, contentH)
        dropList.Visible = true
        
        self:Tween(dropList, {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, targetH)}, 0.25,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        -- NOVO: Trocar ícone se Asset ID diferente
        if arrowOpenIconAssetId and arrow:IsA("ImageLabel") then
            arrow.Image = self:FormatAssetId(arrowOpenIconAssetId)
        else
            self:Tween(arrow, {Rotation = 180}, 0.2)
        end
        if dropStroke then
            self:Tween(dropStroke, {Color = self.Theme.Accent, Transparency = 0.2}, 0.2)
        end
        isOpen = true
    end)
    
    updateText()
    
    return {
        Frame = frame,
        GetValues = function() return selected end,
        SetValues = function(v)
            selected = v
            updateText()
        end,
        SetOptions = function(newOptions)
            options = newOptions
            if isOpen then populate() end
        end,
    }
end

-- ─── CREATE CHECKBOX ──────────────────────────────────────────────────────────
function SpectrumX:CreateCheckbox(parent, config)
    config = config or {}
    local text = config.Text or "Checkbox"
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    -- CORREÇÃO: Altura menor
    local height = self:S(38)
    
    local frame = Instance.new("Frame")
    frame.Name = "Checkbox_" .. text
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    self:CreateStroke(frame, self.Theme.Border, 1, 0.4)
    
    -- Checkbox - CORREÇÃO: Tamanho menor
    local cbSize = self:S(18)
    local checkbox = Instance.new("TextButton")
    checkbox.Name = "Checkbox"
    checkbox.BackgroundColor3 = default and self.Theme.Accent or self.Theme.Input
    checkbox.AutoButtonColor = false
    checkbox.Position = UDim2.new(0, self:S(12), 0.5, -cbSize/2)
    checkbox.Size = UDim2.new(0, cbSize, 0, cbSize)
    checkbox.Font = Enum.Font.GothamBold
    checkbox.Text = default and "✓" or ""
    checkbox.TextColor3 = Color3.new(1, 1, 1)
    checkbox.TextSize = self:S(12)
    checkbox.ZIndex = 14
    checkbox.Parent = frame
    self:CreateCorner(checkbox, UDim.new(0, 4))
    self:CreateStroke(checkbox, default and self.Theme.Accent or self.Theme.Border, 1.5, default and 0.2 or 0.4)
    
    local cbStroke = checkbox:FindFirstChildOfClass("UIStroke")
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self:S(38), 0, 0)
    label.Size = UDim2.new(1, -self:S(52), 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = self.Theme.Text
    label.TextSize = self:S(12)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.ZIndex = 13
    label.Parent = frame
    
    local state = default
    
    checkbox.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        
        if state then
            self:Tween(checkbox, {BackgroundColor3 = self.Theme.Accent}, 0.2)
            if cbStroke then
                self:Tween(cbStroke, {Color = self.Theme.Accent, Transparency = 0.2}, 0.2)
            end
            checkbox.Text = "✓"
        else
            self:Tween(checkbox, {BackgroundColor3 = self.Theme.Input}, 0.2)
            if cbStroke then
                self:Tween(cbStroke, {Color = self.Theme.Border, Transparency = 0.4}, 0.2)
            end
            checkbox.Text = ""
        end
    end)
    
    return {
        Frame = frame,
        GetState = function() return state end,
        SetState = function(s)
            state = s
            callback(state)
            self:Tween(checkbox, {BackgroundColor3 = state and self.Theme.Accent or self.Theme.Input}, 0.2)
            checkbox.Text = state and "✓" or ""
        end,
    }
end

-- ─── CREATE LABEL ─────────────────────────────────────────────────────────────
-- CORREÇÃO PRINCIPAL: Agora suporta quebra de linha automática!
function SpectrumX:CreateLabel(parent, config)
    config = config or {}
    local text = config.Text or "Label"
    local color = config.Color or self.Theme.TextSecondary
    local autoSize = config.AutoSize ~= false -- Default true
    local wrapped = config.Wrapped ~= false -- Default true (CORREÇÃO!)
    
    -- Calcular altura baseada no texto
    local minHeight = self:S(32)
    local padding = self:S(16)
    
    local frame = Instance.new("Frame")
    frame.Name = "Label_" .. text:sub(1, 10)
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, minHeight)
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    self:CreateStroke(frame, self.Theme.Border, 1, 0.4)
    
    -- Label com quebra de linha automática
    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, self:S(12), 0, 0)
    label.Size = UDim2.new(1, -self:S(24), 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 = color
    label.TextSize = self:S(11)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    -- CORREÇÃO: Quebra de linha automática!
    label.TextWrapped = wrapped
    
    -- CORREÇÃO: Ajuste automático de tamanho
    if autoSize then
        label.AutomaticSize = Enum.AutomaticSize.Y
    end
    
    label.ZIndex = 13
    label.Parent = frame
    
    -- Ajustar altura do frame quando o texto mudar
    if autoSize then
        label:GetPropertyChangedSignal("TextBounds"):Connect(function()
            local newHeight = math.max(minHeight, label.TextBounds.Y + padding)
            frame.Size = UDim2.new(1, 0, 0, newHeight)
        end)
        
        -- Ajuste inicial
        task.delay(0.1, function()
            if label and label.Parent then
                local newHeight = math.max(minHeight, label.TextBounds.Y + padding)
                frame.Size = UDim2.new(1, 0, 0, newHeight)
            end
        end)
    end
    
    return {
        Frame = frame,
        Label = label,
        SetText = function(t)
            label.Text = t
        end,
        SetColor = function(c)
            label.TextColor3 = c
        end,
    }
end

-- ─── CREATE SEPARATOR ─────────────────────────────────────────────────────────
function SpectrumX:CreateSeparator(parent)
    local wrap = Instance.new("Frame")
    wrap.Name = "Separator"
    wrap.BackgroundTransparency = 1
    wrap.Size = UDim2.new(1, 0, 0, self:S(10))
    wrap.ZIndex = 12
    wrap.Parent = parent
    
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.BackgroundColor3 = self.Theme.Border
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.ZIndex = 12
    line.Parent = wrap
    
    self:CreateGradient(line, Color3.new(0, 0, 0), self.Theme.BorderBright, 0)
    
    return wrap
end

-- ─── CREATE STATUS CARD ───────────────────────────────────────────────────────
function SpectrumX:CreateStatusCard(parent, config)
    config = config or {}
    local title = config.Title or "Status"
    
    -- CORREÇÃO: Altura menor
    local height = self:S(100)
    
    local frame = Instance.new("Frame")
    frame.Name = "StatusCard"
    frame.BackgroundColor3 = self.Theme.Card
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.Active = true
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame, UDim.new(0, 10))
    
    -- Stroke animado
    local stroke = self:CreateStroke(frame, self.Theme.Accent, 1.5, 0)
    
    spawn(function()
        while frame and frame.Parent do
            self:Tween(stroke, {Transparency = 0.1}, 1)
            task.wait(1)
            if not frame or not frame.Parent then break end
            self:Tween(stroke, {Transparency = 0.6}, 1)
            task.wait(1)
        end
    end)
    
    -- Barra lateral
    local leftBar = Instance.new("Frame")
    leftBar.Name = "LeftBar"
    leftBar.BackgroundColor3 = self.Theme.Accent
    leftBar.BorderSizePixel = 0
    leftBar.Position = UDim2.new(0, 0, 0, 0)
    leftBar.Size = UDim2.new(0, 3, 1, 0)
    leftBar.ZIndex = 13
    leftBar.Parent = frame
    self:CreateCorner(leftBar, UDim.new(0, 10))
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundColor3 = self.Theme.Header
    header.BorderSizePixel = 0
    header.Size = UDim2.new(1, 0, 0, self:S(30))
    header.Parent = frame
    self:CreateCorner(header, UDim.new(0, 10))
    
    local headerCover = Instance.new("Frame")
    headerCover.BackgroundColor3 = self.Theme.Header
    headerCover.BorderSizePixel = 0
    headerCover.Size = UDim2.new(1, 0, 0, 10)
    headerCover.Position = UDim2.new(0, 0, 1, -10)
    headerCover.Parent = header
    
    local headerTitle = Instance.new("TextLabel")
    headerTitle.Name = "Title"
    headerTitle.BackgroundTransparency = 1
    headerTitle.Position = UDim2.new(0, self:S(14), 0, 0)
    headerTitle.Size = UDim2.new(1, -self:S(14), 1, 0)
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.Text = title
    headerTitle.TextColor3 = self.Theme.Text
    headerTitle.TextSize = self:S(11)
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.ZIndex = 14
    headerTitle.Parent = header
    
    -- Content
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, self:S(12), 0, self:S(34))
    content.Size = UDim2.new(1, -self:S(24), 1, -self:S(44))
    content.ZIndex = 13
    content.Parent = frame
    
    -- Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.BackgroundTransparency = 1
    statusLabel.Size = UDim2.new(1, 0, 0, self:S(18))
    statusLabel.Font = Enum.Font.GothamSemibold
    statusLabel.Text = "● Idle"
    statusLabel.TextColor3 = self.Theme.TextMuted
    statusLabel.TextSize = self:S(11)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 14
    statusLabel.Parent = content
    
    -- Info
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "Info"
    infoLabel.BackgroundTransparency = 1
    infoLabel.Position = UDim2.new(0, 0, 0, self:S(20))
    infoLabel.Size = UDim2.new(1, 0, 0, self:S(14))
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Text = "Aguardando..."
    infoLabel.TextColor3 = self.Theme.TextMuted
    infoLabel.TextSize = self:S(9)
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.ZIndex = 14
    infoLabel.Parent = content
    
    -- Barra de progresso
    local barBg = Instance.new("Frame")
    barBg.Name = "BarBg"
    barBg.BackgroundColor3 = self.Theme.Input
    barBg.Position = UDim2.new(0, 0, 1, -self:S(5))
    barBg.Size = UDim2.new(1, 0, 0, self:S(4))
    barBg.ClipsDescendants = true
    barBg.ZIndex = 13
    barBg.Parent = content
    self:CreateCorner(barBg, UDim.new(1, 0))
    
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.BackgroundColor3 = self.Theme.Accent
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BorderSizePixel = 0
    bar.ZIndex = 14
    bar.Parent = barBg
    self:CreateCorner(bar, UDim.new(1, 0))
    self:CreateGradient(bar, self.Theme.Accent, self.Theme.AccentDark, 0)
    
    self:MakeDraggable(frame, header)
    
    return {
        Frame = frame,
        SetStatus = function(status, color)
            statusLabel.Text = "● " .. status
            statusLabel.TextColor3 = color or self.Theme.TextMuted
        end,
        SetInfo = function(info)
            infoLabel.Text = info
        end,
        SetProgress = function(percent)
            bar.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
        end,
        AnimateLoading = function(active, duration)
            if active then
                spawn(function()
                    while active and frame and frame.Parent do
                        bar.Size = UDim2.new(0, 0, 1, 0)
                        local tween = self:Tween(bar, {Size = UDim2.new(1, 0, 1, 0)}, duration or 1.5)
                        tween.Completed:Wait()
                        task.wait(0.1)
                    end
                end)
            else
                bar.Size = UDim2.new(0, 0, 1, 0)
            end
        end,
    }
end



-- ─── CREATE LABELTOGGLE ───────────────────────────────────────────────────────
-- NOVO: Toggle com label inferior e ícone de dropdown customizável
function SpectrumX:CreateLabelToggle(parent, config)
    config = config or {}
    local text = config.Text or "LabelToggle"
    local labelText = config.Label or ""  -- Texto do label inferior
    local default = config.Default or false
    local callback = config.Callback or function() end
    -- NOVO: Asset ID customizável para o ícone de dropdown
    local arrowIconAssetId = config.ArrowIconAssetId or nil
    local arrowOpenIconAssetId = config.ArrowOpenIconAssetId or arrowIconAssetId
    -- NOVO: Callback quando clicar no label/ícone (para expandir algo)
    local onExpand = config.OnExpand or nil
    
    -- Altura maior para acomodar o label inferior
    local height = self:S(62)
    
    local frame = Instance.new("Frame")
    frame.Name = "LabelToggle_" .. text
    frame.BackgroundColor3 = self.Theme.Card
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.ZIndex = 12
    frame.Parent = parent
    self:CreateCorner(frame)
    self:CreateStroke(frame, self.Theme.Border, 1, 0.5)
    
    -- Efeito hover
    local hoverFill = Instance.new("Frame")
    hoverFill.Name = "HoverFill"
    hoverFill.BackgroundColor3 = Color3.new(1, 1, 1)
    hoverFill.BackgroundTransparency = 1
    hoverFill.BorderSizePixel = 0
    hoverFill.Size = UDim2.new(1, 0, 1, 0)
    hoverFill.ZIndex = 0
    hoverFill.Parent = frame
    self:CreateCorner(hoverFill)
    
    -- Container do texto principal e linha
    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.BackgroundTransparency = 1
    textContainer.Position = UDim2.new(0, self:S(12), 0, 0)
    textContainer.Size = UDim2.new(0.55, 0, 1, 0)
    textContainer.ZIndex = 13
    textContainer.Parent = frame
    
    -- Label principal
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Name = "MainLabel"
    mainLabel.BackgroundTransparency = 1
    mainLabel.Position = UDim2.new(0, 0, 0, self:S(8))
    mainLabel.Size = UDim2.new(1, 0, 0, self:S(16))
    mainLabel.Font = Enum.Font.GothamSemibold
    mainLabel.Text = text
    mainLabel.TextColor3 = self.Theme.Text
    mainLabel.TextSize = self:S(12)
    mainLabel.TextXAlignment = Enum.TextXAlignment.Left
    mainLabel.ZIndex = 14
    mainLabel.Parent = textContainer
    
    -- Linha separadora
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.BackgroundColor3 = self.Theme.Border
    separator.BorderSizePixel = 0
    separator.Position = UDim2.new(0, 0, 0.5, 0)
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.ZIndex = 14
    separator.Parent = textContainer
    
    -- Label inferior
    local subLabel = Instance.new("TextLabel")
    subLabel.Name = "SubLabel"
    subLabel.BackgroundTransparency = 1
    subLabel.Position = UDim2.new(0, 0, 0.55, 0)
    subLabel.Size = UDim2.new(1, 0, 0, self:S(14))
    subLabel.Font = Enum.Font.Gotham
    subLabel.Text = labelText
    subLabel.TextColor3 = self.Theme.TextMuted
    subLabel.TextSize = self:S(10)
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.ZIndex = 14
    subLabel.Parent = textContainer
    
    -- Track do toggle
    local trackWidth, trackHeight = self:S(42), self:S(22)
    local track = Instance.new("TextButton")
    track.Name = "Track"
    track.AutoButtonColor = false
    track.BackgroundColor3 = default and self.Theme.ToggleOn or self.Theme.ToggleOff
    track.Position = UDim2.new(1, -trackWidth - self:S(12), 0.5, -trackHeight/2)
    track.Size = UDim2.new(0, trackWidth, 0, trackHeight)
    track.Text = ""
    track.ZIndex = 14
    track.Parent = frame
    self:CreateCorner(track, UDim.new(1, 0))
    self:CreateStroke(track, default and self.Theme.Accent or self.Theme.Border, 1, default and 0.2 or 0.5)
    
    local trackStroke = track:FindFirstChildOfClass("UIStroke")
    
    -- Knob
    local knobSize = self:S(16)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Position = default and UDim2.new(1, -knobSize - self:S(3), 0.5, -knobSize/2)
                             or UDim2.new(0, self:S(3), 0.5, -knobSize/2)
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.ZIndex = 15
    knob.Parent = track
    self:CreateCorner(knob, UDim.new(1, 0))
    self:CreateStroke(knob, Color3.fromRGB(200, 200, 200), 1, 0.3)
    
    -- NOVO: Ícone de dropdown/expandir (opcional)
    local expandBtn
    if arrowIconAssetId and self:IsAssetId(arrowIconAssetId) then
        -- Asset ID para ícone
        expandBtn = Instance.new("ImageButton")
        expandBtn.Name = "ExpandBtn"
        expandBtn.BackgroundTransparency = 1
        expandBtn.Position = UDim2.new(1, -trackWidth - self:S(40), 0.5, -self:S(10))
        expandBtn.Size = UDim2.new(0, self:S(20), 0, self:S(20))
        expandBtn.Image = self:FormatAssetId(arrowIconAssetId)
        expandBtn.ImageColor3 = self.Theme.TextMuted
        expandBtn.ScaleType = Enum.ScaleType.Fit
        expandBtn.AutoButtonColor = false
        expandBtn.ZIndex = 14
        expandBtn.Parent = frame
    elseif arrowIconAssetId then
        -- Texto como fallback
        expandBtn = Instance.new("TextButton")
        expandBtn.Name = "ExpandBtn"
        expandBtn.BackgroundTransparency = 1
        expandBtn.Position = UDim2.new(1, -trackWidth - self:S(40), 0.5, -self:S(10))
        expandBtn.Size = UDim2.new(0, self:S(20), 0, self:S(20))
        expandBtn.Font = Enum.Font.GothamBold
        expandBtn.Text = "▾"
        expandBtn.TextColor3 = self.Theme.TextMuted
        expandBtn.TextSize = self:S(14)
        expandBtn.AutoButtonColor = false
        expandBtn.ZIndex = 14
        expandBtn.Parent = frame
    end
    
    local state = default
    local isExpanded = false
    
    local function update(newState, animated)
        local time = animated == false and 0 or 0.2
        state = newState
        
        if state then
            self:Tween(track, {BackgroundColor3 = self.Theme.ToggleOn}, time)
            if trackStroke then
                self:Tween(trackStroke, {Color = self.Theme.Accent, Transparency = 0.2}, time)
            end
            self:Tween(knob, {
                Position = UDim2.new(1, -knobSize - self:S(3), 0.5, -knobSize/2)
            }, time, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            self:Tween(track, {BackgroundColor3 = self.Theme.ToggleOff}, time)
            if trackStroke then
                self:Tween(trackStroke, {Color = self.Theme.Border, Transparency = 0.5}, time)
            end
            self:Tween(knob, {
                Position = UDim2.new(0, self:S(3), 0.5, -knobSize/2)
            }, time, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end
    
    -- Toggle click
    track.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        update(state)
    end)
    
    -- NOVO: Expandir ao clicar no ícone
    if expandBtn and onExpand then
        expandBtn.MouseButton1Click:Connect(function()
            isExpanded = not isExpanded
            
            -- Animar rotação do ícone
            if expandBtn:IsA("ImageButton") and arrowOpenIconAssetId then
                if isExpanded then
                    expandBtn.Image = self:FormatAssetId(arrowOpenIconAssetId)
                else
                    expandBtn.Image = self:FormatAssetId(arrowIconAssetId)
                end
            else
                self:Tween(expandBtn, {Rotation = isExpanded and 180 or 0}, 0.2)
            end
            
            -- Chamar callback
            onExpand(isExpanded)
        end)
        
        expandBtn.MouseEnter:Connect(function()
            if expandBtn:IsA("ImageButton") then
                self:Tween(expandBtn, {ImageColor3 = self.Theme.Accent}, 0.15)
            else
                self:Tween(expandBtn, {TextColor3 = self.Theme.Accent}, 0.15)
            end
        end)
        
        expandBtn.MouseLeave:Connect(function()
            if expandBtn:IsA("ImageButton") then
                self:Tween(expandBtn, {ImageColor3 = self.Theme.TextMuted}, 0.15)
            else
                self:Tween(expandBtn, {TextColor3 = self.Theme.TextMuted}, 0.15)
            end
        end)
    end
    
    -- Hover
    frame.MouseEnter:Connect(function()
        self:Tween(hoverFill, {BackgroundTransparency = 0.97}, 0.15)
    end)
    
    frame.MouseLeave:Connect(function()
        self:Tween(hoverFill, {BackgroundTransparency = 1}, 0.15)
    end)
    
    return {
        Frame = frame,
        GetState = function() return state end,
        SetState = function(s) state = s; callback(state); update(state) end,
        SetLabel = function(l) subLabel.Text = l end,
        GetIsExpanded = function() return isExpanded end,
        SetExpanded = function(e)
            isExpanded = e
            if expandBtn then
                if expandBtn:IsA("ImageButton") and arrowOpenIconAssetId then
                    if isExpanded then
                        expandBtn.Image = self:FormatAssetId(arrowOpenIconAssetId)
                    else
                        expandBtn.Image = self:FormatAssetId(arrowIconAssetId)
                    end
                else
                    expandBtn.Rotation = isExpanded and 180 or 0
                end
            end
        end,
    }
end



-- ─── NOTIFICATIONS ────────────────────────────────────────────────────────────
-- CORREÇÃO: Barra de progresso corrigida - sem borda estranha no lado esquerdo
function SpectrumX:Notify(config)
    config = config or {}
    local text = config.Text or "Notificação"
    local ntype = config.Type or "info"
    local duration = config.Duration or 4
    
    self:UpdateScale()
    
    local notifWidth = self:S(ScaleData.IsMobile and 300 or 340)
    local notifHeight = self:S(ScaleData.IsMobile and 70 or 76)
    
    -- Cores por tipo
    local color = self.Theme.Info
    if ntype == "success" then
        color = self.Theme.Success
    elseif ntype == "warning" then
        color = self.Theme.Warning
    elseif ntype == "error" then
        color = self.Theme.Error
    end
    
    -- Wrapper transparente: é ele que se move/anima, sem visual próprio
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.BackgroundTransparency = 1
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(0, notifWidth, 0, notifHeight)
    notif.ZIndex = 2000
    notif.ClipsDescendants = false
    notif.Parent = self.ScreenGui

    -- Card interno: tem background e stroke neutro
    local card = Instance.new("Frame")
    card.Name = "Card"
    card.BackgroundColor3 = self.Theme.Card
    card.BorderSizePixel = 0
    card.Size = UDim2.new(1, 0, 1, 0)
    card.ZIndex = 2000
    card.ClipsDescendants = false
    card.Parent = notif
    self:CreateCorner(card, UDim.new(0, 10))
    self:CreateStroke(card, self.Theme.Border, 1, 0.5)

    -- CORREÇÃO: Barra lateral colorida - posicionada corretamente dentro do card
    -- sem ultrapassar as bordas
    local colorBar = Instance.new("Frame")
    colorBar.Name = "ColorBar"
    colorBar.BackgroundColor3 = color
    colorBar.BorderSizePixel = 0
    -- CORREÇÃO: Posição ajustada para não ficar na borda
    colorBar.Size = UDim2.new(0, 4, 1, -self:S(16))
    colorBar.Position = UDim2.new(0, self:S(8), 0, self:S(8))
    colorBar.ZIndex = 2002
    colorBar.Parent = card
    self:CreateCorner(colorBar, UDim.new(1, 0))

    -- Ícone (dentro do card)
    local iconText = ntype == "success" and "✓" or
                     ntype == "warning" and "⚠" or
                     ntype == "error" and "✕" or "ℹ"

    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, self:S(20), 0, 0)
    icon.Size = UDim2.new(0, self:S(28), 1, 0)
    icon.Font = Enum.Font.GothamBlack
    icon.Text = iconText
    icon.TextColor3 = color
    icon.TextSize = self:S(20)
    icon.ZIndex = 2002
    icon.Parent = card

    -- Texto (dentro do card)
    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.BackgroundTransparency = 1
    textContainer.Position = UDim2.new(0, self:S(54), 0, self:S(8))
    textContainer.Size = UDim2.new(1, -self:S(70), 1, -self:S(16))
    textContainer.ZIndex = 2002
    textContainer.Parent = card

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.Text = text
    textLabel.TextColor3 = self.Theme.Text
    textLabel.TextSize = self:S(12)
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.ZIndex = 2003
    textLabel.Parent = textContainer

    -- CORREÇÃO: Barra de progresso - dentro do card, na parte inferior
    -- sem transbordar para fora
    local progBg = Instance.new("Frame")
    progBg.Name = "ProgressBg"
    progBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    progBg.BorderSizePixel = 0
    progBg.AnchorPoint = Vector2.new(0.5, 1)
    -- CORREÇÃO: Posicionada dentro do card com margens adequadas
    progBg.Position = UDim2.new(0.5, 0, 1, -self:S(6))
    progBg.Size = UDim2.new(1, -self:S(16), 0, self:S(3))
    progBg.ClipsDescendants = true
    progBg.ZIndex = 2001
    progBg.Parent = card
    self:CreateCorner(progBg, UDim.new(1, 0))

    local progBar = Instance.new("Frame")
    progBar.Name = "ProgressBar"
    progBar.BackgroundColor3 = color
    progBar.Size = UDim2.new(1, 0, 1, 0)
    progBar.BorderSizePixel = 0
    progBar.ZIndex = 2002
    progBar.Parent = progBg
    self:CreateCorner(progBar, UDim.new(1, 0))

    -- Botão de fechar invisível (clique na notificação)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(1, 0, 1, 0)
    closeBtn.Text = ""
    closeBtn.ZIndex = 2010
    closeBtn.Parent = notif
    
    -- Adicionar à lista de notificações
    table.insert(self._notifications, notif)
    
    -- Função para obter viewport
    local function getViewport()
        local success, camera = pcall(function() return workspace.CurrentCamera end)
        return (success and camera) and camera.ViewportSize or Vector2.new(1366, 768)
    end
    
    -- Reorganizar notificações
    local function restack()
        local viewport = getViewport()
        local offset = self:S(14)
        
        for i = #self._notifications, 1, -1 do
            local n = self._notifications[i]
            if n and n.Parent then
                local targetY = viewport.Y - notifHeight - offset
                self:Tween(n, {
                    Position = UDim2.fromOffset(viewport.X - notifWidth - self:S(16), targetY)
                }, 0.3)
                offset = offset + notifHeight + self:S(8)
            end
        end
    end
    
    -- Fechar notificação
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        
        -- Remover da lista
        for i, n in ipairs(self._notifications) do
            if n == notif then
                table.remove(self._notifications, i)
                break
            end
        end
        
        -- Animação de saída
        local viewport = getViewport()
        self:Tween(notif, {
            Position = UDim2.fromOffset(viewport.X + notifWidth + 50, notif.AbsolutePosition.Y)
        }, 0.3)
        
        -- Também fade out nos filhos
        for _, child in ipairs(notif:GetDescendants()) do
            if child:IsA("GuiObject") and child ~= notif then
                self:Tween(child, {BackgroundTransparency = 1, TextTransparency = 1, ImageTransparency = 1}, 0.3)
            end
        end
        
        restack()
        task.wait(0.35)
        
        if notif and notif.Parent then
            notif:Destroy()
        end
    end
    
    closeBtn.MouseButton1Click:Connect(dismiss)
    
    -- Animação de entrada
    local viewport = getViewport()
    notif.Position = UDim2.fromOffset(viewport.X + notifWidth + 50, viewport.Y - notifHeight - self:S(14))
    
    self:Tween(notif, {
        Position = UDim2.fromOffset(viewport.X - notifWidth - self:S(16), viewport.Y - notifHeight - self:S(14))
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    restack()
    
    -- Animação do timer
    self:Tween(progBar, {Size = UDim2.new(0, 0, 1, 0)}, duration)
    
    -- Auto-fechar
    task.delay(duration, function()
        if not dismissed then
            dismiss()
        end
    end)
end

-- ─── DESTROY ──────────────────────────────────────────────────────────────────
function SpectrumX:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- ─── GET WINDOW ───────────────────────────────────────────────────────────────
function SpectrumX:GetWindow()
    return self.MainFrame
end

-- ─── SET VISIBLE ──────────────────────────────────────────────────────────────
function SpectrumX:SetVisible(visible)
    if self.MainFrame then
        self.MainFrame.Visible = visible
    end
    if self.FloatBtn then
        -- Opcional: também esconder botão flutuante
        -- self.FloatBtn.Visible = not visible
    end
end

-- ─── TOGGLE VISIBILITY ────────────────────────────────────────────────────────
function SpectrumX:Toggle()
    if self.MainFrame then
        self:SetVisible(not self.MainFrame.Visible)
    end
end

-- ─── SET POSITION ─────────────────────────────────────────────────────────────
function SpectrumX:SetPosition(position)
    if self.MainFrame then
        self.MainFrame.Position = position
    end
end

-- ─── SET SIZE ─────────────────────────────────────────────────────────────────
function SpectrumX:SetSize(size)
    if self.MainFrame then
        self.MainFrame.Size = size
    end
end

-- ─── UPDATE THEME ─────────────────────────────────────────────────────────────
function SpectrumX:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        if self.Theme[key] then
            self.Theme[key] = value
        end
    end
end

-- ─── ADD LUCIDE ICON ──────────────────────────────────────────────────────────
-- NOVO: Adicionar ícone Lucide personalizado
function SpectrumX:AddLucideIcon(name, iconChar)
    self.LucideIcons[name:lower()] = iconChar
end

-- ─── GET LUCIDE ICONS LIST ────────────────────────────────────────────────────
-- NOVO: Obter lista de ícones Lucide disponíveis
function SpectrumX:GetLucideIconsList()
    local list = {}
    for name, _ in pairs(self.LucideIcons) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

-- Retornar a biblioteca
return SpectrumX
