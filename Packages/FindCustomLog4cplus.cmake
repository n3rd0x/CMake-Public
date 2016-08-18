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
# Website: http://sourceforge.net/projects/log4cplus


# ************************************************************
# Start package
message_header( LOG4CPLUS )
package_begin( LOG4CPLUS )
package_create_home_path( LOG4CPLUS LOG4CPLUS_ROOT )


# ************************************************************
# Create search path
set( LOG4CPLUS_PREFIX_PATH ${LOG4CPLUS_HOME} )
package_create_search_path_include( LOG4CPLUS )
package_create_search_path_library( LOG4CPLUS )


# ************************************************************
# Options
option( LOG4CPLUS_ENABLE_STATICAL "Flag for using statical library." OFF )


# ************************************************************
# Create search name
set( LOG4CPLUS_LIBRARY_NAMES "log4cplus" )
if( LOG4CPLUS_ENABLE_STATICAL )
    message_verbose( STATUS "Enable statical library." )
    package_create_statical_names( LOG4CPLUS_LIBRARY_NAMES )
endif()
package_create_debug_names( LOG4CPLUS_LIBRARY_NAMES )


# ************************************************************
# Clear
set( LOG4CPLUS_COMMON_VARIABLES
    LOG4CPLUS_LIBRARY_DEBUG
    LOG4CPLUS_LIBRARY_RELEASE
    LOG4CPLUS_PATH_INCLUDE
)
set( LOG4CPLUS_CLEAR_IF_CHANGED 
    LOG4CPLUS_PREFIX_PATH
    LOG4CPLUS_ENABLE_STATICAL
)
foreach( VAR ${LOG4CPLUS_CLEAR_IF_CHANGED} )
    if( WIN32 AND NOT LOG4CPLUS_ENABLE_STATICAL )
        package_clear_if_changed( ${VAR}
            LOG4CPLUS_BINARY_DEBUG
            LOG4CPLUS_BINARY_RELEASE
            ${LOG4CPLUS_COMMON_VARIABLES}
        )
    else()
        package_clear_if_changed( ${VAR}
            ${LOG4CPLUS_COMMON_VARIABLES}
        )
        unset( LOG4CPLUS_BINARY_DEBUG CACHE )
        unset( LOG4CPLUS_BINARY_RELEASE CACHE )
    endif()
endforeach()


# ************************************************************
# Find paths
package_find_path( LOG4CPLUS_PATH_INCLUDE "logger.h" "${LOG4CPLUS_SEARCH_PATH_INCLUDE}" "log4cplus;log4cpp" )
package_find_library( LOG4CPLUS_LIBRARY_DEBUG "${LOG4CPLUS_LIBRARY_NAMES_DEBUG}" "${LOG4CPLUS_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( LOG4CPLUS_LIBRARY_RELEASE "${LOG4CPLUS_LIBRARY_NAMES}" "${LOG4CPLUS_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )
package_make_library( LOG4CPLUS_LIBRARY LOG4CPLUS_LIBRARY_DEBUG LOG4CPLUS_LIBRARY_RELEASE )


# ************************************************************
# Find binaries on Windows
if( WIN32 AND NOT LOG4CPLUS_ENABLE_STATICAL )
	set( LOG4CPLUS_BINARY_NAMES "log4cplus" )
    package_create_debug_binary_names( LOG4CPLUS_BINARY_NAMES )
	package_create_release_binary_names( LOG4CPLUS_BINARY_NAMES )
	package_create_search_path_binary( LOG4CPLUS )
	
	set( LOG4CPLUS_SEARCH_BINARIES 
		${LOG4CPLUS_SEARCH_PATH_BINARY}
		${LOG4CPLUS_SEARCH_PATH_LIBRARY}
	)
	
	package_find_file( LOG4CPLUS_BINARY_DEBUG "${LOG4CPLUS_BINARY_NAMES_DEBUG}" "${LOG4CPLUS_SEARCH_BINARIES}" "debug" )
	package_find_file( LOG4CPLUS_BINARY_RELEASE "${LOG4CPLUS_BINARY_NAMES_RELEASE}" "${LOG4CPLUS_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
endif()


# ************************************************************
# Finalize package
package_validate( LOG4CPLUS )

if( WIN32 AND LOG4CPLUS_LIBRARIES )
	set( LOG4CPLUS_LIBRARIES "${LOG4CPLUS_LIBRARIES}" "ws2_32.lib" )
endif()

package_add_parent_dir( LOG4CPLUS )
package_end( LOG4CPLUS )
message_footer( LOG4CPLUS )
