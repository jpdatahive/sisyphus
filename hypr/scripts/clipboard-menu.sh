#!/usr/bin/env bash
# ==========================================================
# GERENCIADOR DE HISTÓRICO DA ÁREA DE TRANSFERÊNCIA (CLIPHIST)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i edit-paste
    fi
}

if ! command -v cliphist >/dev/null 2>&1; then
    notify "Área de Transferência" "cliphist não está instalado no sistema."
    exit 1
fi

SELECTED=$(cliphist list 2>/dev/null | rofi -dmenu -i -p "Área de Transferência" -theme-str 'window { width: 750px; } listview { lines: 8; }')

[ -z "$SELECTED" ] && exit 0

printf "%s" "$SELECTED" | cliphist decode | wl-copy
notify "Copiado" "Item pronto para colar."
