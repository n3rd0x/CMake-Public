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
# Website: https://github.com/R4stl1n/cAudio


# ************************************************************
# Start Package
# ************************************************************
cm_message_header(CAUDIO)
cm_package_begin(CAUDIO)
cm_package_create_home_path(CAUDIO CAUDIO_ROOT)




# ************************************************************
# Create Search Paths
# ************************************************************
set(CAUDIO_PREFIX_PATH ${CAUDIO_HOME})
cm_package_create_search_path_include(CAUDIO)
cm_package_create_search_path_library(CAUDIO)




# ************************************************************
# Create Search Name
# ************************************************************
set(CAUDIO_LIBRARY_NAMES "cAudio")
cm_package_create_debug_names(CAUDIO_LIBRARY_NAMES)




# ************************************************************
# Clear
# ************************************************************
set(CAUDIO_COMMON_VARIABLES
    CAUDIO_LIBRARY_DEBUG
    CAUDIO_LIBRARY_RELEASE
    CAUDIO_PATH_INCLUDE
)
set(CAUDIO_CLEAR_IF_CHANGED
    CAUDIO_PREFIX_PATH
)
foreach(VAR ${CAUDIO_CLEAR_IF_CHANGED})
    if(WIN32)
        cm_package_clear_if_changed(${VAR}
            CAUDIO_BINARY_DEBUG
            CAUDIO_BINARY_RELEASE
            ${CAUDIO_COMMON_VARIABLES}
        )
    else()
        cm_package_clear_if_changed(${VAR}
            ${CAUDIO_COMMON_VARIABLES}
        )
        unset(CAUDIO_BINARY_DEBUG CACHE)
        unset(CAUDIO_BINARY_RELEASE CACHE)
    endif()
endforeach()




# ************************************************************
# Find Paths and Libraries
# ************************************************************
package_statical_priority(CAUDIO)
cm_package_find_path(CAUDIO_PATH_INCLUDE "cAudio/cAudio.h" "${CAUDIO_SEARCH_PATH_INCLUDE}" "${CAUDIO_INCLUDE_SEARCH_SUFFIX}" )
cm_package_find_library(CAUDIO_LIBRARY_DEBUG "${CAUDIO_LIBRARY_NAMES_DEBUG}" "${CAUDIO_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(CAUDIO_LIBRARY_RELEASE "${CAUDIO_LIBRARY_NAMES}" "${CAUDIO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
cm_package_make_library(CAUDIO_LIBRARY CAUDIO_LIBRARY_DEBUG CAUDIO_LIBRARY_RELEASE)




# ************************************************************
# Find Binaries (Windows)
# ************************************************************
if(WIN32 AND NOT CAUDIO_ENABLE_STATICAL)
	set(CAUDIO_BINARY_NAMES "libCAUDIO")
    cm_package_create_debug_binary_names(CAUDIO_BINARY_NAMES)
	cm_package_create_release_binary_names(CAUDIO_BINARY_NAMES)
	cm_package_create_search_path_binary(CAUDIO)

	set(CAUDIO_SEARCH_BINARIES
		${CAUDIO_SEARCH_PATH_BINARY}
		${CAUDIO_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(CAUDIO_BINARY_DEBUG "${CAUDIO_BINARY_NAMES_DEBUG}" "${CAUDIO_SEARCH_BINARIES}" "debug")
	cm_package_find_file(CAUDIO_BINARY_RELEASE "${CAUDIO_BINARY_NAMES_RELEASE}" "${CAUDIO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()




# ************************************************************
# Finalize Package
# ************************************************************
cm_package_validate(CAUDIO)
cm_package_include_options(CAUDIO)
cm_package_end(CAUDIO)
cm_message_footer(CAUDIO)
