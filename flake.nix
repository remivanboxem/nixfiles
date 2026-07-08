{
  description = "RémiOS 23.11";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    kathara.url = "github:Captniz/Kathara-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #    stylix = {
    #      url = "github:danth/stylix";
    #      inputs.nixpkgs.follows = "nixpkgs";
    #    };
  };

  outputs =
    {
      self,
      #      stylix,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      mkSystem =
        host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # stylix.nixosModules.stylix
            ./hosts/${host}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.remi = import ./home/remi.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        # thinkpad = mkSystem "thinkpad" "x86_64-linux";
        dell = mkSystem "dell" "x86_64-linux";
        # server   = mkSystem "server"   "x86_64-linux";
      };
    };
}
