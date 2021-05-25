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
cm_package_begin( OculusSdk )
cm_package_create_home_path( OculusSdk OculusSdk_ROOT )


# ************************************************************
# Create Search Path
set( OculusSdk_PREFIX_PATH ${OculusSdk_HOME} )
cm_package_create_search_path_include( OculusSdk )
cm_package_create_search_path_library( OculusSdk )


# ************************************************************
# Create Search Name
set( OculusSdk_LIBRARY_NAMES "libovr" )
cm_package_create_debug_names( OculusSdk_LIBRARY_NAMES )


# ************************************************************
# Clear
cm_package_clear_if_changed( OculusSdk_PREFIX_PATH
    OculusSdk_LIBRARY_DEBUG
    OculusSdk_LIBRARY_RELEASE
    OculusSdk_PATH_INCLUDE
)


# ************************************************************
# Find Paths
cm_package_find_path( OculusSdk_PATH_INCLUDE "OVR.h" "${OculusSdk_SEARCH_PATH_INCLUDE}" "" )
cm_package_find_library( OculusSdk_LIBRARY_DEBUG "${OculusSdk_LIBRARY_NAMES_DEBUG}" "${OculusSdk_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( OculusSdk_LIBRARY_RELEASE "${OculusSdk_LIBRARY_NAMES}" "${OculusSdk_SEARCH_PATH_LIBRARY}" "release"  )
cm_package_make_library( OculusSdk_LIBRARY OculusSdk_LIBRARY_DEBUG OculusSdk_LIBRARY_RELEASE )


# ************************************************************
# Finalize Package
cm_package_validate( OculusSdk )
cm_package_include_options( OculusSdk )
cm_package_end( OculusSdk )
cm_message_footer( OculusSdk )

