{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    # blender-bin.url = "github:edolstra/nix-warez?dir=blender";
  };

  # outputs = { self, nixpkgs, home-manager, blender-bin, ... }@inputs: 
  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {  
      # Please replace my-nixos with your hostname
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          inputs.stylix.nixosModules.stylix
          # ({config, pkgs, ...}: {
          #   nixpkgs.overlays = [ blender-bin.overlays.default ];
          #   # This line can either be here or in configuration.nix
          #   environment.systemPackages = with pkgs; [ blender_4_0 ];
          # })
        ];
      };
      homeConfigurations = {
        gasdia73 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [./home.nix ];
        };
      };
    };
}

