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
# Website: https://www.baslerweb.com/en/


# ************************************************************
# Start Package
# ************************************************************
cm_message_header(BASLER_PYLON)
cm_package_begin(BASLER_PYLON)
cm_package_create_home_path(BASLER_PYLON BASLER_PYLON_ROOT)




# ************************************************************
# Create Search Name
# ************************************************************
set(BASLER_PYLON_PREFIX_NAMES "pylon")
set(BASLER_PYLON_LIBRARY_NAMES "${BASLER_PYLON_PREFIX_NAMES}")




# ************************************************************
# Create Search Path
# ************************************************************
set(BASLER_PYLON_PREFIX_PATH ${BASLER_PYLON_HOME})
cm_package_create_search_path_include(BASLER_PYLON)
cm_package_create_search_path_library(BASLER_PYLON)




# ************************************************************
# Clear
# ************************************************************
cm_package_clear_if_changed(BASLER_PYLON_HOME
    BASLER_PYLON_PATH_INCLUDE
    BASLER_PYLON_LIBRARY_DEBUG
    BASLER_PYLON_LIBRARY_RELEASE
)




# ************************************************************
# Find Paths
# ************************************************************
if(APPLE)
    cm_package_find_path(BASLER_PYLON_PATH_INCLUDE "PylonBase.h" "${BASLER_PYLON_SEARCH_PATH_INCLUDE}" "")
    cm_package_find_library(BASLER_PYLON_LIBRARY_DEBUG "${BASLER_PYLON_LIBRARY_NAMES}" "${BASLER_PYLON_SEARCH_PATH_LIBRARY}" "")
    cm_package_find_library(BASLER_PYLON_LIBRARY_RELEASE "${BASLER_PYLON_LIBRARY_NAMES}" "${BASLER_PYLON_SEARCH_PATH_LIBRARY}" "")
    cm_package_make_library(BASLER_PYLON_LIBRARY BASLER_PYLON_LIBRARY_DEBUG BASLER_PYLON_LIBRARY_RELEASE)
else()
    cm_package_find_path(BASLER_PYLON_PATH_INCLUDE "pylon" "${BASLER_PYLON_SEARCH_PATH_INCLUDE}" "")
    set(Args "")
    set(BASLER_PYLON_LIBRARY_DEBUG "")
    set(BASLER_PYLON_LIBRARY_RELEASE "")
    execute_process(
        COMMAND ${BASLER_PYLON_HOME}/bin/pylon-config --libs
        OUTPUT_VARIABLE Args
        RESULT_VARIABLE ReturnValue
    )
    separate_arguments(ListArgs UNIX_COMMAND "${Args}")
    foreach(Var ${ListArgs})
        string(REGEX MATCH "-l" LibraryFound ${Var})
        if(LibraryFound)
            string(REGEX REPLACE "-l" "" LibraryName "${Var}")
            cm_package_find_library(BASLER_PYLON_LIBRARY_${LibraryName} "${LibraryName}" "${BASLER_PYLON_SEARCH_PATH_LIBRARY}" "")
            if(BASLER_PYLON_LIBRARY_${LibraryName})
                list(APPEND BASLER_PYLON_LIBRARY_RELEASE ${BASLER_PYLON_LIBRARY_${LibraryName}})
            endif()
            #unset(BASLER_PYLON_LIBRARY_${LibraryName} CACHE)
            unset(LibraryName)
        endif()
    endforeach()
    unset(Args)
    unset(LibraryFound)
    unset(ListArgs)
    cm_package_make_library(BASLER_PYLON_LIBRARY BASLER_PYLON_LIBRARY_DEBUG BASLER_PYLON_LIBRARY_RELEASE)
endif()




# ************************************************************
# Finalize Package
# ************************************************************
cm_package_validate(BASLER_PYLON)
if(APPLE)
    cm_package_include_options(BASLER_PYLON)
    list(APPEND BASLER_PYLON_INCLUDE_DIR "${BASLER_PYLON_PATH_INCLUDE}/GenICam")
else()
    cm_package_include_options(BASLER_PYLON)
endif()
cm_package_end(BASLER_PYLON)
cm_message_footer(BASLER_PYLON)
