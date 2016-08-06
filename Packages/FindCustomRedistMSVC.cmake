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
message_header(RedistMSVC)
package_begin(RedistMSVC)
package_create_home_path(RedistMSVC RedistMSVC_ROOT)




# ************************************************************
# Create search path
set(RedistMSVC_PREFIX_PATH ${RedistMSVC_HOME})




# ************************************************************
# Create search name
set(VERSION_VALUE "")
if(MSVC14)
    set(VERSION_VALUE "140")
elseif(MSVC12)
    set(VERSION_VALUE "120")
elseif(MSVC11)
    set(VERSION_VALUE "110")
elseif(MSVC10)
    set(VERSION_VALUE "100")
endif()
set(MSVCP_NAME "msvcp${VERSION_VALUE}")
set(MSVCR_NAME "msvcr${VERSION_VALUE}")
package_create_debug_binary_names(MSVCP_NAME)
package_create_release_binary_names(MSVCP_NAME)
package_create_debug_binary_names(MSVCR_NAME)
package_create_release_binary_names(MSVCR_NAME)




# ************************************************************
# Clear
package_clear_if_changed(RedistMSVC_PREFIX_PATH
    RedistMSVC_MSVCP_DEBUG
    RedistMSVC_MSVCP_RELEASE
    RedistMSVC_MSVCR_DEBUG
    RedistMSVC_MSVCR_RELEASE
)




# ************************************************************
# Find paths
package_find_file(RedistMSVC_MSVCP_DEBUG "${MSVCP_NAME_DEBUG}" "${RedistMSVC_HOME}" "debug")
package_find_file(RedistMSVC_MSVCP_RELEASE "${MSVCP_NAME_RELEASE}" "${RedistMSVC_HOME}" "release")
package_find_file(RedistMSVC_MSVCR_DEBUG "${MSVCR_NAME_DEBUG}" "${RedistMSVC_HOME}" "debug")
package_find_file(RedistMSVC_MSVCR_RELEASE "${MSVCR_NAME_RELEASE}" "${RedistMSVC_HOME}" "release")

if(RedistMSVC_MSVCP_DEBUG AND RedistMSVC_MSVCR_DEBUG)
    set(RedistMSVC_BINARY_DEBUG "${RedistMSVC_MSVCP_DEBUG}" "${RedistMSVC_MSVCR_DEBUG}")
endif()

if(RedistMSVC_MSVCP_RELEASE AND RedistMSVC_MSVCR_RELEASE)
    set(RedistMSVC_BINARY_RELEASE "${RedistMSVC_MSVCP_RELEASE}" "${RedistMSVC_MSVCR_RELEASE}")
endif()




# ************************************************************
# Finalize package
if(RedistMSVC_BINARY_DEBUG OR RedistMSVC_BINARY_RELEASE)
    message_status(STATUS "The RedistMSVC library is located.")
else()
    message_status("" "Failed to locate the RedistMSVC library.")
endif()
message_footer(RedistMSVC)
