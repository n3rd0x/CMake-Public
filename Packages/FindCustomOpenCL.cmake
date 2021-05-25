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
cm_message_header( OPENCL )
cm_package_begin( OPENCL )
cm_package_create_home_path( OPENCL OPENCL_ROOT )

# Check whether we are going to compile for x64Bit systems.
string( REGEX MATCH "Win64" x64_FOUND ${CMAKE_GENERATOR} )
# Set path suffix for x64.
if( x64_FOUND )
    set( PATH_SUFFIX "x64" )
else()
    set( PATH_SUFFIX "x86" )
endif()
unset( x64_FOUND )


# ************************************************************
# Create Search Path
set( OPENCL_PREFIX_PATH ${OPENCL_HOME} )
cm_package_create_search_path_include( OPENCL )
cm_package_create_search_path_library( OPENCL )


# ************************************************************
# Create Search Name
set( OPENCL_LIBRARY_NAMES "OpenCL" )



# ************************************************************
# Clear
cm_package_clear_if_changed( OPENCL_PREFIX_PATH
    OPENCL_PATH_INCLUDE
    OPENCL_LIBRARY_DEBUG
    OPENCL_LIBRARY_RELEASE
    OPENCL_BINARY_RELEASE
    OPENCL_BINARY_DEBUG
)


# ************************************************************
# Find Paths
cm_package_find_path( OPENCL_PATH_INCLUDE "cl.h" "${OPENCL_SEARCH_PATH_INCLUDE}" "CL" )
cm_package_find_library( OPENCL_LIBRARY_DEBUG "${OPENCL_LIBRARY_NAMES}" "${OPENCL_SEARCH_PATH_LIBRARY}" "${PATH_SUFFIX}" )
cm_package_find_library( OPENCL_LIBRARY_RELEASE "${OPENCL_LIBRARY_NAMES}" "${OPENCL_SEARCH_PATH_LIBRARY}" "${PATH_SUFFIX}" )
cm_package_make_library( OPENCL_LIBRARY OPENCL_LIBRARY_DEBUG OPENCL_LIBRARY_RELEASE )



# ************************************************************
# Find Binaries on Windows



# ************************************************************
# Finalize Package
cm_package_validate( OPENCL )
cm_package_include_options( OPENCL )
cm_package_end( OPENCL )
cm_message_footer( OPENCL )
