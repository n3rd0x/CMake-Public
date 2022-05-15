# ************************************************************
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ************************************************************




# ************************************************************
# Copy Binaries from Target
# ************************************************************
macro(CM_PACKAGE_ADD_RUNTIME_TARGET SrcFile Path)
    # TST 2014-09-19
    # We assume that the source file do exists.
    # This would increase the processing speed.

    # Find the existence of the source.
    get_filename_component(_filename ${SrcFile} NAME)
    #get_filename_component(_path ${SrcFile} PATH)
    #find_file(_found NAMES ${_filename} HINTS ${_path})
    #if(_found)
        # Add command.
        add_custom_command(
            TARGET ALL_CopyRuntime
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${SrcFile}
            "${Path}/${_filename}"
        )
        cm_message_verbose(STATUS "Adding [${SrcFile}] to [${Path}] in ALL_CopyRuntime target.")
    #else()
    #    cm_message_status("" "Failed to locate: ${SrcFile}")
    #endif()

    #unset(_found CACHE)
    unset(_filename)
    #unset(_path)
endmacro()




# ************************************************************
# Add parent directory
# Ex: /usr/include/json -> /usr/include
# TODO: Deprecated
macro(PACKAGE_ADD_PARENT_DIR Prefix)
    # Help information.
    cm_message_header(PACKAGE_ADD_PARENT_DIR)
    cm_message_help("Required:")
    cm_message_help("[Prefix]      -> Prefix of the variable to process.")
    cm_message_help("Optional:")
    cm_message_help("ADD_PARENT    -> Flag to add parent directory.")
    #cm_message_help("[Suffixes]    -> Suffixes to process.")

    if(${Prefix}_FOUND)
        # Parse options.
        set(options)
        #set(multiValueArgs Suffixes)
        cmake_parse_arguments(PACKAGE_ADD_PARENT_DIR "${options}" "" "" ${ARGN})

        #foreach(Var ${PACKAGE_ADD_PARENT_DIR_Suffixes})
        #    string(REGEX MATCH "/${Var}" ValueFound "${${Prefix}_INCLUDE_DIR}")
        #    if(ValueFound)
        #        string(REGEX REPLACE "/${Var}" "" PathParent "${${Prefix}_INCLUDE_DIR}")
        #        if(PACKAGE_ADD_PARENT_DIR_ONLY_PARENT)
        #            set(${Prefix}_INCLUDE_DIR ${PathParent})
        #        else()
        #            set(${Prefix}_INCLUDE_DIR ${PathParent} ${${Prefix}_INCLUDE_DIR})
        #        endif()
        #        unset(PathParent)
        #    endif()
        #endforeach()
        set(PathCpy ${${Prefix}_INCLUDE_DIR})
        get_filename_component(Path "${PathCpy}" PATH)
        if(PACKAGE_ADD_PARENT_DIR_ADD_PARENT)
            set(${Prefix}_INCLUDE_DIR ${Path} ${${Prefix}_INCLUDE_DIR})
        else()
            set(${Prefix}_INCLUDE_DIR ${${Prefix}_INCLUDE_DIR})
        endif()
    endif()

    #unset(ValueFound)
    unset(options)
    #unset(multiValueArgs)
    unset(PACKAGE_ADD_PARENT_DIR_ADD_PARENT)
    #unset(PACKAGE_ADD_PARENT_DIR_Suffixes)
    unset(Path CACHE)
    unset(PathCpy)

    cm_message_footer(PACKAGE_ADD_PARENT_DIR)
endmacro()




# ************************************************************
# Append names
macro(PACKAGE_APPEND_NAMES Prefix Name)
    cm_message_verbose(STATUS "Append ${Name} to ${Prefix}.")

    set(NewNames "")
    foreach(Var ${${Prefix}})
        set(NewNames ${NewNames} "${Var}${Name}")
    endforeach()

    set(${Prefix} "${NewNames}")
    unset(NewNames)
    cm_message_debug(STATUS "Append names: ${${Prefix}}")
endmacro()




# ************************************************************
# Append SubPaths
# ************************************************************
macro(PACKAGE_APPEND_PATHS Prefix SubPaths)
    # Append paths into current.
    foreach(dir ${${Prefix}})
        foreach(path ${SubPaths})
            list(APPEND ${Prefix}
                "${dir}/${path}"
            )
        endforeach()
        unset(path)
    endforeach()
    unset(dir)
endmacro()




# ************************************************************
# Begin the Package
# ************************************************************
macro(CM_PACKAGE_BEGIN Prefix)
    cm_message_status(STATUS "Looking for the ${Prefix} library.")
endmacro()




# ************************************************************
# Create binary names
macro(PACKAGE_CREATE_BINARY_NAMES Prefix)
    cm_message_verbose(STATUS "Creating binary names ${${Prefix}}.")
    cm_generate_dynamic_extension(_suffix)

    foreach(name ${${Prefix}})
        set(${Prefix} ${${Prefix}} "${name}.${_suffix}")
    endforeach()

    unset(_suffix)
    cm_message_debug(STATUS "Binary names: ${${Prefix}}")
endmacro()




# ************************************************************
# Copy Binaries
# ************************************************************
macro(CM_PACKAGE_COPY_BINARY Prefix)
    # Copy debug runtime files.
    if(${Prefix}_BINARY_DEBUG)
        foreach(file ${${Prefix}_BINARY_DEBUG})
            # Get the file name.
            get_filename_component(_filename ${file} NAME)

            # Copy into output directory.
            cm_copy_single_file(${file} "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${_filename}" "COPYONLY")

            # Clean up.
            unset(_filename)
        endforeach()
    endif()

    # Copy release runtime files.
    if(${Prefix}_BINARY_RELEASE)
        foreach(file ${${Prefix}_BINARY_RELEASE})
            # Get the file name.
            get_filename_component(_filename ${file} NAME)

            # Copy into output directory.
            cm_copy_single_file(${file} "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${_filename}" "COPYONLY")

            # Clean up.
            unset(_filename)
        endforeach()
    endif()
endmacro()




# ************************************************************
# Copy Binaries from Target
# ************************************************************
macro(CM_PACKAGE_COPY_BINARY_FROM_TARGET Prefix)
    # Set debug runtime files.
    if(${Prefix}_BINARY_DEBUG)
        foreach(file ${${Prefix}_BINARY_DEBUG})
            cm_package_add_runtime_target(${file} "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
        endforeach()
    endif()


    # Set release runtime files.
    if(${Prefix}_BINARY_RELEASE)
        foreach(file ${${Prefix}_BINARY_RELEASE})
            cm_package_add_runtime_target(${file} "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
        endforeach()
    endif()
endmacro()




# ************************************************************
# Clear if Changed
# ************************************************************
macro(CM_PACKAGE_CLEAR_IF_CHANGED TestVar)
    if(NOT "${${TestVar}}" STREQUAL "${${TestVar}_INT_CHECK}")
        cm_message_verbose(STATUS "${TestVar} changed.")

        # Reset variables.
        foreach(var ${ARGN})
            #set(${var} "${var}-NOTFOUND" CACHE STRING "" FORCE)
            unset(${var} CACHE)
        endforeach()
    endif()
    set(${TestVar}_INT_CHECK ${${TestVar}} CACHE INTERNAL ${TestVar} FORCE)
endmacro()




# ************************************************************
# Create binary names
macro(PACKAGE_CREATE_BINARY_NAMES Input)
    cm_message_verbose(STATUS "Creating binary names of ${${Input}}.")

    set(Names ${${Input}})
    set(${Input} "")
    cm_generate_dynamic_extension(_suffix)

    foreach(name ${Names})
        set(${Input} ${${Input}} "${name}.${_suffix}")
    endforeach()

    unset(Names)
    unset(_suffix)
endmacro()




# ************************************************************
# Create Home Path
# ************************************************************
macro(CM_PACKAGE_CREATE_HOME_PATH Prefix EnvPrefix)
    if(NOT DEFINED ${Prefix}_HOME)
        cm_message_verbose(STATUS "${Prefix}_HOME doesn't exists.")
        cm_message_verbose(STATUS "Looking for ${EnvPrefix} environment variable.")
        cm_package_get_environment_path(${Prefix} ${EnvPrefix})

        if(${Prefix}_ENV_${EnvPrefix})
            cm_message_verbose(STATUS "Set ${EnvPrefix} as ${Prefix}_HOME (${${Prefix}_ENV_${EnvPrefix}}).")
            set(${Prefix}_HOME "${${Prefix}_ENV_${EnvPrefix}}"
                CACHE PATH "Path to ${Prefix} directory."
            )
        else()
            cm_message_verbose(STATUS "Creating an empty ${Prefix}_HOME.")
            set(${Prefix}_HOME "" CACHE PATH "Path to ${Prefix} directory.")
        endif()
    endif()
endmacro()




# ************************************************************
# Create prefix as sub directory
# ************************************************************
macro(PACKAGE_CREATE_PREFIX_SUBPATH Output Prefix)
    # Example: c:/ogre/include
    # Assume that Prefix is Ogre.
    # This will generate the following lines:
    # c:/ogre/include/Ogre
    # c:/ogre/include/OGRE
    # c:/ogre/include/ogre
    string(TOUPPER ${Prefix} Uppercase)
    string(TOLOWER ${Prefix} Lowercase)
    foreach(var ${${Output}})
        list(APPEND ${Output}
            "${var}/${Prefix}"
            "${var}/${Uppercase}"
            "${var}/${Lowercase}"
      )
    endforeach()

    # Clean up.
    unset(Uppercase)
    unset(Lowercase)
    unset(Var)
endmacro()


# ************************************************************
# NB! Using the macro for creating search paths:
# The user must create manually create ${PREFIX}_PREFIX_PATH
# Ex: set(OGRE_PREFIX_PATH "/opt/sdk/ogre")


# ************************************************************
# Create Search Binary Path
# ************************************************************
macro(CM_PACKAGE_CREATE_SEARCH_PATH_BINARY Prefix)
    cm_message_verbose(STATUS "Creating ${Prefix} binary search path.")

    set(_vars "bin" "Bin" "binary" "Binary" "dll" "DLL")

    # Create search for "default" directories.
    foreach(dir ${${Prefix}_PREFIX_PATH})
        foreach(var ${_vars})
            list(APPEND ${Prefix}_SEARCH_PATH_BINARY
                "${dir}/${var}"
                "${dir}/${var}/debug"
                "${dir}/${var}/release"
                "${dir}/debug/${var}"
                "${dir}/release/${var}"
            )
        endforeach()
    endforeach()

    unset(_vars)
    #cm_message_debug(STATUS "Search binary paths:")
    #cm_message_debug_output(STATUS "${${Prefix}_SEARCH_PATH_BINARY}")
endmacro()




# ************************************************************
# Create Search Include Path
# ************************************************************
macro(CM_PACKAGE_CREATE_SEARCH_PATH_INCLUDE Prefix)
    cm_message_verbose(STATUS "Creating ${Prefix} include search path.")

    # Create search for "default" directories.
    foreach(dir ${${Prefix}_PREFIX_PATH})
        list(APPEND ${Prefix}_SEARCH_PATH_INCLUDE
            "${dir}/inc"
            "${dir}/Inc"
            "${dir}/include"
            "${dir}/Include"
            "${dir}/Headers"
        )
    endforeach()

    # Add system directories.
    if(APPLE)
        foreach(name ${${Prefix}_PREFIX_NAMES})
            list(APPEND ${Prefix}_SEARCH_PATH_INCLUDE
                "/Library/Frameworks/${name}.framework/Headers"
            )
            list(APPEND ${Prefix}_SEARCH_PATH_INCLUDE
                "/Library/Frameworks/${name}.framework/Version/Current/Headers"
            )
            list(APPEND ${Prefix}_SEARCH_PATH_INCLUDE
                "/Library/Frameworks/${name}.framework/Version/Current/include"
            )
        endforeach()
    endif()

    if(UNIX)
        list(APPEND ${Prefix}_SEARCH_PATH_INCLUDE
            "/usr/include"
            "/usr/local/include"
            "/opt/local/include"
        )
    endif()

    #cm_message_debug(STATUS "Search include paths:")
    #cm_message_debug_output(STATUS "${${Prefix}_SEARCH_PATH_INCLUDE}")
endmacro()




# ************************************************************
# Create Search Library Path
# ************************************************************
macro(CM_PACKAGE_CREATE_SEARCH_PATH_LIBRARY Prefix)
    cm_message_verbose(STATUS "Creating ${Prefix} library search path.")


    set(_vars "lib" "Lib" "library" "Library" "Libraries" "dll" "DLL")

    # Create search for "default" directories.
    foreach(dir ${${Prefix}_PREFIX_PATH})
        foreach(var ${_vars})
            list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
                "${dir}/${var}"
                "${dir}/${var}/debug"
                "${dir}/${var}/release"
                "${dir}/debug/${var}"
                "${dir}/release/${var}"
            )
        endforeach()
    endforeach()
    unset(_vars)

    # Add system directories.
    if(APPLE)
        list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
            "/Library/Frameworks"
            "/System/Library"
        )
        foreach(name ${${Prefix}_PREFIX_NAMES})
            list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
                "/Library/Frameworks/${name}.framework/Libraries"
            )
            list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
                "/Library/Frameworks/${name}.framework/Version/Current/Libraries"
            )
            list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
                "/Library/Frameworks/${name}.framework/Version/Current/lib"
            )
        endforeach()
    endif()

    if(UNIX)
        list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
            "/usr/lib"
            "/usr/local/lib"
            "/opt/local/lib"
        )
    endif()

    if(UNIX AND NOT APPLE)
        list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
            "/usr/lib/arm-linux-gnueabihf"
            "/usr/lib/aarch64-linux-gnu"
            "/usr/lib/i386-linux-gnu"
            "/usr/lib/x86_64-linux-gnu"
        )
    endif()

    #cm_message_debug(STATUS "Search binary paths:")
    #cm_message_debug_output(STATUS "${${Prefix}_SEARCH_PATH_LIBRARY}")
endmacro()





# ************************************************************
# Create search media path
macro(PACKAGE_CREATE_SEARCH_PATH_MEDIA Prefix)
    cm_message_verbose(STATUS "Creating ${Prefix} media search path.")

    foreach(dir ${${Prefix}_PREFIX_PATH})
        list(APPEND ${Prefix}_SEARCH_PATH_MEDIA
            "${dir}/media"
            "${dir}/Media"
        )
    endforeach()

    #cm_message_debug(STATUS "Search media paths:")
    #cm_message_debug_output(STATUS "${${Prefix}_SEARCH_PATH_MEDIA}")
endmacro()




# ************************************************************
# Create search plug-in path
macro(PACKAGE_CREATE_SEARCH_PATH_PLUGIN Prefix)
    cm_message_verbose(STATUS "Creating ${Prefix} plugin search path.")

    set(_vars "bin" "Bin" "binary" "Binary" "dll" "DLL" "plugin" "Plugin" "plugins" "Plugins")

    # Create search for "default" directories.
    foreach(dir ${${Prefix}_PREFIX_PATH})
        foreach(var ${_vars})
            list(APPEND ${Prefix}_SEARCH_PATH_PLUGIN
                "${dir}/${var}"
                "${dir}/${var}/debug"
                "${dir}/${var}/release"
                "${dir}/debug/${var}"
                "${dir}/release/${var}"
            )
        endforeach()
    endforeach()
    unset(_vars)

    #cm_message_debug(STATUS "Search plugin paths:")
    #cm_message_debug_output(STATUS "${${Prefix}_SEARCH_PATH_PLUGIN}")
endmacro()




# ************************************************************
# Create Debug Names
# ************************************************************
macro(CM_PACKAGE_CREATE_DEBUG_NAMES Prefix)
    cm_message_verbose(STATUS "Creating debug names of ${${Prefix}}.")

    foreach(name ${${Prefix}})
        list(APPEND ${Prefix}_DEBUG
             "${name}d"
             "${name}D"
             "${name}-d"
             "${name}_d"
             "${name}_D"
             "${name}_debug"
             "${name}"
        )
    endforeach()

    #cm_message_debug(STATUS "Debug names:")
    #cm_message_debug_output(STATUS "${${Prefix}_DEBUG}")
endmacro()




# ************************************************************
# Create Debug Binary Names
# ************************************************************
macro(CM_PACKAGE_CREATE_DEBUG_BINARY_NAMES Prefix)
    cm_message_verbose(STATUS "Creating debug binary names of ${${Prefix}}.")
    cm_generate_dynamic_extension(_suffix)

    foreach(name ${${Prefix}})
        list(APPEND ${Prefix}_DEBUG
             "${name}d.${_suffix}"
             "${name}D.${_suffix}"
             "${name}-d.${_suffix}"
             "${name}_d.${_suffix}"
             "${name}_D.${_suffix}"
             "${name}_debug.${_suffix}"
             "${name}.${_suffix}"
      )
    endforeach()

    unset(_suffix)
    #cm_message_debug(STATUS "Debug binary names:")
    #cm_message_debug_output(STATUS "${${Prefix}_DEBUG}")
endmacro()




# ************************************************************
# Create debug framework names
# ************************************************************
macro(CM_PACKAGE_CREATE_DEBUG_FRAMEWORK_NAMES Prefix)
    cm_message_verbose(STATUS "Creating debug framework names of ${${Prefix}}.")
    foreach(name ${${Prefix}})
        set(${Prefix}_DEBUG
             ${${Prefix}_DEBUG}
             "${name}d.framework"
             "${name}D.framework"
             "${name}-d.framework"
             "${name}_d.framework"
             "${name}_D.framework"
             "${name}_debug.framework"
             "${name}.framework"
      )
    endforeach()

    #cm_message_debug(STATUS "Debug framework names:")
    #cm_message_debug_output(STATUS "${${Prefix}_DEBUG}")
endmacro()




# ************************************************************
# Create Release Binary Names
# ************************************************************
macro(CM_PACKAGE_CREATE_RELEASE_BINARY_NAMES Prefix)
    cm_message_verbose(STATUS "Creating release binary names ${${Prefix}}.")
    cm_generate_dynamic_extension(_suffix)

    foreach(name ${${Prefix}})
        set(${Prefix}_RELEASE
             ${${Prefix}_RELEASE}
             "${name}.${_suffix}"
      )
    endforeach()

    unset(_suffix)
    cm_message_debug(STATUS "Release binary names:")
    cm_message_debug_output(STATUS "${${Prefix}_RELEASE}")
endmacro()




# ************************************************************
# Create Eelease Framework Names
# ************************************************************
macro(CM_PACKAGE_CREATE_RELEASE_FRAMEWORK_NAMES Prefix)
    cm_message_verbose(STATUS "Creating release framework names of ${${Prefix}}.")
    foreach(name ${${Prefix}})
        set(${Prefix}_RELEASE
             ${${Prefix}_RELEASE}
             "${name}.framework"
        )
    endforeach()

    cm_message_debug(STATUS "Release framework names:")
    cm_message_debug_output(STATUS "${${Prefix}_RELEASE}")
endmacro()




# ************************************************************
# Create Statical Names
# ************************************************************
macro(CM_PACKAGE_CREATE_STATICAL_NAMES Prefix)
    cm_message_verbose(STATUS "Creating statical names ${${Prefix}}.")

    foreach(name ${${Prefix}})
        set(${Prefix}
            "${name}-i"
            "${name}s"
            "${name}S"
            "${name}-s"
            "${name}_static"
            "${name}_Static"
            "${name}_s"
            "${name}_S"
            "${name}LibStatic"
            "${name}libstatic"
            ${${Prefix}}
      )
    endforeach()

    cm_message_debug(STATUS "Statical names:")
    cm_message_debug_output(STATUS "${${Prefix}_RELEASE}")
endmacro()




# ************************************************************
# Create versional names
macro(PACKAGE_CREATE_VERSIONAL_NAMES Var Versions)
    cm_message_header_debug("PACKAGE_CREATE_VERSIONAL_NAMES")
    cm_message_verbose(STATUS "Creating versional names of ${${Var}}.")

    # Each version will be added to the name.
    foreach(name ${${Var}})
        foreach(v ${Versions})
            # Split into major, minor, patch and tweak numbers.
            cm_message_debug("" "----------------------------------------")
            cm_message_debug("" "Version: ${v} (source)")

            string(REGEX MATCHALL "[0-9]+" components ${v})
            cm_message_debug("" "Components: ${components}")

            list(LENGTH components length)
            cm_message_debug("" "Length: ${length}")

            # Whole version.
            set(Version "")

            # Major version.
            if(${length} GREATER 0)
                list(GET components 0 MajorVersion)
                set(Version "${MajorVersion}")
                cm_message_debug("" "Major: ${MajorVersion}")
            endif()

            # Minor version.
            if(${length} GREATER 1)
                list(GET components 1 MinorVersion)
                set(Version "${Version}${MinorVersion}")
                cm_message_debug("" "Minor: ${MinorVersion}")
            endif()

            # Path version.
            if(${length} GREATER 2)
                list(GET components 2 PatchVersion)
                set(Version "${Version}${PatchVersion}")
                cm_message_debug("" "Patch: ${PatchVersion}")
            endif()

            # Tweak version.
            if(${length} GREATER 3)
                list(GET components 3 TweakVersion)
                set(Version "${Version}${TweakVersion}")
                cm_message_debug("" "Tweak: ${TweakVersion}")
            endif()

            cm_message_debug("" "Version: ${Version}")

            set(nName "${name}${v}")
            if(${length} GREATER 1)
                set(nName "${nName}" "${name}${Version}")
            endif()

            set(${Var}
                ${nName}
                ${${Var}}
          )
            cm_message_debug("" "Adding: ${name}${v} and ${name}${Version}")

            cm_message_debug("" "----------------------------------------")

            unset(components)
            unset(length)
            unset(MajorVersion)
            unset(MinorVersion)
            unset(PatchVersion)
            unset(TweakVersion)
            unset(Version)
            unset(nName)
        endforeach()

    endforeach()
    cm_message_debug("" "Final: ${${Var}}")
    message_footer_debug("PACKAGE_CREATE_VERSIONAL_NAMES")
endmacro()




# ************************************************************
# Display Library
# ************************************************************
macro(CM_PACKAGE_DISPLAY_LIBRARY Libraries)
    foreach(lib ${Libraries})
        if(NOT ${lib} STREQUAL "optimized" AND NOT ${lib} STREQUAL "debug")
            cm_message_verbose(STATUS "  [*] ${lib}")
        else()
            cm_message_verbose(STATUS "[${lib}]")
        endif()
    endforeach()
endmacro()




# ************************************************************
# End the Package
# ************************************************************
macro(CM_PACKAGE_END Prefix)
    if(${Prefix}_FOUND)
        cm_message_verbose(STATUS "${Prefix} libraries:")
        cm_package_display_library("${${Prefix}_LIBRARIES}")
        cm_message_verbose(STATUS "${Prefix} includes:")
        cm_message_verbose_output(STATUS "${${Prefix}_INCLUDE_DIR}")
        cm_message_status(STATUS "The ${Prefix} library is located.")
    else()
        cm_message_status("" "Failed to locate the ${Prefix} library.")
    endif()
endmacro()




# ************************************************************
# Find File
# ************************************************************
macro(CM_PACKAGE_FIND_FILE Prefix SearchName SearchPath Suffixes)
    cm_message_sub_header("Package Find File (${Prefix})")
    cm_message_debug(STATUS "Search names:")
    cm_message_debug_output(STATUS "${SearchName}")
    cm_message_debug(STATUS "Search path:")
    cm_message_debug_output(STATUS "${SearchPath}")
    cm_message_debug(STATUS "Suffixes:")
    cm_message_debug_output(STATUS "${Suffixes}")

    find_file(${Prefix} NAMES ${SearchName} HINTS ${SearchPath} PATH_SUFFIXES ${Suffixes} NO_DEFAULT_PATH)
    if(${Prefix})
        cm_message_verbose(STATUS "Found file: ${${Prefix}}")
    else()
        cm_message_verbose("" "Failed to locate one of these files: ${SearchName}")
    endif()

    cm_message_sub_footer("Package Find File (${Prefix})")
endmacro()






# ************************************************************
# Find Library
# ************************************************************
macro(CM_PACKAGE_FIND_LIBRARY Prefix SearchName SearchPath Suffixes)
    cm_message_sub_header("Package Find Library (${Prefix})")
    cm_message_debug(STATUS "Searching files:")
    cm_message_debug_output(STATUS "${Files}")
    cm_message_debug(STATUS "Names:")
    cm_message_debug_output(STATUS "${SearchName}")
    cm_message_debug(STATUS "Search path:")
    cm_message_debug_output(STATUS "${SearchPath}")
    cm_message_debug(STATUS "Suffixes:")
    cm_message_debug_output(STATUS "${Suffixes}")

    find_library(${Prefix} NAMES ${SearchName} HINTS ${SearchPath} PATH_SUFFIXES ${Suffixes} NO_DEFAULT_PATH)
    if(${Prefix})
        cm_message_verbose(STATUS "Found library: ${${Prefix}}")
    else()
        cm_message_verbose("" "Failed to locate one of these files: ${SearchName}")
    endif()

    cm_message_sub_footer("Package Find Library (${Prefix})")
endmacro()



# ************************************************************
# Find directory
# ************************************************************
macro(CM_PACKAGE_FIND_PATH Prefix Files SearchPath Suffixes)
    cm_message_sub_header("Package Find Path (${Prefix})")
    cm_message_debug(STATUS "Files:")
    cm_message_debug_output(STATUS "${Files}")
    cm_message_debug(STATUS "Search path:")
    cm_message_debug_output(STATUS "${SearchPath}")
    cm_message_debug(STATUS "Suffixes:")
    cm_message_debug_output(STATUS "${Suffixes}")

    find_path(${Prefix} NAMES ${Files} HINTS ${SearchPath} PATH_SUFFIXES ${Suffixes} NO_DEFAULT_PATH)
    if(${Prefix})
        cm_message_verbose(STATUS "Found path: ${${Prefix}}")
    else()
        cm_message_verbose("" "Failed to locate path of the search files: ${Files}")
    endif()

    cm_message_sub_footer("Package Find Path (${Prefix})")
endmacro()




# ************************************************************
# Include Options
# Ex: /usr/include/json -> /usr/include
# ************************************************************
macro(CM_USER_PACKAGE_INCLUDE_OPTIONS Prefix Value)
    set(${Prefix}_PATH_INCLUDE_MODE "${Value}" CACHE STRING "Include path options.")
    set_property(CACHE ${Prefix}_PATH_INCLUDE_MODE PROPERTY STRINGS "" "IncludeParent" "ParentOnly")
endmacro()


macro(CM_PACKAGE_INCLUDE_OPTIONS Prefix)
    if(${Prefix}_FOUND)
        set(_value "")
        if(${ARGC} GREATER 1)
            set(_value ${ARGN})
        endif()

        if(NOT ${Prefix}_PATH_INCLUDE_MODE)
            cm_user_package_include_options(${Prefix} "")
        endif()

        set(_opt ${${Prefix}_PATH_INCLUDE_MODE})
        get_filename_component(_path "${${Prefix}_INCLUDE_DIR}" PATH)
        if(_opt STREQUAL "IncludeParent")
            list(APPEND ${Prefix}_INCLUDE_DIR ${_path})
        elseif(_opt STREQUAL "ParentOnly")
            set(${Prefix}_INCLUDE_DIR ${_path})
        endif()

        unset(_path)
        unset(_opt)
    endif()
endmacro()



# ************************************************************
# Initialise home path
# ************************************************************
# macro(PACKAGE_INITIALISE_HOME_PATH Prefix EnvPrefix)
#     cm_package_get_environment_path(${Prefix} ${EnvPrefix})
#      if(${Prefix}_ENV_${EnvPrefix})
#         if(${Prefix}_HOME)
#             cm_message_verbose(STATUS "Set ${EnvPrefix} as ${Prefix}_HOME (${${Prefix}_ENV_${EnvPrefix}}).")
#             set(${Prefix}_HOME "${${Prefix}_ENV_${EnvPrefix}}" CACHE PATH "Path to ${Prefix} directory.")
#         endif()
#     else()
# endmacro()




# ************************************************************
# Install binaries.
macro(PACKAGE_INSTALL_BINARY_FROM_TARGET Prefix)
    # Help information.
    cm_message_header(PACKAGE_INSTALL_BINARY_FROM_TARGET)
    cm_message_help("Required:")
    cm_message_help("[Prefix]     -> Prefix of the variable to process.")
    cm_message_help("Optional:")
    cm_message_help("[SubPath]    -> Sub path in the installation directory (${PROJECT_PATH_INSTALL}).")

    # Parse options.
    set(oneValueArgs SubPath)
    cmake_parse_arguments(PACKAGE_INSTALL_BINARY_FROM_TARGET "" "${oneValueArgs}" "" ${ARGN})

    # Working variables.
    set(Path "${PROJECT_PATH_INSTALL}${PACKAGE_INSTALL_BINARY_FROM_TARGET_SubPath}")

    # Set debug runtime files.
    if(${Prefix}_BINARY_DEBUG)
        foreach(file ${${Prefix}_BINARY_DEBUG})
            install(FILES "${file}" DESTINATION "${Path}" CONFIGURATIONS "debug")
            cm_message_verbose(STATUS "Install [${file}] to ${Path}.")
        endforeach()
    endif()


    # Set release runtime files.
    if(${Prefix}_BINARY_RELEASE)
        foreach(file ${${Prefix}_BINARY_RELEASE})
            install(FILES "${file}" DESTINATION "${Path}" CONFIGURATIONS "release")
            cm_message_verbose(STATUS "Install [${file}] to ${Path}.")
        endforeach()
    endif()

    # Clean up.
    unset(Path)
    unset(oneValueArgs)
    unset(PACKAGE_INSTALL_BINARY_FROM_TARGET_SubPath)

    cm_message_footer(PACKAGE_INSTALL_BINARY_FROM_TARGET)
endmacro()




# ************************************************************
# Make Set of Release and Debug
# ************************************************************
macro(CM_PACKAGE_MAKE_LIBRARY Prefix Debug Release)
    cm_message_sub_header("Package Make Library (${Prefix})")

    if(${Debug} AND ${Release})
        cm_message_debug(STATUS "Release and Debug found.")
        set(${Prefix} optimized ${${Release}} debug ${${Debug}})
    elseif(${Release})
        cm_message_debug(STATUS "Release found.")
        set(${Prefix} ${${Release}})
    elseif(${Debug})
        cm_message_debug(STATUS "Debug found.")
        set(${Prefix} ${${Debug}})
    else()
        cm_message_debug("" "Failed to make the library (${Prefix}).")
    endif()

    cm_message_debug(STATUS "Library: ${${Prefix}}")
    cm_message_sub_footer("Package Make Library (${Prefix})")
endmacro()



# ************************************************************
# Pkgconfig usage
# ************************************************************
macro(PACKAGE_PKGCONFIG Prefix Name)
    if(PKG_CONFIG_FOUND)
        if(NOT ${Prefix}_HOME)
            pkg_check_modules(${Prefix} ${Name})
            if(${Prefix}_FOUND)
                set(${Prefix}_PATH_INCLUDE {${Prefix}_INCLUDE_DIRS})
                set(${Prefix}_LIBRARY_RELEASE {${Prefix}_LDFLAGS})
            endif()
        endif()
    endif()
endmacro()




# ************************************************************
# Get Environment Variable
# ************************************************************
macro(CM_PACKAGE_GET_ENVIRONMENT_PATH Prefix Var)
    set(TmpEnv $ENV{${Var}})

    # Make sure backslashes are converted to forward slashes.
    if(TmpEnv)
        cm_message_debug(STATUS "${Var} is located.")
        string(REGEX REPLACE "\\\\" "/" TmpEnv ${TmpEnv})

        # We must also remove the double quote if exists.
        # As we don't want the quotes to in the cache.
        string(REGEX REPLACE "\"" "" TmpEnv ${TmpEnv})

        set(${Prefix}_ENV_${Var} ${TmpEnv})
        cm_message_debug(STATUS "Set ${Prefix}_ENV_${Var} to ${TmpEnv}.")
    endif ()

    unset(TmpEnv)
endmacro()




# ************************************************************
# Set Statical Priority
# ************************************************************
macro(PACKAGE_STATICAL_DEFAULT)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${PROJECT_LIBRARY_SUFFIXES})
endmacro()

macro(PACKAGE_STATICAL_PRIORITY Prefix)
    if(${Prefix}_PRIORITY_STATICAL)
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
    endif()
endmacro()




# ************************************************************
# Validate the Package
# ************************************************************
macro(CM_PACKAGE_VALIDATE Prefix)
    if(NOT ${Prefix}_FOUND)
        if(${Prefix}_PATH_INCLUDE AND ${Prefix}_LIBRARY)
            set(${Prefix}_FOUND TRUE)
            set(${Prefix}_LIBRARIES ${${Prefix}_LIBRARY})
            set(${Prefix}_INCLUDE_DIR ${${Prefix}_PATH_INCLUDE})
        endif()
    endif()
endmacro()

