{ lib
, stdenv
, fetchYarnDeps
, yarnConfigHook
, nodejs
, makeWrapper
, cacert
, python3
, pkg-config
, packageDir
, yarnHash
, file
, patchelf
, libsecret
, glib
, zlib
, openssl
, libffi
, pcre2
, xcbuild
, darwin
}:

let
  inherit (builtins) attrNames attrValues fromJSON head readFile;
  json = fromJSON (readFile (packageDir + "/package.json"));
  dependencyName = head (attrNames json.dependencies);
  pname = lib.replaceStrings [ "@" "/" ] [ "" "-" ] dependencyName;
  version = head (attrValues json.dependencies);
  keytarRuntimeLibs = lib.optionals stdenv.isLinux [
    libsecret
    glib
    stdenv.cc.cc.lib
    zlib
    openssl
    libffi
    pcre2
  ];
  linuxRpath = lib.makeLibraryPath keytarRuntimeLibs;
in
stdenv.mkDerivation {
  inherit pname version;

  src = packageDir;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = packageDir + "/yarn.lock";
    hash = yarnHash;
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
    makeWrapper
    python3
    pkg-config
  ] ++ lib.optionals stdenv.isLinux [
    file
    patchelf
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
    darwin.cctools
  ];

  buildInputs = keytarRuntimeLibs;

  env = {
    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    npm_config_build_from_source = "true";
    npm_config_nodedir = "${nodejs}";
  };

  buildPhase = ''
    runHook preBuild
    npm rebuild keytar sqlite3
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app="$out/lib/node_modules/${pname}"
    mkdir -p "$app" "$out/bin"
    cp -R package.json yarn.lock node_modules "$app/"
    makeWrapper "$app/node_modules/.bin/mdctl" "$out/bin/mdctl" \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]}

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    echo "Patching RPATH for native addons -> ${linuxRpath}"
    while IFS= read -r -d "" f; do
      if file "$f" | grep -q ELF; then
        old_rpath="$(patchelf --print-rpath "$f" 2>/dev/null || true)"
        if [ -n "$old_rpath" ]; then
          patchelf --set-rpath "${linuxRpath}:$old_rpath" "$f" || true
        else
          patchelf --set-rpath "${linuxRpath}" "$f" || true
        fi
      fi
    done < <(find "$out/lib/node_modules" -type f -name '*.node' -print0)
  '';
}
