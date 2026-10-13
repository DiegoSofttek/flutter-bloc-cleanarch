# Shared compilation settings helper for platform runner targets.
#
# The caller provides the target name, required C++ standard, compile options,
# and compile definitions so each platform can preserve its existing behavior
# while sharing the target configuration structure.
function(apply_standard_settings TARGET CXX_STANDARD COMPILE_OPTIONS COMPILE_DEFINITIONS)
  target_compile_features(${TARGET} PUBLIC cxx_std_${CXX_STANDARD})

  if(COMPILE_OPTIONS)
    target_compile_options(${TARGET} PRIVATE ${COMPILE_OPTIONS})
  endif()

  if(COMPILE_DEFINITIONS)
    target_compile_definitions(${TARGET} PRIVATE ${COMPILE_DEFINITIONS})
  endif()
endfunction()
