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
# Copy binaries from target.
macro(PACKAGE_ADD_RUNTIME_TARGET SrcFile Path)
    # TST 2014-09-19
    # We assume that the source file do exists.
    # This would increase the processing speed.
    
    # Find the existence of the source.
    get_filename_component(FileName ${SrcFile} NAME)
    #get_filename_component( FilePath ${SrcFile} PATH )
    #find_file( FileFound NAMES ${FileName} HINTS ${FilePath} )
    #if( FileFound )
        # Add command.
        add_custom_command(
            TARGET ALL_CopyRuntime
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${SrcFile}
            "${Path}/${FileName}"
        )
        message_verbose(STATUS "Adding [${SrcFile}] to [${Path}] in ALL_CopyRuntime target.")
    #else()
    #    message_status( "" "Failed to locate: ${SrcFile}" )
    #endif()
    
    #unset( FileFound CACHE )
    unset(FileName)
    #unset( FilePath )
endmacro()




# ************************************************************
# Add parent directory
# Ex: /usr/include/json -> /usr/include
macro(PACKAGE_ADD_PARENT_DIR Prefix)
    # Help information.
    message_header(PACKAGE_ADD_PARENT_DIR)
    message_help("Required:")
    message_help("[Prefix]      -> Prefix of the variable to process.")
    message_help("Optional:")
    message_help("ADD_PARENT    -> Flag to add parent directory.")
    #message_help("[Suffixes]    -> Suffixes to process.")
    
    if(${Prefix}_FOUND)
        # Parse options.
        set(options ADD_PARENT)
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
        get_filename_component(Path ${${Prefix}_INCLUDE_DIR} PATH)
        if(PACKAGE_ADD_PARENT_DIR_ADD_PARENT)
            set(${Prefix}_INCLUDE_DIR ${Path} ${${Prefix}_INCLUDE_DIR})
        else()
            set(${Prefix}_INCLUDE_DIR ${Path})
        endif()
    endif()
    
    #unset(ValueFound)
    unset(options)
    #unset(multiValueArgs)
    unset(PACKAGE_ADD_PARENT_DIR_ADD_PARENT)
    #unset(PACKAGE_ADD_PARENT_DIR_Suffixes)
    unset(Path CACHE)

    message_footer(PACKAGE_ADD_PARENT_DIR)
endmacro()




# ************************************************************
# Append names
macro(PACKAGE_APPEND_NAMES Prefix Name)
    message_verbose(STATUS "Append ${Name} to ${Prefix}.")

    set(NewNames "")
    foreach(Var ${${Prefix}})
        set(NewNames ${NewNames} "${Var}${Name}")
    endforeach()
    
    set(${Prefix} "${NewNames}")
    unset(NewNames)
	message_debug(STATUS "Append names: ${${Prefix}}")
endmacro()




# ************************************************************
# Begin the package
macro( PACKAGE_BEGIN Prefix )
    message_status( STATUS "Looking for the ${Prefix} library." )
endmacro()




# ************************************************************
# Create binary names
macro( PACKAGE_CREATE_BINARY_NAMES Prefix )
    message_verbose( STATUS "Creating binary names ${${Prefix}}." )
    create_dynamic_extension( DynamicSuffix )
    
    foreach(name ${${Prefix}})
        set(${Prefix} ${${Prefix}} "${name}.${DynamicSuffix}")
    endforeach()
    
    unset( DynamicSuffix )
	message_debug( STATUS "Binary names: ${${Prefix}}" )
endmacro()




# ************************************************************
# Copy binaries
macro( PACKAGE_COPY_BINARY Prefix )
    # Copy debug runtime files.
    if( ${Prefix}_BINARY_DEBUG )
		foreach( DebugFile ${${Prefix}_BINARY_DEBUG} )
			# Get the file name.
			get_filename_component( FileName ${DebugFile} NAME )
			
            # Copy into output directory.
			copy_single_file( ${DebugFile} "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${FileName}" "COPYONLY" )
			
			# Clean up.
			unset( FileName )
		endforeach()
	endif()
    
    # Copy release runtime files.
	if( ${Prefix}_BINARY_RELEASE )
		foreach( ReleaseFile ${${Prefix}_BINARY_RELEASE} )
			# Get the file name.
			get_filename_component( FileName ${ReleaseFile} NAME )
			
            # Copy into output directory.
			copy_single_file( ${ReleaseFile} "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${FileName}" "COPYONLY" )
			
			# Clean up.
			unset( FileName )
		endforeach()
	endif()
endmacro()




# ************************************************************
# Copy binaries from target.
macro( PACKAGE_COPY_BINARY_FROM_TARGET Prefix )
    # Set debug runtime files.
    if( ${Prefix}_BINARY_DEBUG )
		foreach( DebugFile ${${Prefix}_BINARY_DEBUG} )
			package_add_runtime_target( ${DebugFile} "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}" )
		endforeach()
	endif()
    
    
    # Set release runtime files.
	if( ${Prefix}_BINARY_RELEASE )
		foreach( ReleaseFile ${${Prefix}_BINARY_RELEASE} )
            package_add_runtime_target( ${ReleaseFile} "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}" )
		endforeach()
	endif()
endmacro()




# ************************************************************
# Clear if changed
macro( PACKAGE_CLEAR_IF_CHANGED TestVar )
    if( NOT "${${TestVar}}" STREQUAL "${${TestVar}_INT_CHECK}" )
		message_verbose( STATUS "${TestVar} changed." )

		# Reset variables.
		foreach( var ${ARGN} )
			#set( ${var} "${var}-NOTFOUND" CACHE STRING "" FORCE )
			unset( ${var} CACHE )
		endforeach()
    endif()
    set( ${TestVar}_INT_CHECK ${${TestVar}} CACHE INTERNAL ${TestVar} FORCE )
endmacro()




# ************************************************************
# Create binary names
macro( PACKAGE_CREATE_BINARY_NAMES Input )
    message_verbose( STATUS "Creating binary names of ${${Input}}." )
    
    set( Names ${${Input}} )
    set( ${Input} "" )
    create_dynamic_extension( DynamicSuffix )

    foreach( name ${Names} )
        set( ${Input} ${${Input}} "${name}.${DynamicSuffix}" )
    endforeach()
    
    unset( Names )
    unset( DynamicSuffix )
endmacro()




# ************************************************************
# Add home path
macro( PACKAGE_CREATE_HOME_PATH Prefix EnvPrefix )
    if( NOT DEFINED ${Prefix}_HOME )
        message_verbose( STATUS "${Prefix}_HOME doesn't exists." )
        message_verbose( STATUS "Looking for ${EnvPrefix} environment variable." )
        package_get_environment_path( ${Prefix} ${EnvPrefix} )
        
        if( ${Prefix}_ENV_${EnvPrefix} )
            message_verbose( STATUS "Set ${EnvPrefix} as ${Prefix}_HOME (${${Prefix}_ENV_${EnvPrefix}})." )
            set( ${Prefix}_HOME "${${Prefix}_ENV_${EnvPrefix}}" CACHE PATH "Path to ${Prefix} directory." )
        else()
            message_verbose( STATUS "Creating an empty ${Prefix}_HOME." )
            set( ${Prefix}_HOME "" CACHE PATH "Path to ${Prefix} directory." )
        endif()
    endif()
endmacro()




# ************************************************************
# Create prefix as sub directory
macro(PACKAGE_CREATE_PREFIX_SUBPATH Output Prefix)
	# Example: c:/ogre/include
    # Assume that Prefix is Ogre.
    # This will generate the following lines:
    # c:/ogre/include/Ogre
    # c:/ogre/include/OGRE
    # c:/ogre/include/ogre
    string(TOUPPER ${Prefix} Uppercase)
	string(TOLOWER ${Prefix} Lowercase)
	set(WorkVar ${${Output}})
	foreach(var ${${Output}})
		set(WorkVar
            ${WorkVar}
			"${var}/${Prefix}"
			"${var}/${Uppercase}"
			"${var}/${Lowercase}"
		)
	endforeach()
    
    # Set to output.
	set(${Output} ${WorkVar})
	
    # Clean up.
    unset(Uppercase)
	unset(Lowercase)
	unset(WorkVar)
    unset(var)
endmacro()


# ************************************************************
# NB! Using the macro for creating search paths:
# The user must create manually create ${PREFIX}_PREFIX_PATH
# Ex: set( OGRE_PREFIX_PATH "/opt/sdk/ogre" )


# ************************************************************
# Create search binary path
macro( PACKAGE_CREATE_SEARCH_PATH_BINARY Prefix )
    message_verbose( STATUS "Creating ${Prefix} binary search path." )
    
    # Create search for "default" directories.
    foreach( dir ${${Prefix}_PREFIX_PATH} )
        set( ${Prefix}_SEARCH_PATH_BINARY
			"${${Prefix}_SEARCH_PATH_BINARY}"
            "${dir}/bin"
            "${dir}/Bin"
            "${dir}/binary"
            "${dir}/Binary"
            "${dir}/dll"
            "${dir}/Dll"
            "${dir}/redist"
            "${dir}/Redist"
        )
    endforeach()
    
    # Also create "default platform" specific directories.
    package_create_search_platform( ${Prefix}_SEARCH_PATH_BINARY            )
	package_create_prefix_subpath(  ${Prefix}_SEARCH_PATH_BINARY ${Prefix}  )
    
    message_debug( STATUS "Binary search path: ${${Prefix}_SEARCH_PATH_BINARY}" )
endmacro()




# ************************************************************
# Create search include path
macro(PACKAGE_CREATE_SEARCH_PATH_INCLUDE Prefix)
    message_verbose(STATUS "Creating ${Prefix} include search path.")
    
    # Create search for "default" directories.
    foreach(dir ${${Prefix}_PREFIX_PATH})
        set(${Prefix}_SEARCH_PATH_INCLUDE
			"${${Prefix}_SEARCH_PATH_INCLUDE}"
			"${dir}/inc"
            "${dir}/Inc"
            "${dir}/include"
            "${dir}/Include"
        )
    endforeach()
    
    # Add for UNIX system.
    if(UNIX)
        set(${Prefix}_SEARCH_PATH_INCLUDE
            "${${Prefix}_SEARCH_PATH_INCLUDE}"
			"/usr/include"
			"/usr/local/include"
	    )
    endif()
    
    # Clear temp vars.
    unset(dir)
    
    # Create specific directories.
	package_create_prefix_subpath(${Prefix}_SEARCH_PATH_INCLUDE ${Prefix})
    
    message_debug(STATUS "Include search path: ${${Prefix}_SEARCH_PATH_INCLUDE}")
endmacro()




# ************************************************************
# Create search library path
macro(PACKAGE_CREATE_SEARCH_PATH_LIBRARY Prefix)
    message_verbose(STATUS "Creating ${Prefix} library search path.")
    
    # Create search for "default" directories.
    foreach(dir ${${Prefix}_PREFIX_PATH})
        list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
            "${dir}"
            "${dir}/lib"
            "${dir}/Lib"
            "${dir}/library"
            "${dir}/Library"
        )
    endforeach()
    
    # Add for UNIX system.
    if(UNIX)
        list(APPEND ${Prefix}_SEARCH_PATH_LIBRARY
			"/usr/lib"
			"/usr/lib/x86_64-linux-gnu"
			"/usr/local/lib"
            "/usr/lib/i386-linux-gnu"
            "/usr/lib/arm-linux-gnueabihf"
	    )
    endif()
    
    # Clear temp vars.
    unset(dir)
    
    # Also create "default platform" specific directories.
    package_create_search_platform(${Prefix}_SEARCH_PATH_LIBRARY)
	package_create_prefix_subpath(${Prefix}_SEARCH_PATH_LIBRARY ${Prefix})
    
    message_debug(STATUS "Library search path: ${${Prefix}_SEARCH_PATH_LIBRARY}")
endmacro()





# ************************************************************
# Create search media path
macro( PACKAGE_CREATE_SEARCH_PATH_MEDIA Prefix )
    message_verbose( STATUS "Creating ${Prefix} media search path." )
    
    foreach( dir ${${Prefix}_PREFIX_PATH} )
        set( ${Prefix}_SEARCH_PATH_MEDIA
			"${${Prefix}_SEARCH_PATH_MEDIA}"
            "${dir}/media"
            "${dir}/Media"
        )
    endforeach()
    
	package_create_prefix_subpath( ${Prefix}_SEARCH_PATH_MEDIA ${Prefix} )
    
    message_debug( STATUS "Media search path: ${${Prefix}_SEARCH_PATH_MEDIA}" )
endmacro()




# ************************************************************
# Create search plug-in path
macro( PACKAGE_CREATE_SEARCH_PATH_PLUGIN Prefix )
    message_verbose( STATUS "Creating ${Prefix} plugin search path." )
    
    # Create search for "default" directories.
    foreach( dir ${${Prefix}_PREFIX_PATH} )
        set( ${Prefix}_SEARCH_PATH_PLUGIN
			"${${Prefix}_SEARCH_PATH_PLUGIN}"
            "${dir}/bin"
            "${dir}/Bin"
            "${dir}/binary"
            "${dir}/Binary"
            "${dir}/dll"
            "${dir}/Dll"
            "${dir}/plugin"
			"${dir}/Plugin"
            "${dir}/plugins"
            "${dir}/Plugins"
        )
    endforeach()
    
    # Also create "default platform" specific directories.
    package_create_search_platform( ${Prefix}_SEARCH_PATH_PLUGIN            )
	package_create_prefix_subpath(  ${Prefix}_SEARCH_PATH_PLUGIN ${Prefix}  )
    
    message_debug( STATUS "Plugin search path: ${${Prefix}_SEARCH_PATH_PLUGIN}" )
endmacro()




# ************************************************************
# Create search platform path
macro( PACKAGE_CREATE_SEARCH_PLATFORM Var )
    # Check whether we are going to compile for x64-bit systems.
	string( REGEX MATCH "Win64" x64Found ${CMAKE_GENERATOR} )
    if( x64Found )
        set( OsSystem
            "64"
            "x64"
            "w64"
            "win64"
            "Win64"
            "amd64"
            "Amd64"
        )
    else()
        set( OsSystem
            "32"
            "x32"
            "w32"
            "win32"
            "Win32"
        )
    endif()
    
    # Take backup.
    set( WorkingVar ${${Var}} )
    set( ${Var} "" )
    foreach( dir ${WorkingVar} )
        foreach( os ${OsSystem} )
            set( ${Var}
                ${${Var}}
                "${dir}"
                "${dir}/${os}"
            )
        endforeach()
    endforeach()
    
    # Clean up.
    unset( OsSystem )
    unset( WorkingVar )
    unset( x64Found )
endmacro()




# ************************************************************
# Create debug names
macro( PACKAGE_CREATE_DEBUG_NAMES Prefix )
    message_verbose( STATUS "Creating debug names of ${${Prefix}}." )
    
    foreach( name ${${Prefix}} )
        set( ${Prefix}_DEBUG
             ${${Prefix}_DEBUG}
             "${name}d"
             "${name}D"
             "${name}-d"
             "${name}_d"
             "${name}_D"
             "${name}_debug"
             "${name}"
        )
    endforeach()
    
	message_debug( STATUS "Debug names: ${${Prefix}_DEBUG}" )
endmacro()




# ************************************************************
# Create debug binary names
macro( PACKAGE_CREATE_DEBUG_BINARY_NAMES Prefix )
    message_verbose( STATUS "Creating debug binary names of ${${Prefix}}." )
    create_dynamic_extension( DynamicSuffix )
    
    foreach( name ${${Prefix}} )
        set( ${Prefix}_DEBUG
             ${${Prefix}_DEBUG}
             "${name}d.${DynamicSuffix}"
             "${name}D.${DynamicSuffix}"
             "${name}-d.${DynamicSuffix}"
             "${name}_d.${DynamicSuffix}"
             "${name}_D.${DynamicSuffix}"
             "${name}_debug.${DynamicSuffix}"
             "${name}.${DynamicSuffix}"
        )
    endforeach()
    
    unset( DynamicSuffix )
	message_debug( STATUS "Debug binary names: ${${Prefix}_DEBUG}" )
endmacro()




# ************************************************************
# Create release binary names
macro( PACKAGE_CREATE_RELEASE_BINARY_NAMES Prefix )
    message_verbose( STATUS "Creating release binary names ${${Prefix}}." )
    create_dynamic_extension( DynamicSuffix )
    
    foreach( name ${${Prefix}} )
        set( ${Prefix}_RELEASE
             ${${Prefix}_RELEASE}
             "${name}.${DynamicSuffix}"
        )
    endforeach()
    
    unset( DynamicSuffix )
	message_debug( STATUS "Release binary names: ${${Prefix}_RELEASE}" )
endmacro()




# ************************************************************
# Create statical names
macro( PACKAGE_CREATE_STATICAL_NAMES Var )
    message_verbose( STATUS "Creating statical names ${${Var}}." )
    
    foreach( name ${${Var}} )
        set( ${Var}
			"${name}s"
			"${name}S"
			"${name}-s"
			"${name}_static"
			"${name}_Static"
			"${name}_s"
			"${name}_S"
			"${name}LibStatic"
			"${name}libstatic"
            ${${Var}}
        )
    endforeach()
    
	message_debug( STATUS "Statical names: ${${Var}}" )
endmacro()




# ************************************************************
# Create versional names
macro( PACKAGE_CREATE_VERSIONAL_NAMES Var Versions )
    message_header_debug( "PACKAGE_CREATE_VERSIONAL_NAMES" )
    message_verbose( STATUS "Creating versional names of ${${Var}}." )
    
    # Each version will be added to the name.
    foreach( name ${${Var}} )
        foreach( v ${Versions} )
            # Split into major, minor, patch and tweak numbers.
            message_debug( "" "----------------------------------------" )
            message_debug( "" "Version: ${v} (source)")
            
            string( REGEX MATCHALL "[0-9]+" components ${v} )
            message_debug( "" "Components: ${components}" )
            
            list( LENGTH components length )
            message_debug( "" "Length: ${length}" )
            
            # Whole version.
            set( Version "" )
                
            # Major version.
            if( ${length} GREATER 0 )
                list( GET components 0 MajorVersion )
                set( Version "${MajorVersion}" )
                message_debug( "" "Major: ${MajorVersion}" )
            endif()
            
            # Minor version.
            if( ${length} GREATER 1 )
                list( GET components 1 MinorVersion )
                set( Version "${Version}${MinorVersion}" )
                message_debug( "" "Minor: ${MinorVersion}" )
            endif()
            
            # Path version.
            if( ${length} GREATER 2 )
                list( GET components 2 PatchVersion )
                set( Version "${Version}${PatchVersion}" )
                message_debug( "" "Patch: ${PatchVersion}" )
            endif()

            # Tweak version.
            if( ${length} GREATER 3 )
                list( GET components 3 TweakVersion )
                set( Version "${Version}${TweakVersion}" )
                message_debug( "" "Tweak: ${TweakVersion}" )
            endif()
            
            message_debug( "" "Version: ${Version}" )
            
            set( nName "${name}${v}" )
            if( ${length} GREATER 1 )
                set( nName "${nName}" "${name}${Version}" )
            endif()
            
            set( ${Var}
                ${nName}
                ${${Var}}
            )        
            message_debug( "" "Adding: ${name}${v} and ${name}${Version}" )          
            
            message_debug( "" "----------------------------------------" )
            
            unset( components )
            unset( length )
            unset( MajorVersion )
            unset( MinorVersion )
            unset( PatchVersion )
            unset( TweakVersion )
            unset( Version )
            unset( nName )
        endforeach()
        
    endforeach()
    message_debug( "" "Final: ${${Var}}" )
    message_footer_debug( "PACKAGE_CREATE_VERSIONAL_NAMES" )
endmacro()




# ************************************************************
# Display library
macro(PACKAGE_DISPLAY_LIBRARY Libraries)
    foreach(lib ${Libraries})
        if(NOT ${lib} STREQUAL "optimized" AND NOT ${lib} STREQUAL "debug")
            message_verbose(STATUS "  * ${lib}")
        else()
            message_verbose(STATUS "[${lib}]")
        endif()
    endforeach()
    unset(lib)
endmacro()




# ************************************************************
# End the package
macro(PACKAGE_END Prefix)
	if(${Prefix}_FOUND)
        message_verbose(STATUS "${Prefix} libraries:")
        package_display_library("${${Prefix}_LIBRARIES}")
        message_verbose(STATUS "${Prefix} includes:  ${${Prefix}_INCLUDE_DIR}")
        message_status(STATUS "The ${Prefix} library is located." )
    else()
        message_status("" "Failed to locate the ${Prefix} library.")
    endif()
endmacro()




# ************************************************************
# Find file
macro(PACKAGE_FIND_FILE Prefix SearchName SearchPath Suffixes)
    message_sub_header("Package Find File (${Prefix})")
    message_verbose(STATUS "Searching files: ${SearchName}")
    message_debug(STATUS "Names:           ${SearchName}")
    message_debug(STATUS "Search path:     ${SearchPath}")
    message_debug(STATUS "Suffixes:        ${Suffixes}")
    
    find_file(${Prefix} NAMES ${SearchName} HINTS ${SearchPath} PATH_SUFFIXES ${Suffixes} NO_DEFAULT_PATH)
    if(${Prefix})
        message_debug(STATUS "Found file:      ${${Prefix}}")
    else()
        message_verbose("" "Failed to locate one of these files: ${SearchName}")
    endif()
    
    message_sub_footer("Package Find File (${Prefix})")
endmacro()






# ************************************************************
# Find library
macro( PACKAGE_FIND_LIBRARY Prefix SearchName SearchPath Suffixes )
	message_sub_header( "Package Find Library (${Prefix})" )
	message_verbose( STATUS "Searching files: ${SearchName}"    )
    message_debug( STATUS "Names:           ${SearchName}"      )
    message_debug( STATUS "Search path:     ${SearchPath}"      )
    message_debug( STATUS "Suffixes:        ${Suffixes}"        )
    
    find_library( ${Prefix} NAMES ${SearchName} HINTS ${SearchPath} PATH_SUFFIXES ${Suffixes} NO_DEFAULT_PATH )
    if( ${Prefix} )
        message_debug( STATUS "Found library:    ${${Prefix}}" )
    else()
        message_verbose( "" "Failed to locate one of these files: ${SearchName}" )
    endif()
    
    message_sub_footer( "Package Find Library (${Prefix})" )
endmacro()



# ************************************************************
# Find directory
macro(PACKAGE_FIND_PATH Prefix Files SearchPath Suffixes)
	message_sub_header("Package Find Path (${Prefix})")
    message_debug(STATUS "Files:           ${Files}")
    message_debug(STATUS "Search path:     ${SearchPath}")
    message_debug(STATUS "Suffixes:        ${Suffixes}")
    
    find_path(${Prefix} NAMES ${Files} HINTS ${SearchPath} PATH_SUFFIXES ${Suffixes} NO_DEFAULT_PATH)
    if(${Prefix})
        message_debug(STATUS "Found path:      ${${Prefix}}")
    else()
        message_verbose("" "Failed to locate one of these paths: ${SearchPath}")
    endif()
    
    message_sub_footer("Package Find Path (${Prefix})")
endmacro()




# ************************************************************
# Initialise home path
macro( PACKAGE_INITIALISE_HOME_PATH Prefix EnvPrefix )
    package_get_environment_path( ${Prefix} ${EnvPrefix} )
     if( ${Prefix}_ENV_${EnvPrefix} )
        if( ${Prefix}_HOME )
            message_verbose( STATUS "Set ${EnvPrefix} as ${Prefix}_HOME (${${Prefix}_ENV_${EnvPrefix}})." )
            set( ${Prefix}_HOME "${${Prefix}_ENV_${EnvPrefix}}" CACHE PATH "Path to ${Prefix} directory." )
        endif()
    else()
endmacro()




# ************************************************************
# Install binaries.
macro( PACKAGE_INSTALL_BINARY_FROM_TARGET Prefix )
    # Help information.
    message_header( PACKAGE_INSTALL_BINARY_FROM_TARGET )
    message_help( "Required:" )
    message_help( "[Prefix]     -> Prefix of the variable to process." )
    message_help( "Optional:" )
    message_help( "[SubPath]    -> Sub path in the installation directory (${PROJECT_PATH_INSTALL})." )
        
    # Parse options.
    set( oneValueArgs SubPath )
    cmake_parse_arguments( PACKAGE_INSTALL_BINARY_FROM_TARGET "" "${oneValueArgs}" "" ${ARGN} )
    
    # Working variables.
    set( Path "${PROJECT_PATH_INSTALL}${PACKAGE_INSTALL_BINARY_FROM_TARGET_SubPath}" )
    
    # Set debug runtime files.
    if( ${Prefix}_BINARY_DEBUG )
		foreach( DebugFile ${${Prefix}_BINARY_DEBUG} )
            install( FILES "${DebugFile}" DESTINATION "${Path}" CONFIGURATIONS "debug" )
            message_verbose( STATUS "Install [${DebugFile}] to ${Path}." )
		endforeach()
	endif()
    
    
    # Set release runtime files.
	if( ${Prefix}_BINARY_RELEASE )
		foreach( ReleaseFile ${${Prefix}_BINARY_RELEASE} )
            install( FILES "${ReleaseFile}" DESTINATION "${Path}" CONFIGURATIONS "release" )
            message_verbose( STATUS "Install [${ReleaseFile}] to ${Path}." )
		endforeach()
	endif()
    
    # Clean up.
    unset( Path )
    unset( oneValueArgs )
    unset( PACKAGE_INSTALL_BINARY_FROM_TARGET_SubPath )
    
    message_footer( PACKAGE_INSTALL_BINARY_FROM_TARGET )
endmacro()




# ************************************************************
# Make set of release and debug
macro( PACKAGE_MAKE_LIBRARY Prefix Debug Release )
    message_sub_header( "Package Make Library (${Prefix})" )
    
    if( ${Debug} AND ${Release} )
        message_debug( STATUS "Release and Debug found." )
        set( ${Prefix} optimized ${${Release}} debug ${${Debug}} )
    elseif( ${Release} )
        message_debug( STATUS "Release found." )
        set( ${Prefix} ${${Release}} )
    elseif( ${Debug} )
        message_debug( STATUS "Debug found." )
        set( ${Prefix} ${${Debug}} )
    else()
        message_debug( "" "Failed to make the library (${Prefix})." )
    endif()
    
    message_debug( STATUS "Library: ${${Prefix}}" )
    message_sub_footer( "Package Make Library (${Prefix})" )
endmacro()




# ************************************************************
# Get environment variable
macro( PACKAGE_GET_ENVIRONMENT_PATH Prefix Var )
    set( TmpEnv $ENV{${Var}} )

    # Make sure backslashes are converted to forward slashes.
    if( TmpEnv )
        message_debug( STATUS "${Var} is located." )
        string( REGEX REPLACE "\\\\" "/" TmpEnv ${TmpEnv} )
        
        # We must also remove the double quote if exists.
        # As we don't want the quotes to in the cache.
        string( REGEX REPLACE "\"" "" TmpEnv ${TmpEnv} )
		
        set( ${Prefix}_ENV_${Var} ${TmpEnv} )
        message_debug( STATUS "Set ${Prefix}_ENV_${Var} to ${TmpEnv}." )
    endif ()
    
    unset( TmpEnv )
endmacro()




# ********************
# Validate the package
macro( PACKAGE_VALIDATE Prefix )
    if( NOT ${Prefix}_FOUND )
		if( ${Prefix}_PATH_INCLUDE AND ${Prefix}_LIBRARY )
			set( ${Prefix}_FOUND TRUE )
			set( ${Prefix}_LIBRARIES ${${Prefix}_LIBRARY} )
			set( ${Prefix}_INCLUDE_DIR ${${Prefix}_PATH_INCLUDE} )
		endif()
    endif()
endmacro()

