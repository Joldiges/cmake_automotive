@echo off
cmake -S . -B automotive-build -G Ninja %CMAKE_ARGS% ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_USE_SYSTEM_LIBRARIES=OFF ^
  -DCMAKE_USE_OPENSSL=OFF ^
  -DBUILD_CursesDialog=OFF ^
  -DBUILD_QtDialog=OFF ^
  -DBUILD_TESTING=ON
if errorlevel 1 exit /b 1
cmake --build automotive-build --parallel %CPU_COUNT%
if errorlevel 1 exit /b 1
automotive-build\bin\ctest.exe --test-dir automotive-build -R "^RunCMake.DiabCompilerId$" --output-on-failure
if errorlevel 1 exit /b 1
cmake --install automotive-build
if errorlevel 1 exit /b 1
