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
# Website: https://moltengl.com/moltenvk


# ************************************************************
# Start package
message_header(Vulkan)
package_begin(Vulkan)
package_create_home_path(Vulkan Vulkan_ROOT)

# Notice.
message_status("" "NB! Version 0.18.2")
message_status("" "Replace the symbolic link 'vulkan' to the actual directory.")
message_status("" "ln -s ../vulkan vulkan")

# Options.
option(Vulkan_STATIC_LIB "Enable statically linking." FALSE)



# ************************************************************
# Create search path
set(Vulkan_PREFIX_PATH ${Vulkan_HOME})
package_create_search_path_include(Vulkan)
package_create_search_path_library(Vulkan)
package_create_search_path_binary(Vulkan)




# ************************************************************
# Define library name
if(Vulkan_STATIC_LIB)
    set(Vulkan_LIBRARY_NAMES "MoltenVK.framework")
else()
    set(Vulkan_LIBRARY_NAMES "libMoltenVK.dylib")
endif()
#package_create_debug_names(Vulkan_LIBRARY_NAMES)




# ************************************************************
# Clear
set(Vulkan_COMMON_VARIABLES
    Vulkan_LIBRARY_DEBUG
    Vulkan_LIBRARY_RELEASE
    Vulkan_PATH_INCLUDE
)
set(Vulkan_CLEAR_IF_CHANGED 
    Vulkan_PREFIX_PATH
    Vulkan_STATIC_LIB
)
foreach(Var ${Vulkan_CLEAR_IF_CHANGED})
    package_clear_if_changed(${Var}
        Vulkan_BINARY_DEBUG
        Vulkan_BINARY_RELEASE
        ${Vulkan_COMMON_VARIABLES}
    )
    unset(Var)
endforeach()




# ************************************************************
# Find path and header file
package_find_path(Vulkan_PATH_INCLUDE "vulkan/vulkan.h" "${Vulkan_SEARCH_PATH_INCLUDE}" "")
if(Vulkan_STATIC_LIB)
    package_find_file(Vulkan_LIBRARY_DEBUG "${Vulkan_LIBRARY_NAMES}" "${Vulkan_SEARCH_PATH_LIBRARY};${Vulkan_SEARCH_PATH_BINARY}" "debug;macOS")
    package_find_file(Vulkan_LIBRARY_RELEASE "${Vulkan_LIBRARY_NAMES}" "${Vulkan_SEARCH_PATH_LIBRARY};${Vulkan_SEARCH_PATH_BINARY}" "release;relwithdebinfo;minsizerel;macOS")
else()
    package_find_library(Vulkan_LIBRARY_DEBUG "${Vulkan_LIBRARY_NAMES}" "${Vulkan_SEARCH_PATH_LIBRARY};${Vulkan_SEARCH_PATH_BINARY}" "debug;macOS")
    package_find_library(Vulkan_LIBRARY_RELEASE "${Vulkan_LIBRARY_NAMES}" "${Vulkan_SEARCH_PATH_LIBRARY};${Vulkan_SEARCH_PATH_BINARY}" "release;relwithdebinfo;minsizerel;macOS")
endif()
package_make_library(Vulkan_LIBRARY Vulkan_LIBRARY_DEBUG Vulkan_LIBRARY_RELEASE)





# ************************************************************
# Find binaries
if(NOT Vulkan_STATIC_LIB)
    set(Vulkan_BINARY_DEBUG "${Vulkan_LIBRARY_DEBUG}" CACHE FILEPATH "Runtime library." FORCE)
    set(Vulkan_BINARY_RELEASE "${Vulkan_LIBRARY_DEBUG}" CACHE FILEPATH "Runtime library." FORCE)
endif()




# ************************************************************
# Finalize package
package_validate(Vulkan)
package_add_parent_dir(Vulkan ADD_PARENT)
package_end(Vulkan)
message_footer(Vulkan)

