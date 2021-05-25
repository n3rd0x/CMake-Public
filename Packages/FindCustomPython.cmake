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
# Website: http://www.python.org


# ************************************************************
# Start package
cm_message_header( PYTHON )
cm_package_begin( PYTHON )
cm_package_create_home_path( PYTHON PYTHON_ROOT )

# Available versions.
set( PYTHON_ADDITIONAL_VERSION "" CACHE STRING "Supply additional version." )
set( PYTHON_VERSIONS "3.4;2.7" "${PYTHON_ADDITIONAL_VERSION}" )

# Current newest version.
set( PYTHON_VERSION "" )



# ************************************************************
# Create Search Path
set( PYTHON_PREFIX_PATH ${PYTHON_HOME} )
cm_package_create_search_path_include( PYTHON "${PYTHON_VERSIONS}" )
cm_package_create_search_path_library( PYTHON )


# ************************************************************
# Create Search Name
set( PYTHON_LIBRARY_NAMES "python" )
package_create_versional_names( PYTHON_LIBRARY_NAMES "${PYTHON_VERSIONS}" )
cm_package_create_debug_names( PYTHON_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
	cm_package_clear_if_changed( PYTHON_PREFIX_PATH
		PYTHON_BINARY_RELEASE
		PYTHON_BINARY_DEBUG
		PYTHON_LIBRARY_DEBUG
		PYTHON_LIBRARY_RELEASE
		PYTHON_PATH_INCLUDE
	)
else()
	cm_package_clear_if_changed( PYTHON_PREFIX_PATH
		PYTHON_LIBRARY_DEBUG
		PYTHON_LIBRARY_RELEASE
		PYTHON_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find Paths
cm_package_find_path( PYTHON_PATH_INCLUDE "python.h" "${PYTHON_SEARCH_PATH_INCLUDE}" "python" )
cm_package_find_library( PYTHON_LIBRARY_DEBUG "${PYTHON_LIBRARY_NAMES_DEBUG}" "${PYTHON_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( PYTHON_LIBRARY_RELEASE "${PYTHON_LIBRARY_NAMES}" "${PYTHON_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( PYTHON_LIBRARY PYTHON_LIBRARY_DEBUG PYTHON_LIBRARY_RELEASE )


# ************************************************************
# Find Binaries on Windows
if( WIN32 )
	set( PYTHON_BINARY_NAMES "${PYTHON_LIBRARY_NAMES}" )
	cm_package_create_release_binary_names( PYTHON_BINARY_NAMES )
	cm_package_create_debug_binary_names( PYTHON_BINARY_NAMES )
	cm_package_create_search_path_binary( PYTHON )

	set( PYTHON_SEARCH_BINARIES
		${PYTHON_SEARCH_PATH_BINARY}
		${PYTHON_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file( PYTHON_BINARY_DEBUG "${PYTHON_BINARY_NAMES_DEBUG}" "${PYTHON_SEARCH_BINARIES}" "debug" )
	cm_package_find_file( PYTHON_BINARY_RELEASE "${PYTHON_BINARY_NAMES_RELEASE}" "${PYTHON_SEARCH_BINARIES}" "release" )
endif()


# ************************************************************
# Finalize Package
cm_package_validate( PYTHON )
cm_package_include_options( PYTHON )
cm_package_end( PYTHON )
cm_message_footer( PYTHON )
