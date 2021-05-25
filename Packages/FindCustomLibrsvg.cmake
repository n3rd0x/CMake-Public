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
# Website: https://github.com/GNOME/librsvg


# ************************************************************
# Start Package
# ************************************************************
cm_message_header(RSVG)
cm_package_begin(RSVG)
cm_package_create_home_path(RSVG RSVG_ROOT)




# ************************************************************
# Options
# ************************************************************
option(RSVG_PRIORITY_STATICAL "Flag for priority statical library." OFF)
set(RSVG_VERSION "2" CACHE STRING "Select version.")
set_property(CACHE RSVG_VERSION PROPERTY STRINGS "2")




# ************************************************************
# Create Search Paths
# ************************************************************
set(RSVG_PREFIX_PATH ${RSVG_HOME})
cm_package_create_search_path_include(RSVG)
cm_package_create_search_path_library(RSVG)

set(RSVG_INCLUDE_SEARCH_SUFFIX "librsvg")
if(RSVG_VERSION STREQUAL "2")
    list(APPEND RSVG_INCLUDE_SEARCH_SUFFIX "librsvg-2.0/librsvg")
endif()




# ************************************************************
# Create Search Name
# ************************************************************
set(RSVG_LIBRARY_NAMES "rsvg-${RSVG_VERSION}")
if(RSVG_PRIORITY_STATICAL)
    cm_message_verbose(STATUS "Prioritu search statical library.")
    cm_package_create_statical_names(RSVG_LIBRARY_NAMES)
endif()
cm_package_create_debug_names(RSVG_LIBRARY_NAMES)




# ************************************************************
# Clear
# ************************************************************
set(RSVG_COMMON_VARIABLES
    RSVG_LIBRARY_DEBUG
    RSVG_LIBRARY_RELEASE
    RSVG_PATH_INCLUDE
)
set(RSVG_CLEAR_IF_CHANGED
    RSVG_PREFIX_PATH
    RSVG_PRIORITY_STATICAL
)
foreach(VAR ${RSVG_CLEAR_IF_CHANGED})
    if(WIN32 AND NOT RSVG_PRIORITY_STATICAL)
        cm_package_clear_if_changed(${VAR}
            RSVG_BINARY_DEBUG
            RSVG_BINARY_RELEASE
            ${RSVG_COMMON_VARIABLES}
        )
    else()
        cm_package_clear_if_changed(${VAR}
            ${RSVG_COMMON_VARIABLES}
        )
        unset(RSVG_BINARY_DEBUG CACHE)
        unset(RSVG_BINARY_RELEASE CACHE)
    endif()
endforeach()




# ************************************************************
# Find Paths and Libraries
# ************************************************************
package_statical_priority(RSVG)
cm_package_find_path(RSVG_PATH_INCLUDE "rsvg.h" "${RSVG_SEARCH_PATH_INCLUDE}" "${RSVG_INCLUDE_SEARCH_SUFFIX}" )
cm_package_find_library(RSVG_LIBRARY_DEBUG "${RSVG_LIBRARY_NAMES_DEBUG}" "${RSVG_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(RSVG_LIBRARY_RELEASE "${RSVG_LIBRARY_NAMES}" "${RSVG_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
cm_package_make_library(RSVG_LIBRARY RSVG_LIBRARY_DEBUG RSVG_LIBRARY_RELEASE)




# ************************************************************
# Find Binaries (Windows)
# ************************************************************
if(WIN32 AND NOT RSVG_ENABLE_STATICAL)
	set(RSVG_BINARY_NAMES "librsvg")
    cm_package_create_debug_binary_names(RSVG_BINARY_NAMES)
	cm_package_create_release_binary_names(RSVG_BINARY_NAMES)
	cm_package_create_search_path_binary(RSVG)

	set(RSVG_SEARCH_BINARIES
		${RSVG_SEARCH_PATH_BINARY}
		${RSVG_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(RSVG_BINARY_DEBUG "${RSVG_BINARY_NAMES_DEBUG}" "${RSVG_SEARCH_BINARIES}" "debug")
	cm_package_find_file(RSVG_BINARY_RELEASE "${RSVG_BINARY_NAMES_RELEASE}" "${RSVG_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()




# ************************************************************
# Finalize Package
# ************************************************************
package_statical_default()
cm_package_validate(RSVG)
cm_package_include_options(RSVG)
cm_package_end(RSVG)
cm_message_footer(RSVG)
