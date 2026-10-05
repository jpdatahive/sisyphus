#!/usr/bin/env bash
# ==========================================================
# GUIA INTERATIVO DE ATALHOS (ROFI)
# ==========================================================

BINDS="🚀 Super + Enter       :: Abrir Terminal Kitty
🔍 Super + Space       :: Menu de Aplicativos (Rofi)
❌ Super + W           :: Fechar Janela Ativa
📁 Super + E           :: Gerenciador de Arquivos
🪟 Super + V           :: Alternar Janela Flutuante
🔄 Super + J           :: Alternar Divisão (Dwindle split)
📑 Super + G           :: Agrupar Janelas em Abas
📑 Super + Alt + Tab   :: Navegar entre Abas do Grupo
🔀 Super + Shift + ⬅/➡ :: Trocar posição da Janela (Swap)
📸 Super + Ctrl + S    :: Screenshot Interativo (Omarchy / Satty)
📷 Print               :: Screenshot Rápido (Tela Cheia)
📝 Super + Shift + T   :: Extrair Texto da Tela (OCR)
⏺️ Super + Alt + Print  :: Iniciar/Parar Gravação de Tela
🔊 Super + Mute        :: Alternar Saída de Áudio (Fone/Caixa)
🔔 Super + ,           :: Fechar Notificação Atual
🔕 Super + Ctrl + ,    :: Alternar Modo Não Perturbe
📊 Super + Shift + Space :: Ocultar / Exibir Waybar
🎨 Super + Ctrl + Space :: Menu de Temas e Wallpapers
🚪 Super + M           :: Menu de Desligar / Sair"

CHOICE=$(echo "$BINDS" | rofi -dmenu -i -p "Atalhos do Sistema" -theme-str 'window { width: 650px; }')
