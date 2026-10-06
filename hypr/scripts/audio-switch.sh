#!/usr/bin/env bash
# ==========================================================
# TROCA RÁPIDA DE SAÍDA DE ÁUDIO (WPCTL)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i audio-speakers
    fi
}

# Obtém a lista de Sinks (saídas de áudio) em uma única chamada ao wpctl
sinks_data=$(wpctl status 2>/dev/null | awk '
BEGIN { in_audio = 0; in_sinks = 0 }
/Audio/ { in_audio = 1 }
in_audio && /Sinks:/ { in_sinks = 1; next }
in_audio && in_sinks && /(Sources:|Filters:|Streams:|Video)/ { in_sinks = 0 }
in_sinks && match($0, /([*]?)[[:space:]]*([0-9]+)\.[[:space:]]*(.*)/, m) {
    active = (m[1] == "*") ? 1 : 0
    id = m[2]
    name = m[3]
    sub(/[[:space:]]+\[vol:.*$/, "", name)
    sub(/[[:space:]]+$/, "", name)
    printf "%d|%s|%s\n", active, id, name
}')

[ -z "$sinks_data" ] && exit 0

declare -a SINK_IDS
declare -a SINK_NAMES
CURRENT_INDEX=0
idx=0

while IFS="|" read -r is_active id name; do
    [[ -z "$id" ]] && continue
    SINK_IDS[idx]="$id"
    SINK_NAMES[idx]="$name"
    if [[ "$is_active" -eq 1 ]]; then
        CURRENT_INDEX=$idx
    fi
    ((idx++))
done <<< "$sinks_data"

TOTAL=${#SINK_IDS[@]}

if [[ "$TOTAL" -le 1 ]]; then
    notify "Áudio" "Apenas uma saída de áudio conectada."
    exit 0
fi

# Alterna para a próxima saída de áudio
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % TOTAL ))
NEXT_SINK="${SINK_IDS[NEXT_INDEX]}"
NEXT_NAME="${SINK_NAMES[NEXT_INDEX]}"

wpctl set-default "$NEXT_SINK"
notify "Saída de Áudio Alterada" "$NEXT_NAME"
