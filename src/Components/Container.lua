--[[
    SpectrumX Container Component
    Layout wrapper para organização de elementos
--]]

local TweenService = game:GetService("TweenService")

local Container = {}

-- ─── CRIAR CONTAINER ──────────────────────────────────────────────────────────
function Container:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local ContainerObj = {}
    
    -- Propriedades
    ContainerObj.Direction = config.Direction or "Vertical" -- Vertical, Horizontal
    ContainerObj.Padding = config.Padding or 8
    ContainerObj.Fill = config.Fill or false -- Preencher espaço disponível
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = config.Name or "Container"
    frame.BackgroundTransparency = 1
    
    if ContainerObj.Fill then
        frame.Size = UDim2.new(1, 0, 1, 0)
    else
        frame.Size = UDim2.new(1, 0, 0, 0)
        frame.AutomaticSize = Enum.AutomaticSize.Y
    end
    
    frame.ZIndex = 15
    frame.Parent = parent
    
    -- Padding
    if config.PaddingTop or config.PaddingBottom or config.PaddingLeft or config.PaddingRight then
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, config.PaddingTop or 0)
        padding.PaddingBottom = UDim.new(0, config.PaddingBottom or 0)
        padding.PaddingLeft = UDim.new(0, config.PaddingLeft or 0)
        padding.PaddingRight = UDim.new(0, config.PaddingRight or 0)
        padding.Parent = frame
    end
    
    -- Layout
    local layout
    if ContainerObj.Direction == "Horizontal" then
        layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, ContainerObj.Padding)
        layout.HorizontalAlignment = config.HorizontalAlignment or Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = config.VerticalAlignment or Enum.VerticalAlignment.Top
    else
        layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, ContainerObj.Padding)
        layout.HorizontalAlignment = config.HorizontalAlignment or Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = config.VerticalAlignment or Enum.VerticalAlignment.Top
    end
    
    layout.Parent = frame
    
    -- Grid layout (opcional)
    if config.Grid then
        layout:Destroy()
        
        local grid = Instance.new("UIGridLayout")
        grid.CellSize = config.CellSize or UDim2.new(0, 100, 0, 40)
        grid.CellPadding = UDim2.new(0, ContainerObj.Padding, 0, ContainerObj.Padding)
        grid.FillDirection = Enum.FillDirection.Horizontal
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.HorizontalAlignment = config.HorizontalAlignment or Enum.HorizontalAlignment.Center
        grid.VerticalAlignment = config.VerticalAlignment or Enum.VerticalAlignment.Top
        grid.Parent = frame
        
        ContainerObj.Layout = grid
    else
        ContainerObj.Layout = layout
    end
    
    -- Background (opcional)
    if config.Background then
        frame.BackgroundTransparency = config.BackgroundTransparency or 0
        frame.BackgroundColor3 = config.BackgroundColor or Theme.Card
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, config.CornerRadius or 8)
        corner.Parent = frame
        
        if config.Border then
            local stroke = Instance.new("UIStroke")
            stroke.Color = config.BorderColor or Theme.Border
            stroke.Thickness = config.BorderThickness or 1
            stroke.Transparency = config.BorderTransparency or 0.5
            stroke.Parent = frame
        end
    end
    
    -- Referências
    ContainerObj.Frame = frame
    
    -- Métodos
    function ContainerObj:AddButton(config)
        local Button = require(script.Parent.Button)
        local btn = Button:New(config, self.Frame)
        return btn
    end
    
    function ContainerObj:AddToggle(config)
        local Toggle = require(script.Parent.Toggle)
        local toggle = Toggle:New(config, self.Frame)
        return toggle
    end
    
    function ContainerObj:AddSlider(config)
        local Slider = require(script.Parent.Slider)
        local slider = Slider:New(config, self.Frame)
        return slider
    end
    
    function ContainerObj:AddDropdown(config)
        local Dropdown = require(script.Parent.Dropdown)
        local dropdown = Dropdown:New(config, self.Frame)
        return dropdown
    end
    
    function ContainerObj:AddInput(config)
        local Input = require(script.Parent.Input)
        local input = Input:New(config, self.Frame)
        return input
    end
    
    function ContainerObj:AddLabel(config)
        local Label = require(script.Parent.Label)
        local label = Label:New(config, self.Frame)
        return label
    end
    
    function ContainerObj:AddChild(child)
        child.Parent = self.Frame
    end
    
    function ContainerObj:SetPadding(padding)
        self.Padding = padding
        if self.Layout:IsA("UIListLayout") then
            self.Layout.Padding = UDim.new(0, padding)
        elseif self.Layout:IsA("UIGridLayout") then
            self.Layout.CellPadding = UDim2.new(0, padding, 0, padding)
        end
    end
    
    function ContainerObj:SetDirection(direction)
        self.Direction = direction
        if self.Layout:IsA("UIListLayout") then
            self.Layout.FillDirection = direction == "Horizontal" and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
        end
    end
    
    function ContainerObj:SetVisible(visible)
        frame.Visible = visible
    end
    
    function ContainerObj:Destroy()
        frame:Destroy()
    end
    
    return ContainerObj
end

-- ─── CRIAR ROW (HORIZONTAL) ───────────────────────────────────────────────────
function Container:Row(config, parent)
    config = config or {}
    config.Direction = "Horizontal"
    return self:New(config, parent)
end

-- ─── CRIAR COLUMN (VERTICAL) ──────────────────────────────────────────────────
function Container:Column(config, parent)
    config = config or {}
    config.Direction = "Vertical"
    return self:New(config, parent)
end

-- ─── CRIAR GRID ───────────────────────────────────────────────────────────────
function Container:Grid(config, parent)
    config = config or {}
    config.Grid = true
    return self:New(config, parent)
end

return Container
