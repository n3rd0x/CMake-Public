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
# Website: https://www.libsdl.org


# ************************************************************
# Start package
message_header(SDL)
package_begin(SDL)
package_create_home_path(SDL SDL_ROOT)

# Select version.
set(SDL_VERSION "2" CACHE STRING "Select SDL version.")
set_property(CACHE SDL_VERSION PROPERTY STRINGS 2 1) 

message_status(STATUS "Current SDL version: ${SDL_VERSION}")


# ************************************************************
# Create search path
set(SDL_PREFIX_PATH ${SDL_HOME})
package_create_search_path_include(SDL)
package_create_search_path_library(SDL)


# ************************************************************
# Create search name
set(SDL_LIBRARY_NAME_COMMON "SDL${SDL_VERSION}")
set(SDL_LIBRARY_NAME_IMAGE "SDL${SDL_VERSION}_image")
set(SDL_LIBRARY_NAME_MAIN "SDL${SDL_VERSION}main")
package_create_debug_names(SDL_LIBRARY_NAME_COMMON)
package_create_debug_names(SDL_LIBRARY_NAME_IMAGE)
package_create_debug_names(SDL_LIBRARY_NAME_MAIN)


# ************************************************************
# Clear
package_clear_if_changed(SDL_PREFIX_PATH
    SDL_BINARY_DEBUG
    SDL_BINARY_RELEASE
    SDL_BINARY_IMAGE_DEBUG
    SDL_BINARY_IMAGE_RELEASE
    SDL_LIBRARY_COMMON_DEBUG
    SDL_LIBRARY_COMMON_RELEASE
    SDL_LIBRARY_IMAGE_DEBUG
    SDL_LIBRARY_IMAGE_RELEASE
    SDL_LIBRARY_MAIN_DEBUG
    SDL_LIBRARY_MAIN_RELEASE
    SDL_PATH_INCLUDE
)


# ************************************************************
# Find paths
package_find_path(SDL_PATH_INCLUDE "SDL.h" "${SDL_SEARCH_PATH_INCLUDE}" "SDL2")

# Common library.
package_find_library(
    SDL_LIBRARY_COMMON_DEBUG
    "${SDL_LIBRARY_NAME_COMMON_DEBUG}"
    "${SDL_SEARCH_PATH_LIBRARY}"
    "debug"
)
package_find_library(
    SDL_LIBRARY_COMMON_RELEASE
    "${SDL_LIBRARY_NAME_COMMON}"
    "${SDL_SEARCH_PATH_LIBRARY}"
    "release"
)
package_make_library(SDL_LIBRARY_COMMON SDL_LIBRARY_COMMON_DEBUG SDL_LIBRARY_COMMON_RELEASE)

# Image library.
package_find_library(
    SDL_LIBRARY_IMAGE_DEBUG
    "${SDL_LIBRARY_NAME_IMAGE_DEBUG}"
    "${SDL_SEARCH_PATH_LIBRARY}"
    "debug"
)
package_find_library(
    SDL_LIBRARY_IMAGE_RELEASE
    "${SDL_LIBRARY_NAME_IMAGE}"
    "${SDL_SEARCH_PATH_LIBRARY}"
    "release"
)
package_make_library(SDL_LIBRARY_IMAGE SDL_LIBRARY_IMAGE_DEBUG SDL_LIBRARY_IMAGE_RELEASE)

# Main library.
package_find_library(
    SDL_LIBRARY_MAIN_DEBUG
    "${SDL_LIBRARY_NAME_MAIN_DEBUG}"
    "${SDL_SEARCH_PATH_LIBRARY}"
    "debug"
)
package_find_library(
    SDL_LIBRARY_MAIN_RELEASE
    "${SDL_LIBRARY_NAME_MAIN}"
    "${SDL_SEARCH_PATH_LIBRARY}"
    "release"
)
package_make_library(SDL_LIBRARY_MAIN SDL_LIBRARY_MAIN_DEBUG SDL_LIBRARY_MAIN_RELEASE)

# Make set.
if(SDL_LIBRARY_COMMON AND SDL_LIBRARY_MAIN)
    set(SDL_LIBRARY ${SDL_LIBRARY_COMMON} ${SDL_LIBRARY_MAIN})
    
    # Extension: Image.
    if(SDL_LIBRARY_IMAGE)
        message_status(STATUS "The SDL Image extension is located.")
        set(SDL_IMAGE_LIBRARIES ${SDL_LIBRARY_IMAGE})
    endif()
endif()




# ************************************************************
# Find binaries on Windows
if( WIN32 )
    set(SDL_BINARY_NAMES "SDL${SDL_VERSION}")
    package_create_release_binary_names(SDL_BINARY_NAMES)
    package_create_debug_binary_names(SDL_BINARY_NAMES)
    package_create_search_path_binary(SDL)
    
    set(SDL_SEARCH_BINARIES 
        ${SDL_SEARCH_PATH_BINARY}
        ${SDL_SEARCH_PATH_LIBRARY}
    )

    package_find_file(SDL_BINARY_DEBUG "${SDL_BINARY_NAMES_DEBUG}" "${SDL_SEARCH_BINARIES}" "debug")
    package_find_file(SDL_BINARY_RELEASE "${SDL_BINARY_NAMES_RELEASE}" "${SDL_SEARCH_BINARIES}" "release")
    
    # Extensions.
    if(SDL_LIBRARY_IMAGE)
        set(SDL_IMAGE_BINARY_NAMES "SDL${SDL_VERSION}_image")
        package_create_release_binary_names(SDL_IMAGE_BINARY_NAMES)
        package_create_debug_binary_names(SDL_IMAGE_BINARY_NAMES)
        package_find_file(SDL_IMAGE_BINARY_DEBUG "${SDL_IMAGE_BINARY_NAMES_DEBUG}" "${SDL_SEARCH_BINARIES}" "debug")
        package_find_file(SDL_IMAGE_BINARY_RELEASE "${SDL_IMAGE_BINARY_NAMES_RELEASE}" "${SDL_SEARCH_BINARIES}" "release")
        
        # Add dependencies.
        set(SDL_IMAGE_DEPS
            "libjpeg-9.dll"
            "libpng16-16.dll"
            "libtiff-5.dll"
            "libwebp-4.dll"
            "zlib1.dll"
        )
        
        foreach(VAR ${SDL_IMAGE_DEPS})
            package_find_file(SDL_${VAR}_IMAGE_BINARY_DEBUG "${VAR}" "${SDL_SEARCH_BINARIES}" "debug")
            if(SDL_${VAR}_IMAGE_BINARY_DEBUG)
                set(SDL_IMAGE_BINARY_DEBUG ${SDL_IMAGE_BINARY_DEBUG} ${SDL_${VAR}_IMAGE_BINARY_DEBUG})
            endif()
            
            package_find_file(SDL_${VAR}_IMAGE_BINARY_RELEASE "${VAR}" "${SDL_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
            if(SDL_${VAR}_IMAGE_BINARY_RELEASE )
                set(SDL_IMAGE_BINARY_RELEASE ${SDL_IMAGE_BINARY_RELEASE} ${SDL_${VAR}_IMAGE_BINARY_RELEASE})
            endif()

            unset(SDL_${VAR}_IMAGE_BINARY_DEBUG CACHE)
            unset(SDL_${VAR}_IMAGE_BINARY_RELEASE CACHE)
        endforeach()
    endif()
endif()


# ************************************************************
# Finalize package
package_validate(SDL)
package_add_parent_dir(SDL)
package_end(SDL)
message_footer(SDL)
