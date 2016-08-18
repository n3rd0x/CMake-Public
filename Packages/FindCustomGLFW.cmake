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
# Webiste: http://www.glfw.org


# ************************************************************
# Start package
message_header( GLFW )
package_begin( GLFW )
package_create_home_path( GLFW GLFW_ROOT )


# ************************************************************
# Option for which version of compiler on Windows only
# if( WIN32 )
    # option( GLFW_COMPILER_MINGW "MinGW Compiler" OFF )
    # option( GLFW_COMPILER_VC_90 "Visual Studio 2008" OFF )
    # option( GLFW_COMPILER_VC_100 "Visual Studio 2010" OFF )
    # option( GLFW_COMPILER_VC_110 "Visual Studio 2012" OFF )
    
    # # Newest compiler has higher priority
    # if( GLFW_COMPILER_VC_110 )
        # message_debug( STATUS "Compiler Visual Studio 2012 selected." )
        # set( GLEW_PATH_SUFFIX "lib-msvc110" )
    # elseif( GLFW_COMPILER_VC_100 )
        # message_debug( STATUS "Compiler Visual Studio 2010 selected." )
        # set( GLEW_PATH_SUFFIX "lib-msvc100" )
    # elseif( GLFW_COMPILER_VC_90 )
        # message_debug( STATUS "Compiler Visual Studio 2008 selected." )
        # set( GLEW_PATH_SUFFIX "lib-msvc90" )
    # elseif(GLFW_COMPILER_MINGW)
        # message_debug( STATUS "Compiler MinGW selected." )
        # set( GLEW_PATH_SUFFIX "lib-mingw" )
    # else()
        # message_debug( STATUS "Automatic compiler." )
        # set( GLEW_PATH_SUFFIX "" )
    # endif()
# endif()


# ************************************************************
# Options
set( GLFW_VERSION "3" CACHE STRING "Select ther version of GLFW to search." )
option( GLFW_ENABLE_STATICAL "Flag for using static library." OFF )


# ************************************************************
# Create search path
set( GLFW_PREFIX_PATH ${GLFW_HOME} )
package_create_search_path_include( GLFW )
package_create_search_path_library( GLFW )
#set( GLFW_SEARCH_PATH_LIBRARY "{$GLFW_SEARCH_PATH_LIBRARY}" "${GLFW_HOME}/${GLEW_PATH_SUFFIX}" )


# ************************************************************
# Create search name
if( GLFW_ENABLE_STATICAL )
    set( GLFW_LIBRARY_NAMES "glfw${GLFW_VERSION}" )
else()
    set( GLFW_LIBRARY_NAMES "glfw${GLFW_VERSION}dll" )
endif()
package_create_debug_names( GLFW_LIBRARY_NAMES )


# ************************************************************
# Clear
set( GLFW_CLEAR_IF_CHANGED 
    GLFW_PREFIX_PATH
    GLFW_ENABLE_STATICAL
    GLFW_VERSION
    #GLFW_COMPILER_VC_110
    #GLFW_COMPILER_VC_100
    #GLFW_COMPILER_VC_90
    #GLFW_COMPILER_MINGW
)
foreach( VAR ${GLFW_CLEAR_IF_CHANGED} )
    if( WIN32 )
        package_clear_if_changed( ${VAR}
            GLFW_LIBRARY_DEBUG
            GLFW_LIBRARY_RELEASE
            GLFW_PATH_INCLUDE
            GLFW_BINARY_RELEASE
            GLFW_BINARY_DEBUG
        )
    else()
        package_clear_if_changed( ${VAR}
            GLFW_LIBRARY_DEBUG
            GLFW_LIBRARY_RELEASE
            GLFW_PATH_INCLUDE
        )
    endif()
endforeach()



# ************************************************************
# Find paths
package_find_path( GLFW_PATH_INCLUDE "glfw${GLFW_VERSION}.h" "${GLFW_SEARCH_PATH_INCLUDE}" "GL" )
package_find_library( GLFW_LIBRARY_DEBUG "${GLFW_LIBRARY_NAMES_DEBUG}" "${GLFW_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( GLFW_LIBRARY_RELEASE "${GLFW_LIBRARY_NAMES}" "${GLFW_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )
package_make_library( GLFW_LIBRARY GLFW_LIBRARY_DEBUG GLFW_LIBRARY_RELEASE )


# ************************************************************
# Find binaries on Windows
if( WIN32 )
    set( GLFW_BINARY_NAMES "glfw${GLFW_VERSION}" )
	package_create_release_binary_names( GLFW_BINARY_NAMES )
	package_create_debug_binary_names( GLFW_BINARY_NAMES )
	package_create_search_path_binary( GLFW )
	
	set( GLFW_SEARCH_BINARIES 
		${GLFW_SEARCH_PATH_BINARY}
		${GLFW_SEARCH_PATH_LIBRARY}
	)

	package_find_file( GLFW_BINARY_DEBUG "${GLFW_BINARY_NAMES_DEBUG}" "${GLFW_SEARCH_BINARIES}" "debug" )
	package_find_file( GLFW_BINARY_RELEASE "${GLFW_BINARY_NAMES_RELEASE}" "${GLFW_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
endif()


# ************************************************************
# Finalize package
package_validate( GLFW )
package_add_parent_dir( GLFW )
package_end( GLFW )
message_footer( GLFW )


