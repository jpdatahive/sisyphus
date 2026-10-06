#!/usr/bin/env bash
# ==========================================================
# SELETOR INTERATIVO DE DISPOSITIVOS DE ÁUDIO (ROFI + WPCTL)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i audio-speakers
    fi
}

# Obtém saídas (Sinks) e entradas (Sources) via wpctl
audio_data=$(wpctl status 2>/dev/null | awk '
BEGIN { in_audio = 0; section = "" }
/Audio/ { in_audio = 1 }
in_audio && /Sinks:/ { section = "sink"; next }
in_audio && /Sources:/ { section = "source"; next }
in_audio && /(Filters:|Streams:|Video)/ { section = "" }
section != "" && match($0, /([*]?)[[:space:]]*([0-9]+)\.[[:space:]]*(.*)/, m) {
    active = (m[1] == "*") ? 1 : 0
    id = m[2]
    name = m[3]
    sub(/[[:space:]]+\[vol:.*$/, "", name)
    sub(/[[:space:]]+$/, "", name)
    printf "%s|%d|%s|%s\n", section, active, id, name
}')

[ -z "$audio_data" ] && exit 0

ROFI_ITEMS=""
declare -A ID_MAP

while IFS="|" read -r section is_active id name; do
    [[ -z "$id" ]] && continue
    if [[ "$section" == "sink" ]]; then
        icon="󰓃"
        [[ "$name" =~ [Hh]eadphone|[Ff]one|[Hh]eadset ]] && icon="󰋋"
        prefix="Saída"
    else
        icon="󰍬"
        prefix="Entrada"
    fi

    status=""
    [[ "$is_active" -eq 1 ]] && status=" [Ativo]"

    label="${icon}  [${prefix}] ${name}${status}"
    ROFI_ITEMS+="${label}\n"
    ID_MAP["$label"]="$id|$name"
done <<< "$audio_data"

CHOICE=$(echo -e -n "$ROFI_ITEMS" | sed '/^$/d' | rofi -dmenu -i -p "Dispositivo de Áudio" -theme-str 'window { width: 620px; }')

[ -z "$CHOICE" ] && exit 0

target_data="${ID_MAP["$CHOICE"]}"
if [ -n "$target_data" ]; then
    target_id="${target_data%%|*}"
    target_name="${target_data#*|}"
    wpctl set-default "$target_id"
    notify "Áudio Atualizado" "$target_name"
fi
