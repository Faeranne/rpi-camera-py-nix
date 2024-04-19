{ lib, 
  buildPythonPackage,
  fetchPypi,
  #python3 packages
  numpy,
  ...
}: let
in buildPythonPackage rec {
  pname = "v4l2-python3";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "6258917ac8049ac69871a5e0dfd6d89d55c9e7f80e812c1ef8ba8879bda1c587";
  };

  propagatedBuildInputs = [
  ];

  # Tests are broken rn, so this prevents them from being run.
  doCheck = false;
  pythonImportsCheck = [ "v4l2" ];

  meta = with lib; {
    description = "Python bindings for the v4l2 userspace api";
    homepage = "https://pypi.org/project/v4l2-python3/";
    license = licenses.gpl2;
    maintainers = [ {
      email = "nina@projectmakeit.com";
      github = "faeranne";
      githubId = 764185;
      name = "FaerAnne";
    } ];
  };
}

