--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                    SpectrumX UI Library v3.0 - Modular                   ║
    ║              Professional UI Library for Roblox Executores               ║
    ║                                                                          ║
    ║  Estrutura modular baseada em Fluent UI (dawid-scripts)                 ║
    ║  Mantendo características únicas do SpectrumX original                  ║
    ╚══════════════════════════════════════════════════════════════════════════╝
    
    Uso:
        local Library = loadstring(game:HttpGet("URL"))()
        
        local Window = Library:CreateWindow({
            Title = "Meu Script",
            Size = UDim2.fromOffset(550, 600),
            Theme = "Dark",
            FloatingButton = {
                Enabled = true,
                Icon = "settings",
                Position = "BottomRight"
            }
        })
        
        local Tab = Window:AddTab({ Title = "Main", Icon = "home" })
        local Section = Tab:AddSection("Farm")
        
        Section:AddToggle({ Title = "Auto Farm", Default = false, Callback = function(v) end })
--]]

local SpectrumX = {}
SpectrumX.__index = SpectrumX

-- ─── SERVIÇOS ─────────────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ─── MÓDULOS ──────────────────────────────────────────────────────────────────
local Themes = require(script.Themes)
local Utils = {
    Tween = require(script.Utils.Tween),
    Event = require(script.Utils.Event),
    Responsive = require(script.Utils.Responsive)
}

-- ─── ELEMENTOS ────────────────────────────────────────────────────────────────
local Elements = {
    Acrylic = require(script.Elements.Acrylic),
    TitleBar = require(script.Elements.TitleBar),
    Notification = require(script.Elements.Notification),
    FloatingButton = require(script.Elements.FloatingButton)
}

-- ─── COMPONENTES ──────────────────────────────────────────────────────────────
local Components = {
    Window = require(script.Components.Window),
    Tab = require(script.Components.Tab),
    Section = require(script.Components.Section),
    Button = require(script.Components.Button),
    Toggle = require(script.Components.Toggle),
    Slider = require(script.Components.Slider),
    Dropdown = require(script.Components.Dropdown),
    Input = require(script.Components.Input),
    Label = require(script.Components.Label),
    Container = require(script.Components.Container)
}

-- ─── CONFIGURAÇÕES GLOBAIS ────────────────────────────────────────────────────
SpectrumX.Version = "3.0.0"
SpectrumX.Theme = "Dark"
SpectrumX.Window = nil
SpectrumX.ScreenGui = nil
SpectrumX.UseAcrylic = false
SpectrumX.MinimizeKey = Enum.KeyCode.RightControl

-- ─── UTILITÁRIOS ──────────────────────────────────────────────────────────────
function SpectrumX:SafeCallback(callback, ...)
    if not callback then return end
    local success, result = pcall(callback, ...)
    if not success then
        self:Notify({
            Title = "Erro de Callback",
            Content = tostring(result),
            Duration = 5
        })
    end
    return success, result
end

function SpectrumX:GetIcon(name)
    local Icons = require(script.Icons)
    return Icons[name] or Icons["menu"]
end

-- ─── TEMA ─────────────────────────────────────────────────────────────────────
function SpectrumX:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = themeName
        Utils.Event.Trigger("ThemeChanged", themeName)
    end
end

function SpectrumX:GetTheme()
    return Themes[self.Theme] or Themes.Dark
end

-- ─── NOTIFICAÇÃO ──────────────────────────────────────────────────────────────
function SpectrumX:Notify(config)
    return Elements.Notification:New(config)
end

-- ─── CRIAR JANELA ─────────────────────────────────────────────────────────────
function SpectrumX:CreateWindow(config)
    config = config or {}
    
    if self.Window then
        warn("[SpectrumX] Apenas uma janela pode ser criada por vez!")
        return self.Window
    end
    
    -- Configurações padrão
    config.Title = config.Title or "SpectrumX"
    config.SubTitle = config.SubTitle or nil
    config.Size = config.Size or UDim2.fromOffset(550, 600)
    config.TabWidth = config.TabWidth or 160
    config.Theme = config.Theme or "Dark"
    config.Acrylic = config.Acrylic or false
    config.MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    config.FloatingButton = config.FloatingButton or { Enabled = true }
    
    -- Definir tema
    self:SetTheme(config.Theme)
    self.UseAcrylic = config.Acrylic
    self.MinimizeKey = config.MinimizeKey
    
    -- Criar ScreenGui
    local protectGui = getgenv().protectgui or (syn and syn.protect_gui) or function() end
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SpectrumX_" .. tostring(math.random(1000, 9999))
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    
    local success = pcall(function()
        self.ScreenGui.Parent = CoreGui
    end)
    if not success then
        self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    protectGui(self.ScreenGui)
    
    -- Inicializar sistema de notificações
    Elements.Notification:Init(self.ScreenGui)
    
    -- Inicializar responsividade
    Utils.Responsive:Init()
    
    -- Criar janela principal
    self.Window = Components.Window:New(config, self.ScreenGui)
    
    -- Criar botão flutuante se habilitado
    if config.FloatingButton.Enabled then
        Elements.FloatingButton:New({
            Icon = config.FloatingButton.Icon or "menu",
            Position = config.FloatingButton.Position or "BottomRight",
            Draggable = config.FloatingButton.Draggable ~= false,
            Window = self.Window
        }, self.ScreenGui)
    end
    
    return self.Window
end

-- ─── DESTRUIR ─────────────────────────────────────────────────────────────────
function SpectrumX:Destroy()
    if self.Window then
        self.Window:Destroy()
        self.Window = nil
    end
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
    Utils.Event.DisconnectAll()
end

-- ─── TOGGLE ACRYLIC ───────────────────────────────────────────────────────────
function SpectrumX:ToggleAcrylic(enabled)
    if self.UseAcrylic and self.Window then
        Elements.Acrylic:Toggle(enabled)
    end
end

-- ─── EXPORTAR ─────────────────────────────────────────────────────────────────
return SpectrumX
