--[[
    SpectrumX Label Component
    Texto estático com suporte a rich text
--]]

local TweenService = game:GetService("TweenService")

local Label = {}

-- ─── CRIAR LABEL ──────────────────────────────────────────────────────────────
function Label:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local LabelObj = {}
    
    -- Propriedades
    LabelObj.Text = config.Text or "Label"
    LabelObj.Style = config.Style or "default" -- default, title, subtitle, muted, accent
    LabelObj.Alignment = config.Alignment or "Left" -- Left, Center, Right
    LabelObj.Wrap = config.Wrap ~= false
    LabelObj.RichText = config.RichText or false
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = "LabelFrame"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.ZIndex = 20
    frame.Parent = parent
    
    -- Padding
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, config.PaddingTop or 5)
    padding.PaddingBottom = UDim.new(0, config.PaddingBottom or 5)
    padding.PaddingLeft = UDim.new(0, config.PaddingLeft or 5)
    padding.PaddingRight = UDim.new(0, config.PaddingRight or 5)
    padding.Parent = frame
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.Font = Enum.Font.Gotham
    label.Text = LabelObj.Text
    label.TextWrapped = LabelObj.Wrap
    label.RichText = LabelObj.RichText
    label.ZIndex = 21
    label.Parent = frame
    
    -- Estilos
    local textColor, textSize, fontWeight
    
    if LabelObj.Style == "title" then
        textColor = Theme.Text
        textSize = 18
        fontWeight = Enum.FontWeight.Bold
    elseif LabelObj.Style == "subtitle" then
        textColor = Theme.TextSecondary
        textSize = 14
        fontWeight = Enum.FontWeight.Medium
    elseif LabelObj.Style == "muted" then
        textColor = Theme.TextMuted
        textSize = 12
        fontWeight = Enum.FontWeight.Regular
    elseif LabelObj.Style == "accent" then
        textColor = Theme.Accent
        textSize = 13
        fontWeight = Enum.FontWeight.SemiBold
    elseif LabelObj.Style == "success" then
        textColor = Theme.Success
        textSize = 13
        fontWeight = Enum.FontWeight.SemiBold
    elseif LabelObj.Style == "warning" then
        textColor = Theme.Warning
        textSize = 13
        fontWeight = Enum.FontWeight.SemiBold
    elseif LabelObj.Style == "error" then
        textColor = Theme.Error
        textSize = 13
        fontWeight = Enum.FontWeight.SemiBold
    else -- default
        textColor = Theme.Text
        textSize = 13
        fontWeight = Enum.FontWeight.Regular
    end
    
    label.TextColor3 = textColor
    label.TextSize = textSize
    label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", fontWeight)
    
    -- Alinhamento
    if LabelObj.Alignment == "Center" then
        label.TextXAlignment = Enum.TextXAlignment.Center
    elseif LabelObj.Alignment == "Right" then
        label.TextXAlignment = Enum.TextXAlignment.Right
    else
        label.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    -- Separador (opcional)
    if config.Separator then
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.BackgroundColor3 = Theme.Border
        separator.BorderSizePixel = 0
        separator.Position = UDim2.new(0, 0, 0, 0)
        separator.Size = UDim2.new(1, 0, 0, 1)
        separator.ZIndex = 20
        separator.Parent = frame
        
        padding.PaddingTop = UDim.new(0, 10)
    end
    
    -- Referências
    LabelObj.Frame = frame
    LabelObj.Label = label
    
    -- Métodos
    function LabelObj:SetText(text)
        self.Text = text
        label.Text = text
    end
    
    function LabelObj:SetStyle(style)
        self.Style = style
        
        local newColor, newSize, newWeight
        
        if style == "title" then
            newColor = Theme.Text
            newSize = 18
            newWeight = Enum.FontWeight.Bold
        elseif style == "subtitle" then
            newColor = Theme.TextSecondary
            newSize = 14
            newWeight = Enum.FontWeight.Medium
        elseif style == "muted" then
            newColor = Theme.TextMuted
            newSize = 12
            newWeight = Enum.FontWeight.Regular
        elseif style == "accent" then
            newColor = Theme.Accent
            newSize = 13
            newWeight = Enum.FontWeight.SemiBold
        elseif style == "success" then
            newColor = Theme.Success
            newSize = 13
            newWeight = Enum.FontWeight.SemiBold
        elseif style == "warning" then
            newColor = Theme.Warning
            newSize = 13
            newWeight = Enum.FontWeight.SemiBold
        elseif style == "error" then
            newColor = Theme.Error
            newSize = 13
            newWeight = Enum.FontWeight.SemiBold
        else
            newColor = Theme.Text
            newSize = 13
            newWeight = Enum.FontWeight.Regular
        end
        
        TweenService:Create(label, TweenInfo.new(0.2), {
            TextColor3 = newColor,
            TextSize = newSize
        }):Play()
        
        label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", newWeight)
    end
    
    function LabelObj:SetAlignment(alignment)
        self.Alignment = alignment
        
        if alignment == "Center" then
            label.TextXAlignment = Enum.TextXAlignment.Center
        elseif alignment == "Right" then
            label.TextXAlignment = Enum.TextXAlignment.Right
        else
            label.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
    
    function LabelObj:SetVisible(visible)
        frame.Visible = visible
    end
    
    function LabelObj:Destroy()
        frame:Destroy()
    end
    
    return LabelObj
end

return Label
