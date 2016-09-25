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
# Webiste: http://glm.g-truc.net


# ************************************************************
# Start package
message_header(GLM)
package_begin(GLM)
package_create_home_path(GLM GLM_ROOT)


# ************************************************************
# Options
option(GLM_VERSION_0_9_5_0 "Greater than version 0.9.5.0" ON)


# ************************************************************
# Create search path
set(GLM_PREFIX_PATH ${GLM_HOME})
package_create_search_path_include(GLM)


# ************************************************************
# Clear
package_clear_if_changed(GLM_PREFIX_PATH
    GLM_PATH_INCLUDE
)


# ************************************************************
# Find paths
package_find_path(GLM_PATH_INCLUDE "glm.hpp" "${GLM_SEARCH_PATH_INCLUDE}" "GLM")



# ************************************************************
# Finalize package
if(GLM_PATH_INCLUDE)
    message_status(STATUS "The GLM library is located...")
    set(GLM_FOUND TRUE)
    set(GLM_INCLUDE_DIR "${GLM_PATH_INCLUDE}")
    package_add_parent_dir(GLM)
else()
    message_status("" "Failed to locate the GLM library.")
    set(GLM_FOUND FALSE)
endif()


# ************************************************************
# List files
# ------------------------------
# Root Files
# ------------------------------
file(GLOB GLM_ROOT_INLINE "${GLM_PATH_INCLUDE}/*.inl")
file(GLOB GLM_ROOT_HEADER "${GLM_PATH_INCLUDE}/*.hpp")
file(GLOB GLM_ROOT_SOURCE "${GLM_PATH_INCLUDE}/*.cpp")


# ------------------------------
# Detail / Core Files
# ------------------------------
if(GLM_VERSION_0_9_5_0)
    file(GLOB_RECURSE GLM_DETAIL_INLINE "${GLM_PATH_INCLUDE}/detail/*.inl")
    file(GLOB_RECURSE GLM_DETAIL_HEADER "${GLM_PATH_INCLUDE}/detail/*.hpp")
    file(GLOB_RECURSE GLM_DETAIL_SOURCE "${GLM_PATH_INCLUDE}/detail/*.cpp")
else()
    file(GLOB_RECURSE GLM_CORE_INLINE "${GLM_PATH_INCLUDE}/core/*.inl")
    file(GLOB_RECURSE GLM_CORE_HEADER "${GLM_PATH_INCLUDE}/core/*.hpp")
    file(GLOB_RECURSE GLM_CORE_SOURCE "${GLM_PATH_INCLUDE}/core/*.cpp")
endif()


# ------------------------------
# GTC Files
# ------------------------------
file(GLOB_RECURSE GLM_GTC_INLINE "${GLM_PATH_INCLUDE}/gtc/*.inl")
file(GLOB_RECURSE GLM_GTC_HEADER "${GLM_PATH_INCLUDE}/gtc/*.hpp")
file(GLOB_RECURSE GLM_GTC_SOURCE "${GLM_PATH_INCLUDE}/gtc/*.cpp")


# ------------------------------
# GTX Files
# ------------------------------
file(GLOB_RECURSE GLM_GTX_INLINE "${GLM_PATH_INCLUDE}/gtx/*.inl")
file(GLOB_RECURSE GLM_GTX_HEADER "${GLM_PATH_INCLUDE}/gtx/*.hpp")
file(GLOB_RECURSE GLM_GTX_SOURCE "${GLM_PATH_INCLUDE}/gtx/*.cpp")


# ------------------------------
# Virtrev Files
# ------------------------------
if(NOT GLM_VERSION_0_9_5_0 )
    file(GLOB_RECURSE GLM_VIRTREV_INLINE "${GLM_PATH_INCLUDE}/virtrev/*.inl")
    file(GLOB_RECURSE GLM_VIRTREV_HEADER "${GLM_PATH_INCLUDE}/virtrev/*.hpp")
    file(GLOB_RECURSE GLM_VIRTREV_SOURCE "${GLM_PATH_INCLUDE}/virtrev/*.cpp")
endif()


# ************************************************************
# Header Files
set(GLM_HEADER_FILES
    "${GLM_ROOT_INLINE}"
    "${GLM_ROOT_HEADER}"
    "${GLM_CORE_INLINE}"
    "${GLM_CORE_HEADER}"
    "${GLM_DETAIL_HEADER}"
    "${GLM_DETAIL_INLINE}"
    "${GLM_GTC_INLINE}"
    "${GLM_GTC_HEADER}"
    "${GLM_GTX_INLINE}"
    "${GLM_GTX_HEADER}"
    "${GLM_VIRTREV_INLINE}"
    "${GLM_VIRTREV_HEADER}"
)


# ************************************************************
# Macro
# ************************************************************
MACRO(ENABLE_LIBRARY_GLM_FILES)
    # Group files.
    source_group("Header Files\\3rd-Party\\GLM" FILES ${GLM_ROOT_INLINE})
    source_group("Header Files\\3rd-Party\\GLM" FILES ${GLM_ROOT_HEADER})
    source_group("Header Files\\3rd-Party\\GLM\\GTC" FILES ${GLM_GTC_INLINE})
    source_group("Header Files\\3rd-Party\\GLM\\GTC" FILES ${GLM_GTC_HEADER})
    source_group("Header Files\\3rd-Party\\GLM\\GTX" FILES ${GLM_GTX_INLINE})
    source_group("Header Files\\3rd-Party\\GLM\\GTX" FILES ${GLM_GTX_HEADER})
    
    if(GLM_VERSION_0_9_5_0)
        source_group("Header Files\\3rd-Party\\GLM\\Detail" FILES ${GLM_DETAIL_INLINE})
        source_group("Header Files\\3rd-Party\\GLM\\Detail" FILES ${GLM_DETAIL_HEADER})
    else()
        source_group("Header Files\\3rd-Party\\GLM\\Core" FILES ${GLM_CORE_INLINE})
        source_group("Header Files\\3rd-Party\\GLM\\Core" FILES ${GLM_CORE_HEADER})
        source_group("Header Files\\3rd-Party\\GLM\\Virtrev" FILES ${GLM_VIRTREV_INLINE})
        source_group("Header Files\\3rd-Party\\GLM\\Virtrev" FILES ${GLM_VIRTREV_HEADER})
    endif()
    
    # Set include directory
    include_directories(${GLM_INCLUDE_DIR})
    
    # Add into global header file variable.
    set(LOCAL_GROUP_HEADER_FILES ${LOCAL_GROUP_HEADER_FILES} ${GLM_HEADER_FILES})
ENDMACRO()


message_footer( GLM )

