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
# Website: https://www.baslerweb.com/en/


# ************************************************************
# Start Package
# ************************************************************
message_header(BASLER_PYLON)
package_begin(BASLER_PYLON)
package_create_home_path(BASLER_PYLON BASLER_PYLON_ROOT)




# ************************************************************
# Create Search Path
# ************************************************************
set(BASLER_PYLON_PREFIX_PATH ${BASLER_PYLON_HOME})
package_create_search_path_include(BASLER_PYLON)
package_create_search_path_library(BASLER_PYLON)




# ************************************************************
# Create Search Name
# ************************************************************
set(BASLER_PYLON_PREFIX_NAME "pylon")
set(BASLER_PYLON_LIBRARY_NAMES "${BASLER_PYLON_PREFIX_NAME}")




# ************************************************************
# Clear
# ************************************************************
package_clear_if_changed(BASLER_PYLON_HOME
    BASLER_PYLON_PATH_INCLUDE
    BASLER_PYLON_LIBRARY_DEBUG
    BASLER_PYLON_LIBRARY_RELEASE
)




# ************************************************************
# Find Paths
# ************************************************************
if(APPLE)
    package_find_path(BASLER_PYLON_PATH_INCLUDE "PylonBase.h" "${BASLER_PYLON_SEARCH_PATH_INCLUDE}" "")
else()
    package_find_path(BASLER_PYLON_PATH_INCLUDE "pylon" "${BASLER_PYLON_SEARCH_PATH_INCLUDE}" "")
endif()
package_find_library(BASLER_PYLON_LIBRARY_DEBUG "${BASLER_PYLON_LIBRARY_NAMES}" "${BASLER_PYLON_SEARCH_PATH_LIBRARY}" "")
package_find_library(BASLER_PYLON_LIBRARY_RELEASE "${BASLER_PYLON_LIBRARY_NAMES}" "${BASLER_PYLON_SEARCH_PATH_LIBRARY}" "")
package_make_library(BASLER_PYLON_LIBRARY BASLER_PYLON_LIBRARY_DEBUG BASLER_PYLON_LIBRARY_RELEASE)




# ************************************************************
# Finalize Package
# ************************************************************
package_validate(BASLER_PYLON)
if(APPLE)
    package_add_parent_dir(BASLER_PYLON)
    list(APPEND BASLER_PYLON_INCLUDE_DIR "${BASLER_PYLON_PATH_INCLUDE}/GenICam")
else()
    package_add_parent_dir(BASLER_PYLON ADD_PARENT)
endif()
package_end(BASLER_PYLON)
message_footer(BASLER_PYLON)
