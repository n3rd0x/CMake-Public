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
# Website: http://www.lonesock.net/soil.html


# ************************************************************
# Start package
message_header( SOIL )
package_begin( SOIL )
package_create_home_path( SOIL SOIL_ROOT )


# ************************************************************
# Create search path
set( SOIL_PREFIX_PATH ${SOIL_HOME} )
package_create_search_path_include( SOIL )
package_create_search_path_library( SOIL )
package_create_search_path_plugin( SOIL )


# ************************************************************
# Create search name
set( SOIL_LIBRARY_NAMES "SOIL" )
package_create_debug_names( SOIL_LIBRARY_NAMES )


# ************************************************************
# Clear
package_clear_if_changed( SOIL_PREFIX_PATH
    SOIL_LIBRARY_DEBUG
    SOIL_LIBRARY_RELEASE
    SOIL_PATH_INCLUDE
)


# ************************************************************
# Find paths
package_find_path( SOIL_PATH_INCLUDE "SOIL.h" "${SOIL_SEARCH_PATH_INCLUDE}" "soil" )
package_find_library( SOIL_LIBRARY_DEBUG "${SOIL_LIBRARY_NAMES_DEBUG}" "${SOIL_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library( SOIL_LIBRARY_RELEASE "${SOIL_LIBRARY_NAMES}" "${SOIL_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel" )
package_make_library( SOIL_LIBRARY SOIL_LIBRARY_DEBUG SOIL_LIBRARY_RELEASE )


# ************************************************************
# Finalize package
package_validate( SOIL )
package_add_parent_dir( SOIL )
package_end( SOIL )
message_footer( SOIL )

