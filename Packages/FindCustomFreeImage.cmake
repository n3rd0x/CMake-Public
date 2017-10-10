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
# Website: http://freeimage.sourceforge.net


# ************************************************************
# Start package
message_header( FREEIMAGE )
package_begin( FREEIMAGE )
package_create_home_path( FREEIMAGE FREEIMAGE_ROOT )


# ************************************************************
# Create search path
set( FREEIMAGE_PREFIX_PATH ${FREEIMAGE_HOME} )
package_create_search_path_include( FREEIMAGE )
package_create_search_path_library( FREEIMAGE )
package_create_search_path_plugin( FREEIMAGE )


# ************************************************************
# Create search name
set( FREEIMAGE_LIBRARY_NAMES "FreeImage" "freeimage" )
package_create_debug_names( FREEIMAGE_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
    package_clear_if_changed( FREEIMAGE_PREFIX_PATH
        FREEIMAGE_LIBRARY_DEBUG
        FREEIMAGE_LIBRARY_RELEASE
        FREEIMAGE_PATH_INCLUDE
        FREEIMAGE_BINARY_RELEASE
        FREEIMAGE_BINARY_DEBUG
    )
else()
    package_clear_if_changed( FREEIMAGE_PREFIX_PATH
        FREEIMAGE_LIBRARY_DEBUG
        FREEIMAGE_LIBRARY_RELEASE
        FREEIMAGE_PATH_INCLUDE
    )
endif()


# ************************************************************
# Find paths
package_find_path( FREEIMAGE_PATH_INCLUDE "FreeImage.h" "${FREEIMAGE_SEARCH_PATH_INCLUDE}" "" )
package_find_library( FREEIMAGE_LIBRARY_DEBUG "${FREEIMAGE_LIBRARY_NAMES_DEBUG}" "${FREEIMAGE_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library( FREEIMAGE_LIBRARY_RELEASE "${FREEIMAGE_LIBRARY_NAMES}" "${FREEIMAGE_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel" )
package_make_library( FREEIMAGE_LIBRARY FREEIMAGE_LIBRARY_DEBUG FREEIMAGE_LIBRARY_RELEASE )


# ************************************************************
# Find binaries on Windows
if( WIN32 )
	set( FREEIMAGE_BINARY_NAMES "FreeImage" )
	package_create_release_binary_names( FREEIMAGE_BINARY_NAMES )
	package_create_debug_binary_names( FREEIMAGE_BINARY_NAMES )
	package_create_search_path_binary( FREEIMAGE )
	
	set( FREEIMAGE_SEARCH_BINARIES 
		${FREEIMAGE_SEARCH_PATH_BINARY}
		${FREEIMAGE_SEARCH_PATH_LIBRARY}
	)

	package_find_file( FREEIMAGE_BINARY_DEBUG "${FREEIMAGE_BINARY_NAMES_DEBUG}" "${FREEIMAGE_SEARCH_BINARIES}" "debug" )
	package_find_file( FREEIMAGE_BINARY_RELEASE "${FREEIMAGE_BINARY_NAMES_RELEASE}" "${FREEIMAGE_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
endif()


# ************************************************************
# Finalize package
package_validate( FREEIMAGE )
package_add_parent_dir( FREEIMAGE )
package_end( FREEIMAGE )
message_footer( FREEIMAGE )
