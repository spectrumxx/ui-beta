--[[
    SpectrumX Responsive Utility
    Sistema de responsividade com breakpoints
    
    Breakpoints:
    - Mobile: < 600px
    - Tablet: 600px - 900px
    - Desktop: > 900px
--]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Responsive = {}

-- ─── BREAKPOINTS ──────────────────────────────────────────────────────────────
Responsive.Breakpoints = {
    Mobile = 600,
    Tablet = 900,
    Desktop = math.huge
}

-- ─── ESTADO ATUAL ─────────────────────────────────────────────────────────────
Responsive.CurrentBreakpoint = "Desktop"
Responsive.IsMobile = false
Responsive.IsTablet = false
Responsive.IsDesktop = true
Responsive.ScaleFactor = 1
Responsive.ViewportSize = Vector2.new(1920, 1080)

-- ─── CALLBACKS ────────────────────────────────────────────────────────────────
Responsive.OnBreakpointChanged = nil
Responsive.OnScaleChanged = nil

-- ─── INICIALIZAR ──────────────────────────────────────────────────────────────
function Responsive:Init()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    self.ViewportSize = camera.ViewportSize
    self:UpdateBreakpoint()
    self:UpdateScaleFactor()
    
    -- Monitorar mudanças no viewport
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local oldBreakpoint = self.CurrentBreakpoint
        self.ViewportSize = camera.ViewportSize
        
        self:UpdateBreakpoint()
        self:UpdateScaleFactor()
        
        if oldBreakpoint ~= self.CurrentBreakpoint and self.OnBreakpointChanged then
            self.OnBreakpointChanged(self.CurrentBreakpoint, oldBreakpoint)
        end
        
        if self.OnScaleChanged then
            self.OnScaleChanged(self.ScaleFactor)
        end
    end)
end

-- ─── ATUALIZAR BREAKPOINT ─────────────────────────────────────────────────────
function Responsive:UpdateBreakpoint()
    local width = self.ViewportSize.X
    
    if width < self.Breakpoints.Mobile then
        self.CurrentBreakpoint = "Mobile"
        self.IsMobile = true
        self.IsTablet = false
        self.IsDesktop = false
    elseif width < self.Breakpoints.Tablet then
        self.CurrentBreakpoint = "Tablet"
        self.IsMobile = false
        self.IsTablet = true
        self.IsDesktop = false
    else
        self.CurrentBreakpoint = "Desktop"
        self.IsMobile = false
        self.IsTablet = false
        self.IsDesktop = true
    end
end

-- ─── ATUALIZAR FATOR DE ESCALA ────────────────────────────────────────────────
function Responsive:UpdateScaleFactor()
    local baseResolution = Vector2.new(1920, 1080)
    local scaleX = self.ViewportSize.X / baseResolution.X
    local scaleY = self.ViewportSize.Y / baseResolution.Y
    
    -- Usar o menor fator para manter proporção
    local scale = math.min(scaleX, scaleY)
    
    -- Ajustar para mobile
    if self.IsMobile then
        self.ScaleFactor = math.clamp(scale, 0.7, 1.1)
    elseif self.IsTablet then
        self.ScaleFactor = math.clamp(scale, 0.8, 1.0)
    else
        self.ScaleFactor = math.clamp(scale, 0.85, 1.05)
    end
end

-- ─── ESCALAR VALOR ────────────────────────────────────────────────────────────
function Responsive:Scale(value)
    if type(value) == "number" then
        return math.floor(value * self.ScaleFactor)
    elseif typeof(value) == "UDim2" then
        return UDim2.new(
            value.X.Scale,
            math.floor(value.X.Offset * self.ScaleFactor),
            value.Y.Scale,
            math.floor(value.Y.Offset * self.ScaleFactor)
        )
    elseif typeof(value) == "UDim" then
        return UDim.new(value.Scale, math.floor(value.Offset * self.ScaleFactor))
    end
    return value
end

-- ─── OBTER TAMANHO ADAPTATIVO ─────────────────────────────────────────────────
function Responsive:GetAdaptiveSize(mobileSize, tabletSize, desktopSize)
    if self.IsMobile then
        return self:Scale(mobileSize)
    elseif self.IsTablet then
        return self:Scale(tabletSize or mobileSize)
    else
        return self:Scale(desktopSize or tabletSize or mobileSize)
    end
end

-- ─── OBTER LARGURA DE TAB ADAPTATIVA ──────────────────────────────────────────
function Responsive:GetTabWidth()
    if self.IsMobile then
        return self:Scale(80)  -- Tabs mais estreitas em mobile
    elseif self.IsTablet then
        return self:Scale(120)
    else
        return self:Scale(160)
    end
end

-- ─── OBTER TAMANHO DE JANELA ADAPTATIVO ───────────────────────────────────────
function Responsive:GetWindowSize()
    if self.IsMobile then
        return UDim2.fromOffset(
            math.min(self.ViewportSize.X - 40, self:Scale(400)),
            math.min(self.ViewportSize.Y - 100, self:Scale(500))
        )
    elseif self.IsTablet then
        return UDim2.fromOffset(
            math.min(self.ViewportSize.X - 100, self:Scale(500)),
            math.min(self.ViewportSize.Y - 100, self:Scale(450))
        )
    else
        return UDim2.fromOffset(
            self:Scale(550),
            self:Scale(600)
        )
    end
end

-- ─── OBTER POSIÇÃO DE JANELA CENTRALIZADA ─────────────────────────────────────
function Responsive:GetWindowCenterPosition(size)
    return UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
end

-- ─── VERIFICAR SE É TOUCH ─────────────────────────────────────────────────────
function Responsive:IsTouchDevice()
    return UserInputService.TouchEnabled
end

-- ─── VERIFICAR SE É MOUSE ─────────────────────────────────────────────────────
function Responsive:IsMouseDevice()
    return UserInputService.MouseEnabled
end

-- ─── VERIFICAR SE É GAMEPAD ───────────────────────────────────────────────────
function Responsive:IsGamepadDevice()
    return UserInputService.GamepadEnabled
end

-- ─── OBTER TIPO DE INPUT PRIMÁRIO ─────────────────────────────────────────────
function Responsive:GetPrimaryInputType()
    if self:IsTouchDevice() and self.IsMobile then
        return "Touch"
    elseif self:IsGamepadDevice() then
        return "Gamepad"
    else
        return "Mouse"
    end
end

-- ─── AJUSTAR ESPAÇAMENTO PARA MOBILE ──────────────────────────────────────────
function Responsive:GetSpacing(defaultSpacing)
    if self.IsMobile then
        return math.floor(defaultSpacing * 0.8)
    end
    return defaultSpacing
end

-- ─── AJUSTAR TAMANHO DE FONTE ─────────────────────────────────────────────────
function Responsive:GetFontSize(defaultSize)
    if self.IsMobile then
        return math.floor(defaultSize * 0.9)
    elseif self.IsTablet then
        return math.floor(defaultSize * 0.95)
    end
    return defaultSize
end

-- ─── AJUSTAR PADDING ──────────────────────────────────────────────────────────
function Responsive:GetPadding(defaultPadding)
    if self.IsMobile then
        return math.floor(defaultPadding * 0.7)
    elseif self.IsTablet then
        return math.floor(defaultPadding * 0.85)
    end
    return defaultPadding
end

-- ─── VERIFICAR ORIENTAÇÃO ─────────────────────────────────────────────────────
function Responsive:GetOrientation()
    if self.ViewportSize.X > self.ViewportSize.Y then
        return "Landscape"
    else
        return "Portrait"
    end
end

-- ─── É LANDSCAPE ──────────────────────────────────────────────────────────────
function Responsive:IsLandscape()
    return self:GetOrientation() == "Landscape"
end

-- ─── É PORTRAIT ───────────────────────────────────────────────────────────────
function Responsive:IsPortrait()
    return self:GetOrientation() == "Portrait"
end

-- ─── CONFIGURAR BREAKPOINTS CUSTOMIZADOS ──────────────────────────────────────
function Responsive:SetBreakpoints(mobile, tablet)
    self.Breakpoints.Mobile = mobile or 600
    self.Breakpoints.Tablet = tablet or 900
    self:UpdateBreakpoint()
end

return Responsive
