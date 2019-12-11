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
# Website:


# ************************************************************
# Start package
# ************************************************************
message_header(GEOS)
package_begin(GEOS)
package_create_home_path(GEOS GEOS_ROOT)




# ************************************************************
# Create search path
# ************************************************************
set(GEOS_PREFIX_PATH ${GEOS_HOME})
package_create_search_path_include(GEOS)
package_create_search_path_library(GEOS)


# ************************************************************
# Create search name
set(GEOS_LIBRARY_NAMES "geos")
package_create_debug_names(GEOS_LIBRARY_NAMES)

set(GEOS_C_LIBRARY_NAMES "geos_c")
package_create_debug_names(GEOS_C_LIBRARY_NAMES)




# ************************************************************
# Clear
# ************************************************************
if(WIN32)
	package_clear_if_changed(GEOS_PREFIX_PATH
		GEOS_BINARY_RELEASE
		GEOS_BINARY_DEBUG
		GEOS_LIBRARY_DEBUG
        GEOS_LIBRARY_RELEASE
        GEOS_C_BINARY_RELEASE
		GEOS_C_BINARY_DEBUG
		GEOS_C_LIBRARY_DEBUG
		GEOS_C_LIBRARY_RELEASE
		GEOS_PATH_INCLUDE
	)
else()
	package_clear_if_changed(GEOS_PREFIX_PATH
		GEOS_LIBRARY_DEBUG
        GEOS_LIBRARY_RELEASE
        GEOS_C_LIBRARY_DEBUG
		GEOS_C_LIBRARY_RELEASE
		GEOS_PATH_INCLUDE
	)
endif()




# ************************************************************
# Find paths
# ************************************************************
package_find_path(GEOS_PATH_INCLUDE "GEOS.h" "${GEOS_SEARCH_PATH_INCLUDE}" "GEOS")
package_find_library(GEOS_LIBRARY_DEBUG "${GEOS_LIBRARY_NAMES_DEBUG}" "${GEOS_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library(GEOS_LIBRARY_RELEASE "${GEOS_LIBRARY_NAMES}" "${GEOS_SEARCH_PATH_LIBRARY}" "release" )
package_find_library(GEOS_C_LIBRARY_DEBUG "${GEOS_C_LIBRARY_NAMES_DEBUG}" "${GEOS_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library(GEOS_C_LIBRARY_RELEASE "${GEOS_C_LIBRARY_NAMES}" "${GEOS_SEARCH_PATH_LIBRARY}" "release" )
package_make_library(GEOS_LIBRARY GEOS_LIBRARY_DEBUG GEOS_LIBRARY_RELEASE)
package_make_library(GEOS_C_LIBRARY GEOS_C_LIBRARY_DEBUG GEOS_C_LIBRARY_RELEASE)

if(GEOS_C_LIBRARY)
    list(APPEND GEOS_LIBRARY "${GEOS_C_LIBRARY}")
endif()




# ************************************************************
# Find binaries on Windows
# ************************************************************
if(WIN32)
	set(GEOS_BINARY_NAMES "geos")
	package_create_release_binary_names(GEOS_BINARY_NAMES)
	package_create_debug_binary_names(GEOS_BINARY_NAMES)
    package_create_search_path_binary(GEOS)

    et(GEOS_C_BINARY_NAMES "geos")
	package_create_release_binary_names(GEOS_C_BINARY_NAMES)
	package_create_debug_binary_names(GEOS_C_BINARY_NAMES)

	set(GEOS_SEARCH_BINARIES
		${GEOS_SEARCH_PATH_BINARY}
		${GEOS_SEARCH_PATH_LIBRARY}
	)

	package_find_file(GEOS_BINARY_DEBUG "${GEOS_BINARY_NAMES_DEBUG}" "${GEOS_SEARCH_BINARIES}" "debug")
    package_find_file(GEOS_BINARY_RELEASE "${GEOS_BINARY_NAMES_RELEASE}" "${GEOS_SEARCH_BINARIES}" "release")

    package_find_file(GEOS_C_BINARY_DEBUG "${GEOS_C_BINARY_NAMES_DEBUG}" "${GEOS_SEARCH_BINARIES}" "debug")
	package_find_file(GEOS_C_BINARY_RELEASE "${GEOS_C_BINARY_NAMES_RELEASE}" "${GEOS_SEARCH_BINARIES}" "release")
endif()




# ************************************************************
# Finalize package
# ************************************************************
package_validate(GEOS)
package_add_parent_dir(GEOS ADD_PARENT)
package_end(GEOS)
message_footer(GEOS)
