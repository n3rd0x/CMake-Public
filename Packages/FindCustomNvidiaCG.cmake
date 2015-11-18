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
# Start package
message_header( NVIDIA_CG )
package_begin( NVIDIA_CG )
package_create_home_path( NVIDIA_CG NVIDIA_CG_ROOT )


# ************************************************************
# Create search path
set( NVIDIA_CG_PREFIX_PATH ${NVIDIA_CG_HOME} )
package_create_search_path_include( NVIDIA_CG )
package_create_search_path_library( NVIDIA_CG )


# ************************************************************
# Create search name
set( NVIDIA_CG_LIBRARY_NAMES "Cg" )
package_create_debug_names( NVIDIA_CG_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
	package_clear_if_changed( NVIDIA_CG_PREFIX_PATH
		NVIDIA_CG_BINARY_RELEASE
		NVIDIA_CG_BINARY_DEBUG
		NVIDIA_CG_LIBRARY_RELEASE
		NVIDIA_CG_LIBRARY_DEBUG
		NVIDIA_CG_PATH_INCLUDE
	)
else()
	package_clear_if_changed( NVIDIA_CG_PREFIX_PATH
		NVIDIA_CG_LIBRARY_RELEASE
		NVIDIA_CG_LIBRARY_DEBUG
		NVIDIA_CG_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find paths
package_find_path( NVIDIA_CG_PATH_INCLUDE "cg.h" "${NVIDIA_CG_SEARCH_PATH_INCLUDE}" "cg" )
package_find_library( NVIDIA_CG_LIBRARY_DEBUG "${NVIDIA_CG_LIBRARY_NAMES_DEBUG}" "${NVIDIA_CG_SEARCH_PATH_LIBRARY}" "debug;release" )
package_find_library( NVIDIA_CG_LIBRARY_RELEASE "${NVIDIA_CG_LIBRARY_NAMES}" "${NVIDIA_CG_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel" )
package_make_library( NVIDIA_CG_LIBRARY NVIDIA_CG_LIBRARY_DEBUG NVIDIA_CG_LIBRARY_RELEASE )


# ************************************************************
# Find binaries on Windows
if( WIN32 )
	set( NVIDIA_CG_BINARY_NAMES "cg" )
	package_create_debug_binary_names( NVIDIA_CG_BINARY_NAMES )
	package_create_release_binary_names( NVIDIA_CG_BINARY_NAMES )
	package_create_search_path_binary( NVIDIA_CG )
	
	set( NVIDIA_CG_SEARCH_BINARIES 
		${NVIDIA_CG_SEARCH_PATH_BINARY}
		${NVIDIA_CG_SEARCH_PATH_LIBRARY}
	)
	

	package_find_file( NVIDIA_CG_BINARY_DEBUG "${NVIDIA_CG_BINARY_NAMES_DEBUG}" "${NVIDIA_CG_SEARCH_BINARIES}" "debug" )
	package_find_file( NVIDIA_CG_BINARY_RELEASE "${NVIDIA_CG_BINARY_NAMES_RELEASE}" "${NVIDIA_CG_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
endif()


# ************************************************************
# Finalize package
package_validate( NVIDIA_CG )
package_add_parent_dir( NVIDIA_CG )
package_end( NVIDIA_CG )
message_footer( NVIDIA_CG )
