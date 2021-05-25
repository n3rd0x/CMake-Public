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
# Website: https://github.com/xdspacelab/openvslam


# ************************************************************
# Start package
cm_message_header(OPENVSLAM)
cm_package_begin(OPENVSLAM)
cm_package_create_home_path(OPENVSLAM OPENVSLAM_ROOT)


# ************************************************************
# Create Search Path
set(OPENVSLAM_PREFIX_PATH ${OPENVSLAM_HOME})
cm_package_create_search_path_include(OPENVSLAM)
cm_package_create_search_path_library(OPENVSLAM)


# ************************************************************
# Create Search Name
set(OPENVSLAM_LIBRARY_NAMES "openvslam")
cm_package_create_debug_names(OPENVSLAM_LIBRARY_NAMES)


# ************************************************************
# Clear
if(WIN32)
	cm_package_clear_if_changed(OPENVSLAM_PREFIX_PATH
		OPENVSLAM_BINARY_RELEASE
		OPENVSLAM_BINARY_DEBUG
		OPENVSLAM_LIBRARY_DEBUG
		OPENVSLAM_LIBRARY_RELEASE
		OPENVSLAM_PATH_INCLUDE
	)
else()
	cm_package_clear_if_changed(OPENVSLAM_PREFIX_PATH
		OPENVSLAM_LIBRARY_DEBUG
		OPENVSLAM_LIBRARY_RELEASE
		OPENVSLAM_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find Paths
cm_package_find_path(OPENVSLAM_PATH_INCLUDE "system.h" "${OPENVSLAM_SEARCH_PATH_INCLUDE}" "openvslam")
cm_package_find_library(OPENVSLAM_LIBRARY_DEBUG "${OPENVSLAM_LIBRARY_NAMES_DEBUG}" "${OPENVSLAM_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library(OPENVSLAM_LIBRARY_RELEASE "${OPENVSLAM_LIBRARY_NAMES}" "${OPENVSLAM_SEARCH_PATH_LIBRARY}" "release" )
cm_package_make_library(OPENVSLAM_LIBRARY OPENVSLAM_LIBRARY_DEBUG OPENVSLAM_LIBRARY_RELEASE)

cm_package_find_library(OPENVSLAM_VIEWER_LIBRARY_DEBUG "pangolin_viewer" "${OPENVSLAM_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library(OPENVSLAM_VIEWER_LIBRARY_RELEASE "pangolin_viewer" "${OPENVSLAM_SEARCH_PATH_LIBRARY}" "release" )
cm_package_make_library(OPENVSLAM_VIEWER_LIBRARY OPENVSLAM_VIEWER_LIBRARY_DEBUG OPENVSLAM_VIEWER_LIBRARY_RELEASE)


# ************************************************************
# Find Binaries on Windows
if(WIN32)
	set(OPENVSLAM_BINARY_NAMES "openvslam")
	cm_package_create_release_binary_names(OPENVSLAM_BINARY_NAMES)
	cm_package_create_debug_binary_names(OPENVSLAM_BINARY_NAMES)
	cm_package_create_search_path_binary(OPENVSLAM)

	set(OPENVSLAM_SEARCH_BINARIES
		${OPENVSLAM_SEARCH_PATH_BINARY}
		${OPENVSLAM_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(OPENVSLAM_BINARY_DEBUG "${OPENVSLAM_BINARY_NAMES_DEBUG}" "${OPENVSLAM_SEARCH_BINARIES}" "debug")
	cm_package_find_file(OPENVSLAM_BINARY_RELEASE "${OPENVSLAM_BINARY_NAMES_RELEASE}" "${OPENVSLAM_SEARCH_BINARIES}" "release")
endif()


# ************************************************************
# Finalize Package
cm_package_validate(OPENVSLAM)
cm_package_include_options(OPENVSLAM)
cm_package_end(OPENVSLAM)
cm_message_footer(OPENVSLAM)
