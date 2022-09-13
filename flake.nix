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

      nativeOverlay = f: p: {
        scala-cli-native = p.symlinkJoin
          {
            name = "scala-cli-native";
            paths = [ p.scala-cli ];
            buildInputs = [ p.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/scala-cli \
              --prefix LLVM_BIN : "${p.llvmPackages.clang}/bin" \
              --add-flags "package --native"
            '';
          };
      };

      forSystem = system:
        let

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ jreOverlay nativeOverlay ];
          };

          labApp = pkgs.writeShellScriptBin "scala-lab-app" ''
            ${pkgs.scala-cli}/bin/scala-cli run main.scala
          '';

          nativeApp = pkgs.writeShellScriptBin "scala-native-app" ''
            ${pkgs.scala-cli-native}/bin/scala-cli hello.scala -- --no-fallback
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

          packages = rec {
            lab = labApp;
            native = nativeApp;

            default = lab;
          };
        };
    in
    flake-utils.lib.eachDefaultSystem forSystem;
}
