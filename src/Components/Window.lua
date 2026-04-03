--[[
    SpectrumX Window Component
    Janela principal da UI Library
    
    Features:
    - Acrylic/Glass background
    - Draggable
    - Resizable
    - Minimize/Restore
    - Responsive sizing
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local Window = {}

-- ─── CRIAR JANELA ─────────────────────────────────────────────────────────────
function Window:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    local Elements = require(script.Parent.Parent.Elements)
    
    local WindowObj = {}
    
    -- Propriedades
    WindowObj.Title = config.Title or "SpectrumX"
    WindowObj.SubTitle = config.SubTitle
    WindowObj.Size = config.Size or UDim2.fromOffset(550, 600)
    WindowObj.TabWidth = config.TabWidth or 160
    WindowObj.Minimized = false
    WindowObj.Visible = true
    WindowObj.Tabs = {}
    WindowObj.CurrentTab = nil
    
    -- Ajustar tamanho para responsivo
    if config.Responsive ~= false then
        WindowObj.Size = Utils.Responsive:GetWindowSize()
    end
    
    -- Posição central
    WindowObj.Position = config.Position or Utils.Responsive:GetWindowCenterPosition(WindowObj.Size)
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Window"
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = WindowObj.Position
    mainFrame.Size = WindowObj.Size
    mainFrame.Active = true
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 10
    mainFrame.Parent = parent
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Borda de destaque
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = mainFrame
    
    -- Gradiente de fundo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Background),
        ColorSequenceKeypoint.new(1, Theme.Surface)
    })
    gradient.Rotation = 90
    gradient.Parent = mainFrame
    
    -- Acrylic effect (opcional)
    if config.Acrylic then
        Elements.Acrylic:Init()
        Elements.Acrylic:Enable()
        WindowObj.AcrylicPaint = Elements.Acrylic:CreatePaint()
        WindowObj.AcrylicPaint:AddParent(mainFrame)
    end
    
    -- TitleBar
    WindowObj.TitleBar = Elements.TitleBar:New({
        Title = WindowObj.Title,
        SubTitle = WindowObj.SubTitle,
        Icon = config.Icon,
        Window = WindowObj
    }, mainFrame)
    
    -- Área de conteúdo
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.BackgroundTransparency = 1
    contentArea.Position = UDim2.new(0, 0, 0, 48)
    contentArea.Size = UDim2.new(1, 0, 1, -48)
    contentArea.ZIndex = 11
    contentArea.Parent = mainFrame
    
    -- Sidebar (área das tabs)
    local sidebarWidth = Utils.Responsive:GetTabWidth()
    
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.BackgroundColor3 = Theme.Sidebar or Color3.fromRGB(10, 10, 10)
    sidebar.BorderSizePixel = 0
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.Size = UDim2.new(0, sidebarWidth, 1, 0)
    sidebar.ZIndex = 12
    sidebar.Parent = contentArea
    
    -- Gradiente da sidebar
    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Sidebar or Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(1, Theme.Surface or Color3.fromRGB(18, 18, 18))
    })
    sidebarGradient.Rotation = 90
    sidebarGradient.Parent = sidebar
    
    -- Linha separadora
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.BackgroundColor3 = Theme.Border
    separator.BorderSizePixel = 0
    separator.Position = UDim2.new(1, -1, 0, 0)
    separator.Size = UDim2.new(0, 1, 1, 0)
    separator.ZIndex = 13
    separator.Parent = sidebar
    
    -- ScrollingFrame para tabs
    local tabScroller = Instance.new("ScrollingFrame")
    tabScroller.Name = "TabScroller"
    tabScroller.BackgroundTransparency = 1
    tabScroller.BorderSizePixel = 0
    tabScroller.Position = UDim2.new(0, 0, 0, 10)
    tabScroller.Size = UDim2.new(1, 0, 1, -20)
    tabScroller.ScrollBarThickness = 2
    tabScroller.ScrollBarImageColor3 = Theme.Accent
    tabScroller.ScrollBarImageTransparency = 0.6
    tabScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScroller.ZIndex = 12
    tabScroller.Parent = sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabScroller
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.PaddingBottom = UDim.new(0, 5)
    tabPadding.Parent = tabScroller
    
    -- Atualizar canvas size
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroller.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Área das páginas
    local pageArea = Instance.new("Frame")
    pageArea.Name = "PageArea"
    pageArea.BackgroundTransparency = 1
    pageArea.Position = UDim2.new(0, sidebarWidth + 10, 0, 10)
    pageArea.Size = UDim2.new(1, -(sidebarWidth + 20), 1, -20)
    pageArea.ZIndex = 12
    pageArea.Parent = contentArea
    
    -- Referências
    WindowObj.Frame = mainFrame
    WindowObj.Sidebar = sidebar
    WindowObj.TabScroller = tabScroller
    WindowObj.PageArea = pageArea
    WindowObj.ContentArea = contentArea
    
    -- Draggable
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    WindowObj.TitleBar.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    WindowObj.TitleBar.Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Resize handle (canto inferior direito)
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.ZIndex = 100
    resizeHandle.Parent = mainFrame
    
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = mainFrame.Size
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(400, startSize.X.Offset + delta.X)
            local newHeight = math.max(300, startSize.Y.Offset + delta.Y)
            
            mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    -- Métodos
    function WindowObj:AddTab(tabConfig)
        local Tab = require(script.Parent.Tab)
        local tab = Tab:New(tabConfig, self)
        table.insert(self.Tabs, tab)
        
        -- Selecionar primeira tab automaticamente
        if #self.Tabs == 1 then
            self:SelectTab(tab)
        end
        
        return tab
    end
    
    function WindowObj:SelectTab(tab)
        if type(tab) == "string" then
            -- Buscar tab pelo nome
            for _, t in ipairs(self.Tabs) do
                if t.Title == tab then
                    tab = t
                    break
                end
            end
        end
        
        if not tab then return end
        
        -- Desativar tab atual
        if self.CurrentTab then
            self.CurrentTab:SetActive(false)
        end
        
        -- Ativar nova tab
        self.CurrentTab = tab
        tab:SetActive(true)
    end
    
    function WindowObj:Minimize()
        self.Minimized = true
        
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, self.Size.X.Offset, 0, 48)
        }):Play()
        
        contentArea.Visible = false
    end
    
    function WindowObj:Restore()
        self.Minimized = false
        
        contentArea.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = self.Size
        }):Play()
    end
    
    function WindowObj:Toggle()
        if self.Minimized then
            self:Restore()
        else
            self:Minimize()
        end
    end
    
    function WindowObj:SetVisible(visible)
        self.Visible = visible
        mainFrame.Visible = visible
    end
    
    function WindowObj:SetTitle(title)
        self.Title = title
        self.TitleBar:SetTitle(title)
    end
    
    function WindowObj:SetSize(size)
        self.Size = size
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = size
        }):Play()
    end
    
    function WindowObj:SetPosition(position)
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Position = position
        }):Play()
    end
    
    function WindowObj:Notify(config)
        return Elements.Notification:New(config)
    end
    
    function WindowObj:Dialog(config)
        -- Implementação de diálogo modal
        -- TODO: Implementar Dialog component
    end
    
    function WindowObj:Destroy()
        -- Animação de saída
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, self.Size.X.Offset, 0, 0)
        }):Play()
        
        task.delay(0.2, function()
            if config.Acrylic then
                Elements.Acrylic:Disable()
            end
            mainFrame:Destroy()
        end)
    end
    
    -- Animação de entrada
    mainFrame.Size = UDim2.new(0, WindowObj.Size.X.Offset, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = WindowObj.Size
    }):Play()
    
    return WindowObj
end

return Window
