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
# Add C Compiler Flag
# ************************************************************
macro(CM_COMPILER_C_ADD_FLAGS Value)
    cm_add_value(PROJECT_COMPILER_C_ENABLE_FLAGS
        ${Value}
        AS_STRING
        CACHING
        Description "Flags for the C compiler."
    )
endmacro()




# ************************************************************
# Initialise C++ Compiler Standard
# ************************************************************
macro(CM_COMPILER_CXX_INITIALISE_STANDARD)
    set(_cxxStdName "Manually specified")
    if(CMAKE_CXX_COMPILER_ID)
        # Option for C++ standard.
        cm_user_compiler_cxx_standard(11 "")

        # Apply C++ standard.
        if(PROJECT_COMPILER_CXX_ENABLE_STANDARD)
            # Alternative:
            # Use CMAKE_CXX_STANDARD [Value]
            if(PROJECT_COMPILER_CXX_ENABLE_STANDARD_MODE STREQUAL "ISO C++20")
                set(_cxxStdName "ISO C++20")
                set(_cxxStdFlag "-std=c++20")
                set(_cxxStdDef "20")
            elseif(PROJECT_COMPILER_CXX_ENABLE_STANDARD_MODE STREQUAL "ISO C++17")
                set(_cxxStdName "ISO C++17")
                set(_cxxStdFlag "-std=c++17")
                set(_cxxStdDef "17")
            elseif(PROJECT_COMPILER_CXX_ENABLE_STANDARD_MODE STREQUAL "ISO C++14")
                set(_cxxStdName "ISO C++14")
                set(_cxxStdFlag "-std=c++14")
                set(_cxxStdDef "14")
            elseif(PROJECT_COMPILER_CXX_ENABLE_STANDARD_MODE STREQUAL "ISO C++11")
                set(_cxxStdName "ISO C++11")
                set(_cxxStdFlag "-std=c++11")
                set(_cxxStdDef "11")
            else()
                set(_cxxStdName "Legacy C++ 98")
            endif()

            # Reauired CMake macro "check_cxx_compiler_flag".
            # NB! This will be perfom just once.
            # Lower version of CMake there was no flag check, so we assume that the flags are supported by the compiler.
            if(_cxxStdFlag)
                if(CMAKE_MAJOR_VERSION GREATER 2)
                    if(NOT CXX_HAS_STANDARD${_cxxStdDef})
                        cm_message_status(STATUS "Check supported flag: ${_cxxStdFlag}")
                    endif()

                    check_cxx_compiler_flag(${_cxxStdFlag} CXX_HAS_STANDARD${_cxxStdDef})
                    if(NOT CXX_HAS_STANDARD${_cxxStdDef})
                        cm_message_status("" "The compiler has no support for C++ standard ${_cxxStdName}.")
                        set(_cxxStdName "Legacy C++ 98")
                        unset(_cxxStdFlag)
                    endif()
                endif()
            endif()

            if(_cxxStdFlag)
                cm_message_debug(STATUS "Add C++ flag (${_cxxStdFlag}).")
                list(APPEND PROJECT_COMPILER_CXX_INTERNAL_STANDARD ${_cxxStdFlag})

                # Add value as definition so we can access in our code.
                if(_cxxStdDef)
                    cm_add_definition(CXX_STANDARD_SUPPORT)
                    cm_add_definition(CXX_STANDARD_VERSION=${_cxxStdDef})
                endif()
            endif()
        endif()
    endif()


    # New C++ features are supported from Visual Studio 2013 (v12.0).
#        if(MSVC_VERSION GREATER 1700)
#            set(PROJECT_COMPILER_NEW_CXX_SUPPORT TRUE)
#        else()
#            cm_message_status("" "The compiler ${CMAKE_CXX_COMPILER} has no support for new C++ features. This feature are available from Visual Studio 2013 (v12.0).")
#            set(PROJECT_COMPILER_NEW_CXX_SUPPORT FALSE)
#        endif()

    cm_message_status(STATUS "C++ Standard: ${_cxxStdName}")
    unset(_cxxStdFlag)
    unset(_cxxStdName)
    unset(_cxxStdDef)
endmacro()




# ************************************************************
# Initialise Compiler Flags
# ************************************************************
macro(CM_COMPILER_INITIALISE_FLAGS)
    # Ref: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

    set(PROJECT_COMPILER_C_INTERNAL_FLAGS "")
    set(PROJECT_COMPILER_CXX_INTERNAL_FLAGS "")
    set(PROJECT_COMPILER_CXX_INTERNAL_STANDARD "")
    set(PROJECT_COMPILER_INTERNAL_FLAGS "")
    set(PROJECT_COMPILER_ENABLE_FLAGS_OPTION "" CACHE STRING "Select predefined flags under 'Compiler' category.")
    set_property(CACHE PROJECT_COMPILER_ENABLE_FLAGS_OPTION PROPERTY STRINGS "" "Default" "All On" "All Off")
    option(PROJECT_COMPILER_CHECK_FLAGS "Verify check of the compiler flags." OFF)

    # Project compiler flags.
    # This usual clould be empty, as the user could select available flags from the GUI.
    set(PROJECT_COMPILER_ENABLE_FLAGS "" CACHE STRING "Flags for the compiler (seperate with comma).")
    option(PROJECT_COMPILER_ENABLE_FLAG "Apply selected compiler flags." ON)


    # C compiler.
    if(CMAKE_C_COMPILER_LOADED)
        set(PROJECT_COMPILER_C_ENABLE_FLAGS "" CACHE STRING "Flags for the C compiler (seperate with comma).")
        option(PROJECT_COMPILER_C_ENABLE_FLAG "Apply selected C compiler flags." ON)
    endif()


    # CXX compiler.
    if(CMAKE_CXX_COMPILER_LOADED)
        set(PROJECT_COMPILER_CXX_ENABLE_FLAGS "" CACHE STRING "Flags for the CXX compiler (seperate with comma).")
        option(PROJECT_COMPILER_CXX_ENABLE_FLAG "Apply selected CXX compiler flags." ON)
        option(PROJECT_COMPILER_CXX_ENABLE_STANDARD "Apply selected CXX compiler standard." OFF)
        cm_compiler_cxx_initialise_standard()
    endif()


    # Make changes based on the option.
    if(PROJECT_COMPILER_ENABLE_FLAGS_OPTION)
        if(${PROJECT_COMPILER_ENABLE_FLAGS_OPTION} STREQUAL "Default")
            cm_compiler_flag_setup_default()
        elseif(${PROJECT_COMPILER_ENABLE_FLAGS_OPTION} STREQUAL "All On")
            cm_compiler_flag_setup_all_on()
        elseif(${PROJECT_COMPILER_ENABLE_FLAGS_OPTION} STREQUAL "All Off")
            cm_compiler_flag_setup_init(FORCE)
        endif()
    else()
        # List available flags.
        cm_compiler_flag_setup_init("")
    endif()
endmacro()




# ************************************************************
# Add Support for Multithreaded Compilation
# ************************************************************
# NB! May not be needed!
macro(CM_COMPILER_MULTITHREADED_COMPILATION Variable)
    if(PROJECT_COMPILER_MULTITHREADED_FLAG)
        cm_message_status(STATUS "Add multithreaded compilation (${PROJECT_COMPILER_MULTITHREADED_FLAG}).")
        list(APPEND Variable "${PROJECT_COMPILER_MULTITHREADED_FLAG}")
    endif()
endmacro()




# ************************************************************
# Set Compiler Flag Option
# ************************************************************
# ----------------------------------------
# Multithreaded Compilation
# ----------------------------------------
# For MSCV: Use /MD[N], where N is number of cores. Without N the system will
#           use maximum available cores.
# For UNIX / MinGW: Use the flag -j X, where X is number of cores, for make program.
macro(CM_COMPILER_FLAG_MULTITHREADED_COMPILATION Value Force)
    if(MSVC)
        set(Compiler_Flag_MultithreadedCompilation
            "${Value}"
            CACHE STRING
            "This enables multiple compilation."
            ${Force}
        )
        set_property(CACHE Compiler_Opt_MultithreadedCompilation PROPERTY STRINGS "" "/MP")

        set(_maxCores 1)
        ProcessorCount(_maxCores)
        set(Compiler_Flag_MultithreadedCompilation_Cores
            ""
            CACHE STRING
            "Number of cores to use (maximun ${_maxCores})."
        )

        set(PROJECT_COMPILER_MULTITHREADED_FLAG ${Compiler_Flag_MultithreadedCompilation})

        # Limit the maximum core.
        if(Compiler_Flag_MultithreadedCompilation_Cores)
            if(${Compiler_Flag_MultithreadedCompilation_Cores} GREATER ${_maxCores})
                cm_message_debug("" "Selected core(s) (${Compiler_Flag_MultithreadedCompilation_Cores}) exceed number of available core: ${_maxCores}.")
                cm_message_debug("" "Set to number of core to ${_maxCores}.")
                set(Compiler_Flag_MultithreadedCompilation_Cores ${_maxCores} FORCE)
            endif()
        endif()

        set_property(CACHE Compiler_Flag_MultiThreadedCompilation PROPERTY STRINGS "" "-j")
        set(PROJECT_COMPILER_MULTITHREADED_FLAG "${PROJECT_COMPILER_MULTITHREADED_FLAG}${Compiler_Flag_MultithreadedCompilation_Cores}")

        cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS PROJECT_COMPILER_MULTITHREADED_FLAG)
    endif()
endmacro()


# ----------------------------------------
# Wall
# ----------------------------------------
macro(CM_COMPILER_FLAG_WALL Value Force)
    set(Compiler_Flag_Wall
        "${Value}"
        CACHE STRING
        "Description:
        This enables all the warnings about constructions
        that some users consider questionable,
        and that are easy to avoid (or modify to prevent the warning),
        even in conjunction with macros."
        ${Force}
    )

    set_property(CACHE Compiler_Flag_Wall PROPERTY STRINGS "" "-Wall")
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_Wall)
endmacro()


# ----------------------------------------
# Wcast_qual
# ----------------------------------------
macro(CM_COMPILER_FLAG_WCASTQUAL Value Force)
    set(Compiler_Flag_WCastQual
        "${Value}"
        CACHE STRING
        "Description:
        Warn whenever a pointer is cast so as to remove a type qualifier
        from the target type. For example, warn if a const char * is
        cast to an ordinary char *."
        ${Force}
    )

    set_property(CACHE Compiler_Flag_WCastQual PROPERTY STRINGS "" "-Wcast-qual" "-Wno-cast-qual")
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_WCastQual)
endmacro()


# ----------------------------------------
# Werror
# ----------------------------------------
macro(CM_COMPILER_FLAG_WERROR Value Force)
    set(Compiler_Flag_WError
        CACHE STRING
        "Description:
        Make all warnings into errors."
        ${Force}
    )

    set_property(CACHE Compiler_Flag_WError PROPERTY STRINGS "" "-Werror")
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_WError)
endmacro()


# ----------------------------------------
# Wextra
# ----------------------------------------
macro(CM_COMPILER_FLAG_WEXTRA Value Force)
    set(Compiler_Flag_WExtra
        "${Value}"
        CACHE STRING
        "Description:
        This enables some extra warning flags that are not enabled by -Wall."
        ${Force}
    )

    set_property(CACHE Compiler_Flag_WExtra PROPERTY STRINGS "" "-Wextra")
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_WExtra)
endmacro()


# ----------------------------------------
# Winit_self
# ----------------------------------------
macro(CM_COMPILER_FLAG_WINITSELF Value Force)
    set(Compiler_Flag_WInitSelf
        "${Value}"
        CACHE STRING
        "Description:
        Warn about uninitialized variables that are initialized with themselves.
        Note this option can only be used with the -Wuninitialized option."
        ${Force}
    )

    set_property(CACHE Compiler_Flag_WInitSelf PROPERTY STRINGS "" "-Winit-self")
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_WInitSelf)
endmacro()


# ----------------------------------------
# Wmissing_field_initializers
# ----------------------------------------
macro(CM_COMPILER_FLAG_WMISSINGFIELDINIT Value Force)
    set(Compiler_Flag_WMissingFieldInit
        "${Value}"
        CACHE STRING
        "Description:
        Warn if a structure’s initializer has some fields missing."
        ${Force}
    )

    set_property(
        CACHE
        Compiler_Flag_WMissingFieldInit
        PROPERTY
        STRINGS "" "-Wmissing-field-initializers" "-Wno-missing-field-initializers"
    )
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_WMissingFieldInit)
endmacro()


# ----------------------------------------
# Wpedantic
# ----------------------------------------
macro(CM_COMPILER_FLAG_WPEDANTIC Value Force)
    set(Compiler_Flag_WPedantic
        "${Value}"
        CACHE STRING
        "Description:
        Issue all the warnings demanded by strict ISO C and ISO C++;
        reject all programs that use forbidden extensions,
        and some other programs that do not follow ISO C and ISO C++."
        ${Force}
    )

    set_property(CACHE Compiler_Flag_WPedantic PROPERTY STRINGS "" "-Wpedantic")
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_WPedantic)
endmacro()


# ----------------------------------------
# Wunused_parameter
# ----------------------------------------
macro(CM_COMPILER_FLAG_WUNUSEDPARAMETER Value Force)
    set(Compiler_Flag_WUnusedParameter
        "${Value}"
        CACHE STRING
        "Description:
        Warn whenever a function parameter is unused aside from its declaration."
        ${Force}
    )

    set_property(
        CACHE
        Compiler_Flag_WUnusedParameter
        PROPERTY
        STRINGS "" "-Wunused-parameter" "-Wno-unused-parameter"
    )
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_WUnusedParameter)
endmacro()


# ----------------------------------------
# Wshadow
# ----------------------------------------
macro(CM_COMPILER_FLAG_WSHADOW Value Force)
    set(Compiler_Flag_WShadow
        "${Value}"
        CACHE STRING
        "Description:
        Warn whenever a local variable or type declaration shadows
        another variable, parameter, type, class member (in C++),
        or instance variable (in Objective-C) or whenever a built-in
        function is shadowed."
        ${Force}
    )

    set_property(
        CACHE
        Compiler_Flag_WShadow
        PROPERTY
        STRINGS "" "-Wshadow=local" "-Wshadow=global" "-Wshadow " "-Wno-shadow-ivar"
    )
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Flag_WShadow)
endmacro()




# ************************************************************
# Set Compiler Flag Option (Visual Studio)
# ************************************************************
# REF: https://docs.microsoft.com/en-us/cpp/error-messages/compiler-errors-1/c-cpp-build-errors
# ----------------------------------------
# Warning
# ----------------------------------------
macro(CM_COMPILER_MSCV_FLAG_WARNING Value Force)
    set(Compiler_Msvc_Flag_Warning
        "${Value}"
        CACHE STRING
        "Description:
        /w - Suppresses compiler warnings.
        /W[0-4] - Specifies the level of warnings to be generated by the compiler.
        /Wall - Equivalent to /W4."
        ${Force}
    )

    set_property(
        CACHE
        Compiler_Msvc_Flag_Warning
        PROPERTY
        STRINGS "" "/w" "/W0" "/W1" "/W2" "/W3" "/W4" "/Wall"
    )

    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Msvc_Flag_Warning)
endmacro()


# ----------------------------------------
# C4018
# ----------------------------------------
macro(CM_COMPILER_MSCV_FLAG_C4018 Value Force)
    cm_compiler_msvc_setup_warning(
        Compiler_Msvc_Flag_C4018
        "4018"
        "'expression': signed/unsigned mismatch."
        "${Value}"
        "${Force}"
    )
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Msvc_Flag_C4018)
endmacro()


# ----------------------------------------
# C4244
# ----------------------------------------
macro(CM_COMPILER_MSCV_FLAG_C4244 Value Force)
    cm_compiler_msvc_setup_warning(
        Compiler_Msvc_Flag_C4244
        "4244"
        "'conversion_type': conversion from 'type1' to 'type2', possible loss of data."
        "${Value}"
        "${Force}"
    )
    cm_add_value(PROJECT_COMPILER_INTERNAL_FLAGS Compiler_Msvc_Flag_C4244)
endmacro()




# ************************************************************
# (Helper Function) Setup Compiler Flags
# ************************************************************
# Initialise values.
macro(CM_COMPILER_FLAG_SETUP_INIT Force)
    # NB! Implement this way in order to have a nice sorted list on the GUI.
    # ----------------------------------------
    # Clang
    # ----------------------------------------
    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        cm_compiler_flag_multithreaded_compilation("" "${Force}")

        cm_compiler_flag_wall("" "${Force}")
        cm_compiler_flag_wcastqual("" "${Force}")
        cm_compiler_flag_wextra("" "${Force}")
        cm_compiler_flag_winitself("" "${Force}")
        cm_compiler_flag_wmissingfieldinit("" "${Force}")
        cm_compiler_flag_wpedantic("" "${Force}")
        cm_compiler_flag_wshadow("" "${Force}")
        cm_compiler_flag_wunusedparameter("" "${Force}")
    endif()


    # ----------------------------------------
    # GNU
    # ----------------------------------------
    if(${CMAKE_CXX_COMPILER_ID} STREQUAL GNU)
        cm_compiler_flag_multithreaded_compilation("" "${Force}")

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


# All on values.
macro(CM_COMPILER_FLAG_SETUP_ALL_ON)
    # TST 20210524
    # TODO: Specify all these values.
    # ----------------------------------------
    # Clang
    # ----------------------------------------
    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        cm_compiler_flag_multithreaded_compilation("/MD" FORCE)

        cm_compiler_flag_wall("-Wall" FORCE)
        cm_compiler_flag_wcastqual("" FORCE)
        cm_compiler_flag_wextra("-Wextra" FORCE)
        cm_compiler_flag_winitself("" FORCE)
        cm_compiler_flag_wmissingfieldinit("" FORCE)
        cm_compiler_flag_wpedantic("-Wpedantic" FORCE)
        cm_compiler_flag_wshadow("-Wshadow" FORCE)
        cm_compiler_flag_wunusedparameter("-Wunused-parameter" FORCE)
    endif()


    # ----------------------------------------
    # GNU
    # ----------------------------------------
    if(${CMAKE_CXX_COMPILER_ID} STREQUAL GNU)
        cm_compiler_flag_multithreaded_compilation("/MD" FORCE)

        cm_compiler_flag_wall("" FORCE)
        cm_compiler_flag_wcastqual("" FORCE)
        cm_compiler_flag_werror("" FORCE)
        cm_compiler_flag_wextra("" FORCE)
        cm_compiler_flag_winitself("" FORCE)
        cm_compiler_flag_wmissingfieldinit("" FORCE)
        cm_compiler_flag_wpedantic("" FORCE)
        cm_compiler_flag_wshadow("" FORCE)
        cm_compiler_flag_wunusedparameter("" FORCE)
    endif()
endmacro()


# Default values.
macro(CM_COMPILER_FLAG_SETUP_DEFAULT)
    # TST 20210524
    # TODO: Find useful flags to set as default.
    # ----------------------------------------
    # Clang
    # ----------------------------------------
    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        cm_compiler_flag_multithreaded_compilation("/MD" FORCE)

        cm_compiler_flag_wall("-Wall" FORCE)
        cm_compiler_flag_wcastqual("" FORCE)
        cm_compiler_flag_wextra("" FORCE)
        cm_compiler_flag_winitself("" FORCE)
        cm_compiler_flag_wmissingfieldinit("" FORCE)
        cm_compiler_flag_wpedantic("-Wpedantic" FORCE)
        cm_compiler_flag_wshadow("-Wshadow" FORCE)
        cm_compiler_flag_wunusedparameter("" FORCE)
    endif()


    # ----------------------------------------
    # GNU
    # ----------------------------------------
    if(${CMAKE_CXX_COMPILER_ID} STREQUAL GNU)
        cm_compiler_flag_multithreaded_compilation("/MD" FORCE)

        cm_compiler_flag_wall("-Wall" FORCE)
        cm_compiler_flag_wcastqual("" FORCE)
        cm_compiler_flag_werror("" FORCE)
        cm_compiler_flag_wextra("" FORCE)
        cm_compiler_flag_winitself("" FORCE)
        cm_compiler_flag_wmissingfieldinit("" FORCE)
        cm_compiler_flag_wpedantic("-Wpedantic" FORCE)
        cm_compiler_flag_wshadow("-Wshadow" FORCE)
        cm_compiler_flag_wunusedparameter("" FORCE)
    endif()
endmacro()




# ************************************************************
# Setup Visual Studio Warning
# ************************************************************
macro(CM_COMPILER_MSVC_SETUP_WARNING Prefix ID Desc Value Force)
    set(${Prefix}
        "${Value}"
        CACHE STRING
        "Description:
        ${Desc}
        /w[1-4] - The warning level.
        /wd - Suppresses the compiler warning.
        /we - Treats the compiler warning as an error.
        /wn - Reports the compiler warning only once."
        ${Force}
    )

    set_property(
        CACHE
        ${Prefix}
        PROPERTY
        STRINGS
        "" "/w1${ID}" "/w2${ID}" "/w3${ID}" "/w4${ID}"
        "/wd${ID}" "/we${ID}" "/wn${ID}"
    )
endmacro()




# ************************************************************
# User Customization
# ************************************************************
# ----------------------------------------
# Default C++ Standard Version
# ----------------------------------------
macro(CM_USER_COMPILER_CXX_STANDARD Value)
    set(_iso "ISO C++11")
    if(${Value} EQUAL 11)
        set(_iso "ISO C++11")
    elseif(${Value} EQUAL 14)
        set(_iso "ISO C++14")
    elseif(${Value} EQUAL 17)
        set(_iso "ISO C++17")
    elseif(${Value} EQUAL 20)
        set(_iso "ISO C++20")
    else()
        set(_iso "Legacy C++ 98")
    endif()

    set(_force FORCE)
    if(${ARGC} GREATER 1)
        set(_force "")
    endif()

    set(PROJECT_COMPILER_CXX_ENABLE_STANDARD_MODE "${_iso}" CACHE STRING "Select C++ standards." ${_force})
    set_property(
        CACHE PROJECT_COMPILER_CXX_ENABLE_STANDARD_MODE PROPERTY
        STRINGS "Legacy C++ 98" "ISO C++11" "ISO C++14" "ISO C++17" "ISO C++20"
    )

    unset(_iso)
    unset(_force)
endmacro()