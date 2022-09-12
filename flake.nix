{
  description = "Scala Lab development flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      jreOverlay = f: p: {
        jre = p.jdk17_headless;
      };

      forSystem = system:
        let

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ jreOverlay ];
          };

          app = pkgs.writeShellScriptBin "scala-lab-app" ''
            ${pkgs.scala-cli}/bin/scala-cli run .
          '';
        in
        {
          devShells.default = pkgs.mkShell {
            name = "scala-lab-dev-shell";
            buildInputs = with pkgs; [ jre scala-cli ];
            shellHook = ''
              JAVA_HOME="${pkgs.jre}"
            '';
          };

          packages.default = app;
        };
    in
    flake-utils.lib.eachDefaultSystem forSystem;
}
