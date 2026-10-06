#!/usr/bin/env bash
# ==========================================================
# GUIA INTERATIVO DE ATALHOS (ROFI)
# ==========================================================

BINDS="Super + Enter          :: Abrir Terminal Kitty
Super + Space          :: Menu de Aplicativos (Rofi drun)
Super + Tab            :: Alternar Janelas Abertas (Rofi window)
Super + E              :: Gerenciador de Arquivos (Nautilus)
Super + W              :: Fechar Janela Ativa
Super + V              :: Alternar Janela Flutuante
Super + J              :: Alternar Divisão (Dwindle split)
Super + G              :: Agrupar Janelas em Abas
Super + Alt + Tab      :: Navegar entre Abas do Grupo
Super + Shift + Setas  :: Trocar posição da Janela (Swap)
Super + Ctrl + S       :: Screenshot Interativo (Satty / Editor)
Print                  :: Screenshot Rápido (Tela Cheia)
Super + Shift + T      :: Extrair Texto da Tela (OCR)
Super + Alt + Print    :: Iniciar/Parar Gravação de Tela
Super + Mute           :: Rotação Rápida de Saída de Áudio
Super + Shift + A      :: Seletor Interativo de Saídas/Entradas de Áudio
Super + ,              :: Fechar Notificação Atual
Super + Ctrl + ,       :: Alternar Modo Não Perturbe
Super + Shift + Space  :: Ocultar / Exibir Waybar
Super + Ctrl + Space   :: Menu de Temas (com Miniaturas)
Super + Alt + Space    :: Galeria Visual de Wallpapers (Grid)
Super + Alt + W        :: Próximo Wallpaper do Tema (Ciclar)
Super + Shift + V      :: Histórico da Área de Transferência (Clipboard)
Super + Shift + P      :: Perfis de Energia e Ventoinha (ASUS ROG)
Super + .              :: Seletor de Emojis e Símbolos Nerd Font
Super + =              :: Calculadora Rápida (Rofi)
Super + Escape         :: Menu de Sessão e Energia (Power Menu)
Super + K              :: Exibir este Guia de Atalhos"

echo -e "$BINDS" | rofi -dmenu -i -p "Atalhos do Sistema" -theme-str 'window { width: 720px; } listview { lines: 14; }' >/dev/null
