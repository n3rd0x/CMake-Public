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
cm_message_header( KINECT_FACETRACK )

if( WIN32 )
	cm_package_begin( KINECT_FACETRACK )
	cm_package_create_home_path( KINECT_FACETRACK FTSDK_DIR )

	# Check whether we are going to compile for x64Bit systems.
	string( REGEX MATCH "Win64" x64_FOUND ${CMAKE_GENERATOR} )
	# Set path suffix for x64.
	if( x64_FOUND )
		set( PATH_SUFFIX "amd64" )
		set( BIT_SUFFIX "64" )
	else()
		set( PATH_SUFFIX "x86" )
		set( BIT_SUFFIX "32" )
	endif()
	unset( x64_FOUND CACHE )


	# ************************************************************
	# Create Search Path
	set( KINECT_FACETRACK_PREFIX_PATH ${KINECT_FACETRACK_HOME} )
	cm_package_create_search_path_include( KINECT_FACETRACK )
	cm_package_create_search_path_library( KINECT_FACETRACK )


	# ************************************************************
	# Create Search Name
	set( KINECT_FACETRACK_LIBRARY_NAMES "FaceTrackLib" )


	# ************************************************************
	# Clear
	cm_package_clear_if_changed( KINECT_FACETRACK_PREFIX_PATH
		KINECT_FACETRACK_PATH_INCLUDE
		KINECT_FACETRACK_LIBRARY_DEBUG
		KINECT_FACETRACK_LIBRARY_RELEASE
		KINECT_FACETRACK_BINARY_RELEASE
		KINECT_FACETRACK_BINARY_DEBUG
	)


	# ************************************************************
	# Find Paths
	cm_package_find_path( KINECT_FACETRACK_PATH_INCLUDE "FaceTrackLib.h" "${KINECT_FACETRACK_SEARCH_PATH_INCLUDE}" "" )
	cm_package_find_library( KINECT_FACETRACK_LIBRARY_DEBUG "${KINECT_FACETRACK_LIBRARY_NAMES}" "${KINECT_FACETRACK_SEARCH_PATH_LIBRARY}" "${PATH_SUFFIX}" )
	cm_package_find_library( KINECT_FACETRACK_LIBRARY_RELEASE "${KINECT_FACETRACK_LIBRARY_NAMES}" "${KINECT_FACETRACK_SEARCH_PATH_LIBRARY}" "${PATH_SUFFIX}" )
	cm_package_make_library( KINECT_FACETRACK_LIBRARY KINECT_FACETRACK_LIBRARY_DEBUG KINECT_FACETRACK_LIBRARY_RELEASE )


	# ************************************************************
	# Find Binaries on Windows
	if( WIN32 )
		cm_package_find_file( KINECT_FACETRACK_BINARY_TRACKLIB "FaceTrackLib.dll" "${KINECT_FACETRACK_HOME}/redist" "${PATH_SUFFIX}" )
		cm_package_find_file( KINECT_FACETRACK_BINARY_TRACKDATA "FaceTrackData.dll" "${KINECT_FACETRACK_HOME}/redist" "${PATH_SUFFIX}" )

		if( KINECT_FACETRACK_BINARY_TRACKLIB )
			set( KINECT_FACETRACK_BINARY_DEBUG ${KINECT_FACETRACK_BINARY_TRACKLIB} )
			set( KINECT_FACETRACK_BINARY_RELEASE ${KINECT_FACETRACK_BINARY_TRACKLIB} )
		endif()

		if( KINECT_FACETRACK_BINARY_TRACKDATA )
			set( KINECT_FACETRACK_BINARY_DEBUG ${KINECT_FACETRACK_BINARY_DEBUG} ${KINECT_FACETRACK_BINARY_TRACKDATA} )
			set( KINECT_FACETRACK_BINARY_RELEASE ${KINECT_FACETRACK_BINARY_RELEASE} ${KINECT_FACETRACK_BINARY_TRACKDATA} )
		endif()
	endif()


	# ************************************************************
	# Finalize Package
	cm_package_validate( KINECT_FACETRACK )
	cm_package_include_options( KINECT_FACETRACK )
	cm_package_end( KINECT_FACETRACK )
else()
	cm_message_status( SEND_ERROR "This only works in Microsoft Windows." )
endif()
cm_message_footer( KINECT_FACETRACK )
