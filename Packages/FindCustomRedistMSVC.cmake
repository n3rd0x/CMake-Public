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
# Start package
cm_message_header(RedistMSVC)
cm_package_begin(RedistMSVC)
cm_package_create_home_path(RedistMSVC RedistMSVC_ROOT)




# ************************************************************
# Create Search Path
set(RedistMSVC_PREFIX_PATH ${RedistMSVC_HOME})




# ************************************************************
# Options
option(RedistMSVC_DIRECTX11 "Search for DirectX 11.0." OFF)




# ************************************************************
# Create Search Name
set(VERSION_VALUE "")
if(MSVC14)
    set(VERSION_VALUE "140")
elseif(MSVC12)
    set(VERSION_VALUE "120")
elseif(MSVC11)
    set(VERSION_VALUE "110")
elseif(MSVC10)
    set(VERSION_VALUE "100")
endif()
set(MSVCP_NAME "msvcp${VERSION_VALUE}")
set(MSVCR_NAME "msvcr${VERSION_VALUE}")
cm_package_create_debug_binary_names(MSVCP_NAME)
cm_package_create_release_binary_names(MSVCP_NAME)
if(NOT MSVC14)
    cm_package_create_debug_binary_names(MSVCR_NAME)
    cm_package_create_release_binary_names(MSVCR_NAME)
endif()




# ************************************************************
# Clear
set(ClearIfChanged
    RedistMSVC_HOME
)
set(Modules
    RedistMSVC_MSVCP_DEBUG
    RedistMSVC_MSVCP_RELEASE
)
if(NOT MSVC14)
    list(APPEND Modules
        RedistMSVC_MSVCP_DEBUG
        RedistMSVC_MSVCP_RELEASE
    )
endif()

if(RedistMSVC_DIRECTX11)
    list(APPEND Modules
        RedistMSVC_DX11
    )
endif()
foreach(VAR ${ClearIfChanged})
    cm_package_clear_if_changed(${VAR}
        ${Modules}
    )
endforeach()
unset(VAR)
unset(ClearIfChanged)
unset(Modules)




# ************************************************************
# Find Paths
cm_package_find_file(RedistMSVC_MSVCP_DEBUG "${MSVCP_NAME_DEBUG}" "${RedistMSVC_HOME}" "debug")
cm_package_find_file(RedistMSVC_MSVCP_RELEASE "${MSVCP_NAME_RELEASE}" "${RedistMSVC_HOME}" "release")

if(NOT MSVC14)
    cm_package_find_file(RedistMSVC_MSVCR_DEBUG "${MSVCR_NAME_DEBUG}" "${RedistMSVC_HOME}" "debug")
    cm_package_find_file(RedistMSVC_MSVCR_RELEASE "${MSVCR_NAME_RELEASE}" "${RedistMSVC_HOME}" "release")
endif()

if(RedistMSVC_DIRECTX11)
    cm_package_find_file(RedistMSVC_DX11 "D3Dcompiler_47.dll" "${RedistMSVC_HOME}" "debug;release")
endif()

# Add into final variable.
set(RedistFoundDebug TRUE)
set(RedistFoundRelease TRUE)
set(RedistMSVC_BINARY_DEBUG "")
set(RedistMSVC_BINARY_RELEASE "")
if(NOT MSVC14)
    if(RedistMSVC_MSVCP_DEBUG AND RedistMSVC_MSVCR_DEBUG)
        set(RedistMSVC_BINARY_DEBUG "${RedistMSVC_MSVCP_DEBUG}" "${RedistMSVC_MSVCR_DEBUG}")
    else()
        set(RedistFoundDebug FALSE)
    endif()

    if(RedistMSVC_MSVCP_RELEASE AND RedistMSVC_MSVCR_RELEASE)
        set(RedistMSVC_BINARY_RELEASE "${RedistMSVC_MSVCP_RELEASE}" "${RedistMSVC_MSVCR_RELEASE}")
    else()
        set(RedistFoundRelease FALSE)
    endif()
else()
    if(RedistMSVC_MSVCP_DEBUG)
        set(RedistMSVC_BINARY_DEBUG "${RedistMSVC_MSVCP_DEBUG}")
    else()
        set(RedistFoundDebug FALSE)
    endif()

    if(RedistMSVC_MSVCP_RELEASE)
        set(RedistMSVC_BINARY_RELEASE "${RedistMSVC_MSVCP_RELEASE}")
     else()

    endif()
endif()

if(RedistFoundDebug OR RedistFoundRelease)
    if(RedistMSVC_DIRECTX11)
        if(RedistMSVC_DX11)
            list(APPEND RedistMSVC_BINARY_DEBUG "${RedistMSVC_DX11}")
            list(APPEND RedistMSVC_BINARY_RELEASE "${RedistMSVC_DX11}")
        else()
            set(RedistFoundDebug FALSE)
            set(RedistFoundRelease FALSE)
        endif()
    endif()
endif()




# ************************************************************
# Finalize Package
if(RedistFoundDebug OR RedistFoundRelease)
    cm_message_status(STATUS "The RedistMSVC library is located.")
else()
    cm_message_status("" "Failed to locate the RedistMSVC library.")
endif()

unset(RedistFoundDebug)
unset(RedistFoundRelease)
cm_message_footer(RedistMSVC)

