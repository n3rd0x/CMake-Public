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
message_header(GSTREAMER)
package_begin(GSTREAMER)
package_create_home_path(GSTREAMER GSTREAMER_ROOT)




# ************************************************************
# Create search name
set(GSTREAMER_PREFIX_NAMES "GStreamer" "gstreamer-1.0")
set(GSTREAMER_LIBRARY_NAMES "${GSTREAMER_PREFIX_NAMES}")
package_create_debug_names(GSTREAMER_LIBRARY_NAMES)




# ************************************************************
# Create search path
set(GSTREAMER_PREFIX_PATH ${GSTREAMER_HOME})
package_create_search_path_include(GSTREAMER)
package_create_search_path_library(GSTREAMER)




# ************************************************************
# Clear
set(GSTREAMER_CLEAR_IF_CHANGED 
    GSTREAMER_PREFIX_PATH
)
foreach(VAR ${GSTREAMER_CLEAR_IF_CHANGED})
    if(WIN32)
        package_clear_if_changed(${VAR}
            GSTREAMER_LIBRARY_DEBUG
            GSTREAMER_LIBRARY_RELEASE
            GSTREAMER_PATH_INCLUDE
            GSTREAMER_BINARY_RELEASE
            GSTREAMER_BINARY_DEBUG
        )
    else()
        package_clear_if_changed(${VAR}
            GSTREAMER_LIBRARY_DEBUG
            GSTREAMER_LIBRARY_RELEASE
            GSTREAMER_PATH_INCLUDE
        )
    endif()
endforeach()




# ************************************************************
# Find paths
package_find_path(GSTREAMER_PATH_INCLUDE "gst/gst.h" "${GSTREAMER_SEARCH_PATH_INCLUDE}" "gstreamer-1.0")
package_find_library(GSTREAMER_LIBRARY_DEBUG "${GSTREAMER_LIBRARY_NAMES_DEBUG}" "${GSTREAMER_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(GSTREAMER_LIBRARY_RELEASE "${GSTREAMER_LIBRARY_NAMES}" "${GSTREAMER_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
package_make_library(GSTREAMER_LIBRARY GSTREAMER_LIBRARY_DEBUG GSTREAMER_LIBRARY_RELEASE)




# ************************************************************
# Finalize package
package_validate(GSTREAMER)
package_add_parent_dir(GSTREAMER ADD_PARENT)
package_end(GSTREAMER)
message_footer(GSTREAMER)

