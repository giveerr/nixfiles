{
  config,
  pkgs,
  self,
  inputs,
  lib,
  ...
}: {
  environment.systemPackages = [
    # we need git for flakes
    pkgs.git
  ];
  environment.variables.FLAKE = "/home/giveerr/Documents/code/dotfiles";

  nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };

  nix = {
    # extra builders to offload work onto
    # don't set a machine as a builder to itself (throws warnings)
    buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
      {
        system = "aarch64-linux";
        sshUser = "giveerr";
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        maxJobs = 4;
        hostName = "alpha";
        protocol = "ssh-ng";
        supportedFeatures = ["nixos-test" "benchmark" "kvm" "big-parallel"];
      }
    ];
    distributedBuilds = true;

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      substituters = [
        "https://nix-community.cachix.org"
        "https://fufexan.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      ];

      trusted-users = ["root" "@wheel"];
    };
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      lib =
        prev.lib
        // {
          colors = import "${self}/lib/colors" prev.lib;
        };
    })
  ];
}
