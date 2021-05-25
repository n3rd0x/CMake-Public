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
# Website: http://opencv.org


# ************************************************************
# Start package
# ************************************************************
cm_message_header(OPENCV)
cm_package_begin(OPENCV)
cm_package_create_home_path(OPENCV OPENCV_ROOT)

# Options.
option(OPENCV_LEGACY "Searching for legacy version. Version less than 4.0.0" ON)
if(MSVC)
    set(OPENCV_VERSION "340" CACHE STRING "OpenCV version to search for.")
endif()




# ************************************************************
# Create Search Path
# ************************************************************
if(MSVC)
    string(REGEX MATCH "Win64" x64Found ${CMAKE_GENERATOR})
    set(MsvcVer "vc12")
    if(x64Found)
        set(OPENCV_PREFIX_PATH ${OPENCV_HOME} "${OPENCV_HOME}/x64/${MsvcVer}")
    else()
        set(OPENCV_PREFIX_PATH ${OPENCV_HOME} "${OPENCV_HOME}/x86/${MsvcVer}")
    endif()
else()
    set(OPENCV_PREFIX_PATH ${OPENCV_HOME})
endif()
cm_package_create_search_path_include(OPENCV)
cm_package_create_search_path_library(OPENCV)




# ************************************************************
# Create Search Name
# ************************************************************
if(MSVC)
    set(OPENCV_LIBRARY_NAMES "opencv_world${OPENCV_VERSION}")
else()
    set(OPENCV_LIBRARY_NAMES "opencv_world")
endif()
cm_package_create_debug_names(OPENCV_LIBRARY_NAMES)




# ************************************************************
# Clear
# ************************************************************
cm_package_clear_if_changed(OPENCV_HOME
    OPENCV_PATH_INCLUDE
    OPENCV_LIBRARY_DEBUG
    OPENCV_LIBRARY_RELEASE
    OPENCV_BINARY_DEBUG
    OPENCV_BINARY_RELEASE
    OPENCV_BINARY_FFMPEG_DEBUG
    OPENCV_BINARY_FFMPEG_RELEASE
)




# ************************************************************
# Find Paths
# ************************************************************
if(OPENCV_LEGACY)
    cm_package_find_path(OPENCV_PATH_INCLUDE "cv.h" "${OPENCV_SEARCH_PATH_INCLUDE}" "opencv")
else()
    cm_package_find_path(OPENCV_PATH_INCLUDE "opencv2" "${OPENCV_SEARCH_PATH_INCLUDE}" "opencv4")
endif()
cm_package_find_library(OPENCV_LIBRARY_DEBUG "${OPENCV_LIBRARY_NAMES_DEBUG}" "${OPENCV_SEARCH_PATH_LIBRARY}" "")
cm_package_find_library(OPENCV_LIBRARY_RELEASE "${OPENCV_LIBRARY_NAMES}" "${OPENCV_SEARCH_PATH_LIBRARY}" "")
cm_package_make_library(OPENCV_LIBRARY OPENCV_LIBRARY_DEBUG OPENCV_LIBRARY_RELEASE)




# ************************************************************
# Find Binaries on Windows
if(WIN32)
    set(OPENCV_BINARY_NAMES ${OPENCV_LIBRARY_NAMES})
	cm_package_create_release_binary_names(OPENCV_BINARY_NAMES)
	cm_package_create_debug_binary_names(OPENCV_BINARY_NAMES)

    set(OPENCV_BINARY_FFMPEG_NAMES "opencv_ffmpeg${OPENCV_VERSION}")
    cm_package_create_release_binary_names(OPENCV_BINARY_FFMPEG_NAMES)
	cm_package_create_debug_binary_names(OPENCV_BINARY_FFMPEG_NAMES)

	cm_package_create_search_path_binary(OPENCV)
	set(OPENCV_SEARCH_BINARIES
		${OPENCV_SEARCH_PATH_BINARY}
		${OPENCV_SEARCH_PATH_LIBRARY}
	)

    cm_package_find_file(OPENCV_BINARY_DEBUG "${OPENCV_BINARY_NAMES_DEBUG}" "${OPENCV_SEARCH_BINARIES}" "")
	cm_package_find_file(OPENCV_BINARY_RELEASE "${OPENCV_BINARY_NAMES_RELEASE}" "${OPENCV_SEARCH_BINARIES}" "")
    cm_package_find_file(OPENCV_BINARY_FFMPEG_DEBUG "${OPENCV_BINARY_FFMPEG_NAMES_DEBUG}" "${OPENCV_SEARCH_BINARIES}" "")
	cm_package_find_file(OPENCV_BINARY_FFMPEG_RELEASE "${OPENCV_BINARY_FFMPEG_NAMES_RELEASE}" "${OPENCV_SEARCH_BINARIES}" "")
    if(OPENCV_BINARY_DEBUG)
        if(OPENCV_BINARY_FFMPEG_DEBUG)
            list(APPEND OPENCV_BINARY_DEBUG "${OPENCV_BINARY_FFMPEG_DEBUG}")
        endif()
    endif()

    if(OPENCV_BINARY_RELEASE)
        if(OPENCV_BINARY_FFMPEG_RELEASE)
            list(APPEND OPENCV_BINARY_RELEASE "${OPENCV_BINARY_FFMPEG_RELEASE}")
        endif()
    endif()
endif()




# ************************************************************
# Finalize Package
# ************************************************************
cm_package_validate(OPENCV)
cm_package_include_options(OPENCV)
cm_package_end(OPENCV)
cm_message_footer(OPENCV)
