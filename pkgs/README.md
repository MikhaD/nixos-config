# My Modules

- [e](./e/README.md): Utility to print the value of the specified environment variable (with case insensitive bash completions).
- [tat](./tat/README.md): Utility to improve navigation between tmux sessions.

<!-- - Instructions on creating new derivations

## Useful info
`$src` and `$out` are special variables available during the build, accessible within the different phases.

`$src`is the directory that the src downloader (like fetchFromGitHub) downloads the source code to.

`$out` is the directory where the final build result should be placed. This is usually `/nix/store/<hash>-<pname>-<version>`. This is the same thing returned by the mkDerivation function (or any of its specific wrappers).

files in `$out/bin` are placed on the users $PATH
files in `$out/lib` are placed on the users $LD_LIBRARY_PATH


## TODO Clean this up and make it into a proper doc
https://nixos.org/manual/nixpkgs/stable/#ssec-stdenv-dependencies
Here are all the phases that mkDerivation goes through, in order:

1. unpackPhase
Directory: /build/
Purpose: Extract/copy source code
Variables: $src, $srcs (if multiple sources)
What happens: Extracts tarballs, copies directories from $src to current directory
Controls: unpackPhase, dontUnpack, sourceRoot, setSourceRoot
2. patchPhase
Directory: /build/<source-root>/ (usually /build/source/)
Purpose: Apply patches to source code
Variables: $src, $out (created but empty)
What happens: Applies patches from patches attribute
Controls: patchPhase, dontPatch, patches, patchFlags
3. updateAutotoolsGnuConfigScriptsPhase
Directory: Same as patchPhase
Purpose: Update autotools config scripts for newer architectures
Controls: dontUpdateAutotoolsGnuConfigScripts
4. configurePhase
Directory: Same (usually /build/source/)
Purpose: Configure the build (./configure, cmake, etc.)
Variables: $src, $out, $dev, $bin, etc. (all outputs)
What happens: Runs ./configure, cmake, or custom configuration
Controls: configurePhase, dontConfigure, configureScript, configureFlags, cmakeFlags
5. buildPhase
Directory: Same
Purpose: Compile/build the software
Variables: All previous + build-time dependencies in $PATH
What happens: Runs make, ninja, go build, etc.
Controls: buildPhase, dontBuild, makeFlags, buildFlags, enableParallelBuilding
6. checkPhase
Directory: Same
Purpose: Run tests
Variables: Same as buildPhase
What happens: Runs make check, go test, etc.
Controls: checkPhase, dontCheck, checkFlags, doCheck
7. installPhase
Directory: Same
Purpose: Install built software to output directories
Variables: $out, $bin, $dev, $doc, etc. (writable output directories)
What happens: Runs make install, copies files to $out
Controls: installPhase, dontInstall, installFlags, makeInstallFlags
8. fixupPhase
Directory: Works on $out and other output directories
Purpose: Fix up installed files (strip binaries, fix RPATHs, etc.)
Variables: All outputs
What happens: Strips binaries, fixes library paths, removes references
Controls: fixupPhase, dontFixup, dontStrip, dontPatchELF
9. installCheckPhase
Directory: Same as fixupPhase
Purpose: Test the installed software
Controls: installCheckPhase, dontInstallCheck, doInstallCheck
10. distPhase
Directory: Same
Purpose: Create distribution tarballs
Controls: distPhase, dontDist, distFlags
Special Variables Available
Source Variables:
$src: Primary source directory/file
$srcs: Array of multiple sources
$sourceRoot: Root directory of unpacked source
Output Variables:
$out: Primary output directory (always available)
$bin: Binary output (if outputs = ["out" "bin"])
$dev: Development files output
$doc: Documentation output
$man: Manual pages output
$lib: Library files output
Build Environment:
$stdenv: Standard environment
$system: Target system (e.g., "x86_64-linux")
$pname: Package name
$version: Package version
$name: Usually ${pname}-${version}
Phase Control:
$prePhase, $postPhase: Hooks run before/after each phase
$phases: List of phases to run -->