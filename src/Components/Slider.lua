--[[
    SpectrumX Slider Component
    Slider com value label animado
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Slider = {}

-- ─── CRIAR SLIDER ─────────────────────────────────────────────────────────────
function Slider:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local SliderObj = {}
    
    -- Propriedades
    SliderObj.Title = config.Title or "Slider"
    SliderObj.Min = config.Min or 0
    SliderObj.Max = config.Max or 100
    SliderObj.Default = config.Default or SliderObj.Min
    SliderObj.Callback = config.Callback or function() end
    SliderObj.Value = SliderObj.Default
    SliderObj.Decimals = config.Decimals or 0
    SliderObj.Suffix = config.Suffix or ""
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = SliderObj.Title .. "Slider"
    frame.BackgroundColor3 = Theme.Card
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 62)
    frame.ZIndex = 20
    frame.Parent = parent
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Borda
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 10)
    label.Size = UDim2.new(0.6, 0, 0, 18)
    label.Font = Enum.Font.GothamSemibold
    label.Text = SliderObj.Title
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 21
    label.Parent = frame
    
    -- Value display
    local valueBg = Instance.new("Frame")
    valueBg.Name = "ValueBg"
    valueBg.BackgroundColor3 = Theme.Accent
    valueBg.Position = UDim2.new(1, -50, 0, 8)
    valueBg.Size = UDim2.new(0, 42, 0, 22)
    valueBg.ZIndex = 22
    valueBg.Parent = frame
    
    local valueBgCorner = Instance.new("UICorner")
    valueBgCorner.CornerRadius = UDim.new(0, 5)
    valueBgCorner.Parent = valueBg
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(SliderObj.Default) .. SliderObj.Suffix
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.TextSize = 11
    valueLabel.ZIndex = 23
    valueLabel.Parent = valueBg
    
    -- Track background
    local trackHeight = 6
    local trackBg = Instance.new("Frame")
    trackBg.Name = "TrackBg"
    trackBg.BackgroundColor3 = Theme.InputBackground
    trackBg.BorderSizePixel = 0
    trackBg.Position = UDim2.new(0, 14, 1, -trackHeight - 14)
    trackBg.Size = UDim2.new(1, -28, 0, trackHeight)
    trackBg.ZIndex = 21
    trackBg.Parent = frame
    
    local trackBgCorner = Instance.new("UICorner")
    trackBgCorner.CornerRadius = UDim.new(1, 0)
    trackBgCorner.Parent = trackBg
    
    -- Fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    local percent = (SliderObj.Default - SliderObj.Min) / (SliderObj.Max - SliderObj.Min)
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.ZIndex = 22
    fill.Parent = trackBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    -- Gradiente no fill
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.AccentDark)
    })
    fillGradient.Rotation = 0
    fillGradient.Parent = fill
    
    -- Knob
    local knobSize = 16
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(percent, -knobSize / 2, 0.5, -knobSize / 2)
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.ZIndex = 23
    knob.Parent = trackBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    -- Borda do knob
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = Theme.Accent
    knobStroke.Thickness = 2
    knobStroke.Parent = knob
    
    -- Sombra do knob
    local knobShadow = Instance.new("Frame")
    knobShadow.Name = "Shadow"
    knobShadow.BackgroundColor3 = Color3.new(0, 0, 0)
    knobShadow.BackgroundTransparency = 0.6
    knobShadow.BorderSizePixel = 0
    knobShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    knobShadow.Size = UDim2.new(1, 4, 1, 4)
    knobShadow.ZIndex = 22
    knobShadow.Parent = knob
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(1, 0)
    shadowCorner.Parent = knobShadow
    
    -- Dragging state
    local dragging = false
    
    -- Função de atualização
    local function update(input)
        local trackPos = trackBg.AbsolutePosition
        local trackSize = trackBg.AbsoluteSize
        
        local mouseX = input.Position.X
        local relativeX = math.clamp(mouseX - trackPos.X, 0, trackSize.X)
        local newPercent = relativeX / trackSize.X
        
        local newValue = SliderObj.Min + (SliderObj.Max - SliderObj.Min) * newPercent
        
        -- Arredondar conforme decimais
        if SliderObj.Decimals > 0 then
            local mult = 10 ^ SliderObj.Decimals
            newValue = math.floor(newValue * mult + 0.5) / mult
        else
            newValue = math.floor(newValue + 0.5)
        end
        
        -- Clamp
        newValue = math.clamp(newValue, SliderObj.Min, SliderObj.Max)
        SliderObj.Value = newValue
        
        -- Atualizar visual
        local newPercentClamped = (newValue - SliderObj.Min) / (SliderObj.Max - SliderObj.Min)
        fill.Size = UDim2.new(newPercentClamped, 0, 1, 0)
        knob.Position = UDim2.new(newPercentClamped, -knobSize / 2, 0.5, -knobSize / 2)
        valueLabel.Text = tostring(newValue) .. SliderObj.Suffix
        
        -- Callback
        SliderObj.Callback(newValue)
    end
    
    -- Input events
    trackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
            
            -- Scale up knob
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Size = UDim2.new(0, knobSize * 1.2, 0, knobSize * 1.2)
            }):Play()
        end
    end)
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            
            -- Scale up knob
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Size = UDim2.new(0, knobSize * 1.2, 0, knobSize * 1.2)
            }):Play()
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
            
            -- Scale down knob
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Size = UDim2.new(0, knobSize, 0, knobSize)
            }):Play()
        end
    end)
    
    -- Hover no knob
    knob.MouseEnter:Connect(function()
        if not dragging then
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Size = UDim2.new(0, knobSize * 1.1, 0, knobSize * 1.1)
            }):Play()
        end
    end)
    
    knob.MouseLeave:Connect(function()
        if not dragging then
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Size = UDim2.new(0, knobSize, 0, knobSize)
            }):Play()
        end
    end)
    
    -- Referências
    SliderObj.Frame = frame
    SliderObj.Track = trackBg
    SliderObj.Fill = fill
    SliderObj.Knob = knob
    SliderObj.ValueLabel = valueLabel
    
    -- Métodos
    function SliderObj:GetValue()
        return self.Value
    end
    
    function SliderObj:SetValue(value)
        value = math.clamp(value, self.Min, self.Max)
        self.Value = value
        
        local percent = (value - self.Min) / (self.Max - self.Min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, -knobSize / 2, 0.5, -knobSize / 2)
        valueLabel.Text = tostring(value) .. self.Suffix
        
        self.Callback(value)
    end
    
    function SliderObj:SetTitle(title)
        self.Title = title
        label.Text = title
    end
    
    function SliderObj:SetCallback(callback)
        self.Callback = callback
    end
    
    function SliderObj:SetVisible(visible)
        frame.Visible = visible
    end
    
    function SliderObj:SetEnabled(enabled)
        trackBg.Active = enabled
        knob.Active = enabled
    end
    
    function SliderObj:Destroy()
        frame:Destroy()
    end
    
    return SliderObj
end

return Slider
