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
# Website: https://www.neurotechnology.com/sentimask.html


# ************************************************************
# Start package
# ************************************************************
message_header(SENTIMASK)
package_begin(SENTIMASK)
package_create_home_path(SENTIMASK SENTIMASK_ROOT)



# ************************************************************
# Find binary
# ************************************************************
macro(SENTIMASK_FIND_COMPONENT_BINARY COMPONENT NAME SUFFIX)
    set(SENTIMASK_${COMPONENT}_BINARY_NAMES "${NAME}")
    
    package_create_debug_binary_names(SENTIMASK_${COMPONENT}_BINARY_NAMES)
    package_create_release_binary_names(SENTIMASK_${COMPONENT}_BINARY_NAMES)

    package_find_file(SENTIMASK_${COMPONENT}_BINARY_DEBUG "${SENTIMASK_${COMPONENT}_BINARY_NAMES}" "${SENTIMASK_SEARCH_BINARIES}" "${SUFFIX}")
    package_find_file(SENTIMASK_${COMPONENT}_BINARY_RELEASE "${SENTIMASK_${COMPONENT}_BINARY_NAMES}" "${SENTIMASK_SEARCH_BINARIES}" "${SUFFIX}")

    if(SENTIMASK_${COMPONENT}_BINARY_DEBUG)
        list(APPEND SENTIMASK_BINARY_DEBUG ${SENTIMASK_${COMPONENT}_BINARY_DEBUG})
    endif()

    if(SENTIMASK_${COMPONENT}_BINARY_RELEASE)
        list(APPEND SENTIMASK_BINARY_RELEASE ${SENTIMASK_${COMPONENT}_BINARY_RELEASE})
    endif()
    
    unset(SENTIMASK_${COMPONENT}_BINARY_NAMES)
endmacro()




# ************************************************************
# Create search path
# ************************************************************
set(SENTIMASK_PREFIX_PATH ${SENTIMASK_HOME})
package_create_search_path_binary(SENTIMASK)
package_create_search_path_include(SENTIMASK)
package_create_search_path_library(SENTIMASK)
package_create_search_path_plugin(SENTIMASK)
if(APPLE)
    list(APPEND SENTIMASK_SEARCH_PATH_LIBRARY "${SENTIMASK_HOME}/Frameworks")
endif()




# ************************************************************
# Clear
# ************************************************************
package_clear_if_changed(SENTIMASK_HOME
    SENTIMASK_FOUND
    SENTIMASK_PATH_INCLUDE
    SENTIMASK_SENTIMASK_BINARY_DEBUG
    SENTIMASK_SENTIMASK_BINARY_RELEASE
    SENTIMASK_LIBRARY_DEBUG
    SENTIMASK_LIBRARY_RELEASE
    SENTIMASK_NCORE_BINARY_DEBUG
    SENTIMASK_NCORE_BINARY_RELEASE
    SENTIMASK_NCORE_LIBRARY_DEBUG
    SENTIMASK_NCORE_LIBRARY_RELEASE
    SENTIMASK_NMEDIA_BINARY_DEBUG
    SENTIMASK_NMEDIA_BINARY_RELEASE
    SENTIMASK_NMEDIA_LIBRARY_DEBUG
    SENTIMASK_NMEDIA_LIBRARY_RELEASE
    SENTIMASK_NLICENSING_BINARY_DEBUG
    SENTIMASK_NLICENSING_BINARY_RELEASE
    SENTIMASK_NLICENSING_LIBRARY_DEBUG
    SENTIMASK_NLICENSING_LIBRARY_RELEASE
)




# ************************************************************
# Create search name
# ************************************************************
if(APPLE)
    set(SENTIMASK_LIBRARY_NAMES "SentiMask")
    set(SENTIMASK_NCORE_LIBRARY_NAMES "NCore")
    set(SENTIMASK_NMEDIA_LIBRARY_NAMES "NMedia")
    set(SENTIMASK_NLICENSING_LIBRARY_NAMES "NLicensing")
    set(PathSuffix "MacOSX")
else()
    set(SENTIMASK_LIBRARY_NAMES "SentiMask.dll")
    set(SENTIMASK_NCORE_LIBRARY_NAMES "NCore.dll")
    set(SENTIMASK_NMEDIA_LIBRARY_NAMES "NMedia.dll")
    set(SENTIMASK_NLICENSING_LIBRARY_NAMES "NLicensing.dll")
    set(PathSuffix "Win32_x86")
endif()



# ************************************************************
# Find path and file
# ************************************************************
package_find_path(SENTIMASK_PATH_INCLUDE "NCore.h" "${SENTIMASK_SEARCH_PATH_INCLUDE}" "")
package_find_library(SENTIMASK_LIBRARY_DEBUG "${SENTIMASK_LIBRARY_NAMES}" "${SENTIMASK_SEARCH_PATH_LIBRARY}" "${PathSuffix}")
package_find_library(SENTIMASK_LIBRARY_RELEASE "${SENTIMASK_LIBRARY_NAMES}" "${SENTIMASK_SEARCH_PATH_LIBRARY}" "${PathSuffix}")
package_make_library(SENTIMASK_LIBRARY SENTIMASK_LIBRARY_DEBUG SENTIMASK_LIBRARY_RELEASE)
package_find_path(SENTIMASK_PATH_DATA "FacesDetect45.ndf" "${SENTIMASK_SEARCH_PATH_BINARY}" "Data")
if(SENTIMASK_PATH_DATA)
    add_data_target("${SENTIMASK_PATH_DATA}/FacesDetect45.ndf" SubPath "/data")
    add_data_target("${SENTIMASK_PATH_DATA}/FacesDetectSegmentsFeaturePointsTrack.ndf" SubPath "/data")
    add_data_target("${SENTIMASK_PATH_DATA}/FacesDetectSegmentsOrientation.ndf" SubPath "/data")
endif()



# ************************************************************
# Search the components
# ************************************************************
package_find_library(SENTIMASK_NCORE_LIBRARY_DEBUG "${SENTIMASK_NCORE_LIBRARY_NAMES}" "${SENTIMASK_SEARCH_PATH_LIBRARY}" "${PathSuffix}")
package_find_library(SENTIMASK_NCORE_LIBRARY_RELEASE "${SENTIMASK_NCORE_LIBRARY_NAMES}" "${SENTIMASK_SEARCH_PATH_LIBRARY}" "${PathSuffix}")
package_make_library(SENTIMASK_NCORE_LIBRARY SENTIMASK_NCORE_LIBRARY_DEBUG SENTIMASK_NCORE_LIBRARY_RELEASE)
set(SENTIMASK_NCORE_LIBRARIES ${SENTIMASK_NCORE_LIBRARY})

package_find_library(SENTIMASK_NMEDIA_LIBRARY_DEBUG "${SENTIMASK_NMEDIA_LIBRARY_NAMES}" "${SENTIMASK_SEARCH_PATH_LIBRARY}" "${PathSuffix}")
package_find_library(SENTIMASK_NMEDIA_LIBRARY_RELEASE "${SENTIMASK_NMEDIA_LIBRARY_NAMES}" "${SENTIMASK_SEARCH_PATH_LIBRARY}" "${PathSuffix}")
package_make_library(SENTIMASK_NMEDIA_LIBRARY SENTIMASK_NMEDIA_LIBRARY_DEBUG SENTIMASK_NMEDIA_LIBRARY_RELEASE)
set(SENTIMASK_NMEDIA_LIBRARIES ${SENTIMASK_NMEDIA_LIBRARY})

package_find_library(SENTIMASK_NLICENSING_LIBRARY_DEBUG "${SENTIMASK_NLICENSING_LIBRARY_NAMES}" "${SENTIMASK_SEARCH_PATH_LIBRARY}" "${PathSuffix}")
package_find_library(SENTIMASK_NLICENSING_LIBRARY_RELEASE "${SENTIMASK_NLICENSING_LIBRARY_NAMES}" "${SENTIMASK_SEARCH_PATH_LIBRARY}" "${PathSuffix}")
package_make_library(SENTIMASK_NLICENSING_LIBRARY SENTIMASK_NLICENSING_LIBRARY_DEBUG SENTIMASK_NLICENSING_LIBRARY_RELEASE)
set(SENTIMASK_NLICENSING_LIBRARIES ${SENTIMASK_NLICENSING_LIBRARY})




# ************************************************************
# Find binaries on Windows
# ************************************************************
if(WIN32)
    set(SENTIMASK_SEARCH_BINARIES 
        ${SENTIMASK_SEARCH_PATH_BINARY}
        ${SENTIMASK_SEARCH_PATH_LIBRARY}
    )
    
    sentimask_find_component_binary(SENTIMASK "SentiMask.dll" "${PathSuffix}")
    sentimask_find_component_binary(NCORE "NCore.dll" "${PathSuffix}")
    sentimask_find_component_binary(NMEDIA "NMedia.dll" "${PathSuffix}")
    sentimask_find_component_binary(NMEDIA_PROC "NMediaProc.dll" "${PathSuffix}")
    sentimask_find_component_binary(NLICENSING "NLicensing.dll" "${PathSuffix}")
endif()





# ************************************************************
# Finalize package
# ************************************************************
package_validate(SENTIMASK)
package_add_parent_dir(SENTIMASK)
package_end(SENTIMASK)
message_footer(SENTIMASK)

