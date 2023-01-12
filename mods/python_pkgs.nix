let
  pynixifyOverlay =
    final: prev: {
      python310 = prev.python310.override { inherit packageOverrides; };
      python311 = prev.python311.override { inherit packageOverrides; };
    };

  packageOverrides = final: prev: with final;
    let
      inherit (prev.stdenv) isDarwin isAarch64;
      isM1 = isDarwin && isAarch64;
    in
    {
      pyopenssl = if isM1 then prev.pyopenssl.overrideAttrs (_: { meta.broken = false; }) else prev.pyopenssl;
      google-auth = prev.google-auth.overridePythonAttrs (_: { doCheck = false; });
      pycurl = if isM1 then prev.pycurl.overrideAttrs (_: { doInstallCheck = false; }) else prev.pycurl;
    };
in
pynixifyOverlay
