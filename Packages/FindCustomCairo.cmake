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
# Website: http://cairographics.org


# ************************************************************
# Start package
cm_message_header(CAIRO)
package_begin(CAIRO)
package_create_home_path(CAIRO CAIRO_ROOT)




# ************************************************************
# Create search path
set(CAIRO_PREFIX_PATH ${CAIRO_HOME})
package_create_search_path_include(CAIRO)
package_create_search_path_library(CAIRO)




# ************************************************************
# Create search name
set(CAIRO_LIBRARY_NAMES "cairo")
package_create_debug_names(CAIRO_LIBRARY_NAMES)



# ************************************************************
# Clear
if(WIN32)
	package_clear_if_changed(CAIRO_PREFIX_PATH
		CAIRO_BINARY_RELEASE
		CAIRO_BINARY_DEBUG
		CAIRO_LIBRARY_DEBUG
		CAIRO_LIBRARY_RELEASE
		CAIRO_PATH_INCLUDE
	)
else()
	package_clear_if_changed(CAIRO_PREFIX_PATH
		CAIRO_LIBRARY_DEBUG
		CAIRO_LIBRARY_RELEASE
		CAIRO_PATH_INCLUDE
	)
endif()




# ************************************************************
# Find paths
package_find_path(CAIRO_PATH_INCLUDE "cairo.h" "${CAIRO_SEARCH_PATH_INCLUDE}" "cairo")
package_find_library(CAIRO_LIBRARY_DEBUG "${CAIRO_LIBRARY_NAMES_DEBUG}" "${CAIRO_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library(CAIRO_LIBRARY_RELEASE "${CAIRO_LIBRARY_NAMES}" "${CAIRO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel" )
package_make_library(CAIRO_LIBRARY CAIRO_LIBRARY_DEBUG CAIRO_LIBRARY_RELEASE)




# ************************************************************
# Find binaries on Windows
if(WIN32)
	set(CAIRO_DEPENDENCY
		"freetype6.dll"
		"libexpat-1.dll"
		"libfontconfig-1.dll"
		"libpng14-14.dll"
		"zlib1.dll"
	)
    set(CAIRO_BINARY_NAMES "libcairo-2")
	package_create_release_binary_names(CAIRO_BINARY_NAMES)
	package_create_debug_binary_names(CAIRO_BINARY_NAMES)
	package_create_search_path_binary(CAIRO)

	set(CAIRO_SEARCH_BINARIES
		${CAIRO_SEARCH_PATH_BINARY}
		${CAIRO_SEARCH_PATH_LIBRARY}
	)

	package_find_file(CAIRO_BINARY_DEBUG "${CAIRO_BINARY_NAMES_DEBUG}" "${CAIRO_SEARCH_BINARIES}" "debug")
	package_find_file(CAIRO_BINARY_RELEASE "${CAIRO_BINARY_NAMES_RELEASE}" "${CAIRO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")

    # Find dependencies.
    foreach(VAR ${CAIRO_DEPENDENCY})
        package_find_file(CAIRO_${VAR}_BINARY_DEBUG "${VAR}" "${CAIRO_SEARCH_BINARIES}" "debug")
        if(CAIRO_${VAR}_BINARY_DEBUG)
            set(CAIRO_BINARY_DEBUG ${CAIRO_BINARY_DEBUG} ${CAIRO_${VAR}_BINARY_DEBUG})
        endif()

        package_find_file(CAIRO_${VAR}_BINARY_RELEASE "${VAR}" "${CAIRO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
        if(CAIRO_${VAR}_BINARY_RELEASE)
            set(CAIRO_BINARY_RELEASE ${CAIRO_BINARY_RELEASE} ${CAIRO_${VAR}_BINARY_RELEASE})
        endif()
        unset(CAIRO_${VAR}_BINARY_DEBUG CACHE)
        unset(CAIRO_${VAR}_BINARY_RELEASE CACHE)
    endforeach()
endif()




# ************************************************************
# Finalize package
package_validate(CAIRO)
package_add_parent_dir(CAIRO ADD_PARENT)
package_end(CAIRO)
cm_message_footer(CAIRO)
