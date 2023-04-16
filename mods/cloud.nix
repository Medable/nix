final: prev:
with prev;
rec {
  coscli = prev.callPackage
    ({ stdenv, lib, buildGo120Module, fetchFromGitHub }:
      buildGo120Module rec {
        pname = "coscli";
        version = "0.13.0";

        src = fetchFromGitHub {
          owner = "tencentyun";
          repo = pname;
          rev = "v${version}-beta";
          sha256 = "sha256-G9RN07L26g81VA22sB+zG0PFYx6RvU9NuEpL7Hc0bOo=";
        };

        vendorHash = "sha256-B0gUj+10R2zCF2HlqqcVS5uxWv03+DVlETPMledwSho=";

        ldflags = [
          "-s"
          "-w"
        ];

        doCheck = false;

        meta = with lib; {
          description = "";
          homepage = "https://github.com/tencentyun/coscli";
          license = licenses.asl20;
          maintainers = with maintainers; [ jpetrucciani ];
        };
      }
    )
    { };

  gcsproxy = prev.callPackage
    ({ stdenv, lib, buildGo120Module, fetchFromGitHub }:
      buildGo120Module rec {
        pname = "gcsproxy";
        version = "0.3.2";

        src = fetchFromGitHub {
          owner = "daichirata";
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-yeAN2pFgakgqTM4/sq9sgVBJi2zL3qamHsKN3s+ntds=";
        };

        vendorHash = "sha256-Wsa9zPFE4q9yBxflovzkrzn0Jq1a4zlxc5jJOsl7HDQ=";

        meta = with lib; {
          inherit (src.meta) homepage;
          description = "Reverse proxy for Google Cloud Storage";
          license = licenses.mit;
          maintainers = with maintainers; [ jpetrucciani ];
        };
      }
    )
    { };

  custom = prev.custom // {
    inherit coscli gcsproxy;
  };
}
