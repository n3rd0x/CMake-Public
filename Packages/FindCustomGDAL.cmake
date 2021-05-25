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
# Website: http://www.gdal.org


# ************************************************************
# Start package
cm_message_header(GDAL)
cm_package_begin(GDAL)
cm_package_create_home_path(GDAL GDAL_ROOT)


# ************************************************************
# Create Search Path
set(GDAL_PREFIX_PATH ${GDAL_HOME})
cm_package_create_search_path_include(GDAL)
cm_package_create_search_path_library(GDAL)


# ************************************************************
# Create Search Name
set(GDAL_LIBRARY_NAMES "gdal_i")
cm_package_create_debug_names(GDAL_LIBRARY_NAMES)


# ************************************************************
# Clear
if(WIN32)
	cm_package_clear_if_changed(GDAL_PREFIX_PATH
		GDAL_BINARY_RELEASE
		GDAL_BINARY_DEBUG
		GDAL_LIBRARY_DEBUG
		GDAL_LIBRARY_RELEASE
		GDAL_PATH_INCLUDE
	)
else()
	cm_package_clear_if_changed(GDAL_PREFIX_PATH
		GDAL_LIBRARY_DEBUG
		GDAL_LIBRARY_RELEASE
		GDAL_PATH_INCLUDE
	)
endif()


# ************************************************************
# Find Paths
cm_package_find_path(GDAL_PATH_INCLUDE "gdal.h" "${GDAL_SEARCH_PATH_INCLUDE}" "gdal" )
cm_package_find_library(GDAL_LIBRARY_DEBUG "${GDAL_LIBRARY_NAMES_DEBUG}" "${GDAL_SEARCH_PATH_LIBRARY}" "debug")
cm_package_find_library(GDAL_LIBRARY_RELEASE "${GDAL_LIBRARY_NAMES}" "${GDAL_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
cm_package_make_library(GDAL_LIBRARY GDAL_LIBRARY_DEBUG GDAL_LIBRARY_RELEASE)


# ************************************************************
# Find Binaries on Windows
if(WIN32)
    set( GDAL_BINARY_NAMES "gdal" )
	cm_package_create_release_binary_names(GDAL_BINARY_NAMES)
	cm_package_create_debug_binary_names(GDAL_BINARY_NAMES)
	cm_package_create_search_path_binary(GDAL)

	set(GDAL_SEARCH_BINARIES
		${GDAL_SEARCH_PATH_BINARY}
		${GDAL_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(GDAL_BINARY_DEBUG "${GDAL_BINARY_NAMES_DEBUG}" "${GDAL_SEARCH_BINARIES}" "debug")
	cm_package_find_file(GDAL_BINARY_RELEASE "${GDAL_BINARY_NAMES_RELEASE}" "${GDAL_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
endif()


# ************************************************************
# Finalize Package
cm_package_validate(GDAL)
cm_package_include_options(GDAL)
cm_package_end(GDAL )
cm_message_footer(GDAL)
