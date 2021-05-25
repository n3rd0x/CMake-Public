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
cm_message_header( DXSHOW )
cm_package_begin( DXSHOW )
cm_package_create_home_path( DXSHOW DXSHOW_ROOT )


# ************************************************************
# Create Search Path
set( DXSHOW_PREFIX_PATH ${DXSHOW_HOME} )
cm_package_create_search_path_include( DXSHOW )
cm_package_create_search_path_library( DXSHOW )
package_create_search_path_plugin( DXSHOW )


# ************************************************************
# Create Search Name
set( DXSHOW_LIBRARY_NAMES "dscapture" )
cm_package_create_debug_names( DXSHOW_LIBRARY_NAMES )


# ************************************************************
# Clear
cm_package_clear_if_changed( DXSHOW_PREFIX_PATH
    DXSHOW_LIBRARY_RELEASE
    DXSHOW_LIBRARY_DEBUG
    DXSHOW_PATH_INCLUDE
)


# ************************************************************
# Find Paths
cm_package_find_path( DXSHOW_PATH_INCLUDE "CaptureDSAPI.h" "${DXSHOW_SEARCH_PATH_INCLUDE}" "dxshow" )
cm_package_find_library( DXSHOW_LIBRARY_DEBUG "${DXSHOW_LIBRARY_NAMES_DEBUG}" "${DXSHOW_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library( DXSHOW_LIBRARY_RELEASE "${DXSHOW_LIBRARY_NAMES}" "${DXSHOW_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel" )
cm_package_make_library( DXSHOW_LIBRARY DXSHOW_LIBRARY_DEBUG DXSHOW_LIBRARY_RELEASE )


# ************************************************************
# Find Binaries on Windows
if( WIN32 )
	set( DXSHOW_BINARY_NAMES "dscapture" )
	cm_package_create_release_binary_names( DXSHOW_BINARY_NAMES )
	cm_package_create_debug_binary_names( DXSHOW_BINARY_NAMES )
	cm_package_create_search_path_binary( DXSHOW )

	set( DXSHOW_SEARCH_BINARIES
		${DXSHOW_SEARCH_PATH_BINARY}
		${DXSHOW_SEARCH_PATH_LIBRARY}
	)

	cm_package_clear_if_changed( DXSHOW_PREFIX_PATH
		DXSHOW_BINARY_RELEASE
		DXSHOW_BINARY_DEBUG
	)

	cm_package_find_file( DXSHOW_BINARY_DEBUG "${DXSHOW_BINARY_NAMES_DEBUG}" "${DXSHOW_SEARCH_BINARIES}" "debug" )
	cm_package_find_file( DXSHOW_BINARY_RELEASE "${DXSHOW_BINARY_NAMES_RELEASE}" "${DXSHOW_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
endif()


# ************************************************************
# Finalize Package
cm_package_validate( DXSHOW )
cm_package_include_options( DXSHOW )
cm_package_end( DXSHOW )
cm_message_footer( DXSHOW )

