{
  inputs,
  sharedModules,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    # howdy = inputs.nixpkgs-howdy;
  in {
    ozaco = nixosSystem {
      modules =
        [
          ./ozaco
          ../modules/bluetooth.nix
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/lanzaboote.nix
          ../modules/power-switcher.nix
          {home-manager.users.giveerr.imports = homeImports."giveerr@ozaco";}
        ]
        ++ sharedModules;
    };
  };

  # {disabledModules = ["security/pam.nix"];}
  # "${howdy}/nixos/modules/security/pam.nix"
  # "${howdy}/nixos/modules/services/security/howdy"
  # "${howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
}