prev: next:
with next;
rec {
  inherit (stdenv) isLinux isDarwin isAarch64;

  prospector-177 = (import
    (fetchFromGitHub {
      name = "frozen-prospector";
      owner = "jpetrucciani";
      repo = "nix";
      rev = "58e698a20ba4cc8b58a9e08e359cc413e2868a6b";
      sha256 = "02z5hmbh0zag6smzsyd1pxgzzw84vnrdiqww3jyk3iwk6abkzjh6";
    })
    { }).prospector-176;


  # haproxy overrides
  haproxy-pin = { version, sha256 }: haproxy.overrideAttrs (attrs: rec {
    inherit version;
    src = fetchurl {
      inherit sha256;
      url = "https://www.haproxy.org/download/${lib.versions.majorMinor version}/src/${attrs.pname}-${version}.tar.gz";
    };
  });
  haproxy-2-2-9 = haproxy-pin {
    version = "2.2.9";
    sha256 = "sha256-IWgEWbCLm6IcjMn129DubhhC9Xo6Z/hxeYceHBPr1OM=";
  };
  haproxy-2-2-23 = haproxy-pin {
    version = "2.2.23";
    sha256 = "sha256-3lc7eGtm7izLmnmiN7DpHTwnokchR0+VadWHjo651Po=";
  };
  haproxy-2-2-24 = haproxy-pin {
    version = "2.2.24";
    sha256 = "sha256-DoBzENzjpSk9JFTZwbceuNFkcjBbZvB2s4S1CFix5/k=";
  };

  jellyfish = prev.jacobi.pog {
    name = "jellyfish";
    description = "";
    flags = [
      {
        name = "name";
        description = "the jellyfish name of this project/repo";
      }
      {
        name = "token";
        description = "the jellyfish token to use";
        envVar = "JELLYFISH_API_TOKEN";
      }
      {
        name = "deployedat";
        description = "";
        envVar = "CI_COMMIT_TIMESTAMP";
      }
      {
        name = "commit";
        description = "the commit hash we're reporting for";
        envVar = "CI_COMMIT_SHA";
      }
      {
        name = "url";
        description = "the repo url";
        envVar = "CI_REPOSITORY_URL";
      }
    ];
    script = helpers: ''
      payload=$(${prev.coreutils}/bin/mktemp)
      cat >"$payload" <<EOF
      {
        "reference_id": "Jellyfish DORA",
        "name": "$name",
        "deployed_at": "$deployedat",
        "repo_name": "$url",
        "commit_shas": ["$commit"]
      }
      EOF
      debug "payload at $payload"
      ${prev.curl}/bin/curl \
        -X POST \
        -H 'Content-Type: application/json' \
        -H "x-jf-api-token: $token" \
        --data "$(cat "$payload")" \
        https://webhooks.jellyfish.co/deployment
    '';
  };

  custom = [
    prospector-177
    haproxy-2-2-24
    haproxy-2-2-23
    jellyfish
  ];
}
