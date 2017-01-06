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
message_header(PNG)
package_begin(PNG)
package_create_home_path(PNG PNG_ROOT)




# ************************************************************
# Create search path
set(PNG_PREFIX_PATH ${PNG_HOME})
package_create_search_path_include(PNG)
package_create_search_path_library(PNG)




# ************************************************************
# Options
option(PNG_ENABLE_STATICAL "Flag for using statical library." OFF)




# ************************************************************
# Create search name
set(PNG_LIBRARY_NAMES "libpng")
if(PNG_ENABLE_STATICAL)
    message_verbose(STATUS "Enable statical library.")
    package_create_statical_names(PNG_LIBRARY_NAMES)
endif()
package_create_debug_names(PNG_LIBRARY_NAMES)




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
        package_clear_if_changed(${VAR}
            PNG_BINARY_DEBUG
            PNG_BINARY_RELEASE
            ${PNG_COMMON_VARIABLES}
        )
    else()
        package_clear_if_changed(${VAR}
            ${PNG_COMMON_VARIABLES}
        )
        unset(PNG_BINARY_DEBUG CACHE)
        unset(PNG_BINARY_RELEASE CACHE)
    endif()
endforeach()




# ************************************************************
# Find paths
package_find_path(PNG_PATH_INCLUDE "png.h" "${PNG_SEARCH_PATH_INCLUDE}" "" )
package_find_library(PNG_LIBRARY_DEBUG "${PNG_LIBRARY_NAMES_DEBUG}" "${PNG_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(PNG_LIBRARY_RELEASE "${PNG_LIBRARY_NAMES}" "${PNG_SEARCH_PATH_LIBRARY}" "release")
package_make_library(PNG_LIBRARY PNG_LIBRARY_DEBUG PNG_LIBRARY_RELEASE)




# ************************************************************
# Find binaries on Windows
if(WIN32 AND NOT PNG_ENABLE_STATICAL)
	set(PNG_BINARY_NAMES "libpng")
    package_create_debug_binary_names(PNG_BINARY_NAMES)
	package_create_release_binary_names(PNG_BINARY_NAMES)
	package_create_search_path_binary(PNG)
	
	set(PNG_SEARCH_BINARIES 
		${PNG_SEARCH_PATH_BINARY}
		${PNG_SEARCH_PATH_LIBRARY}
	)
	
	package_find_file(PNG_BINARY_DEBUG "${PNG_BINARY_NAMES_DEBUG}" "${PNG_SEARCH_BINARIES}" "debug")
	package_find_file(PNG_BINARY_RELEASE "${PNG_BINARY_NAMES_RELEASE}" "${PNG_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()




# ************************************************************
# Finalize package
package_validate(PNG)
package_add_parent_dir(PNG)
package_end(PNG)
message_footer(PNG)
