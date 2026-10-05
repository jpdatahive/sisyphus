#!/usr/bin/env bash
# ==========================================================
# MENU DE TEMAS E WALLPAPERS (ROFI)
# ==========================================================

THEMES="Catppuccin Mocha\nTokyo Night\nNord\nGruvbox Dark"
CHOICE=$(echo -e "$THEMES" | rofi -dmenu -i -p "Selecionar Tema" -theme-str 'window { width: 400px; }')

[ -z "$CHOICE" ] && exit 0

if command -v notify-send >/dev/null 2>&1; then
    notify-send "Tema Selecionado" "Tema ativo: $CHOICE"
fi
