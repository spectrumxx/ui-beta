--[[
    SpectrumX Input Component
    Input de texto e número
--]]

local TweenService = game:GetService("TweenService")

local Input = {}

-- ─── CRIAR INPUT ──────────────────────────────────────────────────────────────
function Input:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local InputObj = {}
    
    -- Propriedades
    InputObj.Title = config.Title or "Input"
    InputObj.Default = config.Default or ""
    InputObj.Placeholder = config.Placeholder or "Digite aqui..."
    InputObj.Callback = config.Callback or function() end
    InputObj.Numeric = config.Numeric or false
    InputObj.Min = config.Min or -math.huge
    InputObj.Max = config.Max or math.huge
    InputObj.Finished = config.Finished or false -- Callback apenas ao terminar
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = InputObj.Title .. "Input"
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
    label.Size = UDim2.new(1, -28, 0, 16)
    label.Font = Enum.Font.GothamSemibold
    label.Text = InputObj.Title
    label.TextColor3 = Theme.TextMuted
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 21
    label.Parent = frame
    
    -- TextBox
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.BackgroundColor3 = Theme.InputBackground
    textBox.BorderSizePixel = 0
    textBox.Position = UDim2.new(0, 12, 0, 28)
    textBox.Size = UDim2.new(1, -24, 0, 26)
    textBox.Font = Enum.Font.Gotham
    textBox.Text = tostring(InputObj.Default)
    textBox.PlaceholderText = InputObj.Placeholder
    textBox.PlaceholderColor3 = Theme.TextMuted
    textBox.TextColor3 = Theme.Text
    textBox.TextSize = 13
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 22
    textBox.Parent = frame
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox
    
    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Color = Theme.Border
    textBoxStroke.Thickness = 1
    textBoxStroke.Transparency = 0.4
    textBoxStroke.Parent = textBox
    
    -- Ícone de clear (X)
    local clearBtn = Instance.new("TextButton")
    clearBtn.Name = "ClearBtn"
    clearBtn.BackgroundTransparency = 1
    clearBtn.Position = UDim2.new(1, -24, 0, 0)
    clearBtn.Size = UDim2.new(0, 20, 1, 0)
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Text = "×"
    clearBtn.TextColor3 = Theme.TextMuted
    clearBtn.TextSize = 16
    clearBtn.ZIndex = 23
    clearBtn.Parent = textBox
    clearBtn.Visible = textBox.Text ~= ""
    
    -- Focus effects
    textBox.Focused:Connect(function()
        TweenService:Create(textBoxStroke, TweenInfo.new(0.2), {
            Color = Theme.Accent,
            Transparency = 0.1
        }):Play()
        
        TweenService:Create(label, TweenInfo.new(0.2), {
            TextColor3 = Theme.Accent
        }):Play()
    end)
    
    textBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(textBoxStroke, TweenInfo.new(0.2), {
            Color = Theme.Border,
            Transparency = 0.4
        }):Play()
        
        TweenService:Create(label, TweenInfo.new(0.2), {
            TextColor3 = Theme.TextMuted
        }):Play()
        
        -- Validar número
        if InputObj.Numeric then
            local value = tonumber(textBox.Text)
            if value then
                value = math.clamp(value, InputObj.Min, InputObj.Max)
                textBox.Text = tostring(value)
                InputObj.Callback(value)
            else
                textBox.Text = tostring(InputObj.Default)
            end
        else
            if InputObj.Finished or enterPressed then
                InputObj.Callback(textBox.Text)
            end
        end
        
        clearBtn.Visible = textBox.Text ~= ""
    end)
    
    -- Text changed
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        clearBtn.Visible = textBox.Text ~= ""
        
        if not InputObj.Finished and not InputObj.Numeric then
            InputObj.Callback(textBox.Text)
        end
    end)
    
    -- Clear button
    clearBtn.MouseEnter:Connect(function()
        TweenService:Create(clearBtn, TweenInfo.new(0.15), {
            TextColor3 = Theme.Error
        }):Play()
    end)
    
    clearBtn.MouseLeave:Connect(function()
        TweenService:Create(clearBtn, TweenInfo.new(0.15), {
            TextColor3 = Theme.TextMuted
        }):Play()
    end)
    
    clearBtn.MouseButton1Click:Connect(function()
        textBox.Text = ""
        clearBtn.Visible = false
        InputObj.Callback("")
    end)
    
    -- Referências
    InputObj.Frame = frame
    InputObj.TextBox = textBox
    InputObj.Label = label
    
    -- Métodos
    function InputObj:GetValue()
        if self.Numeric then
            return tonumber(self.TextBox.Text) or self.Default
        end
        return self.TextBox.Text
    end
    
    function InputObj:SetValue(value)
        if self.Numeric then
            value = math.clamp(value, self.Min, self.Max)
        end
        self.TextBox.Text = tostring(value)
        self.Callback(value)
    end
    
    function InputObj:SetTitle(title)
        self.Title = title
        label.Text = title
    end
    
    function InputObj:SetPlaceholder(placeholder)
        self.Placeholder = placeholder
        textBox.PlaceholderText = placeholder
    end
    
    function InputObj:SetCallback(callback)
        self.Callback = callback
    end
    
    function InputObj:SetVisible(visible)
        frame.Visible = visible
    end
    
    function InputObj:SetEnabled(enabled)
        textBox.Active = enabled
        textBox.TextEditable = enabled
    end
    
    function InputObj:Focus()
        textBox:CaptureFocus()
    end
    
    function InputObj:Destroy()
        frame:Destroy()
    end
    
    return InputObj
end

return Input
