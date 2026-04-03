--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                    SpectrumX Floating Button Element                     ║
    ║                                                                          ║
    ║  Botão circular flutuante no canto inferior direito da tela             ║
    ║  - Animação de hover (scale up + glow)                                  ║
    ║  - Ao clicar: toggle da janela principal (abre/fecha)                   ║
    ║  - Ícone configurável (default: "menu" ou "settings")                   ║
    ║  - Sempre visível mesmo quando a window tá fechada                      ║
    ║  - Draggable opcional                                                   ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local FloatingButton = {}

-- ─── CRIAR BOTÃO FLUTUANTE ────────────────────────────────────────────────────
function FloatingButton:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local FloatingBtn = {}
    
    -- Configurações
    local icon = config.Icon or "menu"
    local position = config.Position or "BottomRight"
    local draggable = config.Draggable ~= false
    local window = config.Window
    
    -- Tamanho do botão
    local btnSize = 56
    
    -- Frame principal
    local frame = Instance.new("ImageButton")
    frame.Name = "FloatingButton"
    frame.BackgroundColor3 = Theme.Accent
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, btnSize, 0, btnSize)
    frame.Image = ""
    frame.AutoButtonColor = false
    frame.ZIndex = 9999
    frame.Parent = parent
    
    -- Posição inicial baseada na configuração
    local padding = 30
    local viewport = workspace.CurrentCamera.ViewportSize
    
    if position == "BottomRight" then
        frame.Position = UDim2.new(1, -btnSize - padding, 1, -btnSize - padding)
    elseif position == "BottomLeft" then
        frame.Position = UDim2.new(0, padding, 1, -btnSize - padding)
    elseif position == "TopRight" then
        frame.Position = UDim2.new(1, -btnSize - padding, 0, padding)
    elseif position == "TopLeft" then
        frame.Position = UDim2.new(0, padding, 0, padding)
    elseif typeof(position) == "UDim2" then
        frame.Position = position
    else
        frame.Position = UDim2.new(1, -btnSize - padding, 1, -btnSize - padding)
    end
    
    -- Cantos arredondados (circular)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = frame
    
    -- Sombra
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.6
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.ZIndex = 9998
    shadow.Parent = frame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(1, 0)
    shadowCorner.Parent = shadow
    
    -- Glow effect (inicialmente invisível)
    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.BackgroundColor3 = Theme.Accent
    glow.BackgroundTransparency = 0.8
    glow.BorderSizePixel = 0
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.ZIndex = 9997
    glow.Parent = frame
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glow
    
    -- Ícone
    local iconLabel
    if Utils:IsAssetId(icon) then
        -- É um Asset ID
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.BackgroundTransparency = 1
        iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.Size = UDim2.new(0.6, 0, 0.6, 0)
        iconImg.Image = Utils:FormatAssetId(icon)
        iconImg.ImageColor3 = Color3.new(1, 1, 1)
        iconImg.ZIndex = 10000
        iconImg.Parent = frame
        iconLabel = iconImg
    else
        -- É texto/emoji
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Icon"
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Font = Enum.Font.GothamBlack
        textLabel.Text = icon
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextSize = 24
        textLabel.ZIndex = 10000
        textLabel.Parent = frame
        iconLabel = textLabel
    end
    
    -- Estado
    local isHovering = false
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    -- Hover effects
    frame.MouseEnter:Connect(function()
        isHovering = true
        if not isDragging then
            -- Scale up
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, btnSize * 1.1, 0, btnSize * 1.1)
            }):Play()
            
            -- Glow expand
            TweenService:Create(glow, TweenInfo.new(0.2), {
                Size = UDim2.new(1.3, 0, 1.3, 0),
                BackgroundTransparency = 0.6
            }):Play()
            
            -- Shadow expand
            TweenService:Create(shadow, TweenInfo.new(0.2), {
                Size = UDim2.new(1.2, 8, 1.2, 8),
                BackgroundTransparency = 0.4
            }):Play()
            
            -- Cor mais clara
            TweenService:Create(frame, TweenInfo.new(0.15), {
                BackgroundColor3 = Theme.AccentHover
            }):Play()
        end
    end)
    
    frame.MouseLeave:Connect(function()
        isHovering = false
        if not isDragging then
            -- Scale down
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, btnSize, 0, btnSize)
            }):Play()
            
            -- Glow retract
            TweenService:Create(glow, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 0.8
            }):Play()
            
            -- Shadow retract
            TweenService:Create(shadow, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 8, 1, 8),
                BackgroundTransparency = 0.6
            }):Play()
            
            -- Cor normal
            TweenService:Create(frame, TweenInfo.new(0.15), {
                BackgroundColor3 = Theme.Accent
            }):Play()
        end
    end)
    
    -- Clique para toggle da janela
    frame.MouseButton1Click:Connect(function()
        if not isDragging and window then
            -- Animação de clique
            TweenService:Create(frame, TweenInfo.new(0.1), {
                Size = UDim2.new(0, btnSize * 0.95, 0, btnSize * 0.95)
            }):Play()
            
            task.delay(0.1, function()
                TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = isHovering and UDim2.new(0, btnSize * 1.1, 0, btnSize * 1.1) or UDim2.new(0, btnSize, 0, btnSize)
                }):Play()
            end)
            
            -- Toggle janela
            if window.Minimized then
                window:Restore()
            else
                window:Minimize()
            end
        end
    end)
    
    -- Drag functionality
    if draggable then
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                    end
                end)
            end
        end)
        
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or
               input.UserInputType == Enum.UserInputType.Touch then
                if dragStart and (input.Position - dragStart).Magnitude > 5 then
                    isDragging = true
                end
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if isDragging and dragStart and 
               (input.UserInputType == Enum.UserInputType.MouseMovement or
                input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragStart = nil
                startPos = nil
                isDragging = false
            end
        end)
    end
    
    -- Animação de entrada
    frame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, btnSize, 0, btnSize)
    }):Play()
    
    -- Referências
    FloatingBtn.Frame = frame
    FloatingBtn.Icon = iconLabel
    FloatingBtn.Glow = glow
    FloatingBtn.Shadow = shadow
    
    -- Métodos
    function FloatingBtn:SetIcon(newIcon)
        if Utils:IsAssetId(newIcon) then
            if iconLabel:IsA("ImageLabel") then
                iconLabel.Image = Utils:FormatAssetId(newIcon)
            else
                iconLabel:Destroy()
                local iconImg = Instance.new("ImageLabel")
                iconImg.Name = "Icon"
                iconImg.BackgroundTransparency = 1
                iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
                iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
                iconImg.Size = UDim2.new(0.6, 0, 0.6, 0)
                iconImg.Image = Utils:FormatAssetId(newIcon)
                iconImg.ImageColor3 = Color3.new(1, 1, 1)
                iconImg.ZIndex = 10000
                iconImg.Parent = frame
                iconLabel = iconImg
            end
        else
            if iconLabel:IsA("TextLabel") then
                iconLabel.Text = newIcon
            else
                iconLabel:Destroy()
                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "Icon"
                textLabel.BackgroundTransparency = 1
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.Font = Enum.Font.GothamBlack
                textLabel.Text = newIcon
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.TextSize = 24
                textLabel.ZIndex = 10000
                textLabel.Parent = frame
                iconLabel = textLabel
            end
        end
    end
    
    function FloatingBtn:SetPosition(newPosition)
        if typeof(newPosition) == "UDim2" then
            TweenService:Create(frame, TweenInfo.new(0.3), {
                Position = newPosition
            }):Play()
        end
    end
    
    function FloatingBtn:SetVisible(visible)
        if visible then
            frame.Visible = true
            TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, btnSize, 0, btnSize)
            }):Play()
        else
            TweenService:Create(frame, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            task.delay(0.2, function()
                frame.Visible = false
            end)
        end
    end
    
    function FloatingBtn:SetDraggable(draggable)
        draggable = draggable
    end
    
    function FloatingBtn:Destroy()
        -- Animação de saída
        TweenService:Create(frame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        task.delay(0.2, function()
            frame:Destroy()
        end)
    end
    
    return FloatingBtn
end

return FloatingButton
