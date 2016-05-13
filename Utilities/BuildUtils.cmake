# ************************************************************
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the “Software”),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ************************************************************


# ************************************************************
# Add new C++ features
macro(ADD_NEW_CXX_FEATURES)
    check_cxx_compiler_flag(-std=c++11 CompilerSupports_CXX11)
    check_cxx_compiler_flag(-std=c++0x CompilerSupports_CXX0X)
    
    set(Value "")
    if(CompilerSupports_CXX11)
        set(Value "-std=c++11")
        set(PROJECT_CXX_SUPPORTS TRUE)
    elseif(CompilerSupports_CXX0X)
        set(Value "-std=c++0x")
        set(PROJECT_CXX_SUPPORTS TRUE)
    else()
        message_status("" "The compiler ${CMAKE_CXX_COMPILER} has no support for new C++ features.")
        set(PROJECT_CXX_SUPPORTS FALSE)
    endif()
    
    if(PROJECT_CXX_SUPPORTS)
        add_value("${Value}" PROJECT_CXX_FLAGS CACHING)
    endif()
    
    unset(Value)
    unset(CompilerSupports_CXX11)
    unset(CompilerSupports_CXX0X)
endmacro()




# ************************************************************
# Copy data from target.
macro( ADD_DATA_TARGET SrcFile )
    # Help information.
    message_header( ADD_DATA_TARGET )
    message_help( "Required:" )
    message_help( "[SrcFile]    -> The source file." )
    message_help( "Optional:" )
    message_help( "[GENERATE]   -> The source file is a template file." )
    message_help( "[Name]       -> Destination name. Default: Same as the source." )
    message_help( "[SubPath]    -> Sub path of output directory." )
        
    # Parse options.
    set( options GENERATE )
    set( oneValueArgs Name SubPath )
    cmake_parse_arguments( ADD_DATA_TARGET "${options}" "${oneValueArgs}" "" ${ARGN} )
    
    # Find the existence of the source.
    get_filename_component( FileName ${SrcFile} NAME )
    get_filename_component( FilePath ${SrcFile} PATH )
    find_file( FileFound NAMES ${FileName} HINTS ${FilePath} )
    if( FileFound )
        # Working vars.
        set( FileToCopy "${FileFound}" )
        
        # Parse "Name".
        if( ADD_DATA_TARGET_Name )
            set( FileName ${ADD_DATA_TARGET_Name} )
        endif()
        
        # Default output path.
        if( MSVC )
            set( OutputPath "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>" )
        else()
            set( OutputPath "${PROJECT_PATH_OUTPUT_EXECUTABLE}" )
        endif()
        
        # Parse "SubPath".
        if( ADD_DATA_TARGET_SubPath )
            set( OutputPath "${OutputPath}${ADD_DATA_TARGET_SubPath}" )
        endif()
        
        # Generate template file and add command.
        if( ADD_DATA_TARGET_GENERATE )
            message_verbose( STATUS "Generate from template file." )
            configure_file( ${FileToCopy} "${CMAKE_CURRENT_BINARY_DIR}/${FileName}" )
            set( FileToCopy "${CMAKE_CURRENT_BINARY_DIR}/${FileName}" )
        endif()

        # Add command.
        add_custom_command(
            TARGET ALL_CopyData
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${FileToCopy}
            "${OutputPath}/${FileName}"
        )
        
        if( ADD_DATA_TARGET_GENERATE )
            message_verbose( STATUS "Adding [${FileToCopy}] to ALL_CopyData target." )
        else()
            message_verbose( STATUS "Adding [${SrcFile}] to ALL_CopyData target." )
        endif()
        unset( OutputPath )
        unset( FileToCopy )
    else()
        message_status( "" "Failed to locate: ${SrcFile}" )
    endif()
    
    # Clean up.
    unset( options )
    unset( oneValueArgs )
    unset( ADD_DATA_TARGET_GENERATE )
    unset( ADD_DATA_TARGET_Name )
    unset( ADD_DATA_TARGET_SubPath )
    unset( FileFound CACHE )
    unset( FileName )
    unset( FilePath )
    
    message_footer( ADD_DATA_TARGET )
endmacro()




# ************************************************************
# Add value into variable
macro(ADD_VALUE Value Prefix)
     # Help information.
    message_header(ADD_VALUE)
    message_help("Required:")
    message_help("[Value]       -> Value to validate.")
    message_help("[Prefix]      -> Prefix of the variable to process.")
    message_help("Optional:")
    message_help("[CACHING]     -> Flag to caching.")
    message_help("[Description] -> Description.")
    
    # Parse options.
    set(options CACHING)
    set(oneValueArgs Description)
    cmake_parse_arguments(ADD_VALUE "${options}" "${oneValueArgs}" "" ${ARGN})

    regex_compatible("${Value}" RegexVar)
    string(REGEX MATCH "${RegexVar}" ValueFound "${${Prefix}}")
    if(NOT ValueFound)
        if(ADD_VALUE_CACHING)
            set(${Prefix} "${${Prefix}} ${Value}" CACHE STRING "${ADD_VALUE_Description}" FORCE)
        else()
            set(${Prefix} "${${Prefix}} ${Value}")
        endif()
    endif()
    
    unset(ValueFound)
    unset(options)
    unset(oneValueArgs)
    unset(ADD_VALUE_CACHING)
    unset(ADD_VALUE_Description)
    
    message_footer(ADD_VALUE)
endmacro()




# ************************************************************
# Generate group files, create a common variable for all grouped files.
macro( BUILD_GENERATE_GROUP_FILES Prefix )
    message_header( BUILD_GENERATE_GROUP_FILES )
     
    # Just verify that the Prefix has at least one header or source file.
    if( ${Prefix}_GROUP_HEADER_FILES )
        message_debug( STATUS "Header files: ${${Prefix}_GROUP_HEADER_FILES}" )
        set( LOCAL_GROUP_HEADER_FILES ${LOCAL_GROUP_HEADER_FILES} ${${Prefix}_GROUP_HEADER_FILES} )
        set( Continue TRUE )
    endif()

    if( ${Prefix}_GROUP_SOURCE_FILES )
        message_debug( STATUS "Source files: ${${Prefix}_GROUP_SOURCE_FILES}" )
        set( LOCAL_GROUP_SOURCE_FILES ${LOCAL_GROUP_SOURCE_FILES} ${${Prefix}_GROUP_SOURCE_FILES} )
        set( Continue TRUE )
    endif()

    
    if( Continue )
        # Add if not existed.
        # Check if LOCAL_PATH_GROUP_HEADER do exists, if not then just add the path into the variable.
        # Otherwise add into the variable, only then the Prefix (hence the path to the respective
        # include path) doesn't exists.
        if( NOT LOCAL_PATH_GROUP_HEADER )
            set( Located FALSE )
        else()
            string( REGEX MATCHALL ${${Prefix}_PATH_GROUP_HEADER} Located ${LOCAL_PATH_GROUP_HEADER} )
        endif()
        
        if( NOT Located )
            set( LOCAL_PATH_GROUP_HEADER ${LOCAL_PATH_GROUP_HEADER} ${${Prefix}_PATH_GROUP_HEADER} )
        endif()
        message_debug( STATUS "Paths: ${LOCAL_PATH_GROUP_HEADER}" )
        unset( Located )
    endif()
    unset( Continue )
    
    message_footer( BUILD_GENERATE_GROUP_FILES )
endmacro()




# ************************************************************
# Group files.
macro( BUILD_GROUP_FILES )   
    # Help information.
    message_header( BUILD_GROUP_FILES )
    message_help( "Required options:" )
    message_help( "[Prefix]         -> Prefix for this group section." )
    message_help( "Optional options:" )
    message_help( "[Groups]         -> Organize in groups." )
    message_help( "[Headers]        -> Header files." )
    message_help( "[Sources]        -> Source files." )
    message_help( "[Files]          -> Generic files." )
    
    # Working members.
    set( GroupName "" )
    
    # Parse options.
    set( oneValueArgs Prefix )
    set( multiValueArgs Groups Headers Sources Files )
    cmake_parse_arguments(BUILD_GROUP_FILES "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
    
    # Parse "Prefix".
    if( BUILD_GROUP_FILES_Prefix )
        message_debug( STATUS "Prefix: ${BUILD_GROUP_FILES_Prefix}" )
        
        # Parse "Groups".
        if( BUILD_GROUP_FILES_Groups )
            foreach( g ${BUILD_GROUP_FILES_Groups} )
                set( GroupName "${GroupName}\\${g}" )
            endforeach()
            message_debug( STATUS "Groups: ${BUILD_GROUP_FILES_Groups}" )
        endif()
        
        # Parse "Headers".
        if( BUILD_GROUP_FILES_Headers )
            message_debug( STATUS "Headers: ${BUILD_GROUP_FILES_Headers}" )
            foreach( header ${BUILD_GROUP_FILES_Headers} )
                message_debug( STATUS "Working with current header: ${header}" )
                
                # Add into build variables.
                set( ${BUILD_GROUP_FILES_Prefix}_GROUP_HEADER_FILES ${${BUILD_GROUP_FILES_Prefix}_GROUP_HEADER_FILES} ${header} )
                
                # Find and add includes directory.
                get_filename_component( FilePath ${header} PATH )
                if( FilePath )
                    message_debug( STATUS "Path located: ${FilePath}" )
                    if( NOT ${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER )
                        set( PathExists FALSE )
                    else()
                        string( REGEX MATCHALL ${FilePath} PathExists ${${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER} )
                    endif()
                    
                    if( NOT PathExists )
                        message_debug( STATUS "Add path into variable." )
                        set( ${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER ${${BUILD_GROUP_FILES_Prefix}_PATH_GROUP_HEADER} ${FilePath} )
                    endif()
                    unset( PathExists )
                endif()
                unset( FilePath )
            endforeach()
            
            # Group files.
            source_group( "Header Files${GroupName}" FILES ${BUILD_GROUP_FILES_Headers} )
            message_debug( STATUS "Local headers: ${${BUILD_GROUP_FILES_Prefix}_GROUP_HEADER_FILES}" )
        endif()
        
        
        # Parse "Sources".
        if( BUILD_GROUP_FILES_Sources )
            message_debug( STATUS "Sources: ${BUILD_GROUP_FILES_Sources}" )
            # Add into build variable.
            set( ${BUILD_GROUP_FILES_Prefix}_GROUP_SOURCE_FILES ${${BUILD_GROUP_FILES_Prefix}_GROUP_SOURCE_FILES} ${BUILD_GROUP_FILES_Sources} )
            
            # Group files.
            source_group( "Source Files${GroupName}" FILES ${BUILD_GROUP_FILES_Sources} )
            message_debug( STATUS "Local headers: ${${BUILD_GROUP_FILES_Prefix}_GROUP_SOURCE_FILES}" )
        endif()
        
        
        # Parse "Files"
        if( BUILD_GROUP_FILES_Files )
            message_debug( STATUS "Files: ${BUILD_GROUP_FILES_Files}" )
            # Group files.
            source_group( "Other Files${GroupName}" FILES ${BUILD_GROUP_FILES_Files} )
        endif()
    endif()
    
    # Clean up.
    unset( GroupName )
    unset( oneValueArgs )
    unset( multiValueArgs )
    unset( BUILD_GROUP_FILES_Prefix )
    unset( BUILD_GROUP_FILES_Groups )
    unset( BUILD_GROUP_FILES_Headers )
    unset( BUILD_GROUP_FILES_Sources )
    unset( BUILD_GROUP_FILES_Files )
    
    message_footer( BUILD_GROUP_FILES )
endmacro()




# ************************************************************
# Copy build file to the output directory
macro( COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY )
    # Help information.
    message_header( COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY )
    message_help( "Available options:" )
    message_help( "[Path]       -> Output directory. Default: ${PROJECT_PATH_OUTPUT_EXECUTABLE}." )
    message_help( "[SubPath]    -> Sub directory of the output directory." )
    
    # Parse options.
    set( oneValueArgs Path SubPath )
    cmake_parse_arguments(COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY "" "${oneValueArgs}" "" ${ARGN} )
    
    # Set sub path based on OS platform.
    set( Path "${PROJECT_PATH_OUTPUT_EXECUTABLE}" )
    if( COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path )
        set( Path "${COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path}" )
    endif()
    
    if( NOT COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path AND MSVC )
        set( Path "${Path}/$<CONFIGURATION>${COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_SubPath}" )
    else()
        set( Path "${Path}${COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_SubPath}" )
    endif()
        
    add_custom_command(
        TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "${Path}"
        COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${PROJECT_NAME}>" "${Path}"
    )
    
    # Clean up.
    unset( oneValueArgs )
    unset( COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_Path )
    unset( COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY_SubPath )
    unset( Path )
    
    message_footer( COPY_BUILD_FILE_TO_OUTPUT_DIRECTORY )
endmacro()




# ************************************************************
# Copy a single file to the output directory
macro( COPY_FILE_TO_OUTPUT_DIRECTORY SrcFile DstFileName )
    # Help information.
    message_header( COPY_FILE_TO_OUTPUT_DIRECTORY )
    message_help( "Required:" )
    message_help( "[SrcFile]        -> Source file." )
    message_help( "[DstFileName]    -> Destination file name." )
    message_help( "Available options:" )
    message_help( "[Params]         -> CMake parameters." )
    message_help( "[SubPath]        -> Sub directory of the output directory." )
    
    # Parse options.
    set( oneValueArgs SubPath )
    cmake_parse_arguments(COPY_FILE_TO_OUTPUT_DIRECTORY "" "${oneValueArgs}" "" ${ARGN} )
    
    # With Visual Studio we will copy the file into the debug and release directory.
	if( MSVC )
		copy_single_file( "${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Debug${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFileName}" "${COPY_SINGLE_FILE_Params}" )
		copy_single_file( "${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Release${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFileName}" "${COPY_SINGLE_FILE_Params}" )
	else()
		copy_single_file( "${SrcFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}${COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath}/${DstFileName}" "${COPY_SINGLE_FILE_Params}" )
	endif()
    
    # Clean up.
    unset( oneValueArgs )
    unset( COPY_SINGLE_FILE_Params )
    unset( COPY_FILE_TO_OUTPUT_DIRECTORY_SubPath )
    
    message_footer( COPY_FILE_TO_OUTPUT_DIRECTORY )
endmacro()




# ************************************************************
# Copy project template
macro( COPY_PROJECT_TEMPLATE )
    # Help information.
    message_header( COPY_PROJECT_TEMPLATE )
    message_help( "Available options:" )
    message_help( "[Source]         -> Path to the source file." ) 
    message_help( "[Destination]    -> Path to the destination file." ) 
    
    # Default values.
    set( Source "" )
    set( Destination "" )
    
    if( MSVC )
        set( Source "${PROJECT_PATH_CMAKE_TEMPLATE}/MsvcProject_in.vcxproj.user" )
        set( Destination "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.vcxproj.user" )
    endif()
    
    # Parse options.
    set( oneValueArgs Source Destination )
    cmake_parse_arguments(COPY_PROJECT_TEMPLATE "" "${oneValueArgs}" "" ${ARGN} )
    
    # Parse source.
    if( COPY_PROJECT_TEMPLATE_Source )
        set( Source ${COPY_PROJECT_TEMPLATE_Source} )
        message_debug( STATUS "Source: ${COPY_PROJECT_TEMPLATE_Source}" )
    endif()
    
    # Parse destination.
    if( COPY_PROJECT_TEMPLATE_Destination )
        set( Destination ${COPY_PROJECT_TEMPLATE_Destination} )
        message_debug( STATUS "Destination: ${COPY_PROJECT_TEMPLATE_Destination}" )
    endif()

    # Copy the file.
    # TST 2014-08-29
    # At the moment only MSVC is supported.
    if( MSVC )
        copy_single_file( ${Source} ${Destination} "" )
    endif()
    
    # Clean up.
    unset( Source )
    unset( Destination )
    unset( oneValueArgs )
    unset( COPY_PROJECT_TEMPLATE_Source )
    unset( COPY_PROJECT_TEMPLATE_Destination )
    
    message_footer( COPY_PROJECT_TEMPLATE )
endmacro()




# ************************************************************
# Copy a single file
macro( COPY_SINGLE_FILE SrcFile DstFile )
    # Help information.
    message_header( COPY_SINGLE_FILE )
    message_help( "Required:" )
    message_help( "[SrcFile]    -> Source file." )
    message_help( "[DstFile]    -> Destination file." )
    message_help( "Available options:" )
    message_help( "[Params]     -> CMake parameters." )

    # Parse options.
    set( oneValueArgs SubPath )
    cmake_parse_arguments(COPY_SINGLE_FILE "" "${oneValueArgs}" "" ${ARGN} )
    
    # Find the existence of the source.
    get_filename_component( FileName ${SrcFile} NAME )
    get_filename_component( FilePath ${SrcFile} PATH )
    find_file( FileFound NAMES ${FileName} HINTS ${FilePath} )

    # Copy the file if exists.
    if( FileFound )
        if( COPY_SINGLE_FILE_Params )
            configure_file( ${SrcFile} ${DstFile} "${COPY_SINGLE_FILE_Params}" )
        else()
            configure_file( ${SrcFile} ${DstFile} )
        endif()
        message_verbose( STATUS "Copy [${SrcFile}] to [${DstFile}]" )
    else()
        message_status( "" "Failed to locate: ${SrcFile}" )
    endif()
    
    # Clean up.
    unset( oneValueArgs )
    unset( COPY_SINGLE_FILE_Params )
    unset( FileFound CACHE )
    unset( FileName )
    unset( FilePath )
    
    message_footer( COPY_SINGLE_FILE )
endmacro()




# ************************************************************
# Create a directory
macro( CREATE_DIRECTORY DIST_DIR )
    file( MAKE_DIRECTORY "${DIST_DIR}" )
	message_verbose( STATUS "Create the directory: ${DIST_DIR}" )
endmacro()




# ************************************************************
# Create a directory in the output directory
macro( CREATE_DIRECTORY_IN_OUTPUT_DIRECTORY DIST_DIR )
    if( MSVC )
		create_directory( "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${DIST_DIR}" )
		create_directory( "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${DIST_DIR}" )
	else()
		create_directory( "${PROJECT_PATH_OUTPUT_EXECUTABLE}/${DIST_DIR}" )
	endif()
endmacro()




# ************************************************************
# Create dynamic library extension
macro( CREATE_DYNAMIC_EXTENSION OUTPUT )
	if( WIN32 )
        set( ${OUTPUT} "dll" )
    elseif( APPLE )
        set( ${OUTPUT} "dynlib" )
    else()
        set( ${OUTPUT} "so" )
    endif()
endmacro()




# ************************************************************
# Create MSVC toolset
macro( CREATE_MSVC_TOOLSET OUTPUT )
    set( ${OUTPUT} "" )
    if( WIN32 )
        # This apply for Visual Studio version greater than 2012.
        if( MSVC11 )
            set( ${OUTPUT} "v110" )
        elseif( MSVC12 )
            set( ${OUTPUT} "v120" )
        endif()
    endif()
endmacro()




# ************************************************************
# Generate the PDB file.
macro( GENERATE_DEBUG_SYMBOLS )
    if( MSVC )
        # This property does not apply to STATIC library targets because no linker is invoked to produce them so they have no
        # linker-generated .pdb file containing debug symbols.
        # The compiler-generated program database files specified by the MSVC /Fd flag are not the same as linker-generated
        # program database files and so are not influenced by this property.
        # http://msdn.microsoft.com/en-us/library/9wst99a9.aspx
        set( CMAKE_C_FLAGS        "${CMAKE_C_FLAGS}     /FdGenerated.pdb" )
        set( CMAKE_CXX_FLAGS      "${CMAKE_CXX_FLAGS}   /FdGenerated.pdb" )
        
        # "Hack" to make the output name as the "Project Name" due to a lower case naming.
        # Find the existence of the source.
        set( SrcFile "${CMAKE_CURRENT_BINARY_DIR}/Generated.pdb" )
        get_filename_component( FileName ${SrcFile} NAME )
        get_filename_component( FilePath ${SrcFile} PATH )
        find_file( FileFound NAMES ${FileName} HINTS ${FilePath} )
        if( FileFound )
            #copy_single_file( ${FileFound} "${PROJECT_PATH_OUTPUT_EXECUTABLE}/Debug/${PROJECT_NAME}_d.pdb" )
            
            # Copy and rename.
            add_custom_command(
                TARGET ${PROJECT_NAME}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                "${FileFound}"
                "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>/${PROJECT_NAME}$<$<CONFIG:Debug>:${CMAKE_DEBUG_POSTFIX}>.pdb"
            )
        endif()
        
        unset( FileFound CACHE )
        unset( FileName )
        unset( FilePath )
        unset( SrcFile )
    endif()
endmacro()




# ************************************************************
# Group files
macro( GROUP_FILES TopGroup Files )
    # Help information.
    message_header( GROUP_FILES )
    message_help( "Requires:" )
    message_help( "[TopGroup]   -> Name of the top group." )
    message_help( "[Files]      -> Files to group." )
    message_help( "Available options:" )
    message_help( "[Groups]     -> Groups." )
    
    # Parse options.
    set( multiValueArgs Groups )
    cmake_parse_arguments( GROUP_FILES "" "" "${multiValueArgs}" ${ARGN} )

    # Default values.
    set( GroupName "" )
    if( GROUP_FILES_Groups )
        foreach( group ${GROUP_FILES_Groups} )
            set( GroupName "${GroupName}\\${group}" )
        endforeach()
    endif()
    
    source_group( "${TopGroup}${GroupName}" FILES ${Files} )
    
    # Clean up.
    unset( multiValueArgs )
    unset( GROUP_FILES_Groups )
 
    message_footer( GROUP_FILES )
endmacro()



# ************************************************************
# Initialise main project details
macro( INITIALISE_PROJECT Title )
    # Define policies.
    # Use project version.
    cmake_policy( SET CMP0048 NEW )
    
    # Compiler definitions.
    cmake_policy( SET CMP0043 NEW )

    # Help information.
    message_header( INITIALISE_PROJECT )
    message_help( "Required:" )
    message_help( "[Title]          -> Title of this project." )
    message_help( "Optional:" )
    message_help( "[Description]    -> Description of this project." )
    message_help( "[Major]          -> The major version." )
    message_help( "[Minor]          -> The minor version." )
    message_help( "[Path]           -> The patch version." )
    message_help( "[Twaek]          -> The twaek version." )
    
    message( STATUS "**********************************************************************" )
    message( STATUS "* Project:     ${Title}" )
    
    # Parse options.
    set( oneValueArgs Description Major Minor Patch Tweak )
    cmake_parse_arguments(INITIALISE_PROJECT "" "${oneValueArgs}" "" ${ARGN} )
    
    # Description.
    if( INITIALISE_PROJECT_Description )
        message( STATUS "* Description: ${INITIALISE_PROJECT_Description}" )
    endif()
    
    # Major version.
    set( MajorVersion "0" )
    if( INITIALISE_PROJECT_Major )
        set( MajorVersion ${INITIALISE_PROJECT_Major} )
    endif()
    
    # Minor version.
    set( MinorVersion "0" )
    if( INITIALISE_PROJECT_Minor )
        set( MinorVersion ${INITIALISE_PROJECT_Minor} )
    endif()
    
    # Patch version.
    set( PatchVersion "1" )
    if( INITIALISE_PROJECT_Patch )
        set( PatchVersion ${INITIALISE_PROJECT_Patch} )
    endif()
    
    # Tweak version.
    set( TweakVersion "0" )
    if( INITIALISE_PROJECT_Tweak )
        set( TweakVersion ${INITIALISE_PROJECT_Tweak} )
    endif()
    
    # Set the project title.
    project( ${Title} VERSION "${MajorVersion}.${MinorVersion}.${PatchVersion}.${TweakVersion}" )
    
    # Build timestamp.
    string( TIMESTAMP PROJECT_BUILD_TIME "%d/%m-%Y" )
    
    # Project version.
    message( STATUS "* Version:     ${PROJECT_VERSION}" )
    message( STATUS "* Time:        ${PROJECT_BUILD_TIME}" )
    
    

    # Clean up.
    unset( oneValueArgs )
    unset( INITIALISE_PROJECT_Description )
    unset( INITIALISE_PROJECT_Major )
    unset( INITIALISE_PROJECT_Minor )
    unset( INITIALISE_PROJECT_Patch )
    
    message_footer( INITIALISE_PROJECT )
endmacro()




# ************************************************************
# Initialise sub project details
macro( INITIALISE_LOCAL_PROJECT Title Description )
    # Define policies.
    # Use project version.
    cmake_policy( SET CMP0048 NEW )
    
    project( ${Title} )
    message( STATUS "**********************************************************************" )
    message( STATUS "* Project:     ${Title}" )
    message( STATUS "* Description: ${Description}" )
endmacro()




# ************************************************************
# Initialise project environments
macro( INITIALISE_PROJECT_ENVIRONMENT )
    # Setting default target mode.
    if( MINGW OR UNIX )
        option( PROJECT_BUILD_AS_RELEASE "Build project as release" OFF )
        
        if( PROJECT_BUILD_AS_RELEASE )
            set( PROJECT_BUILD_TARGET_DEBUG FALSE )
            set( PROJECT_BUILD_TARGET_RELEASE TRUE )
            set( SELECTED_TARGET "Release" )
            message_status( STATUS "Build as RELEASE." )
        else()
            set( PROJECT_BUILD_TARGET_DEBUG TRUE )
            set( PROJECT_BUILD_TARGET_RELEASE FALSE )
            set( SELECTED_TARGET "Debug" )
            message_status( STATUS "Build as DEBUG." )
        endif()
        
        # Set target mode.
        set( CMAKE_BUILD_TYPE "${SELECTED_TARGET}" CACHE STRING "Target mode of this project." FORCE )
        
        set( BUILD_TARGET_MODES "[Debug] [Release]" )
        if( CMAKE_BUILD_TYPE STREQUAL "" OR NOT CMAKE_BUILD_TYPE )
            set( CMAKE_BUILD_TYPE "Release" CACHE STRING "Valid build targets are: ${BUILD_TARGET_MODES}" FORCE )
            message_verbose( STATUS "Set to Release mode due to the build target is not set." )
        endif()

		unset( SELECTED_TARGET )
    endif()

    # Set debug suffix.
    set( CMAKE_DEBUG_POSTFIX "_d" )
    
    # Set state for displaying debug message.
    option( PROJECT_CMAKE_ENABLE_DEBUG_MESSAGE      "Enable debug message"      OFF )
    
    # Set state for displaying options message.
    option( PROJECT_CMAKE_ENABLE_HELP_MESSAGE       "Enable help message."      OFF )

    # Set state for displaying verbose message.
    option( PROJECT_CMAKE_ENABLE_VERBOSE_MESSAGE    "Enable verbose message"    OFF )

    # Set multi processor compilation.
    # For UNIX / MinGW the user has to use the flag -jX, where X is number of processor.
    if(MSVC)
        option(PROJECT_ENABLE_MULTI_PROCESSOR_COMPILATION "Enable multi processor compilation." ON)
        if(PROJECT_ENABLE_MULTI_PROCESSOR_COMPILATION)
            message_status(STATUS "Enable multi processor compilation.")
            add_value("/MP" CMAKE_C_FLAGS CACHING)
            add_value("/MP" CMAKE_CXX_FLAGS CACHING)
        else()
            message_status(STATUS "Disable multi processor compilation.")
            remove_value("/MP" CMAKE_C_FLAGS CACHING)
            remove_value("/MP" CMAKE_CXX_FLAGS CACHING)
        endif()
    endif()
    
    # Set option for build for targeting XP.
    if( WIN32 )
        option( PROJECT_BUILD_FOR_WIN_XP "Build for Windows XP SP3." OFF )
        
        if( PROJECT_BUILD_FOR_WIN_XP )
            # This apply only for Visual Studio 2012 and greater.
            if( MSVC_VERSION GREATER  1600 )
                set( TOOLSET "" )
                create_msvc_toolset( TOOLSET )
                set( TOOLSET "${TOOLSET}_xp" )
                set( CMAKE_GENERATOR_TOOLSET ${TOOLSET} CACHE STRING "Platform toolset." FORCE )
            endif()
            
            # Add definitions.
            add_definitions( -D_WIN32_WINNT=0x0501 )
        endif()
    endif()

    # Warnings.
    option(PROJECT_ENABLE_DEFAULT_WARNINGS "Enable default warnings." ON)
    if(PROJECT_ENABLE_DEFAULT_WARNINGS)
        message_status(STATUS "Enable default warnings.")
        if(MSVC)
            #4018 -> signed / unsigned mismatch.
            #4244 -> Conversion from X to Y, possible loss of data.
            set(CommonWarnings "/wd4251 /wd4193 /wd4275 /wd4244")
            set(CommonWarnings "")
        elseif(UNIX)
            # Following OGRE warning settings.
            set(CommonWarnings "-Wall -Wcast-qual -Wextra -Winit-self -Wno-long-long -Wno-missing-field-initializers -Wno-unused-parameter -Wno-unused-but-set-parameter -Wno-overloaded-virtual -Wshadow -Wwrite-strings")
        endif()
        
        set(PROJECT_C_FLAGS ${CommonWarnings} CACHE STRING "C flags in this project.")
        set(PROJECT_CXX_FLAGS ${CommonWarnings} CACHE STRING "CXX flags in this project.")
        unset(CommonWarnings)
    endif()

    # Enable new C++ features.
    if(MINGW OR UNIX)
        option(PROJECT_ENABLE_CXX_FETURES "Enable new C++ features." ON)
        if(PROJECT_ENABLE_CXX_FETURES)
            add_new_cxx_features()
            if(PROJECT_CXX_SUPPORTS)
                message_status(STATUS "Enable new C++ features.")
            endif()
        else()
            remove_new_cxx_features()
            message_status(STATUS "Disable new C++ features.")
        endif()
    endif()
    
    # Install debug symbols.
    #if( MSVC )
        #option( PROJECT_INSTALL_DEBUG_SYMBOLS "Install debug symbols." ON )
    #endif()
    
    #set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} ${PROJECT_C_FLAGS})
    #set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} ${PROJECT_CXX_FLAGS})
    
    # Copy runtime dependencies target and data files.
    add_custom_target( ALL_CopyData )
    add_custom_target( ALL_CopyRuntime )
endmacro()




# ************************************************************
# Initialise default project paths
macro( INITIALISE_PROJECT_PATH )
    # Help information.
    message_header( INITIALISE_PROJECT_PATH )
    message_help( "Available options:" )
    message_help( "[Binary]     -> Output path of binary files. Default: 'bin'." )
    message_help( "[Include]    -> Output path of include files. Default: 'include'." )
    message_help( "[Library]    -> Output path of library files. Default: 'lib'." )
    if( MSVC )
        message_help( "[PDB]        -> Output path of PDB files. Default: 'pdb'." )
    endif()  
    
    # Parse options.
    set( oneValueArgs Binary Include Library )
    if( MSVC )
        set( oneValueArgs ${oneValueArgs} PDB )
    endif()
    cmake_parse_arguments(INITIALISE_PROJECT_PATH "" "${oneValueArgs}" "" ${ARGN} )
    
    # Parse binary path.
    set( PathBinary "bin" )
    if( INITIALISE_PROJECT_PATH_Binary )
        set( PathBinary ${INITIALISE_PROJECT_PATH_Binary} )
    endif()
    
    # Parse include path.
    set( PathInclude "include" )
    if( INITIALISE_PROJECT_PATH_Include )
        set( PathInclude ${INITIALISE_PROJECT_PATH_Include} )
    endif()
    
    # Parse library path.
    set( PathLibrary "lib" )
    if( INITIALISE_PROJECT_PATH_Library )
        set( PathLibrary ${INITIALISE_PROJECT_PATH_Library} )
    endif()
    
    # Parse PDB path.
    set( PathPDB "pdb" )
    if( INITIALISE_PROJECT_PATH_PDB )
        set( PathPDB ${INITIALISE_PROJECT_PATH_PDB} )
    endif()
    
 
    # Root path where the root CMakeList is located.
    set( PROJECT_PATH_ROOT "${CMAKE_CURRENT_SOURCE_DIR}" )
	
    # Output path.
    set( PROJECT_PATH_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/Output" )

	# Install directory.
    set( PROJECT_PATH_INSTALL "${CMAKE_CURRENT_BINARY_DIR}/Install" CACHE PATH "Installation directory." )
    
    
    # Check for changes.
    #if( NOT "${CMAKE_BUILD_TYPE}" STREQUAL "${CMAKE_BUILD_TYPE_INT_CHECK}" )
    #    message_verbose( STATUS "TARGET MODE CHANGED => ${CMAKE_BUILD_TYPE}" )
    #    set( FORCE_CHANGE "FORCE" )
    #else()
    #    set( FORCE_CHANGE "" )
    #endif()
    #set( CMAKE_BUILD_TYPE_INT_CHECK ${CMAKE_BUILD_TYPE} CACHE INTERNAL "x" FORCE )

    set( BuildTarget "" )
    set( BuildTargetDebug "" )
    set( BuildTargetRelease "" )
    if( PROJECT_BUILD_TARGET_DEBUG )
        set( BuildTarget "Debug" )
    elseif( PROJECT_BUILD_TARGET_RELEASE )
        set( BuildTarget "Release" )
    endif()

    if( MSVC )
        set( BuildTargetDebug    "Debug"     )
        set( BuildTargetRelease  "Release"   )
    else()
        set( BuildTargetDebug    "${BuildTarget}" )
        set( BuildTargetRelease  "${BuildTarget}" )
    endif()


    # Executable directory.
    set( PROJECT_PATH_OUTPUT_EXECUTABLE         "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTarget}" CACHE PATH "Executable output directory." )
    set( PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG   "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTargetDebug}" )
    set( PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE "${PROJECT_PATH_OUTPUT}/${PathBinary}/${BuildTargetRelease}" )
    
    # Include directory.
    set( PROJECT_PATH_OUTPUT_INCLUDE "${PROJECT_PATH_OUTPUT}/${PathInclude}" CACHE PATH "Include output directory." )
    
    # Library directory.
    set( PROJECT_PATH_OUTPUT_LIBRARY            "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTarget}" CACHE PATH "Library output directory." )
    set( PROJECT_PATH_OUTPUT_LIBRARY_DEBUG      "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTargetDebug}" )
    set( PROJECT_PATH_OUTPUT_LIBRARY_RELEASE    "${PROJECT_PATH_OUTPUT}/${PathLibrary}/${BuildTargetRelease}" )
    
    if( MSVC )
        # PDB directory.
        set( PROJECT_PATH_OUTPUT_PDB            "${PROJECT_PATH_OUTPUT}/${PathPDB}" CACHE PATH "PDB output directory." )   
        set( PROJECT_PATH_OUTPUT_PDB_DEBUG      "${PROJECT_PATH_OUTPUT}/${PathPDB}/${BuildTargetDebug}" )   
        set( PROJECT_PATH_OUTPUT_PDB_RELEASE    "${PROJECT_PATH_OUTPUT}/${PathPDB}/${BuildTargetRelease}" )   
    endif()

    # Caching.
    set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_EXECUTABLE}   CACHE PATH "Executable directory."  FORCE )
    set( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_LIBRARY}      CACHE PATH "Library directory."     FORCE )
    set( CMAKE_INSTALL_PREFIX           ${PROJECT_PATH_INSTALL}             CACHE PATH "Install directory."     FORCE )
    
    if( MSVC )
        set( CMAKE_PDB_OUTPUT_DIRECTORY ${PROJECT_PATH_OUTPUT_PDB} CACHE PATH "PDB directory." FORCE )
    endif()
	
    # Clean up.
	unset( BuildTarget )
    unset( BuildTargetDebug )
    unset( BuildTargetRelease )
    unset( oneValueArgs )
    unset( INITIALISE_PROJECT_PATH_Binary )
    unset( INITIALISE_PROJECT_PATH_Include )
    unset( INITIALISE_PROJECT_PATH_Library )
    unset( INITIALISE_PROJECT_PATH_PDB )
    
    message_footer( INITIALISE_PROJECT_PATH )
endmacro()




# ************************************************************
# Initialise local path
macro( INITIALISE_LOCAL_VARIABLE )
    # Path to the header directory.
    set( LOCAL_PATH_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/include" )

    # Path to the source directory.
    set( LOCAL_PATH_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/src" )
endmacro()




# ************************************************************
# Initialise project SDK
macro( INITIALISE_PROJECT_SDK )
    if( NOT DEFINED PROJECT_PATH_SDK_HOME )
        # Find for defined environment variables.
        message_verbose( STATUS "SDK doesn't exists. Create the SDK path." )
        package_get_environment_path( PROJECT_SDK SDK_ROOT )
        if( PROJECT_SDK_ENV_SDK_ROOT )
            message_verbose( STATUS "Set SDK home to ${PROJECT_SDK_ENV_SDK_ROOT}." )
            set( PROJECT_PATH_SDK_HOME "${PROJECT_SDK_ENV_SDK_ROOT}" CACHE PATH "Path to the SDK directory." )
        else()
            set( PROJECT_PATH_SDK_HOME "" CACHE PATH "Path to the SDK directory." )
        endif()
        
        # Clean up.
        unset( PROJECT_SDK_ENV_SDK_ROOT )
    endif()
endmacro()




# ************************************************************
# Initialise library in the project SDK
macro( INITIALISE_PROJECT_SDK_LIBRARY )
    if( PROJECT_PATH_SDK_HOME )
        # Locate the IncludeSdk.cmake
        find_file( SdkFile "IncludeSdk.cmake" HINTS "${PROJECT_PATH_SDK_HOME}" )
        if( SdkFile )
            message_debug( STATUS "IncludeSdk.cmake is located." )
            include( ${SdkFile} )
        else()
            message_status( "" "Failed to locate the IncludeSdk.cmake." )
        endif()
        unset( SdkFile CACHE )
    endif()
endmacro()




# ************************************************************
# Copy "as it" into destination
#macro( COPY_RAW SRC DEST )
    #if( WIN32 )
    #    package_get_environment_path( WINDOWS windir )
    #    if( DEFINED WINDOWS_ENV_windir )
    #        find_file( PROGRAM_FOUND NAMES "xcopy.exe" HINTS "${WINDOWS_ENV_windir}" PATH_SUFFIXES "system32" )
    #        execute_process( COMMAND xcopy "${SRC}" "${DST}" /y /s /e /i /d )
    #    endif()
    #endif()
#endmacro()




# ************************************************************
# Install binaries
macro( INSTALL_BINARY Prefix )
    # Help information.
    message_header( INSTALL_BINARY_${Prefix} )
    message_help( "Required:" )
    message_help( "[Prefix]     -> The Prefix to use. Example '${Prefix}' for respective related files." )
    message_help( "Optional:" )
    message_help( "[SubPath]    -> Sub path in ${PROJECT_PATH_INSTALL}." )
    
    # Parse options.
    set( oneValueArgs SubPath )
    cmake_parse_arguments( INSTALL_BINARY_${Prefix} "" "${oneValueArgs}" "" ${ARGN} )
    
    # Install debug files.
    if( ${Prefix}_BINARY_DEBUG )
		foreach( DebugFile ${${Prefix}_BINARY_DEBUG} )
			install( FILES ${DebugFile} DESTINATION "${PROJECT_PATH_INSTALL}${INSTALL_BINARY_${Prefix}_SubPath}" CONFIGURATIONS Debug )
		endforeach()
	endif()
	
    # Install release files.
	if( ${Prefix}_BINARY_RELEASE )
		foreach( ReleaseFile ${${Prefix}_BINARY_RELEASE} )
			install( FILES ${ReleaseFile} DESTINATION "${PROJECT_PATH_INSTALL}${INSTALL_BINARY_${Prefix}_SubPath}" CONFIGURATIONS Release )
		endforeach()
	endif()
    
    # Clean up.
    unset( oneValueArgs )
    unset( INSTALL_BINARY_${Prefix}_SubPath )
    
    message_footer( INSTALL_BINARY_${Prefix} )
endmacro()




# ************************************************************
# Install debug symbols
macro( INSTALL_DEBUG_SYMBOLS )
    if( MSVC )
        # Help information.
        message_header( INSTALL_DEBUG_SYMBOLS )
        message_help( "Optional:" )
        message_help( "[Name]       -> Name of the PDB file. Default is the '${PROJECT_NAME}${CMAKE_DEBUG_POSTFIX}.pdb'." )
        message_help( "[SubPath]    -> Sub path in ${PROJECT_PATH_INSTALL}. Default is 'bin'." )
        
        # Parse options.
        set( oneValueArgs Name SubPath )
        cmake_parse_arguments( INSTALL_DEBUG_SYMBOLS "" "${oneValueArgs}" "" ${ARGN} )
    
        # Default options.
        set( Name "${PROJECT_NAME}" )
        set( Path "${PROJECT_PATH_INSTALL}/bin" )
        
        # Parse "Name".
        if( INSTALL_DEBUG_SYMBOLS_Name )
            set( Name ${INSTALL_DEBUG_SYMBOLS_Name} )
        endif()
              
        # Parse "SubPath".
        if( INSTALL_DEBUG_SYMBOLS_SubPath )
            set( Path "${PROJECT_PATH_INSTALL}${INSTALL_DEBUG_SYMBOLS_SubPath}" )
        endif()

        # Find the existence of the source.
        set( PdbFile "${CMAKE_CURRENT_BINARY_DIR}/Generated.pdb" )
        get_filename_component( FileName ${PdbFile} NAME )
        get_filename_component( FilePath ${PdbFile} PATH )
        find_file( FileFound NAMES ${FileName} HINTS ${FilePath} )

        # Copy the file if exists.
        if( FileFound )
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
            message_verbose( STATUS "Install debug symbol ${FileName}." )
        else()
            message_debug( "" "Failed to locate: ${PdbFile}" )
        endif()

        # Clean up.
        unset( oneValueArgs )
        unset( INSTALL_DEBUG_SYMBOLS_Name )
        unset( INSTALL_DEBUG_SYMBOLS_SubPath )
        unset( FileFound CACHE )
        unset( FileName )
        unset( FilePath )
        unset( PdbFile )
        
        message_footer( INSTALL_DEBUG_SYMBOLS )
    endif()
endmacro()




# ************************************************************
# Install files.
macro( INSTALL_FILES Files )
    # Help information.
    message_header( INSTALL_FILES )
    message_help( "Required:" )
    message_help( "[Files]     -> Files to install." )
    message_help( "Optional:" )
    message_help( "[SubPath]    -> Sub path in the installation directory (${PROJECT_PATH_INSTALL})." )
        
    # Parse options.
    set( oneValueArgs SubPath )
    cmake_parse_arguments( INSTALL_FILES "" "${oneValueArgs}" "" ${ARGN} )
    
    # Working variables.
    set( Path "${PROJECT_PATH_INSTALL}${INSTALL_FILES_SubPath}" )
    
    # Install files.
    foreach( f ${Files} )
        install( FILES "${f}" DESTINATION "${Path}" )
        message_verbose( STATUS "Install [${f}] to ${Path}." )
    endforeach()
    
    # Clean up.
    unset( Path )
    unset( oneValueArgs )
    unset( INSTALL_FILES_SubPath )
    
    message_footer( INSTALL_FILES )
endmacro()




# ************************************************************
# Install headers
macro( INSTALL_HEADERS )
    # Help information.
    message_header( INSTALL_HEADERS )
    #message_help( "Required options:" )
    #message_help( "[Headers]        -> Headers to install." )
    message_help( "Optional options:" )
    message_help( "[SubPath]        -> Sub path of the current install diretory (${PROJECT_PATH_INSTALL})." )
    
    # Parse options.
    set( oneValueArgs SubPath )
    #set( multiValueArgs Files )
    #cmake_parse_arguments(INSTALL_HEADERS "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
    cmake_parse_arguments( INSTALL_HEADERS "" "${oneValueArgs}" "" ${ARGN} )
    
    # Default options.
    if( NOT INSTALL_HEADERS_SubPath )
        set( INSTALL_HEADERS_SubPath "/include" )
    endif()
    
    # Parse "Files".
    #if( INSTALL_HEADERS_Files )
    if( DEFINED LOCAL_HEADERS )
        #foreach( header ${INSTALL_HEADERS_Files} )
        foreach( header ${LOCAL_HEADERS} )
            # Example:
            # Replace c:/library/include/core/Library.h -> c:/builds/library/include/core/Library.h
            string( REPLACE ${LOCAL_PATH_HEADER} "${PROJECT_PATH_INSTALL}${INSTALL_HEADERS_SubPath}" InstallFile ${header} )
            if( NOT ${header} STREQUAL ${InstallFile} )
                # Get path only.
                # Example:
                # c:/builds/library/include/core
                get_filename_component( DestPath ${InstallFile} PATH )
                
                # Install file with sub path if exists.
                # Example:
                # c:/library/include/Prerequisites.h -> c:/builds/library/include/Prerequisites.h
                # c:/library/include/core/Library.h -> c:/builds/library/include/core/Library.h
                install( FILES ${header} DESTINATION ${DestPath} )
                message_debug( STATUS "Install [${header}] to [${DestPath}]" )
            endif()
            
            unset( InstallFile CACHE )
        endforeach()
    else()
        message_debug( STATUS "No files were supplied." )
    endif()
    
    # Clean up.
    unset( oneValueArgs )
    #unset( multiValueArgs )
    unset( INSTALL_HEADERS_Files )
    unset( INSTALL_HEADERS_SubPath )
    
    message_footer_help( INSTALL_HEADERS )
endmacro()




# ************************************************************
# Remove new C++ features
macro(REMOVE_NEW_CXX_FEATURES)
    check_cxx_compiler_flag(-std=c++11 CompilerSupports_CXX11)
    check_cxx_compiler_flag(-std=c++0x CompilerSupports_CXX0X)
    set(Value "")
    if(CompilerSupports_CXX11)
        set(Value " -std=c++11")
    elseif(CompilerSupports_CXX0X)
        set(Value " -std=c+0x")
    endif()
    remove_value("${Value}" PROJECT_CXX_FLAGS CACHING)
    unset(Value)
endmacro()




# ************************************************************
# Remove value from the variable
macro(REMOVE_VALUE Value Prefix)
    # Help information.
    message_header(REMOVE_VALUE)
    message_help("Required:")
    message_help("[Value]       -> Value to validate.")
    message_help("[Prefix]      -> Prefix of the variable to process.")
    message_help("Optional:")
    message_help("[CACHING]     -> Flag to caching.")
    message_help("[Description] -> Description.")
    
    # Parse options.
    set(options CACHING)
    set(oneValueArgs Description)
    cmake_parse_arguments(REMOVE_VALUE "${options}" "${oneValueArgs}" "" ${ARGN})
      
    regex_compatible("${Value}" RegexVar)
    string(REGEX REPLACE "${RegexVar}" "" ValueFound "${${Prefix}}")
    if(ValueFound)
        if(REMOVE_VALUE_CACHING)
            set(${Prefix} "${ValueFound}" CACHE STRING "${REMOVE_VALUE_Description}" FORCE)
        else()
            set(${Prefix} "${ValueFound}")
        endif()
    endif()
    
    unset(ValueFound)
    unset(options)
    unset(oneValueArgs)
    unset(REMOVE_VALUE_CACHING)
    unset(REMOVE_VALUE_Description)
    
    message_footer(REMOVE_VALUE)
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
macro( TOGGLE_ENABLING_STATE State Vars )
    foreach( var ${Vars} )
        if( DEFINED ${var} )
            if( ${State} )
                set( ${var}_STATE 1 )
            else()
                set( ${var}_STATE ${${var}} )
            endif()
        endif()
    endforeach()
endmacro()




# ************************************************************
# Verify Visual Studio environment.
macro( VERIFY_MSVC_ENV Output )
    package_get_environment_path( VERIFY VisualStudioVersion )
    if( VERIFY_ENV_VisualStudioVersion )
        message_status( STATUS "Visual Studio environment exists." )
        message_status( STATUS "Visual Studio version: ${VERIFY_ENV_VisualStudioVersion}" )
        set( ${Output} 1 )
    else()
        message_status( "" "Visual Studio environment couldn't be located." )
        set( ${Output} 0 )
    endif()
endmacro()

