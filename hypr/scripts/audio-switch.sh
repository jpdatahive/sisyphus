#!/usr/bin/env bash
# ==========================================================
# TROCA RÁPIDA DE SAÍDA DE ÁUDIO (WPCTL)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2"
    fi
}

# Obtém a lista de Sinks (saídas de áudio) disponíveis
SINKS=($(wpctl status | grep -A 10 "Audio" | grep -A 8 "Sinks:" | grep -E '^\s+[│\* ]*\s+[0-9]+\.' | awk '{print $NF}' | sed 's/\.//'))

if [ ${#SINKS[@]} -le 1 ]; then
    notify "Áudio" "Apenas uma saída de áudio conectada."
    exit 0
fi

CURRENT=$(wpctl status | grep -A 10 "Audio" | grep -A 8 "Sinks:" | grep -E '\*' | awk '{print $2}' | sed 's/\.//')

# Encontra o próximo sink
NEXT_SINK="${SINKS[0]}"
for i in "${!SINKS[@]}"; do
    if [[ "${SINKS[$i]}" == "$CURRENT" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#SINKS[@]} ))
        NEXT_SINK="${SINKS[$NEXT_INDEX]}"
        break
    fi
done

wpctl set-default "$NEXT_SINK"
NAME=$(wpctl status | grep -A 10 "Sinks:" | grep -E "^\s+[│\* ]*\s+$NEXT_SINK\." | sed 's/.*\. //;s/\[.*//')
notify "Saída de Áudio Alterada" "$NAME"
