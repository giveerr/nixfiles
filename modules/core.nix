{
  pkgs,
  lib,
  ...
}:
# configuration shared by all hosts
{
  documentation.dev.enable = true;

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = ["/share/zsh"];

  # graphics drivers / HW accel
  hardware.opengl.enable = true;

  # enable programs
  programs = {
    less.enable = true;

    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting = {
        enable = true;
        patterns = {"rm -rf *" = "fg=black,bg=red";};
        styles = {"alias" = "fg=magenta";};
        highlighters = ["main" "brackets" "pattern"];
      };
    };
  };

  # don't ask for password for wheel group
  security.sudo.wheelNeedsPassword = false;

  # don't touch this
  system.stateVersion = lib.mkDefault "23.11";

  time.timeZone = lib.mkDefault "Europe/Bucharest";

  users.users.giveerr = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["adbusers" "input" "libvirtd" "networkmanager" "plugdev" "transmission" "video" "wheel"];
  };

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
