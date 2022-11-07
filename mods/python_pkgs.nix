let
  pynixifyOverlay =
    final: prev: {
      python310 = prev.python310.override { inherit packageOverrides; };
      python311 = prev.python311.override { inherit packageOverrides; };
    };

  packageOverrides = final: prev: with final;
    let
      inherit (prev.stdenv) isDarwin isAarch64 isNixOS;
      isM1 = isDarwin && isAarch64;
      isOldMac = isDarwin && !isAarch64;
    in
    {
      slack-sdk = prev.slack-sdk.overridePythonAttrs (_: { doCheck = false; });
      pyopenssl = if isM1 then prev.pyopenssl.overrideAttrs (_: { meta.broken = false; }) else prev.pyopenssl;
      google-auth = prev.google-auth.overridePythonAttrs (_: { doCheck = false; });
      pycurl = if isM1 then prev.pycurl.overrideAttrs (_: { doInstallCheck = false; }) else prev.pycurl;

      looker-sdk = buildPythonPackage rec {
        pname = "looker-sdk";
        version = "22.10.0";

        src = fetchPypi {
          inherit version;
          pname = "looker_sdk";
          sha256 = "sha256-Ex/AAdZp+qo91qZOLtRnzlYR4y0TILiycPgZxI5pVNE=";
        };

        buildInputs = [ exceptiongroup ];
        propagatedBuildInputs = [
          requests
          attrs
          cattrs
          typing-extensions
        ];

        pythonImportsCheck = [
          "looker_sdk"
        ];

        doCheck = false;

        meta = with lib; {
          description = "Looker REST API";
          homepage = "https://pypi.python.org/pypi/looker_sdk";
        };
      };

      pydrive2 = buildPythonPackage rec {
        pname = "pydrive2";
        version = "1.14.0";

        src = fetchPypi {
          inherit version;
          pname = "PyDrive2";
          sha256 = "sha256-212jvmcWMPVxynEAsoHYtdcv0His1CUkem0pLis9KEA=";
        };

        propagatedBuildInputs = [
          google-api-python-client
          six
          oauth2client
          pyyaml
          pyopenssl
        ];

        pythonImportsCheck = [
          "pydrive2"
        ];

        doCheck = false;
        checkInputs = [
          appdirs
          fsspec
          funcy
          pytestCheckHook
          timeout-decorator
        ];

        meta = with lib; {
          description = "Google Drive API made easy. Maintained fork of PyDrive.";
          homepage = "https://github.com/iterative/PyDrive2";
        };
      };

      cattrs = buildPythonPackage rec {
        pname = "cattrs";
        version = "22.1.0";

        format = "pyproject";

        src = fetchTarball {
          url = "https://github.com/python-attrs/cattrs/archive/refs/tags/v${version}.tar.gz";
          sha256 = "1n0h25gj6zd02kqyl040xpdvg4hpy1j92716sz0rg019xjqqijqb";
        };

        propagatedBuildInputs = [ attrs ];
        buildInputs = [ poetry exceptiongroup ];

        pythonImportsCheck = [
          "cattr"
        ];

        preConfigure = ''
          sed -i -E '/"<= 3.10"/d' ./pyproject.toml
        '';

        doCheck = false;

        meta = with lib; {
          description = "Composable complex class support for attrs.";
          homepage = "https://github.com/Tinche/cattrs";
        };
      };
    };
in
pynixifyOverlay
