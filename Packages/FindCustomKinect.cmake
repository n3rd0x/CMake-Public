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
cm_message_header( KINECT_SDK )

if( WIN32 )
	package_begin( KINECT_SDK )
	package_create_home_path( KINECT_SDK KINECTSDK10_DIR )

	# Check whether we are going to compile for x64-bit systems.
	string( REGEX MATCH "Win64" x64_FOUND ${CMAKE_GENERATOR} )
	# Set path suffix for x64.
	if( x64_FOUND )
		set( PATH_SUFFIX "amd64" )
	else()
		set( PATH_SUFFIX "x86" )
	endif()
	unset( x64_FOUND )


	# ************************************************************
	# Create search path
	set( KINECT_SDK_PREFIX_PATH ${KINECT_SDK_HOME} )
	package_create_search_path_include( KINECT_SDK )
	package_create_search_path_library( KINECT_SDK )


	# ************************************************************
	# Create search name
	set( KINECT_SDK_LIBRARY_NAMES "Kinect10" )



	# ************************************************************
	# Clear
	package_clear_if_changed( KINECT_SDK_PREFIX_PATH
		KINECT_SDK_PATH_INCLUDE
		KINECT_SDK_LIBRARY_DEBUG
		KINECT_SDK_LIBRARY_RELEASE
		KINECT_SDK_BINARY_RELEASE
		KINECT_SDK_BINARY_DEBUG
	)


	# ************************************************************
	# Find paths
	package_find_path( KINECT_SDK_PATH_INCLUDE "NuiApi.h" "${KINECT_SDK_SEARCH_PATH_INCLUDE}" "" )
	package_find_library( KINECT_SDK_LIBRARY_DEBUG "${KINECT_SDK_LIBRARY_NAMES}" "${KINECT_SDK_SEARCH_PATH_LIBRARY}" "${PATH_SUFFIX}" )
	package_find_library( KINECT_SDK_LIBRARY_RELEASE "${KINECT_SDK_LIBRARY_NAMES}" "${KINECT_SDK_SEARCH_PATH_LIBRARY}" "${PATH_SUFFIX}" )
	package_make_library( KINECT_SDK_LIBRARY KINECT_SDK_LIBRARY_DEBUG KINECT_SDK_LIBRARY_RELEASE )



	# ************************************************************
	# Find binaries on Windows
	set( KINECT_SDK_BINARY_NAMES "Kinect10.dll" )
	package_get_environment_path( KINECT_SDK SystemRoot )
	if( DEFINED KINECT_SDK_ENV_SystemRoot )
		set( KINECT_SDK_SEARCH_BINARIES "${KINECT_SDK_ENV_SystemRoot}/System32" )
	else()
		set( KINECT_SDK_SEARCH_BINARIES "c://Windows//System32" )
	endif()

	package_find_file( KINECT_SDK_BINARY_DEBUG "${KINECT_SDK_BINARY_NAMES}" "${KINECT_SDK_SEARCH_BINARIES}" "" )
	package_find_file( KINECT_SDK_BINARY_RELEASE "${KINECT_SDK_BINARY_NAMES}" "${KINECT_SDK_SEARCH_BINARIES}" "" )


	# ************************************************************
	# Finalize package
	package_validate( KINECT_SDK )
	package_add_parent_dir( KINECT_SDK )
	package_end( KINECT_SDK )
else()
	cm_message_status( SEND_ERROR "This only works in Microsoft Windows." )
endif()
cm_message_footer( KINECT_SDK )
