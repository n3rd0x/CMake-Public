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


# ************************************************************
# Start package
cm_message_header( OPENNI )
cm_package_begin( OPENNI )
cm_package_create_home_path( OPENNI OPENNI_ROOT )




# ************************************************************
# Create Search Path
set( OPENNI_PREFIX_PATH ${OPENNI_HOME} )
cm_package_create_search_path_binary( OPENNI )
cm_package_create_search_path_include( OPENNI )
cm_package_create_search_path_library( OPENNI )




# ************************************************************
# Create Search Name
# Set default version 2.
if( NOT DEFINED OPENNI_VERSION OR OPENNI_VERSION STREQUAL "")
    set( OPENNI_VERSION "2" CACHE STRING "Set OpenNI version." )
endif()
set( OPENNI_LIBRARY_NAMES "OPENNI${OPENNI_VERSION}" )
cm_package_create_debug_names( OPENNI_LIBRARY_NAMES )




# ************************************************************
# Clear
set( OPENNI_CLEAR_TRIGGER
    OPENNI_HOME
    OPENNI_VERSION
)
set( OPENNI_CLEAR_COMPONENTS
    OPENNI_LIBRARY_DEBUG
    OPENNI_LIBRARY_RELEASE
    OPENNI_PATH_INCLUDE
)
if( WIN32 )
    set( OPENNI_CLEAR_COMPONENTS
        ${OPENNI_CLEAR_COMPONENTS}
        OPENNI_PATH_REDIST
    )
endif()

foreach( VAR ${OPENNI_CLEAR_TRIGGER} )
    cm_package_clear_if_changed( ${VAR}
        ${OPENNI_CLEAR_COMPONENTS}
    )
endforeach()




# ************************************************************
# Find Paths
cm_package_find_path( OPENNI_PATH_INCLUDE "OpenNI.h" "${OPENNI_SEARCH_PATH_INCLUDE}" "" )
cm_package_find_library( OPENNI_LIBRARY_DEBUG "${OPENNI_LIBRARY_NAMES_DEBUG}" "${OPENNI_SEARCH_PATH_LIBRARY}" "debug"  )
cm_package_find_library( OPENNI_LIBRARY_RELEASE "${OPENNI_LIBRARY_NAMES}" "${OPENNI_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )
cm_package_make_library( OPENNI_LIBRARY OPENNI_LIBRARY_DEBUG OPENNI_LIBRARY_RELEASE )




# ************************************************************
# Redistribution
if( WIN32 )
    # 2014-06-14 TST
    # We will handle this partially manually.
    cm_package_find_path( OPENNI_PATH_REDIST "OpenNI${OPENNI_VERSION}.dll" "${OPENNI_SEARCH_PATH_BINARY}" "" )
    if( OPENNI_PATH_REDIST )
        # Main redistribution.
        set( OPENNI_REDIST_MAIN
            "${OPENNI_PATH_REDIST}/OpenNI.ini"
            "${OPENNI_PATH_REDIST}/OpenNI${OPENNI_VERSION}.dll"
        )

        # Debug.
        foreach( VAR ${OPENNI_REDIST_MAIN})
            package_add_runtime_target( ${VAR} "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}" )
        endforeach()

        # Release.
        foreach( VAR ${OPENNI_REDIST_MAIN} )
            package_add_runtime_target( ${VAR} "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}" )
        endforeach()


        # Driver redistribution.
        set( OPENNI_REDIST_DRIVERS
            "${OPENNI_PATH_REDIST}/OpenNI${OPENNI_VERSION}/Drivers/Kinect.dll"
            "${OPENNI_PATH_REDIST}/OpenNI${OPENNI_VERSION}/Drivers/OniFile.dll"
            "${OPENNI_PATH_REDIST}/OpenNI${OPENNI_VERSION}/Drivers/PS1080.dll"
            "${OPENNI_PATH_REDIST}/OpenNI${OPENNI_VERSION}/Drivers/PS1080.ini"
            "${OPENNI_PATH_REDIST}/OpenNI${OPENNI_VERSION}/Drivers/PSLink.dll"
            "${OPENNI_PATH_REDIST}/OpenNI${OPENNI_VERSION}/Drivers/PSLink.ini"
        )

        # Debug
        foreach( VAR ${OPENNI_REDIST_DRIVERS} )
            package_add_runtime_target( ${VAR} "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/OpenNI${OPENNI_VERSION}/Drivers" )
        endforeach()

        # Release
        foreach( VAR ${OPENNI_REDIST_DRIVERS} )
            package_add_runtime_target( ${VAR} "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/OpenNI${OPENNI_VERSION}/Drivers" )
        endforeach()
    endif()
endif()




# ************************************************************
# Finalize Package
cm_package_validate( OPENNI )
cm_package_end( OPENNI )
cm_message_footer( OPENNI )
