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


# ************************************************************
# Start package
cm_message_header( CPPNETLIB )
cm_package_begin( CPPNETLIB )
cm_package_create_home_path( CPPNETLIB CPPNETLIB_ROOT )


# ************************************************************
# Create Search Path
set( CPPNETLIB_PREFIX_PATH ${CPPNETLIB_HOME} )
cm_package_create_search_path_include( CPPNETLIB )
cm_package_create_search_path_library( CPPNETLIB )


# ************************************************************
# Clear
cm_package_clear_if_changed( CPPNETLIB_PREFIX_PATH
    CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_DEBUG
    CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_RELEASE
    CPPNETLIB_LIBRARY_SERVER_PARSERS_DEBUG
    CPPNETLIB_LIBRARY_SERVER_PARSERS_RELEASE
    CPPNETLIB_LIBRARY_URI_DEBUG
    CPPNETLIB_LIBRARY_URI_RELEASE
    CPPNETLIB_PATH_INCLUDE
)


# ************************************************************
# Find Paths
cm_package_find_path( CPPNETLIB_PATH_INCLUDE "boost/network.hpp" "${CPPNETLIB_SEARCH_PATH_INCLUDE}" "" )


# ************************************************************
# Find "Client Connections"
set( CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_NAMES "cppnetlib-client-connections" )
cm_package_create_debug_names( CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_NAMES )
cm_package_find_library( CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_DEBUG "${CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_NAMES_DEBUG}" "${CPPNETLIB_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_RELEASE "${CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_NAMES}" "${CPPNETLIB_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_DEBUG CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS_RELEASE )


# ************************************************************
# Find "Server Parsers"
set( CPPNETLIB_LIBRARY_SERVER_PARSERS_NAMES "cppnetlib-server-parsers" )
cm_package_create_debug_names( CPPNETLIB_LIBRARY_SERVER_PARSERS_NAMES )
cm_package_find_library( CPPNETLIB_LIBRARY_SERVER_PARSERS_DEBUG "${CPPNETLIB_LIBRARY_SERVER_PARSERS_NAMES_DEBUG}" "${CPPNETLIB_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( CPPNETLIB_LIBRARY_SERVER_PARSERS_RELEASE "${CPPNETLIB_LIBRARY_SERVER_PARSERS_NAMES}" "${CPPNETLIB_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( CPPNETLIB_LIBRARY_SERVER_PARSERS CPPNETLIB_LIBRARY_SERVER_PARSERS_DEBUG CPPNETLIB_LIBRARY_SERVER_PARSERS_RELEASE )


# ************************************************************
# Find "URI"
set( CPPNETLIB_LIBRARY_URI_NAMES "cppnetlib-uri" )
cm_package_create_debug_names( CPPNETLIB_LIBRARY_URI_NAMES )
cm_package_find_library( CPPNETLIB_LIBRARY_URI_DEBUG "${CPPNETLIB_LIBRARY_URI_NAMES_DEBUG}" "${CPPNETLIB_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( CPPNETLIB_LIBRARY_URI_RELEASE "${CPPNETLIB_LIBRARY_URI_NAMES}" "${CPPNETLIB_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( CPPNETLIB_LIBRARY_URI CPPNETLIB_LIBRARY_URI_DEBUG CPPNETLIB_LIBRARY_URI_RELEASE )


# Verify all three sub-libraries.
if( CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS AND CPPNETLIB_LIBRARY_SERVER_PARSERS AND CPPNETLIB_LIBRARY_URI )
    set( CPPNETLIB_LIBRARY
        ${CPPNETLIB_LIBRARY_CLIENT_CONNECTIONS}
        ${CPPNETLIB_LIBRARY_SERVER_PARSERS}
        ${CPPNETLIB_LIBRARY_URI}
    )
endif()


# ************************************************************
# Finalize Package
cm_package_validate( CPPNETLIB )
cm_package_end( CPPNETLIB )
cm_message_footer( CPPNETLIB )

