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
# Apply Project Compiler Options to CMake
# ************************************************************
function(CM_PROJECT_COMPILER_APPLY_OPTIONS)
    if(PROJECT_COMPILER_C_ENABLE_FLAG   OR
       PROJECT_COMPILER_CXX_ENABLE_FLAG OR
       PROJECT_COMPILER_CXX_ENABLE_STANDARD)
        cm_message_header(CM_PROJECT_COMPILER_APPLY_OPTIONS)
        cm_message_verbose(STATUS "-------------------------------")
        cm_message_verbose(STATUS "- Prepare Common Compiler Flags")
        cm_message_verbose(STATUS "-------------------------------")

        set(_flags "")
        # ----------------------------------------
        # Selectable Flags
        # ----------------------------------------
        if(PROJECT_COMPILER_INTERNAL_FLAGS)
            cm_message_verbose(STATUS "Prepare selectable compiler flags.")
            foreach(flag ${PROJECT_COMPILER_INTERNAL_FLAGS})
                cm_append_list(_flags ${flag})
            endforeach()
        endif()


        # ----------------------------------------
        # Project Flags
        # ----------------------------------------
        if(PROJECT_COMPILER_ENABLE_FLAG)
            if(PROJECT_COMPILER_ENABLE_FLAGS)
                cm_message_verbose(STATUS "Prepare custom project compiler flags.")
                foreach(flag ${PROJECT_COMPILER_ENABLE_FLAGS})
                    cm_append_list(_flags ${flag})
                endforeach()
            endif()
        endif()


        # ----------------------------------------
        # C Compiler
        # ----------------------------------------
        if(CMAKE_C_COMPILER_LOADED)
            set(_cFlags "")

            if(PROJECT_COMPILER_C_ENABLE_FLAG)
                cm_message_verbose(STATUS "--------------------------")
                cm_message_verbose(STATUS "- Process C Compiler Flags")
                cm_message_verbose(STATUS "--------------------------")

                # Global internal flags.
                if(_flags)
                    list(APPEND _cFlags ${_flags})
                    cm_message_verbose(STATUS "Apply common internal & custom project compiler flags.")
                    cm_message_debug(STATUS "Flags: ${_cFlags}")
                endif()


                # Internal compiler flags.
                if(PROJECT_COMPILER_C_INTERNAL_FLAGS)
                    cm_message_verbose(STATUS "Apply internal C compiler flags.")

                    set(_cIntFlags ${PfROJECT_COMPILER_C_INTERNAL_FLAGS})
                    separate_arguments(_cIntFlags)
                    foreach(flag ${_cIntFlags})
                        cm_append_list(_cFlags flag)
                    endforeach()
                    cm_message_debug(STATUS "Flags: ${_cFlags}")
                endif()


                # Project compiler flags.
                if(PROJECT_COMPILER_C_ENABLE_FLAGS)
                    cm_message_verbose(STATUS "Apply custom project C compiler flags.")

                    set(_cProFlags ${PROJECT_COMPILER_C_ENABLE_FLAGS})
                    separate_arguments(_cProFlags)
                    foreach(flag ${_cProFlags})
                        cm_append_list(_cFlags flag)
                    endforeach()
                    cm_message_debug(STATUS "Flags: ${_cFlags}")
                endif()
            endif()


            if(_cFlags)
                set(_c2Add "")
                list(REMOVE_DUPLICATES _cFlags)
                list(SORT _cFlags)

                # Usual for debug purpose, but nice to have though.
                if(PROJECT_COMPILER_CHECK_FLAGS)
                    foreach(flag ${_cFlags})
                        cm_message_debug(STATUS "Checking C flag: ${flag}")

                        check_c_compiler_flag(${flag} C_HAS_${flag}_FLAG)
                        if(NOT C_HAS_${flag}_FLAG)
                            cm_message_status("" "C flag (${flag}) is NOT supported.")
                        else()
                            list(APPEND _c2Add ${flag})
                        endif()
                        unset(C_HAS_${flag}_FLAG CACHE)
                    endforeach()
                else()
                    set(_c2Add ${_cFlags})
                endif()

                cm_message_verbose(STATUS "Add following to CMAKE_C_FLAGS:")
                cm_message_verbose_output(STATUS "${_c2Add}")

                list(JOIN _c2Add " " _c2Add)
                set(CMAKE_C_FLAGS ${_c2Add} CACHE STRING "Flags used by C compiler during all build types." FORCE)

                unset(_c2Add)
            endif()
            unset(_cFlags)
        endif()




        # ----------------------------------------
        # C++ Compiler
        # ----------------------------------------
        if(CMAKE_CXX_COMPILER_LOADED)
            set(_cxxFlags "")

            if(PROJECT_COMPILER_CXX_ENABLE_FLAG)
                cm_message_verbose(STATUS "----------------------------")
                cm_message_verbose(STATUS "- Process C++ Compiler Flags")
                cm_message_verbose(STATUS "----------------------------")

                # Global internal flags.
                if(_flags)
                    list(APPEND _cxxFlags ${_flags})
                    cm_message_verbose(STATUS "Apply common internal & custom project compiler flags.")
                    cm_message_debug(STATUS "Flags: ${_cxxFlags}")
                endif()


                # Internal compiler flags.
                if(PROJECT_COMPILER_CXX_INTERNAL_FLAGS)
                    cm_message_verbose(STATUS "Apply internal C++ compiler flags.")

                    set(_cxxIntFlags ${PROJECT_COMPILER_CXX_INTERNAL_FLAGS})
                    separate_arguments(_cxxIntFlags)
                    foreach(flag ${_cxxIntFlags})
                        cm_append_list(_cxxFlags flag)
                    endforeach()
                    cm_message_debug(STATUS "Flags: ${_cxxFlags}")
                endif()


                # Project compiler flags.
                if(PROJECT_COMPILER_CXX_ENABLE_FLAGS)
                    cm_message_verbose(STATUS "Apply custom project C++ compiler flags.")

                    set(_cxxProFlags ${PROJECT_COMPILER_CXX_ENABLE_FLAGS})
                    separate_arguments(_cxxProFlags)
                    foreach(flag ${_cxxProFlags})
                        cm_append_list(_cxxFlags flag)
                    endforeach()
                    cm_message_debug(STATUS "Flags: ${_cxxFlags}")
                endif()
            endif()


            if(PROJECT_COMPILER_CXX_ENABLE_STANDARD AND PROJECT_COMPILER_CXX_INTERNAL_STANDARD)
                cm_append_list(_cxxFlags PROJECT_COMPILER_CXX_INTERNAL_STANDARD)
                cm_message_verbose(STATUS "Apply C++ standard flag.")
                cm_message_debug(STATUS "Flags: ${_cxxFlags}")
            endif()

            if(_cxxFlags)
                set(_cxx2Add "")
                list(REMOVE_DUPLICATES _cxxFlags)
                list(SORT _cxxFlags)

                # Usual for debug purpose, but nice to have though.
                if(PROJECT_COMPILER_CHECK_FLAGS)
                    foreach(flag ${_cxxFlags})
                        cm_message_debug(STATUS "Checking C++ flag: ${flag}")

                        check_cxx_compiler_flag(${flag} CXX_HAS_${flag}_FLAG)
                        if(NOT CXX_HAS_${flag}_FLAG)
                            cm_message_status("" "C++ flag (${flag}) is NOT supported.")
                        else()
                            list(APPEND _cxx2Add ${flag})
                        endif()
                        unset(CXX_HAS_${flag}_FLAG CACHE)
                    endforeach()
                else()
                    set(_cxx2Add ${_cxxFlags})
                endif()

                cm_message_verbose(STATUS "Add following to CMAKE_CXX_FLAGS:")
                cm_message_verbose_output(STATUS "${_cxx2Add}")

                list(JOIN _cxx2Add " " _cxx2Add)
                set(CMAKE_CXX_FLAGS ${_cxx2Add} CACHE STRING "Flags used by C compiler during all build types." FORCE)

                unset(_cxx2Add)
            endif()
            unset(_cxxFlags)
        endif()

        unset(_flags)
        cm_message_footer(CM_PROJECT_COMPILER_APPLY_OPTIONS)
    endif()
endfunction()

