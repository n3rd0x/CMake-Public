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
cm_package_begin( TURBOJPEG )
cm_package_create_home_path( TURBOJPEG TURBOJPEG_ROOT )


# ************************************************************
# Create Search Path
set( TURBOJPEG_PREFIX_PATH ${TURBOJPEG_HOME} )
cm_package_create_search_path_include( TURBOJPEG )
cm_package_create_search_path_library( TURBOJPEG )


# ************************************************************
# Create Search Name
set( TURBOJPEG_LIBRARY_NAMES "TurboJPEG" )
cm_package_create_debug_names( TURBOJPEG_LIBRARY_NAMES )


# ************************************************************
# Clear
cm_package_clear_if_changed( TURBOJPEG_PREFIX_PATH
    TURBOJPEG_LIBRARY_DEBUG
    TURBOJPEG_LIBRARY_RELEASE
    TURBOJPEG_PATH_INCLUDE
)


# ************************************************************
# Find Paths
cm_package_find_path( TURBOJPEG_PATH_INCLUDE "turbojpeg.h" "${TURBOJPEG_SEARCH_PATH_INCLUDE}" "" )
cm_package_find_library( TURBOJPEG_LIBRARY_DEBUG "${TURBOJPEG_LIBRARY_NAMES_DEBUG}" "${TURBOJPEG_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( TURBOJPEG_LIBRARY_RELEASE "${TURBOJPEG_LIBRARY_NAMES}" "${TURBOJPEG_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( TURBOJPEG_LIBRARY TURBOJPEG_LIBRARY_DEBUG TURBOJPEG_LIBRARY_RELEASE )


# ************************************************************
# Find Binaries on Windows
if( WIN32 )
	set( TURBOJPEG_BINARY_NAMES "turbojpeg" )
	cm_package_create_release_binary_names( TURBOJPEG_BINARY_NAMES )
	cm_package_create_debug_binary_names( TURBOJPEG_BINARY_NAMES )
	cm_package_create_search_path_binary( TURBOJPEG )

	set( TURBOJPEG_SEARCH_BINARIES
		${TURBOJPEG_SEARCH_PATH_BINARY}
		${TURBOJPEG_SEARCH_PATH_LIBRARY}
	)

	cm_package_clear_if_changed( TURBOJPEG_PREFIX_PATH
		TURBOJPEG_BINARY_RELEASE
		TURBOJPEG_BINARY_DEBUG
	)

	cm_package_find_file( TURBOJPEG_BINARY_DEBUG "${TURBOJPEG_BINARY_NAMES_DEBUG}" "${TURBOJPEG_SEARCH_BINARIES}" "debug" )
	cm_package_find_file( TURBOJPEG_BINARY_RELEASE "${TURBOJPEG_BINARY_NAMES_RELEASE}" "${TURBOJPEG_SEARCH_BINARIES}" "release" )
endif()


# ************************************************************
# Finalize Package
cm_package_validate( TURBOJPEG )
cm_package_include_options( TURBOJPEG )
cm_package_end( TURBOJPEG )
