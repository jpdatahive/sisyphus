# Sisyphus — Dotfiles & Ambiente NixOS / Hyprland

> Ambiente de trabalho moderno, minimalista e altamente performático baseado em **NixOS** e **Hyprland** (configurado nativamente via Lua), com sincronização dinâmica de temas em tempo real, utilitários interativos via **Rofi (Wayland)**, gravação de tela com indicadores dinâmicos na **Waybar** e controle total de hardware.

---

## Sumário

- [Visão Geral dos Componentes](#visão-geral-dos-componentes)
- [Estrutura do Repositório](#estrutura-do-repositório)
- [Scripts e Utilitários Integrados](#scripts-e-utilitários-integrados)
- [Mapa Completo de Atalhos (Keybindings)](#mapa-completo-de-atalhos-keybindings)
- [Sistema Dinâmico de Temas & Wallpapers](#sistema-dinâmico-de-temas--wallpapers)
- [Comportamento da Waybar & Janelas Pop-up](#comportamento-da-waybar--janelas-pop-up)
- [Instalação e Como Aplicar](#instalação-e-como-aplicar)

---

## Visão Geral dos Componentes

| Componente | Software | Descrição e Papel no Sistema |
| :--- | :--- | :--- |
| **Compositor Wayland** | `Hyprland 0.55+` | Tiling dinâmico, animações fluidas e regras de janela nativas em Lua (`hyprland.lua`). |
| **Barra de Status** | `Waybar` | Módulos inteligentes, player MPRIS, indicador de gravação pulsante e pop-ups flutuantes. |
| **Menu & Lançador** | `Rofi (Wayland)` | Lançador de apps, seletor de temas com miniaturas, galeria de wallpapers e menus rápidos. |
| **Emulador de Terminal** | `Kitty` | Aceleração por GPU, abas estilizadas e recarga instantânea de cores via `SIGUSR1`. |
| **Papel de Parede** | `Hyprpaper` | Gerenciador atômico de papéis de parede com troca via IPC sem reinicialização. |
| **Notificações** | `Mako` | Notificações leves integradas à paleta de cores do tema ativo (`makoctl`). |
| **Áudio & Multimídia** | `PipeWire / wpctl` | Controle granular de volume, mudo e alternância rápida ou guiada de dispositivos. |
| **Rede & Bluetooth** | `impala` / `bluetui` | Ferramentas TUI ágeis integradas aos cliques nos módulos da Waybar. |
| **Controle de Hardware** | `asusctl` | Gerenciamento de iluminação Aura RGB e perfis de ventoinha/energia (ASUS ROG). |

---

## Estrutura do Repositório

```text
sisyphus/
├── hypr/
│   ├── hyprland.lua               # Configuração mestre do Hyprland em Lua
│   ├── hyprpaper.conf             # Configuração do daemon Hyprpaper
│   └── scripts/                   # Utilitários de produtividade e integração
│       ├── audio-menu.sh          # Seletor interativo de saídas e microfones via Rofi
│       ├── audio-switch.sh        # Alternador rápido sequencial de saída de áudio
│       ├── calc-menu.sh           # Calculadora interativa no Rofi com histórico
│       ├── clipboard-menu.sh      # Gerenciador de área de transferência (cliphist)
│       ├── emoji-menu.sh          # Seletor de emojis e símbolos Nerd Font
│       ├── keybindings-menu.sh    # Guia interativo e pesquisável de atalhos
│       ├── ocr-extract.sh         # Extração óptica de texto da tela (Tesseract)
│       ├── power-menu.sh          # Menu de sessão (bloquear, suspender, desligar)
│       ├── power-profile.sh       # Alternador de perfis de energia e refrigeração
│       ├── screenshot.sh          # Captura (Satty), tela cheia e gravação MP4
│       ├── theme-switcher.sh      # Motor de troca e sincronização de temas
│       └── wallpaper-switcher.sh  # Galeria visual em grade de papéis de parede
├── waybar/
│   ├── config.jsonc               # Estrutura dos módulos, gaveta de tray e ações
│   ├── style.css                  # Folha de estilo e design translúcido (glassmorphism)
│   └── current-theme.css          # Cores ativas geradas dinamicamente
├── rofi/
│   ├── config.rasi                # Estilização visual, janelas centradas e fontes
│   └── colors.rasi                # Definição dinâmica de cores do launcher
└── nixos/
    ├── configuration.nix          # Configuração declarativa do sistema NixOS
    └── hardware-configuration.nix # Mapeamento de hardware, discos e boot
```

---

## Scripts e Utilitários Integrados

Todos os scripts residem em [hypr/scripts/](file:///home/jp/sisyphus/hypr/scripts/) e oferecem respostas rápidas por atalhos ou cliques da barra:

1. **`theme-switcher.sh`**:
   - Menu em **lista vertical única** no Rofi com **previews expandidos (90px)**.
   - Destaca o tema atual com indicador visual `● (ativo)`.
   - Gera e recarrega instantaneamente configurações para Kitty, Waybar, Mako, Rofi, bordas do Hyprland, teclado ROG e papel de parede.
2. **`wallpaper-switcher.sh`**:
   - **Galeria visual em grade (3x3)** com miniaturas de 120px dos papéis de parede do tema atual.
   - Suporte a modos CLI rápidos (`next`, `prev` e `set <caminho>`).
3. **`audio-menu.sh` & `audio-switch.sh`**:
   - `audio-menu.sh`: Menu Rofi para escolher saídas (fones, caixas, HDMI) e entradas (microfones).
   - `audio-switch.sh`: Comutação direta e sequencial com um único atalho de teclado.
4. **`clipboard-menu.sh`**:
   - Integração com `cliphist` e `wl-clipboard` para busca rápida no histórico de cópia.
5. **`screenshot.sh`**:
   - Captura interativa de região com anotações e edições via **Satty**.
   - Captura instantânea de tela cheia salva em `~/Images/Screenshots/`.
   - Gravação de tela em MP4 via `wf-recorder` com toggle e notificação animada na Waybar.
6. **`ocr-extract.sh`**:
   - Seleciona uma região da tela com o mouse, processa via OCR com `tesseract` e copia o texto diretamente para a área de transferência.
7. **`power-menu.sh` & `power-profile.sh`**:
   - Menu com opções de bloqueio (`hyprlock`), suspensão, hibernação, reinicialização e desligamento.
   - Perfis de ventoinha e energia via `asusctl` (*Quiet*, *Balanced*, *Performance*).
8. **`calc-menu.sh` & `emoji-menu.sh`**:
   - Calculadora flutuante com cálculo contínuo no Rofi.
   - Seletor de emojis com pesquisa em português e inglês.
9. **`keybindings-menu.sh`**:
   - Exibe todos os atalhos em uma janela filtrável do Rofi.

---

## Mapa Completo de Atalhos (Keybindings)

A tecla modificadora primária é **Super** (tecla Windows).

### Lançadores, Menus & Utilitários
| Atalho | Ação |
| :--- | :--- |
| `Super + Enter` | Abre o terminal **Kitty** |
| `Super + Space` | Abre o menu de aplicativos (**Rofi**) |
| `Super + Tab` | Alternador de janelas abertas (**Rofi Window**) |
| `Super + E` | Abre o gerenciador de arquivos (**Nautilus**) |
| `Super + K` | Exibe o guia interativo de atalhos do sistema |
| `Super + Ctrl + Space` | **Seletor de Temas** (lista com previews ampliados) |
| `Super + Alt + Space` | **Galeria de Wallpapers** (grade visual de miniaturas) |
| `Super + Alt + W` | Alterna instantaneamente para o próximo wallpaper do tema |
| `Super + Shift + V` | Histórico da área de transferência (**Clipboard**) |
| `Super + Shift + P` | Alternador de perfis de energia/ventoinha (ASUS ROG) |
| `Super + Shift + A` | Menu de seleção de entradas/saídas de áudio |
| `Super + .` | Seletor de emojis e símbolos |
| `Super + =` | Calculadora rápida |
| `Super + Escape` / `Super + M` | Menu de energia (**Power Menu**) |
| `Super + Shift + Space` | Oculta ou exibe a barra **Waybar** |

### Gerenciamento de Janelas e Tiling
| Atalho | Ação |
| :--- | :--- |
| `Super + W` | Fecha a janela ativa |
| `Super + V` | Alterna janela entre modo flutuante e ladrilhado (*toggle float*) |
| `Super + P` | Alterna modo pseudo-tiling |
| `Super + J` | Alterna orientação de divisão (*Dwindle split*) |
| `Super + G` | Agrupa janelas em abas (*Tabbed group*) |
| `Super + Alt + Tab` | Navega entre as abas do grupo ativo |
| `Super + Setas` | Move o foco para a janela na direção indicada |
| `Super + Shift + Setas` | Troca a posição física (*swap*) da janela com a vizinha |
| `Super + Botão Esquerdo` | Arrasta e move janelas flutuantes |
| `Super + Botão Direito` | Redimensiona janelas |

### Workspaces
| Atalho | Ação |
| :--- | :--- |
| `Super + [1 - 5]` | Muda para o Workspace 1 a 5 |
| `Super + Shift + [1 - 5]` | Move a janela ativa para o Workspace 1 a 5 |
| `Super + S` | Alterna o Workspace Especial flutuante (*Scratchpad*) |
| `Super + Shift + S` | Envia a janela ativa para o Workspace Especial |
| `Super + Scroll do Mouse` | Percorre os workspaces sequencialmente |

### Captura de Tela, Gravação e OCR
| Atalho | Ação |
| :--- | :--- |
| `Super + Ctrl + S` | **Screenshot Interativo**: Seleciona área para anotação/recorte no **Satty** |
| `Print` | **Screenshot Instantâneo**: Captura a tela inteira diretamente para a pasta |
| `Super + Shift + T` | **OCR de Tela**: Seleciona região e copia o texto reconhecido para o clipboard |
| `Super + Alt + Print` | **Gravação de Tela**: Inicia ou encerra a gravação de área selecionada em MP4 |

### Notificações (Mako)
| Atalho | Ação |
| :--- | :--- |
| `Super + ,` | Fecha a notificação visível mais recente |
| `Super + Shift + ,` | Fecha todas as notificações ativas |
| `Super + Ctrl + ,` | Alterna o modo **Não Perturbe** (silencia alertas) |

### Multimídia, Áudio e Brilho
| Atalho / Tecla | Ação |
| :--- | :--- |
| `Volume + / -` | Aumenta ou diminui o volume geral em 5% (`wpctl`) |
| `Volume Mute` | Alterna mudo da saída de áudio padrão |
| `Mic Mute` | Alterna mudo do microfone |
| `Super + Volume Mute` | **Troca Rápida de Saída**: Comuta entre Fone, Caixas e HDMI |
| `Brilho + / -` | Ajusta o brilho da tela suavemente (`brightnessctl`) |
| `Play / Pause / Next / Prev` | Controle de reprodução via `playerctl` |

---

## Sistema Dinâmico de Temas & Wallpapers

O Sisyphus conta com um pipeline desacoplado que propaga paletas de cores instantaneamente sem reiniciar programas nem travar o ambiente:

```text
~/.config/themes/<tema>/colors.toml
                  │
                  ├──> ~/.config/kitty/current-theme.conf   (Reload SIGUSR1)
                  ├──> ~/.config/waybar/current-theme.css  (Reload SIGUSR2)
                  ├──> ~/.config/mako/config               (Reload makoctl)
                  ├──> ~/.config/rofi/colors.rasi          (Reload automático)
                  ├──> Bordas do Hyprland                  (IPC via hyprctl eval)
                  ├──> Wallpaper no Hyprpaper              (IPC via hyprctl hyprpaper)
                  ├──> Modo Claro/Escuro GNOME             (gsettings color-scheme)
                  └──> Teclado ASUS ROG                    (asusctl aura)
```

### Como Adicionar um Novo Tema
Crie uma pasta em `~/.config/themes/<nome-do-tema>/` com os seguintes arquivos:
- `colors.toml`: Paleta com chaves hexadecimais (`accent`, `background`, `foreground`, `color0` a `color15`).
- `preview.png`: Captura de pré-visualização (16:9) exibida no seletor do Rofi.
- `backgrounds/`: Pasta contendo um ou mais papéis de parede correspondentes.
- *(Opcional)* `light.mode`: Se existir, instrui o sistema a preferir esquema claro no GTK.
- *(Opcional)* `icons.theme`: Nome do pacote de ícones a ser ativado pelo GNOME.

---

## Comportamento da Waybar & Janelas Pop-up

A barra superior é dividida em três zonas bem definidas:
- **Esquerda**: Seletor numérico de Workspaces (1 a 5) e título da janela em foco.
- **Centro**: Relógio e data, tocador MPRIS e **indicador animado de gravação de tela** (pisca em vermelho durante a gravação).
- **Direita**: Gaveta retrátil de ícones de sistema (`󱊖`), Bluetooth, Wi-Fi, Volume, CPU, Memória, Bateria e Botão de Energia.

### Regra Especial para Diálogos Flutuantes
Ao clicar em módulos da Waybar, ferramentas abrem em modo **flutuante, perfeitamente centralizadas e com tamanho fixo**:
- **Clique no Bluetooth** 󰂯: Abre o `bluetui` centralizado.
- **Clique na Rede** 󰤨: Abre o `impala` para gerenciar Wi-Fi.
- **Clique no Volume** 󰕾: Abre o mixer `pavucontrol`.
- **Clique em CPU / RAM** : Abre o monitor `htop`.
- **Clique no Gravador** : Interrompe a gravação de tela imediatamente.

---

## Instalação e Como Aplicar

### 1. Vincular configurações de usuário (`~/.config`)
Para manter as configurações do repositório vinculadas à sua pasta pessoal:
```bash
ln -sf $(pwd)/waybar ~/.config/waybar
ln -sf $(pwd)/hypr   ~/.config/hypr
ln -sf $(pwd)/rofi   ~/.config/rofi
```

### 2. Aplicar alterações no sistema NixOS
```bash
sudo cp nixos/*.nix /etc/nixos/
sudo nixos-rebuild switch
```

---

<div align="center">
  <sub>Construído com foco em fluidez, precisão e produtividade.</sub>
</div>
