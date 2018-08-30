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
# Website: https://bitbucket.org/cabalistic/ogredeps


# ************************************************************
# Start package
# ************************************************************
message_header(OIS)
package_begin(OIS)
package_create_home_path(OIS OIS_ROOT)


# ************************************************************
# Create search path
# ************************************************************
set(OIS_PREFIX_PATH ${OIS_HOME})
package_create_search_path_include(OIS)
package_create_search_path_library(OIS)


# ************************************************************
# Create search name
# ************************************************************
set(OIS_LIBRARY_NAMES "OIS")
package_create_debug_names(OIS_LIBRARY_NAMES)


# ************************************************************
# Clear
# ************************************************************
if(WIN32)
    package_clear_if_changed(OIS_PREFIX_PATH
        OIS_BINARY_RELEASE
        OIS_BINARY_DEBUG
        OIS_LIBRARY_RELEASE
        OIS_LIBRARY_DEBUG
        OIS_PATH_INCLUDE
        OIS_FOUND
    )
else()
    package_clear_if_changed(OIS_PREFIX_PATH
        OIS_LIBRARY_RELEASE
        OIS_LIBRARY_DEBUG
        OIS_PATH_INCLUDE
        OIS_FOUND
    )
endif()


# ************************************************************
# Find paths
# ************************************************************
package_find_path(OIS_PATH_INCLUDE "OIS.h" "${OIS_SEARCH_PATH_INCLUDE}" "OIS;Ois;ois")
package_find_library(OIS_LIBRARY_DEBUG "${OIS_LIBRARY_NAMES_DEBUG}" "${OIS_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(OIS_LIBRARY_RELEASE "${OIS_LIBRARY_NAMES}" "${OIS_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
package_make_library(OIS_LIBRARY OIS_LIBRARY_DEBUG OIS_LIBRARY_RELEASE)


# ************************************************************
# Find binaries on Windows
# ************************************************************
if(WIN32)
	set(OIS_BINARY_NAMES "OIS")
	package_create_release_binary_names(OIS_BINARY_NAMES)
	package_create_debug_binary_names(OIS_BINARY_NAMES)
	package_create_search_path_binary(OIS)
	
	set(OIS_SEARCH_BINARIES 
		${OIS_SEARCH_PATH_BINARY}
		${OIS_SEARCH_PATH_LIBRARY}
	)
	
	if(OIS_USE_CUSTOM_PACKAGE)
		package_find_file(OIS_BINARY_DEBUG "${OIS_BINARY_NAMES_DEBUG}" "${OIS_SEARCH_BINARIES}" "debug")
		package_find_file(OIS_BINARY_RELEASE "${OIS_BINARY_NAMES_RELEASE}" "${OIS_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
	else()
		if(NOT ${OIS_BINARY_DBG})
			package_find_file(OIS_BINARY_DBG "${OIS_BINARY_NAMES_DEBUG}" "${OIS_SEARCH_BINARIES}" "debug")
		endif()
		
		if(NOT ${OIS_BINARY_REL})
			package_find_file(OIS_BINARY_REL "${OIS_BINARY_NAMES_RELEASE}" "${OIS_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
		endif()
		
		set(OIS_BINARY_DEBUG ${OIS_BINARY_DBG})
		set(OIS_BINARY_RELEASE ${OIS_BINARY_REL})
	endif()
    
    package_copy_binary_from_target(OIS)
endif()


# ************************************************************
# Finalize package
# ************************************************************
package_validate(OIS)
package_add_parent_dir(OIS ADD_PARENT)
package_end(OIS)
message_footer(OIS)

