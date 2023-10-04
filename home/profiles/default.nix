{
  self,
  inputs,
  withSystem,
  module_args,
  ...
}: let
  sharedModules = [
    ../.
    ../shell
    module_args
    inputs.anyrun.homeManagerModules.default
    inputs.nix-index-db.hmModules.nix-index
    inputs.spicetify-nix.homeManagerModule
    inputs.hyprland.homeManagerModules.default
    self.nixosModules.theme
  ];

  homeImports = {
    "giveerr@ozaco" = [./ozaco] ++ sharedModules;
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
in {
  imports = [
    # we need to pass this to NixOS' HM module
    {_module.args = {inherit homeImports;};}
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
      "giveerr@ozaco" = homeManagerConfiguration {
        modules = homeImports."giveerr@ozaco";
        inherit pkgs;
      };
    });

    homeManagerModules.eww-hyprland = import ../programs/eww;
  };
}
