if(NOT QV2RAY_PLATFORM_LIBS_BIN_PATH_PREFIX)
    set(QV2RAY_PLATFORM_LIBS_BIN_PATH_PREFIX ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX}/tools)
endif()

list(APPEND CMAKE_PROGRAM_PATH
    ${QV2RAY_PLATFORM_LIBS_BIN_PATH_PREFIX}/grpc/
    ${QV2RAY_PLATFORM_LIBS_BIN_PATH_PREFIX}/protobuf/
    ${QV2RAY_PLATFORM_LIBS_BIN_PATH_PREFIX}/openssl/
    )

message("CMAKE_PROGRAM_PATH=${CMAKE_PROGRAM_PATH}")

# From vcpkg
#If CMake does not have a mapping for MinSizeRel and RelWithDebInfo in imported targets
#it will map those configuration to the first valid configuration in CMAKE_CONFIGURATION_TYPES or the targets IMPORTED_CONFIGURATIONS.
#In most cases this is the debug configuration which is wrong.
if(NOT DEFINED CMAKE_MAP_IMPORTED_CONFIG_MINSIZEREL)
    set(CMAKE_MAP_IMPORTED_CONFIG_MINSIZEREL "MinSizeRel;Release;")
    message(STATUS "CMAKE_MAP_IMPORTED_CONFIG_MINSIZEREL set to MinSizeRel;Release;")
endif()
if(NOT DEFINED CMAKE_MAP_IMPORTED_CONFIG_RELWITHDEBINFO)
    set(CMAKE_MAP_IMPORTED_CONFIG_RELWITHDEBINFO "RelWithDebInfo;Release;")
    message(STATUS "CMAKE_MAP_IMPORTED_CONFIG_RELWITHDEBINFO set to RelWithDebInfo;Release;")
endif()

QVLOG(QV2RAY_PLATFORM_LIBS_PATH_PREFIX)
if(CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$" OR NOT DEFINED CMAKE_BUILD_TYPE)
    # Debug build: Put Debug paths before Release paths.
    list(APPEND CMAKE_PREFIX_PATH
        ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX}/debug
        ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX}
        )
    link_directories(
        ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX}/debug/lib
        ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX}/lib
        )
    list(APPEND CMAKE_FIND_ROOT_PATH
        ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX}/debug
        ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX}
        )
else()
    # Release build: Put Release paths before Debug paths.
    # Debug Paths are required so that CMake generates correct info in autogenerated target files.
    list(APPEND CMAKE_PREFIX_PATH ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX})
    link_directories(${QV2RAY_PLATFORM_LIBS_PATH_PREFIX}/lib)
    list(APPEND CMAKE_FIND_ROOT_PATH ${QV2RAY_PLATFORM_LIBS_PATH_PREFIX})
endif()
