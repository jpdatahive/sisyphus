-- ==========================================================
-- HYPRLAND CONFIGURATION (LUA) - COM RECURSOS OMARCHY 3
-- ==========================================================

-- ==========================================================
-- 1. MONITORES
-- ==========================================================
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- ==========================================================
-- 2. PROGRAMAS PADRÃO
-- ==========================================================
local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "rofi -show drun"

-- ==========================================================
-- 3. INICIALIZAÇÃO AUTOMÁTICA (AUTOSTART)
-- ==========================================================
hl.on("hyprland.start", function () 
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("mako & waybar & hyprpaper & firefox")
end)

-- ==========================================================
-- 4. VARIÁVEIS DE AMBIENTE
-- ==========================================================
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ==========================================================
-- 5. APARÊNCIA, BORDAS E DECORAÇÃO (TEMA CATPPUCCIN MOCHA)
-- ==========================================================
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 15,
        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(89b4faee)", "rgba(cba6f7ee)"}, angle = 45 },
            inactive_border = "rgba(313244aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow = {
            enabled      = true,
            range        = 6,
            render_power = 3,
            color        = 0x66000000,
        },

        blur = {
            enabled   = true,
            size      = 4,
            passes    = 2,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- ==========================================================
-- 6. ANIMAÇÕES (CURVAS BEZIER E TRANSIÇÕES)
-- ==========================================================
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- ==========================================================
-- 7. LAYOUTS (DWINDLE / MASTER)
-- ==========================================================
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

-- ==========================================================
-- 8. CONFIGURAÇÕES DIVERSAS (MISC)
-- ==========================================================
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

-- ==========================================================
-- 9. ENTRADA (TECLADO BR ABNT2, MOUSE E TOUCHPAD)
-- ==========================================================
hl.config({
    input = {
        kb_layout    = "br",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace"
})

-- ==========================================================
-- 10. ATALHOS DO TECLADO (KEYBINDINGS)
-- ==========================================================
local mainMod = "SUPER"

-- ----------------------------------------------------------
-- 10.1 APLICATIVOS BÁSICOS
-- ----------------------------------------------------------
-- Terminal Kitty: Super + Enter
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

-- Menu de Aplicativos Rofi: Super + Space
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))

-- Gerenciador de Arquivos: Super + E
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- Guia de Atalhos Interativo (Rofi): Super + K
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("/home/jp/.config/hypr/scripts/keybindings-menu.sh"))

-- Alternador de Temas e Wallpapers: Super + Ctrl + Space
hl.bind(mainMod .. " + CONTROL + SPACE", hl.dsp.exec_cmd("/home/jp/.config/hypr/scripts/theme-switcher.sh"))

-- ----------------------------------------------------------
-- 10.2 CONTROLE DE JANELAS E TILING AVANÇADO
-- ----------------------------------------------------------
-- Fechar Janela Ativa: Super + W
hl.bind(mainMod .. " + W", hl.dsp.window.close())

-- Alternar Janela Flutuante: Super + V
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Alternar modo Pseudo-tiling: Super + P
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Alternar divisão (Dwindle split): Super + J
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Agrupar Janelas em Abas (Estilo Omarchy): Super + G
hl.bind(mainMod .. " + G", hl.dsp.layout("togglegroup"))

-- Navegar entre Abas de um Grupo: Super + Alt + Tab
hl.bind(mainMod .. " + ALT + Tab", hl.dsp.layout("changegroupactive"))

-- Ocultar / Exibir Barra Waybar: Super + Shift + Space
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar || waybar &"))

-- Sair / Desligar: Super + M
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- ----------------------------------------------------------
-- 10.3 CAPTURAS DE TELA, GRAVAÇÃO E OCR (OMARCHY 3)
-- ----------------------------------------------------------
-- Screenshot Interativo (Editor Satty com setas/corte/blur): Super + Ctrl + S
hl.bind(mainMod .. " + CONTROL + S", hl.dsp.exec_cmd("/home/jp/.config/hypr/scripts/screenshot.sh interactive"))

-- Screenshot Rápido (Tela Cheia direta para a pasta): Tecla Print
hl.bind("Print", hl.dsp.exec_cmd("/home/jp/.config/hypr/scripts/screenshot.sh full"))

-- Extração de Texto da Tela (OCR via Tesseract): Super + Shift + T
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("/home/jp/.config/hypr/scripts/ocr-extract.sh"))

-- Gravação de Tela (Iniciar / Parar com indicador no Waybar): Super + Alt + Print
hl.bind(mainMod .. " + ALT + Print", hl.dsp.exec_cmd("/home/jp/.config/hypr/scripts/screenshot.sh record-toggle"))

-- ----------------------------------------------------------
-- 10.4 CONTROLE DE NOTIFICAÇÕES (MAKO)
-- ----------------------------------------------------------
-- Fechar notificação mais recente: Super + ,
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("makoctl dismiss"))

-- Fechar todas as notificações: Super + Shift + ,
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.exec_cmd("makoctl dismiss --all"))

-- Alternar modo Não Perturbe: Super + Ctrl + ,
hl.bind(mainMod .. " + CONTROL + comma", hl.dsp.exec_cmd("makoctl mode -t do-not-disturb"))

-- ----------------------------------------------------------
-- 10.5 FOCO E TROCA (SWAP) DE JANELAS
-- ----------------------------------------------------------
-- Mudar Foco com Super + Setas
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Trocar posição da janela com a vizinha (Swap): Super + Shift + Setas
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

-- ----------------------------------------------------------
-- 10.6 ÁREAS DE TRABALHO (WORKSPACES 1 A 5)
-- ----------------------------------------------------------
for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i }))
end

-- Workspace especial (Scratchpad): Super + S
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Navegação de workspaces pela rolagem do mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Mover / Redimensionar janelas arrastando com o mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ----------------------------------------------------------
-- 10.7 TECLAS MULTIMÍDIA, BRILHO E TROCA DE SAÍDA DE ÁUDIO
-- ----------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Troca rápida de saída de áudio (Fone / Caixa / HDMI): Super + Mute
hl.bind(mainMod .. " + XF86AudioMute", hl.dsp.exec_cmd("/home/jp/.config/hypr/scripts/audio-switch.sh"))

hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Controle de Mídia (playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- ==========================================================
-- 11. REGRAS DE JANELAS (WINDOW RULES)
-- ==========================================================
local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Janelas flutuantes automáticas para utilitários
hl.window_rule({
    name  = "float-bluetui",
    match = { class = "bluetui" },
    float = true,
})

hl.window_rule({
    name  = "float-impala",
    match = { class = "impala" },
    float = true,
})
