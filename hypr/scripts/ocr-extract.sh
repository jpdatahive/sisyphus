#!/usr/bin/env bash
# ==========================================================
# EXTRAÇÃO DE TEXTO DA TELA (OCR VIA TESSERACT)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i accessories-character-map
    fi
}

pkill -x slurp 2>/dev/null && exit 0
SELECTION=$(slurp 2>/dev/null)
[ -z "$SELECTION" ] && exit 0

if command -v tesseract >/dev/null 2>&1; then
    TEXT=$(grim -g "$SELECTION" - | tesseract stdin stdout -l por+eng 2>/dev/null)
    # Remove form-feed (\f) característico emitido pelo tesseract
    TEXT="${TEXT//$'\f'/}"
    # Remove espaços e quebras no início e fim
    TEXT="${TEXT#"${TEXT%%[![:space:]]*}"}"
    TEXT="${TEXT%"${TEXT##*[![:space:]]}"}"

    if [ -n "$TEXT" ]; then
        printf "%s" "$TEXT" | wl-copy
        PREVIEW="$TEXT"
        if [ "${#PREVIEW}" -gt 200 ]; then
            PREVIEW="${PREVIEW:0:197}..."
        fi
        notify "Texto Extraído (OCR)" "$PREVIEW"
    else
        notify "OCR" "Nenhum texto reconhecido na área selecionada."
    fi
else
    # Fallback se tesseract ainda não estiver instalado
    grim -g "$SELECTION" - | wl-copy
    notify "Captura Realizada" "Instale 'tesseract' para ativar o OCR de texto."
fi
