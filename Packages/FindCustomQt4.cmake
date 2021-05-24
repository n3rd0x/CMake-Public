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
cm_message_header( QT )
package_begin( QT )
package_create_home_path( QT QT4_ROOT )


# ************************************************************
# Create search path
set( QT_PREFIX_PATH ${QT_HOME} )
package_create_search_path_binary( QT )
package_create_search_path_include( QT )
package_create_search_path_library( QT )


# ************************************************************
# Clear
package_clear_if_changed( QT_PREFIX_PATH
	QT_QMAKE_EXECUTABLE
)
package_clear_if_changed( QT_COMPONENTS
	QT_QMAKE_EXECUTABLE
)


# ************************************************************
# Find library
# Find Qt based on the environment variable.
if( NOT QT_QMAKE_EXECUTABLE )
	package_find_file( QT_QMAKE_EXECUTABLE "qmake.exe" "${QT_SEARCH_PATH_BINARY}" "" )
    #package_get_environment_path( QT QT4_DIR )
    #find_file( QT_QMAKE_EXECUTABLE NAMES "qmake.exe" HINTS ${QT_ENV_QT4_DIR} PATH_SUFFIXES "bin" NO_DEFAULT_PATH )
endif()

# Set Qt components.
set( QT_COMPONENTS "${CustomQt4_FIND_COMPONENTS}" CACHE STRING "Qt4 components." )

# Use official Qt package.
find_package( Qt4 COMPONENTS ${QT_COMPONENTS} )


# ************************************************************
# Update libraries and binaries
if( QT_FOUND )
	foreach( COMPONENT ${QT_COMPONENTS} )
		# TST 2013-12-08
		# Updating libraries is not necessary due to the official CMake
		# Qt4 module will update the variables.

		# Update libraries.
		#string( TOUPPER ${COMPONENT} LIBRARY )
		#set( QT_LIBRARIES ${QT_LIBRARIES} ${QT_${LIBRARY}_LIBRARY} )
		#unset( LIBRARY )

		# Update binaries.
		if( WIN32 )
			set( QT_BINARY_DEBUG ${QT_BINARY_DEBUG} "${QT_BINARY_DIR}/${COMPONENT}d4.dll" )
			set( QT_BINARY_RELEASE ${QT_BINARY_RELEASE} "${QT_BINARY_DIR}/${COMPONENT}4.dll" )
		endif()
	endforeach()
endif()


# ************************************************************
# Finalize package
if( QT_FOUND )
	cm_message_status( STATUS "The Qt4 library is located." )
else()
	cm_message_status( "" "Failed to locate the Qt4 library." )
endif()
cm_message_footer( QT )
