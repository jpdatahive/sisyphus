#!/usr/bin/env bash
# ==========================================================
# SELETOR DE EMOJIS E SÍMBOLOS NERD FONT (ROFI)
# ==========================================================

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2" -i accessories-character-map
    fi
}

DATA="󰥔  :: Relógio / Hora
󰸗  :: Calendário / Data
󰓇  :: Spotify
󰎆  :: Música / Nota Musical
󰋋  :: Fone de Ouvido
󰓃  :: Caixa de Som
󰍬  :: Microfone
󰍛  :: Processador / CPU
󰘚  :: Memória RAM
󰤄  :: Suspender / Lua
󰌾  :: Cadeado / Bloqueio
󰐥  :: Energia / Desligar
󰜉  :: Reiniciar
󰗽  :: Sair / Logout
󰓅  :: Performance / Velocidade
󰾆  :: Balanceado
󰾅  :: Silencioso / Quiet
󰈀  :: Rede Cabeada / Ethernet
󰤨  :: Wi-Fi / Rede Sem Fio
󰂯  :: Bluetooth
󰂄  :: Bateria Carregando
󰁹  :: Bateria Cheia
󰁻  :: Bateria Fraca
  :: Círculo Preenchido / Gravação
  :: Lupa / Pesquisa
  :: Terminal / Console
  :: Pasta / Diretório
󰄬  :: Check / Sucesso
  :: Cruz / Fechar / Cancelar
󰅂  :: Seta Direita
󰅁  :: Seta Esquerda
😀  :: Rosto Sorridente
🚀  :: Foguete
🔥  :: Fogo
✨  :: Brilho / Estrelas
💡  :: Lâmpada / Ideia
🎉  :: Festa / Comemoração
👍  :: Polegar para Cima
❤️  :: Coração
⚡  :: Raio / Energia
🐛  :: Bug / Inseto
🔧  :: Ferramenta / Configuração
📦  :: Pacote / Caixa
📝  :: Nota / Lápis
🔒  :: Cadeado Fechado
🌐  :: Globo / Web"

CHOICE=$(echo -e "$DATA" | rofi -dmenu -i -p "Símbolos e Emojis" -theme-str 'window { width: 520px; } listview { lines: 8; }')

[ -z "$CHOICE" ] && exit 0

SYMBOL=$(awk '{print $1}' <<< "$CHOICE")
if [ -n "$SYMBOL" ]; then
    printf "%s" "$SYMBOL" | wl-copy
    notify "Símbolo Copiado" "$SYMBOL copiado para a área de transferência."
fi
