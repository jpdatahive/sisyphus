#!/usr/bin/env bash
# ==========================================================
# MENU DE SESSÃO E ENERGIA (ROFI)
# ==========================================================

LOCK="󰌾  Bloquear Tela"
SUSPEND="󰤄  Suspender"
LOGOUT="󰗽  Encerrar Sessão"
REBOOT="󰜉  Reiniciar"
POWEROFF="󰐥  Desligar"

OPTIONS="${LOCK}\n${SUSPEND}\n${LOGOUT}\n${REBOOT}\n${POWEROFF}"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Sistema" -theme-str 'window { width: 320px; } listview { lines: 5; spacing: 4px; } element { padding: 8px 12px; }')

case "$CHOICE" in
    "$LOCK")
        if command -v hyprlock >/dev/null 2>&1; then
            hyprlock
        fi
        ;;
    "$SUSPEND")
        systemctl suspend
        ;;
    "$LOGOUT")
        if command -v hyprctl >/dev/null 2>&1; then
            hyprctl dispatch exit
        fi
        ;;
    "$REBOOT")
        systemctl reboot
        ;;
    "$POWEROFF")
        systemctl poweroff
        ;;
esac
