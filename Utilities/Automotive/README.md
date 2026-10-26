# Automotive CMake fork

Based on CMake 4.4.4. The intended repository is
`Joldiges/cmake_automotive`; changes remain local until explicitly approved.

The generic patches add a Diab version-string fallback for older compilers and
C/C++ compiler-generated dependencies. Product target/linker flags do not
belong in these patches. Upstream submissions go to Kitware GitLab after human
review under CMake's contribution policies.

## Local validation

Build CMake normally with an existing host CMake and Ninja:

```sh
cmake -S . -B ../cmake-build-automotive -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$HOME/git/cmake-install-automotive" \
  -DBUILD_TESTING=ON -DCMAKE_USE_OPENSSL=ON
cmake --build ../cmake-build-automotive --parallel 8
../cmake-build-automotive/bin/ctest --test-dir ../cmake-build-automotive \
  -R '^RunCMake.DiabCompilerId$' --output-on-failure
cmake --install ../cmake-build-automotive
```

Compiler-ID macro tests use ordinary native C/C++ compilers; no Diab license is
required. They cover old, modern, partial, and absent version macros.

Licensed dependency tests are opt-in. Set `DIAB_BIN` to the licensed compiler's
bin directory and `DIAB_TARGET` to the target text accepted after `-t`. Preserve
your organization's existing license environment. For example, on Linux:

```sh
export DIAB_BIN=/path/to/diab/bin
export DIAB_TARGET=your-target:cross
"$HOME/git/cmake-install-automotive/bin/cmake" \
  -DCMAKE_MODULE_PATH="$PWD/Tests/RunCMake" \
  -DRunCMake_GENERATOR=Ninja \
  -DRunCMake_SOURCE_DIR="$PWD/Tests/RunCMake/DiabDependencies" \
  -DRunCMake_BINARY_DIR="$HOME/git/diab-dependencies-ninja" \
  -DCMake_TEST_Diab_TOOLCHAIN_FILE="$PWD/Utilities/Automotive/diab-toolchain.cmake" \
  -P Tests/RunCMake/DiabDependencies/RunCMakeTest.cmake
```

Repeat with `"Ninja Multi-Config"` and `"Unix Makefiles"` using separate build
directories. The toolchain example uses static-library try-compiles rather
than forced compiler IDs/success flags. It is not a product linker toolchain.
Alternatively configure CMake's own tests with
`CMake_TEST_Diab_TOOLCHAIN_FILE` and run `RunCMake.DiabDependencies`.
Without that setting, licensed tests are not registered or claimed as passed.

## Native packages and publication

```sh
pixi exec --spec 'rattler-build=0.74.0' rattler-build build \
  --recipe conda.recipe/recipe.yaml -c conda-forge
```

The recipe builds from source on Linux and Windows, runs native compiler-ID
tests, and tests installed executables with a native C/C++ project. Linux uses
OpenSSL; Windows uses bundled curl's native Schannel TLS backend. It does not
package proprietary compilers or license data. Curses/Qt dialogs are omitted.

The package is named `cmake-automotive`, while the binaries and version remain
upstream-compatible `cmake`, `ctest`, `cpack`, and `4.4.4`. CI build strings
record the source commit and run number. Stock `cmake` is a build-only bootstrap
dependency; the runtime constraint prevents installing both providers.
Dependencies on a package literally named `cmake` are not satisfied by this
renaming and must be resolved explicitly.

Pull requests, pushes, and default manual runs build artifacts without upload
credentials. Publishing requires an explicitly approved manual run with
`publish=true`. Before enabling it:

1. Review the outgoing source and artifacts, approve the commit/push/upload,
   and establish the intended GitHub fork.
2. Create GitHub environment `prefix-publish` with required reviewers and
   suitable branch restrictions.
3. Register a Prefix.dev trusted publisher for channel
   `jamesoldiges/bobs-forge`, repository `Joldiges/cmake_automotive`,
   workflow `prefix.yml`, environment `prefix-publish`.
4. Review both native package results, then approve the publication environment.

Only the publication job receives `id-token: write`; no long-lived upload token
is needed. Package smoke tests on Windows do not qualify a proprietary Diab
toolchain or a product firmware build.
