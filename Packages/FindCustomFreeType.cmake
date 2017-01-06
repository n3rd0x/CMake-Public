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
message_header(FREETYPE)
package_begin(FREETYPE)
package_create_home_path(FREETYPE FREETYPE_ROOT)




# ************************************************************
# Create search path
set(FREETYPE_PREFIX_PATH ${FREETYPE_HOME})
package_create_search_path_include(FREETYPE)
package_create_search_path_library(FREETYPE)




# ************************************************************
# Options
option(FREETYPE_ENABLE_STATICAL "Flag for using statical library." ON)




# ************************************************************
# Create search name
set(FREETYPE_LIBRARY_NAMES "freetype")
if(FREETYPE_ENABLE_STATICAL)
    message_verbose(STATUS "Enable statical library.")
    package_create_statical_names(FREETYPE_LIBRARY_NAMES)
endif()
package_create_debug_names(FREETYPE_LIBRARY_NAMES)




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
        package_clear_if_changed(${VAR}
            FREETYPE_BINARY_DEBUG
            FREETYPE_BINARY_RELEASE
            ${FREETYPE_COMMON_VARIABLES}
        )
    else()
        package_clear_if_changed(${VAR}
            ${FREETYPE_COMMON_VARIABLES}
        )
        unset(FREETYPE_BINARY_DEBUG CACHE)
        unset(FREETYPE_BINARY_RELEASE CACHE)
    endif()
endforeach()




# ************************************************************
# Find paths
package_find_path(FREETYPE_PATH_INCLUDE "freetype.h" "${FREETYPE_SEARCH_PATH_INCLUDE}" "freetype")
package_find_library(FREETYPE_LIBRARY_DEBUG "${FREETYPE_LIBRARY_NAMES_DEBUG}" "${FREETYPE_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(FREETYPE_LIBRARY_RELEASE "${FREETYPE_LIBRARY_NAMES}" "${FREETYPE_SEARCH_PATH_LIBRARY}" "release")
package_make_library(FREETYPE_LIBRARY FREETYPE_LIBRARY_DEBUG FREETYPE_LIBRARY_RELEASE)




# ************************************************************
# Find binaries on Windows
if(WIN32 AND NOT FREETYPE_ENABLE_STATICAL)
	set(FREETYPE_BINARY_NAMES "freetype")
    package_create_debug_binary_names(FREETYPE_BINARY_NAMES)
	package_create_release_binary_names(FREETYPE_BINARY_NAMES)
	package_create_search_path_binary(FREETYPE)
	
	set(FREETYPE_SEARCH_BINARIES 
		${FREETYPE_SEARCH_PATH_BINARY}
		${FREETYPE_SEARCH_PATH_LIBRARY}
	)
	
	package_find_file(FREETYPE_BINARY_DEBUG "${FREETYPE_BINARY_NAMES_DEBUG}" "${FREETYPE_SEARCH_BINARIES}" "debug")
	package_find_file(FREETYPE_BINARY_RELEASE "${FREETYPE_BINARY_NAMES_RELEASE}" "${FREETYPE_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()




# ************************************************************
# Finalize package
package_validate(FREETYPE)
package_add_parent_dir(FREETYPE ADD_PARENT)
package_end(FREETYPE)
message_footer(FREETYPE)
