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
# Website: http://zlib.net


# ************************************************************
# Start package
cm_message_header(ZLIB)
cm_package_begin(ZLIB)
cm_package_create_home_path(ZLIB ZLIB_ROOT)




# ************************************************************
# Create Search Path
set(ZLIB_PREFIX_PATH ${ZLIB_HOME})
cm_package_create_search_path_include(ZLIB)
cm_package_create_search_path_library(ZLIB)




# ************************************************************
# Options
option(ZLIB_ENABLE_STATICAL "Flag for using statical library." ON)




# ************************************************************
# Create Search Name
set(ZLIB_LIBRARY_NAMES "zlib")
if(ZLIB_ENABLE_STATICAL)
    cm_message_verbose(STATUS "Enable statical library.")
    cm_package_create_statical_names(ZLIB_LIBRARY_NAMES)
endif()
cm_package_create_debug_names(ZLIB_LIBRARY_NAMES)




# ************************************************************
# Clear
set(ZLIB_COMMON_VARIABLES
    ZLIB_LIBRARY_DEBUG
    ZLIB_LIBRARY_RELEASE
    ZLIB_PATH_INCLUDE
)
set(ZLIB_CLEAR_IF_CHANGED
    ZLIB_PREFIX_PATH
    ZLIB_ENABLE_STATICAL
)
foreach(VAR ${ZLIB_CLEAR_IF_CHANGED})
    if( WIN32 AND NOT ZLIB_ENABLE_STATICAL )
        cm_package_clear_if_changed(${VAR}
            ZLIB_BINARY_DEBUG
            ZLIB_BINARY_RELEASE
            ${ZLIB_COMMON_VARIABLES}
        )
    else()
        cm_package_clear_if_changed(${VAR}
            ${ZLIB_COMMON_VARIABLES}
        )
        unset(ZLIB_BINARY_DEBUG CACHE)
        unset(ZLIB_BINARY_RELEASE CACHE)
    endif()
endforeach()




# ************************************************************
# Find Paths
cm_package_find_path(ZLIB_PATH_INCLUDE "zlib.h" "${ZLIB_SEARCH_PATH_INCLUDE}" "" )
cm_package_find_library(ZLIB_LIBRARY_DEBUG "${ZLIB_LIBRARY_NAMES_DEBUG}" "${ZLIB_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(ZLIB_LIBRARY_RELEASE "${ZLIB_LIBRARY_NAMES}" "${ZLIB_SEARCH_PATH_LIBRARY}" "release")
cm_package_make_library(ZLIB_LIBRARY ZLIB_LIBRARY_DEBUG ZLIB_LIBRARY_RELEASE)




# ************************************************************
# Find Binaries on Windows
if(WIN32 AND NOT ZLIB_ENABLE_STATICAL)
	set(ZLIB_BINARY_NAMES "zlib")
    cm_package_create_debug_binary_names(ZLIB_BINARY_NAMES)
	cm_package_create_release_binary_names(ZLIB_BINARY_NAMES)
	cm_package_create_search_path_binary(ZLIB)

	set(ZLIB_SEARCH_BINARIES
		${ZLIB_SEARCH_PATH_BINARY}
		${ZLIB_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(ZLIB_BINARY_DEBUG "${ZLIB_BINARY_NAMES_DEBUG}" "${ZLIB_SEARCH_BINARIES}" "debug")
	cm_package_find_file(ZLIB_BINARY_RELEASE "${ZLIB_BINARY_NAMES_RELEASE}" "${ZLIB_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()




# ************************************************************
# Finalize Package
cm_package_validate(ZLIB)
cm_package_include_options(ZLIB)
cm_package_end(ZLIB)
cm_message_footer(ZLIB)
