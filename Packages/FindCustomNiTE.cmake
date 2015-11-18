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


# ************************************************************
# Start package
message_header( NiTE )
package_begin( NiTE )
package_create_home_path( NiTE NiTE_ROOT )




# ************************************************************
# Create search path
set( NiTE_PREFIX_PATH ${NiTE_HOME} )
package_create_search_path_binary( NiTE )
package_create_search_path_include( NiTE )
package_create_search_path_library( NiTE )




# ************************************************************
# Create search name
# Set default version 2.
if( NOT DEFINED NiTE_VERSION OR NiTE_VERSION STREQUAL "")
    set( NiTE_VERSION "2" CACHE STRING "Set NiTE version." )
endif()
set( NiTE_LIBRARY_NAMES "NiTE${NiTE_VERSION}" )
package_create_debug_names( NiTE_LIBRARY_NAMES )




# ************************************************************
# Clear
set( NiTE_CLEAR_TRIGGER 
    NiTE_HOME
    NiTE_VERSION
)
set( NiTE_CLEAR_COMPONENTS
    NiTE_LIBRARY_DEBUG
    NiTE_LIBRARY_RELEASE
    NiTE_PATH_INCLUDE
)
if( WIN32 )
    set( NiTE_CLEAR_COMPONENTS 
        ${NiTE_CLEAR_COMPONENTS}
        NiTE_PATH_REDIST
    )
endif()

foreach( VAR ${NiTE_CLEAR_TRIGGER} )
    package_clear_if_changed( ${VAR}
        ${NiTE_CLEAR_COMPONENTS}
    )
endforeach()




# ************************************************************
# Find paths
package_find_path( NiTE_PATH_INCLUDE "NiTE.h" "${NiTE_SEARCH_PATH_INCLUDE}" "" )
package_find_library( NiTE_LIBRARY_DEBUG "${NiTE_LIBRARY_NAMES_DEBUG}" "${NiTE_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( NiTE_LIBRARY_RELEASE "${NiTE_LIBRARY_NAMES}" "${NiTE_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )
package_make_library( NiTE_LIBRARY NiTE_LIBRARY_DEBUG NiTE_LIBRARY_RELEASE )




# ************************************************************
# Redistribution
if( WIN32 )
    # 2014-06-14 TST
    # We will handle this partially manually.
    package_find_path( NiTE_PATH_REDIST "NiTE${NiTE_VERSION}.dll" "${NiTE_SEARCH_PATH_BINARY}" "" )
    if( NiTE_PATH_REDIST )
        # Main redistribution.
        set( NiTE_MAIN_REDIST
            "${NiTE_PATH_REDIST}/NiTE.ini"
            "${NiTE_PATH_REDIST}/NiTE${NiTE_VERSION}.dll"
        )
        
        # Set binary flags.
        set( NiTE_BINARY_DEBUG ${NiTE_MAIN_REDIST} )
        set( NiTE_BINARY_RELEASE ${NiTE_MAIN_REDIST} )
        
        # Add rules.
        package_copy_binary_from_target( NiTE )
    endif()
endif()




# ************************************************************
# Finalize package
package_validate( NiTE )
package_end( NiTE )
message_footer( NiTE )
