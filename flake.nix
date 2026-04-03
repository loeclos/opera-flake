{
  description = "Opera and Opera GX browsers for NixOS via Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true; 
      };
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          opera = pkgs.callPackage ./one.nix { };
          opera-gx = pkgs.callPackage ./gx.nix { };
          
          default = self.packages.${system}.opera;
        });

      apps = forAllSystems (system: {
        opera = {
          type = "app";
          program = "${self.packages.${system}.opera}/bin/opera";
        };
        opera-gx = {
          type = "app";
          program = "${self.packages.${system}.opera-gx}/bin/opera-gx";
        };
      });

      overlays.default = final: prev: {
        opera = self.packages.${prev.system}.opera;
        opera-gx = self.packages.${prev.system}.opera-gx;
      };
    };
}