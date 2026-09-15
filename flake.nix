{
  description = "worker";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs =
    { self, nixpkgs }:
    let
      each = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      packages = each (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildGoModule {
            pname = "worker";
            version = "0.1.0";
            src = ./.;
            vendorHash = "sha256-mkdMPljkn+pfruuPBby+CjrpJxmOpWT7EFtIueZxRnc=";
            subPackages = [
              "cmd/worker"
              "cmd/agent-watch"
            ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postInstall = ''
              for command in worker agent-watch; do
                wrapProgram "$out/bin/$command" --prefix PATH : ${
                  pkgs.lib.makeBinPath [
                    pkgs.git
                    pkgs.wezterm
                    pkgs.zsh
                    pkgs.coreutils
                  ]
                }
              done
            '';
            nativeCheckInputs = [ pkgs.git ];
            checkPhase = "runHook preCheck; go test ./...; runHook postCheck";
            meta.mainProgram = "worker";
          };
        }
      );
      checks = each (system: {
        package = self.packages.${system}.default;
      });
      devShells = each (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.go
              pkgs.git
              pkgs.nixfmt
              pkgs.shellcheck
              pkgs.shfmt
              pkgs.python3
            ];
          };
        }
      );
      formatter = each (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "format";
          runtimeInputs = [ pkgs.nixfmt ];
          text = ''exec nixfmt "$@" flake.nix'';
        }
      );
    };
}
