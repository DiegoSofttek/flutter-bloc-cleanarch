function(apply_shared_standard_settings TARGET STD_VERSION)
  target_compile_features(${TARGET} PUBLIC ${STD_VERSION})
endfunction()

function(configure_runner_target_include_dir TARGET)
  target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}")
endfunction()
