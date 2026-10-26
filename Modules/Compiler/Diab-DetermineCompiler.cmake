# Diab Toolchain. Works only for versions 5.9.x or higher.
set(_compiler_id_pp_test "defined(__DCC__) && defined(_DIAB_TOOL)")

set(_compiler_id_version_compute "
  # if defined(__VERSION_MAJOR_NUMBER__) && defined(__VERSION_MINOR_NUMBER__) \\
    && defined(__VERSION_ARCH_FEATURE_NUMBER__) && defined(__VERSION_BUG_FIX_NUMBER__)
  #  define @PREFIX@COMPILER_VERSION_MAJOR @MACRO_DEC@(__VERSION_MAJOR_NUMBER__)
  #  define @PREFIX@COMPILER_VERSION_MINOR @MACRO_DEC@(__VERSION_MINOR_NUMBER__)
  #  define @PREFIX@COMPILER_VERSION_PATCH @MACRO_DEC@(__VERSION_ARCH_FEATURE_NUMBER__)
  #  define @PREFIX@COMPILER_VERSION_TWEAK @MACRO_DEC@(__VERSION_BUG_FIX_NUMBER__)
  # elif defined(__VERSION__)
  #  define @PREFIX@COMPILER_VERSION __VERSION__
  # endif
"
)
