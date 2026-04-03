--[[
    SpectrumX Button Component
    Botão com hover effects e ripple
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Button = {}

-- ─── CRIAR BOTÃO ──────────────────────────────────────────────────────────────
function Button:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local ButtonObj = {}
    
    -- Propriedades
    ButtonObj.Title = config.Title or "Button"
    ButtonObj.Callback = config.Callback or function() end
    ButtonObj.Style = config.Style or "default" -- default, accent, outline, danger
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = ButtonObj.Title .. "Button"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.ZIndex = 20
    frame.Parent = parent
    
    -- Botão
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Font = Enum.Font.GothamBold
    btn.Text = ButtonObj.Title
    btn.TextSize = 13
    btn.ZIndex = 21
    btn.Parent = frame
    
    -- Estilos
    local bgColor, textColor, borderColor
    
    if ButtonObj.Style == "accent" then
        bgColor = Theme.Accent
        textColor = Color3.new(1, 1, 1)
        borderColor = Theme.Accent
    elseif ButtonObj.Style == "outline" then
        bgColor = Theme.Card
        textColor = Theme.Text
        borderColor = Theme.Border
    elseif ButtonObj.Style == "danger" then
        bgColor = Color3.fromRGB(40, 10, 10)
        textColor = Theme.Error
        borderColor = Theme.Error
    elseif ButtonObj.Style == "success" then
        bgColor = Color3.fromRGB(10, 40, 10)
        textColor = Theme.Success
        borderColor = Theme.Success
    else -- default
        bgColor = Theme.Card
        textColor = Theme.Text
        borderColor = Theme.Border
    end
    
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = textColor
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    -- Borda
    local stroke = Instance.new("UIStroke")
    stroke.Color = borderColor
    stroke.Thickness = ButtonObj.Style == "accent" and 0 or 1
    stroke.Transparency = ButtonObj.Style == "accent" and 1 or 0.4
    stroke.Parent = btn
    
    -- Gradiente para estilo accent
    if ButtonObj.Style == "accent" then
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Accent),
            ColorSequenceKeypoint.new(1, Theme.AccentDark)
        })
        gradient.Rotation = 90
        gradient.Parent = btn
    end
    
    -- Container para ripple
    local rippleHolder = Instance.new("Frame")
    rippleHolder.Name = "RippleHolder"
    rippleHolder.BackgroundTransparency = 1
    rippleHolder.ClipsDescendants = true
    rippleHolder.Size = UDim2.new(1, 0, 1, 0)
    rippleHolder.ZIndex = 22
    rippleHolder.Parent = btn
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(0, 8)
    rippleCorner.Parent = rippleHolder
    
    -- Hover effects
    btn.MouseEnter:Connect(function()
        if ButtonObj.Style == "accent" then
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Theme.AccentHover
            }):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Theme.CardHover
            }):Play()
            if stroke then
                TweenService:Create(stroke, TweenInfo.new(0.15), {
                    Transparency = 0.1
                }):Play()
            end
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if ButtonObj.Style == "accent" then
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = bgColor
            }):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = bgColor
            }):Play()
            if stroke then
                TweenService:Create(stroke, TweenInfo.new(0.15), {
                    Transparency = 0.4
                }):Play()
            end
        end
    end)
    
    -- Ripple effect
    local function createRipple(position)
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = Color3.new(1, 1, 1)
        ripple.BackgroundTransparency = 0.8
        ripple.BorderSizePixel = 0
        ripple.ZIndex = 23
        
        local maxSize = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.5
        
        -- Posição do clique
        local startX = position.X - btn.AbsolutePosition.X
        local startY = position.Y - btn.AbsolutePosition.Y
        
        ripple.Position = UDim2.new(0, startX, 0, startY)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Parent = rippleHolder
        
        local rippleCircle = Instance.new("UICorner")
        rippleCircle.CornerRadius = UDim.new(1, 0)
        rippleCircle.Parent = ripple
        
        -- Animar ripple
        TweenService:Create(ripple, TweenInfo.new(0.4), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.4, function()
            if ripple and ripple.Parent then
                ripple:Destroy()
            end
        end)
    end
    
    -- Clique
    btn.MouseButton1Click:Connect(function()
        createRipple(UserInputService:GetMouseLocation())
        ButtonObj.Callback()
    end)
    
    -- Referências
    ButtonObj.Frame = frame
    ButtonObj.Button = btn
    
    -- Métodos
    function ButtonObj:SetTitle(title)
        self.Title = title
        btn.Text = title
    end
    
    function ButtonObj:SetCallback(callback)
        self.Callback = callback
    end
    
    function ButtonObj:SetVisible(visible)
        frame.Visible = visible
    end
    
    function ButtonObj:SetEnabled(enabled)
        btn.Active = enabled
        btn.AutoButtonColor = false
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundTransparency = enabled and 0 or 0.5
        }):Play()
    end
    
    function ButtonObj:Destroy()
        frame:Destroy()
    end
    
    return ButtonObj
end

return Button
