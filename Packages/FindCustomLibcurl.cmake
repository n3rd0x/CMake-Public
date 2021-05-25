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
# Website: http://curl.haxx.se/libcurl


# ************************************************************
# Start package
cm_message_header( LIBCURL )
cm_package_begin( LIBCURL )
cm_package_create_home_path( LIBCURL LIBCURL_ROOT )


# ************************************************************
# Create Search Path
set( LIBCURL_PREFIX_PATH ${LIBCURL_HOME} )
cm_package_create_search_path_include( LIBCURL )
cm_package_create_search_path_library( LIBCURL )


# ************************************************************
# Create Search Name
set( LIBCURL_LIBRARY_NAMES "libcurl" )
cm_package_create_debug_names( LIBCURL_LIBRARY_NAMES )


# ************************************************************
# Clear
cm_package_clear_if_changed( LIBCURL_PREFIX_PATH
    LIBCURL_LIBRARY_DEBUG
    LIBCURL_LIBRARY_RELEASE
    LIBCURL_PATH_INCLUDE
)


# ************************************************************
# Find Paths
cm_package_find_path( LIBCURL_PATH_INCLUDE "curl.h" "${LIBCURL_SEARCH_PATH_INCLUDE}" "curl" )
#set (LIBCURL_PATH_INCLUDE "${LIBCURL_PREFIX_PATH}/curl")
cm_package_find_library( LIBCURL_LIBRARY_DEBUG "${LIBCURL_LIBRARY_NAMES_DEBUG}" "${LIBCURL_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( LIBCURL_LIBRARY_RELEASE "${LIBCURL_LIBRARY_NAMES}" "${LIBCURL_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( LIBCURL_LIBRARY LIBCURL_LIBRARY_DEBUG LIBCURL_LIBRARY_RELEASE )


# ************************************************************
# Find Binaries on Windows
if( WIN32 )
	set( LIBCURL_BINARY_NAMES "libcurl" )
	cm_package_create_release_binary_names( LIBCURL_BINARY_NAMES )
	cm_package_create_debug_binary_names( LIBCURL_BINARY_NAMES )
	cm_package_create_search_path_binary( LIBCURL )

	set( LIBCURL_SEARCH_BINARIES
		${LIBCURL_SEARCH_PATH_BINARY}
		${LIBCURL_SEARCH_PATH_LIBRARY}
	)

	cm_package_clear_if_changed( LIBCURL_PREFIX_PATH
		LIBCURL_BINARY_RELEASE
		LIBCURL_BINARY_DEBUG
	)

	cm_package_find_file( LIBCURL_BINARY_DEBUG "${LIBCURL_BINARY_NAMES_DEBUG}" "${LIBCURL_SEARCH_BINARIES}" "debug" )
	cm_package_find_file( LIBCURL_BINARY_RELEASE "${LIBCURL_BINARY_NAMES_RELEASE}" "${LIBCURL_SEARCH_BINARIES}" "release" )
endif()


# ************************************************************
# Finalize Package
cm_package_validate( LIBCURL )
cm_package_include_options( LIBCURL )
cm_package_end( LIBCURL )
cm_message_footer( LIBCURL )
