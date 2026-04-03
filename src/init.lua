--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                    SpectrumX UI Library v3.0 - Modular                   ║
    ║              Professional UI Library for Roblox Executors                ║
    ║                                                                          ║
    ║  Estrutura modular baseada em Fluent UI (dawid-scripts)                 ║
    ║  Mantendo características únicas do SpectrumX original                  ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

local SpectrumX = {}
SpectrumX.__index = SpectrumX

-- ─── SERVIÇOS ─────────────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ─── BASE DO REPOSITÓRIO ──────────────────────────────────────────────────────
local BASE = "https://raw.githubusercontent.com/spectrumxx/ui-beta/main/src/"

local function Load(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BASE .. path))()
    end)

    if not success then
        error("[SpectrumX] Falha ao carregar módulo: " .. tostring(path) .. "\nErro: " .. tostring(result))
    end

    return result
end

-- ─── MÓDULOS ──────────────────────────────────────────────────────────────────
local Themes = Load("Themes/init.lua")
local Icons = Load("Icons.lua")
local Utils = Load("Utils/init.lua")
local Elements = Load("Elements/init.lua")
local Components = Load("Components/init.lua")

-- ─── CONFIGURAÇÕES GLOBAIS ────────────────────────────────────────────────────
SpectrumX.Version = "3.0.0"
SpectrumX.Theme = "Dark"
SpectrumX.Window = nil
SpectrumX.ScreenGui = nil
SpectrumX.UseAcrylic = false
SpectrumX.MinimizeKey = Enum.KeyCode.RightControl

SpectrumX.Themes = Themes
SpectrumX.Icons = Icons
SpectrumX.Utils = Utils
SpectrumX.Elements = Elements
SpectrumX.Components = Components

-- ─── UTILITÁRIOS ──────────────────────────────────────────────────────────────
function SpectrumX:SafeCallback(callback, ...)
    if not callback then
        return
    end

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
    return Icons[name] or Icons["menu"]
end

-- ─── TEMA ─────────────────────────────────────────────────────────────────────
function SpectrumX:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = themeName

        if Utils.Event and Utils.Event.Trigger then
            Utils.Event.Trigger("ThemeChanged", themeName)
        end

        return true
    end

    warn("[SpectrumX] Tema não encontrado: " .. tostring(themeName))
    return false
end

function SpectrumX:GetTheme()
    return Themes[self.Theme] or Themes.Dark
end

function SpectrumX:GetThemes()
    return Themes.Names or { "Dark" }
end

-- ─── NOTIFICAÇÃO ──────────────────────────────────────────────────────────────
function SpectrumX:Notify(config)
    if Elements.Notification and Elements.Notification.New then
        return Elements.Notification:New(config)
    end

    warn("[SpectrumX] Sistema de notificações não disponível.")
end

-- ─── CRIAR JANELA ─────────────────────────────────────────────────────────────
function SpectrumX:CreateWindow(config)
    config = config or {}

    if self.Window then
        warn("[SpectrumX] Apenas uma janela pode ser criada por vez!")
        return self.Window
    end

    config.Title = config.Title or "SpectrumX"
    config.SubTitle = config.SubTitle or nil
    config.Size = config.Size or UDim2.fromOffset(550, 600)
    config.TabWidth = config.TabWidth or 160
    config.Theme = config.Theme or "Dark"
    config.Acrylic = config.Acrylic or false
    config.MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    config.FloatingButton = config.FloatingButton or { Enabled = true }

    self:SetTheme(config.Theme)
    self.UseAcrylic = config.Acrylic
    self.MinimizeKey = config.MinimizeKey

    local protectGui = (getgenv and getgenv().protectgui)
        or (syn and syn.protect_gui)
        or function() end

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

    if Elements.Notification and Elements.Notification.Init then
        Elements.Notification:Init(self.ScreenGui)
    end

    if Utils.Responsive and Utils.Responsive.Init then
        Utils.Responsive:Init()
    end

    if not (Components.Window and Components.Window.New) then
        error("[SpectrumX] Components.Window:New não encontrado.")
    end

    self.Window = Components.Window:New(config, self.ScreenGui)

    if config.FloatingButton.Enabled and Elements.FloatingButton and Elements.FloatingButton.New then
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
    if self.Window and self.Window.Destroy then
        pcall(function()
            self.Window:Destroy()
        end)
        self.Window = nil
    end

    if self.ScreenGui then
        pcall(function()
            self.ScreenGui:Destroy()
        end)
        self.ScreenGui = nil
    end

    if Utils.Event and Utils.Event.DisconnectAll then
        Utils.Event.DisconnectAll()
    end
end

-- ─── TOGGLE ACRYLIC ───────────────────────────────────────────────────────────
function SpectrumX:ToggleAcrylic(enabled)
    if self.Window and Elements.Acrylic and Elements.Acrylic.Toggle then
        Elements.Acrylic:Toggle(enabled)
    end
end

return SpectrumX
