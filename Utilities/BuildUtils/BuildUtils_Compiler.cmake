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


# ************************************************************
# Add C compiler flag
# ************************************************************
macro(CM_COMPILER_C_ADD_FLAGS Value)
    cm_add_value(Project_COMPILER_C_FLAGS
        ${Value}
        AS_STRING
        CACHING
        Description "Flags for the C compiler."
    )
endmacro()




# ************************************************************
# Initialise C++ compiler standard
# ************************************************************
macro(CM_COMPILER_CXX_INITIALISE_STANDARD)
    set(_cxxStdName "Manually specified")
    if(CMAKE_CXX_COMPILER_ID)
        # Option for C++ standard.
        set(Project_COMPILER_CXX_STANDARD "ISO C++11" CACHE STRING "Select C++ standards.")
        set_property(
            CACHE Project_COMPILER_CXX_STANDARD PROPERTY
            STRINGS "Legacy C++ 98" "ISO C++11" "ISO C++14" "ISO C++17" "ISO C++20"
        )


        # Apply C++ standard.
        if(Project_COMPILER_CXX_APPLY_STANDARD)
            if(Project_COMPILER_CXX_STANDARD STREQUAL "ISO C++20")
                set(_cxxStdName "ISO C++20")
                set(_cxxStdFlag "-std=c++20")
                set(_cxxStdDef "CXX20_SUPPORT")
            elseif(Project_COMPILER_CXX_STANDARD STREQUAL "ISO C++17")
                set(_cxxStdName "ISO C++17")
                set(_cxxStdFlag "-std=c++17")
                set(_cxxStdDef "CXX17_SUPPORT")
            elseif(Project_COMPILER_CXX_STANDARD STREQUAL "ISO C++14")
                set(_cxxStdName "ISO C++14")
                set(_cxxStdFlag "-std=c++14")
                set(_cxxStdDef "CXX14_SUPPORT")
            elseif(Project_COMPILER_CXX_STANDARD STREQUAL "ISO C++11")
                set(_cxxStdName "ISO C++11")
                set(_cxxStdFlag "-std=c++11")
                set(_cxxStdDef "CXX11_SUPPORT")
            else()
                set(_cxxStdName "Legacy C++ 98")
            endif()

            # Reauired CMake macro "check_cxx_compiler_flag".
            # NB! This will be perfom just once.
            # Lower version of CMake there was no flag check, so we assume that the flags are supported by the compiler.
            if(_cxxStdDef)
                if(CMAKE_MAJOR_VERSION GREATER 2)
                    if(NOT ${_cxxStdDef}_STATE)
                        cm_message_status(STATUS "Check supported flag: ${_cxxStdFlag}")
                    endif()

                    check_cxx_compiler_flag(${_cxxStdFlag} ${_cxxStdDef}_STATE)
                    if(NOT ${_cxxStdDef}_STATE)
                        cm_message_status("" "The compiler has no support for C++ standard ${_cxxStdName}.")
                        set(_cxxStdName "Legacy C++ 98")
                        unset(_cxxStdFlag)
                    endif()
                endif()
            endif()

            if(_cxxStdFlag)
                cm_message_debug(STATUS "Add C++ flag (${_cxxStdFlag}).")
                list(APPEND Project_COMPILER_CXX_INTERNAL_STANDARD ${_cxxStdFlag})

                if(_cxxStdDef)
                    cm_add_definition(CXX_STANDARD_SUPPORT)
                    cm_add_definition(${_cxxStdDef})
                endif()
            endif()
        endif()
    endif()

    cm_message_status(STATUS "C++ Standard: ${_cxxStdName}")
    unset(_cxxStdFlag)
    unset(_cxxStdName)
    unset(_cxxStdDef)
endmacro()




# ************************************************************
# Initialise compiler flags
# ************************************************************
macro(CM_COMPILER_INITIALISE_FLAGS)
    # Ref: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

    set(Project_COMPILER_INTERNAL_FLAG_OPTIONS "")
    set(Compiler_FLAG_OPTION "" CACHE STRING "Compiler options.")
    set_property(CACHE Compiler_FLAG_OPTION PROPERTY STRINGS "" "Default" "All Off")


    # List available flags.
    cm_compiler_flag_setup_init("")

    # Make changes based on the option.
    if(Compiler_FLAG_OPTION)
        if(${Compiler_FLAG_OPTION} STREQUAL "Default")
            cm_compiler_flag_setup_default()
        elseif(${Compiler_FLAG_OPTION} STREQUAL "All Off")
            cm_compiler_flag_setup_init(FORCE)
        endif()
    endif()


    message("GNU Compiler: ${CMAKE_COMPILER_IS_GNUCC}")
    message("GNU Compiler: ${CMAKE_COMPILER_IS_GNUCXX}")
endmacro()




# ************************************************************
# Set compiler flag option
# ************************************************************
# ----------------------------------------
# Wall
# ----------------------------------------
macro(CM_COMPILER_FLAG_WALL Value Force)
    set(Compiler_FLAG_WAll
        "${Value}"
        CACHE STRING
        "This enables all the warnings about constructions that
        some users consider questionable, and that are easy to avoid
        (or modify to prevent the warning), even in conjunction with macros."
        ${Force}
    )

    set_property(CACHE Compiler_FLAG_WAll PROPERTY STRINGS "" "-Wall")
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WAll)
endmacro()


# ----------------------------------------
# Wcast_qual
# ----------------------------------------
macro(CM_COMPILER_FLAG_WCastQual Value Force)
    set(Compiler_FLAG_WCastQual
        "${Value}"
        CACHE STRING
        "Warn whenever a pointer is cast so as to remove a type qualifier
        from the target type. For example, warn if a const char * is cast
        to an ordinary char *."
        ${Force}
    )

    set_property(CACHE Compiler_FLAG_WCastQual PROPERTY STRINGS "" "-Wcast-qual" "-Wno-cast-qual")
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WCastQual)
endmacro()


# ----------------------------------------
# Werror
# ----------------------------------------
macro(CM_COMPILER_FLAG_WError Value Force)
    set(Compiler_FLAG_WError
        CACHE STRING
        "Make all warnings into errors."
        ${Force}
    )

    set_property(CACHE Compiler_FLAG_WError PROPERTY STRINGS "" "-Werror")
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WError)
endmacro()


# ----------------------------------------
# Wextra
# ----------------------------------------
macro(CM_COMPILER_FLAG_WExtra Value Force)
    set(Compiler_FLAG_WExtra
        "${Value}"
        CACHE STRING
        "This enables some extra warning flags that are not enabled by -Wall."
        ${Force}
    )

    set_property(CACHE Compiler_FLAG_WExtra PROPERTY STRINGS "" "-Wextra")
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WExtra)
endmacro()


# ----------------------------------------
# Winit_self
# ----------------------------------------
macro(CM_COMPILER_FLAG_WInitSelf Value Force)
    set(Compiler_FLAG_WInitSelf
        "${Value}"
        CACHE STRING
        "Warn about uninitialized variables that are initialized
        with themselves. Note this option can only be used with the
        -Wuninitialized option."
        ${Force}
    )

    set_property(CACHE Compiler_FLAG_WInitSelf PROPERTY STRINGS "" "-Winit-self")
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WInitSelf)
endmacro()


# ----------------------------------------
# Wmissing_field_initializers
# ----------------------------------------
macro(CM_COMPILER_FLAG_WMissingFieldInit Value Force)
    set(Compiler_FLAG_WMissingFieldInit
        "${Value}"
        CACHE STRING
        "Warn if a structure’s initializer has some fields missing."
        ${Force}
    )

    set_property(
        CACHE
        Compiler_FLAG_WMissingFieldInit
        PROPERTY
        STRINGS "" "-Wmissing-field-initializers" "-Wno-missing-field-initializers"
    )
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WMissingFieldInit)
endmacro()


# ----------------------------------------
# Wpedantic
# ----------------------------------------
macro(CM_COMPILER_FLAG_WPedantic Value Force)
    set(Compiler_FLAG_WPedantic
        "${Value}"
        CACHE STRING
        "Issue all the warnings demanded by strict ISO C and ISO C++;
        reject all programs that use forbidden extensions, and some
        other programs that do not follow ISO C and ISO C++."
        ${Force}
    )

    set_property(CACHE Compiler_FLAG_WPedantic PROPERTY STRINGS "" "-Wpedantic")
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WPedantic)
endmacro()


# ----------------------------------------
# Wunused_parameter
# ----------------------------------------
macro(CM_COMPILER_FLAG_WUnusedParameter Value Force)
    set(Compiler_FLAG_WUnusedParameter
        "${Value}"
        CACHE STRING "Warn whenever a function parameter is unused aside from its declaration."
        ${Force}
    )

    set_property(
        CACHE
        Compiler_FLAG_WUnusedParameter
        PROPERTY
        STRINGS "" "-Wshadow=local" "-Wshadow=global" "-Wshadow " "-Wno-shadow-ivar")
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WUnusedParameter)
endmacro()


# ----------------------------------------
# Wshadow
# ----------------------------------------
macro(CM_COMPILER_FLAG_WShadow Value Force)
    set(Compiler_FLAG_WShadow
        "${Value}"
        CACHE STRING
        "Warn whenever a local variable or type declaration
        shadows another variable, parameter, type, class member
        (in C++), or instance variable (in Objective-C) or
        whenever a built-in function is shadowed."
        ${Force}
    )

    set_property(
        CACHE
        Compiler_FLAG_WShadow
        PROPERTY
        STRINGS "" "-Wunused-parameter" "-Wno-unused-parameter"
    )
    cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WShadow)
endmacro()




# ************************************************************
# (Helper Function) Setup compiler flags
# ************************************************************
# Initialise values.
macro(CM_COMPILER_FLAG_SETUP_INIT Force)
    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        cm_compiler_flag_werror("" "${Force}")
        cm_compiler_flag_wpedantic("" "${Force}")
    elseif(${CMAKE_CXX_COMPILER_ID} STREQUAL GNU)
        cm_compiler_flag_wall("" "${Force}")
        cm_compiler_flag_wcastqual("" "${Force}")
        cm_compiler_flag_werror("" "${Force}")
        cm_compiler_flag_wextra("" "${Force}")
        cm_compiler_flag_winitself("" "${Force}")
        cm_compiler_flag_wmissingfieldinit("" "${Force}")
        cm_compiler_flag_wpedantic("" "${Force}")
        cm_compiler_flag_wshadow("" "${Force}")
        cm_compiler_flag_wunusedparameter("" "${Force}")
    endif()
endmacro()

# Default values.
macro(CM_COMPILER_FLAG_SETUP_DEFAULT)
    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        cm_compiler_flag_werror("" FORCE)
        cm_compiler_flag_wpedantic("-Wpedantic" FORCE)
    elseif(${CMAKE_CXX_COMPILER_ID} STREQUAL GNU)
        cm_compiler_flag_wall("" FORCE)
        cm_compiler_flag_wcastqual("" FORCE)
        cm_compiler_flag_werror("" FORCE)
        cm_compiler_flag_wextra("" FORCE)
        cm_compiler_flag_winitself("" FORCE)
        cm_compiler_flag_wmissingfieldinit("" FORCE)
        cm_compiler_flag_wpedantic("-Wpedantic" FORCE)
        cm_compiler_flag_wshadow("" FORCE)
        cm_compiler_flag_wunusedparameter("" FORCE)
    endif()
endmacro()

