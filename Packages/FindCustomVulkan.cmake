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
# Website: https://www.khronos.org/vulkan


# ************************************************************
# Start package
cm_message_header(VULKAN)
cm_package_begin(VULKAN)
cm_package_create_home_path(VULKAN VULKAN_SDK VULKAN_ROOT)




# ************************************************************
# Create Search Path
set(VULKAN_PREFIX_PATH ${VULKAN_HOME})
cm_package_create_search_path_include(VULKAN)
cm_package_create_search_path_library(VULKAN)
cm_package_create_search_path_binary(VULKAN)




# ************************************************************
# Define library name
if(WIN32)
    set(VULKAN_LIBRARY_NAMES "vulkan-1")
else()
    set(VULKAN_LIBRARY_NAMES "vulkan")
endif()
cm_package_create_debug_names(VULKAN_LIBRARY_NAMES)




# ************************************************************
# Clear
set(VULKAN_COMMON_VARIABLES
    VULKAN_LIBRARY_DEBUG
    VULKAN_LIBRARY_RELEASE
    VULKAN_PATH_INCLUDE
)
set(VULKAN_CLEAR_IF_CHANGED
    VULKAN_PREFIX_PATH
)
foreach(Var ${VULKAN_CLEAR_IF_CHANGED})
    if(WIN32)
        cm_package_clear_if_changed(${Var}
            VULKAN_BINARY_DEBUG
            VULKAN_BINARY_RELEASE
            ${VULKAN_COMMON_VARIABLES}
        )
    else()
        cm_package_clear_if_changed(${Var}
            ${VULKAN_COMMON_VARIABLES}
        )
        unset(VULKAN_BINARY_DEBUG CACHE)
        unset(VULKAN_BINARY_RELEASE CACHE)
    endif()
    unset(Var)
endforeach()




# ************************************************************
# Find path and header file
cm_package_find_path(VULKAN_PATH_INCLUDE "vulkan/vulkan.h" "${VULKAN_SEARCH_PATH_INCLUDE}" "")
cm_package_find_library(VULKAN_LIBRARY_DEBUG "${VULKAN_LIBRARY_NAMES_DEBUG}" "${VULKAN_SEARCH_PATH_LIBRARY};${VULKAN_SEARCH_PATH_BINARY}" "debug")
cm_package_find_library(VULKAN_LIBRARY_RELEASE "${VULKAN_LIBRARY_NAMES}" "${VULKAN_SEARCH_PATH_LIBRARY};${VULKAN_SEARCH_PATH_BINARY}" "release;relwithdebinfo;minsizerel")
cm_package_make_library(VULKAN_LIBRARY VULKAN_LIBRARY_DEBUG VULKAN_LIBRARY_RELEASE)





# ************************************************************
# Find binaries
if(WIN32)
    set(VULKAN_DATA_BINARY_NAMES ${VULKAN_DATA_LIBRARY_NAMES})
    cm_package_create_debug_binary_names(VULKAN_ZIP_BINARY_NAMES)
	cm_package_create_release_binary_names(VULKAN_DATA_BINARY_NAMES)

	cm_package_find_file(VULKAN_BINARY_DEBUG "${VULKAN_DATA_BINARY_NAMES_DEBUG}" "${VULKAN_SEARCH_BINARIES}" "debug")
	cm_package_find_file(VULKAN_BINARY_RELEASE "${VULKAN_DATA_SQLITE_BINARY_NAMES_DEBUG}" "${VULKAN_SEARCH_BINARIES}" "debug")
endif()




# ************************************************************
# Finalize Package
cm_package_validate(VULKAN)
cm_package_include_options(VULKAN)
cm_package_end(VULKAN)
cm_message_footer(VULKAN)

