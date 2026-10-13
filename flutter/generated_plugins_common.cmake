#
# Shared generated plugin helper, do not edit.
#

function(flutter_register_plugins PLATFORM_DIR)
  foreach(plugin ${FLUTTER_PLUGIN_LIST})
    add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/${PLATFORM_DIR} plugins/${plugin})
    target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
    list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
    list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
  endforeach(plugin)

  foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
    add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/${PLATFORM_DIR} plugins/${ffi_plugin})
    list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
  endforeach(ffi_plugin)

  set(PLUGIN_BUNDLED_LIBRARIES "${PLUGIN_BUNDLED_LIBRARIES}" PARENT_SCOPE)
endfunction()
