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
# Website: https://github.com/open-source-parsers/jsoncpp


# ************************************************************
# Start package
cm_message_header( JSONCPP )
package_begin( JSONCPP )
package_create_home_path( JSONCPP JSONCPP_ROOT )


# ************************************************************
# Create search path
set( JSONCPP_PREFIX_PATH ${JSONCPP_HOME} )
package_create_search_path_include( JSONCPP )
package_create_search_path_library( JSONCPP )


# ************************************************************
# Create search name
set( JSONCPP_LIBRARY_NAMES "jsoncpp" )
package_create_debug_names( JSONCPP_LIBRARY_NAMES )


# ************************************************************
# Clear
package_clear_if_changed( JSONCPP_PREFIX_PATH
    JSONCPP_LIBRARY_DEBUG
    JSONCPP_LIBRARY_RELEASE
    JSONCPP_PATH_INCLUDE
)


# ************************************************************
# Find paths
package_find_path( JSONCPP_PATH_INCLUDE "json.h" "${JSONCPP_SEARCH_PATH_INCLUDE}" "json" )
package_find_library( JSONCPP_LIBRARY_DEBUG "${JSONCPP_LIBRARY_NAMES_DEBUG}" "${JSONCPP_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( JSONCPP_LIBRARY_RELEASE "${JSONCPP_LIBRARY_NAMES}" "${JSONCPP_SEARCH_PATH_LIBRARY}" "release"  )
package_make_library( JSONCPP_LIBRARY JSONCPP_LIBRARY_DEBUG JSONCPP_LIBRARY_RELEASE )


# ************************************************************
# Finalize package
package_validate( JSONCPP )
package_add_parent_dir(JSONCPP ADD_PARENT)
package_end( JSONCPP )
cm_message_footer( JSONCPP )
