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
            rlwrap
            gnuplot
            (python3.withPackages (ps:
              with ps; [
                ipython
                jupyter
                numpy
                matplotlib
              ]))
          ];
          #Uncomment this if you don't care about maxima and want `nix develop`
          #to just run the notebook for you. Most convenient.
          #shellHook = "jupyter notebook";
        };
      }
    );
}
