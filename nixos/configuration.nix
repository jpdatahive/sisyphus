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

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Rede
  networking.hostName = "nixos";
  networking.networkmanager.enable = false;
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true; # o iwd cuida do DHCP
  };
  services.resolved.enable = true; # DNS
  
  # Fuso horário e idioma
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

  # Teclado
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  # Usuário
  users.users."jp" = {
    isNormalUser = true;
    description = "jp";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  # ---------------- Config JP ----------------

  # Hyprland
  programs.hyprland.enable = true;
  security.polkit.enable = true;

  # Login TTY tuigreet
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
      user = "greeter";
    };
  };

  # Áudio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true; # necessário para o módulo pulseaudio do Waybar
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Gráficos: Intel (integrada) + NVIDIA RTX 3050 (offload)
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

  # ASUS e energia
  services.asusd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.thermald.enable = true;

  # Firmware, SSD e memória
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

  # Fontes
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Pacotes
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    htop
    unzip

    kitty
    waybar
    rofi 
    mako
    hyprpaper
    hyprlock
    hypridle
    hyprpolkitagent
    wl-clipboard
    grim
    slurp
    brightnessctl
    playerctl
    pavucontrol
    networkmanagerapplet
    nautilus
    bluetui
    impala

    firefox
    unstable.antigravity # 2.5.5, vem do nixpkgs unstable
  ];

  system.stateVersion = "26.05";
}

