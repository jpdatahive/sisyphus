#!/usr/bin/env bash
# ==========================================================
# CALCULADORA RÁPIDA (ROFI + BC)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i accessories-calculator
    fi
}

if ! command -v bc >/dev/null 2>&1; then
    notify "Calculadora" "bc não está instalado no sistema."
    exit 1
fi

PREV_RESULT=""
PROMPT="Calcular"

while true; do
    if [ -n "$PREV_RESULT" ]; then
        PROMPT="Resultado: $PREV_RESULT | Calcular"
    fi

    INPUT=$(rofi -dmenu -i -p "$PROMPT" -theme-str 'window { width: 500px; } listview { lines: 0; } entry { placeholder: "Ex: 24 * 1.5, sqrt(64), 2^10..."; }')

    [ -z "$INPUT" ] && exit 0

    # Trata caso o usuário aperte enter no resultado prévio
    if [[ "$INPUT" == "$PREV_RESULT" ]]; then
        printf "%s" "$PREV_RESULT" | wl-copy
        notify "Calculadora" "Copiado para o clipboard: $PREV_RESULT"
        exit 0
    fi

    RESULT=$(echo "scale=4; $INPUT" | bc -l 2>/dev/null)

    if [ -n "$RESULT" ]; then
        # Remove zeros à direita em decimais redundantes
        if [[ "$RESULT" == *.* ]]; then
            RESULT="${RESULT%"${RESULT##*[!0]}"}"
            RESULT="${RESULT%.}"
        fi
        PREV_RESULT="$RESULT"
        printf "%s" "$RESULT" | wl-copy
        notify "Calculadora" "$INPUT = $RESULT (copiado)"
    else
        notify "Calculadora" "Expressão inválida: $INPUT"
    fi
done
