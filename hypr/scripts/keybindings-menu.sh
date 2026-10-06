#!/usr/bin/env bash
# ==========================================================
# GUIA INTERATIVO DE ATALHOS (ROFI)
# ==========================================================

BINDS="Super + Enter          :: Abrir Terminal Kitty
Super + Space          :: Menu de Aplicativos (Rofi)
Super + W              :: Fechar Janela Ativa
Super + E              :: Gerenciador de Arquivos
Super + V              :: Alternar Janela Flutuante
Super + J              :: Alternar Divisão (Dwindle split)
Super + G              :: Agrupar Janelas em Abas
Super + Alt + Tab      :: Navegar entre Abas do Grupo
Super + Shift + Setas  :: Trocar posição da Janela (Swap)
Super + Ctrl + S       :: Screenshot Interativo (Seleção / Editor)
Print                  :: Screenshot Rápido (Tela Cheia)
Super + Shift + T      :: Extrair Texto da Tela (OCR)
Super + Alt + Print    :: Iniciar/Parar Gravação de Tela
Super + Mute           :: Alternar Saída de Áudio (Fone/Caixa)
Super + ,              :: Fechar Notificação Atual
Super + Ctrl + ,       :: Alternar Modo Não Perturbe
Super + Shift + Space  :: Ocultar / Exibir Waybar
Super + Ctrl + Space   :: Menu de Temas do Sistema
Super + Alt + Space    :: Selecionar Wallpaper do Tema Ativo
Super + Alt + W        :: Próximo Wallpaper do Tema (Ciclar)
Super + M              :: Menu de Desligar / Sair"

echo -e "$BINDS" | rofi -dmenu -i -p "Atalhos do Sistema" -theme-str 'window { width: 650px; }' >/dev/null
