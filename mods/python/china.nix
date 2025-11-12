final: prev:
let
  inherit (final) buildPythonPackage fetchPypi;
in
rec {
  tccli = buildPythonPackage rec {
    pname = "tccli";
    version = "3.0.838.1";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-QY0rtm7lxUoXsAYyQdjn/rFqJHNprPAr/G6Q4NU3AdQ=";
    };

    nativeBuildInputs = [ final.pythonRelaxDepsHook ];
    pythonRelaxDeps = [
      "six"
    ];

    propagatedBuildInputs = with final; [
      setuptools
      (buildPythonPackage rec {
        pname = "jmespath";
        version = "0.10.0";
        pyproject = true;

        src = fetchPypi {
          inherit pname version;
          sha256 = "1yflbqggg1z9ndw9ps771hy36d07j9l2wwbj66lljqb6p1khapdq";
        };
        doCheck = false;
        propagatedBuildInputs = [ setuptools ply ];
      })
      tencentcloud-sdk-python
      six
    ];
    doCheck = false;
  };

  tencentcloud-sdk-python =
    buildPythonPackage rec {
      pname = "tencentcloud-sdk-python";
      version = "3.0.838";
      pyproject = true;

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-Jr0+U1Y6LdRiK431DfTnnrDSgKCEY+XpnfTDE8VfAC8=";
      };
      propagatedBuildInputs = with final; [ setuptools requests ];
      doCheck = false;
    };


  coscmd = buildPythonPackage rec {
    pname = "coscmd";
    version = "1.8.6.30";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-nKhtW2OQwKl/Jl3gfuzrHM1JJz/yOYUFncaLtrGI+qU=";
    };

    pythonImportsCheck = [
      "coscmd"
    ];

    preBuild =
      let
        sed = "${final.pkgs.gnused}/bin/sed -i -E";
      in
      ''
        ${sed} '/argparse/d' ./requirements.txt
        ${sed} '/datetime/d' ./requirements.txt
      '';
    propagatedBuildInputs = with final; [
      final.setuptools
      (buildPythonPackage rec {
        pname = "argparse";
        version = "1.4.0";
        pyproject = true;

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-YrCJpVvh2JSc0rx+DfC9254Cj678jDIDjMhIYq791uQ=";
        };
        pythonImportsCheck = [
          "argparse"
        ];
        build-system = [ setuptools ];
        doCheck = false;
      })
      (buildPythonPackage rec {
        pname = "cos-python-sdk-v5";
        version = "1.9.23";
        pyproject = true;

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-W8k2AmE/ZFSXmnauD5eiaYL6ivdZwOnn4pUSn/yKKAQ=";
        };
        pythonImportsCheck = [
          "qcloud_cos"
        ];
        propagatedBuildInputs = [
          setuptools
          crcmod
          pycryptodome
          requests
          six
          xmltodict
        ];
        doCheck = false;
      })
      six
      tqdm
      prettytable
      pytz
      pyyaml
      requests
    ];
    doCheck = false;
  };
}
