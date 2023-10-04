{
  imports = [
    ../../programs
    ../../programs/games.nix
    ../../programs/dunst.nix
    ../../wayland
    ../../terminals/alacritty.nix
    ../../terminals/wezterm.nix
  ];

  home.sessionVariables = {
    GDK_SCALE = "1";
  };
}
