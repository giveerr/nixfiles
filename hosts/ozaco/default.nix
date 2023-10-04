{
  config,
  pkgs,
  self,
  inputs,
  default,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Istanbul";
  i18n.supportedLocales = ["all"];
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };
  console.keyMap = "trq";
  services.xserver = {
    layout = "tr";
    xkbVariant = "";
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "ozaco";

  programs = {
    # enable hyprland and required options
    hyprland.enable = true;

    matugen = {
      enable = false;

      wallpaper = default.wallpaper;

      # templates.amongus = {
      #   input_path = pkgs.writeText "amongus-test.css" ''
      #     color1: @{primary};
      #     color2: @{surface_variant};
      #   '';
      #   output_path = "$HOME/.config/amongus-test.css";
      # };
    };

    steam = {
      enable = true;
      # fix gamescope inside steam
      package = pkgs.steam.override {
        # extraPkgs = pkgs:
        #   with pkgs; [
        #     keyutils
        #     libkrb5
        #     libpng
        #     libpulseaudio
        #     libvorbis
        #     stdenv.cc.cc.lib
        #     xorg.libXcursor
        #     xorg.libXi
        #     xorg.libXinerama
        #     xorg.libXScrnSaver
        #   ];
        # set correct scaling
        extraProfile = "export GDK_SCALE=1";
      };
    };
  };

  # security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    # howdy = {
    #   enable = true;
    #   package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
    #   settings = {
    #     core.no_confirmation = true;
    #     video.dark_threshold = 90;
    #   };
    # };
    # linux-enable-ir-emitter = {
    #   enable = true;
    #   package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    # };

    # kmonad.keyboards = {
    #   ozaco = {
    #     name = "ozaco";
    #     device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    #     defcfg = {
    #       enable = true;
    #       fallthrough = true;
    #       allowCommands = false;
    #     };
    #     config = builtins.readFile "${self}/modules/main.kbd";
    #   };
    # };
  };
}
