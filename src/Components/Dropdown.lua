--[[
    SpectrumX Dropdown Component
    Dropdown com search opcional
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Dropdown = {}

-- Lista global de dropdowns abertos
Dropdown.OpenDropdowns = {}

-- ─── CRIAR DROPDOWN ───────────────────────────────────────────────────────────
function Dropdown:New(config, parent)
    config = config or {}
    local Theme = require(script.Parent.Parent.Themes):GetCurrent()
    local Utils = require(script.Parent.Parent.Utils)
    
    local DropdownObj = {}
    
    -- Propriedades
    DropdownObj.Title = config.Title or "Dropdown"
    DropdownObj.Options = config.Options or {}
    DropdownObj.Default = config.Default
    DropdownObj.Callback = config.Callback or function() end
    DropdownObj.Searchable = config.Searchable or false
    DropdownObj.Multi = config.Multi or false
    
    DropdownObj.Value = DropdownObj.Default
    DropdownObj.Values = DropdownObj.Multi and (config.Default or {}) or nil
    DropdownObj.IsOpen = false
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = DropdownObj.Title .. "Dropdown"
    frame.BackgroundColor3 = Theme.Card
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, DropdownObj.Searchable and 90 or 62)
    frame.ClipsDescendants = false
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
    label.Size = UDim2.new(1, -28, 0, 14)
    label.Font = Enum.Font.GothamSemibold
    label.Text = DropdownObj.Title
    label.TextColor3 = Theme.TextMuted
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 21
    label.Parent = frame
    
    -- Botão do dropdown
    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = "DropBtn"
    dropBtn.BackgroundColor3 = Theme.InputBackground
    dropBtn.AutoButtonColor = false
    dropBtn.Position = UDim2.new(0, 12, 0, 26)
    dropBtn.Size = UDim2.new(1, -24, 0, 28)
    dropBtn.Font = Enum.Font.GothamSemibold
    dropBtn.Text = "  " .. (DropdownObj.Default or "Selecionar...")
    dropBtn.TextColor3 = DropdownObj.Default and Theme.Text or Theme.TextMuted
    dropBtn.TextSize = 12
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.ZIndex = 22
    dropBtn.Parent = frame
    
    local dropBtnCorner = Instance.new("UICorner")
    dropBtnCorner.CornerRadius = UDim.new(0, 6)
    dropBtnCorner.Parent = dropBtn
    
    local dropBtnStroke = Instance.new("UIStroke")
    dropBtnStroke.Color = Theme.Border
    dropBtnStroke.Thickness = 1
    dropBtnStroke.Transparency = 0.4
    dropBtnStroke.Parent = dropBtn
    
    -- Seta
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -28, 0, 0)
    arrow.Size = UDim2.new(0, 26, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▾"
    arrow.TextColor3 = Theme.Accent
    arrow.TextSize = 14
    arrow.ZIndex = 23
    arrow.Parent = dropBtn
    
    -- Search box (opcional)
    local searchBox
    if DropdownObj.Searchable then
        searchBox = Instance.new("TextBox")
        searchBox.Name = "SearchBox"
        searchBox.BackgroundColor3 = Theme.InputBackground
        searchBox.Position = UDim2.new(0, 12, 0, 58)
        searchBox.Size = UDim2.new(1, -24, 0, 26)
        searchBox.Font = Enum.Font.Gotham
        searchBox.PlaceholderText = "Pesquisar..."
        searchBox.PlaceholderColor3 = Theme.TextMuted
        searchBox.Text = ""
        searchBox.TextColor3 = Theme.Text
        searchBox.TextSize = 12
        searchBox.ClearTextOnFocus = false
        searchBox.ZIndex = 22
        searchBox.Parent = frame
        
        local searchCorner = Instance.new("UICorner")
        searchCorner.CornerRadius = UDim.new(0, 6)
        searchCorner.Parent = searchBox
        
        local searchStroke = Instance.new("UIStroke")
        searchStroke.Color = Theme.Border
        searchStroke.Thickness = 1
        searchStroke.Transparency = 0.4
        searchStroke.Parent = searchBox
    end
    
    -- Lista do dropdown (ScreenGui)
    local screenGui = parent:FindFirstAncestorOfClass("ScreenGui")
    local dropList = Instance.new("ScrollingFrame")
    dropList.Name = "DropList"
    dropList.BackgroundColor3 = Theme.DropdownBackground
    dropList.BorderSizePixel = 0
    dropList.Size = UDim2.new(0, 0, 0, 0)
    dropList.ScrollBarThickness = 3
    dropList.ScrollBarImageColor3 = Theme.Accent
    dropList.Visible = false
    dropList.ZIndex = 100
    dropList.Parent = screenGui
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = dropList
    
    local listStroke = Instance.new("UIStroke")
    listStroke.Color = Theme.Accent
    listStroke.Thickness = 1.5
    listStroke.Transparency = 0.2
    listStroke.Parent = dropList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 3)
    listLayout.Parent = dropList
    
    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingBottom = UDim.new(0, 5)
    listPadding.PaddingLeft = UDim.new(0, 5)
    listPadding.PaddingRight = UDim.new(0, 5)
    listPadding.Parent = dropList
    
    -- Função para fechar dropdown
    local function closeDropdown()
        if not DropdownObj.IsOpen then return end
        DropdownObj.IsOpen = false
        
        -- Remover da lista global
        for i, dd in ipairs(Dropdown.OpenDropdowns) do
            if dd == DropdownObj then
                table.remove(Dropdown.OpenDropdowns, i)
                break
            end
        end
        
        -- Animação de saída
        TweenService:Create(dropList, TweenInfo.new(0.2), {
            Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
        }):Play()
        
        TweenService:Create(arrow, TweenInfo.new(0.2), {
            Rotation = 0
        }):Play()
        
        if dropBtnStroke then
            TweenService:Create(dropBtnStroke, TweenInfo.new(0.2), {
                Color = Theme.Border,
                Transparency = 0.4
            }):Play()
        end
        
        task.delay(0.2, function()
            if dropList and dropList.Parent then
                dropList.Visible = false
            end
        end)
    end
    
    -- Função para abrir dropdown
    local function openDropdown()
        if DropdownObj.IsOpen then
            closeDropdown()
            return
        end
        
        -- Fechar outros dropdowns
        for _, dd in ipairs(Dropdown.OpenDropdowns) do
            dd:Close()
        end
        
        DropdownObj.IsOpen = true
        table.insert(Dropdown.OpenDropdowns, DropdownObj)
        
        -- Popular lista
        populateList()
        
        -- Posicionar
        local btnPos = dropBtn.AbsolutePosition
        local btnSize = dropBtn.AbsoluteSize
        local maxHeight = 200
        
        dropList.Position = UDim2.fromOffset(btnPos.X, btnPos.Y + btnSize.Y + 4)
        dropList.Size = UDim2.new(0, btnSize.X, 0, 0)
        dropList.Visible = true
        
        -- Calcular altura
        local contentHeight = listLayout.AbsoluteContentSize.Y + 10
        local targetHeight = math.min(contentHeight, maxHeight)
        
        -- Ajustar se passar da tela
        local camera = workspace.CurrentCamera
        if camera then
            local screenHeight = camera.ViewportSize.Y
            local listBottom = btnPos.Y + btnSize.Y + 4 + targetHeight
            if listBottom > screenHeight then
                dropList.Position = UDim2.fromOffset(btnPos.X, btnPos.Y - targetHeight - 4)
            end
        end
        
        dropList.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        
        -- Animação de entrada
        TweenService:Create(dropList, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, btnSize.X, 0, targetHeight)
        }):Play()
        
        TweenService:Create(arrow, TweenInfo.new(0.2), {
            Rotation = 180
        }):Play()
        
        if dropBtnStroke then
            TweenService:Create(dropBtnStroke, TweenInfo.new(0.2), {
                Color = Theme.Accent,
                Transparency = 0.2
            }):Play()
        end
    end
    
    -- Função para popular lista
    function populateList(filter)
        -- Limpar lista
        for _, child in ipairs(dropList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Adicionar opções
        for _, option in ipairs(DropdownObj.Options) do
            -- Filtrar se houver search
            if filter and filter ~= "" then
                if not string.find(string.lower(option), string.lower(filter)) then
                    continue
                end
            end
            
            local isSelected = false
            if DropdownObj.Multi then
                isSelected = table.find(DropdownObj.Values, option) ~= nil
            else
                isSelected = option == DropdownObj.Value
            end
            
            local row = Instance.new("Frame")
            row.Name = option .. "Row"
            row.BackgroundColor3 = isSelected and Theme.AccentDark or Theme.InputBackground
            row.Size = UDim2.new(1, 0, 0, 30)
            row.ZIndex = 101
            row.Parent = dropList
            
            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 5)
            rowCorner.Parent = row
            
            if isSelected then
                local rowStroke = Instance.new("UIStroke")
                rowStroke.Color = Theme.Accent
                rowStroke.Thickness = 1
                rowStroke.Transparency = 0.3
                rowStroke.Parent = row
            end
            
            local rowBtn = Instance.new("TextButton")
            rowBtn.BackgroundTransparency = 1
            rowBtn.Size = UDim2.new(1, 0, 1, 0)
            rowBtn.Font = Enum.Font.GothamSemibold
            rowBtn.Text = (isSelected and "✓ " or "  ") .. option
            rowBtn.TextColor3 = isSelected and Theme.AccentSecondary or Theme.TextSecondary
            rowBtn.TextSize = 12
            rowBtn.TextXAlignment = Enum.TextXAlignment.Left
            rowBtn.ZIndex = 102
            rowBtn.Parent = row
            
            local rowPad = Instance.new("UIPadding")
            rowPad.PaddingLeft = UDim.new(0, 10)
            rowPad.Parent = rowBtn
            
            -- Hover
            rowBtn.MouseEnter:Connect(function()
                if not isSelected then
                    TweenService:Create(row, TweenInfo.new(0.1), {
                        BackgroundColor3 = Theme.CardHover
                    }):Play()
                end
            end)
            
            rowBtn.MouseLeave:Connect(function()
                if not isSelected then
                    TweenService:Create(row, TweenInfo.new(0.1), {
                        BackgroundColor3 = Theme.InputBackground
                    }):Play()
                end
            end)
            
            -- Clique
            rowBtn.MouseButton1Click:Connect(function()
                if DropdownObj.Multi then
                    -- Toggle seleção
                    local idx = table.find(DropdownObj.Values, option)
                    if idx then
                        table.remove(DropdownObj.Values, idx)
                    else
                        table.insert(DropdownObj.Values, option)
                    end
                    DropdownObj.Callback(DropdownObj.Values)
                else
                    DropdownObj.Value = option
                    dropBtn.Text = "  " .. option
                    dropBtn.TextColor3 = Theme.Text
                    DropdownObj.Callback(option)
                    closeDropdown()
                end
                
                -- Atualizar lista
                populateList(filter)
            end)
        end
    end
    
    -- Search functionality
    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            if DropdownObj.IsOpen then
                populateList(searchBox.Text)
            end
        end)
    end
    
    -- Hover no botão
    dropBtn.MouseEnter:Connect(function()
        TweenService:Create(dropBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.CardHover
        }):Play()
    end)
    
    dropBtn.MouseLeave:Connect(function()
        TweenService:Create(dropBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.InputBackground
        }):Play()
    end)
    
    -- Clique no botão
    dropBtn.MouseButton1Click:Connect(openDropdown)
    
    -- Fechar ao clicar fora
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            local mousePos = input.Position
            local listPos = dropList.AbsolutePosition
            local listSize = dropList.AbsoluteSize
            local btnPos = dropBtn.AbsolutePosition
            local btnSize = dropBtn.AbsoluteSize
            
            local inList = mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
                          mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y
            local inBtn = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and
                         mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
            
            if DropdownObj.IsOpen and not inList and not inBtn then
                closeDropdown()
            end
        end
    end)
    
    -- Referências
    DropdownObj.Frame = frame
    DropdownObj.Button = dropBtn
    DropdownObj.List = dropList
    DropdownObj.Arrow = arrow
    
    -- Métodos
    function DropdownObj:GetValue()
        return self.Multi and self.Values or self.Value
    end
    
    function DropdownObj:SetValue(value)
        if self.Multi then
            self.Values = value
        else
            self.Value = value
            self.Button.Text = "  " .. (value or "Selecionar...")
        end
    end
    
    function DropdownObj:SetOptions(options)
        self.Options = options
        if self.IsOpen then
            populateList()
        end
    end
    
    function DropdownObj:Close()
        closeDropdown()
    end
    
    function DropdownObj:SetTitle(title)
        self.Title = title
        label.Text = title
    end
    
    function DropdownObj:SetCallback(callback)
        self.Callback = callback
    end
    
    function DropdownObj:SetVisible(visible)
        frame.Visible = visible
    end
    
    function DropdownObj:SetEnabled(enabled)
        dropBtn.Active = enabled
    end
    
    function DropdownObj:Destroy()
        closeDropdown()
        frame:Destroy()
        dropList:Destroy()
    end
    
    return DropdownObj
end

return Dropdown
