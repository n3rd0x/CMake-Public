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
# ====================
# Print project details
# ====================
macro(DEBUG_PRINT_PROJECT_DETAILS)
    set(_multiValueArgs SubProjects)
    cmake_parse_arguments(PRINT_PROJECT_DETAILS "" "" "${_multiValueArgs}" ${ARGN})

    message("** Print Project Details **")
    message("Current:   ${CMAKE_PROJECT_NAME}")
    message("Version:   ${CMAKE_PROJECT_VERSION}")
    message("   Major:  ${CMAKE_PROJECT_VERSION_MAJOR}")
    message("   Minor:  ${CMAKE_PROJECT_VERSION_MINOR}")
    message("   Patch:  ${CMAKE_PROJECT_VERSION_PATCH}")
    message("   Tweak:  ${CMAKE_PROJECT_VERSION_TWEAK}")

    if(PRINT_PROJECT_DETAILS_SubProjects)
        message("SubProjects:")
        foreach(pro ${PRINT_PROJECT_DETAILS_SubProjects})
            if(${pro}_PROJECT_VERSION)
                message("   Project:   ${pro}")
                message("   Version:   ${${pro}_PROJECT_VERSION}")
                message("       Major:  ${${pro}_PROJECT_VERSION_MAJOR}")
                message("       Minor:  ${${pro}_PROJECT_VERSION_MINOR}")
                message("       Patch:  ${${pro}_PROJECT_VERSION_PATCH}")
                message("       Tweak:  ${${pro}_PROJECT_VERSION_TWEAK}")
            else()
                message("   The project ${pro} doesn't exists.")
            endif()
        endforeach()
    endif()
    message("****************************")

    # Clean up.
    unset(_multiValueArgs)
    unset(PRINT_PROJECT_DETAILS_SubProjects)
endmacro()





# ************************************************************
# Add definition
# ************************************************************
macro(CM_ADD_DEFINITION Value)
    add_definitions(-D${Value})
    cm_message_debug(STATUS "Add definition (${Value})")
endmacro()




# ************************************************************
# Append value to list
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
# Add new C++ features
#macro(ADD_NEW_CXX_FEATURES)
#    if(UNIX OR MINGW)
#        check_cxx_compiler_flag(-std=c++11 CompilerSupports_CXX11)
#        check_cxx_compiler_flag(-std=c++0x CompilerSupports_CXX0X)

#        set(Value "")
#        if(CompilerSupports_CXX11)
#            set(Value "-std=c++11")
#            set(PROJECT_COMPILER_NEW_CXX_SUPPORT TRUE)
#        elseif(CompilerSupports_CXX0X)
#            set(Value "-std=c++0x")
#            set(PROJECT_COMPILER_NEW_CXX_SUPPORT TRUE)
#        else()
#            cm_message_status("" "The compiler ${CMAKE_CXX_COMPILER} has no support for new C++ features.")
#            set(PROJECT_COMPILER_NEW_CXX_SUPPORT FALSE)
#        endif()

#        if(PROJECT_COMPILER_NEW_CXX_SUPPORT)
#            cm_add_value(PROJECT_COMPILER_CXX_FLAGS ${Value} CACHING)
#        endif()

#        unset(Value)
#        unset(CompilerSupports_CXX11)
#        unset(CompilerSupports_CXX0X)
#    elseif(MSVC)
#        # New C++ features are supported from Visual Studio 2013 (v12.0).
#        if(MSVC_VERSION GREATER 1700)
#            set(PROJECT_COMPILER_NEW_CXX_SUPPORT TRUE)
#        else()
#            cm_message_status("" "The compiler ${CMAKE_CXX_COMPILER} has no support for new C++ features. This feature are available from Visual Studio 2013 (v12.0).")
#            set(PROJECT_COMPILER_NEW_CXX_SUPPORT FALSE)
#        endif()
#    endif()
#endmacro()




# ************************************************************
# Copy data from target.
macro(ADD_DATA_TARGET SrcFile)
    # Help information.
    message_header(ADD_DATA_TARGET)
    message_help("Required:")
    message_help("[SrcFile]    -> The source file.")
    message_help("Optional:")
    message_help("[GENERATE]   -> The source file is a template file.")
    message_help("[Name]       -> Destination name. Default: Same as the source.")
    message_help("[SubPath]    -> Sub path of output directory.")

    # Parse options.
    set(options GENERATE)
    set(oneValueArgs Name SubPath)
    cmake_parse_arguments(ADD_DATA_TARGET "${options}" "${oneValueArgs}" "" ${ARGN})

    # Find the existence of the source.
    get_filename_component(FileName ${SrcFile} NAME)
    get_filename_component(FilePath ${SrcFile} PATH)
    find_file(FileFound NAMES ${FileName} HINTS ${FilePath})
    if(FileFound)
        # Working vars.
        set(FileToCopy "${FileFound}")

        # Parse "Name".
        if(ADD_DATA_TARGET_Name)
            set(FileName ${ADD_DATA_TARGET_Name})
        endif()

        # Default output path.
        if(MSVC OR XCODE)
            set(OutputPath "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>")
        else()
            set(OutputPath "${PROJECT_PATH_OUTPUT_EXECUTABLE}")
        endif()

        # Parse "SubPath".
        if(ADD_DATA_TARGET_SubPath)
            set(OutputPath "${OutputPath}${ADD_DATA_TARGET_SubPath}")
        endif()

        # Generate template file and add command.
        if(ADD_DATA_TARGET_GENERATE)
            cm_message_verbose(STATUS "Generate from template file.")
            configure_file(${FileToCopy} "${CMAKE_CURRENT_BINARY_DIR}/${FileName}")
            set(FileToCopy "${CMAKE_CURRENT_BINARY_DIR}/${FileName}")
        endif()

        # Add command.
        add_custom_command(
            TARGET ALL_CopyData
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${FileToCopy}
            "${OutputPath}/${FileName}"
       )

        if(ADD_DATA_TARGET_GENERATE)
            cm_message_verbose(STATUS "Adding [${FileToCopy}] to ALL_CopyData target.")
        else()
            cm_message_verbose(STATUS "Adding [${SrcFile}] to ALL_CopyData target.")
        endif()
        unset(OutputPath)
        unset(FileToCopy)
    else()
        cm_message_status("" "Failed to locate: ${SrcFile}")
    endif()

    # Clean up.
    unset(options)
    unset(oneValueArgs)
    unset(ADD_DATA_TARGET_GENERATE)
    unset(ADD_DATA_TARGET_Name)
    unset(ADD_DATA_TARGET_SubPath)
    unset(FileFound CACHE)
    unset(FileName)
    unset(FilePath)

    message_footer(ADD_DATA_TARGET)
endmacro()









# ************************************************************
# Add value into variable
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
    # ----------------------------------------
    # Parse Options
    # ----------------------------------------
    set(_options AS_STRING CACHING)
    set(_oneValueArgs Description)
    cmake_parse_arguments(CM_ADD_VALUE "${_options}" "${_oneValueArgs}" "" ${ARGN})




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
        if(CM_ADD_VALUE_AS_STRING)
            cm_message_debug(STATUS "Make as string arguments.")
            list(JOIN _values " " _values)
        endif()

        # Cache the variable if specified.
        if(CM_ADD_VALUE_CACHING)
            cm_message_debug(STATUS "Adding '${Value}' to ${Prefix} in cache mode.")
            set(${Prefix} ${_values} CACHE STRING "${CM_ADD_VALUE_Description}" FORCE)
        else()
            cm_message_debug(STATUS "Adding '${Value}' to ${Prefix}.")
            set(${Prefix} ${_values})
        endif()
    else()
        cm_message_debug(STATUS "Value '${Value}' exists, skipping adding to ${Prefix}.")
    endif()




    # ----------------------------------------
    # Clean Up
    # ----------------------------------------
    unset(_options)
    unset(_oneValueArgs)
    unset(_valueFound)
    unset(_values)
    unset(CM_ADD_VALUE_AS_STRING)
    unset(CM_ADD_VALUE_CACHING)
    unset(CM_ADD_VALUE_Description)
endmacro()









# ************************************************************
# Generate group files, create a common variable for all grouped files.
macro(BUILD_GENERATE_GROUP_FILES Prefix)
    message_header(BUILD_GENERATE_GROUP_FILES)
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

    message_footer(BUILD_GENERATE_GROUP_FILES)
endmacro()




# ************************************************************
# Group files.
macro(BUILD_GROUP_FILES)
    # Help information.
    message_header(BUILD_GROUP_FILES)
    message_help("Required options:")
    message_help("[Prefix]         -> Prefix for this group section.")
    message_help("Optional options:")
    message_help("[Groups]         -> Organize in groups.")
    message_help("[Headers]        -> Header files.")
    message_help("[Sources]        -> Source files.")
    message_help("[Files]          -> Generic files.")

    # Working members.
    set(GroupName "")

    # Parse options.
    set(oneValueArgs Prefix)
    set(multiValueArgs Groups Headers Sources Files)
    cmake_parse_arguments(BUILD_GROUP_FILES "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

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
                get_filename_component(FilePath ${header} PATH)
                if(FilePath)
                    cm_message_debug(STATUS "Path located: ${FilePath}")
                    if(NOT ${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER)
                        set(PathExists FALSE)
                    else()
                        string(REGEX MATCHALL ${FilePath} PathExists ${${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER})
                    endif()

                    if(NOT PathExists)
                        cm_message_debug(STATUS "Add path into variable.")
                        set(${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER ${${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER} ${FilePath})
                    endif()
                    unset(PathExists)
                endif()
                unset(FilePath)
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
    unset(oneValueArgs)
    unset(multiValueArgs)
    unset(BUILD_GROUP_FILES_Prefix)
    unset(BUILD_GROUP_FILES_Groups)
    unset(BUILD_GROUP_FILES_Headers)
    unset(BUILD_GROUP_FILES_Sources)
    unset(BUILD_GROUP_FILES_Files)

    message_footer(BUILD_GROUP_FILES)
endmacro()




# ************************************************************
# Copy build file to the output directory
macro(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY)
    # Help information.
    message_header(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY)
    message_help("Available options:")
    message_help("[Path]       -> Output directory. Default: ${PROJECT_PATH_OUTPUT_EXECUTABLE}.")
    message_help("[SubPath]    -> Sub directory of the output directory.")

    # Parse options.
    set(oneValueArgs Path SubPath)
    cmake_parse_arguments(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY "" "${oneValueArgs}" "" ${ARGN})

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
    unset(oneValueArgs)
    unset(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path)
    unset(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_SubPath)
    unset(Path)

    message_footer(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY)
endmacro()




# ************************************************************
# Copy a single file to the output directory
macro(COPY_FILE_TO_OUTPUT_DIRECTORY SrcFile DstFileName)
    # Help information.
    message_header(COPY_FILE_TO_OUTPUT_DIRECTORY)
    message_help("Required:")
    message_help("[SrcFile]        -> Source file.")
    message_help("[DstFileName]    -> Destination file name.")
    message_help("Available options:")
    message_help("[Params]         -> CMake parameters.")
    message_help("[SubPath]        -> Sub directory of the output directory.")

    # Parse options.
    set(oneValueArgs SubPath)
    cmake_parse_arguments(COPY_FILE_TO_OUTPUT_DIRECTORY "" "${oneValueArgs}" "" ${ARGN})

    # With Visual Studio we will copy the file into the debug and release directory.
    if(MSVC OR XCODE)
        copy_single_file("${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Debug${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFileName}" "${COPY_SINGLE_FILE_Params}")
        copy_single_file("${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Release${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFileName}" "${COPY_SINGLE_FILE_Params}")
    else()
        copy_single_file("${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFileName}" "${COPY_SINGLE_FILE_Params}")
    endif()

    # Clean up.
    unset(oneValueArgs)
    unset(COPY_SINGLE_FILE_Params)
    unset(COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath)

    message_footer(COPY_FILE_TO_OUTPUT_DIRECTORY)
endmacro()




# ************************************************************
# Copy project template
macro(COPY_PROJECT_TEMPLATE)
    # Help information.
    message_header(COPY_PROJECT_TEMPLATE)
    message_help("Available options:")
    message_help("[Source]         -> Path to the source file.")
    message_help("[Destination]    -> Path to the destination file.")

    # Default values.
    set(Source "")
    set(Destination "")

    if(MSVC)
        set(Source "${PROJECT_PATH_CMAKE_TEMPLATE}/MsvcProject_in.vcxproj.user")
        set(Destination "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.vcxproj.user")
    endif()

    # Parse options.
    set(oneValueArgs Source Destination)
    cmake_parse_arguments(COPY_PROJECT_TEMPLATE "" "${oneValueArgs}" "" ${ARGN})

    # Parse source.
    if(COPY_PROJECT_TEMPLATE_Source)
        set(Source ${COPY_PROJECT_TEMPLATE_Source})
        cm_message_debug(STATUS "Source: ${COPY_PROJECT_TEMPLATE_Source}")
    endif()

    # Parse destination.
    if(COPY_PROJECT_TEMPLATE_Destination)
        set(Destination ${COPY_PROJECT_TEMPLATE_Destination})
        cm_message_debug(STATUS "Destination: ${COPY_PROJECT_TEMPLATE_Destination}")
    endif()

    # Copy the file.
    # TST 2014-08-29
    # At the moment only MSVC is supported.
    if(MSVC)
        copy_single_file(${Source} ${Destination} "")
    endif()

    # Clean up.
    unset(Source)
    unset(Destination)
    unset(oneValueArgs)
    unset(COPY_PROJECT_TEMPLATE_Source)
    unset(COPY_PROJECT_TEMPLATE_Destination)

    message_footer(COPY_PROJECT_TEMPLATE)
endmacro()




# ************************************************************
# Copy a single file
macro(COPY_SINGLE_FILE SrcFile DstFile)
    # Help information.
    message_header(COPY_SINGLE_FILE)
    message_help("Required:")
    message_help("[SrcFile]    -> Source file.")
    message_help("[DstFile]    -> Destination file.")
    message_help("Available options:")
    message_help("[Params]     -> CMake parameters.")

    # Parse options.
    set(oneValueArgs SubPath)
    cmake_parse_arguments(COPY_SINGLE_FILE "" "${oneValueArgs}" "" ${ARGN})

    # Find the existence of the source.
    get_filename_component(FileName ${SrcFile} NAME)
    get_filename_component(FilePath ${SrcFile} PATH)
    find_file(FileFound NAMES ${FileName} HINTS ${FilePath})

    # Copy the file if exists.
    if(FileFound)
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
    unset(oneValueArgs)
    unset(COPY_SINGLE_FILE_Params)
    unset(FileFound CACHE)
    unset(FileName)
    unset(FilePath)

    message_footer(COPY_SINGLE_FILE)
endmacro()



# ************************************************************
# Generate dynamic library extension
# ************************************************************
macro(GENERATE_DYNAMIC_EXTENSION Value)
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
# Create dynamic library extension
# ************************************************************
macro(CREATE_DYNAMIC_EXTENSION Value)
    generate_dynamic_extension(suffix)
    set(${Value} "${${Value}}.${suffix}")
    unset(suffix)
endmacro()




# ************************************************************
# Create executable extension
# ************************************************************
macro(CREATE_EXECUTABLE_EXTENSION Value)
    if(WIN32)
        set(${Value} "${${Value}}.exe")
    endif()
endmacro()




# ************************************************************
# Create MSVC toolset
macro(CREATE_MSVC_TOOLSET OUTPUT)
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
# Create MSVC toolset with Clang
macro(CREATE_MSVC_TOOLSET_CLANG OUTPUT)
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
        get_filename_component(FileName ${SrcFile} NAME)
        get_filename_component(FilePath ${SrcFile} PATH)
        find_file(FileFound NAMES ${FileName} HINTS ${FilePath})
        if(FileFound)
            #copy_single_file(${FileFound} "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Debug/${PROJECT_NAME}_d.pdb")

            # Copy and rename.
            add_custom_command(
                TARGET ${PROJECT_NAME}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                "${FileFound}"
                "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>/${PROJECT_NAME}$<$<CONFIG:Debug>:${CMAKE_DEBUG_POSTFIX}>.pdb"
           )
        endif()

        unset(FileFound CACHE)
        unset(FileName)
        unset(FilePath)
        unset(SrcFile)
    endif()
endmacro()




# ************************************************************
# Group files
macro(GROUP_FILES TopGroup Files)
    # Help information.
    message_header(GROUP_FILES)
    message_help("Requires:")
    message_help("[TopGroup]   -> Name of the top group.")
    message_help("[Files]      -> Files to group.")
    message_help("Available options:")
    message_help("[Groups]     -> Groups.")

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

    message_footer(GROUP_FILES)
endmacro()




# ************************************************************
# Initialise project details
# ************************************************************
# Help information.
# Optional:
# [Description] -> Description of this project.
# [Major]       -> The major version.
# [Minor]       -> The minor version.
# [Path]        -> The patch version.
# [Tweak]       -> The tweak version.
macro(CM_INITIALISE_PROJECT)
    message_header(CM_INITIALISE_PROJECT)


    # ----------------------------------------
    # Policies
    # ----------------------------------------
    if(CMAKE_MAJOR_VERSION GREATER 2)
        # Compiler definitions.
        cmake_policy(SET CMP0043 NEW)
    endif()




    # ----------------------------------------
    # Parse Options
    # ----------------------------------------
    set(_oneValueArgs Description Major Minor Patch Tweak)
    cmake_parse_arguments(CM_INITIALISE_PROJECT "" "${_oneValueArgs}" "" ${ARGN})

    # Description.
    if(CM_INITIALISE_PROJECT_Description)
        set(CMAKE_PROJECT_DESCRIPTION ${CM_INITIALISE_PROJECT_Description})
    endif()

    # Major version.
    if(CM_INITIALISE_PROJECT_Major)
        set(CMAKE_PROJECT_VERSION_MAJOR ${CM_INITIALISE_PROJECT_Major})
    else()
        set(CMAKE_PROJECT_VERSION_MAJOR "0")
    endif()

    # Minor version.
    if(CM_INITIALISE_PROJECT_Minor)
        set(CMAKE_PROJECT_VERSION_MINOR ${CM_INITIALISE_PROJECT_Minor})
    else()
        set(CMAKE_PROJECT_VERSION_MINOR "0")
    endif()

    # Patch version.
    if(CM_INITIALISE_PROJECT_Patch)
        set(CMAKE_PROJECT_VERSION_PATCH ${CM_INITIALISE_PROJECT_Patch})
    else()
        set(CMAKE_PROJECT_VERSION_PATCH "0")
    endif()

    # Tweak version.
    if(CM_INITIALISE_PROJECT_Tweak)
        set(CMAKE_PROJECT_VERSION_TWEAK ${CM_INITIALISE_PROJECT_Tweak})
    else()
        set(CMAKE_PROJECT_VERSION_TWEAK "0")
    endif()




    # ----------------------------------------
    # Compiler Details
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
        set(_LongName "Visual Studio")
        set(_ShortName "VC")
        if(MSVC14)
            if(MSVC_TOOLSET_VERSION MATCHES 142)
                set(_LongName "Visual Studio 2019")
                set(_ShortName "VC16")
            elseif(MSVC_TOOLSET_VERSION MATCHES 141)
                set(_LongName "Visual Studio 2017")
                set(_ShortName "VC15")
            else()
                set(_LongName "Visual Studio 2015")
                set(_ShortName "VC14")
            endif()
        elseif(MSVC12)
            set(_LongName "Visual Studio 2013")
            set(_ShortName "VC12")
        elseif(MSVC11)
            set(_LongName "Visual Studio 2012")
            set(_ShortName "VC11")
        elseif(MSVC10)
            set(_LongName "Visual Studio 2011")
            set(_ShortName "VC10")
        endif()

        set(_ideTool "${_LongName} (${_ShortName}), ${MSVC_VERSION}")

        unset(_LongName)
        unset(_ShortName)
    elseif(XCODE)
        set(_ideTool "Apple XCode, ${XCODE_VERSION}")
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

    # Set build timestamp.
    string(TIMESTAMP PROJECT_BUILD_TIME "%d/%m-%Y")

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
    unset(_oneValueArgs)
    unset(_cCompiler)
    unset(_cxxCompiler)
    unset(_ideTool)
    unset(CM_INITIALISE_PROJECT_Description)
    unset(CM_INITIALISE_PROJECT_Major)
    unset(CM_INITIALISE_PROJECT_Minor)
    unset(CM_INITIALISE_PROJECT_Patch)
    unset(CM_INITIALISE_PROJECT_Tweak)

    message_footer(CM_INITIALISE_PROJECT)
endmacro()




# ************************************************************
# Initialise project description and version
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
# Initialise sub project details
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
macro(CM_INITIALISE_LOCAL_PROJECT Title Description)
    message_header(CM_INITIALISE_LOCAL_PROJECT)


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
    set(_oneValueArgs Major Minor Patch Tweak)
    set(_multiValueArgs Languages)
    cmake_parse_arguments(CM_INITIALISE_LOCAL_PROJECT "" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})

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
    # Output.
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
    unset(_oneValueArgs)
    unset(_multiValueArgs)
    unset(_languages)
    unset(CM_INITIALISE_LOCAL_PROJECT_Major)
    unset(CM_INITIALISE_LOCAL_PROJECT_Minor)
    unset(CM_INITIALISE_LOCAL_PROJECT_Patch)
    unset(CM_INITIALISE_LOCAL_PROJECT_Tweak)
    unset(CM_INITIALISE_LOCAL_PROJECT_Languages)

    message_footer(CM_INITIALISE_LOCAL_PROJECT)
endmacro()







# ************************************************************
# Initialise compiler flags
#macro(CM_INITIALISE_PROJECT_COMPILER_FLAGS)
#    cm_message_debug(STATUS "Project C Flags:   ${PROJECT_COMPILER_C_FLAGS}")
#    cm_message_debug(STATUS "Project Cxx Flags: ${PROJECT_COMPILER_CXX_FLAGS}")
#    #set(CMAKE_C_FLAGS "${PROJECT_COMPILER_C_FLAGS}" CACHE STRING "Project C flags." FORCE)
#    #set(CMAKE_CXX_FLAGS "${PROJECT_COMPILER_CXX_FLAGS}" CACHE STRING "Project CXX flags." FORCE)


#    cm_message_debug(STATUS "----------------------------------------")
#    cm_message_debug(STATUS "Adding compiler flags to CMAKE:")
#    separate_arguments(PROJECT_COMPILER_C_FLAGS)
#    foreach(Flag ${PROJECT_COMPILER_C_FLAGS})
#        cm_message_debug(STATUS "Iterate C Flag: ${Flag}")
#        cm_add_value(CMAKE_C_FLAGS "${Flag}" CACHING "C flags for all builds.")
#    endforeach()

#    separate_arguments(PROJECT_COMPILER_CXX_FLAGS)
#    foreach(Flag ${PROJECT_COMPILER_CXX_FLAGS})
#        cm_message_debug(STATUS "Iterate CXX Flag: ${Flag}")
#        cm_add_value(CMAKE_CXX_FLAGS "${Flag}" CACHING "C++ flags for all builds.")
#    endforeach()
#    cm_message_debug(STATUS "----------------------------------------")
#endmacro()




# ************************************************************
# Initialise C++ compiler standard
# ************************************************************
macro(CM_COMPILER_CXX_INITIALISE_STANDARD)
    set(_cxxStdName "Manually specified")
    if(CMAKE_CXX_COMPILER_ID)
        # Option for C++ standard.
        set(Project_COMPILER_CXX_STANDARD "ISO C++11" CACHE STRING "Select C++ standards.")
        set_property(
            CACHE Project_COMPILER_CXX_STANDARD PROPERTY
            STRINGS "Legacy C++ 98" "ISO C++11" "ISO C++14" "ISO C++17" "ISO C++20"
        )


        # Apply C++ standard.
        if(Project_COMPILER_CXX_APPLY_STANDARD)
            if(Project_COMPILER_CXX_STANDARD STREQUAL "ISO C++20")
                set(_cxxStdName "ISO C++20")
                set(_cxxStdFlag "-std=c++20")
                set(_cxxStdDef "CXX20_SUPPORT")
            elseif(Project_COMPILER_CXX_STANDARD STREQUAL "ISO C++17")
                set(_cxxStdName "ISO C++17")
                set(_cxxStdFlag "-std=c++17")
                set(_cxxStdDef "CXX17_SUPPORT")
            elseif(Project_COMPILER_CXX_STANDARD STREQUAL "ISO C++14")
                set(_cxxStdName "ISO C++14")
                set(_cxxStdFlag "-std=c++14")
                set(_cxxStdDef "CXX14_SUPPORT")
            elseif(Project_COMPILER_CXX_STANDARD STREQUAL "ISO C++11")
                set(_cxxStdName "ISO C++11")
                set(_cxxStdFlag "-std=c++11")
                set(_cxxStdDef "CXX11_SUPPORT")
            else()
                set(_cxxStdName "Legacy C++ 98")
            endif()

            # Reauired CMake macro "check_cxx_compiler_flag".
            # NB! This will be perfom just once.
            # Lower version of CMake there was no flag check, so we assume that the flags are supported by the compiler.
            if(_cxxStdDef)
                if(CMAKE_MAJOR_VERSION GREATER 2)
                    cm_message_verbose(STATUS "Check supported flag: ${_cxxStdFlag}")
                    check_cxx_compiler_flag(${_cxxStdFlag} ${_cxxStdDef}_STATE)
                    if(NOT ${_cxxStdDef}_STATE)
                        cm_message_status("" "The compiler has no support for C++ standard ${_cxxStdName}.")
                        set(_cxxStdName "Legacy C++ 98")
                        unset(_cxxStdFlag)
                    endif()
                endif()
            endif()

            if(_cxxStdFlag)
                cm_message_debug(STATUS "Add C++ flag (${_cxxStdFlag}).")
                list(APPEND Project_COMPILER_CXX_INTERNAL_STANDARD ${_cxxStdFlag})

                if(_cxxStdDef)
                    cm_add_definition(CXX_STANDARD_SUPPORT)
                    cm_add_definition(${_cxxStdDef})
                endif()
            endif()
        endif()
    endif()

    cm_message_status(STATUS "C++ Standard: ${_cxxStdName}")
    unset(_cxxStdFlag)
    unset(_cxxStdName)
    unset(_cxxStdDef)
endmacro()













# ************************************************************
# Initialise project environments
# ************************************************************
macro(CM_INITIALISE_PROJECT_ENVIRONMENT)
    message_header(CM_INITIALISE_PROJECT_ENVIRONMENT)


    # ----------------------------------------
    # Build Type
    # ----------------------------------------
    # Setup for single configuration system.
    if(MINGW OR UNIX)
        if(NOT MSCV AND NOT XCODE)
            set(PROJECT_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Select build type.")
            set_property(CACHE PROJECT_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)

            set(CMAKE_BUILD_TYPE ${PROJECT_BUILD_TYPE} CACHE STRING "Target mode of this project." FORCE)

            cm_message_status(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
        endif()
    endif()




    # ----------------------------------------
    # Cache Options
    # ----------------------------------------
    # Set debug postfix.
    set(CMAKE_DEBUG_POSTFIX "_d")

    # Suffix search priority.
    cm_message_verbose(STATUS "Library search priority: ${CMAKE_FIND_LIBRARY_SUFFIXES}")

    # Set state for displaying debug message.
    option(Project_CMAKE_ENABLE_DEBUG_MESSAGE "Enable debug message" OFF)

    # Set state for displaying verbose message.
    option(Project_CMAKE_ENABLE_VERBOSE_MESSAGE "Enable verbose message." OFF)

    # Load pkgconfig modules.
#    if(NOT ANDROID)
#        find_package(PkgConfig)
#        if(PKG_CONFIG_FOUND)
#            cm_message_status(STATUS "Enable 'pkgconfig' modules.")
#        endif ()
#    endif()


    # ----------------------------------------
    # Multiple Compilation
    # Set multi processor compilation.
    # For UNIX / MinGW: Use the flag -j X, where X is number of processor, for make program.
    # ----------------------------------------
    if(MSVC)
        option(PROJECT_ENABLE_MULTI_PROCESSOR_COMPILATION "Enable multi processor compilation." ON)
        if(PROJECT_ENABLE_MULTI_PROCESSOR_COMPILATION)
            cm_message_status(STATUS "Enable multi processor compilation.")
            cm_add_value(PROJECT_COMPILER_C_FLAGS "/MP" CACHING)
            cm_add_value(PROJECT_COMPILER_CXX_FLAGS "/MP" CACHING)
        else()
            cm_message_status(STATUS "Disable multi processor compilation.")
            remove_value(PROJECT_COMPILER_C_FLAGS "/MP" CACHING)
            remove_value(PROJECT_COMPILER_CXX_FLAGS "/MP" CACHING)
        endif()
    endif()


    # ----------------------------------------
    # Toolset & OS
    # ----------------------------------------
    # Set option for build for targeting XP.
    if(MSVC)
        option(PROJECT_BUILD_FOR_WIN_XP "Build for Windows XP SP3." OFF)

        set(Toolset "")
        if(PROJECT_ENABLE_LLVM_CLANG)
            if(MSVC_VERSION GREATER 1600)
                create_msvc_toolset_clang(Toolset)
            else()
                cm_message_status("" "Current version of MSVC don't support LLVM Clang.")
            endif()
        endif()

        if(PROJECT_BUILD_FOR_WIN_XP)
            if(NOT PROJECT_ENABLE_LLVM_CLANG)
                create_msvc_toolset(Toolset)
            endif()
            set(Toolset "${Toolset}_xp")
            add_definitions(-D_WIN32_WINNT=0x0501)
        endif()

        if(NOT Toolset STREQUAL "")
            # This apply only for Visual Studio 2012 and greater.
            if(MSVC_VERSION GREATER 1600)
                set(CMAKE_GENERATOR_TOOLSET ${Toolset} CACHE STRING "Platform toolset." FORCE)
            endif()
        else()
            unset(CMAKE_GENERATOR_TOOLSET CACHE)
        endif()
        unset(Toolset)
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
    # Compiler Options
    # ----------------------------------------
    # C compiler.
    if(CMAKE_C_COMPILER_LOADED)
        set(Project_COMPILER_C_INTERNAL_FLAGS "")

        set(Project_COMPILER_C_FLAGS "" CACHE STRING "Flags for the C compiler.")
        option(Project_COMPILER_C_APPLY_FLAGS "Apply C compiler flags." ON)
    endif()


    # CXX compiler.
    if(CMAKE_CXX_COMPILER_LOADED)
        set(Project_COMPILER_CXX_INTERNAL_FLAGS "")
        set(Project_COMPILER_CXX_INTERNAL_STANDARD "")

        set(Project_COMPILER_CXX_FLAGS "" CACHE STRING "Flags for the CXX compiler.")
        option(Project_COMPILER_CXX_APPLY_FLAGS "Apply CXX compiler flags." ON)
        option(Project_COMPILER_CXX_APPLY_STANDARD "Apply CXX compiler standard." ON)
        cm_compiler_cxx_initialise_standard()
    endif()






    # ----------------------------------------
    # Options
    # ----------------------------------------
    option(PROJECT_ENABLE_COMPILER_FLAGS "Enable to set compiler flags." ON)
    option(PROJECT_ENABLE_COMPILER_FLAGS2 "Enable to set compiler flags." OFF)

    cmake_dependent_option(
            PROJECT_ENABLE_COMPILER_FLAGS2 "efsadfds" ON
            "PROJECT_ENABLE_COMPILER_FLAGS" ON
        )



    option(PROJECT_ENABLE_COMPILER_DEFAULT_FLAGS "Enable default compiler flags." ON)
    if(PROJECT_ENABLE_COMPILER_DEFAULT_FLAGS)
        cm_message_status(STATUS "Enable COMPILER_DEFAULT_FLAGS.")
        if(UNIX)
            # Following OGRE warning settings.
            # -fPIC
            #   Emit position independent code, suitable for dynamic linking
            #   and avoiding any limit on the size of the global offset table.
            set(CommonFlags
                "-fPIC"
           )
        endif()

        cm_message_debug(STATUS "----------------------------------------")
        cm_message_debug(STATUS "Setting default flags:")
        foreach(Flag ${CommonFlags})
            cm_message_debug(STATUS "Iterate: ${Flag}")
            cm_add_value(PROJECT_COMPILER_C_FLAGS ${Flag} CACHING)
            cm_add_value(PROJECT_COMPILER_CXX_FLAGS ${Flag} CACHING)
        endforeach()
        cm_message_debug(STATUS "----------------------------------------")
        unset(CommonFlags)
    endif()


    # ----------------------------------------
    # Warnings
    # ----------------------------------------
    option(PROJECT_ENABLE_COMPILER_DEFAULT_WARNINGS "Enable default compiler warnings." ON)
    if(PROJECT_ENABLE_COMPILER_DEFAULT_WARNINGS)
        if(MSVC)
            #4018 -> signed / unsigned mismatch.
            #4244 -> Conversion from X to Y, possible loss of data.
            set(CommonWarnings
                "/wd4251"
                "/wd4193"
                "/wd4275"
                "/wd4244"
           )
        elseif(UNIX)
            # Following OGRE warning settings.
            set(CommonWarnings
                "-Wall"
                "-Wcast-qual"
                "-Wextra"
                "-Winit-self"
                "-Wno-long-long"
                "-Wno-missing-field-initializers"
                "-Wno-unused-parameter"
                "-Wno-overloaded-virtual"
                "-Wshadow"
                "-Wwrite-strings"
           )
        endif()

        cm_message_debug(STATUS "----------------------------------------")
        cm_message_debug(STATUS "Setting warnings flags:")
        foreach(Flag ${CommonWarnings})
            cm_message_debug(STATUS "Iterate: ${Flag}")
                if(CMAKE_C_COMPILER)
                    cm_add_value(PROJECT_COMPILER_C_FLAGS ${Flag} CACHING)
                endif()

                if(CMAKE_CXX_COMPILER)
                    cm_add_value(PROJECT_COMPILER_CXX_FLAGS ${Flag} CACHING)
                endif()
        endforeach()
        cm_message_debug(STATUS "----------------------------------------")
        unset(CommonWarnings)
    endif()


    # Install debug symbols.
    #if(MSVC)
        #option(PROJECT_INSTALL_DEBUG_SYMBOLS "Install debug symbols." ON)
    #endif()

    #set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} ${PROJECT_C_FLAGS})
    #set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} ${PROJECT_CXX_FLAGS})

    # Copy runtime dependencies target and data files.
    add_custom_target(ALL_CopyData)
    add_custom_target(ALL_CopyRuntime)


    # Output details.


    message_footer(CM_INITIALISE_PROJECT_ENVIRONMENT)
endmacro()




# ************************************************************
# Initialise default project paths.
macro(INITIALISE_PROJECT_PATH)
    # Help information.
    message_header(INITIALISE_PROJECT_PATH)
    message_help("Available options:")
    message_help("[Binary]     -> Output path of binary files. Default: 'bin'.")
    message_help("[Include]    -> Output path of include files. Default: 'include'.")
    message_help("[Library]    -> Output path of library files. Default: 'lib'.")
    if(MSVC)
        message_help("[PDB]        -> Output path of PDB files. Default: 'pdb'.")
    endif()

    # Parse options.
    set(oneValueArgs Binary Include Library)
    if(MSVC)
        set(oneValueArgs ${oneValueArgs} PDB)
    endif()
    cmake_parse_arguments(INITIALISE_PROJECT_PATH "" "${oneValueArgs}" "" ${ARGN})

    # Parse binary path.
    set(PathBinary "bin")
    if(INITIALISE_PROJECT_PATH_Binary)
        set(PathBinary ${INITIALISE_PROJECT_PATH_Binary})
    endif()

    # Parse include path.
    set(PathInclude "include")
    if(INITIALISE_PROJECT_PATH_Include)
        set(PathInclude ${INITIALISE_PROJECT_PATH_Include})
    endif()

    # Parse library path.
    set(PathLibrary "lib")
    if(INITIALISE_PROJECT_PATH_Library)
        set(PathLibrary ${INITIALISE_PROJECT_PATH_Library})
    endif()

    # Parse PDB path.
    set(PathPDB "pdb")
    if(INITIALISE_PROJECT_PATH_PDB)
        set(PathPDB ${INITIALISE_PROJECT_PATH_PDB})
    endif()


    # Root path where the root CMakeList is located.
    set(PROJECT_PATH_ROOT "${CMAKE_CURRENT_SOURCE_DIR}")

    # Output path.
    set(PROJECT_PATH_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/Output")

    # Install directory.
    package_get_environment_path(PROJECT_INSTALL INSTALL_ROOT)
    if(PROJECT_INSTALL_ENV_INSTALL_ROOT)
        cm_message_verbose(STATUS "Set install to ${PROJECT_INSTALL_ENV_INSTALL_ROOT}.")
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
    set(PROJECT_PATH_OUTPUT_EXECUTABLE         "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTarget}" CACHE PATH "Executable output directory.")
    set(PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG   "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTargetDebug}")
    set(PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTargetRelease}")

    # Include directory.
    set(PROJECT_PATH_OUTPUT_INCLUDE "${PROJECT_PATH_OUTPUT}/${PathInclude}" CACHE PATH "Include output directory.")

    # Library directory.
    set(PROJECT_PATH_OUTPUT_LIBRARY            "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTarget}" CACHE PATH "Library output directory.")
    set(PROJECT_PATH_OUTPUT_LIBRARY_DEBUG      "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTargetDebug}")
    set(PROJECT_PATH_OUTPUT_LIBRARY_RELEASE    "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTargetRelease}")

    if(MSVC)
        # PDB directory.
        set(PROJECT_PATH_OUTPUT_PDB            "${PROJECT_PATH_OUTPUT}/${PathPDB}" CACHE PATH "PDB output directory.")
        set(PROJECT_PATH_OUTPUT_PDB_DEBUG      "${PROJECT_PATH_OUTPUT}/${PathPDB}/${BuildTargetDebug}")
        set(PROJECT_PATH_OUTPUT_PDB_RELEASE    "${PROJECT_PATH_OUTPUT}/${PathPDB}/${BuildTargetRelease}")
    endif()

    # Caching.
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_EXECUTABLE} CACHE PATH "Executable directory." FORCE)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_LIBRARY} CACHE PATH "Library directory." FORCE)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_LIBRARY} CACHE PATH "Archive directory." FORCE)
    set(CMAKE_INSTALL_PREFIX ${PROJECT_PATH_INSTALL} CACHE PATH "Install directory." FORCE)
    if(MSVC)
        set(CMAKE_PDB_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_PDB} CACHE PATH "PDB directory." FORCE)
    endif()

    cm_message_debug(STATUS "Executable Path:              '${PROJECT_PATH_OUTPUT_EXECUTABLE}'")
    cm_message_debug(STATUS "Executable Path (Debug):      '${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}'")
    cm_message_debug(STATUS "Executable Path (Release):    '${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}'")
    cm_message_debug(STATUS "Include Path:                 '${PROJECT_PATH_OUTPUT_INCLUDE}'")
    cm_message_debug(STATUS "Library Path:                 '${PROJECT_PATH_OUTPUT_LIBRARY}'")
    cm_message_debug(STATUS "Library Path (Debug):         '${PROJECT_PATH_OUTPUT_LIBRARY_DEBUG}'")
    cm_message_debug(STATUS "Library Path (Release):       '${PROJECT_PATH_OUTPUT_LIBRARY_RELEASE}'")
    if(MSVC)
        cm_message_debug(STATUS "PDB Path:                     '${PROJECT_PATH_OUTPUT_PDB}'")
        cm_message_debug(STATUS "PDB Path (Debug):             '${PROJECT_PATH_OUTPUT_PDB_DEBUG}'")
        cm_message_debug(STATUS "PDB Path (Release):           '${PROJECT_PATH_OUTPUT_PDB_RELEASE}'")
    endif()

    # Clean up.
    unset(BuildTarget)
    unset(BuildTargetDebug)
    unset(BuildTargetRelease)
    unset(oneValueArgs)
    unset(INITIALISE_PROJECT_PATH_Binary)
    unset(INITIALISE_PROJECT_PATH_Include)
    unset(INITIALISE_PROJECT_PATH_Library)
    unset(INITIALISE_PROJECT_PATH_PDB)

    message_footer(INITIALISE_PROJECT_PATH)
endmacro()




# ************************************************************
# Initialise local path
macro(INITIALISE_LOCAL_VARIABLE)
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
        package_get_environment_path(PROJECT_SDK SDK_ROOT)
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
    message_header(INSTALL_SOURCES)
    #message_help("Required options:")
    #message_help("[Headers]        -> Headers to install.")
    message_help("Optional options:")
    message_help("[SubPath]        -> Sub path of the current install diretory (${PROJECT_PATH_INSTALL}).")

    # Parse options.
    set(oneValueArgs SubPath)
    #set(multiValueArgs Files)
    #cmake_parse_arguments(INSTALL_SOURCES "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    cmake_parse_arguments(INSTALL_SOURCES "" "${oneValueArgs}" "" ${ARGN})

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
                get_filename_component(DestPath ${InstallFile} PATH)

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
    unset(oneValueArgs)
    #unset( multiValueArgs)
    unset(INSTALL_SOURCES_Files)
    unset(INSTALL_SOURCES_SubPath)

    message_footer_help(INSTALL_SOURCES)
endmacro()




# ************************************************************
# Copy "as it" into destination
#macro(COPY_RAW SRC DEST)
    #if(WIN32)
    #    package_get_environment_path(WINDOWS windir)
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
    message_header(GENERATE_UUID)
    message_help("Required:")
    message_help("[Prefix]      -> Variable to save the result.")
    message_help("[Name]        -> Name to use for generation of UUID.")
    message_help("Optional:")
    message_help("[Namespace]   -> Namespace to use.")
    message_help("[Type]        -> Type to use [MD5|SHA1].")

    # Default values.
    set(Namespace "00000000-0000-0000-0000-000000000000")
    set(Type "MD5")

    # Parse options.
    set(oneValueArgs Namespace Type)
    cmake_parse_arguments(GENERATE_UUID "" "${oneValueArgs}" "" ${ARGN})

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
    unset(oneValueArgs)
    unset(GENERATE_UUID_Namespace)
    unset(GENERATE_UUID_Type)

    message_footer(GENERATE_UUID)
endmacro()


# ************************************************************
# Install binaries
macro(INSTALL_BINARY Prefix)
    # Help information.
    message_header(INSTALL_BINARY_${Prefix})
    message_help("Required:")
    message_help("[Prefix]     -> The Prefix to use. Example '${Prefix}' for respective related files.")
    message_help("Optional:")
    message_help("[SubPath]    -> Sub path in ${PROJECT_PATH_INSTALL}.")

    # Parse options.
    set(oneValueArgs SubPath)
    cmake_parse_arguments(INSTALL_BINARY_${Prefix} "" "${oneValueArgs}" "" ${ARGN})

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
    unset(oneValueArgs)
    unset(INSTALL_BINARY_${Prefix}_SubPath)

    message_footer(INSTALL_BINARY_${Prefix})
endmacro()




# ************************************************************
# Install debug symbols
macro(INSTALL_DEBUG_SYMBOLS)
    if(MSVC)
        # Help information.
        message_header(INSTALL_DEBUG_SYMBOLS)
        message_help("Optional:")
        message_help("[Name]       -> Name of the PDB file. Default is the '${PROJECT_NAME}${CMAKE_DEBUG_POSTFIX}.pdb'.")
        message_help("[SubPath]    -> Sub path in ${PROJECT_PATH_INSTALL}. Default is 'bin'.")

        # Parse options.
        set(oneValueArgs Name SubPath)
        cmake_parse_arguments(INSTALL_DEBUG_SYMBOLS "" "${oneValueArgs}" "" ${ARGN})

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
        get_filename_component(FileName ${PdbFile} NAME)
        get_filename_component(FilePath ${PdbFile} PATH)
        find_file(FileFound NAMES ${FileName} HINTS ${FilePath})

        # Copy the file if exists.
        if(FileFound)
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
            cm_message_verbose(STATUS "Install debug symbol ${FileName}.")
        else()
            cm_message_debug("" "Failed to locate: ${PdbFile}")
        endif()

        # Clean up.
        unset(oneValueArgs)
        unset(INSTALL_DEBUG_SYMBOLS_Name)
        unset(INSTALL_DEBUG_SYMBOLS_SubPath)
        unset(FileFound CACHE)
        unset(FileName)
        unset(FilePath)
        unset(PdbFile)

        message_footer(INSTALL_DEBUG_SYMBOLS)
    endif()
endmacro()




# ************************************************************
# Install files.
macro(INSTALL_FILES Files)
    # Help information.
    message_header(INSTALL_FILES)
    message_help("Required:")
    message_help("[Files]     -> Files to install.")
    message_help("Optional:")
    message_help("[SubPath]    -> Sub path in the installation directory (${PROJECT_PATH_INSTALL}).")

    # Parse options.
    set(oneValueArgs SubPath)
    cmake_parse_arguments(INSTALL_FILES "" "${oneValueArgs}" "" ${ARGN})

    # Working variables.
    set(Path "${PROJECT_PATH_INSTALL}${INSTALL_FILES_SubPath}")

    # Install files.
    foreach(f ${Files})
        install(FILES "${f}" DESTINATION "${Path}")
        cm_message_verbose(STATUS "Install [${f}] to ${Path}.")
    endforeach()

    # Clean up.
    unset(Path)
    unset(oneValueArgs)
    unset(INSTALL_FILES_SubPath)

    message_footer(INSTALL_FILES)
endmacro()




# ************************************************************
# Install headers
macro(INSTALL_HEADERS)
    # Help information.
    message_header(INSTALL_HEADERS)
    #message_help("Required options:")
    #message_help("[Headers]        -> Headers to install.")
    message_help("Optional options:")
    message_help("[SubPath]        -> Sub path of the current install diretory (${PROJECT_PATH_INSTALL}).")

    # Parse options.
    set(oneValueArgs SubPath)
    #set(multiValueArgs Files)
    #cmake_parse_arguments(INSTALL_HEADERS "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    cmake_parse_arguments(INSTALL_HEADERS "" "${oneValueArgs}" "" ${ARGN})

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
                get_filename_component(DestPath ${InstallFile} PATH)

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
    unset(oneValueArgs)
    #unset(multiValueArgs)
    unset(INSTALL_HEADERS_Files)
    unset(INSTALL_HEADERS_SubPath)

    message_footer_help(INSTALL_HEADERS)
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
    message_help_star_line()
    message_help("Required:")
    message_help("[Prefix]      -> Prefix of the variable to process.")
    message_help("[Value]       -> Value to validate.")
    message_help("Optional:")
    message_help("[CACHING]     -> Flag to caching.")
    message_help("[Description] -> Description.")
    cm_message_debug(STATUS "Value to remove: '${Value}' from '${${Prefix}}'")

    # Parse options.
    set(options CACHING)
    set(oneValueArgs Description)
    cmake_parse_arguments(REMOVE_VALUE "${options}" "${oneValueArgs}" "" ${ARGN})

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
    unset(oneValueArgs)
    unset(REMOVE_VALUE_CACHING)
    unset(REMOVE_VALUE_Description)

    message_help_star_line()
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
    package_get_environment_path(VERIFY VisualStudioVersion)
    if(VERIFY_ENV_VisualStudioVersion)
        cm_message_status(STATUS "Visual Studio environment exists.")
        cm_message_status(STATUS "Visual Studio version: ${VERIFY_ENV_VisualStudioVersion}")
        set(${Output} 1)
    else()
        cm_message_status("" "Visual Studio environment couldn't be located.")
        set(${Output} 0)
    endif()
endmacro()
