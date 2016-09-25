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
# Website: https://github.com/leethomason/tinyxml2


# ************************************************************
# Start package
message_header( TINYXML2 )
package_begin( TINYXML2 )
package_create_home_path( TINYXML2 TINYXML2_ROOT )


# ************************************************************
# Options
option( TINYXML2_USE_STATIC "Flag to use static library." OFF )


# ************************************************************
# Create search path
set( TINYXML2_PREFIX_PATH ${TINYXML2_HOME} )
package_create_search_path_include( TINYXML2 )
package_create_search_path_library( TINYXML2 )
package_create_search_path_plugin( TINYXML2 )
package_create_search_path_binary( TINYXML2 )


# ************************************************************
# Create search name
set( TINYXML2_LIBRARY_SHARED_NAMES "tinyxml2" )
package_create_debug_names( TINYXML2_LIBRARY_SHARED_NAMES )

set( TINYXML2_LIBRARY_STATIC_NAMES "${TINYXML2_LIBRARY_SHARED_NAMES}" )
package_create_statical_names( TINYXML2_LIBRARY_STATIC_NAMES )
package_create_debug_names( TINYXML2_LIBRARY_STATIC_NAMES )


# ************************************************************
# Clear
package_clear_if_changed( TINYXML2_PREFIX_PATH
    TINYXML2_BINARY_DEBUG
    TINYXML2_BINARY_RELEASE
    TINYXML2_LIBRARY_DEBUG
    TINYXML2_LIBRARY_RELEASE
    TINYXML2_LIBRARY_DEBUG_SHARED
    TINYXML2_LIBRARY_RELEASE_SHARED
    TINYXML2_LIBRARY_DEBUG_STATIC
    TINYXML2_LIBRARY_RELEASE_STATIC
    TINYXML2_PATH_INCLUDE
)


# ************************************************************
# Find paths
package_find_path( TINYXML2_PATH_INCLUDE "tinyxml2.h" "${TINYXML2_SEARCH_PATH_INCLUDE}" "tinyxml2" )

# Shared libraries.
package_find_library(
    TINYXML2_LIBRARY_DEBUG_SHARED
    "${TINYXML2_LIBRARY_SHARED_NAMES_DEBUG}"
    "${TINYXML2_SEARCH_PATH_LIBRARY}"
    "debug"
)
package_find_library(
    TINYXML2_LIBRARY_RELEASE_SHARED
    "${TINYXML2_LIBRARY_SHARED_NAMES}"
    "${TINYXML2_SEARCH_PATH_LIBRARY}"
    "release;relwithdebinfo;minsizerel"
)
package_make_library( TINYXML2_LIBRARY_SHARED TINYXML2_LIBRARY_DEBUG_SHARED TINYXML2_LIBRARY_RELEASE_SHARED )

# Static libraries.
package_find_library(
    TINYXML2_LIBRARY_DEBUG_STATIC
    "${TINYXML2_LIBRARY_STATIC_NAMES_DEBUG}"
    "${TINYXML2_SEARCH_PATH_LIBRARY}"
    "debug"
)
package_find_library(
    TINYXML2_LIBRARY_RELEASE_STATIC
    "${TINYXML2_LIBRARY_STATIC_NAMES}"
    "${TINYXML2_SEARCH_PATH_LIBRARY}"
    "release;relwithdebinfo;minsizerel"
)
package_make_library( TINYXML2_LIBRARY_STATIC TINYXML2_LIBRARY_DEBUG_STATIC TINYXML2_LIBRARY_RELEASE_STATIC )

# Make set.
if( TINYXML2_LIBRARY_SHARED AND TINYXML2_LIBRARY_STATIC )
    message_debug( STATUS "SHARED and STATIC found." )
    if( TINYXML2_USE_STATIC )
        set( TINYXML2_LIBRARY "${TINYXML2_LIBRARY_STATIC}" )
        message_status( STATUS "Use STATIC library of TinyXml2." )
    else()
        set( TINYXML2_LIBRARY "${TINYXML2_LIBRARY_SHARED}" )
        message_status( STATUS "Use SHARED library of TinyXml2." )
    endif()
elseif( TINYXML2_LIBRARY_SHARED )
    set( TINYXML2_LIBRARY "${TINYXML2_LIBRARY_SHARED}" )
    message_status( STATUS "Use SHARED library of TinyXml2." )
elseif( TINYXML2_LIBRARY_STATIC )
    set( TINYXML2_LIBRARY "${TINYXML2_LIBRARY_STATIC}" )
    message_status( STATUS "Use STATIC library of TinyXml2." )
endif()


# ************************************************************
# Find binaries
if( WIN32 )
    if( TINYXML2_LIBRARY_SHARED )
        set( TINYXML2_BINARY_NAMES "tinyxml2" )
        package_create_release_binary_names( TINYXML2_BINARY_NAMES )
        package_create_debug_binary_names( TINYXML2_BINARY_NAMES )
        
        set( TINYXML2_SEARCH_BINARIES 
            ${TINYXML2_SEARCH_PATH_BINARY}
            ${TINYXML2_SEARCH_PATH_LIBRARY}
        )
    
        package_find_file(
            TINYXML2_BINARY_DEBUG
            "${TINYXML2_BINARY_NAMES_DEBUG}"
            "${TINYXML2_SEARCH_BINARIES}"
            "debug"
        )
        package_find_file(
            TINYXML2_BINARY_RELEASE
            "${TINYXML2_BINARY_NAMES_RELEASE}"
            "${TINYXML2_SEARCH_BINARIES}"
            "release;relwithdebinfo;minsizerel"
        )
    
        package_copy_binary_from_target( TINYXML2 )
    endif()
endif()



# ************************************************************
# Finalize package
package_validate( TINYXML2 )
package_add_parent_dir( TINYXML2 )
package_end( TINYXML2 )
message_footer( TINYXML2 )
