#!/usr/bin/env bash
# ==========================================================
# SELETOR E ALTERNADOR DE PAPÉIS DE PAREDE (HYPRPAPER)
# ==========================================================

THEMES_DIR="$HOME/.config/themes"
CURRENT_THEME_FILE="$THEMES_DIR/current.theme"
CURRENT_WALLPAPER_FILE="$THEMES_DIR/current.wallpaper"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i preferences-desktop-wallpaper
    fi
}

# 1. Identifica o tema atual
if [ -f "$CURRENT_THEME_FILE" ]; then
    CURRENT_THEME=$(head -n 1 "$CURRENT_THEME_FILE")
else
    CURRENT_THEME="catppuccin"
fi

THEME_BG_DIR="$THEMES_DIR/$CURRENT_THEME/backgrounds"

if [ ! -d "$THEME_BG_DIR" ]; then
    notify "Papel de Parede" "Pasta de wallpapers não encontrada para o tema: $CURRENT_THEME"
    exit 1
fi

# 2. Coleta lista de wallpapers disponíveis
mapfile -t WALLPAPERS < <(find -L "$THEME_BG_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) 2>/dev/null | sort)

TOTAL=${#WALLPAPERS[@]}
if [ "$TOTAL" -eq 0 ]; then
    notify "Papel de Parede" "Nenhum papel de parede encontrado para $CURRENT_THEME"
    exit 1
fi

# Função para aplicar o wallpaper selecionado via IPC instantâneo
apply_wallpaper() {
    local target="$1"
    [ ! -f "$target" ] && return 1

    mkdir -p "$(dirname "$HYPRPAPER_CONF")"
    cat << EOF > "$HYPRPAPER_CONF"
wallpaper {
    monitor = 
    path = $target
    fit_mode = cover
}
splash = false
EOF

    # Aplicação via IPC sem reiniciar o daemon se já estiver ativo
    if pgrep -x hyprpaper >/dev/null 2>&1; then
        hyprctl hyprpaper wallpaper ",$target,cover" >/dev/null 2>&1 &
    else
        hyprpaper >/dev/null 2>&1 &
    fi

    mkdir -p "$(dirname "$CURRENT_WALLPAPER_FILE")"
    echo "$target" > "$CURRENT_WALLPAPER_FILE"

    local base_name
    base_name=$(basename "$target")
    notify "Papel de Parede Atualizado" "$CURRENT_THEME :: $base_name"
}

# 3. Modos de execução
case "$1" in
    next)
        CURRENT_WP=""
        [ -f "$CURRENT_WALLPAPER_FILE" ] && CURRENT_WP=$(head -n 1 "$CURRENT_WALLPAPER_FILE")

        NEXT_INDEX=0
        for i in "${!WALLPAPERS[@]}"; do
            if [ "${WALLPAPERS[$i]}" = "$CURRENT_WP" ]; then
                NEXT_INDEX=$(( (i + 1) % TOTAL ))
                break
            fi
        done
        apply_wallpaper "${WALLPAPERS[$NEXT_INDEX]}"
        ;;

    prev)
        CURRENT_WP=""
        [ -f "$CURRENT_WALLPAPER_FILE" ] && CURRENT_WP=$(head -n 1 "$CURRENT_WALLPAPER_FILE")

        PREV_INDEX=0
        for i in "${!WALLPAPERS[@]}"; do
            if [ "${WALLPAPERS[$i]}" = "$CURRENT_WP" ]; then
                PREV_INDEX=$(( (i - 1 + TOTAL) % TOTAL ))
                break
            fi
        done
        apply_wallpaper "${WALLPAPERS[$PREV_INDEX]}"
        ;;

    set)
        if [ -n "$2" ] && [ -f "$2" ]; then
            apply_wallpaper "$2"
        fi
        ;;

    *)
        # Modo Interativo via Rofi
        DISPLAY_ITEMS=""
        for wp in "${WALLPAPERS[@]}"; do
            bname="${wp##*/}"
            no_ext="${bname%.*}"
            clean_name="${no_ext#[0-9][0-9][-_]}"
            clean_name="${clean_name#[0-9][-_]}"
            clean_name="${clean_name//[-_]/ }"
            DISPLAY_ITEMS+="$bname  (${clean_name^})"$'\n'
        done

        SELECTED=$(printf "%s" "$DISPLAY_ITEMS" | sed '/^$/d' | rofi -dmenu -i -p "Wallpapers ($CURRENT_THEME)" -theme-str 'window { width: 550px; }')
        
        [ -z "$SELECTED" ] && exit 0

        SELECTED_FILE=$(awk '{print $1}' <<< "$SELECTED")
        TARGET_PATH="$THEME_BG_DIR/$SELECTED_FILE"

        if [ -f "$TARGET_PATH" ]; then
            apply_wallpaper "$TARGET_PATH"
        fi
        ;;
esac
