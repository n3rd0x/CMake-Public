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
# Website: https://code.google.com/p/lz4


# ************************************************************
# Start package
message_header( LZ4 )
package_begin( LZ4 )
package_create_home_path( LZ4 LZ4_ROOT )


# ************************************************************
# Create search path
set( LZ4_PREFIX_PATH ${LZ4_HOME} )
package_create_search_path_include( LZ4 )
package_create_search_path_library( LZ4 )


# ************************************************************
# Create search name
set( LZ4_LIBRARY_NAMES "lz4" )
package_create_debug_names( LZ4_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
	package_clear_if_changed( LZ4_PREFIX_PATH
		LZ4_BINARY_RELEASE
		LZ4_BINARY_DEBUG
		LZ4_LIBRARY_DEBUG
		LZ4_LIBRARY_RELEASE
		LZ4_PATH_INCLUDE
	)
else()
	package_clear_if_changed( LZ4_PREFIX_PATH
		LZ4_LIBRARY_DEBUG
		LZ4_LIBRARY_RELEASE
		LZ4_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find paths
package_find_path( LZ4_PATH_INCLUDE "lz4.h" "${LZ4_SEARCH_PATH_INCLUDE}" "" )
package_find_library( LZ4_LIBRARY_DEBUG "${LZ4_LIBRARY_NAMES_DEBUG}" "${LZ4_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( LZ4_LIBRARY_RELEASE "${LZ4_LIBRARY_NAMES}" "${LZ4_SEARCH_PATH_LIBRARY}" "release"  )
package_make_library( LZ4_LIBRARY LZ4_LIBRARY_DEBUG LZ4_LIBRARY_RELEASE )


# ************************************************************
# Find binaries on Windows
if( WIN32 )
	set( LZ4_BINARY_NAMES "lz4" )
	package_create_release_binary_names( LZ4_BINARY_NAMES )
	package_create_debug_binary_names( LZ4_BINARY_NAMES )
	package_create_search_path_binary( LZ4 )
	
	set( LZ4_SEARCH_BINARIES 
		${LZ4_SEARCH_PATH_BINARY}
		${LZ4_SEARCH_PATH_LIBRARY}
	)

	package_find_file( LZ4_BINARY_DEBUG "${LZ4_BINARY_NAMES_DEBUG}" "${LZ4_SEARCH_BINARIES}" "debug" )
	package_find_file( LZ4_BINARY_RELEASE "${LZ4_BINARY_NAMES_RELEASE}" "${LZ4_SEARCH_BINARIES}" "release" )
endif()


# ************************************************************
# Finalize package
package_validate( LZ4 )
package_add_parent_dir( LZ4 )
package_end( LZ4 )
message_footer( LZ4 )
