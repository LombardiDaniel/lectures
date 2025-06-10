{
  description = "Nix-powered environment for experiments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-2.29.0";
  };

  outputs = { self, nixpkgs }: {
    devShells.x86_64-linux.default = nixpkgs.lib.nixpkgs.mkShell {
      packages = with nixpkgs; [
        git
        docker

        python3
        python3Packages.numpy
        python3Packages.scipy
        python3Packages.matplotlib
        python3Packages.pandas
      ];

      # Optional: Define environment variables or shell hooks
      shellHook = ''
        echo "Entering reproducible thesis experiment environment!"
        export PYTHONPATH=$(pwd)/src:$PYTHONPATH # Example: add your project's src directory to PYTHONPATH
        # You can add other setup commands here.
      '';
    };
  };
}