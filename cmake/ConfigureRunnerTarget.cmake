function(configure_runner_target TARGET)
  # Apply the standard set of build settings. This can be removed for applications
  # that need different build settings.
  apply_standard_settings(${TARGET})

  target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}")
endfunction()
