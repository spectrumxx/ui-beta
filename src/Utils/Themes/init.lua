--[[
    SpectrumX Themes Module
    Gerenciamento de temas da UI Library
--]]

local Themes = {}

-- Carregar tema Dark
Themes.Dark = require(script.Dark)

-- Lista de temas disponíveis
Themes.Names = { "Dark" }

-- Tema atual
Themes.Current = "Dark"

-- ─── OBTER TEMA ATUAL ─────────────────────────────────────────────────────────
function Themes:GetCurrent()
    return self[self.Current] or self.Dark
end

-- ─── DEFINIR TEMA ─────────────────────────────────────────────────────────────
function Themes:SetTheme(name)
    if self[name] then
        self.Current = name
        return true
    end
    return false
end

-- ─── VERIFICAR SE TEMA EXISTE ─────────────────────────────────────────────────
function Themes:Exists(name)
    return self[name] ~= nil
end

return Themes
