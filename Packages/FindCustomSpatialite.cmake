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
# Website: https://www.gaia-gis.it/fossil/libspatialite/index


# ************************************************************
# Start package
# ************************************************************
cm_message_header(SPATIALITE)
cm_package_begin(SPATIALITE)
cm_package_create_home_path(SPATIALITE SPATIALITE_ROOT)




# ************************************************************
# Create Search Path
# ************************************************************
set(SPATIALITE_PREFIX_PATH ${SPATIALITE_HOME})
cm_package_create_search_path_include(SPATIALITE)
cm_package_create_search_path_library(SPATIALITE)


# ************************************************************
# Create Search Name
set(SPATIALITE_LIBRARY_NAMES "spatialite")
cm_package_create_debug_names(SPATIALITE_LIBRARY_NAMES)




# ************************************************************
# Clear
# ************************************************************
if(WIN32)
	cm_package_clear_if_changed(SPATIALITE_PREFIX_PATH
		SPATIALITE_BINARY_RELEASE
		SPATIALITE_BINARY_DEBUG
		SPATIALITE_LIBRARY_DEBUG
		SPATIALITE_LIBRARY_RELEASE
		SPATIALITE_PATH_INCLUDE
	)
else()
	cm_package_clear_if_changed(SPATIALITE_PREFIX_PATH
		SPATIALITE_LIBRARY_DEBUG
		SPATIALITE_LIBRARY_RELEASE
		SPATIALITE_PATH_INCLUDE
	)
endif()




# ************************************************************
# Find Paths
# ************************************************************
cm_package_find_path(SPATIALITE_PATH_INCLUDE "spatialite.h" "${SPATIALITE_SEARCH_PATH_INCLUDE}" "spatialite")
cm_package_find_library(SPATIALITE_LIBRARY_DEBUG "${SPATIALITE_LIBRARY_NAMES_DEBUG}" "${SPATIALITE_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library(SPATIALITE_LIBRARY_RELEASE "${SPATIALITE_LIBRARY_NAMES}" "${SPATIALITE_SEARCH_PATH_LIBRARY}" "release" )
cm_package_make_library(SPATIALITE_LIBRARY SPATIALITE_LIBRARY_DEBUG SPATIALITE_LIBRARY_RELEASE)




# ************************************************************
# Find Binaries on Windows
# ************************************************************
if(WIN32)
	set(SPATIALITE_BINARY_NAMES "spatialite")
	cm_package_create_release_binary_names(SPATIALITE_BINARY_NAMES)
	cm_package_create_debug_binary_names(SPATIALITE_BINARY_NAMES)
	cm_package_create_search_path_binary(SPATIALITE)

	set(SPATIALITE_SEARCH_BINARIES
		${SPATIALITE_SEARCH_PATH_BINARY}
		${SPATIALITE_SEARCH_PATH_LIBRARY}
	)

	cm_package_find_file(SPATIALITE_BINARY_DEBUG "${SPATIALITE_BINARY_NAMES_DEBUG}" "${SPATIALITE_SEARCH_BINARIES}" "debug")
	cm_package_find_file(SPATIALITE_BINARY_RELEASE "${SPATIALITE_BINARY_NAMES_RELEASE}" "${SPATIALITE_SEARCH_BINARIES}" "release")
endif()




# ************************************************************
# Finalize Package
# ************************************************************
cm_package_validate(SPATIALITE)
cm_package_include_options(SPATIALITE)
cm_package_end(SPATIALITE)
cm_message_footer(SPATIALITE)
