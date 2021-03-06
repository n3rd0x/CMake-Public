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
# Website: https://pybullet.org/wordpress


# ************************************************************
# Start package
# ************************************************************
message_header(BULLET)
package_begin(BULLET)
package_create_home_path(BULLET BULLET_ROOT)



# ************************************************************
# Find binary
# ************************************************************
macro(BULLET_FIND_COMPONENT Component Name Headers Suffix)
    set(BULLET_${Component}_NAMES "${Name}")
    package_create_debug_names(BULLET_${Component}_NAMES)
    
    package_find_path(BULLET_${Component}_PATH_INCLUDE "${Headers}" "${BULLET_SEARCH_PATH_INCLUDE}" "${Suffix}")
    package_find_library(BULLET_${Component}_LIBRARY_DEBUG "${BULLET_${Component}_NAMES_DEBUG}" "${BULLET_SEARCH_PATH_LIBRARY}" "debug")
    package_find_library(BULLET_${Component}_LIBRARY_RELEASE "${BULLET_${Component}_NAMES}" "${BULLET_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
    package_make_library(BULLET_${Component}_LIBRARY BULLET_${Component}_LIBRARY_DEBUG BULLET_${Component}_LIBRARY_RELEASE)
    if(BULLET_${Component}_LIBRARY)
        set(BULLET_${Component}_LIBRARIES ${BULLET_${Component}_LIBRARY})
    endif()

    if(WIN32)
        package_create_debug_binary_names(BULLET_${Component}_NAMES)
        package_create_release_binary_names(BULLET_${Component}_NAMES)

        package_find_file(BULLET_${Component}_BINARY_DEBUG "${BULLET_${Component}_BINARY_NAMES_DEBUG}" "${BULLET_SEARCH_BINARIES}" "debug")
        package_find_file(BULLET_${Component}_BINARY_RELEASE "${BULLET_${Component}_BINARY_NAMES}" "${BULLET_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")

        if(BULLET_${Component}_BINARY_DEBUG)
            list(APPEND BULLET_BINARY_DEBUG ${BULLET_${Component}_BINARY_DEBUG})
        endif()

        if(BULLET_${Component}_BINARY_RELEASE)
            list(APPEND BULLET_BINARY_RELEASE ${BULLET_${Component}_BINARY_RELEASE})
        endif()
    endif()
    
    unset(BULLET_${Component}_NAMES)
endmacro()




# ************************************************************
# Create search path
# ************************************************************
set(BULLET_PREFIX_PATH ${BULLET_HOME})
package_create_search_path_binary(BULLET)
package_create_search_path_include(BULLET)
package_create_search_path_library(BULLET)
package_create_search_path_plugin(BULLET)
set(BULLET_SEARCH_BINARIES 
    ${BULLET_SEARCH_PATH_BINARY}
    ${BULLET_SEARCH_PATH_LIBRARY}
)




# ************************************************************
# Clear
# ************************************************************
package_clear_if_changed(BULLET_HOME
    BULLET_FOUND
    BULLET_PATH_INCLUDE
    BULLET_COLLISION_BINARY_DEBUG
    BULLET_COLLISION_BINARY_RELEASE
    BULLET_COLLISION_INCLUDE_DIR
    BULLET_COLLISION_LIBRARY_DEBUG
    BULLET_COLLISION_LIBRARY_RELEASE
    BULLET_DYNAMICS_BINARY_DEBUG
    BULLET_DYNAMICS_BINARY_RELEASE
    BULLET_DYNAMICS_INCLUDE_DIR
    BULLET_DYNAMICS_LIBRARY_DEBUG
    BULLET_DYNAMICS_LIBRARY_RELEASE
    BULLET_INVERSEDYNAMICS_BINARY_DEBUG
    BULLET_INVERSEDYNAMICS_BINARY_RELEASE
    BULLET_INVERSEDYNAMICS_INCLUDE_DIR
    BULLET_INVERSEDYNAMICS_LIBRARY_DEBUG
    BULLET_INVERSEDYNAMICS_LIBRARY_RELEASE
    BULLET_SOFTBODY_BINARY_DEBUG
    BULLET_SOFTBODY_BINARY_RELEASE
    BULLET_SOFTBODY_INCLUDE_DIR
    BULLET_SOFTBODY_LIBRARY_DEBUG
    BULLET_SOFTBODY_LIBRARY_RELEASE
    BULLET_CONVEXDECOMPOSITION_BINARY_DEBUG
    BULLET_CONVEXDECOMPOSITION_BINARY_RELEASE
    BULLET_CONVEXDECOMPOSITION_INCLUDE_DIR
    BULLET_CONVEXDECOMPOSITION_LIBRARY_DEBUG
    BULLET_CONVEXDECOMPOSITION_LIBRARY_RELEASE
)




# ************************************************************
# Create search name
# ************************************************************




# ************************************************************
# Find path and file
# ************************************************************
package_find_path(BULLET_PATH_INCLUDE "btBulletDynamicsCommon.h" "${BULLET_SEARCH_PATH_INCLUDE}" "")
bullet_find_component(COLLISION "BulletCollision" "btBulletCollisionCommon.h" "BulletCollision")
bullet_find_component(DYNAMICS "BulletDynamics" "btBulletDynamicsCommon.h" "BulletDynamics")
bullet_find_component(INVERSEDYNAMICS "BulletInverseDynamics" "btBulletCollisionCommon.h" "BulletInverseDynamics")
bullet_find_component(SOFTBODY "BulletSoftBody" "btSoftBody.h" "BulletSoftBody")
bullet_find_component(LINEARMATH "LinearMath" "btMotionState.h" "LinearMath")
bullet_find_component(CONVEXDECOMPOSITION "ConvexDecomposition" "ConvexDecomposition.h" "ConvexDecomposition")
package_make_library(BULLET_LIBRARY BULLET_COLLISION_LIBRARY_DEBUG BULLET_COLLISION_LIBRARY_RELEASE)



# ************************************************************
# Find binaries on Windows
# ************************************************************
if(WIN32)
endif()





# ************************************************************
# Finalize package
# ************************************************************
package_validate(BULLET)
package_add_parent_dir(BULLET ADD_PARENT)
package_end(BULLET)
message_footer(BULLET)

