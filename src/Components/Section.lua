--[[
    SpectrumX Section Component
    Agrupador visual de elementos
--]]

local TweenService = game:GetService("TweenService")

local Section = {}

-- ─── CRIAR SEÇÃO ──────────────────────────────────────────────────────────────
function Section:New(config, tab)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local SectionObj = {}
    
    -- Propriedades
    SectionObj.Title = config.Title or "Section"
    SectionObj.Tab = tab
    SectionObj.Elements = {}
    SectionObj.Collapsed = false
    
    -- Container principal
    local container = Instance.new("Frame")
    container.Name = SectionObj.Title .. "Section"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ZIndex = 15
    container.Parent = tab.Scroller
    
    -- Header da seção
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 30)
    header.ZIndex = 16
    header.Parent = container
    
    -- Linha decorativa
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.BackgroundColor3 = Theme.Border
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.ZIndex = 15
    line.Parent = header
    
    -- Label da seção
    local labelBg = Instance.new("Frame")
    labelBg.Name = "LabelBg"
    labelBg.BackgroundColor3 = Theme.Background
    labelBg.BorderSizePixel = 0
    labelBg.Position = UDim2.new(0, 0, 0, 0)
    labelBg.Size = UDim2.new(0, 0, 1, 0)
    labelBg.AutomaticSize = Enum.AutomaticSize.X
    labelBg.ZIndex = 16
    labelBg.Parent = header
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 16, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = "  " .. SectionObj.Title .. "  "
    label.TextColor3 = Theme.Accent
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 17
    label.Parent = labelBg
    
    -- Botão de colapsar (opcional)
    local collapseBtn
    if config.Collapsible then
        collapseBtn = Instance.new("TextButton")
        collapseBtn.Name = "CollapseBtn"
        collapseBtn.BackgroundTransparency = 1
        collapseBtn.Position = UDim2.new(1, -24, 0.5, -10)
        collapseBtn.Size = UDim2.new(0, 20, 0, 20)
        collapseBtn.Font = Enum.Font.GothamBold
        collapseBtn.Text = "▼"
        collapseBtn.TextColor3 = Theme.TextMuted
        collapseBtn.TextSize = 12
        collapseBtn.ZIndex = 17
        collapseBtn.Parent = header
        
        collapseBtn.MouseButton1Click:Connect(function()
            SectionObj:ToggleCollapse()
        end)
    end
    
    -- Container de elementos
    local elementsContainer = Instance.new("Frame")
    elementsContainer.Name = "Elements"
    elementsContainer.BackgroundTransparency = 1
    elementsContainer.Position = UDim2.new(0, 0, 0, 35)
    elementsContainer.Size = UDim2.new(1, 0, 0, 0)
    elementsContainer.AutomaticSize = Enum.AutomaticSize.Y
    elementsContainer.ZIndex = 15
    elementsContainer.Parent = container
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = elementsContainer
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.Parent = elementsContainer
    
    -- Referências
    SectionObj.Container = container
    SectionObj.Header = header
    SectionObj.ElementsContainer = elementsContainer
    SectionObj.CollapseBtn = collapseBtn
    
    -- Métodos
    function SectionObj:AddButton(config)
        local Button = require(script.Parent.Button)
        local btn = Button:New(config, self.ElementsContainer)
        table.insert(self.Elements, btn)
        return btn
    end
    
    function SectionObj:AddToggle(config)
        local Toggle = require(script.Parent.Toggle)
        local toggle = Toggle:New(config, self.ElementsContainer)
        table.insert(self.Elements, toggle)
        return toggle
    end
    
    function SectionObj:AddSlider(config)
        local Slider = require(script.Parent.Slider)
        local slider = Slider:New(config, self.ElementsContainer)
        table.insert(self.Elements, slider)
        return slider
    end
    
    function SectionObj:AddDropdown(config)
        local Dropdown = require(script.Parent.Dropdown)
        local dropdown = Dropdown:New(config, self.ElementsContainer)
        table.insert(self.Elements, dropdown)
        return dropdown
    end
    
    function SectionObj:AddInput(config)
        local Input = require(script.Parent.Input)
        local input = Input:New(config, self.ElementsContainer)
        table.insert(self.Elements, input)
        return input
    end
    
    function SectionObj:AddLabel(config)
        local Label = require(script.Parent.Label)
        local label = Label:New(config, self.ElementsContainer)
        table.insert(self.Elements, label)
        return label
    end
    
    function SectionObj:ToggleCollapse()
        self.Collapsed = not self.Collapsed
        
        if self.CollapseBtn then
            self.CollapseBtn.Text = self.Collapsed and "▶" or "▼"
        end
        
        if self.Collapsed then
            TweenService:Create(self.ElementsContainer, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            self.ElementsContainer.ClipsDescendants = true
        else
            self.ElementsContainer.ClipsDescendants = false
        end
    end
    
    function SectionObj:SetTitle(title)
        self.Title = title
        label.Text = "  " .. title .. "  "
    end
    
    function SectionObj:Destroy()
        container:Destroy()
    end
    
    return SectionObj
end

return Section
