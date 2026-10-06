#!/usr/bin/env bash
# ==========================================================
# PERFIS DE ENERGIA E VENTOINHA (ASUS ROG / ASUSCTL)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i preferences-system-power
    fi
}

if ! command -v asusctl >/dev/null 2>&1; then
    notify "Perfil de Energia" "asusctl não encontrado no sistema."
    exit 1
fi

# Detecta o perfil ativo
CURRENT=$(asusctl profile -p 2>/dev/null | awk '/Active profile:/ {print $NF}')
CURRENT="${CURRENT:-Balanced}"

PERF="󰓅  Performance"
BAL="󰾆  Balanced"
QUIET="󰾅  Quiet"

OPTIONS="${PERF}\n${BAL}\n${QUIET}"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Perfil ($CURRENT)" -theme-str 'window { width: 340px; } listview { lines: 3; spacing: 4px; } element { padding: 8px 12px; }')

case "$CHOICE" in
    *"Performance"*)
        asusctl profile -P Performance >/dev/null 2>&1
        notify "Perfil de Energia" "Perfil ativo: Performance"
        ;;
    *"Balanced"*)
        asusctl profile -P Balanced >/dev/null 2>&1
        notify "Perfil de Energia" "Perfil ativo: Balanced"
        ;;
    *"Quiet"*)
        asusctl profile -P Quiet >/dev/null 2>&1
        notify "Perfil de Energia" "Perfil ativo: Quiet"
        ;;
esac
