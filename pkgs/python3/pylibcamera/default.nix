{ buildPythonPackage
, fetchFromGitHub
, fetchgit
, fetchpatch
, lib
, meson-python
, meson
, ninja
, pkg-config
, makeFontsConf
, openssl
, libdrm
, libevent
, libyaml
, lttng-ust
, gst_all_1
, gtest
, graphviz
, doxygen
, python3
, systemd # for libudev
#Python packages
, jinja2
, numpy
, pyyaml
, ply
, sphinx
, rpi-libcamera
, pybind11
, ...
}:

buildPythonPackage rec {
  pname = "libcamera";
  version = "0.2.0";

  pyproject = true;

  #src = fetchFromGitHub {
  #  owner = "raspberrypi";
  #  repo = "libcamera";
  src = fetchgit {
    url = "https://git.libcamera.org/libcamera/libcamera.git";
    rev = "v${version}";
    hash = "sha256-x0Im9m9MoACJhQKorMI34YQ+/bd62NdAPc2nWwaJAvM=";
  };

  sourceRoot = ".";

  buildInputs = [
    # IPA and signing
    #openssl

    # gstreamer integration
    #gst_all_1.gstreamer
    #gst_all_1.gst-plugins-base

    # cam integration
    #libevent
    #libdrm

    # hotplugging
    #systemd

    # lttng tracing
    #lttng-ust

    # yamlparser
    #libyaml

    #gtest
  ];

  prePatch = ''
    cp -r ${./pyproject.toml} pyproject.toml 
    cp -r ${./meson.build} meson.build
    cp -r ${./meson_options.txt} meson_options.txt
    cp -r ${./README.md} README.md
    patchShebangs --build libcamera
  '';

  patches = [
    ./meson.patch
  ];

  propagatedBuildInputs = [
    numpy
    meson-python
    pyyaml
    pybind11
    rpi-libcamera
  ];

  nativeBuildInputs = [
    python3
    ninja
    meson
    pkg-config
  ];


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
