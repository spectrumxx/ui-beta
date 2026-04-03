--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                    SpectrumX UI Library - Example                        ║
    ║                    Exemplo completo de uso                               ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

-- Carregar a library (substitua pela URL real quando hospedar)
local Library = loadstring(readfile("SpectrumXUILibrary/src/init.lua"))()
-- local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/seu-usuario/SpectrumXUILibrary/main/src/init.lua"))()

-- ═══════════════════════════════════════════════════════════════════════════
-- CRIAR JANELA PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════════════

local Window = Library:CreateWindow({
    Title = "SpectrumX Example",
    SubTitle = "v3.0.0",
    Size = UDim2.fromOffset(550, 600),
    TabWidth = 160,
    Theme = "Dark",
    Acrylic = false, -- Desative se tiver problemas de performance
    MinimizeKey = Enum.KeyCode.RightControl,
    FloatingButton = {
        Enabled = true,
        Icon = "menu",
        Position = "BottomRight",
        Draggable = true
    }
})

-- ═══════════════════════════════════════════════════════════════════════════
-- TAB: MAIN
-- ═══════════════════════════════════════════════════════════════════════════

local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "home"
})

-- Seção de Boas-vindas
local WelcomeSection = MainTab:AddSection("Bem-vindo")

WelcomeSection:AddLabel({
    Text = "SpectrumX UI Library",
    Style = "title",
    Alignment = "Center"
})

WelcomeSection:AddLabel({
    Text = "Uma library moderna e responsiva para Roblox",
    Style = "muted",
    Alignment = "Center"
})

WelcomeSection:AddLabel({
    Text = "",
    Style = "default"
})

-- Seção de Informações
local InfoSection = MainTab:AddSection("Informações")

InfoSection:AddLabel({
    Text = "Versão: 3.0.0",
    Style = "default"
})

InfoSection:AddLabel({
    Text = "Tema: Dark/Black Gradiente",
    Style = "default"
})

InfoSection:AddLabel({
    Text = "Breakpoint: " .. (Library.Utils.Responsive.IsMobile and "Mobile" or 
                              Library.Utils.Responsive.IsTablet and "Tablet" or "Desktop"),
    Style = "accent"
})

-- ═══════════════════════════════════════════════════════════════════════════
-- TAB: COMPONENTS
-- ═══════════════════════════════════════════════════════════════════════════

local ComponentsTab = Window:AddTab({
    Title = "Components",
    Icon = "grid"
})

-- Seção de Botões
local ButtonSection = ComponentsTab:AddSection("Buttons")

ButtonSection:AddButton({
    Title = "Default Button",
    Style = "default",
    Callback = function()
        Library:Notify({
            Title = "Button Clicked",
            Content = "Você clicou no botão padrão!",
            Type = "Info"
        })
    end
})

ButtonSection:AddButton({
    Title = "Accent Button",
    Style = "accent",
    Callback = function()
        Library:Notify({
            Title = "Accent Button",
            Content = "Botão de destaque clicado!",
            Type = "Success"
        })
    end
})

ButtonSection:AddButton({
    Title = "Outline Button",
    Style = "outline",
    Callback = function()
        print("Outline button clicked!")
    end
})

ButtonSection:AddButton({
    Title = "Danger Button",
    Style = "danger",
    Callback = function()
        Library:Notify({
            Title = "Cuidado!",
            Content = "Você clicou no botão de perigo!",
            Type = "Warning"
        })
    end
})

-- Seção de Toggles
local ToggleSection = ComponentsTab:AddSection("Toggles")

ToggleSection:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        _G.AutoFarm = value
        Library:Notify({
            Title = "Auto Farm",
            Content = value and "Ativado!" or "Desativado!",
            Type = value and "Success" or "Info"
        })
    end
})

ToggleSection:AddToggle({
    Title = "Anti-AFK",
    Default = true,
    Callback = function(value)
        _G.AntiAFK = value
        print("Anti-AFK:", value)
    end
})

ToggleSection:AddToggle({
    Title = "Auto Save",
    Default = false,
    Callback = function(value)
        _G.AutoSave = value
        print("Auto Save:", value)
    end
})

-- Seção de Sliders
local SliderSection = ComponentsTab:AddSection("Sliders")

SliderSection:AddSlider({
    Title = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Suffix = " studs",
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

SliderSection:AddSlider({
    Title = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Suffix = " power",
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
})

SliderSection:AddSlider({
    Title = "Farm Delay",
    Min = 0.1,
    Max = 5,
    Default = 1,
    Decimals = 1,
    Suffix = "s",
    Callback = function(value)
        _G.FarmDelay = value
    end
})

-- ═══════════════════════════════════════════════════════════════════════════
-- TAB: DROPDOWNS & INPUTS
-- ═══════════════════════════════════════════════════════════════════════════

local InputTab = Window:AddTab({
    Title = "Inputs",
    Icon = "input"
})

-- Seção de Dropdowns
local DropdownSection = InputTab:AddSection("Dropdowns")

DropdownSection:AddDropdown({
    Title = "Select Weapon",
    Options = {"Sword", "Axe", "Bow", "Staff", "Dagger"},
    Default = "Sword",
    Callback = function(value)
        _G.SelectedWeapon = value
        Library:Notify({
            Title = "Weapon Selected",
            Content = "Arma selecionada: " .. value,
            Type = "Info"
        })
    end
})

DropdownSection:AddDropdown({
    Title = "Select Location (Searchable)",
    Options = {
        "Forest", "Desert", "Mountain", "Ocean", "Cave",
        "Castle", "Village", "City", "Dungeon", "Sky Island"
    },
    Default = "Forest",
    Searchable = true,
    Callback = function(value)
        _G.SelectedLocation = value
        print("Location:", value)
    end
})

-- Seção de Inputs
local InputSection = InputTab:AddSection("Text Inputs")

InputSection:AddInput({
    Title = "Player Name",
    Default = "",
    Placeholder = "Digite o nome do jogador...",
    Callback = function(value)
        _G.TargetPlayer = value
    end
})

InputSection:AddInput({
    Title = "Amount",
    Default = "100",
    Placeholder = "Quantidade...",
    Numeric = true,
    Min = 1,
    Max = 10000,
    Callback = function(value)
        _G.Amount = value
    end
})

-- ═══════════════════════════════════════════════════════════════════════════
-- TAB: SETTINGS
-- ═══════════════════════════════════════════════════════════════════════════

local SettingsTab = Window:AddTab({
    Title = "Settings",
    Icon = "settings"
})

-- Seção de Tema
local ThemeSection = SettingsTab:AddSection("Theme")

ThemeSection:AddLabel({
    Text = "Cores de Destaque",
    Style = "subtitle"
})

ThemeSection:AddButton({
    Title = "Roxo (Padrão)",
    Style = "accent",
    Callback = function()
        Library:GetTheme():SetAccentColor("purple")
        Library:Notify({
            Title = "Theme",
            Content = "Cor de destaque alterada para Roxo!",
            Type = "Success"
        })
    end
})

ThemeSection:AddButton({
    Title = "Azul",
    Style = "accent",
    Callback = function()
        Library:GetTheme():SetAccentColor("blue")
        Library:Notify({
            Title = "Theme",
            Content = "Cor de destaque alterada para Azul!",
            Type = "Success"
        })
    end
})

ThemeSection:AddButton({
    Title = "Vermelho",
    Style = "accent",
    Callback = function()
        Library:GetTheme():SetAccentColor("red")
        Library:Notify({
            Title = "Theme",
            Content = "Cor de destaque alterada para Vermelho!",
            Type = "Success"
        })
    end
})

ThemeSection:AddButton({
    Title = "Verde",
    Style = "accent",
    Callback = function()
        Library:GetTheme():SetAccentColor("green")
        Library:Notify({
            Title = "Theme",
            Content = "Cor de destaque alterada para Verde!",
            Type = "Success"
        })
    end
})

-- Seção de Janela
local WindowSection = SettingsTab:AddSection("Window")

WindowSection:AddToggle({
    Title = "Acrylic Effect",
    Default = false,
    Callback = function(value)
        Library:ToggleAcrylic(value)
    end
})

WindowSection:AddButton({
    Title = "Minimize Window",
    Style = "outline",
    Callback = function()
        Window:Minimize()
    end
})

WindowSection:AddButton({
    Title = "Test Notification",
    Style = "default",
    Callback = function()
        Library:Notify({
            Title = "Test",
            Content = "Esta é uma notificação de teste!",
            SubContent = "Você pode adicionar mais detalhes aqui.",
            Duration = 5,
            Type = "Info"
        })
    end
})

WindowSection:AddButton({
    Title = "Success Notification",
    Style = "success",
    Callback = function()
        Library:Notify({
            Title = "Sucesso!",
            Content = "Operação concluída com sucesso!",
            Duration = 3,
            Type = "Success"
        })
    end
})

WindowSection:AddButton({
    Title = "Warning Notification",
    Style = "outline",
    Callback = function()
        Library:Notify({
            Title = "Atenção!",
            Content = "Isso é um aviso!",
            Duration = 3,
            Type = "Warning"
        })
    end
})

WindowSection:AddButton({
    Title = "Error Notification",
    Style = "danger",
    Callback = function()
        Library:Notify({
            Title = "Erro!",
            Content = "Algo deu errado!",
            Duration = 3,
            Type = "Error"
        })
    end
})

-- ═══════════════════════════════════════════════════════════════════════════
-- NOTIFICAÇÃO INICIAL
-- ═══════════════════════════════════════════════════════════════════════════

Library:Notify({
    Title = "SpectrumX UI Library",
    Content = "Library carregada com sucesso!",
    SubContent = "Pressione RightControl para minimizar",
    Duration = 5,
    Type = "Success"
})

print("[SpectrumX] Example script loaded successfully!")
print("[SpectrumX] Press RightControl to toggle the UI")
