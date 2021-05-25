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
# Website: https://github.com/stachenov/quazip


# ************************************************************
# Start package
cm_message_header(QUAZIP)
cm_package_begin(QUAZIP)
cm_package_create_home_path(QUAZIP QUAZIP_ROOT)


# ************************************************************
# Create Search Path
set(QUAZIP_PREFIX_PATH ${QUAZIP_HOME})
cm_package_create_search_path_include(QUAZIP)
cm_package_create_search_path_library(QUAZIP)


# ************************************************************
# Options
#option(QUAZIP_ENABLE_STATICAL "Flag for using statical library." OFF)
set(QUAZIP_VERSION "5" CACHE STRING "Select the version to search.")


# ************************************************************
# Create Search Name
set(QUAZIP_LIBRARY_NAMES "quazip${QUAZIP_VERSION}")
#if(QUAZIP_ENABLE_STATICAL)
#    cm_message_verbose(STATUS "Enable statical library.")
#    cm_package_create_statical_names(QUAZIP_LIBRARY_NAMES)
#endif()
cm_package_create_debug_names(QUAZIP_LIBRARY_NAMES)


# ************************************************************
# Clear
set(QUAZIP_COMMON_VARIABLES
    QUAZIP_LIBRARY_DEBUG
    QUAZIP_LIBRARY_RELEASE
    QUAZIP_PATH_INCLUDE
)
set(QUAZIP_CLEAR_IF_CHANGED
    QUAZIP_PREFIX_PATH
    QUAZIP_VERSION
    #QUAZIP_ENABLE_STATICAL
)
foreach(VAR ${QUAZIP_CLEAR_IF_CHANGED})
    if(WIN32 AND NOT QUAZIP_ENABLE_STATICAL)
        cm_package_clear_if_changed(${VAR}
            QUAZIP_BINARY_DEBUG
            QUAZIP_BINARY_RELEASE
            ${QUAZIP_COMMON_VARIABLES}
       )
    else()
        cm_package_clear_if_changed(${VAR}
            ${QUAZIP_COMMON_VARIABLES}
       )
        unset(QUAZIP_BINARY_DEBUG CACHE)
        unset(QUAZIP_BINARY_RELEASE CACHE)
    endif()
endforeach()


# ************************************************************
# Find Paths
cm_package_find_path(QUAZIP_PATH_INCLUDE "quazip.h" "${QUAZIP_SEARCH_PATH_INCLUDE}" "quazip;quazip${QUAZIP_VERSION}")
cm_package_find_library(QUAZIP_LIBRARY_DEBUG "${QUAZIP_LIBRARY_NAMES_DEBUG}" "${QUAZIP_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library(QUAZIP_LIBRARY_RELEASE "${QUAZIP_LIBRARY_NAMES}" "${QUAZIP_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel" )
cm_package_make_library(QUAZIP_LIBRARY QUAZIP_LIBRARY_DEBUG QUAZIP_LIBRARY_RELEASE)


# ************************************************************
# Find Binaries on Windows
if(WIN32 AND NOT QUAZIP_ENABLE_STATICAL)
	set(QUAZIP_BINARY_NAMES "quazip")
    cm_package_create_debug_binary_names(QUAZIP_BINARY_NAMES)
	cm_package_create_release_binary_names(QUAZIP_BINARY_NAMES)
	cm_package_create_search_path_binary(QUAZIP)

	set(QUAZIP_SEARCH_BINARIES
		${QUAZIP_SEARCH_PATH_BINARY}
		${QUAZIP_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(QUAZIP_BINARY_DEBUG "${QUAZIP_BINARY_NAMES_DEBUG}" "${QUAZIP_SEARCH_BINARIES}" "debug")
	cm_package_find_file(QUAZIP_BINARY_RELEASE "${QUAZIP_BINARY_NAMES_RELEASE}" "${QUAZIP_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()


# ************************************************************
# Finalize Package
cm_package_validate(QUAZIP)
cm_package_include_options(QUAZIP)
cm_package_end(QUAZIP)
cm_message_footer(QUAZIP)
