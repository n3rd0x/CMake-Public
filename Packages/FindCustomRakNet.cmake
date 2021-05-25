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
cm_message_header(RAKNET)
cm_package_begin(RAKNET)
cm_package_create_home_path(RAKNET RAKNET_ROOT)


# ************************************************************
# Create Search Path
set(RAKNET_PREFIX_PATH ${RAKNET_HOME})
cm_package_create_search_path_include(RAKNET)
cm_package_create_search_path_library(RAKNET)


# ************************************************************
# Options
option( RAKNET_ENABLE_STATICAL "Flag for using statical library." OFF )


# ************************************************************
# Create Search Name
set(RAKNET_LIBRARY_NAMES "RakNet")
if(RAKNET_ENABLE_STATICAL)
    cm_message_verbose( STATUS "Enable statical library." )
    cm_package_create_statical_names( RAKNET_LIBRARY_NAMES )
else()
    set(RAKNET_LIBRARY_NAMES "${RAKNET_LIBRARY_NAMES};RakNetDLL")
endif()
cm_package_create_debug_names(RAKNET_LIBRARY_NAMES)


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
        cm_package_clear_if_changed(${VAR}
            RAKNET_BINARY_DEBUG
            RAKNET_BINARY_RELEASE
            ${RAKNET_COMMON_VARIABLES}
        )
    else()
        cm_package_clear_if_changed(${VAR}
            ${RAKNET_COMMON_VARIABLES}
        )
        unset(RAKNET_BINARY_DEBUG CACHE)
        unset(RAKNET_BINARY_RELEASE CACHE)
    endif()
endforeach()



# ************************************************************
# Find Paths
cm_package_find_path(RAKNET_PATH_INCLUDE "RakNetDefines.h" "${RAKNET_SEARCH_PATH_INCLUDE}" "RakNet" )
cm_package_find_library(RAKNET_LIBRARY_DEBUG "${RAKNET_LIBRARY_NAMES_DEBUG}" "${RAKNET_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(RAKNET_LIBRARY_RELEASE "${RAKNET_LIBRARY_NAMES}" "${RAKNET_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
cm_package_make_library(RAKNET_LIBRARY RAKNET_LIBRARY_DEBUG RAKNET_LIBRARY_RELEASE)


# ************************************************************
# Find Binaries on Windows
if(WIN32 AND NOT RAKNET_ENABLE_STATICAL)
    set( RAKNET_BINARY_NAMES "RakNetDLL" )
	cm_package_create_release_binary_names(RAKNET_BINARY_NAMES)
	cm_package_create_debug_binary_names(RAKNET_BINARY_NAMES)
	cm_package_create_search_path_binary(RAKNET)

	set(RAKNET_SEARCH_BINARIES
		${RAKNET_SEARCH_PATH_BINARY}
		${RAKNET_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(RAKNET_BINARY_DEBUG "${RAKNET_BINARY_NAMES_DEBUG}" "${RAKNET_SEARCH_BINARIES}" "debug")
	cm_package_find_file(RAKNET_BINARY_RELEASE "${RAKNET_BINARY_NAMES_RELEASE}" "${RAKNET_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()


# ************************************************************
# Finalize Package
cm_package_validate(RAKNET)
cm_package_include_options(RAKNET)
cm_package_end(RAKNET)
cm_message_footer(RAKNET)
