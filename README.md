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

### Scala Native app 

There's also a little example of creating a native binary via [Scala Native](https://www.scala-native.org/en/latest/).

```console
$ nix run .#native
[info] Linking (1460 ms)
[info] Discovered 665 classes and 3691 methods
[info] Optimizing (debug mode) (1016 ms)
[info] Generating intermediate code (859 ms)
[info] Produced 16 files
[info] Compiling to native code (512 ms)
[info] Linking native code (immix gc, none lto) (142 ms)
[info] Total (4063 ms)
Wrote /home/gvolpe/workspace/scala-lab/hello, run it with
  ./hello

./hello
Hello, Scala Native!
```
