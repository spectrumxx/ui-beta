--[[
    SpectrumX Acrylic Element
    Efeito vidro fosco (Glassmorphism) para Roblox
    
    Inspirado na Fluent UI - dawid-scripts
--]]

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Acrylic = {}

-- Estado
Acrylic.Enabled = false
Acrylic.Effect = nil
Acrylic.Defaults = {}

-- ─── INICIALIZAR ──────────────────────────────────────────────────────────────
function Acrylic:Init()
    if self.Effect then return end
    
    -- Criar efeito de profundidade de campo
    self.Effect = Instance.new("DepthOfFieldEffect")
    self.Effect.FarIntensity = 0
    self.Effect.InFocusRadius = 0.1
    self.Effect.NearIntensity = 1
    self.Effect.Enabled = false
    
    -- Registrar efeitos padrão
    self:RegisterDefaults()
end

-- ─── REGISTRAR EFEITOS PADRÃO ─────────────────────────────────────────────────
function Acrylic:RegisterDefaults()
    local function register(object)
        if object:IsA("DepthOfFieldEffect") then
            self.Defaults[object] = { enabled = object.Enabled }
        end
    end
    
    -- Registrar no Lighting
    for _, child in ipairs(Lighting:GetChildren()) do
        register(child)
    end
    
    -- Registrar na câmera
    local camera = workspace.CurrentCamera
    if camera then
        for _, child in ipairs(camera:GetChildren()) do
            register(child)
        end
    end
end

-- ─── HABILITAR ────────────────────────────────────────────────────────────────
function Acrylic:Enable()
    if not self.Effect then
        self:Init()
    end
    
    -- Desabilitar efeitos existentes
    for effect, data in pairs(self.Defaults) do
        effect.Enabled = false
    end
    
    -- Habilitar nosso efeito
    self.Effect.Parent = Lighting
    self.Effect.Enabled = true
    self.Enabled = true
end

-- ─── DESABILITAR ──────────────────────────────────────────────────────────────
function Acrylic:Disable()
    if not self.Effect then return end
    
    -- Restaurar efeitos padrão
    for effect, data in pairs(self.Defaults) do
        effect.Enabled = data.enabled
    end
    
    -- Desabilitar nosso efeito
    self.Effect.Parent = nil
    self.Enabled = false
end

-- ─── TOGGLE ───────────────────────────────────────────────────────────────────
function Acrylic:Toggle(enabled)
    if enabled then
        self:Enable()
    else
        self:Disable()
    end
end

-- ─── CRIAR PAINT ACRYLIC ──────────────────────────────────────────────────────
function Acrylic:CreatePaint()
    local AcrylicPaint = {}
    
    -- Frame principal com blur
    AcrylicPaint.Frame = Instance.new("Frame")
    AcrylicPaint.Frame.Name = "AcrylicFrame"
    AcrylicPaint.Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    AcrylicPaint.Frame.BackgroundTransparency = 0.15
    AcrylicPaint.Frame.BorderSizePixel = 0
    AcrylicPaint.Frame.Size = UDim2.new(1, 0, 1, 0)
    AcrylicPaint.Frame.ZIndex = 1
    
    -- Gradiente de fundo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 26))
    })
    gradient.Rotation = 90
    gradient.Parent = AcrylicPaint.Frame
    
    -- Overlay para efeito de vidro
    AcrylicPaint.Overlay = Instance.new("Frame")
    AcrylicPaint.Overlay.Name = "Overlay"
    AcrylicPaint.Overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AcrylicPaint.Overlay.BackgroundTransparency = 0.95
    AcrylicPaint.Overlay.BorderSizePixel = 0
    AcrylicPaint.Overlay.Size = UDim2.new(1, 0, 1, 0)
    AcrylicPaint.Overlay.ZIndex = 2
    AcrylicPaint.Overlay.Parent = AcrylicPaint.Frame
    
    -- Função para adicionar parent
    function AcrylicPaint:AddParent(parent)
        self.Frame.Parent = parent
    end
    
    -- Função para destruir
    function AcrylicPaint:Destroy()
        if self.Frame then
            self.Frame:Destroy()
        end
    end
    
    return AcrylicPaint
end

-- ─── CRIAR EFEITO DE BLUR ─────────────────────────────────────────────────────
function Acrylic:CreateBlur(parent, intensity)
    intensity = intensity or 0.15
    
    local blurFrame = Instance.new("Frame")
    blurFrame.Name = "BlurFrame"
    blurFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    blurFrame.BackgroundTransparency = 1 - intensity
    blurFrame.BorderSizePixel = 0
    blurFrame.Size = UDim2.new(1, 0, 1, 0)
    blurFrame.ZIndex = 1
    
    -- Gradiente suave
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 26))
    })
    gradient.Rotation = 90
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    gradient.Parent = blurFrame
    
    blurFrame.Parent = parent
    
    return blurFrame
end

-- ─── CRIAR GLASS PANEL ────────────────────────────────────────────────────────
function Acrylic:CreateGlassPanel(parent, config)
    config = config or {}
    
    local panel = Instance.new("Frame")
    panel.Name = config.Name or "GlassPanel"
    panel.BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(24, 24, 24)
    panel.BackgroundTransparency = config.Transparency or 0.2
    panel.BorderSizePixel = 0
    panel.Size = config.Size or UDim2.new(1, 0, 1, 0)
    panel.Position = config.Position or UDim2.new(0, 0, 0, 0)
    panel.ZIndex = config.ZIndex or 10
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.CornerRadius or UDim.new(0, 12)
    corner.Parent = panel
    
    -- Borda sutil
    if config.ShowBorder ~= false then
        local stroke = Instance.new("UIStroke")
        stroke.Color = config.BorderColor or Color3.fromRGB(39, 39, 42)
        stroke.Thickness = config.BorderThickness or 0.5
        stroke.Transparency = config.BorderTransparency or 0.5
        stroke.Parent = panel
    end
    
    -- Gradiente de fundo
    local gradient = Instance.new("UIGradient")
    gradient.Color = config.Gradient or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 18)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 28))
    })
    gradient.Rotation = config.GradientRotation or 90
    gradient.Parent = panel
    
    panel.Parent = parent
    
    return panel
end

-- ─── CRIAR EFEITO DE VIDRO ────────────────────────────────────────────────────
function Acrylic:CreateGlassEffect(parent, config)
    config = config or {}
    
    local glass = Instance.new("Frame")
    glass.Name = config.Name or "GlassEffect"
    glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glass.BackgroundTransparency = config.Transparency or 0.9
    glass.BorderSizePixel = 0
    glass.Size = config.Size or UDim2.new(1, 0, 1, 0)
    glass.Position = config.Position or UDim2.new(0, 0, 0, 0)
    glass.ZIndex = config.ZIndex or 100
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.CornerRadius or UDim.new(0, 8)
    corner.Parent = glass
    
    -- Gradiente para efeito de vidro
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(1, 0.95)
    })
    gradient.Rotation = 135
    gradient.Parent = glass
    
    glass.Parent = parent
    
    return glass
end

-- ─── ATUALIZAR TRANSPARÊNCIA ──────────────────────────────────────────────────
function Acrylic:SetTransparency(frame, transparency)
    if frame and frame:FindFirstChild("AcrylicFrame") then
        frame.AcrylicFrame.BackgroundTransparency = transparency
    end
end

-- ─── DESTRUIR ─────────────────────────────────────────────────────────────────
function Acrylic:Destroy()
    self:Disable()
    if self.Effect then
        self.Effect:Destroy()
        self.Effect = nil
    end
    self.Defaults = {}
end

return Acrylic
