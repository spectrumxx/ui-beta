--[[
    SpectrumX Toggle Component
    Switch animado on/off
--]]

local TweenService = game:GetService("TweenService")

local Toggle = {}

-- ─── CRIAR TOGGLE ─────────────────────────────────────────────────────────────
function Toggle:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local ToggleObj = {}
    
    -- Propriedades
    ToggleObj.Title = config.Title or "Toggle"
    ToggleObj.Default = config.Default or false
    ToggleObj.Callback = config.Callback or function() end
    ToggleObj.Value = ToggleObj.Default
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = ToggleObj.Title .. "Toggle"
    frame.BackgroundColor3 = Theme.Card
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 46)
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
    
    -- Efeito hover
    local hoverFill = Instance.new("Frame")
    hoverFill.Name = "HoverFill"
    hoverFill.BackgroundColor3 = Color3.new(1, 1, 1)
    hoverFill.BackgroundTransparency = 1
    hoverFill.BorderSizePixel = 0
    hoverFill.Size = UDim2.new(1, 0, 1, 0)
    hoverFill.ZIndex = 19
    hoverFill.Parent = frame
    
    local hoverCorner = Instance.new("UICorner")
    hoverCorner.CornerRadius = UDim.new(0, 8)
    hoverCorner.Parent = hoverFill
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = ToggleObj.Title
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.ZIndex = 21
    label.Parent = frame
    
    -- Track do toggle
    local trackWidth = 46
    local trackHeight = 24
    
    local track = Instance.new("TextButton")
    track.Name = "Track"
    track.AutoButtonColor = false
    track.BackgroundColor3 = ToggleObj.Default and Theme.ToggleOn or Theme.ToggleOff
    track.Position = UDim2.new(1, -trackWidth - 14, 0.5, -trackHeight / 2)
    track.Size = UDim2.new(0, trackWidth, 0, trackHeight)
    track.Text = ""
    track.ZIndex = 22
    track.Parent = frame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    -- Borda do track
    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = ToggleObj.Default and Theme.Accent or Theme.Border
    trackStroke.Thickness = 1
    trackStroke.Transparency = ToggleObj.Default and 0.2 or 0.5
    trackStroke.Parent = track
    
    -- Knob
    local knobSize = 18
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Theme.ToggleKnob
    knob.Position = ToggleObj.Default and 
        UDim2.new(1, -knobSize - 3, 0.5, -knobSize / 2) or
        UDim2.new(0, 3, 0.5, -knobSize / 2)
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.ZIndex = 23
    knob.Parent = track
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    -- Sombra do knob
    local knobShadow = Instance.new("Frame")
    knobShadow.Name = "Shadow"
    knobShadow.BackgroundColor3 = Color3.new(0, 0, 0)
    knobShadow.BackgroundTransparency = 0.7
    knobShadow.BorderSizePixel = 0
    knobShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    knobShadow.Size = UDim2.new(1, 4, 1, 4)
    knobShadow.ZIndex = 22
    knobShadow.Parent = knob
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(1, 0)
    shadowCorner.Parent = knobShadow
    
    -- Função de atualização
    local function update(value, animate)
        animate = animate ~= false
        local time = animate and 0.2 or 0
        
        ToggleObj.Value = value
        
        if value then
            -- ON state
            TweenService:Create(track, TweenInfo.new(time), {
                BackgroundColor3 = Theme.ToggleOn
            }):Play()
            
            if trackStroke then
                TweenService:Create(trackStroke, TweenInfo.new(time), {
                    Color = Theme.Accent,
                    Transparency = 0.2
                }):Play()
            end
            
            TweenService:Create(knob, TweenInfo.new(time, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -knobSize - 3, 0.5, -knobSize / 2)
            }):Play()
        else
            -- OFF state
            TweenService:Create(track, TweenInfo.new(time), {
                BackgroundColor3 = Theme.ToggleOff
            }):Play()
            
            if trackStroke then
                TweenService:Create(trackStroke, TweenInfo.new(time), {
                    Color = Theme.Border,
                    Transparency = 0.5
                }):Play()
            end
            
            TweenService:Create(knob, TweenInfo.new(time, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 3, 0.5, -knobSize / 2)
            }):Play()
        end
        
        -- Callback
        ToggleObj.Callback(value)
    end
    
    -- Hover effects
    frame.MouseEnter:Connect(function()
        TweenService:Create(hoverFill, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.97
        }):Play()
    end)
    
    frame.MouseLeave:Connect(function()
        TweenService:Create(hoverFill, TweenInfo.new(0.15), {
            BackgroundTransparency = 1
        }):Play()
    end)
    
    -- Clique
    track.MouseButton1Click:Connect(function()
        update(not ToggleObj.Value)
    end)
    
    -- Clique no frame também funciona
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            -- Verificar se não clicou no track
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local trackSize = track.AbsoluteSize
            
            if mousePos.X < trackPos.X or mousePos.X > trackPos.X + trackSize.X or
               mousePos.Y < trackPos.Y or mousePos.Y > trackPos.Y + trackSize.Y then
                update(not ToggleObj.Value)
            end
        end
    end)
    
    -- Referências
    ToggleObj.Frame = frame
    ToggleObj.Track = track
    ToggleObj.Knob = knob
    ToggleObj.Label = label
    
    -- Métodos
    function ToggleObj:GetValue()
        return self.Value
    end
    
    function ToggleObj:SetValue(value)
        update(value)
    end
    
    function ToggleObj:SetTitle(title)
        self.Title = title
        label.Text = title
    end
    
    function ToggleObj:SetCallback(callback)
        self.Callback = callback
    end
    
    function ToggleObj:SetVisible(visible)
        frame.Visible = visible
    end
    
    function ToggleObj:SetEnabled(enabled)
        track.Active = enabled
    end
    
    function ToggleObj:Destroy()
        frame:Destroy()
    end
    
    return ToggleObj
end

return Toggle
