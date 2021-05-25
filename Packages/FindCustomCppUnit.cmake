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
# Website: http://sourceforge.net/projects/cppunit
# Website: http://www.freedesktop.org/wiki/Software/cppunit
# Document: http://cppunit.sourceforge.net/doc/cvs/index.html


# ************************************************************
# Start package
cm_message_header( CPPUNIT )
cm_package_begin( CPPUNIT )
cm_package_create_home_path( CPPUNIT CPPUNIT_ROOT )


# ************************************************************
# Create Search Path
set( CPPUNIT_PREFIX_PATH ${CPPUNIT_HOME} )
cm_package_create_search_path_include( CPPUNIT )
cm_package_create_search_path_library( CPPUNIT )


# ************************************************************
# Create Search Name
set( CPPUNIT_LIBRARY_NAMES "cppunit" )
cm_package_create_debug_names( CPPUNIT_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
	cm_package_clear_if_changed( CPPUNIT_PREFIX_PATH
		CPPUNIT_BINARY_RELEASE
		CPPUNIT_BINARY_DEBUG
		CPPUNIT_LIBRARY_DEBUG
		CPPUNIT_LIBRARY_RELEASE
		CPPUNIT_PATH_INCLUDE
	)
else()
	cm_package_clear_if_changed( CPPUNIT_PREFIX_PATH
		CPPUNIT_LIBRARY_DEBUG
		CPPUNIT_LIBRARY_RELEASE
		CPPUNIT_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find Paths
cm_package_find_path( CPPUNIT_PATH_INCLUDE "Test.h" "${CPPUNIT_SEARCH_PATH_INCLUDE}" "cppunit" )
cm_package_find_library( CPPUNIT_LIBRARY_DEBUG "${CPPUNIT_LIBRARY_NAMES_DEBUG}" "${CPPUNIT_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( CPPUNIT_LIBRARY_RELEASE "${CPPUNIT_LIBRARY_NAMES}" "${CPPUNIT_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( CPPUNIT_LIBRARY CPPUNIT_LIBRARY_DEBUG CPPUNIT_LIBRARY_RELEASE )


# ************************************************************
# Find Binaries on Windows
if( WIN32 )
	set( CPPUNIT_BINARY_NAMES "cppunit" )
	cm_package_create_release_binary_names( CPPUNIT_BINARY_NAMES )
	cm_package_create_debug_binary_names( CPPUNIT_BINARY_NAMES )
	cm_package_create_search_path_binary( CPPUNIT )

	set( CPPUNIT_SEARCH_BINARIES
		${CPPUNIT_SEARCH_PATH_BINARY}
		${CPPUNIT_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file( CPPUNIT_BINARY_DEBUG "${CPPUNIT_BINARY_NAMES_DEBUG}" "${CPPUNIT_SEARCH_BINARIES}" "debug" )
	cm_package_find_file( CPPUNIT_BINARY_RELEASE "${CPPUNIT_BINARY_NAMES_RELEASE}" "${CPPUNIT_SEARCH_BINARIES}" "release" )
endif()


# ************************************************************
# Finalize Package
cm_package_validate( CPPUNIT )
cm_package_include_options( CPPUNIT )
cm_package_end( CPPUNIT )
cm_message_footer( CPPUNIT )
