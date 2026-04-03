--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                         SpectrumX Dark Theme                             ║
    ║                    Tema Dark/Black com Gradiente                         ║
    ╚══════════════════════════════════════════════════════════════════════════╝
    
    Características:
    - Background: gradiente de preto (#0a0a0a → #1a1a1a)
    - Surface: preto fosco com leve transparência
    - Primary: roxo neon (#7c3aed) ou azul (#3b82f6) - configurável
    - Text: branco/cinza claro (#ffffff, #e5e5e5, #a3a3a3)
    - Borders: cinza escuro (#27272a) com 0.5px
    - Efeito Acrylic/Glass (blur background)
    - Cantos arredondados (8-12px)
--]]

local DarkTheme = {}

-- ─── CORES BASE ───────────────────────────────────────────────────────────────
DarkTheme.Background = Color3.fromRGB(10, 10, 10)           -- #0a0a0a
DarkTheme.BackgroundGradient = {
    Color3.fromRGB(10, 10, 10),  -- #0a0a0a
    Color3.fromRGB(26, 26, 26)   -- #1a1a1a
}

DarkTheme.Surface = Color3.fromRGB(18, 18, 18)              -- Preto fosco
DarkTheme.SurfaceHover = Color3.fromRGB(28, 28, 28)         -- Hover state
DarkTheme.SurfaceElevated = Color3.fromRGB(24, 24, 24)      -- Cards elevados

-- ─── CORES DE DESTAQUE (CONFIGURÁVEIS) ────────────────────────────────────────
-- Opção 1: Roxo Neon (padrão)
DarkTheme.Accent = Color3.fromRGB(124, 58, 237)             -- #7c3aed
DarkTheme.AccentHover = Color3.fromRGB(139, 92, 246)        -- #8b5cf6
DarkTheme.AccentSecondary = Color3.fromRGB(167, 139, 250)   -- #a78bfa
DarkTheme.AccentDark = Color3.fromRGB(109, 40, 217)         -- #6d28d9

-- Opção 2: Azul (alternativo) - descomente para usar
--[[
DarkTheme.Accent = Color3.fromRGB(59, 130, 246)             -- #3b82f6
DarkTheme.AccentHover = Color3.fromRGB(96, 165, 250)        -- #60a5fa
DarkTheme.AccentSecondary = Color3.fromRGB(147, 197, 253)   -- #93c5fd
DarkTheme.AccentDark = Color3.fromRGB(37, 99, 235)          -- #2563eb
--]]

-- ─── CORES DE TEXTO ───────────────────────────────────────────────────────────
DarkTheme.Text = Color3.fromRGB(255, 255, 255)              -- #ffffff
DarkTheme.TextSecondary = Color3.fromRGB(229, 229, 229)     -- #e5e5e5
DarkTheme.TextMuted = Color3.fromRGB(163, 163, 163)         -- #a3a3a3
DarkTheme.TextDisabled = Color3.fromRGB(115, 115, 115)      -- #737373

-- ─── CORES DE BORDA ───────────────────────────────────────────────────────────
DarkTheme.Border = Color3.fromRGB(39, 39, 42)               -- #27272a
DarkTheme.BorderLight = Color3.fromRGB(63, 63, 70)          -- #3f3f46
DarkTheme.BorderFocus = Color3.fromRGB(124, 58, 237)        -- Mesmo que Accent

-- ─── CORES DE ESTADO ──────────────────────────────────────────────────────────
DarkTheme.Success = Color3.fromRGB(34, 197, 94)             -- #22c55e
DarkTheme.Warning = Color3.fromRGB(234, 179, 8)             -- #eab308
DarkTheme.Error = Color3.fromRGB(239, 68, 68)               -- #ef4444
DarkTheme.Info = Color3.fromRGB(59, 130, 246)               -- #3b82f6

-- ─── CORES DE COMPONENTES ESPECÍFICOS ─────────────────────────────────────────
-- Toggle
DarkTheme.ToggleOff = Color3.fromRGB(39, 39, 42)            -- #27272a
DarkTheme.ToggleOn = Color3.fromRGB(124, 58, 237)           -- #7c3aed (Accent)
DarkTheme.ToggleKnob = Color3.fromRGB(255, 255, 255)        -- #ffffff

-- Slider
DarkTheme.SliderTrack = Color3.fromRGB(39, 39, 42)          -- #27272a
DarkTheme.SliderFill = Color3.fromRGB(124, 58, 237)         -- #7c3aed (Accent)
DarkTheme.SliderKnob = Color3.fromRGB(255, 255, 255)        -- #ffffff

-- Input
DarkTheme.InputBackground = Color3.fromRGB(28, 28, 28)      -- #1c1c1c
DarkTheme.InputPlaceholder = Color3.fromRGB(115, 115, 115)  -- #737373

-- Dropdown
DarkTheme.DropdownBackground = Color3.fromRGB(24, 24, 24)   -- #181818
DarkTheme.DropdownHover = Color3.fromRGB(35, 35, 35)        -- #232323

-- Button
DarkTheme.ButtonBackground = Color3.fromRGB(28, 28, 28)     -- #1c1c1c
DarkTheme.ButtonHover = Color3.fromRGB(39, 39, 42)          -- #27272a

-- ─── TRANSPARÊNCIAS ───────────────────────────────────────────────────────────
DarkTheme.Transparency = {
    Background = 0,                                          -- Opaco
    Surface = 0.02,                                          -- Quase opaco
    Acrylic = 0.15,                                          -- Efeito vidro
    Border = 0.5,                                            -- Borda sutil
    Text = 0,                                                -- Texto opaco
    TextMuted = 0.3,                                         -- Texto secundário
    Disabled = 0.5                                           -- Elemento desabilitado
}

-- ─── TAMANHOS E ESPAÇAMENTOS ──────────────────────────────────────────────────
DarkTheme.Sizes = {
    CornerRadius = 8,                                        -- Cantos arredondados
    CornerRadiusLarge = 12,                                  -- Cantos maiores
    BorderThickness = 1,                                     -- Espessura da borda
    BorderThicknessFocus = 1.5,                              -- Borda em foco
    
    -- Componentes
    WindowPadding = 16,
    SectionPadding = 12,
    ElementHeight = 40,
    ElementSpacing = 8,
    TabHeight = 36,
    HeaderHeight = 48
}

-- ─── ANIMAÇÕES ────────────────────────────────────────────────────────────────
DarkTheme.Animation = {
    Speed = 0.2,                                             -- Velocidade padrão
    SpeedFast = 0.15,                                        -- Velocidade rápida
    SpeedSlow = 0.3,                                         -- Velocidade lenta
    
    Easing = Enum.EasingStyle.Quad,                          -- Estilo de easing
    EasingDirection = Enum.EasingDirection.Out               -- Direção do easing
}

-- ─── SOMBRAS ──────────────────────────────────────────────────────────────────
DarkTheme.Shadow = {
    Enabled = true,
    Color = Color3.fromRGB(0, 0, 0),
    Transparency = 0.7,
    Size = 20,
    Layers = 4                                               -- Múltiplas camadas
}

-- ─── FUNÇÕES AUXILIARES ───────────────────────────────────────────────────────
function DarkTheme:GetColor(name)
    return self[name] or self.Text
end

function DarkTheme:GetTransparency(name)
    return self.Transparency[name] or 0
end

function DarkTheme:GetSize(name)
    return self.Sizes[name] or 8
end

function DarkTheme:SetAccentColor(colorType)
    if colorType == "blue" then
        self.Accent = Color3.fromRGB(59, 130, 246)
        self.AccentHover = Color3.fromRGB(96, 165, 250)
        self.AccentSecondary = Color3.fromRGB(147, 197, 253)
        self.AccentDark = Color3.fromRGB(37, 99, 235)
        self.ToggleOn = self.Accent
        self.SliderFill = self.Accent
        self.BorderFocus = self.Accent
    elseif colorType == "purple" then
        self.Accent = Color3.fromRGB(124, 58, 237)
        self.AccentHover = Color3.fromRGB(139, 92, 246)
        self.AccentSecondary = Color3.fromRGB(167, 139, 250)
        self.AccentDark = Color3.fromRGB(109, 40, 217)
        self.ToggleOn = self.Accent
        self.SliderFill = self.Accent
        self.BorderFocus = self.Accent
    elseif colorType == "red" then
        self.Accent = Color3.fromRGB(220, 38, 38)
        self.AccentHover = Color3.fromRGB(239, 68, 68)
        self.AccentSecondary = Color3.fromRGB(248, 113, 113)
        self.AccentDark = Color3.fromRGB(153, 27, 27)
        self.ToggleOn = self.Accent
        self.SliderFill = self.Accent
        self.BorderFocus = self.Accent
    elseif colorType == "green" then
        self.Accent = Color3.fromRGB(34, 197, 94)
        self.AccentHover = Color3.fromRGB(74, 222, 128)
        self.AccentSecondary = Color3.fromRGB(134, 239, 172)
        self.AccentDark = Color3.fromRGB(22, 163, 74)
        self.ToggleOn = self.Accent
        self.SliderFill = self.Accent
        self.BorderFocus = self.Accent
    end
end

return DarkTheme
