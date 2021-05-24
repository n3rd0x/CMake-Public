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
# Webiste: https://developer.gnome.org/glib


# ************************************************************
# Start package
cm_message_header(GLIB)
package_begin(GLIB)
package_create_home_path(GLIB GLIB_ROOT)




# ************************************************************
# Create search name
set(GLIB_LIBRARY_NAMES "glib-2.0")
package_create_debug_names(GLIB_LIBRARY_NAMES)




# ************************************************************
# Create search path
set(GLIB_PREFIX_PATH ${GLIB_HOME})
package_create_search_path_include(GLIB)
package_create_search_path_library(GLIB)




# ************************************************************
# Clear
set(GLIB_CLEAR_IF_CHANGED
    GLIB_PREFIX_PATH
)
foreach(VAR ${GLIB_CLEAR_IF_CHANGED})
    if(WIN32)
        package_clear_if_changed(${VAR}
            GLIB_LIBRARY_DEBUG
            GLIB_LIBRARY_RELEASE
            GLIB_PATH_INCLUDE
            GLIB_BINARY_RELEASE
            GLIB_BINARY_DEBUG
        )
    else()
        package_clear_if_changed(${VAR}
            GLIB_LIBRARY_DEBUG
            GLIB_LIBRARY_RELEASE
            GLIB_PATH_INCLUDE
        )
    endif()
endforeach()




# ************************************************************
# Find paths
package_find_path(GLIB_PATH_INCLUDE "glib.h" "${GLIB_SEARCH_PATH_INCLUDE}" "glib;glib-2.0")
package_find_library(GLIB_LIBRARY_DEBUG "${GLIB_LIBRARY_NAMES_DEBUG}" "${GLIB_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(GLIB_LIBRARY_RELEASE "${GLIB_LIBRARY_NAMES}" "${GLIB_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
package_make_library(GLIB_LIBRARY GLIB_LIBRARY_DEBUG GLIB_LIBRARY_RELEASE)




# ************************************************************
# Finalize package
package_validate(GLIB)
package_add_parent_dir(GLIB ADD_PARENT)
package_end(GLIB)
cm_message_footer(GLIB)

