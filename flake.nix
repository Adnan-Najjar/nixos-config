{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, zen-browser, ... }@inputs:
    let
      system = "x86_64-linux";
      user = {
        hostname = "nixos";
        username = "adnan";
        fullName = "Adnan Najjar";
        email = "adnan.najjar1@gmail.com";
      };

      # Home Manager boilerplate
      hmModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${user.username}.imports =
          [ ./home-manager/home.nix ];
        home-manager.extraSpecialArgs = { inherit user inputs; };
      };

      pkgs = import nixpkgs { inherit system; };
      setupScript = pkgs.writeShellScriptBin "setup-secrets" ''
        export zenity=${pkgs.zenity}/bin/zenity
        ${./setup-secrets.sh}
      '';

    in {
      nixosConfigurations = {

        ${user.hostname} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit user inputs; };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            hmModule
          ];
        };

      };

      apps.${system}.setup-secrets = {
        type = "app";
        program = "${setupScript}/bin/setup-secrets";
      };

    };
}
