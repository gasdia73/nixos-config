{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # stylix.url = "github:danth/stylix";
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  # outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  outputs = { self, nixpkgs, antigravity-nix, ... }@inputs: 
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
    in {  
      # Please replace my-nixos with your hostname
      nixosConfigurations = {
        lenovo1 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
          environment.systemPackages = [
            antigravity-nix.packages.x86_64-linux.default
          ];
        }
            # Import the previous configuration.nix we used,
            # so the old configuration file still takes effect
            ./lenovo1.nix

            # inputs.stylix.nixosModules.stylix

            # ({config, pkgs, ...}: {
            #   nixpkgs.overlays = [ blender-bin.overlays.default ];
            #   # This line can either be here or in configuration.nix
            #   environment.systemPackages = with pkgs; [ blender_4_0 ];
            # })
          ];
        };
        desktopcasa = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
          environment.systemPackages = [
            antigravity-nix.packages.x86_64-linux.default
          ];
        }
            # Import the previous configuration.nix we used,
            # so the old configuration file still takes effect
            ./desktopcasa.nix     

            # inputs.stylix.nixosModules.stylix

            # ({config, pkgs, ...}: {
            #   nixpkgs.overlays = [ blender-bin.overlays.default ];
            #   # This line can either be here or in configuration.nix
            #   environment.systemPackages = with pkgs; [ blender_4_0 ];
            # })
          ];
        };
        # homeConfigurations = {
        #   gasdia73 = home-manager.lib.homeManagerConfiguration {
        #     inherit pkgs;
        #     modules = [./home.nix ];
        #   };
        # };
      };
    };
}

