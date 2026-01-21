{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Sops
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, home-manager, sops-nix, nixpkgs-unstable, ... }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      timeZone = "Europe/London";
      locale = "en_GB.UTF-8";
      unstable-overlays = {
        nixpkgs.overlays = [
          (final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.${prev.system};
            # <-- use this variant instead if unfree packages are needed: -->
            # unstable = import nixpkgs-unstable {
            #   inherit system;
            #   config.allowUnfree = true;
            # };
          })
        ];
      };
    in {
    
      # TODO: add function here so can call mkSystem ./x270/configuration.nix "hostname"

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # thinkpad x270 nixos
        nixos = nixpkgs.lib.nixosSystem {
          # `inherit` is used to pass the variables set in the above "let" statement into our configuration.nix file below
          specialArgs = { inherit inputs outputs timeZone locale; };
          # > Our main nixos configuration file <
          modules =
            [ ./system/x270/configuration.nix sops-nix.nixosModules.sops ];
        };
        
        # snowy intel nuc
        snowy = nixpkgs.lib.nixosSystem {
          # `inherit` is used to pass the variables set in the above "let" statement into our configuration.nix file below
          specialArgs = { inherit inputs outputs timeZone locale; };
          # > Our main nixos configuration file <
          modules =
            [ ./system/snowy/configuration.nix sops-nix.nixosModules.sops ];
        };

        # wilson thinkserver x270
        wilson = nixpkgs.lib.nixosSystem {
          # `inherit` is used to pass the variables set in the above "let" statement into our configuration.nix file below
          specialArgs = { inherit inputs outputs timeZone locale; hostName = "wilson"; };
          # > Our main nixos configuration file <
          modules =
            [ ./system/common/core ./system/wilson/configuration.nix sops-nix.nixosModules.sops ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "jj@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          # `inherit` is used to pass the variables set in the above "let" statement into our home.nix file below
          extraSpecialArgs = { inherit inputs outputs; };
          # > Our main home-manager configuration file <
          modules = [ ./home-manager/x270/home.nix unstable-overlays ];
        };
        
        "jj@snowy" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          # `inherit` is used to pass the variables set in the above "let" statement into our home.nix file below
          extraSpecialArgs = { inherit inputs outputs; };
          # > Our main home-manager configuration file <
          modules = [ ./home-manager/snowy/home.nix unstable-overlays ];
        };

        "jj@wilson" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          # `inherit` is used to pass the variables set in the above "let" statement into our home.nix file below
          extraSpecialArgs = { inherit inputs outputs; };
          # > Our main home-manager configuration file <
          modules = [ ./home-manager/wilson/home.nix unstable-overlays ];
        };
      };

      devShells."${system}".default = let
        pkgs = import nixpkgs { inherit system; };
        in pkgs.mkShell {
          packages = with pkgs; [];
        };
    };
}
