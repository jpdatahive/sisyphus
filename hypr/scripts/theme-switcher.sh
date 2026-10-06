#!/usr/bin/env bash
# ==========================================================
# 1. DEFINIÇÃO DE DIRETÓRIOS E CONSTANTES
# ==========================================================
THEMES_DIR="$HOME/.config/themes"
CURRENT_THEME_FILE="$THEMES_DIR/current.theme"
KITTY_THEME_CONF="$HOME/.config/kitty/current-theme.conf"
WAYBAR_THEME_CSS="$HOME/.config/waybar/current-theme.css"
MAKO_CONF="$HOME/.config/mako/config"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
ROFI_COLORS_RASI="$HOME/.config/rofi/colors.rasi"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i preferences-desktop-theme
    fi
}

# ==========================================================
# 2. SELEÇÃO DO TEMA (CLI OU MENU ROFI COM PREVIEWS)
# ==========================================================
if [ -n "$1" ]; then
    CHOSEN_NAME="$1"
else
    # Lista as pastas disponíveis em ~/.config/themes com seus preview.png
    THEME_ITEMS=""
    while IFS= read -r dir; do
        [ -d "$dir" ] || continue
        name="${dir##*/}"
        preview="$dir/preview.png"
        if [ -f "$preview" ]; then
            THEME_ITEMS+="${name}"$'\0icon\x1f'"${preview}"$'\n'
        else
            THEME_ITEMS+="${name}"$'\n'
        fi
    done < <(find -L "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)

    if [ -z "$THEME_ITEMS" ]; then
        notify "Erro de Tema" "Nenhum tema encontrado em $THEMES_DIR"
        exit 1
    fi

    CHOSEN_NAME=$(printf "%b" "$THEME_ITEMS" | rofi -dmenu -i -p "Selecionar Tema" -theme-str 'window { width: 750px; } listview { columns: 2; lines: 6; spacing: 8px; } element { padding: 8px 12px; } element-icon { size: 48px; border-radius: 6px; }')
fi

[ -z "$CHOSEN_NAME" ] && exit 0

THEME_DIR="$THEMES_DIR/$CHOSEN_NAME"
COLORS_FILE="$THEME_DIR/colors.toml"

if [ ! -f "$COLORS_FILE" ]; then
    notify "Erro de Tema" "Arquivo colors.toml não encontrado para $CHOSEN_NAME"
    exit 1
fi

# ==========================================================
# 3. EXTRAÇÃO E PROCESSAMENTO DA PALETA DE CORES (TOML BASH PURO)
# ==========================================================
declare -A COLORS

while IFS="=" read -r key val || [[ -n "$key" ]]; do
    key="${key//[ \"$'\r'$'\t']/}"
    val="${val//[ \"$'\r'$'\t']/}"
    [[ -z "$key" || "$key" == \#* ]] && continue
    COLORS["$key"]="$val"
done < "$COLORS_FILE"

# Atribuição de padrões caso faltem chaves
BG="${COLORS[background]:-#1e1e2e}"
FG="${COLORS[foreground]:-#cdd6f4}"
ACCENT="${COLORS[accent]:-#89b4fa}"
CURSOR="${COLORS[cursor]:-#f5e0dc}"
SEL_FG="${COLORS[selection_foreground]:-$BG}"
SEL_BG="${COLORS[selection_background]:-$ACCENT}"

C0="${COLORS[color0]:-#45475a}"
C1="${COLORS[color1]:-#f38ba8}"
C2="${COLORS[color2]:-#a6e3a1}"
C3="${COLORS[color3]:-#f9e2af}"
C4="${COLORS[color4]:-#89b4fa}"
C5="${COLORS[color5]:-#f5c2e7}"
C6="${COLORS[color6]:-#94e2d5}"
C7="${COLORS[color7]:-#bac2de}"
C8="${COLORS[color8]:-#585b70}"
C9="${COLORS[color9]:-#f38ba8}"
C10="${COLORS[color10]:-#a6e3a1}"
C11="${COLORS[color11]:-#f9e2af}"
C12="${COLORS[color12]:-#89b4fa}"
C13="${COLORS[color13]:-#f5c2e7}"
C14="${COLORS[color14]:-#94e2d5}"
C15="${COLORS[color15]:-#a6adc8}"

# Versões sem # para cores com transparência
ACCENT_HEX="${ACCENT#\#}"
C5_HEX="${C5#\#}"
C0_HEX="${C0#\#}"

# ==========================================================
# 4. GERAÇÃO DOS ARQUIVOS DE CONFIGURAÇÃO (DISCO)
# ==========================================================

# 4.1 Terminal Kitty
mkdir -p "$(dirname "$KITTY_THEME_CONF")"
cat << EOF > "$KITTY_THEME_CONF"
# ==========================================================
# TEMA ATIVO DO TERMINAL (GERADO AUTOMATICAMENTE: $CHOSEN_NAME)
# ==========================================================
foreground $FG
background $BG
selection_foreground $SEL_FG
selection_background $SEL_BG

cursor $CURSOR
cursor_text_color $BG

active_border_color $ACCENT
active_tab_background $ACCENT

color0 $C0
color1 $C1
color2 $C2
color3 $C3
color4 $C4
color5 $C5
color6 $C6
color7 $C7
color8 $C8
color9 $C9
color10 $C10
color11 $C11
color12 $C12
color13 $C13
color14 $C14
color15 $C15
EOF

# 4.2 Barra Waybar
mkdir -p "$(dirname "$WAYBAR_THEME_CSS")"
cat << EOF > "$WAYBAR_THEME_CSS"
/* ==========================================================
   TEMA ATIVO DA WAYBAR (GERADO DINAMICAMENTE: $CHOSEN_NAME)
   ========================================================== */
@define-color base      $BG;
@define-color mantle    $C0;
@define-color crust     $BG;
@define-color text      $FG;
@define-color subtext0  $C15;
@define-color overlay0  $C8;
@define-color surface0  $C0;

@define-color blue      $C4;
@define-color lavender  $ACCENT;
@define-color sapphire  $C12;
@define-color sky       $C6;
@define-color teal      $C14;
@define-color green     $C2;
@define-color yellow    $C3;
@define-color peach     $C11;
@define-color maroon    $C9;
@define-color red       $C1;
@define-color mauve     $C5;
EOF

# 4.3 Notificações Mako
mkdir -p "$(dirname "$MAKO_CONF")"
cat << EOF > "$MAKO_CONF"
# ==========================================================
# 1. TEMA E APARÊNCIA DE NOTIFICAÇÕES (MAKO: $CHOSEN_NAME)
# ==========================================================
font=JetBrainsMono Nerd Font 10
background-color=${BG}EE
text-color=$FG
border-color=$ACCENT
border-size=2
border-radius=8
default-timeout=5000

# ==========================================================
# 2. ESPAÇAMENTO E GEOMETRIA
# ==========================================================
width=360
height=120
margin=14
padding=12
icons=1
max-icon-size=48

# ==========================================================
# 3. COMPORTAMENTO E CRITICIDADE
# ==========================================================
[urgency=low]
border-color=$C8
default-timeout=3000

[urgency=normal]
border-color=$ACCENT
default-timeout=5000

[urgency=critical]
border-color=$C1
text-color=$C1
default-timeout=0
EOF

# 4.4 Lançador Rofi
mkdir -p "$(dirname "$ROFI_COLORS_RASI")"
cat << EOF > "$ROFI_COLORS_RASI"
/**
 * CORES DINÂMICAS DO ROFI (GERADO AUTOMATICAMENTE: $CHOSEN_NAME)
 **/

* {
    background:     ${BG}EE;
    background-alt: ${C0}FF;
    foreground:     ${FG}FF;
    selected:       ${ACCENT}FF;
    active:         ${C2}FF;
    urgent:         ${C1}FF;
}
EOF

# 4.5 Wallpaper (Hyprpaper)
WALLPAPER=$(find "$THEME_DIR/backgrounds" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) 2>/dev/null | sort | head -n 1)

if [ -n "$WALLPAPER" ]; then
    mkdir -p "$(dirname "$HYPRPAPER_CONF")"
    cat << EOF > "$HYPRPAPER_CONF"
wallpaper {
    monitor = 
    path = $WALLPAPER
    fit_mode = cover
}
splash = false
EOF
    echo "$WALLPAPER" > "$THEMES_DIR/current.wallpaper"
fi

# 4.6 Persistência do Tema Ativo
mkdir -p "$(dirname "$CURRENT_THEME_FILE")"
echo "$CHOSEN_NAME" > "$CURRENT_THEME_FILE"

# ==========================================================
# 5. RECARGA DOS COMPONENTES EM PARALELO (INSTANTÂNEO)
# ==========================================================

# Kitty (SIGUSR1 recarrega configurações sem reiniciar - cobre wrapper NixOS)
(pkill -USR1 -x kitty 2>/dev/null; pkill -USR1 -x .kitty-wrapped 2>/dev/null) &

# Waybar (SIGUSR2 recarrega folhas de estilo CSS - cobre wrapper NixOS)
(pkill -USR2 -x waybar 2>/dev/null; pkill -USR2 -x .waybar-wrapped 2>/dev/null) &

# Mako
makoctl reload 2>/dev/null &

# Bordas do Hyprland via Lua IPC eval (obrigatório com backend Lua no Hyprland 0.55+)
if command -v hyprctl >/dev/null 2>&1; then
    hyprctl eval "hl.config({ general = { col = { active_border = { colors = {'rgba(${ACCENT_HEX}ee)', 'rgba(${C5_HEX}ee)'}, angle = 45 }, inactive_border = 'rgba(${C0_HEX}aa)' } } })" >/dev/null 2>&1 &
fi

# Wallpaper via hyprpaper IPC (sem matar ou reiniciar processo se já estiver rodando)
if [ -n "$WALLPAPER" ]; then
    if pgrep -x hyprpaper >/dev/null 2>&1; then
        hyprctl hyprpaper wallpaper ",$WALLPAPER,cover" >/dev/null 2>&1 &
    else
        hyprpaper >/dev/null 2>&1 &
    fi
fi

# Integração GNOME / GTK (Modo Claro/Escuro e Ícones do Tema)
if command -v gsettings >/dev/null 2>&1; then
    if [ -f "$THEME_DIR/light.mode" ]; then
        gsettings set org.gnome.desktop.interface color-scheme "prefer-light" 2>/dev/null &
        gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" 2>/dev/null &
    else
        gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null &
        gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" 2>/dev/null &
    fi

    if [ -f "$THEME_DIR/icons.theme" ]; then
        ICON_THEME=$(head -n 1 "$THEME_DIR/icons.theme")
        [ -n "$ICON_THEME" ] && gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null &
    fi
fi

# Teclado ASUS ROG (se compatível via asusd / asusctl)
if command -v asusctl >/dev/null 2>&1; then
    if [ -f "$THEME_DIR/keyboard.rgb" ]; then
        KB_RGB=$(sed 's/^#//' "$THEME_DIR/keyboard.rgb")
        asusctl aura effect static -c "$KB_RGB" >/dev/null 2>&1 &
    else
        asusctl aura effect static -c "$ACCENT_HEX" >/dev/null 2>&1 &
    fi
fi

# Aguarda a conclusão dos comandos de recarga disparados em paralelo
wait

notify "Tema Aplicado" "Paleta e papéis de parede atualizados para: $CHOSEN_NAME"
