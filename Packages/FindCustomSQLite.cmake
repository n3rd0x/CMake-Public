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
# Website: https://sqlite.org


# ************************************************************
# Start package
cm_message_header( SQLITE )
cm_package_begin( SQLITE )
cm_package_create_home_path( SQLITE SQLITE_ROOT )


# ************************************************************
# Create Search Path
set( SQLITE_PREFIX_PATH ${SQLITE_HOME} )
cm_package_create_search_path_include( SQLITE )
cm_package_create_search_path_library( SQLITE )
package_create_search_path_plugin( SQLITE )


# ************************************************************
# Create Search Name
set( SQLITE_LIBRARY_NAMES "sqlite3" )
cm_package_create_debug_names( SQLITE_LIBRARY_NAMES )


# ************************************************************
# Clear
cm_package_clear_if_changed( SQLITE_PREFIX_PATH
    SQLITE_LIBRARY_RELEASE
    SQLITE_LIBRARY_DEBUG
    SQLITE_PATH_INCLUDE
)


# ************************************************************
# Find path and file
cm_package_find_path( SQLITE_PATH_INCLUDE "sqlite3.h" "${SQLITE_SEARCH_PATH_INCLUDE}" "" )
cm_package_find_library( SQLITE_LIBRARY_DEBUG "${SQLITE_LIBRARY_NAMES_DEBUG}" "${SQLITE_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( SQLITE_LIBRARY_RELEASE "${SQLITE_LIBRARY_NAMES}" "${SQLITE_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )
cm_package_make_library( SQLITE_LIBRARY SQLITE_LIBRARY_DEBUG SQLITE_LIBRARY_RELEASE )


#if( WIN32 )
#    set( SQLITE_BINARY_NAMES "SQLITE" )
#    cm_package_create_release_binary_names( SQLITE_BINARY_NAMES )
#    cm_package_create_debug_binary_names( SQLITE_BINARY_NAMES )
#
#    cm_package_clear_if_changed( SQLITE_PREFIX_PATH
#	    SQLITE_BINARY_RELEASE
#	    SQLITE_BINARY_DEBUG
#    )
#
#    package_find_binary_release( SQLITE )
#    package_find_binary_debug( SQLITE )
#    cm_package_make_library_set( SQLITE_BINARY )
#    package_copy_binary( SQLITE )
#endif()


# ************************************************************
# Finalize Package
cm_package_validate( SQLITE )
cm_package_include_options( SQLITE )
cm_package_end( SQLITE )
cm_message_footer( SQLITE )

