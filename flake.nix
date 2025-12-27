{
  description = "NixOS configurations for den and WSL machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Disko for declarative disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # WSL support (for other machines)
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix LD for dynamic linking
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Mise version manager
    mise = {
      url = "github:jdx/mise";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    home-manager,
    nixos-wsl,
    nix-ld,
    mise,
    ...
  }: {
    nixosConfigurations = {
      # den - The Tsunderground's new home
      # Hetzner dedicated server: 7950X3D, 128GB DDR5, 2x1.92TB NVMe
      den = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # Disko for ZFS disk management
          disko.nixosModules.disko

          # Host-specific configuration
          ./hosts/den/configuration.nix

          # Nix LD for dynamic linking
          nix-ld.nixosModules.nix-ld
          { programs.nix-ld.dev.enable = true; }

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kautau = import ./home/kautau;
            home-manager.extraSpecialArgs = { inherit mise; };
          }
        ];
      };

      # WSL configuration (preserved for Windows machines)
      nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # WSL-specific configuration
          nixos-wsl.nixosModules.default
          ./modules/wsl
          ./modules/common

          # User configuration
          {
            users.users.kautau = {
              isNormalUser = true;
              description = "Kautau";
              extraGroups = [ "wheel" "docker" ];
              shell = nixpkgs.legacyPackages.x86_64-linux.zsh;
            };

            system.stateVersion = "25.05";
          }

          # Nix LD
          nix-ld.nixosModules.nix-ld
          { programs.nix-ld.dev.enable = true; }

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kautau = import ./home/kautau;
            home-manager.extraSpecialArgs = { inherit mise; };
          }
        ];
      };
    };
  };
}
