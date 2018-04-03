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
# Website: http://www.prismtech.com/dds-community


# ************************************************************
# Start Package
# ************************************************************
message_header(OPENSPLICE)
package_begin(OPENSPLICE)
package_create_home_path(OPENSPLICE OPENSPLICE_ROOT)




# ************************************************************
# Create Search Path
# ************************************************************
set(OPENSPLICE_PREFIX_PATH ${OPENSPLICE_HOME})
package_create_search_path_include(OPENSPLICE)
package_create_search_path_library(OPENSPLICE)
#package_append_paths(OPENSPLICE_SEARCH_PATH_INCLUDE "sys")





# ************************************************************
# Create Search Name
# ************************************************************
set(OPENSPLICE_DDSKERNEL_LIBRARY_NAMES "ddskernel")
set(OPENSPLICE_DCPSSACPP_LIBRARY_NAMES "dcpssacpp")




# ************************************************************
# Clear
# ************************************************************
package_clear_if_changed(OPENSPLICE_HOME
    OPENSPLICE_PATH_INCLUDE
    OPENSPLICE_DDSKERNEL_LIBRARY_DEBUG
    OPENSPLICE_DDSKERNEL_LIBRARY_RELEASE
    OPENSPLICE_DCPSSACPP_PATH_INCLUDE
    OPENSPLICE_DCPSSACPP_LIBRARY_DEBUG
    OPENSPLICE_DCPSSACPP_LIBRARY_RELEASE
)




# ************************************************************
# Find Paths
# ************************************************************
package_find_path(OPENSPLICE_PATH_INCLUDE "dcps" "${OPENSPLICE_SEARCH_PATH_INCLUDE}" "")


# --------------------
# DDSKERNEL
# --------------------
package_find_library(OPENSPLICE_DDSKERNEL_LIBRARY_DEBUG "${OPENSPLICE_DDSKERNEL_LIBRARY_NAMES}" "${OPENSPLICE_SEARCH_PATH_LIBRARY}" "")
package_find_library(OPENSPLICE_DDSKERNEL_LIBRARY_RELEASE "${OPENSPLICE_DDSKERNEL_LIBRARY_NAMES}" "${OPENSPLICE_SEARCH_PATH_LIBRARY}" "")


# --------------------
# DCPSSACPP
# --------------------
package_find_path(OPENSPLICE_DCPSSACPP_PATH_INCLUDE "dds_dcps.h" "${OPENSPLICE_SEARCH_PATH_INCLUDE}" "dcps/C++/SACPP")
package_find_library(OPENSPLICE_DCPSSACPP_LIBRARY_DEBUG "${OPENSPLICE_DCPSSACPP_LIBRARY_NAMES}" "${OPENSPLICE_SEARCH_PATH_LIBRARY}" "")
package_find_library(OPENSPLICE_DCPSSACPP_LIBRARY_RELEASE "${OPENSPLICE_DCPSSACPP_LIBRARY_NAMES}" "${OPENSPLICE_SEARCH_PATH_LIBRARY}" "")



# ************************************************************
# Make Library Set
# ************************************************************
package_make_library(OPENSPLICE_DDSKERNEL_LIBRARIES OPENSPLICE_DDSKERNEL_LIBRARY_DEBUG OPENSPLICE_DDSKERNEL_LIBRARY_RELEASE)
package_make_library(OPENSPLICE_DCPSSACPP_LIBRARIES OPENSPLICE_DCPSSACPP_LIBRARY_DEBUG OPENSPLICE_DCPSSACPP_LIBRARY_RELEASE)




# ************************************************************
# Validation
# ************************************************************
if(NOT OPENSPLICE_FOUND)
    if(OPENSPLICE_PATH_INCLUDE AND OPENSPLICE_DDSKERNEL_LIBRARIES)
        package_append_paths(OPENSPLICE_PATH_INCLUDE "sys")
        set(OPENSPLICE_FOUND TRUE)
        set(OPENSPLICE_LIBRARIES ${OPENSPLICE_DDSKERNEL_LIBRARIES})
        set(OPENSPLICE_INCLUDE_DIR ${OPENSPLICE_PATH_INCLUDE})
        
        if(OPENSPLICE_DCPSSACPP_PATH_INCLUDE)
            list(APPEND OPENSPLICE_INCLUDE_DIR ${OPENSPLICE_DCPSSACPP_PATH_INCLUDE})
        endif()

        if(OPENSPLICE_DCPSSACPP_LIBRARIES)
            list(APPEND OPENSPLICE_LIBRARIES ${OPENSPLICE_DCPSSACPP_LIBRARIES})
        endif()
    endif()
endif()




# ************************************************************
# Finalize Package
# ************************************************************
package_end(OPENSPLICE)
message_footer(OPENSPLICE)
