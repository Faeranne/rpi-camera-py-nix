{ lib, 
  buildPythonPackage,
  fetchPypi,
  #python3 packages
  numpy,
  ...
}: let
in buildPythonPackage rec {
  pname = "pidng";
  version = "4.0.9";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "560eb008086f8a715fd9e1ab998817a7d4c8500a7f161b9ce6af5ab27501f82c";
  };

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "pidng" ];

  meta = with lib; {
    description = "Python utility for creating Adobe DNG files from RAW image data.";
    homepage = "https://github.com/schoolpost/PiDNG";
    license = licenses.mit;
    maintainers = [ {
      email = "nina@projectmakeit.com";
      github = "faeranne";
      githubId = 764185;
      name = "FaerAnne";
    } ];
  };
}

