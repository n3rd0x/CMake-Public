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
# Website: http://www.fmod.org


# ************************************************************
# Start package
cm_message_header( FMOD )
package_begin( FMOD )
package_create_home_path( FMOD FMOD_ROOT )


# ************************************************************
# Create search path
set( FMOD_PREFIX_PATH ${FMOD_HOME} )
package_create_search_path_include( FMOD )
package_create_search_path_library( FMOD )
package_create_search_path_plugin( FMOD )


# ************************************************************
# Create search name
set( FMOD_LIBRARY_NAMES "fmodex64" "fmodex_vc" )
package_create_debug_names( FMOD_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
	package_clear_if_changed( FMOD_PREFIX_PATH
		FMOD_BINARY_RELEASE
		FMOD_BINARY_DEBUG
		FMOD_LIBRARY_RELEASE
		FMOD_LIBRARY_DEBUG
		FMOD_PATH_INCLUDE
	)
else()
	package_clear_if_changed( FMOD_PREFIX_PATH
		FMOD_LIBRARY_RELEASE
		FMOD_LIBRARY_DEBUG
		FMOD_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find path and header file
package_find_path( FMOD_PATH_INCLUDE "fmod.hpp" "${FMOD_SEARCH_PATH_INCLUDE}" "" )
package_find_library( FMOD_LIBRARY_DEBUG "${FMOD_LIBRARY_NAMES_DEBUG}" "${FMOD_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( FMOD_LIBRARY_RELEASE "${FMOD_LIBRARY_NAMES}" "${FMOD_SEARCH_PATH_LIBRARY}" "release relwithdebinfo minsizerel"  )
package_make_library( FMOD_LIBRARY FMOD_LIBRARY_DEBUG FMOD_LIBRARY_RELEASE )


# ************************************************************
# Find binaries
if( WIN32 )
    set( FMOD_BINARY_NAMES "fmodex" )
	package_create_release_binary_names( FMOD_BINARY_NAMES )
	package_create_debug_binary_names( FMOD_BINARY_NAMES )
	package_create_search_path_binary( FMOD )

	set( FMOD_SEARCH_BINARIES
        ${FMOD_HOME}
		${FMOD_SEARCH_PATH_BINARY}
		${FMOD_SEARCH_PATH_LIBRARY}
	)

	package_find_file( FMOD_BINARY_DEBUG "${FMOD_BINARY_NAMES_DEBUG}" "${FMOD_SEARCH_BINARIES}" "" )
	package_find_file( FMOD_BINARY_RELEASE "${FMOD_BINARY_NAMES_RELEASE}" "${FMOD_SEARCH_BINARIES}" "" )
endif()




# ************************************************************
# Finalize package
package_validate( FMOD )
package_add_parent_dir( FMOD )
package_end( FMOD )
