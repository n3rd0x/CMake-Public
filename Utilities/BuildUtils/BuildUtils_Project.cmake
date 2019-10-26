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
# Apply project compiler options
# ************************************************************
# Apply compiler flags to CMake.
function(CM_PROJECT_COMPILER_APPLY_OPTIONS)
    if(Project_COMPILER_C_APPLY_FLAGS   OR
       Project_COMPILER_CXX_APPLY_FLAGS OR
       Project_COMPILER_CXX_APPLY_STANDARD)
        set(_flags "")

        cm_message_debug_header(STATUS "Checking available compiler flags")

        foreach(flag ${Project_COMPILER_INTERNAL_FLAG_OPTIONS})
            cm_append_list(_flags ${flag})
        endforeach()

        cm_message_debug_footer(STATUS "Checking available compiler flags")


        # ----------------------------------------
        # C Compiler
        # ----------------------------------------
        if(CMAKE_C_COMPILER_LOADED)
            set(_cFlags "")

            if(Project_COMPILER_C_APPLY_FLAGS)
                cm_message_status(STATUS "Apply COMPILER_C_FLAGS.")
                list(APPEND _cFlags ${_flags})

                if(Project_COMPILER_C_FLAGS)
                    cm_message_status(STATUS "Apply COMPILER_C_PROJECT_FLAGS.")

                    cm_message_debug_header(STATUS "Add flags from Project_COMPILER_C_FLAGS")

                    set(_cProFlags ${Project_COMPILER_C_FLAGS})
                    separate_arguments(_cProFlags)
                    foreach(flag ${_cProFlags})
                        cm_append_list(_cFlags flag)
                    endforeach()

                    cm_message_debug_footer(STATUS "Add flags from Project_COMPILER_C_FLAGS")
                endif()
            endif()


            if(_cFlags)
                list(REMOVE_DUPLICATES _cFlags)
                list(SORT _cFlags)

                cm_message_verbose(STATUS "Add following to CMAKE_C_FLAGS:")
                cm_message_verbose_output(STATUS "${_cFlags}")

                list(JOIN _cFlags " " _cFlags)
                set(CMAKE_C_FLAGS ${_cFlags} CACHE STRING "Flags used by C compiler during all build types." FORCE)
            endif()
            #unset(_cFlags)
        endif()




        # ----------------------------------------
        # C++ Compiler
        # ----------------------------------------
        if(CMAKE_C_COMPILER_LOADED)
            set(_cxxFlags "")

            if(Project_COMPILER_CXX_APPLY_FLAGS)
                cm_message_status(STATUS "Apply COMPILER_CXX_FLAGS.")
                list(APPEND _cxxFlags ${_flags})

                if(Project_COMPILER_CXX_FLAGS)
                    cm_message_status(STATUS "Apply COMPILER_CXX_PROJECT_FLAGS.")

                    cm_message_debug_header(STATUS "Add flags from Project_COMPILER_CXX_FLAGS")

                    set(_cProFlags ${Project_COMPILER_CXX_FLAGS})
                    separate_arguments(_cProFlags)
                    foreach(flag ${_cProFlags})
                        cm_append_list(_cxxFlags flag)
                    endforeach()

                    cm_message_debug_footer(STATUS "Add flags from Project_COMPILER_CXX_FLAGS")
                endif()
            endif()


            if(Project_COMPILER_CXX_APPLY_STANDARD)
                cm_message_status(STATUS "Apply COMPILER_CXX_STANDARD.")
                cm_append_list(_cxxFlags Project_COMPILER_CXX_INTERNAL_STANDARD)
            endif()

            if(_cxxFlags)
                list(REMOVE_DUPLICATES _cxxFlags)
                list(SORT _cxxFlags)

                cm_message_verbose(STATUS "Add following to CMAKE_CXX_FLAGS:")
                cm_message_verbose_output(STATUS "${_cxxFlags}")

                list(JOIN _cxxFlags " " _cxxFlags)
                set(CMAKE_CXX_FLAGS ${_cxxFlags} CACHE STRING "Flags used by C compiler during all build types." FORCE)
            endif()
            #unset(_cxxFlags)
        endif()

        #unset(_flags)
    endif()
endfunction()

