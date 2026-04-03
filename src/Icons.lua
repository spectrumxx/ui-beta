--[[
    SpectrumX Icons
    Biblioteca de ícones para a UI Library
    
    Ícones são representados como strings (emojis) ou Asset IDs
--]]

local Icons = {}

-- ─── ÍCONES DE NAVEGAÇÃO ──────────────────────────────────────────────────────
Icons.home = "🏠"
Icons.menu = "☰"
Icons.settings = "⚙️"
Icons.user = "👤"
Icons.search = "🔍"
Icons.back = "◀"
Icons.forward = "▶"
Icons.close = "✕"
Icons.add = "+"
Icons.remove = "−"
Icons.edit = "✎"
Icons.delete = "🗑"
Icons.more = "⋯"
Icons.expand = "▼"
Icons.collapse = "▲"

-- ─── ÍCONES DE AÇÃO ───────────────────────────────────────────────────────────
Icons.play = "▶"
Icons.pause = "⏸"
Icons.stop = "⏹"
Icons.refresh = "↻"
Icons.save = "💾"
Icons.download = "⬇"
Icons.upload = "⬆"
Icons.share = "↗"
Icons.copy = "📋"
Icons.cut = "✂"
Icons.paste = "📋"
Icons.undo = "↶"
Icons.redo = "↷"

-- ─── ÍCONES DE ESTADO ─────────────────────────────────────────────────────────
Icons.check = "✓"
Icons.checkCircle = "✓"
Icons.cross = "✕"
Icons.warning = "⚠"
Icons.info = "ℹ"
Icons.help = "?"
Icons.success = "✓"
Icons.error = "✕"
Icons.loading = "◌"
Icons.star = "★"
Icons.starEmpty = "☆"
Icons.heart = "♥"
Icons.heartEmpty = "♡"

-- ─── ÍCONES DE JOGO ───────────────────────────────────────────────────────────
Icons.sword = "⚔"
Icons.shield = "🛡"
Icons.heartGame = "❤"
Icons.mana = "💧"
Icons.coin = "🪙"
Icons.gem = "💎"
Icons.chest = "📦"
Icons.key = "🔑"
Icons.map = "🗺"
Icons.flag = "🚩"
Icons.trophy = "🏆"
Icons.medal = "🎖"

-- ─── ÍCONES DE FERRAMENTAS ────────────────────────────────────────────────────
Icons.hammer = "🔨"
Icons.wrench = "🔧"
Icons.gear = "⚙"
Icons.code = "</>"
Icons.terminal = ">_"
Icons.bug = "🐛"
Icons.database = "🗄"
Icons.server = "🖥"
Icons.cloud = "☁"
Icons.wifi = "📶"
Icons.bluetooth = "🔷"
Icons.battery = "🔋"
Icons.power = "⏻"

-- ─── ÍCONES DE ARQUIVO ────────────────────────────────────────────────────────
Icons.file = "📄"
Icons.folder = "📁"
Icons.image = "🖼"
Icons.video = "🎬"
Icons.music = "🎵"
Icons.document = "📃"
Icons.pdf = "📕"
Icons.zip = "🗜"
Icons.codeFile = "📜"

-- ─── ÍCONES DE COMUNICAÇÃO ────────────────────────────────────────────────────
Icons.message = "💬"
Icons.chat = "🗨"
Icons.email = "✉"
Icons.phone = "📞"
Icons.notification = "🔔"
Icons.bell = "🔔"
Icons.bellMute = "🔕"
Icons.send = "📤"
Icons.receive = "📥"

-- ─── ÍCONES DE TEMPO ──────────────────────────────────────────────────────────
Icons.clock = "🕐"
Icons.calendar = "📅"
Icons.timer = "⏱"
Icons.stopwatch = "⏱"
Icons.hourglass = "⏳"
Icons.sun = "☀"
Icons.moon = "🌙"
Icons.starTime = "⭐"

-- ─── ÍCONES DE SEGURANÇA ──────────────────────────────────────────────────────
Icons.lock = "🔒"
Icons.unlock = "🔓"
Icons.keySecurity = "🔑"
Icons.eye = "👁"
Icons.eyeClosed = "🙈"
Icons.fingerprint = "👆"

-- ─── ÍCONES DE CONFIGURAÇÃO ───────────────────────────────────────────────────
Icons.slider = "⬌"
Icons.toggle = "⭘"
Icons.dropdown = "▾"
Icons.input = "⌨"
Icons.color = "🎨"
Icons.theme = "🎭"
Icons.language = "🌐"
Icons.sound = "🔊"
Icons.mute = "🔇"

-- ─── ÍCONES ESPECÍFICOS ROBLOX ────────────────────────────────────────────────
Icons.roblox = "🎮"
Icons.avatar = "👤"
Icons.inventory = "🎒"
Icons.friends = "👥"
Icons.group = "👨‍👩‍👧‍👦"
Icons.catalog = "🛍"
Icons.build = "🏗"
Icons.script = "📜"
Icons.tool = "🔧"
Icons.vehicle = "🚗"
Icons.hat = "🎩"
Icons.shirt = "👕"
Icons.pants = "👖"
Icons.face = "😊"

-- ─── ÍCONES DE FARM/SCRIPT ────────────────────────────────────────────────────
Icons.auto = "🤖"
Icons.farm = "🌾"
Icons.money = "💰"
Icons.cash = "💵"
Icons.bank = "🏦"
Icons.trade = "🤝"
Icons.shop = "🛒"
Icons.quest = "📜"
Icons.mission = "🎯"
Icons.achievement = "🏅"
Icons.level = "📈"
Icons.xp = "✨"
Icons.skill = "⚡"
Icons.stats = "📊"
Icons.leaderboard = "🏆"

-- ─── FUNÇÃO PARA OBTER ÍCONE ──────────────────────────────────────────────────
function Icons:Get(name)
    return self[name] or self.menu
end

-- ─── VERIFICAR SE ÍCONE EXISTE ────────────────────────────────────────────────
function Icons:Exists(name)
    return self[name] ~= nil
end

-- ─── ADICIONAR ÍCONE CUSTOMIZADO ──────────────────────────────────────────────
function Icons:Add(name, value)
    self[name] = value
end

return Icons
