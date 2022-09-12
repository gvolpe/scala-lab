# scala-lab

Playground for Scala 3's experimental features.

## Usage 

There's only one application named [main.scala](./main.scala) that can be run as follows.

```console 
$ nix run
Compiling project (Scala 3.2.2-RC1-bin-20220910-ac6cd1c-NIGHTLY, JVM)
Compiled project (Scala 3.2.2-RC1-bin-20220910-ac6cd1c-NIGHTLY, JVM)
some-output
```

If [Nix](https://nixos.org/) is not your jam, you can replace `nix run` by `scala-cli run .` (it requires both [scala-cli](https://scala-cli.virtuslab.org/) and a JDK installed).
