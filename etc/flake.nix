{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Use Nix LD for VSCode remote dev
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, nix-ld, ... }:
    let
      system = "x86_64-linux";
      config.allowUnfree = true;
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    { nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          {
            users.users.kautau = {
              isNormalUser = true;
              shell = pkgs.bash;
            };
          }

          nixos-wsl.nixosModules.default
          {
            # This value determines the NixOS release from which the default
            # settings for stateful data, like file locations and database versions
            # on your system were taken. It's perfectly fine and recommended to leave
            # this value at the release version of the first install of this system.
            # Before changing this value read the documentation for this option
            # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
            system.stateVersion = "25.05"; # Did you read the comment?
            
            wsl = {
              enable = true;
              defaultUser = "kautau";
              extraBin = with pkgs; [
                { src = "${coreutils}/bin/uname"; }
                { src = "${coreutils}/bin/dirname"; }
                { src = "${coreutils}/bin/readlink"; }
                { src = "${curl}/bin/curl"; }
              ];
            };
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kautau = import ./home.nix;
          }

          nix-ld.nixosModules.nix-ld
          { programs.nix-ld.dev.enable = true; }
        ];
      };
    };
  };
}
