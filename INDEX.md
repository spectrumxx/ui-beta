# SpectrumX UI Library - Índice de Arquivos

## Estrutura do Projeto

```
SpectrumXUILibrary/
├── src/                           # Código fonte principal
│   ├── init.lua                   # Entry point da library
│   ├── Icons.lua                  # Biblioteca de ícones (emojis)
│   │
│   ├── Components/                # Componentes interativos
│   │   ├── init.lua               # Exporta todos os componentes
│   │   ├── Window.lua             # Janela principal (draggable, resizable)
│   │   ├── Tab.lua                # Sistema de abas/navegação
│   │   ├── Section.lua            # Agrupador visual de elementos
│   │   ├── Button.lua             # Botão com hover, ripple effect
│   │   ├── Toggle.lua             # Switch on/off animado
│   │   ├── Slider.lua             # Slider com value label
│   │   ├── Dropdown.lua           # Dropdown com search opcional
│   │   ├── Input.lua              # Input de texto e número
│   │   ├── Label.lua              # Texto estático com estilos
│   │   └── Container.lua          # Layout wrapper (Row, Column, Grid)
│   │
│   ├── Elements/                  # Elementos visuais reutilizáveis
│   │   ├── init.lua               # Exporta todos os elementos
│   │   ├── Acrylic.lua            # Efeito vidro fosco (Glassmorphism)
│   │   ├── TitleBar.lua           # Barra de título com controles
│   │   ├── Notification.lua       # Sistema de notificações toast
│   │   └── FloatingButton.lua     # Botão flutuante (OBRIGATÓRIO)
│   │
│   ├── Themes/                    # Sistema de temas
│   │   ├── init.lua               # Gerenciador de temas
│   │   └── Dark.lua               # Tema Dark/Black gradiente
│   │
│   └── Utils/                     # Utilitários
│       ├── init.lua               # Exporta todos os utilitários
│       ├── Tween.lua              # Sistema de animações
│       ├── Event.lua              # Gerenciamento de eventos
│       └── Responsive.lua         # Sistema de responsividade
│
├── Example.lua                    # Exemplo completo de uso
├── README.md                      # Documentação completa
└── INDEX.md                       # Este arquivo
```

## Arquivos e suas Funções

### Core

| Arquivo | Descrição |
|---------|-----------|
| `src/init.lua` | Entry point principal. Exporta a API pública da library. |
| `src/Icons.lua` | Biblioteca de ícones usando emojis. Suporta Asset IDs também. |

### Components

| Arquivo | Descrição | API Principal |
|---------|-----------|---------------|
| `Window.lua` | Janela principal com drag, resize, minimize | `Library:CreateWindow({...})` |
| `Tab.lua` | Sistema de abas com ícones | `Window:AddTab({...})` |
| `Section.lua` | Agrupador visual com título | `Tab:AddSection("Título")` |
| `Button.lua` | Botão com ripple effect | `Section:AddButton({...})` |
| `Toggle.lua` | Switch on/off animado | `Section:AddToggle({...})` |
| `Slider.lua` | Slider com value label | `Section:AddSlider({...})` |
| `Dropdown.lua` | Dropdown com search | `Section:AddDropdown({...})` |
| `Input.lua` | Input de texto/número | `Section:AddInput({...})` |
| `Label.lua` | Texto estático | `Section:AddLabel({...})` |
| `Container.lua` | Layout wrapper | `Tab:AddContainer({...})` |

### Elements

| Arquivo | Descrição | Recursos |
|---------|-----------|----------|
| `Acrylic.lua` | Efeito vidro fosco | Glassmorphism, blur background |
| `TitleBar.lua` | Barra de título | Título, subtítulo, botões minimize/close |
| `Notification.lua` | Notificações toast | Tipos: Info, Success, Warning, Error |
| `FloatingButton.lua` | Botão flutuante | Draggable, toggle window, glow effect |

### Themes

| Arquivo | Descrição | Cores |
|---------|-----------|-------|
| `Dark.lua` | Tema Dark/Black | Background: #0a0a0a, Accent: #7c3aed (roxo) |

### Utils

| Arquivo | Descrição | Funções |
|---------|-----------|---------|
| `Tween.lua` | Animações | `Tween:Play()`, `Tween:Number()`, `Tween:Spring()` |
| `Event.lua` | Eventos | `Event:Connect()`, `Event:On()`, `Event:Trigger()` |
| `Responsive.lua` | Responsividade | Breakpoints: Mobile(<600), Tablet(600-900), Desktop(>900) |

## Características Implementadas

### ✅ Botão Flutuante (OBRIGATÓRIO)
- [x] Botão circular flutuante
- [x] Posições: BottomRight, BottomLeft, TopRight, TopLeft
- [x] Animação de hover (scale up + glow)
- [x] Toggle da janela ao clicar
- [x] Ícone configurável
- [x] Sempre visível
- [x] Draggable opcional

### ✅ Tema Dark/Black Gradiente
- [x] Background: gradiente #0a0a0a → #1a1a1a
- [x] Surface: preto fosco com transparência
- [x] Primary: roxo neon (#7c3aed) ou azul (#3b82f6)
- [x] Text: branco/cinza claro
- [x] Borders: cinza escuro (#27272a)
- [x] Efeito Acrylic/Glass
- [x] Cantos arredondados (8-12px)

### ✅ Sistema de Responsividade
- [x] Breakpoints: Mobile(<600), Tablet(600-900), Desktop(>900)
- [x] Window resize automático
- [x] TabWidth dinâmico
- [x] Componentes adaptativos

### ✅ Componentes
- [x] Window (janela principal)
- [x] Tab (navegação com ícones)
- [x] Section (agrupador visual)
- [x] Button (com hover effects)
- [x] Toggle (switch animado)
- [x] Slider (com value label)
- [x] Dropdown (com search opcional)
- [x] Input (texto e número)
- [x] Label (texto estático)
- [x] Container (layout wrapper)
- [x] Notification (toast system)

## Uso Rápido

```lua
-- Carregar
local Library = loadstring(game:HttpGet("URL"))()

-- Criar janela
local Window = Library:CreateWindow({
    Title = "Meu Script",
    FloatingButton = { Enabled = true, Icon = "menu", Position = "BottomRight" }
})

-- Criar tab
local Tab = Window:AddTab({ Title = "Main", Icon = "home" })

-- Criar seção
local Section = Tab:AddSection("Farm")

-- Adicionar componentes
Section:AddToggle({ Title = "Auto Farm", Default = false, Callback = function(v) end })
Section:AddSlider({ Title = "Speed", Min = 0, Max = 100, Default = 50, Callback = function(v) end })
Section:AddButton({ Title = "Start", Style = "accent", Callback = function() end })
```

## Versão

**SpectrumX UI Library v3.0.0**

---

Para mais informações, consulte o `README.md`.
