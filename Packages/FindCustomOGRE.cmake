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
# Website: https://www.ogre3d.org


# ************************************************************
# Start package
# ************************************************************
message_header(OGRE)
package_begin(OGRE)
package_create_home_path(OGRE OGRE_ROOT)

# Specifiy version prefix.
set(OGRE_OPT_VERSION_PREFIX "" CACHE STRING "Append version prefix into the search.")
set(OGRE_OPT_VERSION "Legacy" CACHE STRING "Select OGRE version to search.")
set_property(CACHE OGRE_OPT_VERSION PROPERTY STRINGS "Legacy" "Current" "Next")


# Working variables.
set(_IncludeSuffix
    "Ogre"
    "OGRE"
    "Ogre3D"
    "OGRE3D"
    "ogre"
    "ogre3d"
)
set(_DebugSuffix
    "debug"
    "debug/opt"
    "debug/OGRE"
    "opt"
    "OGRE"
)
set(_ReleaseSuffix
    "release"
    "release/opt"
    "release/OGRE"
    "relwithdebinfo"
    "relwithdebinfo/opt"
    "relwithdebinfo/OGRE"
    "minsizerel"
    "minsizerel/opt"
    "minsizerel/OGRE"
    "opt"
    "OGRE"
)


# ************************************************************
# Find binary
# ************************************************************
macro(OGRE_FIND_COMPONENT_BINARY COMPONENT NAME)
    set(OGRE_${COMPONENT}_BINARY_NAMES "${NAME}")

    package_create_debug_binary_names(OGRE_${COMPONENT}_BINARY_NAMES)
    package_create_release_binary_names(OGRE_${COMPONENT}_BINARY_NAMES)

    package_find_file(OGRE_${COMPONENT}_BINARY_DEBUG "${OGRE_${COMPONENT}_BINARY_NAMES_DEBUG}" "${OGRE_SEARCH_BINARIES}" "${_DebugSuffix}")
    package_find_file(OGRE_${COMPONENT}_BINARY_RELEASE "${OGRE_${COMPONENT}_BINARY_NAMES_RELEASE}" "${OGRE_SEARCH_BINARIES}" "${_ReleaseSuffix}")

    unset(OGRE_${COMPONENT}_BINARY_NAMES)
    unset(OGRE_${COMPONENT}_BINARY_NAMES_DEBUG)
    unset(OGRE_${COMPONENT}_BINARY_NAMES_RELEASE)
endmacro()




# ************************************************************
# Find library
# ************************************************************
macro(OGRE_FIND_COMPONENT_LIBRARY COMPONENT NAME HEADER SUFFIX)
    package_begin(OGRE_${COMPONENT})
    set(OGRE_${COMPONENT}_LIBRARY_NAMES "${NAME}")
    package_create_debug_names(OGRE_${COMPONENT}_LIBRARY_NAMES)

    package_find_path(OGRE_${COMPONENT}_PATH_INCLUDE "${HEADER}" "${OGRE_SEARCH_PATH_INCLUDE}" "${SUFFIX}")
    package_find_library(OGRE_${COMPONENT}_LIBRARY_DEBUG "${OGRE_${COMPONENT}_LIBRARY_NAMES_DEBUG}" "${OGRE_SEARCH_PATH_LIBRARY}" "${_DebugSuffix}")
    package_find_library(OGRE_${COMPONENT}_LIBRARY_RELEASE "${OGRE_${COMPONENT}_LIBRARY_NAMES}" "${OGRE_SEARCH_PATH_LIBRARY}" "${_ReleaseSuffix}")
    package_make_library(OGRE_${COMPONENT}_LIBRARY OGRE_${COMPONENT}_LIBRARY_DEBUG OGRE_${COMPONENT}_LIBRARY_RELEASE)

    package_validate(OGRE_${COMPONENT})
    package_end(OGRE_${COMPONENT})

    unset(OGRE_${COMPONENT}_LIBRARY_NAMES)
    unset(OGRE_${COMPONENT}_LIBRARY_NAMES_DEBUG)
endmacro()




# ************************************************************
# Find plugins / rendersystems
# ************************************************************
macro(OGRE_FIND_EXTRA_COMPONENT_LIBRARY COMPONENT NAME HEADER SUFFIX)
    package_begin(OGRE_${COMPONENT})
    if(APPLE)
        set(LibSuffix "dylib")
    elseif(MSVC)
        set(LibSuffix "lib")
    else()
        set(LibSuffix "so")
    endif()
    set(OGRE_${COMPONENT}_NAMES_DEBUG
        "${NAME}_d.${LibSuffix}"
        "${NAME}.${LibSuffix}"
    )
    set(OGRE_${COMPONENT}_NAMES_RELEASE
        "${NAME}.${LibSuffix}"
    )
    if(APPLE)
        list(APPEND OGRE_${COMPONENT}_NAMES_DEBUG "${NAME}.framework")
        list(APPEND OGRE_${COMPONENT}_NAMES_RELEASE "${NAME}.framework")
    endif()
    if(WIN32)
        list(APPEND OGRE_${COMPONENT}_NAMES_DEBUG "${NAME}_d.dll" "${NAME}.dll")
        list(APPEND OGRE_${COMPONENT}_NAMES_RELEASE "${NAME}.dll")
    endif()

    package_find_path(OGRE_${COMPONENT}_PATH_INCLUDE "${HEADER}" "${OGRE_SEARCH_PATH_INCLUDE}" "${SUFFIX}")

    package_find_file(OGRE_${COMPONENT}_LIBRARY_DEBUG "${OGRE_${COMPONENT}_NAMES_DEBUG}" "${OGRE_SEARCH_PATH_LIBRARY}" "${_DebugSuffix}")
    package_find_file(OGRE_${COMPONENT}_LIBRARY_RELEASE "${OGRE_${COMPONENT}_NAMES_RELEASE}" "${OGRE_SEARCH_PATH_LIBRARY}" "${_ReleaseSuffix}")
    package_make_library(OGRE_${COMPONENT}_LIBRARY OGRE_${COMPONENT}_LIBRARY_DEBUG OGRE_${COMPONENT}_LIBRARY_RELEASE)

    if(WIN32)
        package_find_file(OGRE_${COMPONENT}_BINARY_DEBUG "${OGRE_${COMPONENT}_NAMES_DEBUG}" "${OGRE_SEARCH_BINARIES}" "${_DebugSuffix}")
        package_find_file(OGRE_${COMPONENT}_BINARY_RELEASE "${OGRE_${COMPONENT}_NAMES_RELEASE}" "${OGRE_SEARCH_BINARIES}" "${_ReleaseSuffix}")
    endif()

    package_validate(OGRE_${COMPONENT})
    package_end(OGRE_${COMPONENT})

    unset(ExtSuffix)
    unset(OGRE_${COMPONENT}_LIBRARY_NAMES_DEBUG)
    unset(OGRE_${COMPONENT}_LIBRARY_NAMES_RELEASE)
endmacro()




# ************************************************************
# Create search path
# ************************************************************
set(OGRE_PREFIX_PATH ${OGRE_HOME})
package_create_search_path_binary(OGRE)
package_create_search_path_include(OGRE)
package_create_search_path_library(OGRE)
package_create_search_path_plugin(OGRE)
if(NOT OGRE_OPT_VERSION_PREFIX STREQUAL "")
    package_append_paths(OGRE_SEARCH_PATH_LIBRARY "${OGRE_OPT_VERSION_PREFIX}")
endif()



# ************************************************************
# Clear
# ************************************************************
set(_LocalVars
    OGRE_FOUND
    OGRE_PATH_INCLUDE
    OGRE_PATH_PLUGIN_DEBUG
    OGRE_PATH_PLUGIN_RELEASE
    OGRE_BINARY_DEBUG
    OGRE_BINARY_RELEASE
    OGRE_LIBRARY_DEBUG
    OGRE_LIBRARY_RELEASE
    OGRE_Overlay_BINARY_DEBUG
    OGRE_Overlay_BINARY_RELEASE
    OGRE_Overlay_PATH_INCLUDE
    OGRE_Overlay_LIBRARY_DEBUG
    OGRE_Overlay_LIBRARY_RELEASE
    OGRE_Paging_BINARY_DEBUG
    OGRE_Paging_BINARY_RELEASE
    OGRE_Paging_PATH_INCLUDE
    OGRE_Paging_LIBRARY_DEBUG
    OGRE_Paging_LIBRARY_RELEASE
    OGRE_Property_BINARY_DEBUG
    OGRE_Property_BINARY_RELEASE
    OGRE_Property_PATH_INCLUDE
    OGRE_Property_LIBRARY_DEBUG
    OGRE_Property_LIBRARY_RELEASE
    OGRE_RTShaderSystem_BINARY_DEBUG
    OGRE_RTShaderSystem_BINARY_RELEASE
    OGRE_RTShaderSystem_PATH_INCLUDE
    OGRE_RTShaderSystem_LIBRARY_DEBUG
    OGRE_RTShaderSystem_LIBRARY_RELEASE
    OGRE_Terrain_BINARY_DEBUG
    OGRE_Terrain_BINARY_RELEASE
    OGRE_Terrain_PATH_INCLUDE
    OGRE_Terrain_LIBRARY_DEBUG
    OGRE_Terrain_LIBRARY_RELEASE
    OGRE_Volume_BINARY_DEBUG
    OGRE_Volume_BINARY_RELEASE
    OGRE_Volume_PATH_INCLUDE
    OGRE_Volume_LIBRARY_DEBUG
    OGRE_Volume_LIBRARY_RELEASE

    OGRE_Plugin_BSPSceneManager_BINARY_DEBUG
    OGRE_Plugin_BSPSceneManager_BINARY_RELEASE
    OGRE_Plugin_BSPSceneManager_PATH_INCLUDE
    OGRE_Plugin_BSPSceneManager_LIBRARY_DEBUG
    OGRE_Plugin_BSPSceneManager_LIBRARY_RELEASE
    OGRE_Plugin_CgProgramManager_BINARY_DEBUG
    OGRE_Plugin_CgProgramManager_BINARY_RELEASE
    OGRE_Plugin_CgProgramManager_PATH_INCLUDE
    OGRE_Plugin_CgProgramManager_LIBRARY_DEBUG
    OGRE_Plugin_CgProgramManager_LIBRARY_RELEASE

    OGRE_Plugin_DotScene_BINARY_DEBUG
    OGRE_Plugin_DotScene_BINARY_RELEASE
    OGRE_Plugin_DotScene_PATH_INCLUDE
    OGRE_Plugin_DotScene_LIBRARY_DEBUG
    OGRE_Plugin_DotScene_LIBRARY_RELEASE

    OGRE_Plugin_OctreeSceneManager_BINARY_DEBUG
    OGRE_Plugin_OctreeSceneManager_BINARY_RELEASE
    OGRE_Plugin_OctreeSceneManager_PATH_INCLUDE
    OGRE_Plugin_OctreeSceneManager_LIBRARY_DEBUG
    OGRE_Plugin_OctreeSceneManager_LIBRARY_RELEASE
    OGRE_Plugin_OctreeZone_BINARY_DEBUG
    OGRE_Plugin_OctreeZone_BINARY_RELEASE
    OGRE_Plugin_OctreeZone_PATH_INCLUDE
    OGRE_Plugin_OctreeZone_LIBRARY_DEBUG
    OGRE_Plugin_OctreeZone_LIBRARY_RELEASE
    OGRE_Plugin_ParticleFX_BINARY_DEBUG
    OGRE_Plugin_ParticleFX_BINARY_RELEASE
    OGRE_Plugin_ParticleFX_PATH_INCLUDE
    OGRE_Plugin_ParticleFX_LIBRARY_DEBUG
    OGRE_Plugin_ParticleFX_LIBRARY_RELEASE
    OGRE_Plugin_PCZSceneManager_BINARY_DEBUG
    OGRE_Plugin_PCZSceneManager_BINARY_RELEASE
    OGRE_Plugin_PCZSceneManager_PATH_INCLUDE
    OGRE_Plugin_PCZSceneManager_LIBRARY_DEBUG
    OGRE_Plugin_PCZSceneManager_LIBRARY_RELEASE

    OGRE_Codec_Assimp_BINARY_DEBUG
    OGRE_Codec_Assimp_BINARY_RELEASE
    OGRE_Codec_Assimp_PATH_INCLUDE
    OGRE_Codec_Assimp_LIBRARY_DEBUG
    OGRE_Codec_Assimp_LIBRARY_RELEASE

    OGRE_Codec_EXR_BINARY_DEBUG
    OGRE_Codec_EXR_BINARY_RELEASE
    OGRE_Codec_EXR_PATH_INCLUDE
    OGRE_Codec_EXR_LIBRARY_DEBUG
    OGRE_Codec_EXR_LIBRARY_RELEASE
    OGRE_Codec_FreeImage_BINARY_DEBUG
    OGRE_Codec_FreeImage_BINARY_RELEASE
    OGRE_Codec_FreeImage_PATH_INCLUDE
    OGRE_Codec_FreeImage_LIBRARY_DEBUG
    OGRE_Codec_FreeImage_LIBRARY_RELEASE
    OGRE_Codec_STBI_BINARY_DEBUG
    OGRE_Codec_STBI_BINARY_RELEASE
    OGRE_Codec_STBI_PATH_INCLUDE
    OGRE_Codec_STBI_LIBRARY_DEBUG
    OGRE_Codec_STBI_LIBRARY_RELEASE

    OGRE_RenderSystem_Direct3D9_BINARY_DEBUG
    OGRE_RenderSystem_Direct3D9_BINARY_RELEASE
    OGRE_RenderSystem_Direct3D9_PATH_INCLUDE
    OGRE_RenderSystem_Direct3D9_LIBRARY_DEBUG
    OGRE_RenderSystem_Direct3D9_LIBRARY_RELEASE
    OGRE_RenderSystem_Direct3D11_BINARY_DEBUG
    OGRE_RenderSystem_Direct3D11_BINARY_RELEASE
    OGRE_RenderSystem_Direct3D11_PATH_INCLUDE
    OGRE_RenderSystem_Direct3D11_LIBRARY_DEBUG
    OGRE_RenderSystem_Direct3D11_LIBRARY_RELEASE
    OGRE_RenderSystem_GL_BINARY_DEBUG
    OGRE_RenderSystem_GL_BINARY_RELEASE
    OGRE_RenderSystem_GL_PATH_INCLUDE
    OGRE_RenderSystem_GL_LIBRARY_DEBUG
    OGRE_RenderSystem_GL_LIBRARY_RELEASE
    OGRE_RenderSystem_GL3Plus_BINARY_DEBUG
    OGRE_RenderSystem_GL3Plus_BINARY_RELEASE
    OGRE_RenderSystem_GL3Plus_PATH_INCLUDE
    OGRE_RenderSystem_GL3Plus_LIBRARY_DEBUG
    OGRE_RenderSystem_GL3Plus_LIBRARY_RELEASE

    # OGRE v1.10++
    OGRE_Bites_BINARY_DEBUG
    OGRE_Bites_BINARY_RELEASE
    OGRE_Bites_PATH_INCLUDE
    OGRE_Bites_LIBRARY_DEBUG
    OGRE_Bites_LIBRARY_RELEASE
    OGRE_BitesQt_BINARY_DEBUG
    OGRE_BitesQt_BINARY_RELEASE
    OGRE_BitesQt_PATH_INCLUDE
    OGRE_BitesQt_LIBRARY_DEBUG
    OGRE_BitesQt_LIBRARY_RELEASE
    OGRE_MeshLodGenerator_BINARY_DEBUG
    OGRE_MeshLodGenerator_BINARY_RELEASE
    OGRE_MeshLodGenerator_PATH_INCLUDE
    OGRE_MeshLodGenerator_LIBRARY_DEBUG
    OGRE_MeshLodGenerator_LIBRARY_RELEASE

    # OGRE v2++
    OGRE_HlmsCommon_PATH_INCLUDE
    OGRE_HlmsPbs_BINARY_DEBUG
    OGRE_HlmsPbs_BINARY_RELEASE
    OGRE_HlmsPbs_PATH_INCLUDE
    OGRE_HlmsPbs_LIBRARY_DEBUG
    OGRE_HlmsPbs_LIBRARY_RELEASE
    OGRE_HlmsPbsMobile_BINARY_DEBUG
    OGRE_HlmsPbsMobile_BINARY_RELEASE
    OGRE_HlmsPbsMobile_PATH_INCLUDE
    OGRE_HlmsPbsMobile_LIBRARY_DEBUG
    OGRE_HlmsPbsMobile_LIBRARY_RELEASE
    OGRE_HlmsUnlit_BINARY_DEBUG
    OGRE_HlmsUnlit_BINARY_RELEASE
    OGRE_HlmsUnlit_PATH_INCLUDE
    OGRE_HlmsUnlit_LIBRARY_DEBUG
    OGRE_HlmsUnlit_LIBRARY_RELEASE
    OGRE_HlmsUnlitMobile_BINARY_DEBUG
    OGRE_HlmsUnlitMobile_BINARY_RELEASE
    OGRE_HlmsUnlitMobile_PATH_INCLUDE
    OGRE_HlmsUnlitMobile_LIBRARY_DEBUG
    OGRE_HlmsUnlitMobile_LIBRARY_RELEASE

    #OGRE_RenderSystem_Metal_BINARY_DEBUG
    #OGRE_RenderSystem_Metal_BINARY_RELEASE
    OGRE_RenderSystem_Metal_PATH_INCLUDE
    OGRE_RenderSystem_Metal_LIBRARY_DEBUG
    OGRE_RenderSystem_Metal_LIBRARY_RELEASE

    #OGRE_RenderSystem_NULL_BINARY_DEBUG
    #OGRE_RenderSystem_NULL_BINARY_RELEASE
    OGRE_RenderSystem_NULL_PATH_INCLUDE
    OGRE_RenderSystem_NULL_LIBRARY_DEBUG
    OGRE_RenderSystem_NULL_LIBRARY_RELEASE
)

set(_ClearIfChanged
    OGRE_HOME
    OGRE_OPT_VERSION
)
foreach(VAR ${_ClearIfChanged})
    package_clear_if_changed(${VAR} ${_LocalVars})
endforeach()




# ************************************************************
# Create search name
# ************************************************************
set(OGRE_LIBRARY_NAMES "OgreMain" "Ogre")
package_create_debug_names(OGRE_LIBRARY_NAMES)




# ************************************************************
# Find path and file
# ************************************************************
package_find_path(OGRE_PATH_INCLUDE "Ogre.h" "${OGRE_SEARCH_PATH_INCLUDE}" "${_IncludeSuffix}")
package_find_library(OGRE_LIBRARY_DEBUG "${OGRE_LIBRARY_NAMES_DEBUG}" "${OGRE_SEARCH_PATH_LIBRARY}" "${_DebugSuffix}")
package_find_library(OGRE_LIBRARY_RELEASE "${OGRE_LIBRARY_NAMES}" "${OGRE_SEARCH_PATH_LIBRARY}" "${_ReleaseSuffix}")
package_make_library(OGRE_LIBRARY OGRE_LIBRARY_DEBUG OGRE_LIBRARY_RELEASE)




# ************************************************************
# Search the components
# ************************************************************
package_find_path(OGRE_HlmsCommon_PATH_INCLUDE "OgreHlmsBufferManager.h" "${OGRE_SEARCH_PATH_INCLUDE}" "Hlms/Common")
ogre_find_component_library(HlmsPbs "OgreHlmsPbs" "OgreHlmsPbs.h" "Hlms/Pbs")
ogre_find_component_library(HlmsUnlit "OgreHlmsUnlit" "OgreHlmsUnlit.h" "Hlms/Unlit")

ogre_find_component_library(Bites "OgreBites" "OgreApplicationContext.h" "Bites")
ogre_find_component_library(BitesQt "OgreBitesQt" "OgreApplicationContextQt.h" "Bites")
ogre_find_component_library(MeshLodGenerator "OgreMeshLodGenerator" "OgreMeshLodGenerator.h" "MeshLodGenerator")
ogre_find_component_library(Paging "OgrePaging" "OgrePaging.h" "Paging")
ogre_find_component_library(RTShaderSystem "OgreRTShaderSystem" "OgreRTShaderSystem.h" "RTShaderSystem")
ogre_find_component_library(Terrain "OgreTerrain" "OgreTerrain.h" "Terrain")
ogre_find_component_library(Overlay "OgreOverlay" "OgreOverlaySystem.h" "Overlay")




# ************************************************************
# Find binaries on Windows
# ************************************************************
if(WIN32)
    set(OGRE_SEARCH_BINARIES
        ${OGRE_SEARCH_PATH_BINARY}
        ${OGRE_SEARCH_PATH_LIBRARY}
    )

    set(OGRE_BINARY_NAMES "OgreMain")
    package_create_release_binary_names(OGRE_BINARY_NAMES)
    package_create_debug_binary_names(OGRE_BINARY_NAMES)

    package_find_file(OGRE_BINARY_DEBUG "${OGRE_BINARY_NAMES_DEBUG}" "${OGRE_SEARCH_BINARIES}" "${_DebugSuffix}")
    package_find_file(OGRE_BINARY_RELEASE "${OGRE_BINARY_NAMES_RELEASE}" "${OGRE_SEARCH_BINARIES}" "${_ReleaseSuffix}")

    unset(OGRE_BINARY_NAMES)
    unset(OGRE_BINARY_NAMES_DEBUG)
    unset(OGRE_BINARY_NAMES_RELEASE)

    ogre_find_component_binary(HlmsPbs "OgreHlmsPbs" "OgreHlmsPbs.h" "Hlms/Pbs")
    ogre_find_component_binary(HlmsUnlit "OgreHlmsUnlit" "OgreHlmsUnlit.h" "Hlms/Unlit")

    ogre_find_component_binary(Bites "OgreBites")
    ogre_find_component_binary(MeshLodGenerator "MeshLodGenerator")
    ogre_find_component_binary(Paging "OgrePaging")
    ogre_find_component_binary(Terrain "OgreTerrain")
    ogre_find_component_binary(Volume "OgreVolume")
    ogre_find_component_binary(Overlay "OgreOverlay")
endif()




# ************************************************************
# Plug-ins
# ************************************************************
# Search plugins & rendersystem.
set(OGRE_SEARCH_PLUGINS
    ${OGRE_SEARCH_PATH_LIBRARY}
    ${OGRE_SEARCH_PATH_BINARY}
    ${OGRE_SEARCH_PATH_PLUGIN}
)
ogre_find_extra_component_library(Plugin_BSPSceneManager "Plugin_BSPSceneManager" "OgreBspSceneManagerPlugin.h" "Plugins/BSPSceneManager;OGRE/BSPSceneManager")
ogre_find_extra_component_library(Plugin_CgProgramManager "Plugin_CgProgramManager" "OgreCgProgram.h" "Plugins/CgProgramManager;OGRE/CgProgramManager")
ogre_find_extra_component_library(Plugin_OctreeSceneManager "Plugin_OctreeSceneManager" "OgreOctreePlugin.h" "Plugins/OctreeSceneManager;OGRE/OctreeSceneManager")
ogre_find_extra_component_library(Plugin_OctreeZone "Plugin_OctreeZone" "OgreOctreeZonePlugin.h" "Plugins/OctreeZone;OGRE/OctreeZone")
ogre_find_extra_component_library(Plugin_PCZSceneManager "Plugin_PCZSceneManager" "OgrePCZPlugin.h" "Plugins/PCZSceneManager;OGRE/PCZSceneManager")
ogre_find_extra_component_library(Plugin_ParticleFX "Plugin_ParticleFX" "OgreParticleFXPlugin.h" "Plugins/ParticleFX;OGRE/ParticleFX")

ogre_find_extra_component_library(Codec_EXR "Codec_EXR" "OgreEXRCodec.h" "Plugins/EXRCodec;OGRE/EXRCodec")
ogre_find_extra_component_library(Codec_FreeImage "Codec_FreeImage" "OgreFreeImageCodec.h" "Plugins/FreeImageCodec;OGRE/FreeImageCodec")
ogre_find_extra_component_library(Codec_STBI "Codec_STBI" "OgreSTBICodec.h" "Plugins/STBICodec;OGRE/STBICodec")

ogre_find_extra_component_library(RenderSystem_GL "RenderSystem_GL" "OgreGLPlugin.h" "RenderSystems/GL;OGRE/GL")
ogre_find_extra_component_library(RenderSystem_GL3Plus "RenderSystem_GL3Plus" "OgreGL3PlusPlugin.h" "RenderSystems/GL3Plus;OGRE/GL3Plus")
ogre_find_extra_component_library(RenderSystem_Direct3D9 "RenderSystem_Direct3D9" "OgreD3D9Plugin.h" "RenderSystems/Direct3D9")
ogre_find_extra_component_library(RenderSystem_Direct3D11 "RenderSystem_Direct3D11" "OgreD3D11Plugin.h" "RenderSystems/Direct3D11")
ogre_find_extra_component_library(RenderSystem_Metal "RenderSystem_Metal" "OgreMetalPlugin.h" "RenderSystems/Metal")
ogre_find_extra_component_library(RenderSystem_NULL "RenderSystem_NULL" "OgreNULLPlugin.h" "RenderSystems/NULL")


# Set plugin paths.
if("${OGRE_OPT_VERSION}" STREQUAL "Next")
    if(WIN32)
        set(PlugDebugPath OGRE_RenderSystem_NULL_BINARY_DEBUG)
        set(PlugReleasePath OGRE_RenderSystem_NULL_BINARY_RELEASE)
    else()
        set(PlugDebugPath OGRE_RenderSystem_NULL_LIBRARY_DEBUG)
        set(PlugReleasePath OGRE_RenderSystem_NULL_LIBRARY_RELEASE)
    endif()
else()
    if(WIN32)
        set(PlugDebugPath OGRE_RenderSystem_GL_BINARY_DEBUG)
        set(PlugReleasePath OGRE_RenderSystem_GL_BINARY_RELEASE)
    else()
        set(PlugDebugPath OGRE_RenderSystem_GL_LIBRARY_DEBUG)
        set(PlugReleasePath OGRE_RenderSystem_GL_LIBRARY_RELEASE)
    endif()
endif()
if(PlugDebugPath)
    get_filename_component(OGRE_RenderSystem_FileName ${${PlugDebugPath}} NAME)
    package_find_path(OGRE_PATH_PLUGIN_DEBUG "${OGRE_RenderSystem_FileName}" "${OGRE_SEARCH_PLUGINS}" "${_DebugSuffix}")
    unset(OGRE_RenderSystem_FileName)
endif()

if(PlugReleasePath)
    get_filename_component(OGRE_RenderSystem_FileName ${${PlugReleasePath}} NAME)
    package_find_path(OGRE_PATH_PLUGIN_RELEASE "${OGRE_RenderSystem_FileName}" "${OGRE_SEARCH_PLUGINS}" "${_ReleaseSuffix}")
    unset(OGRE_RenderSystem_FileName)
endif()


# Clean.
unset(_IncludeSuffix)
unset(_DebugSuffix)
unset(_ReleaseSuffix)
unset(_LocalVars)
unset(_ClearIfChanged)


# ************************************************************
# Finalize package
# ************************************************************
package_validate(OGRE)
package_add_parent_dir(OGRE ADD_PARENT)
package_end(OGRE)
message_footer(OGRE)

