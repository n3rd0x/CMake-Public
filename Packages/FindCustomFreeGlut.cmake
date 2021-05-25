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
# Website: http://freeglut.sourceforge.net


# ************************************************************
# Start package
cm_message_header(FREEGLUT)
cm_package_begin(FREEGLUT)
cm_package_create_home_path(FREEGLUT FREEGLUT_ROOT)




# ************************************************************
# Create Search Path
set(FREEGLUT_PREFIX_PATH ${FREEGLUT_HOME})
cm_package_create_search_path_include(FREEGLUT)
cm_package_create_search_path_library(FREEGLUT)




# ************************************************************
# Options
option(FREEGLUT_ENABLE_STATIC "Flag for using statical library." OFF)




# ************************************************************
# Create Search Name
set(FREEGLUT_LIBRARY_NAMES "freeglut")
if(FREEGLUT_ENABLE_STATIC)
    cm_package_create_statical_names(FREEGLUT_LIBRARY_NAMES)
endif()
cm_package_create_debug_names(FREEGLUT_LIBRARY_NAMES)




# ************************************************************
# Clear
set(FREEGLUT_CLEAR_IF_CHANGED
    FREEGLUT_PREFIX_PATH
    FREEGLUT_ENABLE_STATIC
)
foreach(VAR ${FREEGLUT_CLEAR_IF_CHANGED})
    if(WIN32 AND NOT FREEGLUT_ENABLE_STATIC)
        cm_package_clear_if_changed(${VAR}
            FREEGLUT_LIBRARY_DEBUG
            FREEGLUT_LIBRARY_RELEASE
            FREEGLUT_PATH_INCLUDE
            FREEGLUT_BINARY_DEBUG
            FREEGLUT_BINARY_RELEASE
        )
    else()
        cm_package_clear_if_changed(${VAR}
            FREEGLUT_LIBRARY_DEBUG
            FREEGLUT_LIBRARY_RELEASE
            FREEGLUT_PATH_INCLUDE
        )
        unset(FREEGLUT_BINARY_DEBUG CACHE)
        unset(FREEGLUT_BINARY_RELEASE CACHE)
    endif()
endforeach()
unset(VAR)




# ************************************************************
# Find Paths
cm_package_find_path(FREEGLUT_PATH_INCLUDE "freeglut.h" "${FREEGLUT_SEARCH_PATH_INCLUDE}" "GL")
cm_package_find_library(FREEGLUT_LIBRARY_DEBUG "${FREEGLUT_LIBRARY_NAMES_DEBUG}" "${FREEGLUT_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(FREEGLUT_LIBRARY_RELEASE "${FREEGLUT_LIBRARY_NAMES}" "${FREEGLUT_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
cm_package_make_library(FREEGLUT_LIBRARY FREEGLUT_LIBRARY_DEBUG FREEGLUT_LIBRARY_RELEASE)




# ************************************************************
# Find Binaries on Windows
if(WIN32 AND NOT FREEGLUT_ENABLE_STATIC)
	set(FREEGLUT_BINARY_NAMES "freeglut")
	cm_package_create_debug_binary_names(FREEGLUT_BINARY_NAMES)
    cm_package_create_release_binary_names(FREEGLUT_BINARY_NAMES)
	cm_package_create_search_path_binary(FREEGLUT)

	set(FREEGLUT_SEARCH_BINARIES
		${FREEGLUT_SEARCH_PATH_BINARY}
		${FREEGLUT_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(FREEGLUT_BINARY_DEBUG "${FREEGLUT_BINARY_NAMES_DEBUG}" "${FREEGLUT_SEARCH_BINARIES}" "debug")
	cm_package_find_file(FREEGLUT_BINARY_RELEASE "${FREEGLUT_BINARY_NAMES_RELEASE}" "${FREEGLUT_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()




# ************************************************************
# Finalize Package
cm_package_validate(FREEGLUT)
cm_package_include_options(FREEGLUT)
cm_package_end(FREEGLUT)
cm_message_footer(FREEGLUT)
