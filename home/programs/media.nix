{
  pkgs,
  config,
  ...
}:
# media - control and enjoy audio/video
{
  imports = [
    ./rnnoise.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    # images
    imv

    spotify-tui
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };

    obs-studio.enable = true;
  };

  services = {
    playerctld.enable = true;

    spotifyd = {
      enable = true;
      package = pkgs.spotifyd.override {withMpris = true;};
      settings.global = {
        autoplay = true;
        backend = "pulseaudio";
        bitrate = 320;
        cache_path = "${config.xdg.cacheHome}/spotifyd";
        device_type = "computer";
        initial_volume = "100";
        use_mpris = true;
        volume_normalisation = false;
      };
    };
  };
}
