# SpectrumX UI Library v3.0

Uma UI Library profissional e modular para Roblox Executores (Synapse X, KRNL, Fluxus, etc.), inspirada na Fluent UI mas mantendo as características únicas do SpectrumX original.

## ✨ Características

- 🎨 **Tema Dark/Black Gradiente** - Design moderno com cores escuras e gradientes suaves
- 🔘 **Botão Flutuante** - Botão circular flutuante sempre visível para toggle da janela
- 📱 **Responsivo** - Adapta-se automaticamente a diferentes tamanhos de tela (Mobile/Tablet/Desktop)
- 🪟 **Efeito Acrylic/Glass** - Efeito de vidro fosco opcional
- ⚡ **Animações Suaves** - Transições fluidas em todos os componentes
- 🧩 **Componentes Modulares** - Estrutura organizada e extensível

## 📁 Estrutura de Arquivos

```
SpectrumXUILibrary/
├── src/
│   ├── init.lua                 # Entry point
│   ├── Icons.lua                # Biblioteca de ícones
│   ├── Components/
│   │   ├── init.lua
│   │   ├── Window.lua           # Janela principal
│   │   ├── Tab.lua              # Sistema de abas
│   │   ├── Section.lua          # Agrupador de elementos
│   │   ├── Button.lua           # Botão com hover/ripple
│   │   ├── Toggle.lua           # Switch on/off
│   │   ├── Slider.lua           # Slider com value label
│   │   ├── Dropdown.lua         # Dropdown com search
│   │   ├── Input.lua            # Input de texto/número
│   │   ├── Label.lua            # Texto estático
│   │   └── Container.lua        # Layout wrapper
│   ├── Elements/
│   │   ├── init.lua
│   │   ├── Acrylic.lua          # Efeito vidro fosco
│   │   ├── TitleBar.lua         # Barra de título
│   │   ├── Notification.lua     # Sistema de notificações
│   │   └── FloatingButton.lua   # Botão flutuante
│   ├── Themes/
│   │   ├── init.lua
│   │   └── Dark.lua             # Tema dark/black gradiente
│   └── Utils/
│       ├── init.lua
│       ├── Tween.lua            # Sistema de animações
│       ├── Event.lua            # Gerenciamento de eventos
│       └── Responsive.lua       # Sistema de breakpoints
└── README.md
```

## 🚀 Instalação

### Método 1: Loadstring (Recomendado)

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/seu-usuario/SpectrumXUILibrary/main/src/init.lua"))()
```

### Método 2: Arquivo Local

```lua
local Library = loadstring(readfile("path/to/SpectrumXUILibrary/src/init.lua"))()
```

## 📖 Uso Básico

```lua
local Library = loadstring(game:HttpGet("URL"))()

-- Criar janela
local Window = Library:CreateWindow({
    Title = "Meu Script",
    SubTitle = "by SeuNome",
    Size = UDim2.fromOffset(550, 600),
    Theme = "Dark",
    Acrylic = true, -- Efeito de vidro
    MinimizeKey = Enum.KeyCode.RightControl,
    FloatingButton = {
        Enabled = true,
        Icon = "menu",
        Position = "BottomRight", -- BottomRight, BottomLeft, TopRight, TopLeft
        Draggable = true
    }
})

-- Criar tab
local Tab = Window:AddTab({
    Title = "Main",
    Icon = "home"
})

-- Criar seção
local Section = Tab:AddSection("Farm")

-- Adicionar componentes
Section:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

Section:AddSlider({
    Title = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Callback = function(value)
        print("Speed:", value)
    end
})

Section:AddButton({
    Title = "Start Farm",
    Style = "accent", -- default, accent, outline, danger
    Callback = function()
        print("Farm started!")
    end
})

-- Notificação
Library:Notify({
    Title = "Bem-vindo!",
    Content = "Script carregado com sucesso!",
    Duration = 5
})
```

## 🎨 Componentes

### Window

```lua
local Window = Library:CreateWindow({
    Title = "Título",
    SubTitle = "Subtítulo opcional",
    Size = UDim2.fromOffset(550, 600),
    TabWidth = 160,
    Theme = "Dark",
    Acrylic = false,
    MinimizeKey = Enum.KeyCode.RightControl,
    FloatingButton = {
        Enabled = true,
        Icon = "menu",
        Position = "BottomRight",
        Draggable = true
    }
})

-- Métodos
Window:SetTitle("Novo Título")
Window:SetSize(UDim2.fromOffset(600, 700))
Window:SetPosition(UDim2.new(0.5, -300, 0.5, -350))
Window:Minimize()
Window:Restore()
Window:Toggle()
Window:SetVisible(true)
Window:Destroy()
```

### Tab

```lua
local Tab = Window:AddTab({
    Title = "Nome da Tab",
    Icon = "home" -- Pode ser emoji ou Asset ID
})

-- Métodos
Tab:AddSection("Título da Seção")
Tab:AddButton({...})
Tab:AddToggle({...})
Tab:AddSlider({...})
Tab:AddDropdown({...})
Tab:AddInput({...})
Tab:AddLabel({...})
```

### Section

```lua
local Section = Tab:AddSection({
    Title = "Farm",
    Collapsible = false
})

-- Métodos
Section:AddButton({...})
Section:AddToggle({...})
-- ... etc
Section:SetTitle("Novo Título")
Section:ToggleCollapse()
```

### Button

```lua
Section:AddButton({
    Title = "Clique Aqui",
    Style = "accent", -- default, accent, outline, danger, success
    Callback = function()
        print("Clicado!")
    end
})

-- Métodos
Button:SetTitle("Novo Título")
Button:SetCallback(function() end)
Button:SetVisible(true)
Button:SetEnabled(true)
```

### Toggle

```lua
Section:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

-- Métodos
Toggle:GetValue() -- boolean
Toggle:SetValue(true)
Toggle:SetTitle("Novo Título")
```

### Slider

```lua
Section:AddSlider({
    Title = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Decimals = 0, -- Casas decimais
    Suffix = "%", -- Sufixo do valor
    Callback = function(value)
        print("Valor:", value)
    end
})

-- Métodos
Slider:GetValue() -- number
Slider:SetValue(75)
Slider:SetTitle("Novo Título")
```

### Dropdown

```lua
Section:AddDropdown({
    Title = "Selecionar",
    Options = {"Opção 1", "Opção 2", "Opção 3"},
    Default = "Opção 1",
    Searchable = true, -- Habilitar pesquisa
    Multi = false, -- Seleção múltipla
    Callback = function(value)
        print("Selecionado:", value)
    end
})

-- Métodos
Dropdown:GetValue() -- string ou table (se Multi)
Dropdown:SetValue("Opção 2")
Dropdown:SetOptions({"Nova", "Lista"})
Dropdown:Close()
```

### Input

```lua
Section:AddInput({
    Title = "Nome",
    Default = "",
    Placeholder = "Digite seu nome...",
    Numeric = false, -- Apenas números
    Min = 0, -- Se Numeric
    Max = 100, -- Se Numeric
    Finished = false, -- Callback apenas ao terminar (perder foco)
    Callback = function(value)
        print("Input:", value)
    end
})

-- Métodos
Input:GetValue() -- string ou number
Input:SetValue("Novo valor")
Input:SetPlaceholder("Novo placeholder")
Input:Focus()
```

### Label

```lua
Section:AddLabel({
    Text = "Texto do label",
    Style = "default", -- default, title, subtitle, muted, accent, success, warning, error
    Alignment = "Left", -- Left, Center, Right
    Wrap = true,
    RichText = false,
    Separator = false -- Linha separadora acima
})

-- Métodos
Label:SetText("Novo texto")
Label:SetStyle("accent")
Label:SetAlignment("Center")
```

### Container

```lua
-- Container vertical (padrão)
local Container = Tab:AddContainer({
    Direction = "Vertical",
    Padding = 8,
    Fill = false
})

-- Container horizontal (Row)
local Row = Tab:AddContainer({
    Direction = "Horizontal",
    Padding = 8
})

-- Grid
local Grid = Tab:AddContainer({
    Grid = true,
    CellSize = UDim2.new(0, 100, 0, 40),
    Padding = 8
})
```

## 🔔 Notificações

```lua
-- Notificação simples
Library:Notify({
    Title = "Título",
    Content = "Conteúdo da notificação",
    Duration = 5 -- segundos
})

-- Notificação com tipo
Library:Notify({
    Title = "Sucesso!",
    Content = "Operação concluída",
    SubContent = "Detalhes adicionais",
    Duration = 5,
    Type = "Success" -- Info, Success, Warning, Error
})

-- Notificação da janela
Window:Notify({...})
```

## 🎨 Temas

### Cores do Tema Dark

```lua
local Theme = Library:GetTheme()

-- Cores base
Theme.Background        -- #0a0a0a
Theme.Surface          -- #121212
Theme.SurfaceHover     -- #1c1c1c

-- Cores de destaque (configurável)
Theme.Accent           -- #7c3aed (roxo) ou #3b82f6 (azul)
Theme.AccentHover      -- #8b5cf6
Theme.AccentDark       -- #6d28d9

-- Texto
Theme.Text             -- #ffffff
Theme.TextSecondary    -- #e5e5e5
Theme.TextMuted        -- #a3a3a3

-- Estados
Theme.Success          -- #22c55e
Theme.Warning          -- #eab308
Theme.Error            -- #ef4444
Theme.Info             -- #3b82f6
```

### Mudar Cor de Destaque

```lua
local Theme = Library:GetTheme()
Theme:SetAccentColor("purple") -- purple, blue, red, green
```

## 📱 Responsividade

A biblioteca detecta automaticamente o tamanho da tela e se ajusta:

- **Mobile** (< 600px): Tabs compactas, elementos reorganizados
- **Tablet** (600-900px): Layout intermediário
- **Desktop** (> 900px): Layout completo

```lua
local Utils = Library.Utils

-- Verificar breakpoint
if Utils.Responsive.IsMobile then
    -- Código específico para mobile
end

-- Escalar valores
local scaledSize = Utils.Responsive:Scale(100) -- 100 * scaleFactor

-- Obter tamanho adaptativo
local size = Utils.Responsive:GetAdaptiveSize(
    UDim2.fromOffset(400, 500), -- Mobile
    UDim2.fromOffset(500, 450), -- Tablet
    UDim2.fromOffset(550, 600)  -- Desktop
)
```

## 🔘 Botão Flutuante

O botão flutuante é criado automaticamente quando habilitado na configuração da janela:

```lua
FloatingButton = {
    Enabled = true,
    Icon = "menu", -- Emoji ou Asset ID
    Position = "BottomRight", -- BottomRight, BottomLeft, TopRight, TopLeft
    Draggable = true
}
```

### Posições Disponíveis

- `"BottomRight"` - Canto inferior direito (padrão)
- `"BottomLeft"` - Canto inferior esquerdo
- `"TopRight"` - Canto superior direito
- `"TopLeft"` - Canto superior esquerdo

## 🪟 Efeito Acrylic

Habilite o efeito de vidro fosco:

```lua
local Window = Library:CreateWindow({
    Title = "Meu Script",
    Acrylic = true -- Habilita efeito
})

-- Toggle durante execução
Library:ToggleAcrylic(true)
```

## ⚡ Animações

### Tween

```lua
local Tween = Library.Utils.Tween

-- Tween simples
Tween:Play(object, {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = Color3.new(1, 0, 0)
}, 0.3)

-- Tween com easing
Tween:Play(object, {...}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Tween com callback
Tween:PlayWithCallback(object, {...}, 0.3, function()
    print("Tween completado!")
end)
```

### Number Tween

```lua
Tween:Number(0, 100, 1, function(value)
    print("Valor:", value)
end)
```

## 🎯 Eventos

```lua
local Event = Library.Utils.Event

-- Conectar evento
local conn = Event:Connect(object.MouseEnter, function()
    print("Mouse entrou!")
end)

-- Desconectar
Event:Disconnect(conn)

-- Evento customizado
Event:On("MeuEvento", function(data)
    print("Evento disparado:", data)
end)

-- Disparar evento
Event:Trigger("MeuEvento", "dados")

-- Input events
Event:OnKeyPressed(Enum.KeyCode.F, function()
    print("F pressionado!")
end)
```

## 📋 Ícones

```lua
local Icons = Library.Icons

-- Usar ícone
local icon = Icons.home -- "🏠"

-- Verificar se existe
if Icons:Exists("home") then
    -- ...
end

-- Adicionar ícone customizado
Icons:Add("custom", "rbxassetid://123456")
```

### Ícones Disponíveis

**Navegação:** `home`, `menu`, `settings`, `user`, `search`, `back`, `forward`, `close`

**Ação:** `play`, `pause`, `stop`, `refresh`, `save`, `download`, `upload`, `copy`

**Estado:** `check`, `cross`, `warning`, `info`, `success`, `error`, `loading`

**Jogo:** `sword`, `shield`, `heart`, `coin`, `gem`, `chest`, `trophy`

**Roblox:** `roblox`, `avatar`, `inventory`, `friends`, `catalog`

**Farm:** `auto`, `farm`, `money`, `quest`, `stats`

## 🔧 Utilitários

```lua
local Utils = Library.Utils

-- Criar elementos visuais
Utils:CreateCorner(parent, UDim.new(0, 8))
Utils:CreateStroke(parent, color, 1, 0.5)
Utils:CreateGradient(parent, color1, color2, 90)
Utils:CreatePadding(parent, 10, 10, 10, 10)
Utils:CreateListLayout(parent, 8)

-- Verificar Asset ID
if Utils:IsAssetId("rbxassetid://123456") then
    -- ...
end

-- Formatar Asset ID
local assetId = Utils:FormatAssetId("123456") -- "rbxassetid://123456"

-- Clamp
local value = Utils:Clamp(150, 0, 100) -- 100

-- Lerp
local value = Utils:Lerp(0, 100, 0.5) -- 50

-- Map Range
local value = Utils:MapRange(50, 0, 100, 0, 1) -- 0.5

-- Round
local value = Utils:Round(3.14159, 2) -- 3.14

-- Format Number
local text = Utils:FormatNumber(1500000) -- "1.5M"

-- Debounce
local debouncedFunc = Utils:Debounce(function()
    print("Chamado!")
end, 0.5)
```

## 🛠️ Exemplos Avançados

### Exemplo 1: Script de Farm Completo

```lua
local Library = loadstring(game:HttpGet("URL"))()

local Window = Library:CreateWindow({
    Title = "Farm Script",
    SubTitle = "v1.0",
    Theme = "Dark",
    FloatingButton = {
        Enabled = true,
        Icon = "farm",
        Position = "BottomRight"
    }
})

local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
local FarmTab = Window:AddTab({ Title = "Farm", Icon = "auto" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

-- Main Tab
local InfoSection = MainTab:AddSection("Informações")
InfoSection:AddLabel({
    Text = "Bem-vindo ao Farm Script!",
    Style = "title"
})
InfoSection:AddLabel({
    Text = "Versão 1.0 - by SeuNome",
    Style = "muted"
})

-- Farm Tab
local AutoSection = FarmTab:AddSection("Auto Farm")

local autoFarm = false
AutoSection:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        autoFarm = value
        if value then
            Library:Notify({
                Title = "Auto Farm",
                Content = "Auto Farm ativado!",
                Type = "Success"
            })
        end
    end
})

AutoSection:AddSlider({
    Title = "Farm Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        _G.FarmSpeed = value
    end
})

local TargetSection = FarmTab:AddSection("Target")
TargetSection:AddDropdown({
    Title = "Select Target",
    Options = {"Enemy 1", "Enemy 2", "Enemy 3", "Boss"},
    Default = "Enemy 1",
    Callback = function(value)
        _G.Target = value
    end
})

-- Settings Tab
local ConfigSection = SettingsTab:AddSection("Configurações")

ConfigSection:AddToggle({
    Title = "Anti-AFK",
    Default = true,
    Callback = function(value)
        _G.AntiAFK = value
    end
})

ConfigSection:AddToggle({
    Title = "Auto Save",
    Default = true,
    Callback = function(value)
        _G.AutoSave = value
    end
})

ConfigSection:AddButton({
    Title = "Save Settings",
    Style = "accent",
    Callback = function()
        Library:Notify({
            Title = "Settings",
            Content = "Configurações salvas!",
            Type = "Success"
        })
    end
})

Library:Notify({
    Title = "Script Loaded",
    Content = "Farm Script v1.0 carregado com sucesso!",
    Duration = 5
})
```

### Exemplo 2: Layout Responsivo

```lua
local Library = loadstring(game:HttpGet("URL"))()

local Window = Library:CreateWindow({
    Title = "Responsive UI",
    Theme = "Dark"
})

local Tab = Window:AddTab({ Title = "Layout", Icon = "grid" })

-- Row com 2 botões lado a lado
local ButtonRow = Tab:AddContainer({
    Direction = "Horizontal",
    Padding = 10
})

ButtonRow:AddButton({
    Title = "Botão 1",
    Callback = function() print("1") end
})

ButtonRow:AddButton({
    Title = "Botão 2",
    Callback = function() print("2") end
})

-- Grid de toggles
local ToggleGrid = Tab:AddContainer({
    Grid = true,
    CellSize = UDim2.new(0, 150, 0, 40),
    Padding = 8
})

for i = 1, 6 do
    ToggleGrid:AddToggle({
        Title = "Toggle " .. i,
        Callback = function(v) print("Toggle " .. i .. ":", v) end
    })
end
```

## 📝 Changelog

### v3.0.0
- ✅ Estrutura modular completa
- ✅ Sistema de responsividade com breakpoints
- ✅ Botão flutuante com animações
- ✅ Efeito Acrylic/Glass
- ✅ Tema Dark/Black gradiente
- ✅ Todos os componentes base
- ✅ Sistema de notificações
- ✅ Animações suaves

## 🤝 Contribuição

Sinta-se à vontade para contribuir com a biblioteca! Envie pull requests ou abra issues no GitHub.

## 📄 Licença

Este projeto está licenciado sob a MIT License.

---

**SpectrumX UI Library** - Feito com ❤️ para a comunidade Roblox
