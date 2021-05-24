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
# Website: http://www.sfml-dev.org


# ************************************************************
# Start package
cm_message_header(SFML)
package_begin(SFML)
package_create_home_path(SFML SFML_ROOT)


# ************************************************************
# Options
# Flag to either use static or dynamic linking.
option(SFML_STATIC_LIBRARIES OFF "Flag to static linking.")

# Set HOME as ROOT if not specified.
if(NOT DEFINED SFML_ROOT)
    cm_message_debug(STATUS "Setting SFML_ROOT.")
    set(SFML_ROOT ${SFML_HOME} CACHE PATH "Root of the SFML." FORCE)
endif()

# Locate official package.
find_package(SFML COMPONENTS ${CustomSFML_FIND_COMPONENTS})


# ************************************************************
# Create search path
set(SFML_PREFIX_PATH ${SFML_HOME})


# ************************************************************
# Clear
# Set components.
set(Modules "")
foreach(Var ${CustomSFML_FIND_COMPONENTS})
    string(TOUPPER ${Var} ComponentUpper)
    set(Modules
        ${Modules}
        SFML_${ComponentUpper}_LIBRARY_STATIC_RELEASE
        SFML_${ComponentUpper}_LIBRARY_STATIC_DEBUG
        SFML_${ComponentUpper}_LIBRARY_DYNAMIC_RELEASE
        SFML_${ComponentUpper}_LIBRARY_DYNAMIC_DEBUG
    )
    if(WIN32)
        set(Modules ${Modules} SFML_${ComponentUpper}_BINARY_RELEASE SFML_${ComponentUpper}_BINARY_DEBUG)
    endif()
endforeach()

# Set what to trigger the clears.
set(SFML_CLEAR_IF_CHANGED
    SFML_HOME
    SFML_STATIC_LIBRARIES
    CustomSFML_FIND_COMPONENTS
)

# Clear.
foreach(Var ${SFML_CLEAR_IF_CHANGED})
    package_clear_if_changed(${Var}
        SFML_INCLUDE_DIR
        SFML_ROOT
        ${Modules}
    )
endforeach()



# ************************************************************
# Find binaries on Windows
if(WIN32 AND NOT SFML_STATIC_LIBRARIES)
    if(SFML_INCLUDE_DIR)
        # Find version and append.
        set(ConfigInput "${SFML_INCLUDE_DIR}/SFML/Config.hpp")
        FILE(READ "${ConfigInput}" InputContents)
        STRING(REGEX REPLACE ".*#define SFML_VERSION_MAJOR ([0-9]+).*" "\\1" SFML_VERSION_MAJOR "${InputContents}")
        STRING(REGEX REPLACE ".*#define SFML_VERSION_MINOR ([0-9]+).*" "\\1" SFML_VERSION_MINOR "${InputContents}")
        STRING(REGEX REPLACE ".*#define SFML_VERSION_PATCH ([0-9]+).*" "\\1" SFML_VERSION_PATCH "${InputContents}")

        # Search path.
        package_create_search_path_binary(SFML)
        set(SFML_SEARCH_BINARIES
            ${SFML_SEARCH_PATH_BINARY}
            ${SSFML_SEARCH_PATH_LIBRARY}
        )

        set(SFML_BINARY_DEBUG "")
        set(SFML_BINARY_RELEASE "")
        foreach(Var ${CustomSFML_FIND_COMPONENTS})
            set(SFML_BINARY_NAMES "sfml-${Var}")
            package_create_debug_names(SFML_BINARY_NAMES)
            package_append_names(SFML_BINARY_NAMES "-${SFML_VERSION_MAJOR}")
            package_append_names(SFML_BINARY_NAMES_DEBUG "-${SFML_VERSION_MAJOR}")

            # Create binary names.

            package_create_release_binary_names(SFML_BINARY_NAMES)
            package_create_binary_names(SFML_BINARY_NAMES_DEBUG)

            # Find binaries.
            string(TOUPPER ${Var} ComponentUpper)
            package_find_file(SFML_${ComponentUpper}_BINARY_DEBUG "${SFML_BINARY_NAMES_DEBUG}" "${SFML_SEARCH_BINARIES}" "debug")
            package_find_file(SFML_${ComponentUpper}_BINARY_RELEASE "${SFML_BINARY_NAMES_RELEASE}" "${SFML_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")

            set(SFML_BINARY_DEBUG ${SFML_BINARY_DEBUG} "${SFML_${ComponentUpper}_BINARY_DEBUG}")
            set(SFML_BINARY_RELEASE ${SFML_BINARY_RELEASE} "${SFML_${ComponentUpper}_BINARY_RELEASE}")

            unset(SFML_BINARY_NAMES_DEBUG)
            unset(SFML_BINARY_NAMES_RELEASE)
            unset(SFML_${ComponentUpper}_BINARY_DEBUG)
            unset(SFML_${ComponentUpper}_BINARY_RELEASE)
        endforeach()
    endif()
endif()


# ************************************************************
# Finalize package
package_validate(SFML)
package_add_parent_dir(SFML)
package_end(SFML)
cm_message_footer(SFML)
