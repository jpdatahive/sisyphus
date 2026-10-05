#!/usr/bin/env bash
# ==========================================================
# UTILITÁRIO DE SCREENSHOT E GRAVAÇÃO (ESTILO OMARCHY)
# ==========================================================

DIR="$HOME/Images/Screenshots"
mkdir -p "$DIR"
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
FILENAME="$DIR/screenshot_${TIMESTAMP}.png"
RECORDING_PID_FILE="/tmp/omarchy_recording.pid"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i "$3"
    fi
}

case "$1" in
    # ------------------------------------------------------
    # 1. MODO INTERATIVO (EDITOR SATTY / SELEÇÃO INTELIGENTE)
    # ------------------------------------------------------
    interactive)
        pkill slurp && exit 0
        SELECTION=$(slurp 2>/dev/null)
        [ -z "$SELECTION" ] && exit 0

        if command -v satty >/dev/null 2>&1; then
            grim -g "$SELECTION" - | satty --filename - --output-filename "$FILENAME" --early-exit --actions-on-enter save-to-clipboard --copy-command 'wl-copy'
        elif command -v swappy >/dev/null 2>&1; then
            grim -g "$SELECTION" - | swappy -f -
        else
            grim -g "$SELECTION" "$FILENAME" && wl-copy < "$FILENAME"
            notify "Screenshot Salvo" "Copiado para a área de transferência: $FILENAME" "$FILENAME"
        fi
        ;;

    # ------------------------------------------------------
    # 2. MODO TELA CHEIA (SALVAR DIRETO E COPIAR)
    # ------------------------------------------------------
    full)
        grim "$FILENAME" && wl-copy < "$FILENAME"
        notify "Screenshot Capturado" "Tela cheia salva em: $FILENAME" "$FILENAME"
        ;;

    # ------------------------------------------------------
    # 3. GRAVAÇÃO DE TELA (TOGGLE INICIAR / PARAR)
    # ------------------------------------------------------
    record-toggle)
        if [ -f "$RECORDING_PID_FILE" ]; then
            REC_PID=$(cat "$RECORDING_PID_FILE")
            kill -INT "$REC_PID" 2>/dev/null
            rm -f "$RECORDING_PID_FILE"
            pkill -RTMIN+8 waybar 2>/dev/null
            notify "Gravação Finalizada" "Vídeo salvo na pasta de capturas."
        else
            SELECTION=$(slurp 2>/dev/null)
            [ -z "$SELECTION" ] && exit 0
            REC_FILE="$DIR/recording_${TIMESTAMP}.mp4"
            if command -v wf-recorder >/dev/null 2>&1; then
                wf-recorder -g "$SELECTION" -f "$REC_FILE" &
                echo $! > "$RECORDING_PID_FILE"
                pkill -RTMIN+8 waybar 2>/dev/null
                notify "Gravação Iniciada" "Gravando área selecionada..."
            else
                notify "Erro na Gravação" "wf-recorder não encontrado no sistema."
            fi
        fi
        ;;

    *)
        echo "Uso: $0 {interactive|full|record-toggle}"
        exit 1
        ;;
esac
