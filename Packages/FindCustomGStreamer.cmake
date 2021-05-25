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
# Webiste: https://gstreamer.freedesktop.org


# ************************************************************
# Start package
cm_message_header(GSTREAMER)
cm_package_begin(GSTREAMER)
cm_package_create_home_path(GSTREAMER GSTREAMER_ROOT)




# ************************************************************
# Create Search Name
set(GSTREAMER_PREFIX_NAMES "GStreamer" "gstreamer-1.0")
set(GSTREAMER_LIBRARY_NAMES "${GSTREAMER_PREFIX_NAMES}")
cm_package_create_debug_names(GSTREAMER_LIBRARY_NAMES)




# ************************************************************
# Create Search Path
set(GSTREAMER_PREFIX_PATH ${GSTREAMER_HOME})
cm_package_create_search_path_include(GSTREAMER)
cm_package_create_search_path_library(GSTREAMER)




# ************************************************************
# Clear
set(GSTREAMER_CLEAR_IF_CHANGED
    GSTREAMER_PREFIX_PATH
)
foreach(VAR ${GSTREAMER_CLEAR_IF_CHANGED})
    if(WIN32)
        cm_package_clear_if_changed(${VAR}
            GSTREAMER_LIBRARY_DEBUG
            GSTREAMER_LIBRARY_RELEASE
            GSTREAMER_PATH_INCLUDE
            GSTREAMER_BINARY_RELEASE
            GSTREAMER_BINARY_DEBUG
        )
    else()
        cm_package_clear_if_changed(${VAR}
            GSTREAMER_LIBRARY_DEBUG
            GSTREAMER_LIBRARY_RELEASE
            GSTREAMER_PATH_INCLUDE
        )
    endif()
endforeach()




# ************************************************************
# Find Paths
cm_package_find_path(GSTREAMER_PATH_INCLUDE "gst/gst.h" "${GSTREAMER_SEARCH_PATH_INCLUDE}" "gstreamer-1.0")
cm_package_find_library(GSTREAMER_LIBRARY_DEBUG "${GSTREAMER_LIBRARY_NAMES_DEBUG}" "${GSTREAMER_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(GSTREAMER_LIBRARY_RELEASE "${GSTREAMER_LIBRARY_NAMES}" "${GSTREAMER_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
cm_package_make_library(GSTREAMER_LIBRARY GSTREAMER_LIBRARY_DEBUG GSTREAMER_LIBRARY_RELEASE)




# ************************************************************
# Finalize Package
cm_package_validate(GSTREAMER)
cm_package_include_options(GSTREAMER)
cm_package_end(GSTREAMER)
cm_message_footer(GSTREAMER)

