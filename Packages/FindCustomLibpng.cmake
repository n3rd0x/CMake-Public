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
# Website: http://libpng.org/pub/png/libpng.html


# ************************************************************
# Start package
cm_message_header(PNG)
cm_package_begin(PNG)
cm_package_create_home_path(PNG PNG_ROOT)




# ************************************************************
# Create Search Path
set(PNG_PREFIX_PATH ${PNG_HOME})
cm_package_create_search_path_include(PNG)
cm_package_create_search_path_library(PNG)




# ************************************************************
# Options
option(PNG_ENABLE_STATICAL "Flag for using statical library." OFF)




# ************************************************************
# Create Search Name
set(PNG_LIBRARY_NAMES "libpng")
if(PNG_ENABLE_STATICAL)
    cm_message_verbose(STATUS "Enable statical library.")
    cm_package_create_statical_names(PNG_LIBRARY_NAMES)
endif()
cm_package_create_debug_names(PNG_LIBRARY_NAMES)




# ************************************************************
# Clear
set(PNG_COMMON_VARIABLES
    PNG_LIBRARY_DEBUG
    PNG_LIBRARY_RELEASE
    PNG_PATH_INCLUDE
)
set(PNG_CLEAR_IF_CHANGED
    PNG_PREFIX_PATH
    PNG_ENABLE_STATICAL
)
foreach(VAR ${PNG_CLEAR_IF_CHANGED})
    if( WIN32 AND NOT PNG_ENABLE_STATICAL )
        cm_package_clear_if_changed(${VAR}
            PNG_BINARY_DEBUG
            PNG_BINARY_RELEASE
            ${PNG_COMMON_VARIABLES}
        )
    else()
        cm_package_clear_if_changed(${VAR}
            ${PNG_COMMON_VARIABLES}
        )
        unset(PNG_BINARY_DEBUG CACHE)
        unset(PNG_BINARY_RELEASE CACHE)
    endif()
endforeach()




# ************************************************************
# Find Paths
cm_package_find_path(PNG_PATH_INCLUDE "png.h" "${PNG_SEARCH_PATH_INCLUDE}" "" )
cm_package_find_library(PNG_LIBRARY_DEBUG "${PNG_LIBRARY_NAMES_DEBUG}" "${PNG_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(PNG_LIBRARY_RELEASE "${PNG_LIBRARY_NAMES}" "${PNG_SEARCH_PATH_LIBRARY}" "release")
cm_package_make_library(PNG_LIBRARY PNG_LIBRARY_DEBUG PNG_LIBRARY_RELEASE)




# ************************************************************
# Find Binaries on Windows
if(WIN32 AND NOT PNG_ENABLE_STATICAL)
	set(PNG_BINARY_NAMES "libpng")
    cm_package_create_debug_binary_names(PNG_BINARY_NAMES)
	cm_package_create_release_binary_names(PNG_BINARY_NAMES)
	cm_package_create_search_path_binary(PNG)

	set(PNG_SEARCH_BINARIES
		${PNG_SEARCH_PATH_BINARY}
		${PNG_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(PNG_BINARY_DEBUG "${PNG_BINARY_NAMES_DEBUG}" "${PNG_SEARCH_BINARIES}" "debug")
	cm_package_find_file(PNG_BINARY_RELEASE "${PNG_BINARY_NAMES_RELEASE}" "${PNG_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()




# ************************************************************
# Finalize Package
cm_package_validate(PNG)
cm_package_include_options(PNG)
cm_package_end(PNG)
cm_message_footer(PNG)
