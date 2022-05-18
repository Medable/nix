let
  pynixifyOverlay =
    self: super: {
      python39 = super.python39.override { inherit packageOverrides; };
      python310 = super.python310.override { inherit packageOverrides; };
      python311 = super.python311.override { inherit packageOverrides; };
    };

  packageOverrides = self: super: with self; {
    inherit (super.stdenv) isDarwin isAarch64 isNixOS;
    isM1 = isDarwin && isAarch64;
    isOldMac = isDarwin && !isAarch64;

    slack-sdk = super.slack-sdk.overridePythonAttrs (_: { doCheck = false; });
    pyopenssl = if isM1 then super.pyopenssl.overrideAttrs (_: { meta.broken = false; }) else super.pyopenssl;

    looker-sdk = buildPythonPackage rec {
      pname = "looker-sdk";
      version = "21.20.0";

      src = fetchPypi {
        inherit version;
        pname = "looker_sdk";
        sha256 = "1fw7i0zfl90mfrynyhy485gvm0nvfsc08x3s6zs5dlibsidspzq7";
      };

      propagatedBuildInputs = [ requests attrs cattrs ];

      doCheck = false;

      meta = with lib; {
        description = "Looker REST API";
        homepage = "https://pypi.python.org/pypi/looker_sdk";
      };
    };

    cattrs = buildPythonPackage rec {
      pname = "cattrs";
      version = "1.1.2";

      src = fetchPypi {
        inherit pname version;
        sha256 = "08ikvw5ikgdwanmbf2msi8ppcp80pfs4f0kkay2khx2sfka3r1x5";
      };

      propagatedBuildInputs = [ attrs ];

      doCheck = false;

      meta = with lib; {
        description = "Composable complex class support for attrs.";
        homepage = "https://github.com/Tinche/cattrs";
      };
    };
  };
in
pynixifyOverlay
