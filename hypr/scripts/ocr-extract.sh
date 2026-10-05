#!/usr/bin/env bash
# ==========================================================
# EXTRAÇÃO DE TEXTO DA TELA (OCR VIA TESSERACT)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2"
    fi
}

pkill slurp && exit 0
SELECTION=$(slurp 2>/dev/null)
[ -z "$SELECTION" ] && exit 0

if command -v tesseract >/dev/null 2>&1; then
    TEXT=$(grim -g "$SELECTION" - | tesseract stdin stdout -l por+eng 2>/dev/null)
    if [ -n "$TEXT" ]; then
        echo -n "$TEXT" | wl-copy
        notify "Texto Extraído (OCR)" "Texto copiado para o clipboard:\n$TEXT"
    else
        notify "OCR" "Nenhum texto reconhecido na área selecionada."
    fi
else
    # Fallback se tesseract ainda não estiver instalado
    grim -g "$SELECTION" - | wl-copy
    notify "Captura Realizada" "Instale 'tesseract' para ativar o OCR de texto."
fi
