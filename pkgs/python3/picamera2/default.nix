{ lib, 
  buildPythonPackage,
  fetchFromGitHub,
  python3Packages,
  #python3 packages
  numpy,
  piexif,
  pillow,
  python-prctl,
  av,
  pylibcamera,
  toPythonModule,
  #local packages needing overlay
  #Not using simplejpeg rn, since it doesn't package well in nix.
  pidng,
  kmsxx,
  v4l2-python3,
  ...
}: let
  #python-prctl doesn't currently build correctly due to nixos/nixpkgs#236443. this patches it till a proper pr can be made.
  python-prctl-fix = python-prctl.overrideAttrs {
    patchPhase = ''
      substituteInPlace test_prctl.py --replace 'sys.version[0:3]' '"cpython-%d%d" % (sys.version_info.major, sys.version_info.minor)'
    '';
  };
in buildPythonPackage rec {
  pname = "picamera2";
  version = "0.3.18";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "picamera2";
    rev = "v0.3.18";
    hash = "sha256-ybMDBNkppMM/PSg1eYzRQiB14KWG/wJR2SuY+traMEE=";
  };

  propagatedBuildInputs = [
    numpy
    piexif
    pillow
    python-prctl-fix
    av
    pylibcamera
    (kmsxx.override {withPython = true;})

    pidng
    v4l2-python3
  ];

  patches = [
    ./picamera.patch
  ];

  doCheck = false;
  pythonImportsCheck = [ "picamera2" ];

  meta = with lib; {
    description = "New libcamera based python library for raspberry pi";
    homepage = "https://github.com/raspberrypi/picamera2";
    license = licenses.bsd2;
    maintainers = [ {
      email = "nina@projectmakeit.com";
      github = "faeranne";
      githubId = 764185;
      name = "FaerAnne";
    } ];
  };
}

