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
# Website: http://trac.osgeo.org/proj


# ************************************************************
# Start package
cm_message_header( PROJ )
cm_package_begin( PROJ )
cm_package_create_home_path( PROJ PROJ_ROOT )


# ************************************************************
# Options
option( PROJ_USE_STATIC_LIBRARY OFF "Flag to use static library" )


# ************************************************************
# Create Search Path
set( PROJ_PREFIX_PATH ${PROJ_HOME} )
cm_package_create_search_path_include( PROJ )
cm_package_create_search_path_library( PROJ )


# ************************************************************
# Create Search Name
if( PROJ_USE_STATIC_LIBRARY )
    set( PROJ_LIBRARY_NAMES "proj" )
else()
    set( PROJ_LIBRARY_NAMES "proj_i" "proj" )
endif()
cm_package_create_debug_names( PROJ_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
	cm_package_clear_if_changed( PROJ_PREFIX_PATH
		PROJ_BINARY_RELEASE
		PROJ_BINARY_DEBUG
		PROJ_LIBRARY_DEBUG
		PROJ_LIBRARY_RELEASE
		PROJ_PATH_INCLUDE
	)
else()
	cm_package_clear_if_changed( PROJ_USE_STATIC_LIBRARY
		PROJ_LIBRARY_DEBUG
		PROJ_LIBRARY_RELEASE
		PROJ_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find Paths
cm_package_find_path( PROJ_PATH_INCLUDE "proj_api.h" "${PROJ_SEARCH_PATH_INCLUDE}" "" )
cm_package_find_library( PROJ_LIBRARY_DEBUG "${PROJ_LIBRARY_NAMES_DEBUG}" "${PROJ_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( PROJ_LIBRARY_RELEASE "${PROJ_LIBRARY_NAMES}" "${PROJ_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )
cm_package_make_library( PROJ_LIBRARY PROJ_LIBRARY_DEBUG PROJ_LIBRARY_RELEASE )


# ************************************************************
# Find Binaries on Windows
if( WIN32 AND NOT PROJ_USE_STATIC_LIBRARY )
    string( REGEX MATCH "proj_i" DYNAMIC_DEBUG_FOUND ${PROJ_LIBRARY_DEBUG} )
    string( REGEX MATCH "proj_i" DYNAMIC_RELEASE_FOUND ${PROJ_LIBRARY_RELEASE} )

    if( DYNAMIC_DEBUG_FOUND OR DYNAMIC_RELEASE_FOUND )
        cm_message_verbose( STATUS "Searching for dynamic library." )

        set( PROJ_BINARY_NAMES "proj" )
        cm_package_create_release_binary_names( PROJ_BINARY_NAMES )
        cm_package_create_debug_binary_names( PROJ_BINARY_NAMES )
        cm_package_create_search_path_binary( PROJ )

        set( PROJ_SEARCH_BINARIES
            ${PROJ_SEARCH_PATH_BINARY}
            ${PROJ_SEARCH_PATH_LIBRARY}
        )

        cm_package_find_file( PROJ_BINARY_DEBUG "${PROJ_BINARY_NAMES_DEBUG}" "${PROJ_SEARCH_BINARIES}" "debug" )
        cm_package_find_file( PROJ_BINARY_RELEASE "${PROJ_BINARY_NAMES_RELEASE}" "${PROJ_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
    endif()

	unset( DYNAMIC_DEBUG_FOUND )
	unset( DYNAMIC_RELEASE_FOUND )
endif()


# ************************************************************
# Finalize Package
cm_package_validate( PROJ )
cm_package_include_options( PROJ ADD_PARENT )
cm_package_end( PROJ )
cm_message_footer( PROJ )
