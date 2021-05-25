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
# Website: https://www.freetype.org/


# ************************************************************
# Start package
cm_message_header(FREETYPE)
cm_package_begin(FREETYPE)
cm_package_create_home_path(FREETYPE FREETYPE_ROOT)




# ************************************************************
# Create Search Path
set(FREETYPE_PREFIX_PATH ${FREETYPE_HOME})
cm_package_create_search_path_include(FREETYPE)
cm_package_create_search_path_library(FREETYPE)




# ************************************************************
# Options
option(FREETYPE_ENABLE_STATICAL "Flag for using statical library." ON)




# ************************************************************
# Create Search Name
set(FREETYPE_LIBRARY_NAMES "freetype")
if(FREETYPE_ENABLE_STATICAL)
    cm_message_verbose(STATUS "Enable statical library.")
    cm_package_create_statical_names(FREETYPE_LIBRARY_NAMES)
endif()
cm_package_create_debug_names(FREETYPE_LIBRARY_NAMES)




# ************************************************************
# Clear
set(FREETYPE_COMMON_VARIABLES
    FREETYPE_LIBRARY_DEBUG
    FREETYPE_LIBRARY_RELEASE
    FREETYPE_PATH_INCLUDE
)
set(FREETYPE_CLEAR_IF_CHANGED
    FREETYPE_PREFIX_PATH
    FREETYPE_ENABLE_STATICAL
)
foreach(VAR ${FREETYPE_CLEAR_IF_CHANGED})
    if( WIN32 AND NOT FREETYPE_ENABLE_STATICAL )
        cm_package_clear_if_changed(${VAR}
            FREETYPE_BINARY_DEBUG
            FREETYPE_BINARY_RELEASE
            ${FREETYPE_COMMON_VARIABLES}
        )
    else()
        cm_package_clear_if_changed(${VAR}
            ${FREETYPE_COMMON_VARIABLES}
        )
        unset(FREETYPE_BINARY_DEBUG CACHE)
        unset(FREETYPE_BINARY_RELEASE CACHE)
    endif()
endforeach()




# ************************************************************
# Find Paths
cm_package_find_path(FREETYPE_PATH_INCLUDE "freetype.h" "${FREETYPE_SEARCH_PATH_INCLUDE}" "freetype")
cm_package_find_library(FREETYPE_LIBRARY_DEBUG "${FREETYPE_LIBRARY_NAMES_DEBUG}" "${FREETYPE_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(FREETYPE_LIBRARY_RELEASE "${FREETYPE_LIBRARY_NAMES}" "${FREETYPE_SEARCH_PATH_LIBRARY}" "release")
cm_package_make_library(FREETYPE_LIBRARY FREETYPE_LIBRARY_DEBUG FREETYPE_LIBRARY_RELEASE)




# ************************************************************
# Find Binaries on Windows
if(WIN32 AND NOT FREETYPE_ENABLE_STATICAL)
	set(FREETYPE_BINARY_NAMES "freetype")
    cm_package_create_debug_binary_names(FREETYPE_BINARY_NAMES)
	cm_package_create_release_binary_names(FREETYPE_BINARY_NAMES)
	cm_package_create_search_path_binary(FREETYPE)

	set(FREETYPE_SEARCH_BINARIES
		${FREETYPE_SEARCH_PATH_BINARY}
		${FREETYPE_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(FREETYPE_BINARY_DEBUG "${FREETYPE_BINARY_NAMES_DEBUG}" "${FREETYPE_SEARCH_BINARIES}" "debug")
	cm_package_find_file(FREETYPE_BINARY_RELEASE "${FREETYPE_BINARY_NAMES_RELEASE}" "${FREETYPE_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()




# ************************************************************
# Finalize Package
cm_package_validate(FREETYPE)
cm_package_include_options(FREETYPE)
cm_package_end(FREETYPE)
cm_message_footer(FREETYPE)
