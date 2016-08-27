# ************************************************************
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the “Software”),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ************************************************************
# Webiste: http://glew.sourceforge.net


# ************************************************************
# Start package
message_header(GLEW)
package_begin(GLEW)
package_create_home_path(GLEW GLEW_ROOT)




# ************************************************************
# x64-bit system
# Check whether we are going to compile for x64-bit systems.
string(REGEX MATCH "Win64" x64_FOUND ${CMAKE_GENERATOR})
# Set path suffix for x64.
if(x64_FOUND )
    set(PATH_SUFFIX "x64")
else()
    set(PATH_SUFFIX "x86")
endif()
unset(x64_FOUND)




# ************************************************************
# Create search path
set(GLEW_PREFIX_PATH ${GLEW_HOME})
package_create_search_path_include(GLEW)
package_create_search_path_library(GLEW)


# ************************************************************
# Options
option(GLEW_ENABLE_MX "Flag for using the MX (Multiple Rendering Contexts)." OFF)
option(GLEW_ENABLE_STATICAL "Flag for using static library." OFF)


# ************************************************************
# Create search name
if(GLEW_ENABLE_MX)
    if(GLEW_ENABLE_STATICAL)
        set(GLEW_LIBRARY_NAMES "glew32mx" "glewmx")
    else()
        set(GLEW_LIBRARY_NAMES "glew32mxs" "glewmxs")
    endif()
else()
    if(GLEW_ENABLE_STATICAL)
        set(GLEW_LIBRARY_NAMES "glew32s" "glews")
    else()
        set(GLEW_LIBRARY_NAMES "glew32" "glew")
    endif()
endif()
package_create_debug_names(GLEW_LIBRARY_NAMES)


# ************************************************************
# Clear
set(GLEW_CLEAR_IF_CHANGED 
    GLEW_ENABLE_MX
    GLEW_ENABLE_STATICAL
    GLEW_PREFIX_PATH
)
foreach(VAR ${GLEW_CLEAR_IF_CHANGED})
    if(WIN32)
        package_clear_if_changed(${VAR}
            GLEW_LIBRARY_DEBUG
            GLEW_LIBRARY_RELEASE
            GLEW_PATH_INCLUDE
            GLEW_BINARY_RELEASE
            GLEW_BINARY_DEBUG
        )
    else()
        package_clear_if_changed(${VAR}
            GLEW_LIBRARY_DEBUG
            GLEW_LIBRARY_RELEASE
            GLEW_PATH_INCLUDE
        )
    endif()
endforeach()
unset(VAR)




# ************************************************************
# Find paths
package_find_path(GLEW_PATH_INCLUDE "glew.h" "${GLEW_SEARCH_PATH_INCLUDE}" "GL")
package_find_library(GLEW_LIBRARY_DEBUG "${GLEW_LIBRARY_NAMES_DEBUG}" "${GLEW_SEARCH_PATH_LIBRARY}" "${PATH_SUFFIX}")
package_find_library(GLEW_LIBRARY_RELEASE "${GLEW_LIBRARY_NAMES}" "${GLEW_SEARCH_PATH_LIBRARY}" "${PATH_SUFFIX}")
package_make_library(GLEW_LIBRARY GLEW_LIBRARY_DEBUG GLEW_LIBRARY_RELEASE)




# ************************************************************
# Find binaries on Windows
if(WIN32 AND NOT GLEW_ENABLE_STATICAL)
    if(GLEW_ENABLE_MX )
        set(GLEW_BINARY_NAMES "glew32mx")
    else()
        set(GLEW_BINARY_NAMES "glew32")
    endif()
    
    package_create_debug_binary_names(GLEW_BINARY_NAMES)
	package_create_release_binary_names(GLEW_BINARY_NAMES)
	package_create_search_path_binary(GLEW)
	
	set(GLEW_SEARCH_BINARIES 
		${GLEW_SEARCH_PATH_BINARY}
		${GLEW_SEARCH_PATH_LIBRARY}
	)
	
	package_find_file(GLEW_BINARY_DEBUG "${GLEW_BINARY_NAMES_DEBUG}" "${GLEW_SEARCH_BINARIES}" "${PATH_SUFFIX}")
	package_find_file(GLEW_BINARY_RELEASE "${GLEW_BINARY_NAMES_RELEASE}" "${GLEW_SEARCH_BINARIES}" "${PATH_SUFFIX}")
endif()


# ************************************************************
# Finalize package
package_validate(GLEW)
package_add_parent_dir(GLEW ADD_PARENT)
package_end(GLEW)
message_footer(GLEW)

