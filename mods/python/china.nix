final: prev: with prev; rec {
  tccli = buildPythonPackage rec {
    pname = "tccli";
    version = "3.0.838.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-QY0rtm7lxUoXsAYyQdjn/rFqJHNprPAr/G6Q4NU3AdQ=";
    };
    propagatedBuildInputs = [
      (buildPythonPackage rec {
        pname = "jmespath";
        version = "0.10.0";

        src = fetchPypi {
          inherit pname version;
          sha256 = "1yflbqggg1z9ndw9ps771hy36d07j9l2wwbj66lljqb6p1khapdq";
        };

        buildInputs = [ nose ];
        propagatedBuildInputs = [ ply ];
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

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-Jr0+U1Y6LdRiK431DfTnnrDSgKCEY+XpnfTDE8VfAC8=";
      };
      propagatedBuildInputs = [ requests ];
      doCheck = false;
    };


  coscmd = buildPythonPackage rec {
    pname = "coscmd";
    version = "1.8.6.30";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-nKhtW2OQwKl/Jl3gfuzrHM1JJz/yOYUFncaLtrGI+qU=";
    };
    pythonImportsCheck = [
      "coscmd"
    ];
    preBuild =
      let
        sed = "${pkgs.gnused}/bin/sed -i -E";
      in
      ''
        ${sed} '/argparse/d' ./requirements.txt
        ${sed} '/datetime/d' ./requirements.txt
      '';
    propagatedBuildInputs = [
      (buildPythonPackage rec {
        pname = "argparse";
        version = "1.4.0";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-YrCJpVvh2JSc0rx+DfC9254Cj678jDIDjMhIYq791uQ=";
        };
        pythonImportsCheck = [
          "argparse"
        ];
        doCheck = false;
      })
      (buildPythonPackage rec {
        pname = "cos-python-sdk-v5";
        version = "1.9.23";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-W8k2AmE/ZFSXmnauD5eiaYL6ivdZwOnn4pUSn/yKKAQ=";
        };
        pythonImportsCheck = [
          "qcloud_cos"
        ];
        propagatedBuildInputs = [
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
