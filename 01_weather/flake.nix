{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            wxmaxima
            gnuplot
            (python3.withPackages (ps:
              with ps; [
                ipython
                jupyter
                numpy
                matplotlib
              ]))
          ];
          #        shellHook = "jupyter notebook";
        };
      }
    );
}
