--[[
    SpectrumX Tab Component
    Sistema de abas/navegação
--]]

local TweenService = game:GetService("TweenService")

local Tab = {}

-- ─── CRIAR TAB ────────────────────────────────────────────────────────────────
function Tab:New(config, window)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local TabObj = {}
    
    -- Propriedades
    TabObj.Title = config.Title or "Tab"
    TabObj.Icon = config.Icon
    TabObj.Window = window
    TabObj.Active = false
    TabObj.Sections = {}
    TabObj.Elements = {}
    
    -- Botão da tab
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = TabObj.Title .. "Tab"
    tabBtn.BackgroundColor3 = Theme.Card
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(0, Utils.Responsive:IsMobile() and 60 or 140, 0, 36)
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 15
    tabBtn.Parent = window.TabScroller
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tabBtn
    
    -- Ícone
    local hasIcon = false
    if TabObj.Icon then
        hasIcon = true
        
        if Utils:IsAssetId(TabObj.Icon) then
            -- Asset ID
            local iconImg = Instance.new("ImageLabel")
            iconImg.Name = "Icon"
            iconImg.BackgroundTransparency = 1
            iconImg.Position = Utils.Responsive:IsMobile() and 
                UDim2.new(0.5, -10, 0.5, -10) or 
                UDim2.new(0, 10, 0.5, -10)
            iconImg.Size = UDim2.new(0, 20, 0, 20)
            iconImg.Image = Utils:FormatAssetId(TabObj.Icon)
            iconImg.ImageColor3 = Theme.TextMuted
            iconImg.ZIndex = 16
            iconImg.Parent = tabBtn
        else
            -- Texto/emoji
            local iconLabel = Instance.new("TextLabel")
            iconLabel.Name = "Icon"
            iconLabel.BackgroundTransparency = 1
            iconLabel.Position = Utils.Responsive:IsMobile() and 
                UDim2.new(0.5, -10, 0.5, -10) or 
                UDim2.new(0, 10, 0.5, -10)
            iconLabel.Size = UDim2.new(0, 20, 0, 20)
            iconLabel.Font = Enum.Font.GothamBold
            iconLabel.Text = TabObj.Icon
            iconLabel.TextColor3 = Theme.TextMuted
            iconLabel.TextSize = 16
            iconLabel.ZIndex = 16
            iconLabel.Parent = tabBtn
        end
    end
    
    -- Label (apenas em desktop)
    local label
    if not Utils.Responsive:IsMobile() then
        label = Instance.new("TextLabel")
        label.Name = "Label"
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, hasIcon and 36 or 12, 0, 0)
        label.Size = UDim2.new(1, -(hasIcon and 48 or 24), 1, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = TabObj.Title
        label.TextColor3 = Theme.TextMuted
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 16
        label.Parent = tabBtn
    end
    
    -- Indicador ativo (barra lateral)
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = Theme.Accent
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.5, -12)
    indicator.Size = UDim2.new(0, 3, 0, 24)
    indicator.ZIndex = 17
    indicator.Parent = tabBtn
    indicator.Visible = false
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = indicator
    
    -- Container da página
    local page = Instance.new("Frame")
    page.Name = TabObj.Title .. "Page"
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.ZIndex = 14
    page.Parent = window.PageArea
    
    -- ScrollingFrame para conteúdo
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = "Scroller"
    scroller.BackgroundTransparency = 1
    scroller.BorderSizePixel = 0
    scroller.Size = UDim2.new(1, 0, 1, 0)
    scroller.ScrollBarThickness = 4
    scroller.ScrollBarImageColor3 = Theme.Accent
    scroller.ScrollBarImageTransparency = 0.5
    scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroller.ZIndex = 14
    scroller.Parent = page
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = scroller
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = scroller
    
    -- Atualizar canvas size
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroller.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Referências
    TabObj.Button = tabBtn
    TabObj.Page = page
    TabObj.Scroller = scroller
    TabObj.Layout = layout
    TabObj.Indicator = indicator
    TabObj.Label = label
    
    -- Hover effects
    tabBtn.MouseEnter:Connect(function()
        if not TabObj.Active then
            TweenService:Create(tabBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = Theme.CardHover
            }):Play()
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if not TabObj.Active then
            TweenService:Create(tabBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = Theme.Card
            }):Play()
        end
    end)
    
    -- Clique
    tabBtn.MouseButton1Click:Connect(function()
        window:SelectTab(TabObj)
    end)
    
    -- Métodos
    function TabObj:SetActive(active)
        self.Active = active
        
        if active then
            -- Ativar visual
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Accent
            }):Play()
            
            if self.Label then
                TweenService:Create(self.Label, TweenInfo.new(0.2), {
                    TextColor3 = Color3.new(1, 1, 1)
                }):Play()
            end
            
            -- Atualizar ícone
            local icon = tabBtn:FindFirstChild("Icon")
            if icon then
                if icon:IsA("ImageLabel") then
                    TweenService:Create(icon, TweenInfo.new(0.2), {
                        ImageColor3 = Color3.new(1, 1, 1)
                    }):Play()
                else
                    TweenService:Create(icon, TweenInfo.new(0.2), {
                        TextColor3 = Color3.new(1, 1, 1)
                    }):Play()
                end
            end
            
            -- Mostrar indicador
            indicator.Visible = true
            
            -- Mostrar página
            page.Visible = true
            TweenService:Create(page, TweenInfo.new(0.2), {
                BackgroundTransparency = 1
            }):Play()
        else
            -- Desativar visual
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Card
            }):Play()
            
            if self.Label then
                TweenService:Create(self.Label, TweenInfo.new(0.2), {
                    TextColor3 = Theme.TextMuted
                }):Play()
            end
            
            -- Atualizar ícone
            local icon = tabBtn:FindFirstChild("Icon")
            if icon then
                if icon:IsA("ImageLabel") then
                    TweenService:Create(icon, TweenInfo.new(0.2), {
                        ImageColor3 = Theme.TextMuted
                    }):Play()
                else
                    TweenService:Create(icon, TweenInfo.new(0.2), {
                        TextColor3 = Theme.TextMuted
                    }):Play()
                end
            end
            
            -- Esconder indicador
            indicator.Visible = false
            
            -- Esconder página
            page.Visible = false
        end
    end
    
    function TabObj:AddSection(title)
        local Section = require(script.Parent.Section)
        local section = Section:New({ Title = title }, self)
        table.insert(self.Sections, section)
        return section
    end
    
    function TabObj:AddButton(config)
        local Button = require(script.Parent.Button)
        local btn = Button:New(config, self.Scroller)
        table.insert(self.Elements, btn)
        return btn
    end
    
    function TabObj:AddToggle(config)
        local Toggle = require(script.Parent.Toggle)
        local toggle = Toggle:New(config, self.Scroller)
        table.insert(self.Elements, toggle)
        return toggle
    end
    
    function TabObj:AddSlider(config)
        local Slider = require(script.Parent.Slider)
        local slider = Slider:New(config, self.Scroller)
        table.insert(self.Elements, slider)
        return slider
    end
    
    function TabObj:AddDropdown(config)
        local Dropdown = require(script.Parent.Dropdown)
        local dropdown = Dropdown:New(config, self.Scroller)
        table.insert(self.Elements, dropdown)
        return dropdown
    end
    
    function TabObj:AddInput(config)
        local Input = require(script.Parent.Input)
        local input = Input:New(config, self.Scroller)
        table.insert(self.Elements, input)
        return input
    end
    
    function TabObj:AddLabel(config)
        local Label = require(script.Parent.Label)
        local label = Label:New(config, self.Scroller)
        table.insert(self.Elements, label)
        return label
    end
    
    function TabObj:Destroy()
        tabBtn:Destroy()
        page:Destroy()
    end
    
    return TabObj
end

return Tab
