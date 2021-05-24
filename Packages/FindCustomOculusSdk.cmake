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
# Website: http://www.oculusvr.com


# ************************************************************
# Start package
cm_message_header( OculusSdk )
package_begin( OculusSdk )
package_create_home_path( OculusSdk OculusSdk_ROOT )


# ************************************************************
# Create search path
set( OculusSdk_PREFIX_PATH ${OculusSdk_HOME} )
package_create_search_path_include( OculusSdk )
package_create_search_path_library( OculusSdk )


# ************************************************************
# Create search name
set( OculusSdk_LIBRARY_NAMES "libovr" )
package_create_debug_names( OculusSdk_LIBRARY_NAMES )


# ************************************************************
# Clear
package_clear_if_changed( OculusSdk_PREFIX_PATH
    OculusSdk_LIBRARY_DEBUG
    OculusSdk_LIBRARY_RELEASE
    OculusSdk_PATH_INCLUDE
)


# ************************************************************
# Find paths
package_find_path( OculusSdk_PATH_INCLUDE "OVR.h" "${OculusSdk_SEARCH_PATH_INCLUDE}" "" )
package_find_library( OculusSdk_LIBRARY_DEBUG "${OculusSdk_LIBRARY_NAMES_DEBUG}" "${OculusSdk_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( OculusSdk_LIBRARY_RELEASE "${OculusSdk_LIBRARY_NAMES}" "${OculusSdk_SEARCH_PATH_LIBRARY}" "release"  )
package_make_library( OculusSdk_LIBRARY OculusSdk_LIBRARY_DEBUG OculusSdk_LIBRARY_RELEASE )


# ************************************************************
# Finalize package
package_validate( OculusSdk )
package_add_parent_dir( OculusSdk )
package_end( OculusSdk )
cm_message_footer( OculusSdk )

