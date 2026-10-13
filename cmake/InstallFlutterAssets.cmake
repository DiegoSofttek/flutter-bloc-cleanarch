function(install_flutter_assets PROJECT_BUILD_DIR INSTALL_BUNDLE_DATA_DIR INSTALL_BUNDLE_LIB_DIR NATIVE_ASSETS_SUBDIR)
  # Copy the native assets provided by the build.dart from all packages.
  set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/${NATIVE_ASSETS_SUBDIR}/")
  install(DIRECTORY "${NATIVE_ASSETS_DIR}"
     DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
     COMPONENT Runtime)

  # Fully re-copy the assets directory on each build to avoid having stale files
  # from a previous install.
  set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
  install(CODE "
    file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
    " COMPONENT Runtime)
  install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}"
    DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)
endfunction()
