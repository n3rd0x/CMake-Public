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
# Website: https://pocoproject.org


# ************************************************************
# Start package
cm_message_header(POCO)
package_begin(POCO)
package_create_home_path(POCO POCO_ROOT)




# ************************************************************
# Create search path
set(POCO_PREFIX_PATH ${POCO_HOME})
package_create_search_path_include(POCO)
package_create_search_path_library(POCO)




# ************************************************************
# Define library name
set(POCO_DATA_LIBRARY_NAMES "PocoData")
set(POCO_DATA_SQLITE_LIBRARY_NAMES "PocoDataSQLite")
set(POCO_FOUNDATION_LIBRARY_NAMES "PocoFoundation")
set(POCO_JSON_LIBRARY_NAMES "PocoJSON")
set(POCO_NET_LIBRARY_NAMES "PocoNet")
set(POCO_UTIL_LIBRARY_NAMES "PocoUtil")
set(POCO_XML_LIBRARY_NAMES "PocoXML")
set(POCO_ZIP_LIBRARY_NAMES "PocoZip")
package_create_debug_names(POCO_DATA_LIBRARY_NAMES)
package_create_debug_names(POCO_DATA_SQLITE_LIBRARY_NAMES)
package_create_debug_names(POCO_FOUNDATION_LIBRARY_NAMES)
package_create_debug_names(POCO_JSON_LIBRARY_NAMES)
package_create_debug_names(POCO_NET_LIBRARY_NAMES)
package_create_debug_names(POCO_UTIL_LIBRARY_NAMES)
package_create_debug_names(POCO_XML_LIBRARY_NAMES)
package_create_debug_names(POCO_ZIP_LIBRARY_NAMES)




# ************************************************************
# Clear
set(POCO_COMMON_VARIABLES
    POCO_DATA_LIBRARY_DEBUG
    POCO_DATA_SQLITE_LIBRARY_DEBUG
    POCO_FOUNDATION_LIBRARY_DEBUG
    POCO_JSON_LIBRARY_DEBUG
    POCO_NET_LIBRARY_DEBUG
    POCO_UTIL_LIBRARY_DEBUG
    POCO_XML_LIBRARY_DEBUG
    POCO_ZIP_LIBRARY_DEBUG
    POCO_DATA_LIBRARY_RELEASE
    POCO_DATA_SQLITE_LIBRARY_RELEASE
    POCO_FOUNDATION_LIBRARY_RELEASE
    POCO_JSON_LIBRARY_RELEASE
    POCO_NET_LIBRARY_RELEASE
    POCO_UTIL_LIBRARY_RELEASE
    POCO_XML_LIBRARY_RELEASE
    POCO_ZIP_LIBRARY_RELEASE
    POCO_PATH_INCLUDE
)
set(POCO_CLEAR_IF_CHANGED
    POCO_PREFIX_PATH
)
foreach(VAR ${POCO_CLEAR_IF_CHANGED})
    if(WIN32)
        package_clear_if_changed(${VAR}
            POCO_DATA_BINARY_DEBUG
            POCO_DATA_SQLITE_BINARY_DEBUG
            POCO_FOUNDATION_BINARY_DEBUG
            POCO_JSON_BINARY_DEBUG
            POCO_NET_BINARY_DEBUG
            POCO_UTIL_BINARY_DEBUG
            POCO_XML_BINARY_DEBUG
            POCO_ZIP_BINARY_DEBUG
            POCO_DATA_BINARY_RELEASE
            POCO_DATA_SQLITE_BINARY_RELEASE
            POCO_FOUNDATION_BINARY_RELEASE
            POCO_JSON_BINARY_RELEASE
            POCO_NET_BINARY_RELEASE
            POCO_UTIL_BINARY_RELEASE
            POCO_XML_BINARY_RELEASE
            POCO_ZIP_BINARY_RELEASE
            ${POCO_COMMON_VARIABLES}
        )
    else()
        package_clear_if_changed(${VAR}
            ${POCO_COMMON_VARIABLES}
        )
        unset(POCO_DATA_BINARY_DEBUG CACHE)
        unset(POCO_DATA_SQLITE_BINARY_DEBUG CACHE)
        unset(POCO_FOUNDATION_BINARY_DEBUG CACHE)
        unset(POCO_JSON_BINARY_DEBUG CACHE)
        unset(POCO_NET_BINARY_DEBUG CACHE)
        unset(POCO_UTIL_BINARY_DEBUG CACHE)
        unset(POCO_XML_BINARY_DEBUG CACHE)
        unset(POCO_ZIP_BINARY_DEBUG CACHE)
        unset(POCO_DATA_BINARY_RELEASE CACHE)
        unset(POCO_DATA_SQLITE_BINARY_RELEASE CACHE)
        unset(POCO_FOUNDATION_BINARY_RELEASE CACHE)
        unset(POCO_JSON_BINARY_RELEASE CACHE)
        unset(POCO_NET_BINARY_RELEASE CACHE)
        unset(POCO_UTIL_BINARY_RELEASE CACHE)
        unset(POCO_XML_BINARY_RELEASE CACHE)
        unset(POCO_ZIP_BINARY_RELEASE CACHE)
    endif()
endforeach()




# ************************************************************
# Find path and header file
package_find_path(POCO_PATH_INCLUDE "Poco/Poco.h" "${POCO_SEARCH_PATH_INCLUDE}" "")

package_find_library(POCO_DATA_LIBRARY_DEBUG "${POCO_DATA_LIBRARY_NAMES_DEBUG}" "${POCO_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(POCO_DATA_LIBRARY_RELEASE "${POCO_DATA_LIBRARY_NAMES}" "${POCO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")

package_find_library(POCO_DATA_SQLITE_LIBRARY_DEBUG "${POCO_DATA_SQLITE_LIBRARY_NAMES_DEBUG}" "${POCO_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(POCO_DATA_SQLITE_LIBRARY_RELEASE "${POCO_DATA_SQLITE_LIBRARY_NAMES}" "${POCO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")

package_find_library(POCO_FOUNDATION_LIBRARY_DEBUG "${POCO_FOUNDATION_LIBRARY_NAMES_DEBUG}" "${POCO_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(POCO_FOUNDATION_LIBRARY_RELEASE "${POCO_FOUNDATION_LIBRARY_NAMES}" "${POCO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")

package_find_library(POCO_JSON_LIBRARY_DEBUG "${POCO_JSON_LIBRARY_NAMES_DEBUG}" "${POCO_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(POCO_JSON_LIBRARY_RELEASE "${POCO_JSON_LIBRARY_NAMES}" "${POCO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")

package_find_library(POCO_NET_LIBRARY_DEBUG "${POCO_NET_LIBRARY_NAMES_DEBUG}" "${POCO_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(POCO_NET_LIBRARY_RELEASE "${POCO_NET_LIBRARY_NAMES}" "${POCO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")

package_find_library(POCO_UTIL_LIBRARY_DEBUG "${POCO_UTIL_LIBRARY_NAMES_DEBUG}" "${POCO_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(POCO_UTIL_LIBRARY_RELEASE "${POCO_UTIL_LIBRARY_NAMES}" "${POCO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")

package_find_library(POCO_XML_LIBRARY_DEBUG "${POCO_XML_LIBRARY_NAMES_DEBUG}" "${POCO_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(POCO_XML_LIBRARY_RELEASE "${POCO_XML_LIBRARY_NAMES}" "${POCO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")

package_find_library(POCO_ZIP_LIBRARY_DEBUG "${POCO_ZIP_LIBRARY_NAMES_DEBUG}" "${POCO_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(POCO_ZIP_LIBRARY_RELEASE "${POCO_ZIP_LIBRARY_NAMES}" "${POCO_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")




# ************************************************************
# Make library set
package_make_library(POCO_DATA_LIBRARIES POCO_DATA_LIBRARY_DEBUG POCO_DATA_LIBRARY_RELEASE)
package_make_library(POCO_DATA_SQLITE_LIBRARIES POCO_DATA_SQLITE_LIBRARY_DEBUG POCO_DATA_SQLITE_LIBRARY_RELEASE)
package_make_library(POCO_FOUNDATION_LIBRARIES POCO_FOUNDATION_LIBRARY_DEBUG POCO_FOUNDATION_LIBRARY_RELEASE)
package_make_library(POCO_JSON_LIBRARIES POCO_JSON_LIBRARY_DEBUG POCO_JSON_LIBRARY_RELEASE)
package_make_library(POCO_NET_LIBRARIES POCO_NET_LIBRARY_DEBUG POCO_NET_LIBRARY_RELEASE)
package_make_library(POCO_UTIL_LIBRARIES POCO_UTIL_LIBRARY_DEBUG POCO_UTIL_LIBRARY_RELEASE)
package_make_library(POCO_XML_LIBRARIES POCO_XML_LIBRARY_DEBUG POCO_XML_LIBRARY_RELEASE)
package_make_library(POCO_ZIP_LIBRARIES POCO_ZIP_LIBRARY_DEBUG POCO_ZIP_LIBRARY_RELEASE)




# ************************************************************
# Find binaries
if(WIN32)
    set(POCO_DATA_BINARY_NAMES ${POCO_DATA_LIBRARY_NAMES})
    set(POCO_DATA_SQLITE_BINARY_NAMES ${POCO_DATA_SQLITE_LIBRARY_NAMES})
    set(POCO_FOUNDATION_BINARY_NAMES ${POCO_FOUNDATION_LIBRARY_NAMES})
    set(POCO_JSON_BINARY_NAMES ${POCO_JSON_LIBRARY_NAMES})
    set(POCO_NET_BINARY_NAMES ${POCO_NET_LIBRARY_NAMES})
    set(POCO_UTIL_BINARY_NAMES ${POCO_UTIL_LIBRARY_NAMES})
    set(POCO_XML_BINARY_NAMES ${POCO_XML_LIBRARY_NAMES})
    set(POCO_ZIP_BINARY_NAMES ${POCO_ZIP_LIBRARY_NAMES})

    package_create_debug_binary_names(POCO_DATA_BINARY_NAMES)
    package_create_debug_binary_names(POCO_DATA_SQLITE_BINARY_NAMES)
    package_create_debug_binary_names(POCO_FOUNDATION_BINARY_NAMES)
    package_create_debug_binary_names(POCO_JSON_BINARY_NAMES)
    package_create_debug_binary_names(POCO_NET_BINARY_NAMES)
    package_create_debug_binary_names(POCO_UTIL_BINARY_NAMES)
    package_create_debug_binary_names(POCO_XML_BINARY_NAMES)
    package_create_debug_binary_names(POCO_ZIP_BINARY_NAMES)
	package_create_release_binary_names(POCO_DATA_BINARY_NAMES)
	package_create_release_binary_names(POCO_DATA_SQLITE_BINARY_NAMES)
	package_create_release_binary_names(POCO_FOUNDATION_BINARY_NAMES)
	package_create_release_binary_names(POCO_JSON_BINARY_NAMES)
	package_create_release_binary_names(POCO_NET_BINARY_NAMES)
	package_create_release_binary_names(POCO_UTIL_BINARY_NAMES)
	package_create_release_binary_names(POCO_XML_BINARY_NAMES)
	package_create_release_binary_names(POCO_ZIP_BINARY_NAMES)
	package_create_search_path_binary(POCO)

	set(POCO_SEARCH_BINARIES
		${POCO_SEARCH_PATH_BINARY}
		${POCO_SEARCH_PATH_LIBRARY}
	)

	package_find_file(POCO_DATA_BINARY_DEBUG "${POCO_DATA_BINARY_NAMES_DEBUG}" "${POCO_SEARCH_BINARIES}" "debug")
	package_find_file(POCO_DATA_SQLITE_BINARY_DEBUG "${POCO_DATA_SQLITE_BINARY_NAMES_DEBUG}" "${POCO_SEARCH_BINARIES}" "debug")
	package_find_file(POCO_FOUNDATION_BINARY_DEBUG "${POCO_FOUNDATION_BINARY_NAMES_DEBUG}" "${POCO_SEARCH_BINARIES}" "debug")
    package_find_file(POCO_JSON_BINARY_DEBUG "${POCO_JSON_BINARY_NAMES_DEBUG}" "${POCO_SEARCH_BINARIES}" "debug")
    package_find_file(POCO_NET_BINARY_DEBUG "${POCO_NET_BINARY_NAMES_DEBUG}" "${POCO_SEARCH_BINARIES}" "debug")
    package_find_file(POCO_UTIL_BINARY_DEBUG "${POCO_UTIL_BINARY_NAMES_DEBUG}" "${POCO_SEARCH_BINARIES}" "debug")
    package_find_file(POCO_XML_BINARY_DEBUG "${POCO_XML_BINARY_NAMES_DEBUG}" "${POCO_SEARCH_BINARIES}" "debug")
    package_find_file(POCO_ZIP_BINARY_DEBUG "${POCO_ZIP_BINARY_NAMES_DEBUG}" "${POCO_SEARCH_BINARIES}" "debug")
    package_find_file(POCO_DATA_BINARY_RELEASE "${POCO_DATA_BINARY_NAMES_RELEASE}" "${POCO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
	package_find_file(POCO_DATA_SQLITE_BINARY_RELEASE "${POCO_DATA_SQLITE_BINARY_NAMES_RELEASE}" "${POCO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
	package_find_file(POCO_FOUNDATION_BINARY_RELEASE "${POCO_FOUNDATION_BINARY_NAMES_RELEASE}" "${POCO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
    package_find_file(POCO_JSON_BINARY_RELEASE "${POCO_JSON_BINARY_NAMES_RELEASE}" "${POCO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
    package_find_file(POCO_NET_BINARY_RELEASE "${POCO_NET_BINARY_NAMES_RELEASE}" "${POCO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
    package_find_file(POCO_UTIL_BINARY_RELEASE "${POCO_UTIL_BINARY_NAMES_RELEASE}" "${POCO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
    package_find_file(POCO_XML_BINARY_RELEASE "${POCO_XML_BINARY_NAMES_RELEASE}" "${POCO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
    package_find_file(POCO_ZIP_BINARY_RELEASE "${POCO_ZIP_BINARY_NAMES_RELEASE}" "${POCO_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")

    if(POCO_DATA_BINARY_DEBUG)
        list(APPEND POCO_BINARY_DEBUG ${POCO_DATA_BINARY_DEBUG})
    endif()

    if(POCO_DATA_SQLITE_BINARY_DEBUG)
        list(APPEND POCO_BINARY_DEBUG ${POCO_DATA_SQLITE_BINARY_DEBUG})
    endif()

    if(POCO_FOUNDATION_BINARY_DEBUG)
        list(APPEND POCO_BINARY_DEBUG ${POCO_FOUNDATION_BINARY_DEBUG})
    endif()

    if(POCO_JSON_BINARY_DEBUG)
        list(APPEND POCO_BINARY_DEBUG ${POCO_JSON_BINARY_DEBUG})
    endif()

    if(POCO_NET_BINARY_DEBUG)
        list(APPEND POCO_BINARY_DEBUG ${POCO_NET_BINARY_DEBUG})
    endif()

    if(POCO_UTIL_BINARY_DEBUG)
        list(APPEND POCO_BINARY_DEBUG ${POCO_UTIL_BINARY_DEBUG})
    endif()

    if(POCO_XML_BINARY_DEBUG)
        list(APPEND POCO_BINARY_DEBUG ${POCO_XML_BINARY_DEBUG})
    endif()

    if(POCO_ZIP_BINARY_DEBUG)
        list(APPEND POCO_BINARY_DEBUG ${POCO_ZIP_BINARY_DEBUG})
    endif()

    if(POCO_DATA_BINARY_RELEASE)
        list(APPEND POCO_BINARY_RELEASE ${POCO_DATA_BINARY_RELEASE})
    endif()

    if(POCO_DATA_SQLITE_BINARY_RELEASE)
        list(APPEND POCO_BINARY_RELEASE ${POCO_DATA_SQLITE_BINARY_RELEASE})
    endif()

    if(POCO_FOUNDATION_BINARY_RELEASE)
        list(APPEND POCO_BINARY_RELEASE ${POCO_FOUNDATION_BINARY_RELEASE})
    endif()

    if(POCO_JSON_BINARY_RELEASE)
        list(APPEND POCO_BINARY_RELEASE ${POCO_JSON_BINARY_RELEASE})
    endif()

    if(POCO_NET_BINARY_RELEASE)
        list(APPEND POCO_BINARY_RELEASE ${POCO_NET_BINARY_RELEASE})
    endif()

    if(POCO_UTIL_BINARY_RELEASE)
        list(APPEND POCO_BINARY_RELEASE ${POCO_UTIL_BINARY_RELEASE})
    endif()

    if(POCO_XML_BINARY_RELEASE)
        list(APPEND POCO_BINARY_RELEASE ${POCO_XML_BINARY_RELEASE})
    endif()

    if(POCO_ZIP_BINARY_RELEASE)
        list(APPEND POCO_BINARY_RELEASE ${POCO_ZIP_BINARY_RELEASE})
    endif()
endif()




# ************************************************************
# Validation
if(NOT POCO_FOUND)
    if(POCO_PATH_INCLUDE AND POCO_FOUNDATION_LIBRARIES)
        set(POCO_FOUND TRUE)
        set(POCO_LIBRARIES ${POCO_FOUNDATION_LIBRARIES})
        set(POCO_INCLUDE_DIR ${POCO_PATH_INCLUDE})

        if(POCO_DATA_LIBRARIES)
            list(APPEND POCO_LIBRARIES ${POCO_DATA_LIBRARIES})
        endif()

        if(POCO_DATA_SQLITE_LIBRARIES)
            list(APPEND POCO_LIBRARIES ${POCO_DATA_SQLITE_LIBRARIES})
        endif()

        if(POCO_FOUNDATION_LIBRARIES)
            list(APPEND POCO_LIBRARIES ${POCO_FOUNDATION_LIBRARIES})
        endif()

        if(POCO_JSON_LIBRARIES)
            list(APPEND POCO_LIBRARIES ${POCO_JSON_LIBRARIES})
        endif()

        if(POCO_NET_LIBRARIES)
            list(APPEND POCO_LIBRARIES ${POCO_NET_LIBRARIES})
        endif()

        if(POCO_UTIL_LIBRARIES)
            list(APPEND POCO_LIBRARIES ${POCO_UTIL_LIBRARIES})
        endif()

        if(POCO_XML_LIBRARIES)
            list(APPEND POCO_LIBRARIES ${POCO_XML_LIBRARIES})
        endif()

        if(POCO_ZIP_LIBRARIES)
            list(APPEND POCO_LIBRARIES ${POCO_ZIP_LIBRARIES})
        endif()
    endif()
endif()




# ************************************************************
# Finalize package
package_add_parent_dir(POCO)
package_end(POCO)
cm_message_footer(POCO)

