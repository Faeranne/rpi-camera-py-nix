{
  description = "Nix package that provides PiCamera2 as a nix python package";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    allPkgs = forAllSystems (system: import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [(finalPy: prevPy: {
            python-prctl = prevPy.python-prctl.overrideAttrs {
              patchPhase = ''
                substituteInPlace test_prctl.py --replace 'sys.version[0:3]' '"cpython-%d%d" % (sys.version_info.major, sys.version_info.minor)'
                echo Hello
              '';
            };
          })];
        })
      ];
    });
  in {
    packages = forAllSystems (system: let
      pkgs = allPkgs.${system};
    in rec {
      rpi-libcamera = pkgs.callPackage ./pkgs/libcamera { };
      pylibcamera = pkgs.python3.pkgs.callPackage ./pkgs/python3/pylibcamera { inherit rpi-libcamera; };
      v4l2-python3 = pkgs.python3.pkgs.callPackage ./pkgs/python3/v4l2-python3.nix { };
      pidng = pkgs.python3.pkgs.callPackage ./pkgs/python3/pidng.nix { };
      picamera2 = pkgs.python3.pkgs.callPackage ./pkgs/python3/picamera2 { inherit pylibcamera pidng v4l2-python3; };
      default = picamera2;
    });
    overlays = forAllSystems (system: {
      default = final: prev: {
        libcamera = self.packages.${system}.rpi-libcamera;
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (finalPy: prevPy: {
            inherit (self.packages.${system}) pylibcamera v4l2-python3 pidng picamera2;
            python-prctl = prevPy.python-prctl.overrideAttrs {
              patchPhase = ''
                substituteInPlace test_prctl.py --replace 'sys.version[0:3]' '"cpython-%d%d" % (sys.version_info.major, sys.version_info.minor)'
                echo Hello
              '';
            };
          })
        ];
      };
    });

    devShells = forAllSystems (system:
        let
          pkgs = allPkgs.${system};
          pythonWithPackages = pkgs.python3.withPackages (ps: with self.packages.${system};[
            picamera2
          ]);
        in
        {
          default = pkgs.mkShellNoCC (with self.packages.${system}; {
            buildInputs = [
              pythonWithPackages
              rpi-libcamera
            ];
            shellHook = ''
              export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath[
                rpi-libcamera
              ]};
            '';
          });
        });

    formatter = forAllSystems (system: allPkgs.${system}.nixpkgs-fmt);

  };
}
