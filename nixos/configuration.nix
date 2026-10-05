{ config, pkgs, ... }:

let
  # nixpkgs unstable, usado só para pacotes que precisam de versão mais nova
  # (antigravity: o canal estável tem a 1.23.2, o unstable tem a 2.5.5)
  unstable = import (builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
      config.allowUnfree = true;
    };
in
{
  imports = [ ./hardware-configuration.nix ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ==========================================================
  # 1. BOOT E INICIALIZAÇÃO
  # ==========================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ==========================================================
  # 2. REDE E CONECTIVIDADE
  # ==========================================================
  networking.hostName = "nixos";
  networking.networkmanager.enable = false;
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true; # o iwd cuida do DHCP
  };
  services.resolved.enable = true; # DNS
  
  # ==========================================================
  # 3. FUSO HORÁRIO E IDIOMA
  # ==========================================================
  time.timeZone = "America/Bahia";
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # ==========================================================
  # 4. TECLADO
  # ==========================================================
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  # ==========================================================
  # 5. USUÁRIOS
  # ==========================================================
  users.users."jp" = {
    isNormalUser = true;
    description = "jp";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  # ==========================================================
  # 6. AMBIENTE DESKTOP E LOGIN (HYPRLAND + GREETD)
  # ==========================================================
  programs.hyprland.enable = true;
  security.polkit.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
      user = "greeter";
    };
  };

  # ==========================================================
  # 7. SERVIÇOS DO SISTEMA (ÁUDIO, BLUETOOTH, ARQUIVOS)
  # ==========================================================
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true; # necessário para o módulo pulseaudio do Waybar
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Suporte a lixeira, montagem de pendrives e miniaturas no Nautilus
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # ==========================================================
  # 8. GRÁFICOS (INTEL INTEGRADA + NVIDIA RTX 3050)
  # ==========================================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # comando: nvidia-offload <programa>
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # ==========================================================
  # 9. HARDWARE, ENERGIA E MANUTENÇÃO
  # ==========================================================
  services.asusd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.thermald.enable = true;

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  zramSwap.enable = true;

  # Apps Electron/Chromium nativos em Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Limpeza automática do /nix/store
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # ==========================================================
  # 10. FONTES DO SISTEMA
  # ==========================================================
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  # ==========================================================
  # 11. PACOTES DO SISTEMA (ENVIRONMENT.SYSTEMPACKAGES)
  # ==========================================================
  environment.systemPackages = with pkgs; [
    # --- Base e Ferramentas CLI ---
    git
    neovim
    wget
    curl
    htop
    unzip
    libnotify        # comando notify-send para notificações dos scripts

    # --- Desktop, Waybar e Rofi ---
    kitty
    waybar
    rofi-wayland     # versão nativa Wayland do launcher
    mako
    hyprpaper
    hyprlock
    hypridle
    hyprpolkitagent

    # --- Screenshots, OCR e Gravação de Tela (Omarchy) ---
    wl-clipboard
    grim
    slurp
    satty            # editor visual de screenshots (setas, texto, blur, crop)
    tesseract        # motor OCR para extração de texto (Super + Shift + T)
    wf-recorder      # gravador de tela Wayland (Super + Alt + Print)

    # --- Hardware, Áudio e Visualização de Arquivos ---
    brightnessctl
    playerctl
    pavucontrol
    networkmanagerapplet
    nautilus
    loupe            # visualizador de imagens moderno do GNOME
    bluetui
    impala

    # --- Navegador e IDE ---
    firefox
    unstable.antigravity # 2.5.5, vem do nixpkgs unstable
  ];

  system.stateVersion = "26.05";
}
