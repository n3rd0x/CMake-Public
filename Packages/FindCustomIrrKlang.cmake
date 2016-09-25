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
# Website: http://www.ambiera.com/irrklang


# ************************************************************
# Start package
message_header( IRRKLANG )
package_begin( IRRKLANG )
package_create_home_path( IRRKLANG IRRKLANG_ROOT )


# ************************************************************
# Create search path
set( IRRKLANG_PREFIX_PATH ${IRRKLANG_HOME} )
package_create_search_path_include( IRRKLANG )
package_create_search_path_library( IRRKLANG )
package_create_search_path_plugin( IRRKLANG )


# ************************************************************
# Create search name
set( IRRKLANG_LIBRARY_NAMES "IrrKlang" )
package_create_debug_names( IRRKLANG_LIBRARY_NAMES )


# ************************************************************
# Clear
package_clear_if_changed( IRRKLANG_PREFIX_PATH
    IRRKLANG_LIBRARY_RELEASE
    IRRKLANG_LIBRARY_DEBUG
    IRRKLANG_PATH_INCLUDE
)


# ************************************************************
# Find path and header file
package_find_path( IRRKLANG_PATH_INCLUDE "irrKlang.h" "${IRRKLANG_SEARCH_PATH_INCLUDE}" "" )
package_find_library( IRRKLANG_LIBRARY_DEBUG "${IRRKLANG_LIBRARY_NAMES_DEBUG}" "${IRRKLANG_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( IRRKLANG_LIBRARY_RELEASE "${IRRKLANG_LIBRARY_NAMES}" "${IRRKLANG_SEARCH_PATH_LIBRARY}" "release relwithdebinfo minsizerel"  )
package_make_library( IRRKLANG_LIBRARY IRRKLANG_LIBRARY_DEBUG IRRKLANG_LIBRARY_RELEASE )


#if( WIN32 )
#    set( IRRKLANG_BINARY_NAMES "IRRKLANG" )
#    package_create_release_binary_names( IRRKLANG_BINARY_NAMES )
#    package_create_debug_binary_names( IRRKLANG_BINARY_NAMES )
#
#    package_clear_if_changed( IRRKLANG_PREFIX_PATH
#	    IRRKLANG_BINARY_RELEASE
#	    IRRKLANG_BINARY_DEBUG
#    )
#
#    package_find_binary_release( IRRKLANG )
#    package_find_binary_debug( IRRKLANG )
#    package_make_library_set( IRRKLANG_BINARY )
#    package_copy_binary( IRRKLANG )
#endif()


# ************************************************************
# Finalize package
package_validate( IRRKLANG )
package_add_parent_dir( IRRKLANG )
package_end( IRRKLANG )
message_footer( IRRKLANG )

