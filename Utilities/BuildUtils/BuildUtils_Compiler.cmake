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
# Initialise compiler flags
# ************************************************************
macro(CM_COMPILER_INITIALISE_FLAGS)
    # Ref: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

    set(Project_COMPILER_INTERNAL_FLAG_OPTIONS "")
    cm_compiler_flag_wall("" "" "-Wall")
    cm_compiler_flag_werror("" "" "-Werror")
    cm_compiler_flag_wextra("" "" "-Wextra")
    cm_compiler_flag_wcastqual("" "" "-Wcast-qual;-Wno-cast-qual")
    cm_compiler_flag_winitself("" "" "-Winit-self")
    cm_compiler_flag_wmissingfieldinit("" "" "-Wmissing-field-initializers;-Wno-missing-field-initializers")
    cm_compiler_flag_wpedantic("" "" "-pedantic")
    cm_compiler_flag_wshadow("" "" "-Wshadow=local;-Wshadow=global;-Wshadow;-Wno-shadow-ivar")
    cm_compiler_flag_wunusedparameter("" "" "-Wunused-parameter;-Wno-unused-parameter")
endmacro()




# ************************************************************
# Set compiler flag option
# ************************************************************
# ----------------------------------------
# Wall
# ----------------------------------------
macro(CM_COMPILER_FLAG_WALL Value Force Opts)
    set(Compiler_FLAG_WAll
        "${Value}"
        CACHE STRING
        "This enables all the warnings about constructions that
        some users consider questionable, and that are easy to avoid
        (or modify to prevent the warning), even in conjunction with macros."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WAll PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WAll)
    endif()
endmacro()


# ----------------------------------------
# Werror
# ----------------------------------------
macro(CM_COMPILER_FLAG_WError Value Force Opts)
    set(Compiler_FLAG_WError
        CACHE STRING
        "Make all warnings into errors."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WError PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WError)
    endif()
endmacro()


# ----------------------------------------
# Wcast_qual
# ----------------------------------------
macro(CM_COMPILER_FLAG_WCastQual Value Force Opts)
    set(Compiler_FLAG_WCastQual
        "${Value}"
        CACHE STRING
        "Warn whenever a pointer is cast so as to remove a type qualifier
        from the target type. For example, warn if a const char * is cast
        to an ordinary char *."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WCastQual PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WCastQual)
    endif()
endmacro()


# ----------------------------------------
# Wextra
# ----------------------------------------
macro(CM_COMPILER_FLAG_WExtra Value Force Opts)
    set(Compiler_FLAG_WExtra
        "${Value}"
        CACHE STRING
        "This enables some extra warning flags that are not enabled by -Wall."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WExtra PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WExtra)
    endif()
endmacro()


# ----------------------------------------
# Winit_self
# ----------------------------------------
macro(CM_COMPILER_FLAG_WInitSelf Value Force Opts)
    set(Compiler_FLAG_WInitSelf
        "${Value}"
        CACHE STRING
        "Warn about uninitialized variables that are initialized
        with themselves. Note this option can only be used with the
        -Wuninitialized option."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WInitSelf PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WInitSelf)
    endif()
endmacro()


# ----------------------------------------
# Wmissing_field_initializers
# ----------------------------------------
macro(CM_COMPILER_FLAG_WMissingFieldInit Value Force Opts)
    set(Compiler_FLAG_WMissingFieldInit
        "${Value}"
        CACHE STRING
        "Warn if a structure’s initializer has some fields missing."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WMissingFieldInit PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WMissingFieldInit)
    endif()
endmacro()


# ----------------------------------------
# Wpedantic
# ----------------------------------------
macro(CM_COMPILER_FLAG_WPedantic Value Force Opts)
    set(Compiler_FLAG_WPedantic
        "${Value}"
        CACHE STRING
        "Issue all the warnings demanded by strict ISO C and ISO C++;
        reject all programs that use forbidden extensions, and some
        other programs that do not follow ISO C and ISO C++."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WPedantic PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WPedantic)
    endif()
endmacro()


# ----------------------------------------
# Wunused_parameter
# ----------------------------------------
macro(CM_COMPILER_FLAG_WUnusedParameter Value Force Opts)
    set(Compiler_FLAG_WUnusedParameter
        "${Value}"
        CACHE STRING "Warn whenever a function parameter is unused aside from its declaration."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WUnusedParameter PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WUnusedParameter)
    endif()
endmacro()


# ----------------------------------------
# Wshadow
# ----------------------------------------
macro(CM_COMPILER_FLAG_WShadow Value Force Opts)
    set(Compiler_FLAG_WShadow
        "${Value}"
        CACHE STRING
        "Warn whenever a local variable or type declaration
        shadows another variable, parameter, type, class member
        (in C++), or instance variable (in Objective-C) or
        whenever a built-in function is shadowed."
        ${Force}
    )

    if(NOT Opts STREQUAL "")
        set_property(CACHE Compiler_FLAG_WShadow PROPERTY STRINGS "" ${Opts})
        cm_add_value(Project_COMPILER_INTERNAL_FLAG_OPTIONS Compiler_FLAG_WShadow)
    endif()
endmacro()




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
