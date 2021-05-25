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
# Website: http://www.hyperrealm.com/libconfig
# Source:  https://github.com/hyperrealm/libconfig


# ************************************************************
# Start package
cm_message_header( LIBCONFIG )
cm_package_begin( LIBCONFIG )
cm_package_create_home_path( LIBCONFIG LIBCONFIG_ROOT )


# ************************************************************
# Create Search Path
set( LIBCONFIG_PREFIX_PATH ${LIBCONFIG_HOME} )
cm_package_create_search_path_include( LIBCONFIG )
cm_package_create_search_path_library( LIBCONFIG )


# ************************************************************
# Create Search Name
set( LIBCONFIG_LIBRARY_NAMES "libconfig" )
cm_package_create_debug_names( LIBCONFIG_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
	cm_package_clear_if_changed( LIBCONFIG_PREFIX_PATH
		LIBCONFIG_BINARY_RELEASE
		LIBCONFIG_BINARY_DEBUG
		LIBCONFIG_LIBRARY_DEBUG
		LIBCONFIG_LIBRARY_RELEASE
		LIBCONFIG_PATH_INCLUDE
	)
else()
	cm_package_clear_if_changed( LIBCONFIG_PREFIX_PATH
		LIBCONFIG_LIBRARY_DEBUG
		LIBCONFIG_LIBRARY_RELEASE
		LIBCONFIG_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find Paths
cm_package_find_path( LIBCONFIG_PATH_INCLUDE "libconfig.h" "${LIBCONFIG_SEARCH_PATH_INCLUDE}" "libconfig" )
cm_package_find_library( LIBCONFIG_LIBRARY_DEBUG "${LIBCONFIG_LIBRARY_NAMES_DEBUG}" "${LIBCONFIG_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( LIBCONFIG_LIBRARY_RELEASE "${LIBCONFIG_LIBRARY_NAMES}" "${LIBCONFIG_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( LIBCONFIG_LIBRARY LIBCONFIG_LIBRARY_DEBUG LIBCONFIG_LIBRARY_RELEASE )


# ************************************************************
# Find Binaries on Windows
if( WIN32 )
	set( LIBCONFIG_BINARY_NAMES "libconfig" )
	cm_package_create_release_binary_names( LIBCONFIG_BINARY_NAMES )
	cm_package_create_debug_binary_names( LIBCONFIG_BINARY_NAMES )
	cm_package_create_search_path_binary( LIBCONFIG )

	set( LIBCONFIG_SEARCH_BINARIES
		${LIBCONFIG_SEARCH_PATH_BINARY}
		${LIBCONFIG_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file( LIBCONFIG_BINARY_DEBUG "${LIBCONFIG_BINARY_NAMES_DEBUG}" "${LIBCONFIG_SEARCH_BINARIES}" "debug" )
	cm_package_find_file( LIBCONFIG_BINARY_RELEASE "${LIBCONFIG_BINARY_NAMES_RELEASE}" "${LIBCONFIG_SEARCH_BINARIES}" "release" )
endif()


# ************************************************************
# Finalize Package
cm_package_validate( LIBCONFIG )
cm_package_include_options( LIBCONFIG )
cm_package_end( LIBCONFIG )
cm_message_footer( LIBCONFIG )
