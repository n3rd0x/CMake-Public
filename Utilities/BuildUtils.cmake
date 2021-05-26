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
# Debug Macros
# ************************************************************
# ************************************************************
# Print Project Details
# ************************************************************
macro(CM_DEBUG_PRINT_PROJECT_DETAILS)
    set(_multiValueArgs SubProjects)
    cmake_parse_arguments(CM_DEBUG_PRINT_PROJECT_DETAILS "" "" "${_multiValueArgs}" ${ARGN})

    message("** Print Project Details **")
    message("Current:   ${CMAKE_PROJECT_NAME}")
    message("Version:   ${CMAKE_PROJECT_VERSION}")
    message("  Major:   ${CMAKE_PROJECT_VERSION_MAJOR}")
    message("  Minor:   ${CMAKE_PROJECT_VERSION_MINOR}")
    message("  Patch:   ${CMAKE_PROJECT_VERSION_PATCH}")
    message("  Tweak:   ${CMAKE_PROJECT_VERSION_TWEAK}")

    if(CM_DEBUG_PRINT_PROJECT_DETAILS)
        message("SubProjects:")
        foreach(pro ${CM_DEBUG_PRINT_PROJECT_DETAILS})
            if(${pro}_PROJECT_VERSION)
                message("   Project:   ${pro}")
                message("   Version:   ${${pro}_PROJECT_VERSION}")
                message("     Major:   ${${pro}_PROJECT_VERSION_MAJOR}")
                message("     Minor:   ${${pro}_PROJECT_VERSION_MINOR}")
                message("     Patch:   ${${pro}_PROJECT_VERSION_PATCH}")
                message("     Tweak:   ${${pro}_PROJECT_VERSION_TWEAK}")
            else()
                message("   The project ${pro} doesn't exists.")
            endif()
        endforeach()
    endif()
    message("****************************")

    # Clean up.
    unset(_multiValueArgs)
    unset(CM_DEBUG_PRINT_PROJECT_DETAILS)
endmacro()




# ************************************************************
# Add definition
# ************************************************************
macro(CM_ADD_DEFINITION Value)
    add_definitions(-D${Value})
    cm_message_debug(STATUS "Add definition (${Value})")
endmacro()




# ************************************************************
# Append Value to List
# ************************************************************
macro(CM_APPEND_LIST List Value)
    # Add to list if valid value.
    if(NOT ${Value} STREQUAL "")
        list(APPEND ${List} ${${Value}})
        cm_message_debug(STATUS "Add ${${Value}} (${Value}) to ${List}.")
    else()
        cm_message_debug(STATUS "Variable (${Value}) is empty, skip adding to ${List}.")
    endif()
endmacro()




# ************************************************************
# Copy Data from Target
# ************************************************************
# Help information.
# Required:
# [SrcFile]     -> The source file..
# Optional:
# [GENERATE]    -> The source file is a template file..
# [Name]        -> Destination name. Default: Same as the source..
# [SubPath]     -> Sub path of output directory..
macro(ADD_DATA_TARGET SrcFile)
    cm_message_header(ADD_DATA_TARGET)

    # ----------------------------------------
    # Parse Options
    # ----------------------------------------
    set(_options GENERATE)
    set(__oneValueArgs Name SubPath)
    cmake_parse_arguments(ADD_DATA_TARGET "${_options}" "${__oneValueArgs}" "" ${ARGN})

    # Find the existence of the source.
    get_name_component(_name ${SrcFile} NAME)
    get_name_component(_path ${SrcFile} PATH)
    find_file(_found NAMES ${_name} HINTS ${_path})
    if(_found)
        # Working vars.
        set(_fileToCopy "${_found}")

        # Parse "Name".
        if(ADD_DATA_TARGET_Name)
            set(_name ${ADD_DATA_TARGET_Name})
        endif()

        # Default output path.
        if(MSVC OR XCODE)
            set(_outputPath "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>")
        else()
            set(_outputPath "${PROJECT_PATH_OUTPUT_EXECUTABLE}")
        endif()

        # Parse "SubPath".
        if(ADD_DATA_TARGET_SubPath)
            set(_outputPath "${_outputPath}${ADD_DATA_TARGET_SubPath}")
        endif()

        # Generate template file and add command.
        if(ADD_DATA_TARGET_GENERATE)
            cm_message_verbose(STATUS "Generate from template file.")
            configure_file(${_fileToCopy} "${CMAKE_CURRENT_BINARY_DIR}/${_name}")
            set(_fileToCopy "${CMAKE_CURRENT_BINARY_DIR}/${_name}")
        endif()

        # Add command.
        add_custom_command(
            TARGET ALL_CopyData
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${_fileToCopy}
            "${_outputPath}/${_name}"
       )

        if(ADD_DATA_TARGET_GENERATE)
            cm_message_verbose(STATUS "Adding [${_fileToCopy}] to ALL_CopyData target.")
        else()
            cm_message_verbose(STATUS "Adding [${SrcFile}] to ALL_CopyData target.")
        endif()
        unset(_outputPath)
        unset(_fileToCopy)
    else()
        cm_message_status("" "Failed to locate: ${SrcFile}")
    endif()

    # Clean up.
    unset(_options)
    unset(__oneValueArgs)
    unset(_found CACHE)
    unset(_name)
    unset(_path)
    unset(ADD_DATA_TARGET_GENERATE)
    unset(ADD_DATA_TARGET_Name)
    unset(ADD_DATA_TARGET_SubPath)

    cm_message_footer(ADD_DATA_TARGET)
endmacro()




# ************************************************************
# Add Value into Variable
# ************************************************************
# Help information.
# Required:
# [Prefix]      -> (Ref)    Prefix of the variable to process.
# [Value]       -> (String) Value to validate.
# Optional:
# [CACHING]     -> Flag to caching.
# [AS_STRING]   -> Flag to make as string arguments.
# [Description] -> (String) Description.
macro(CM_ADD_VALUE Prefix Value)
    if(${Value})
        # ----------------------------------------
        # Parse Options
        # ----------------------------------------
        set(_options AS_STRING CACHING)
        set(__oneValueArgs Description)
        cmake_parse_arguments(CM_ADD_VALUE "${_options}" "${__oneValueArgs}" "" ${ARGN})


        # ----------------------------------------
        # Process
        # ----------------------------------------
        # Retrieve values from the variable.
        set(_values ${${Prefix}})

        # Convert into list.
        separate_arguments(_values)

        # Search for value.
        list(FIND _values ${Value} _valueFound)

        # Add if not found.
        if(_valueFound LESS 0)
            list(APPEND _values ${Value})

            # Make as string.
            if(CM_ADD_VALUE_AS_STRING)
                cm_message_debug(STATUS "Make as string arguments.")
                list(JOIN _values " " _values)
            endif()

            # Cache the variable if specified.
            if(CM_ADD_VALUE_CACHING)
                cm_message_verbose(STATUS "Adding '${${Value}}' to ${Prefix} in cache mode.")
                set(${Prefix} ${_values} CACHE STRING "${CM_ADD_VALUE_Description}" FORCE)
            else()
                cm_message_verbose(STATUS "Adding '${${Value}}' to ${Prefix}.")
                set(${Prefix} ${_values})
            endif()
        else()
            cm_message_verbose(STATUS "Value '${${Value}}' exists, skipping adding to ${Prefix}.")
        endif()


        # ----------------------------------------
        # Clean Up
        # ----------------------------------------
        unset(_options)
        unset(__oneValueArgs)
        unset(_valueFound)
        unset(_values)
        unset(CM_ADD_VALUE_AS_STRING)
        unset(CM_ADD_VALUE_CACHING)
        unset(CM_ADD_VALUE_Description)
    endif()
endmacro()




# ************************************************************
# Generate group files, create a common variable for all grouped files.
macro(BUILD_GENERATE_GROUP_FILES Prefix)
    cm_message_header(BUILD_GENERATE_GROUP_FILES)
    cm_message_debug(STATUS "Prefix: ${Prefix}")

    # Just verify that the Prefix has at least one header or source file.
    if(${Prefix}_GROUP_HEADER_FILES)
        cm_message_debug(STATUS "Header files: ${${Prefix}_GROUP_HEADER_FILES}")
        set(LOCAL_GROUP_HEADER_FILES ${LOCAL_GROUP_HEADER_FILES} ${${Prefix}_GROUP_HEADER_FILES})
        set(Continue TRUE)
    endif()

    if(${Prefix}_GROUP_SOURCE_FILES)
        cm_message_debug(STATUS "Source files: ${${Prefix}_GROUP_SOURCE_FILES}")
        set(LOCAL_GROUP_SOURCE_FILES ${LOCAL_GROUP_SOURCE_FILES} ${${Prefix}_GROUP_SOURCE_FILES})
    endif()


    if(Continue)
        # Add if not existed.
        # Check if LOCAL_PATH_GROUP_HEADER do exists, if not then just add the path into the variable.
        # Otherwise add into the variable, only then the Prefix (hence the path to the respective
        # include path) doesn't exists.
        if(NOT LOCAL_PATH_GROUP_HEADER)
            cm_message_debug(STATUS "LOCAL_PATH_GROUP_HEADER doesn't exists. Add directly into the variable.")
            set(LOCAL_PATH_GROUP_HEADER ${LOCAL_PATH_GROUP_HEADER} ${${Prefix}_PATH_GROUP_HEADER})
        else()
            cm_message_debug(STATUS "Full list: ${${Prefix}_PATH_GROUP_HEADER}")
            foreach(LocalPath ${${Prefix}_PATH_GROUP_HEADER})
                cm_message_debug(STATUS "Search: ${LocalPath}")
                string(REGEX MATCHALL ${LocalPath} PathExists ${LOCAL_PATH_GROUP_HEADER})

                if(NOT PathExists)
                    cm_message_debug(STATUS "Path doesn't exists, add into variable.")
                    list(APPEND LOCAL_PATH_GROUP_HEADER ${LocalPath})
                else()
                    cm_message_debug(STATUS "Path already exists, skip adding process.")
                endif()
                unset(PathExists)
            endforeach()
        endif()

        cm_message_debug(STATUS "Paths: ${LOCAL_PATH_GROUP_HEADER}")
    endif()
    unset(Continue)

    cm_message_footer(BUILD_GENERATE_GROUP_FILES)
endmacro()




# ************************************************************
# Group files.
macro(BUILD_GROUP_FILES)
    # Help information.
    cm_message_header(BUILD_GROUP_FILES)
    cm_message_help("Required options:")
    cm_message_help("[Prefix]         -> Prefix for this group section.")
    cm_message_help("Optional options:")
    cm_message_help("[Groups]         -> Organize in groups.")
    cm_message_help("[Headers]        -> Header files.")
    cm_message_help("[Sources]        -> Source files.")
    cm_message_help("[Files]          -> Generic files.")

    # Working members.
    set(GroupName "")

    # Parse options.
    set(_oneValueArgs Prefix)
    set(multiValueArgs Groups Headers Sources Files)
    cmake_parse_arguments(BUILD_GROUP_FILES "" "${_oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Parse "Prefix".
    if(BUILD_GROUP_FILES_Prefix)
        cm_message_debug(STATUS "Prefix: ${BUILD_GROUP_FILES_Prefix}")

        # Parse "Groups".
        if(BUILD_GROUP_FILES_Groups)
            foreach(g ${BUILD_GROUP_FILES_Groups})
                set(GroupName "${GroupName}\\${g}")
            endforeach()
            cm_message_debug(STATUS "Groups: ${BUILD_GROUP_FILES_Groups}")
        endif()

        # Parse "Headers".
        if(BUILD_GROUP_FILES_Headers)
            cm_message_debug(STATUS "Headers: ${BUILD_GROUP_FILES_Headers}")
            foreach(header ${BUILD_GROUP_FILES_Headers})
                cm_message_debug(STATUS "Working with current header: ${header}")

                # Add into build variables.
                set(${BUILD_GROUP_FILES_Prefix}_GROUP_HEADER_FILES ${${BUILD_GROUP_FILES_Prefix}_GROUP_HEADER_FILES} ${header})

                # Find and add includes directory.
                get_name_component(_path ${header} PATH)
                if(_path)
                    cm_message_debug(STATUS "Path located: ${_path}")
                    if(NOT ${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER)
                        set(PathExists FALSE)
                    else()
                        string(REGEX MATCHALL ${_path} PathExists ${${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER})
                    endif()

                    if(NOT PathExists)
                        cm_message_debug(STATUS "Add path into variable.")
                        set(${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER ${${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER} ${_path})
                    endif()
                    unset(PathExists)
                endif()
                unset(_path)
            endforeach()

            # Group files.
            source_group("Header Files${GroupName}" FILES ${BUILD_GROUP_FILES_Headers})
            cm_message_debug(STATUS "Local headers: ${${BUILD_GROUP_FILES_Prefix}_GROUP_HEADER_FILES}")
        endif()


        # Parse "Sources".
        if(BUILD_GROUP_FILES_Sources)
            cm_message_debug(STATUS "Sources: ${BUILD_GROUP_FILES_Sources}")
            # Add into build variable.
            set(${BUILD_GROUP_FILES_Prefix}_GROUP_SOURCE_FILES ${${BUILD_GROUP_FILES_Prefix}_GROUP_SOURCE_FILES} ${BUILD_GROUP_FILES_Sources})

            # Group files.
            source_group("Source Files${GroupName}" FILES ${BUILD_GROUP_FILES_Sources})
            cm_message_debug(STATUS "Local sources: ${${BUILD_GROUP_FILES_Prefix}_GROUP_SOURCE_FILES}")
        endif()


        # Parse "Files"
        if(BUILD_GROUP_FILES_Files)
            cm_message_debug(STATUS "Files: ${BUILD_GROUP_FILES_Files}")
            # Group files.
            source_group("Other Files${GroupName}" FILES ${BUILD_GROUP_FILES_Files})
        endif()
    endif()

    # Clean up.
    unset(GroupName)
    unset(_oneValueArgs)
    unset(multiValueArgs)
    unset(BUILD_GROUP_FILES_Prefix)
    unset(BUILD_GROUP_FILES_Groups)
    unset(BUILD_GROUP_FILES_Headers)
    unset(BUILD_GROUP_FILES_Sources)
    unset(BUILD_GROUP_FILES_Files)

    cm_message_footer(BUILD_GROUP_FILES)
endmacro()




# ************************************************************
# Copy build file to the output directory
macro(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY)
    # Help information.
    cm_message_header(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY)
    cm_message_help("Available options:")
    cm_message_help("[Path]       -> Output directory. Default: ${PROJECT_PATH_OUTPUT_EXECUTABLE}.")
    cm_message_help("[SubPath]    -> Sub directory of the output directory.")

    # Parse options.
    set(_oneValueArgs Path SubPath)
    cmake_parse_arguments(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY "" "${_oneValueArgs}" "" ${ARGN})

    # Set sub path based on OS platform.
    set(Path "${PROJECT_PATH_OUTPUT_EXECUTABLE}")
    if(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path)
        set(Path "${COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path}")
    endif()

    if(NOT COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path AND MSVC)
        set(Path "${Path}/$<CONFIGURATION>${COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_SubPath}")
    else()
        set(Path "${Path}${COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_SubPath}")
    endif()

    add_custom_command(
        TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "${Path}"
        COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${PROJECT_NAME}>" "${Path}"
   )

    cm_message_verbose(STATUS "Copy [${PROJECT_NAME}] into [${Path}].")

    # Clean up.
    unset(_oneValueArgs)
    unset(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path)
    unset(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_SubPath)
    unset(Path)

    cm_message_footer(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY)
endmacro()




# ************************************************************
# Copy a single file to the output directory
macro(COPY_FILE_TO_OUTPUT_DIRECTORY SrcFile DstFile)
    # Help information.
    cm_message_header(COPY_FILE_TO_OUTPUT_DIRECTORY)
    cm_message_help("Required:")
    cm_message_help("[SrcFile]        -> Source file.")
    cm_message_help("[DstFile]    -> Destination file name.")
    cm_message_help("Available options:")
    cm_message_help("[Params]         -> CMake parameters.")
    cm_message_help("[SubPath]        -> Sub directory of the output directory.")

    # Parse options.
    set(_oneValueArgs SubPath)
    cmake_parse_arguments(COPY_FILE_TO_OUTPUT_DIRECTORY "" "${_oneValueArgs}" "" ${ARGN})

    # With Visual Studio we will copy the file into the debug and release directory.
    if(MSVC OR XCODE)
        cm_copy_single_file("${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Debug${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFile}" "${COPY_SINGLE_FILE_Params}")
        cm_copy_single_file("${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Release${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFile}" "${COPY_SINGLE_FILE_Params}")
    else()
        cm_copy_single_file("${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFile}" "${COPY_SINGLE_FILE_Params}")
    endif()

    # Clean up.
    unset(_oneValueArgs)
    unset(COPY_SINGLE_FILE_Params)
    unset(COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath)

    cm_message_footer(COPY_FILE_TO_OUTPUT_DIRECTORY)
endmacro()




# ************************************************************
# Copy Project Template
# ************************************************************
# Help information.
# Optional:
# [Source]      -> Source file.
# [Destination] -> Destination file.
macro(CM_COPY_PROJECT_TEMPLATE)
    # Default values.
    set(_source "")
    set(_destination "")

    if(MSVC)
        set(_source "${PROJECT_PATH_CMAKE_TEMPLATE}/MsvcProject_in.vcxproj.user")
        set(_destination "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.vcxproj.user")
    endif()

    # Parse options.
    set(_oneValueArgs Source Destination)
    cmake_parse_arguments(COPY_PROJECT_TEMPLATE "" "${_oneValueArgs}" "" ${ARGN})

    # Parse source.
    if(COPY_PROJECT_TEMPLATE_Source)
        set(_source ${COPY_PROJECT_TEMPLATE_Source})
        cm_message_debug(STATUS "Source: ${COPY_PROJECT_TEMPLATE_Source}")
    endif()

    # Parse destination.
    if(COPY_PROJECT_TEMPLATE_Destination)
        set(_destination ${COPY_PROJECT_TEMPLATE_Destination})
        cm_message_debug(STATUS "Destination: ${COPY_PROJECT_TEMPLATE_Destination}")
    endif()

    # Copy the file.
    # TST 2014-08-29
    # At the moment only MSVC is supported.
    if(MSVC)
        cm_copy_single_file(${_source} ${_destination} "")
    endif()

    # Clean up.
    unset(_source)
    unset(_destination)
    unset(_oneValueArgs)
    unset(COPY_PROJECT_TEMPLATE_Source)
    unset(COPY_PROJECT_TEMPLATE_Destination)
endmacro()




# ************************************************************
# Copy a Single File
# ************************************************************
# Help information.
# Required:
# [SrcFile]    -> Source file.
# [DstFile]    -> Destination file.
# Optional:
# [Params]     -> CMake parameters.
macro(CM_COPY_SINGLE_FILE SrcFile DstFile)
    # Parse options.
    set(_oneValueArgs SubPath)
    cmake_parse_arguments(COPY_SINGLE_FILE "" "${_oneValueArgs}" "" ${ARGN})

    # Find the existence of the source.
    get_name_component(_name ${SrcFile} NAME)
    get_name_component(_path ${SrcFile} PATH)
    find_file(_found NAMES ${_name} HINTS ${_path})

    # Copy the file if exists.
    if(_found)
        if(COPY_SINGLE_FILE_Params)
            configure_file(${SrcFile} ${DstFile} "${COPY_SINGLE_FILE_Params}")
        else()
            configure_file(${SrcFile} ${DstFile})
        endif()
        cm_message_verbose(STATUS "Copy [${SrcFile}] to [${DstFile}]")
    else()
        cm_message_status("" "Failed to locate: ${SrcFile}")
    endif()

    # Clean up.
    unset(_oneValueArgs)
    unset(_found CACHE)
    unset(_name)
    unset(_path)
    unset(COPY_SINGLE_FILE_Params)

    cm_message_footer(COPY_SINGLE_FILE)
endmacro()




# ************************************************************
# Generate Dynamic Library Extension
# ************************************************************
macro(CM_GENERATE_DYNAMIC_EXTENSION Value)
    if(WIN32)
        set(${Value} "dll")
    elseif(APPLE)
        set(${Value} "dylib")
    else()
        set(${Value} "so")
    endif()
endmacro()




# ************************************************************
# Create a directory
macro(CREATE_DIRECTORY DIST_DIR)
    file(MAKE_DIRECTORY "${DIST_DIR}")
    cm_message_verbose(STATUS "Create the directory: ${DIST_DIR}")
endmacro()




# ************************************************************
# Create a directory in the output directory
macro(CREATE_DIRECTORY_IN_OUTPUT_DIRECTORY DIST_DIR)
    if(MSVC OR XCODE)
        create_directory("${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${DIST_DIR}")
        create_directory("${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${DIST_DIR}")
    else()
        create_directory("${PROJECT_PATH_OUTPUT_EXECUTABLE}/${DIST_DIR}")
    endif()
endmacro()




# ************************************************************
# Create Dynamic Library Extension
# ************************************************************
macro(CM_CREATE_DYNAMIC_EXTENSION Value)
    cm_generate_dynamic_extension(suffix)
    set(${Value} "${${Value}}.${suffix}")
    unset(suffix)
endmacro()




# ************************************************************
# Create Executable Extension
# ************************************************************
macro(CM_CREATE_EXECUTABLE_EXTENSION Value)
    if(WIN32)
        set(${Value} "${${Value}}.exe")
    endif()
endmacro()




# ************************************************************
# Create MSVC Toolset
# ************************************************************
macro(CM_CREATE_MSVC_TOOLSET OUTPUT)
    set(${OUTPUT} "")
    if(WIN32)
        # This apply for Visual Studio version greater than 2012.
        if(MSVC11)
            set(${OUTPUT} "v110")
        elseif(MSVC12)
            set(${OUTPUT} "v120")
        endif()
    endif()
endmacro()




# ************************************************************
# Create MSVC Toolset with Clang
# ************************************************************
macro(CM_CREATE_MSVC_TOOLSET_CLANG OUTPUT)
    set(${OUTPUT} "")
    if(WIN32)
        # This apply for Visual Studio version greater than 2012.
        if(MSVC12)
            set(${OUTPUT} "LLVM-vs2013")
        endif()
    endif()
endmacro()




# ************************************************************
# Generate the PDB file.
macro(GENERATE_DEBUG_SYMBOLS)
    if(MSVC)
        # This property does not apply to STATIC library targets because no linker is invoked to produce them so they have no
        # linker-generated .pdb file containing debug symbols.
        # The compiler-generated program database files specified by the MSVC /Fd flag are not the same as linker-generated
        # program database files and so are not influenced by this property.
        # http://msdn.microsoft.com/en-us/library/9wst99a9.aspx
        set(CMAKE_C_FLAGS        "${CMAKE_C_FLAGS}     /FdGenerated.pdb")
        set(CMAKE_CXX_FLAGS      "${CMAKE_CXX_FLAGS}   /FdGenerated.pdb")

        # "Hack" to make the output name as the "Project Name" due to a lower case naming.
        # Find the existence of the source.
        set(SrcFile "${CMAKE_CURRENT_BINARY_DIR}/Generated.pdb")
        get_name_component(_name ${SrcFile} NAME)
        get_name_component(_path ${SrcFile} PATH)
        find_file(_found NAMES ${_name} HINTS ${_path})
        if(_found)
            #cm_copy_single_file(${_found} "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Debug/${PROJECT_NAME}_d.pdb")

            # Copy and rename.
            add_custom_command(
                TARGET ${PROJECT_NAME}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                "${_found}"
                "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>/${PROJECT_NAME}$<$<CONFIG:Debug>:${CMAKE_DEBUG_POSTFIX}>.pdb"
           )
        endif()

        unset(_found CACHE)
        unset(_name)
        unset(_path)
        unset(SrcFile)
    endif()
endmacro()




# ************************************************************
# Group files
macro(GROUP_FILES TopGroup Files)
    # Help information.
    cm_message_header(GROUP_FILES)
    cm_message_help("Requires:")
    cm_message_help("[TopGroup]   -> Name of the top group.")
    cm_message_help("[Files]      -> Files to group.")
    cm_message_help("Available options:")
    cm_message_help("[Groups]     -> Groups.")

    # Parse options.
    set(multiValueArgs Groups)
    cmake_parse_arguments(GROUP_FILES "" "" "${multiValueArgs}" ${ARGN})

    # Default values.
    set(GroupName "")
    if(GROUP_FILES_Groups)
        foreach(group ${GROUP_FILES_Groups})
            set(GroupName "${GroupName}\\${group}")
        endforeach()
    endif()

    source_group("${TopGroup}${GroupName}" FILES ${Files})

    # Clean up.
    unset(multiValueArgs)
    unset(GROUP_FILES_Groups)

    cm_message_footer(GROUP_FILES)
endmacro()




# ************************************************************
# Initialise CMake System
# ************************************************************
macro(CM_INITIALISE_CMAKE_SYSTEM)
    cm_initialise_project()
    cm_initialise_project_path()
    cm_initialise_project_environment()

    cm_project_compiler_apply_options()
    #cm_add_definition(VERSION="${PROJECT_VERSION}")
    cm_add_definition(RELEASE="${PROJECT_BUILD_TIME}")
endmacro()



# ************************************************************
# Initialise Global Project
# ************************************************************
macro(CM_INITIALISE_PROJECT)
    # ----------------------------------------
    # Policies
    # ----------------------------------------
    if(CMAKE_MAJOR_VERSION GREATER 2)
        # Define policies.
        # Use project version.
        cmake_policy(SET CMP0048 NEW)

        # Compiler definitions.
        cmake_policy(SET CMP0043 NEW)
    endif()


    # ----------------------------------------
    # Project Details
    # ----------------------------------------
    # Set the project version.
    set(CMAKE_PROJECT_VERSION "${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR}.${CMAKE_PROJECT_VERSION_PATCH}.${CMAKE_PROJECT_VERSION_TWEAK}")
    cm_initialise_project_details(
        ${CMAKE_PROJECT_NAME}
        ${CMAKE_PROJECT_DESCRIPTION}
        ${CMAKE_PROJECT_VERSION_MAJOR}
        ${CMAKE_PROJECT_VERSION_MINOR}
        ${CMAKE_PROJECT_VERSION_PATCH}
        ${CMAKE_PROJECT_VERSION_TWEAK}
    )

    # Build timestamp.
    string(TIMESTAMP PROJECT_BUILD_TIME "%d/%m-%Y")


    # ----------------------------------------
    # Compiler Details
    # CMAKE_CXX_COMPILER:       Path to the compiler.
    # CMAKE_CXX_COMPILER_ID:    ID of the compiler.
    # ----------------------------------------
    if(CMAKE_C_COMPILER_ID)
        set(_cCompiler ${CMAKE_C_COMPILER_ID})
    else()
        set(_cCompiler ${CMAKE_C_COMPILER})
    endif()

    if(CMAKE_CXX_COMPILER_ID)
        set(_cxxCompiler ${CMAKE_CXX_COMPILER_ID})
    else()
        set(_cxxCompiler ${CMAKE_CXX_COMPILER})
    endif()

    if(MSVC)
        set(_msvcFullName "Visual Studio")
        set(_msvcCodeName "msvc")
        if(MSVC_VERSION GREATER_EQUAL 1920)
            set(_msvcFullName "Visual Studio 2019")
            set(_msvcCodeName "msvc2019")
        elseif(MSVC_VERSION GREATER_EQUAL 1910)
            set(_msvcFullName "Visual Studio 2017")
            set(_msvcCodeName "msvc2017")
        elseif(MSVC_VERSION GREATER_EQUAL 1900)
            set(_msvcFullName "Visual Studio 2015")
            set(_msvcCodeName "msvc2015")
        elseif(MSVC_VERSION GREATER_EQUAL 1800)
            set(_msvcFullName "Visual Studio 2013")
            set(_msvcCodeName "msvc2013")
        elseif(MSVC_VERSION GREATER_EQUAL 1700)
            set(_msvcFullName "Visual Studio 2012")
            set(_msvcCodeName "msvc2012")
        elseif(MSVC_VERSION GREATER_EQUAL 1600)
            set(_msvcFullName "Visual Studio 2011")
            set(_msvcCodeName "msvc2011")
        endif()
        message(STATUS "* Compiler:    Microsoft ${_msvcFullName}")
        message(STATUS "               Toolset: ${MSVC_TOOLSET_VERSION}")
        message(STATUS "               Version: ${MSVC_VERSION}")
        set(_ideTool "${_msvcFullName} (${_msvcCodeName}), ${MSVC_VERSION}")

        unset(_msvcFullName)
        unset(_msvcCodeName)
    elseif(XCODE)
        set(_ideTool "Apple XCode, ${XCODE_VERSION}")
    endif()


    # Output.
    message(STATUS "**********************************************************************")
    message(STATUS "* Project:      ${CMAKE_PROJECT_NAME}")
    message(STATUS "* Description:  ${CMAKE_PROJECT_DESCRIPTION}")
    message(STATUS "* Version:      ${CMAKE_PROJECT_VERSION}")
    message(STATUS "* Time:         ${PROJECT_BUILD_TIME}")
    message(STATUS "* System:       ${CMAKE_HOST_SYSTEM}")
    message(STATUS "* Processor:    ${CMAKE_HOST_SYSTEM_PROCESSOR}")
    message(STATUS "* CMake:        ${CMAKE_VERSION}")
    if(_cCompiler)
        message(STATUS "* C Compiler:   ${_cCompiler} (${CMAKE_C_COMPILER_VERSION})")
    endif()
    if(_cxxCompiler)
        message(STATUS "* CXX Compiler: ${_cxxCompiler} (${CMAKE_CXX_COMPILER_VERSION})")
    endif()
    if(_ideTool)
        message(STATUS "* IDE Tool:     ${_ideTool}")
    endif()


    # ----------------------------------------
    # Clean Up
    # ----------------------------------------
    unset(_cCompiler)
    unset(_cxxCompiler)
    unset(_ideTool)
endmacro()




# ************************************************************
# Initialise Project Description and Version
# ************************************************************
macro(CM_INITIALISE_PROJECT_DETAILS Prefix Desc Major Minor Patch Tweak)
    set(${Prefix}_PROJECT_DESCRIPTION ${Desc})
    set(${Prefix}_PROJECT_VERSION_MAJOR ${Major})
    set(${Prefix}_PROJECT_VERSION_MINOR ${Minor})
    set(${Prefix}_PROJECT_VERSION_PATCH ${Patch})
    set(${Prefix}_PROJECT_VERSION_TWEAK ${Tweak})
    set(${Prefix}_PROJECT_VERSION "${Major}.${Minor}.${Patch}.${Tweak}")
endmacro()




# ************************************************************
# Initialise Project Environments
# ************************************************************
macro(CM_INITIALISE_PROJECT_ENVIRONMENT)
    cm_message_header(CM_INITIALISE_PROJECT_ENVIRONMENT)


    # ----------------------------------------
    # Build Type
    # ----------------------------------------
    if(NOT CMAKE_BUILD_TYPE)
        # Setup for single configuration system.
        if(MINGW OR UNIX)
            if(NOT MSCV AND NOT XCODE)
                set(PROJECT_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Select build type.")
                set_property(CACHE PROJECT_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)

                set(CMAKE_BUILD_TYPE ${PROJECT_BUILD_TYPE} CACHE STRING "Target mode of this project." FORCE)

                cm_message_status(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
            endif()
        endif()
    endif()


    # ----------------------------------------
    # Cache Options
    # ----------------------------------------
    # Set debug postfix.
    set(CMAKE_DEBUG_POSTFIX "_d")

    # Suffix search priority.
    cm_message_verbose(STATUS "Library search priority:")
    cm_message_verbose_output(STATUS ${CMAKE_FIND_LIBRARY_SUFFIXES})

    # Set state for displaying debug message.
    option(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG "Enable debug message" OFF)

    # Set state for displaying verbose message.
    option(PROJECT_CMAKE_ENABLE_MESSAGE_VERBOSE "Enable verbose message." OFF)

    # Load pkgconfig modules.
#    if(NOT ANDROID)
#        find_package(PkgConfig)
#        if(PKG_CONFIG_FOUND)
#            cm_message_status(STATUS "Enable 'pkgconfig' modules.")
#        endif ()
#    endif()


    # ----------------------------------------
    # Toolset
    # ----------------------------------------
    # Set option for build for targeting XP.
    if(MSVC)
        option(PROJECT_BUILD_FOR_WIN_XP "Build for Windows XP SP3." OFF)

        if(PROJECT_BUILD_FOR_WIN_XP)
            if(NOT PROJECT_ENABLE_LLVM_CLANG)
                cm_create_msvc_toolset(_toolset)
            endif()
            set(_toolset "${_toolset}_xp")
            add_definitions(-D_WIN32_WINNT=0x0501)
        endif()

        if(NOT _toolset STREQUAL "")
            # This apply only for Visual Studio 2012 and greater.
            if(MSVC_VERSION GREATER 1600)
                set(CMAKE_GENERATOR_TOOLSET ${_toolset} CACHE STRING "Platform toolset." FORCE)
            endif()
        else()
            unset(CMAKE_GENERATOR_TOOLSET CACHE)
        endif()
        unset(_toolset)
    endif()

    # Required CMake version 3.14
    # Enable to generate shared scheme in XCode.
    if(XCODE)
        option(PROJECT_XCODE_GENERATE_SCHEME "Generate the shared scheme." ON)

        if(PROJECT_XCODE_GENERATE_SCHEME)
            set(CMAKE_XCODE_GENERATE_SCHEME TRUE)
        endif()
    endif()


    # ----------------------------------------
    # Compiler Details
    # ----------------------------------------
    cm_compiler_initialise_flags()

    # Custom compiler setup.
    if(COMMAND cm_custom_compiler_flags)
        cm_custom_compiler_flags()
    endif()


    # Install debug symbols.
    #if(MSVC)
        #option(PROJECT_INSTALL_DEBUG_SYMBOLS "Install debug symbols." ON)
    #endif()


    # Copy runtime dependencies target and data files.
    add_custom_target(ALL_CopyData)
    add_custom_target(ALL_CopyRuntime)

    cm_message_footer(CM_INITIALISE_PROJECT_ENVIRONMENT)
endmacro()



# ************************************************************
# Initialise Local Project
# ************************************************************
# Help information.
# Required:
# [Title]       -> Project name.
# [Description] -> Project description.
# Optional:
# [Description] -> Description of this project.
# [Major]       -> The major version.
# [Minor]       -> The minor version.
# [Path]        -> The patch version.
# [Tweak]       -> The tweak version.
# [Languages]   -> Languages to use.
macro(CM_INITIALISE_LOCAL_PROJECT Title Description)
    # ----------------------------------------
    # Policies
    # ----------------------------------------
    if(CMAKE_MAJOR_VERSION GREATER 2)
        # Version definitions.
        cmake_policy(SET CMP0048 NEW)
    endif()


    # ----------------------------------------
    # Parse Options
    # ----------------------------------------
    set(__oneValueArgs Major Minor Patch Tweak)
    set(_multiValueArgs Languages)
    cmake_parse_arguments(CM_INITIALISE_LOCAL_PROJECT "" "${__oneValueArgs}" "${_multiValueArgs}" ${ARGN})

    # Set project and language.
    set(_languages "C" "CXX")
    if(CM_INITIALISE_LOCAL_PROJECT_Languages)
        set(_languages ${CM_INITIALISE_LOCAL_PROJECT_Languages})
    endif()
    project(${Title} LANGUAGES ${_languages})
    list(JOIN _languages " " _languages)


    # Description.
    set(PROJECT_DESCRIPTION ${Description})

    # Major version.
    if(CM_INITIALISE_LOCAL_PROJECT_Major)
        set(PROJECT_VERSION_MAJOR ${CM_INITIALISE_LOCAL_PROJECT_Major})
    else()
        set(PROJECT_VERSION_MAJOR ${CMAKE_PROJECT_VERSION_MAJOR})
    endif()

    # Minor version.
    if(CM_INITIALISE_LOCAL_PROJECT_Minor)
        set(PROJECT_VERSION_MINOR ${CM_INITIALISE_LOCAL_PROJECT_Minor})
    else()
        set(PROJECT_VERSION_MINOR ${CMAKE_PROJECT_VERSION_MINOR})
    endif()

    # Patch version.
    if(CM_INITIALISE_LOCAL_PROJECT_Patch)
        set(PROJECT_VERSION_PATCH ${CM_INITIALISE_LOCAL_PROJECT_Patch})
    else()
        set(PROJECT_VERSION_PATCH ${CMAKE_PROJECT_VERSION_PATCH})
    endif()

    # Tweak version.
    if(CM_INITIALISE_LOCAL_PROJECT_Tweak)
        set(PROJECT_VERSION_TWEAK ${CM_INITIALISE_LOCAL_PROJECT_Tweak})
    else()
        set(PROJECT_VERSION_TWEAK ${CMAKE_PROJECT_VERSION_TWEAK})
    endif()

    set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}.${PROJECT_VERSION_TWEAK}")
    cm_initialise_project_details(
        ${Title}
        ${PROJECT_DESCRIPTION}
        ${PROJECT_VERSION_MAJOR}
        ${PROJECT_VERSION_MINOR}
        ${PROJECT_VERSION_PATCH}
        ${PROJECT_VERSION_TWEAK}
    )


    # ----------------------------------------
    # Project Details
    # ----------------------------------------
    message(STATUS "----------------------------------------------------------------------")
    message(STATUS "- Project:      ${PROJECT_NAME}")
    message(STATUS "- Description:  ${PROJECT_DESCRIPTION}")
    message(STATUS "- Language:     ${_languages}")
    if(NOT PROJECT_VERSION STREQUAL ${CMAKE_PROJECT_VERSION})
        message(STATUS "- Version:      ${PROJECT_VERSION}")
    endif()


    # ----------------------------------------
    # Clean Up
    # ----------------------------------------
    unset(__oneValueArgs)
    unset(_multiValueArgs)
    unset(_languages)
    unset(CM_INITIALISE_LOCAL_PROJECT_Major)
    unset(CM_INITIALISE_LOCAL_PROJECT_Minor)
    unset(CM_INITIALISE_LOCAL_PROJECT_Patch)
    unset(CM_INITIALISE_LOCAL_PROJECT_Tweak)
    unset(CM_INITIALISE_LOCAL_PROJECT_Languages)
endmacro()




# ************************************************************
# Initialise Default Project Paths
# ************************************************************
# Help information.
    # Available options:
    # [Binary]     -> Output path of binary files. Default: 'bin'.
    # [Include]    -> Output path of include files. Default: 'include'.
    # [Library]    -> Output path of library files. Default: 'lib'.
    # Visual Studio options:
    # [PDB]        -> Output path of PDB files. Default: 'pdb'.
macro(CM_INITIALISE_PROJECT_PATH)
    cm_message_verbose(STATUS "Setup default project paths.")

    # Parse options.
    set(_oneValueArgs Binary Include Library)
    if(MSVC)
        set(_oneValueArgs ${_oneValueArgs} PDB)
    endif()
    cmake_parse_arguments(CM_INITIALISE_PROJECT_PATH "" "${_oneValueArgs}" "" ${ARGN})

    # Parse binary path.
    set(PathBinary "bin")
    if(CM_INITIALISE_PROJECT_PATH_Binary)
        set(PathBinary ${CM_INITIALISE_PROJECT_PATH_Binary})
    endif()

    # Parse include path.
    set(PathInclude "include")
    if(CM_INITIALISE_PROJECT_PATH_Include)
        set(PathInclude ${CM_INITIALISE_PROJECT_PATH_Include})
    endif()

    # Parse library path.
    set(PathLibrary "lib")
    if(CM_INITIALISE_PROJECT_PATH_Library)
        set(PathLibrary ${CM_INITIALISE_PROJECT_PATH_Library})
    endif()

    # Parse PDB path.
    set(PathPDB "pdb")
    if(CM_INITIALISE_PROJECT_PATH_PDB)
        set(PathPDB ${CM_INITIALISE_PROJECT_PATH_PDB})
    endif()


    # Root path where the root CMakeList.txt is located.
    set(PROJECT_PATH_ROOT "${CMAKE_CURRENT_SOURCE_DIR}")

    # Output path.
    set(PROJECT_PATH_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/Output")

    # Install directory.
    cm_package_get_environment_path(PROJECT_INSTALL INSTALL_ROOT)
    if(PROJECT_INSTALL_ENV_INSTALL_ROOT)
        cm_message_verbose(STATUS "Using INSTALL_ROOT environment variable.")
        set(PROJECT_PATH_INSTALL "${PROJECT_INSTALL_ENV_INSTALL_ROOT}" CACHE PATH "Installation directory.")
    else()
        set(PROJECT_PATH_INSTALL "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Installation directory.")
    endif()

    if(NOT MSVC AND NOT XCODE)
        if(NOT "${CMAKE_BUILD_TYPE}" STREQUAL "${CMAKE_BUILD_TYPE_INT_CHECK}")
            cm_message_verbose(STATUS "Build type changed to ${CMAKE_BUILD_TYPE}")

            # Reset variables.
            set(ClearVars
                PROJECT_PATH_OUTPUT_EXECUTABLE
                PROJECT_PATH_OUTPUT_INCLUDE
                PROJECT_PATH_OUTPUT_LIBRARY
            )
            if(MSVC)
                list(APPEND ClearVars PROJECT_PATH_OUTPUT_PDB)
            endif()
            foreach(var ${ClearVars})
                #set(${var} "${var}-NOTFOUND" CACHE STRING "" FORCE)
                unset(${var} CACHE)
            endforeach()
        endif()

        set(CMAKE_BUILD_TYPE_INT_CHECK ${CMAKE_BUILD_TYPE} CACHE INTERNAL "Internal check." FORCE)
        set(BuildTarget "${CMAKE_BUILD_TYPE}")
    else()
        set(BuildTarget "")
    endif()

    set(BuildTargetDebug "")
    set(BuildTargetRelease "")
    # if(PROJECT_BUILD_TARGET_DEBUG)
        # set(BuildTarget "Debug")
    # elseif(PROJECT_BUILD_TARGET_RELEASE)
        # set(BuildTarget "Release")
    # endif()

    if(MSVC OR XCODE)
        set(BuildTargetDebug "Debug")
        set(BuildTargetRelease "Release")
    else()
        set(BuildTargetDebug "${BuildTarget}")
        set(BuildTargetRelease "${BuildTarget}")
    endif()

    # Executable directory.
    set(PROJECT_PATH_OUTPUT_EXECUTABLE "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTarget}" CACHE PATH "Executable output directory.")
    set(PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTargetDebug}")
    set(PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTargetRelease}")

    # Include directory.
    set(PROJECT_PATH_OUTPUT_INCLUDE "${PROJECT_PATH_OUTPUT}/${PathInclude}" CACHE PATH "Include output directory.")

    # Library directory.
    set(PROJECT_PATH_OUTPUT_LIBRARY "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTarget}" CACHE PATH "Library output directory.")
    set(PROJECT_PATH_OUTPUT_LIBRARY_DEBUG "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTargetDebug}")
    set(PROJECT_PATH_OUTPUT_LIBRARY_RELEASE "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTargetRelease}")

    if(MSVC)
        # PDB directory.
        set(PROJECT_PATH_OUTPUT_PDB "${PROJECT_PATH_OUTPUT}/${PathPDB}" CACHE PATH "PDB output directory.")
        set(PROJECT_PATH_OUTPUT_PDB_DEBUG "${PROJECT_PATH_OUTPUT}/${PathPDB}/${BuildTargetDebug}")
        set(PROJECT_PATH_OUTPUT_PDB_RELEASE "${PROJECT_PATH_OUTPUT}/${PathPDB}/${BuildTargetRelease}")
    endif()

    # Caching.
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_EXECUTABLE} CACHE PATH "Executable directory." FORCE)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_LIBRARY} CACHE PATH "Library directory." FORCE)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_LIBRARY} CACHE PATH "Archive directory." FORCE)
    set(CMAKE_INSTALL_PREFIX ${PROJECT_PATH_INSTALL} CACHE PATH "Install directory." FORCE)
    if(MSVC)
        set(CMAKE_PDB_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_PDB} CACHE PATH "PDB directory." FORCE)
    endif()

    cm_message_debug(STATUS "Executable Path:              ${PROJECT_PATH_OUTPUT_EXECUTABLE}")
    cm_message_debug(STATUS "Executable Path (Debug):      ${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
    cm_message_debug(STATUS "Executable Path (Release):    ${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
    cm_message_debug(STATUS "Include Path:                 ${PROJECT_PATH_OUTPUT_INCLUDE}")
    cm_message_debug(STATUS "Library Path:                 ${PROJECT_PATH_OUTPUT_LIBRARY}")
    cm_message_debug(STATUS "Library Path (Debug):         ${PROJECT_PATH_OUTPUT_LIBRARY_DEBUG}")
    cm_message_debug(STATUS "Library Path (Release):       ${PROJECT_PATH_OUTPUT_LIBRARY_RELEASE}")
    cm_message_debug(STATUS "Install Path:                 ${PROJECT_PATH_INSTALL}")
    if(MSVC)
        cm_message_debug(STATUS "PDB Path:                     ${PROJECT_PATH_OUTPUT_PDB}")
        cm_message_debug(STATUS "PDB Path (Debug):             ${PROJECT_PATH_OUTPUT_PDB_DEBUG}")
        cm_message_debug(STATUS "PDB Path (Release):           ${PROJECT_PATH_OUTPUT_PDB_RELEASE}")
    endif()

    # Clean up.
    unset(BuildTarget)
    unset(BuildTargetDebug)
    unset(BuildTargetRelease)
    unset(_oneValueArgs)
    unset(CM_INITIALISE_PROJECT_PATH_Binary)
    unset(CM_INITIALISE_PROJECT_PATH_Include)
    unset(CM_INITIALISE_PROJECT_PATH_Library)
    unset(CM_INITIALISE_PROJECT_PATH_PDB)
endmacro()




# ************************************************************
# Initialise Local Paths
# ************************************************************
macro(CM_INITIALISE_LOCAL_VARIABLE)
    # Path to the header directory.
    set(LOCAL_PATH_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/include")

    # Path to the source directory.
    set(LOCAL_PATH_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/src")
endmacro()




# ************************************************************
# Initialise project SDK
macro(INITIALISE_PROJECT_SDK)
    if(NOT DEFINED PROJECT_PATH_SDK_HOME)
        # Find for defined environment variables.
        cm_message_verbose(STATUS "SDK doesn't exists. Create the SDK path.")
        cm_package_get_environment_path(PROJECT_SDK SDK_ROOT)
        if(PROJECT_SDK_ENV_SDK_ROOT)
            cm_message_verbose(STATUS "Set SDK home to ${PROJECT_SDK_ENV_SDK_ROOT}.")
            set(PROJECT_PATH_SDK_HOME "${PROJECT_SDK_ENV_SDK_ROOT}" CACHE PATH "Path to the SDK directory.")
        else()
            set(PROJECT_PATH_SDK_HOME "" CACHE PATH "Path to the SDK directory.")
        endif()

        # Clean up.
        unset(PROJECT_SDK_ENV_SDK_ROOT)
    endif()
endmacro()




# ************************************************************
# Initialise library in the project SDK
macro(INITIALISE_PROJECT_SDK_LIBRARY)
    if(PROJECT_PATH_SDK_HOME)
        # Locate the IncludeCustom.cmake.
        find_file(SdkCustomFile "IncludeCustom.cmake" HINTS "${PROJECT_PATH_SDK_HOME}")
        if(SdkCustomFile)
            cm_message_debug(STATUS "IncludeCustom.cmake is located.")
            include(${SdkCustomFile})
        else()
            cm_message_status(STATUS "Failed to locate the IncludeCustom.cmake.")
        endif()

        # Locate the IncludeSdk.cmake.
        find_file(SdkFile "IncludeSdk.cmake" HINTS "${PROJECT_PATH_SDK_HOME}")
        if(SdkFile)
            cm_message_debug(STATUS "IncludeSdk.cmake is located.")
            include(${SdkFile})
        else()
            cm_message_status("" "Failed to locate the IncludeSdk.cmake.")
        endif()

        unset(SdkCustomFile CACHE)
        unset(SdkFile CACHE)
    endif()
endmacro()




# ************************************************************
# Install sources
# ************************************************************
macro(INSTALL_SOURCES)
    # Help information.
    cm_message_header(INSTALL_SOURCES)
    #cm_message_help("Required options:")
    #cm_message_help("[Headers]        -> Headers to install.")
    cm_message_help("Optional options:")
    cm_message_help("[SubPath]        -> Sub path of the current install diretory (${PROJECT_PATH_INSTALL}).")

    # Parse options.
    set(_oneValueArgs SubPath)
    #set(multiValueArgs Files)
    #cmake_parse_arguments(INSTALL_SOURCES "" "${_oneValueArgs}" "${multiValueArgs}" ${ARGN})
    cmake_parse_arguments(INSTALL_SOURCES "" "${_oneValueArgs}" "" ${ARGN})

    # Default options.
    if(NOT INSTALL_SOURCES_SubPath)
        set(INSTALL_SOURCES_SubPath "/src")
    endif()

    # Parse "Files".
    #if(INSTALL_SOURCES_Files)
    if(DEFINED LOCAL_SOURCES)
        #foreach(source ${INSTALL_SOURCES_Files})
        foreach(source ${LOCAL_SOURCES})
            # Example:
            # Replace c:/library/include/core/Library.h -> c:/builds/library/include/core/Library.h
            string(REPLACE ${LOCAL_PATH_SOURCE} "${PROJECT_PATH_INSTALL}${INSTALL_SOURCES_SubPath}" InstallFile ${source} )
            if(NOT ${source} STREQUAL ${InstallFile})
                # Get path only.
                # Example:
                # c:/builds/library/include/core
                get_name_component(DestPath ${InstallFile} PATH)

                # Install file with sub path if exists.
                # Example:
                # c:/library/include/Prerequisites.h -> c:/builds/library/include/Prerequisites.h
                # c:/library/include/core/Library.h -> c:/builds/library/include/core/Library.h
                install(FILES ${source} DESTINATION ${DestPath})
                cm_message_debug(STATUS "Install [${source}] to [${DestPath}]")
            endif()

            unset(InstallFile CACHE)
        endforeach()
    else()
        cm_message_debug(STATUS "No files were supplied.")
    endif()

    # Clean up.
    unset(_oneValueArgs)
    #unset( multiValueArgs)
    unset(INSTALL_SOURCES_Files)
    unset(INSTALL_SOURCES_SubPath)

    cm_message_footer_help(INSTALL_SOURCES)
endmacro()




# ************************************************************
# Copy "as it" into destination
#macro(COPY_RAW SRC DEST)
    #if(WIN32)
    #    cm_package_get_environment_path(WINDOWS windir)
    #    if(DEFINED WINDOWS_ENV_windir)
    #        find_file(PROGRAM_FOUND NAMES "xcopy.exe" HINTS "${WINDOWS_ENV_windir}" PATH_SUFFIXES "system32")
    #        execute_process(COMMAND xcopy "${SRC}" "${DST}" /y /s /e /i /d)
    #    endif()
    #endif()
#endmacro()




# ************************************************************
# Generate UUID
# ************************************************************
macro(GENERATE_UUID Prefix Name)
    # Help information.
    cm_message_header(GENERATE_UUID)
    cm_message_help("Required:")
    cm_message_help("[Prefix]      -> Variable to save the result.")
    cm_message_help("[Name]        -> Name to use for generation of UUID.")
    cm_message_help("Optional:")
    cm_message_help("[Namespace]   -> Namespace to use.")
    cm_message_help("[Type]        -> Type to use [MD5|SHA1].")

    # Default values.
    set(Namespace "00000000-0000-0000-0000-000000000000")
    set(Type "MD5")

    # Parse options.
    set(_oneValueArgs Namespace Type)
    cmake_parse_arguments(GENERATE_UUID "" "${_oneValueArgs}" "" ${ARGN})

    # Namespace
    if(GENERATE_UUID_Namespace)
        set(Namespace "${GENERATE_UUID_Namespace}")
    endif()

    # Type
    if(GENERATE_UUID_Type)
        set(Type "${GENERATE_UUID_Type}")
    endif()

    # Generate
    string(UUID ${Prefix} NAMESPACE ${Namespace} NAME ${Name} TYPE ${Type})
    cm_message_verbose(STATUS "Generated UUID: ${${Prefix}}")

    # Clean up.
    unset(_oneValueArgs)
    unset(GENERATE_UUID_Namespace)
    unset(GENERATE_UUID_Type)

    cm_message_footer(GENERATE_UUID)
endmacro()


# ************************************************************
# Install binaries
macro(INSTALL_BINARY Prefix)
    # Help information.
    cm_message_header(INSTALL_BINARY_${Prefix})
    cm_message_help("Required:")
    cm_message_help("[Prefix]     -> The Prefix to use. Example '${Prefix}' for respective related files.")
    cm_message_help("Optional:")
    cm_message_help("[SubPath]    -> Sub path in ${PROJECT_PATH_INSTALL}.")

    # Parse options.
    set(_oneValueArgs SubPath)
    cmake_parse_arguments(INSTALL_BINARY_${Prefix} "" "${_oneValueArgs}" "" ${ARGN})

    # Install debug files.
    if(${Prefix}_BINARY_DEBUG)
        foreach(DebugFile ${${Prefix}_BINARY_DEBUG})
            install(FILES ${DebugFile} DESTINATION "${PROJECT_PATH_INSTALL}${INSTALL_BINARY_${Prefix}_SubPath}" CONFIGURATIONS Debug)
        endforeach()
    endif()

    # Install release files.
    if(${Prefix}_BINARY_RELEASE)
        foreach(ReleaseFile ${${Prefix}_BINARY_RELEASE})
            install(FILES ${ReleaseFile} DESTINATION "${PROJECT_PATH_INSTALL}${INSTALL_BINARY_${Prefix}_SubPath}" CONFIGURATIONS Release)
        endforeach()
    endif()

    # Clean up.
    unset(_oneValueArgs)
    unset(INSTALL_BINARY_${Prefix}_SubPath)

    cm_message_footer(INSTALL_BINARY_${Prefix})
endmacro()




# ************************************************************
# Install debug symbols
macro(INSTALL_DEBUG_SYMBOLS)
    if(MSVC)
        # Help information.
        cm_message_header(INSTALL_DEBUG_SYMBOLS)
        cm_message_help("Optional:")
        cm_message_help("[Name]       -> Name of the PDB file. Default is the '${PROJECT_NAME}${CMAKE_DEBUG_POSTFIX}.pdb'.")
        cm_message_help("[SubPath]    -> Sub path in ${PROJECT_PATH_INSTALL}. Default is 'bin'.")

        # Parse options.
        set(_oneValueArgs Name SubPath)
        cmake_parse_arguments(INSTALL_DEBUG_SYMBOLS "" "${_oneValueArgs}" "" ${ARGN})

        # Default options.
        set(Name "${PROJECT_NAME}")
        set(Path "${PROJECT_PATH_INSTALL}/bin")

        # Parse "Name".
        if(INSTALL_DEBUG_SYMBOLS_Name)
            set(Name ${INSTALL_DEBUG_SYMBOLS_Name})
        endif()

        # Parse "SubPath".
        if(INSTALL_DEBUG_SYMBOLS_SubPath)
            set(Path "${PROJECT_PATH_INSTALL}${INSTALL_DEBUG_SYMBOLS_SubPath}")
        endif()

        # Find the existence of the source.
        set(PdbFile "${CMAKE_CURRENT_BINARY_DIR}/Generated.pdb")
        get_name_component(_name ${PdbFile} NAME)
        get_name_component(_path ${PdbFile} PATH)
        find_file(_found NAMES ${_name} HINTS ${_path})

        # Copy the file if exists.
        if(_found)
            install(
                FILES "${PdbFile}"
                DESTINATION "${Path}"
                CONFIGURATIONS Debug
                RENAME "${Name}${CMAKE_DEBUG_POSTFIX}.pdb"
           )
            install(
                FILES "${PdbFile}"
                DESTINATION "${Path}"
                CONFIGURATIONS Release
                RENAME "${Name}.pdb"
           )
            cm_message_verbose(STATUS "Install debug symbol ${_name}.")
        else()
            cm_message_debug("" "Failed to locate: ${PdbFile}")
        endif()

        # Clean up.
        unset(_oneValueArgs)
        unset(INSTALL_DEBUG_SYMBOLS_Name)
        unset(INSTALL_DEBUG_SYMBOLS_SubPath)
        unset(_found CACHE)
        unset(_name)
        unset(_path)
        unset(PdbFile)

        cm_message_footer(INSTALL_DEBUG_SYMBOLS)
    endif()
endmacro()




# ************************************************************
# Install files.
macro(INSTALL_FILES Files)
    # Help information.
    cm_message_header(INSTALL_FILES)
    cm_message_help("Required:")
    cm_message_help("[Files]     -> Files to install.")
    cm_message_help("Optional:")
    cm_message_help("[SubPath]    -> Sub path in the installation directory (${PROJECT_PATH_INSTALL}).")

    # Parse options.
    set(_oneValueArgs SubPath)
    cmake_parse_arguments(INSTALL_FILES "" "${_oneValueArgs}" "" ${ARGN})

    # Working variables.
    set(Path "${PROJECT_PATH_INSTALL}${INSTALL_FILES_SubPath}")

    # Install files.
    foreach(f ${Files})
        install(FILES "${f}" DESTINATION "${Path}")
        cm_message_verbose(STATUS "Install [${f}] to ${Path}.")
    endforeach()

    # Clean up.
    unset(Path)
    unset(_oneValueArgs)
    unset(INSTALL_FILES_SubPath)

    cm_message_footer(INSTALL_FILES)
endmacro()




# ************************************************************
# Install headers
macro(INSTALL_HEADERS)
    # Help information.
    cm_message_header(INSTALL_HEADERS)
    #cm_message_help("Required options:")
    #cm_message_help("[Headers]        -> Headers to install.")
    cm_message_help("Optional options:")
    cm_message_help("[SubPath]        -> Sub path of the current install diretory (${PROJECT_PATH_INSTALL}).")

    # Parse options.
    set(_oneValueArgs SubPath)
    #set(multiValueArgs Files)
    #cmake_parse_arguments(INSTALL_HEADERS "" "${_oneValueArgs}" "${multiValueArgs}" ${ARGN})
    cmake_parse_arguments(INSTALL_HEADERS "" "${_oneValueArgs}" "" ${ARGN})

    # Default options.
    if(NOT INSTALL_HEADERS_SubPath)
        set(INSTALL_HEADERS_SubPath "/include")
    endif()

    # Parse "Files".
    #if(INSTALL_HEADERS_Files)
    if(DEFINED LOCAL_HEADERS)
        #foreach(header ${INSTALL_HEADERS_Files})
        foreach(header ${LOCAL_HEADERS})
            # Example:
            # Replace c:/library/include/core/Library.h -> c:/builds/library/include/core/Library.h
            string(REPLACE ${LOCAL_PATH_HEADER} "${PROJECT_PATH_INSTALL}${INSTALL_HEADERS_SubPath}" InstallFile ${header})
            if(NOT ${header} STREQUAL ${InstallFile})
                # Get path only.
                # Example:
                # c:/builds/library/include/core
                get_name_component(DestPath ${InstallFile} PATH)

                # Install file with sub path if exists.
                # Example:
                # c:/library/include/Prerequisites.h -> c:/builds/library/include/Prerequisites.h
                # c:/library/include/core/Library.h -> c:/builds/library/include/core/Library.h
                install(FILES ${header} DESTINATION ${DestPath})
                cm_message_debug(STATUS "Install [${header}] to [${DestPath}]")
            endif()

            unset(InstallFile CACHE)
        endforeach()
    else()
        cm_message_debug(STATUS "No files were supplied.")
    endif()

    # Clean up.
    unset(_oneValueArgs)
    #unset(multiValueArgs)
    unset(INSTALL_HEADERS_Files)
    unset(INSTALL_HEADERS_SubPath)

    cm_message_footer_help(INSTALL_HEADERS)
endmacro()




# ************************************************************
# Remove new C++ features
macro(REMOVE_NEW_CXX_FEATURES)
    if(UNIX OR MINGW)
        check_cxx_compiler_flag(-std=c++11 CompilerSupports_CXX11)
        check_cxx_compiler_flag(-std=c++0x CompilerSupports_CXX0X)
        if(CompilerSupports_CXX11)
            remove_value(PROJECT_COMPILER_CXX_FLAGS "-std=c++11" CACHING)
        elseif(CompilerSupports_CXX0X)
            remove_value(PROJECT_COMPILER_CXX_FLAGS "-std=c++0x" CACHING)
        endif()
        unset(CompilerSupports_CXX11)
        unset(CompilerSupports_CXX0X)
    endif()

    set(PROJECT_CXX_SUPPORTS FALSE)
endmacro()




# ************************************************************
# Remove value from the variable
macro(REMOVE_VALUE Prefix Value)
    # Help information.
    cm_message_help_star_line()
    cm_message_help("Required:")
    cm_message_help("[Prefix]      -> Prefix of the variable to process.")
    cm_message_help("[Value]       -> Value to validate.")
    cm_message_help("Optional:")
    cm_message_help("[CACHING]     -> Flag to caching.")
    cm_message_help("[Description] -> Description.")
    cm_message_debug(STATUS "Value to remove: '${Value}' from '${${Prefix}}'")

    # Parse options.
    set(options CACHING)
    set(_oneValueArgs Description)
    cmake_parse_arguments(REMOVE_VALUE "${options}" "${_oneValueArgs}" "" ${ARGN})

    string(REPLACE "${Value}" "" NoSpace "${${Prefix}}")
    string(REPLACE " ${Value}" "" Space "${${Prefix}}")

    if(NoSpacE)
        set(ValueToSet ${NoSpace})
    elseif(Space)
        set(ValueToSet ${Space})
    endif()

    if(NOT ValueToSet STREQUAL "${${Prefix}}")
        if(REMOVE_VALUE_CACHING)
            cm_message_debug(STATUS "Remove '${Value}' from ${Prefix} in CACHE mode.")
            set(${Prefix} "${ValueToSet}" CACHE STRING "${REMOVE_VALUE_Description}" FORCE)
        else()
            cm_message_debug(STATUS "Remove '${Value}' from ${Prefix}.")
            set(${Prefix} "${ValueToSet}")
        endif()
    endif()

    unset(NoSpace)
    unset(Space)
    unset(ValueToSet)
    unset(options)
    unset(_oneValueArgs)
    unset(REMOVE_VALUE_CACHING)
    unset(REMOVE_VALUE_Description)

    cm_message_help_star_line()
endmacro()



# ************************************************************
# Regex compatiple.
macro(REGEX_COMPATIBLE Var OutVar)
    string(REPLACE "+" "\\+" ModVar "${Var}")
    string(REPLACE "/" "\\/" ModVar "${ModVar}")
    set(${OutVar} ${ModVar})
    unset(ModVar)
endmacro()




# ************************************************************
# Toggling enabling state of variables. Only set when 'STATE' is true.
macro(TOGGLE_ENABLING_STATE State Vars)
    foreach(var ${Vars})
        if(DEFINED ${var})
            if(${State})
                set(${var}_STATE 1)
            else()
                set(${var}_STATE ${${var}})
            endif()
        endif()
    endforeach()
endmacro()




# ************************************************************
# Verify Visual Studio environment.
macro(VERIFY_MSVC_ENV Output)
    cm_package_get_environment_path(VERIFY VisualStudioVersion)
    if(VERIFY_ENV_VisualStudioVersion)
        cm_message_status(STATUS "Visual Studio environment exists.")
        cm_message_status(STATUS "Visual Studio version: ${VERIFY_ENV_VisualStudioVersion}")
        set(${Output} 1)
    else()
        cm_message_status("" "Visual Studio environment couldn't be located.")
        set(${Output} 0)
    endif()
endmacro()
