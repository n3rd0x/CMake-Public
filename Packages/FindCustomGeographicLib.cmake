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
# Website: http://geographiclib.sourceforge.net


# ************************************************************
# Start package
cm_message_header(GEOGRAPHICLIB)
cm_package_begin(GEOGRAPHICLIB)
cm_package_create_home_path(GEOGRAPHICLIB GEOGRAPHICLIB_ROOT)


# ************************************************************
# Create Search Path
set(GEOGRAPHICLIB_PREFIX_PATH ${GEOGRAPHICLIB_HOME})
cm_package_create_search_path_include(GEOGRAPHICLIB)
cm_package_create_search_path_library(GEOGRAPHICLIB)


# ************************************************************
# Create Search Name
set(GEOGRAPHICLIB_LIBRARY_NAMES "Geographic")
cm_package_create_debug_names(GEOGRAPHICLIB_LIBRARY_NAMES)


# ************************************************************
# Clear
cm_package_clear_if_changed(GEOGRAPHICLIB_PREFIX_PATH
    GEOGRAPHICLIB_LIBRARY_DEBUG
    GEOGRAPHICLIB_LIBRARY_RELEASE
    GEOGRAPHICLIB_PATH_INCLUDE
)


# ************************************************************
# Find Paths
cm_package_find_path(GEOGRAPHICLIB_PATH_INCLUDE "Geocentric.hpp" "${GEOGRAPHICLIB_SEARCH_PATH_INCLUDE}" "GeographicLib")
cm_package_find_library(GEOGRAPHICLIB_LIBRARY_DEBUG "${GEOGRAPHICLIB_LIBRARY_NAMES_DEBUG}" "${GEOGRAPHICLIB_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library(GEOGRAPHICLIB_LIBRARY_RELEASE "${GEOGRAPHICLIB_LIBRARY_NAMES}" "${GEOGRAPHICLIB_SEARCH_PATH_LIBRARY}" "release" )
cm_package_make_library(GEOGRAPHICLIB_LIBRARY GEOGRAPHICLIB_LIBRARY_DEBUG GEOGRAPHICLIB_LIBRARY_RELEASE)


# ************************************************************
# Find Binaries on Windows
if(WIN32)
    set(GEOGRAPHICLIB_BINARY_NAMES "Geographic")
    cm_package_create_release_binary_names(GEOGRAPHICLIB_BINARY_NAMES)
    cm_package_create_debug_binary_names(GEOGRAPHICLIB_BINARY_NAMES)
    cm_package_create_search_path_binary(GEOGRAPHICLIB)

    set(GEOGRAPHICLIB_SEARCH_BINARIES
        ${GEOGRAPHICLIB_SEARCH_PATH_BINARY}
        ${GEOGRAPHICLIB_SEARCH_PATH_LIBRARY}
    )

    cm_package_clear_if_changed(GEOGRAPHICLIB_PREFIX_PATH
        GEOGRAPHICLIB_BINARY_RELEASE
        GEOGRAPHICLIB_BINARY_DEBUG
    )

    cm_package_find_file(GEOGRAPHICLIB_BINARY_DEBUG "${GEOGRAPHICLIB_BINARY_NAMES_DEBUG}" "${GEOGRAPHICLIB_SEARCH_BINARIES}" "debug")
    #cm_package_find_file(GEOGRAPHICLIB_BINARY_DEBUG "${GEOGRAPHICLIB_BINARY_NAMES_DEBUG}" "${GEOGRAPHICLIB_SEARCH_BINARIES}" "")
    cm_package_find_file(GEOGRAPHICLIB_BINARY_RELEASE "${GEOGRAPHICLIB_BINARY_NAMES_RELEASE}" "${GEOGRAPHICLIB_SEARCH_BINARIES}" "release")
    #cm_package_find_file(GEOGRAPHICLIB_BINARY_RELEASE "${GEOGRAPHICLIB_BINARY_NAMES_RELEASE}" "${GEOGRAPHICLIB_SEARCH_BINARIES}" "")
endif()


# ************************************************************
# Finalize Package
cm_package_validate(GEOGRAPHICLIB)
cm_package_include_options(GEOGRAPHICLIB)
cm_package_end(GEOGRAPHICLIB)
cm_message_footer(GEOGRAPHICLIB)

