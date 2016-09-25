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
# Start package
message_header( NDXLIB )
package_begin( NDXLIB )
package_create_home_path( NDXLIB NDXLIB_ROOT )


# ************************************************************
# Create search path
set( NDXLIB_PREFIX_PATH ${NDXLIB_HOME} "${NDXLIB_HOME}/library" )
package_create_search_path_include( NDXLIB )
package_create_search_path_library( NDXLIB )
package_create_search_path_plugin( NDXLIB )


# ************************************************************
# Create search name
set( NDXLIB_LIBRARY_NAMES "ndxLib" )
package_create_debug_names( NDXLIB_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
    package_clear_if_changed( NDXLIB_PREFIX_PATH
        NDXLIB_LIBRARY_DEBUG
        NDXLIB_LIBRARY_RELEASE
        NDXLIB_PATH_INCLUDE
        NDXLIB_BINARY_RELEASE
        NDXLIB_BINARY_DEBUG
    )
else()
    package_clear_if_changed( NDXLIB_PREFIX_PATH
        NDXLIB_LIBRARY_DEBUG
        NDXLIB_LIBRARY_RELEASE
        NDXLIB_PATH_INCLUDE
    )
endif()


# ************************************************************
# Find paths
package_find_path( NDXLIB_PATH_INCLUDE "ndxBuildSettings.h" "${NDXLIB_SEARCH_PATH_INCLUDE}" "ndxlib" )
package_find_library( NDXLIB_LIBRARY_DEBUG "${NDXLIB_LIBRARY_NAMES_DEBUG}" "${NDXLIB_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library( NDXLIB_LIBRARY_RELEASE "${NDXLIB_LIBRARY_NAMES}" "${NDXLIB_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel" )
package_make_library( NDXLIB_LIBRARY NDXLIB_LIBRARY_DEBUG NDXLIB_LIBRARY_RELEASE )


# ************************************************************
# Find binaries on Windows
if( WIN32 )
	set( NDXLIB_BINARY_NAMES "ndxLib" )
	package_create_release_binary_names( NDXLIB_BINARY_NAMES )
	package_create_debug_binary_names( NDXLIB_BINARY_NAMES )
	package_create_search_path_binary( NDXLIB )
	
	set( NDXLIB_SEARCH_BINARIES 
		${NDXLIB_SEARCH_PATH_BINARY}
		${NDXLIB_SEARCH_PATH_LIBRARY}
	)

	package_find_file( NDXLIB_BINARY_DEBUG "${NDXLIB_BINARY_NAMES_DEBUG}" "${NDXLIB_SEARCH_BINARIES}" "debug" )
	package_find_file( NDXLIB_BINARY_RELEASE "${NDXLIB_BINARY_NAMES_RELEASE}" "${NDXLIB_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
endif()


# ************************************************************
# Finalize package
package_validate( NDXLIB )
package_add_parent_dir( NDXLIB )
package_end( NDXLIB )
message_footer( NDXLIB )
