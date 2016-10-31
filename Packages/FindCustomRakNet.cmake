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
# Website: https://github.com/OculusVR/RakNet


# ************************************************************
# Start package
message_header(RAKNET)
package_begin(RAKNET)
package_create_home_path(RAKNET RAKNET_ROOT)


# ************************************************************
# Create search path
set(RAKNET_PREFIX_PATH ${RAKNET_HOME})
package_create_search_path_include(RAKNET)
package_create_search_path_library(RAKNET)


# ************************************************************
# Options
option( RAKNET_ENABLE_STATICAL "Flag for using statical library." OFF )


# ************************************************************
# Create search name
set(RAKNET_LIBRARY_NAMES "RakNet")
if(RAKNET_ENABLE_STATICAL)
    message_verbose( STATUS "Enable statical library." )
    package_create_statical_names( RAKNET_LIBRARY_NAMES )
else()
    set(RAKNET_LIBRARY_NAMES "${RAKNET_LIBRARY_NAMES};RakNetDLL")
endif()
package_create_debug_names(RAKNET_LIBRARY_NAMES)


# ************************************************************
# Clear
set(RAKNET_COMMON_VARIABLES
    RAKNET_LIBRARY_DEBUG
    RAKNET_LIBRARY_RELEASE
    RAKNET_PATH_INCLUDE
)
set(RAKNET_CLEAR_IF_CHANGED 
    RAKNET_PREFIX_PATH
    RAKNET_ENABLE_STATICAL
)
foreach(VAR ${RAKNET_CLEAR_IF_CHANGED})
    if(WIN32 AND NOT RAKNET_ENABLE_STATICAL)
        package_clear_if_changed(${VAR}
            RAKNET_BINARY_DEBUG
            RAKNET_BINARY_RELEASE
            ${RAKNET_COMMON_VARIABLES}
        )
    else()
        package_clear_if_changed(${VAR}
            ${RAKNET_COMMON_VARIABLES}
        )
        unset(RAKNET_BINARY_DEBUG CACHE)
        unset(RAKNET_BINARY_RELEASE CACHE)
    endif()
endforeach()

	

# ************************************************************
# Find paths
package_find_path(RAKNET_PATH_INCLUDE "RakNetDefines.h" "${RAKNET_SEARCH_PATH_INCLUDE}" "RakNet" )
package_find_library(RAKNET_LIBRARY_DEBUG "${RAKNET_LIBRARY_NAMES_DEBUG}" "${RAKNET_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(RAKNET_LIBRARY_RELEASE "${RAKNET_LIBRARY_NAMES}" "${RAKNET_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
package_make_library(RAKNET_LIBRARY RAKNET_LIBRARY_DEBUG RAKNET_LIBRARY_RELEASE)


# ************************************************************
# Find binaries on Windows
if(WIN32 AND NOT RAKNET_ENABLE_STATICAL)
    set( RAKNET_BINARY_NAMES "RakNetDLL" )
	package_create_release_binary_names(RAKNET_BINARY_NAMES)
	package_create_debug_binary_names(RAKNET_BINARY_NAMES)
	package_create_search_path_binary(RAKNET)
	
	set(RAKNET_SEARCH_BINARIES 
		${RAKNET_SEARCH_PATH_BINARY}
		${RAKNET_SEARCH_PATH_LIBRARY}
	)

	package_find_file(RAKNET_BINARY_DEBUG "${RAKNET_BINARY_NAMES_DEBUG}" "${RAKNET_SEARCH_BINARIES}" "debug")
	package_find_file(RAKNET_BINARY_RELEASE "${RAKNET_BINARY_NAMES_RELEASE}" "${RAKNET_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()


# ************************************************************
# Finalize package
package_validate(RAKNET)
package_add_parent_dir(RAKNET ADD_PARENT)
package_end(RAKNET)
message_footer(RAKNET)
