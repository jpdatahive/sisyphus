# Sisyphus 🪨

> Dotfiles pessoais para **NixOS** com **Hyprland**, **Waybar**, **Rofi** e ferramentas associadas.

## 📂 Estrutura do Repositório

```text
sisyphus/
├── hypr/
│   └── hyprland.lua           # Configuração do compositor Hyprland
├── waybar/
│   ├── config.jsonc           # Módulos e layout do Waybar
│   └── style.css              # Tema Catppuccin Mocha
├── rofi/
│   └── config.rasi            # Configuração do launcher/menu
└── nixos/
    ├── configuration.nix      # Configuração do sistema NixOS
    └── hardware-configuration.nix # Mapeamento de hardware/discos
```

## 🚀 Como Aplicar

### Configurações de Usuário (~/.config)
Para vincular com links simbólicos:
```bash
ln -sf $(pwd)/waybar ~/.config/waybar
ln -sf $(pwd)/hypr ~/.config/hypr
ln -sf $(pwd)/rofi ~/.config/rofi
```

### Configurações do Sistema (NixOS)
```bash
sudo cp nixos/*.nix /etc/nixos/
sudo nixos-rebuild switch
```
