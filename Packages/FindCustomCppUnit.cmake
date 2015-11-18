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
# Website: http://sourceforge.net/projects/cppunit
# Website: http://www.freedesktop.org/wiki/Software/cppunit
# Document: http://cppunit.sourceforge.net/doc/cvs/index.html


# ************************************************************
# Start package
message_header( CPPUNIT )
package_begin( CPPUNIT )
package_create_home_path( CPPUNIT CPPUNIT_ROOT )


# ************************************************************
# Create search path
set( CPPUNIT_PREFIX_PATH ${CPPUNIT_HOME} )
package_create_search_path_include( CPPUNIT )
package_create_search_path_library( CPPUNIT )


# ************************************************************
# Create search name
set( CPPUNIT_LIBRARY_NAMES "cppunit" )
package_create_debug_names( CPPUNIT_LIBRARY_NAMES )


# ************************************************************
# Clear
if( WIN32 )
	package_clear_if_changed( CPPUNIT_PREFIX_PATH
		CPPUNIT_BINARY_RELEASE
		CPPUNIT_BINARY_DEBUG
		CPPUNIT_LIBRARY_DEBUG
		CPPUNIT_LIBRARY_RELEASE
		CPPUNIT_PATH_INCLUDE
	)
else()
	package_clear_if_changed( CPPUNIT_PREFIX_PATH
		CPPUNIT_LIBRARY_DEBUG
		CPPUNIT_LIBRARY_RELEASE
		CPPUNIT_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find paths
package_find_path( CPPUNIT_PATH_INCLUDE "Test.h" "${CPPUNIT_SEARCH_PATH_INCLUDE}" "cppunit" )
package_find_library( CPPUNIT_LIBRARY_DEBUG "${CPPUNIT_LIBRARY_NAMES_DEBUG}" "${CPPUNIT_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( CPPUNIT_LIBRARY_RELEASE "${CPPUNIT_LIBRARY_NAMES}" "${CPPUNIT_SEARCH_PATH_LIBRARY}" "release"  )
package_make_library( CPPUNIT_LIBRARY CPPUNIT_LIBRARY_DEBUG CPPUNIT_LIBRARY_RELEASE )


# ************************************************************
# Find binaries on Windows
if( WIN32 )
	set( CPPUNIT_BINARY_NAMES "cppunit" )
	package_create_release_binary_names( CPPUNIT_BINARY_NAMES )
	package_create_debug_binary_names( CPPUNIT_BINARY_NAMES )
	package_create_search_path_binary( CPPUNIT )
	
	set( CPPUNIT_SEARCH_BINARIES 
		${CPPUNIT_SEARCH_PATH_BINARY}
		${CPPUNIT_SEARCH_PATH_LIBRARY}
	)

	package_find_file( CPPUNIT_BINARY_DEBUG "${CPPUNIT_BINARY_NAMES_DEBUG}" "${CPPUNIT_SEARCH_BINARIES}" "debug" )
	package_find_file( CPPUNIT_BINARY_RELEASE "${CPPUNIT_BINARY_NAMES_RELEASE}" "${CPPUNIT_SEARCH_BINARIES}" "release" )
endif()


# ************************************************************
# Finalize package
package_validate( CPPUNIT )
package_add_parent_dir( CPPUNIT )
package_end( CPPUNIT )
message_footer( CPPUNIT )
