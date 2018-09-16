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
# Website: https://bitbucket.org/alexeyknyshev/ogrebullet.git


# ************************************************************
# Start package
# ************************************************************
message_header(OGREBULLET)
package_begin(OGREBULLET)
package_create_home_path(OGREBULLET OGREBULLET_ROOT)



# ************************************************************
# Find binary
# ************************************************************
macro(OGREBULLET_FIND_COMPONENT Component Name Headers Suffix)
    set(OGREBULLET_${Component}_NAMES "${Name}")
    package_create_debug_names(OGREBULLET_${Component}_NAMES)
    
    package_find_path(OGREBULLET_${Component}_PATH_INCLUDE "${Headers}" "${OGREBULLET_SEARCH_PATH_INCLUDE}" "${Suffix}")
    package_find_library(OGREBULLET_${Component}_LIBRARY_DEBUG "${OGREBULLET_${Component}_NAMES_DEBUG}" "${OGREBULLET_SEARCH_PATH_LIBRARY}" "debug")
    package_find_library(OGREBULLET_${Component}_LIBRARY_RELEASE "${OGREBULLET_${Component}_NAMES}" "${OGREBULLET_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
    package_make_library(OGREBULLET_${Component}_LIBRARY OGREBULLET_${Component}_LIBRARY_DEBUG OGREBULLET_${Component}_LIBRARY_RELEASE)
    if(OGREBULLET_${Component}_LIBRARY)
        set(OGREBULLET_${Component}_LIBRARIES ${OGREBULLET_${Component}_LIBRARY})
    endif()

    if(WIN32)
        package_create_debug_binary_names(OGREBULLET_${Component}_NAMES)
        package_create_release_binary_names(OGREBULLET_${Component}_NAMES)

        package_find_file(OGREBULLET_${Component}_BINARY_DEBUG "${OGREBULLET_${Component}_BINARY_NAMES_DEBUG}" "${OGREBULLET_SEARCH_BINARIES}" "debug")
        package_find_file(OGREBULLET_${Component}_BINARY_RELEASE "${OGREBULLET_${Component}_BINARY_NAMES}" "${OGREBULLET_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")

        if(OGREBULLET_${Component}_BINARY_DEBUG)
            list(APPEND OGREBULLET_BINARY_DEBUG ${OGREBULLET_${Component}_BINARY_DEBUG})
        endif()

        if(OGREBULLET_${Component}_BINARY_RELEASE)
            list(APPEND OGREBULLET_BINARY_RELEASE ${OGREBULLET_${Component}_BINARY_RELEASE})
        endif()
    endif()
    
    unset(OGREBULLET_${Component}_NAMES)
endmacro()




# ************************************************************
# Create search path
# ************************************************************
set(OGREBULLET_PREFIX_PATH ${OGREBULLET_HOME})
package_create_search_path_binary(OGREBULLET)
package_create_search_path_include(OGREBULLET)
package_create_search_path_library(OGREBULLET)
package_create_search_path_plugin(OGREBULLET)
set(OGREBULLET_SEARCH_BINARIES 
    ${OGREBULLET_SEARCH_PATH_BINARY}
    ${OGREBULLET_SEARCH_PATH_LIBRARY}
)




# ************************************************************
# Clear
# ************************************************************
package_clear_if_changed(OGREBULLET_HOME
    OGREBULLET_FOUND
    OGREBULLET_PATH_INCLUDE
    OGREBULLET_BINARY_DEBUG
    OGREBULLET_BINARY_RELEASE
    OGREBULLET_LIBRARY_DEBUG
    OGREBULLET_LIBRARY_RELEASE
    OGREBULLET_COLLISIONS_BINARY_DEBUG
    OGREBULLET_COLLISIONS_BINARY_RELEASE
    OGREBULLET_COLLISIONS_INCLUDE_DIR
    OGREBULLET_COLLISIONS_LIBRARY_DEBUG
    OGREBULLET_COLLISIONS_LIBRARY_RELEASE
    OGREBULLET_DYNAMICS_BINARY_DEBUG
    OGREBULLET_DYNAMICS_BINARY_RELEASE
    OGREBULLET_DYNAMICS_INCLUDE_DIR
    OGREBULLET_DYNAMICS_LIBRARY_DEBUG
    OGREBULLET_DYNAMICS_LIBRARY_RELEASE
)




# ************************************************************
# Create search name
# ************************************************************




# ************************************************************
# Find path and file
# ************************************************************
package_find_path(OGREBULLET_PATH_INCLUDE "OgreBulletCollisions" "${OGREBULLET_SEARCH_PATH_INCLUDE}" "")
OGREBULLET_find_component(COLLISIONS "OgreBulletCollisions" "OgreBulletCollisions.h" "OgreBulletCollisions")
OGREBULLET_find_component(DYNAMICS "OgreBulletDynamics" "OgreBulletDynamics.h" "OgreBulletDynamics")
set(OGREBULLET_LIBRARY
    "${OGREBULLET_COLLISIONS_LIBRARIES}"
    "${OGREBULLET_DYNAMICS_LIBRARIES}"
)




# ************************************************************
# Find binaries on Windows
# ************************************************************
if(WIN32)
endif()





# ************************************************************
# Finalize package
# ************************************************************
# Pacakge validate.
if(NOT OGREBULLET_FOUND)
    if(OGREBULLET_PATH_INCLUDE AND OGREBULLET_LIBRARY)
        set(OGREBULLET}_FOUND TRUE)
        set(OGREBULLET_LIBRARIES "${OGREBULLET_LIBRARY}")
        set(OGREBULLET_INCLUDE_DIR "${OGREBULLET_COLLISIONS_PATH_INCLUDE}" "${OGREBULLET_DYNAMICS_PATH_INCLUDE}")
    endif()
endif()
package_add_parent_dir(OGREBULLET ADD_PARENT)
package_end(OGREBULLET)
message_footer(OGREBULLET)

