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




# ************************************************************
# Find binary
# ************************************************************
macro(OGRE_FIND_COMPONENT_BINARY COMPONENT NAME)
    set(OGRE_${COMPONENT}_BINARY_NAMES "${NAME}")
    
    package_create_debug_binary_names(OGRE_${COMPONENT}_BINARY_NAMES)
    package_create_release_binary_names(OGRE_${COMPONENT}_BINARY_NAMES)

    package_find_file(OGRE_${COMPONENT}_BINARY_DEBUG "${OGRE_${COMPONENT}_BINARY_NAMES_DEBUG}" "${OGRE_SEARCH_BINARIES}" "debug")
    package_find_file(OGRE_${COMPONENT}_BINARY_RELEASE "${OGRE_${COMPONENT}_BINARY_NAMES_RELEASE}" "${OGRE_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
    
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
    package_find_library(OGRE_${COMPONENT}_LIBRARY_DEBUG "${OGRE_${COMPONENT}_LIBRARY_NAMES_DEBUG}" "${OGRE_SEARCH_PATH_LIBRARY}" "debug" )
    package_find_library(OGRE_${COMPONENT}_LIBRARY_RELEASE "${OGRE_${COMPONENT}_LIBRARY_NAMES}" "${OGRE_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
    package_make_library(OGRE_${COMPONENT}_LIBRARY OGRE_${COMPONENT}_LIBRARY_DEBUG OGRE_${COMPONENT}_LIBRARY_RELEASE)
    
    package_validate(OGRE_${COMPONENT})
    package_end(OGRE_${COMPONENT})
    
    unset(OGRE_${COMPONENT}_LIBRARY_NAMES)
    unset(OGRE_${COMPONENT}_LIBRARY_NAMES_DEBUG)
endmacro()




# ************************************************************
# Create search path
# ************************************************************
set(OGRE_PREFIX_PATH ${OGRE_HOME})
package_create_search_path_binary(OGRE)
package_create_search_path_include(OGRE)
package_create_search_path_library(OGRE)
package_create_search_path_plugin(OGRE)




# ************************************************************
# Clear
# ************************************************************
package_clear_if_changed(OGRE_HOME
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
    OGRE_Overlay_INCLUDE_DIR
    OGRE_Overlay_LIBRARY_DEBUG
    OGRE_Overlay_LIBRARY_RELEASE
    OGRE_Paging_BINARY_DEBUG
    OGRE_Paging_BINARY_RELEASE
    OGRE_Paging_INCLUDE_DIR
    OGRE_Paging_LIBRARY_DEBUG
    OGRE_Paging_LIBRARY_RELEASE
    OGRE_Property_BINARY_DEBUG
    OGRE_Property_BINARY_RELEASE
    OGRE_Property_INCLUDE_DIR
    OGRE_Property_LIBRARY_DEBUG
    OGRE_Property_LIBRARY_RELEASE
    OGRE_RTShaderSystem_BINARY_DEBUG
    OGRE_RTShaderSystem_BINARY_RELEASE
    OGRE_RTShaderSystem_INCLUDE_DIR
    OGRE_RTShaderSystem_LIBRARY_DEBUG
    OGRE_RTShaderSystem_LIBRARY_RELEASE
    OGRE_Terrain_BINARY_DEBUG
    OGRE_Terrain_BINARY_RELEASE
    OGRE_Terrain_INCLUDE_DIR
    OGRE_Terrain_LIBRARY_DEBUG
    OGRE_Terrain_LIBRARY_RELEASE
    OGRE_Volume_BINARY_DEBUG
    OGRE_Volume_BINARY_RELEASE
    OGRE_Volume_INCLUDE_DIR
    OGRE_Volume_LIBRARY_DEBUG
    OGRE_Volume_LIBRARY_RELEASE
    OGRE_Plugin_BSPSceneManager_BINARY_DEBUG
    OGRE_Plugin_BSPSceneManager_BINARY_RELEASE
    OGRE_Plugin_BSPSceneManager_INCLUDE_DIR
    OGRE_Plugin_BSPSceneManager_LIBRARY_DEBUG
    OGRE_Plugin_BSPSceneManager_LIBRARY_RELEASE
    OGRE_Plugin_CgProgramManager_BINARY_DEBUG
    OGRE_Plugin_CgProgramManager_BINARY_RELEASE
    OGRE_Plugin_CgProgramManager_INCLUDE_DIR
    OGRE_Plugin_CgProgramManager_LIBRARY_DEBUG
    OGRE_Plugin_CgProgramManager_LIBRARY_RELEASE
    OGRE_Plugin_OctreeSceneManager_BINARY_DEBUG
    OGRE_Plugin_OctreeSceneManager_BINARY_RELEASE
    OGRE_Plugin_OctreeSceneManager_INCLUDE_DIR
    OGRE_Plugin_OctreeSceneManager_LIBRARY_DEBUG
    OGRE_Plugin_OctreeSceneManager_LIBRARY_RELEASE
    OGRE_Plugin_OctreeZone_BINARY_DEBUG
    OGRE_Plugin_OctreeZone_BINARY_RELEASE
    OGRE_Plugin_OctreeZone_INCLUDE_DIR
    OGRE_Plugin_OctreeZone_LIBRARY_DEBUG
    OGRE_Plugin_OctreeZone_LIBRARY_RELEASE
    OGRE_Plugin_PCZSceneManager_BINARY_DEBUG
    OGRE_Plugin_PCZSceneManager_BINARY_RELEASE
    OGRE_Plugin_PCZSceneManager_INCLUDE_DIR
    OGRE_Plugin_PCZSceneManager_LIBRARY_DEBUG
    OGRE_Plugin_PCZSceneManager_LIBRARY_RELEASE
    OGRE_Codec_EXR_BINARY_DEBUG
    OGRE_Codec_EXR_BINARY_RELEASE
    OGRE_Codec_EXR_INCLUDE_DIR
    OGRE_Codec_EXR_LIBRARY_DEBUG
    OGRE_Codec_EXR_LIBRARY_RELEASE
    OGRE_Codec_FreeImage_BINARY_DEBUG
    OGRE_Codec_FreeImage_BINARY_RELEASE
    OGRE_Codec_FreeImage_INCLUDE_DIR
    OGRE_Codec_FreeImage_LIBRARY_DEBUG
    OGRE_Codec_FreeImage_LIBRARY_RELEASE
    OGRE_Codec_STBI_BINARY_DEBUG
    OGRE_Codec_STBI_BINARY_RELEASE
    OGRE_Codec_STBI_INCLUDE_DIR
    OGRE_Codec_STBI_LIBRARY_DEBUG
    OGRE_Codec_STBI_LIBRARY_RELEASE
    OGRE_RenderSystem_Direct3D9_BINARY_DEBUG
    OGRE_RenderSystem_Direct3D9_BINARY_RELEASE
    OGRE_RenderSystem_Direct3D9_INCLUDE_DIR
    OGRE_RenderSystem_Direct3D9_LIBRARY_DEBUG
    OGRE_RenderSystem_Direct3D9_LIBRARY_RELEASE
    OGRE_RenderSystem_Direct3D11_BINARY_DEBUG
    OGRE_RenderSystem_Direct3D11_BINARY_RELEASE
    OGRE_RenderSystem_Direct3D11_INCLUDE_DIR
    OGRE_RenderSystem_Direct3D11_LIBRARY_DEBUG
    OGRE_RenderSystem_Direct3D11_LIBRARY_RELEASE
    OGRE_RenderSystem_GL_BINARY_DEBUG
    OGRE_RenderSystem_GL_BINARY_RELEASE
    OGRE_RenderSystem_GL_INCLUDE_DIR
    OGRE_RenderSystem_GL_LIBRARY_DEBUG
    OGRE_RenderSystem_GL_LIBRARY_RELEASE
    OGRE_RenderSystem_GL3Plus_BINARY_DEBUG
    OGRE_RenderSystem_GL3Plus_BINARY_RELEASE
    OGRE_RenderSystem_GL3Plus_INCLUDE_DIR
    OGRE_RenderSystem_GL3Plus_LIBRARY_DEBUG
    OGRE_RenderSystem_GL3Plus_LIBRARY_RELEASE

    # OGRE v1.11
    OGRE_Bites_BINARY_DEBUG
    OGRE_Bites_BINARY_RELEASE
    OGRE_Bites_INCLUDE_DIR
    OGRE_Bites_LIBRARY_DEBUG
    OGRE_Bites_LIBRARY_RELEASE
    OGRE_MeshLodGenerator_BINARY_DEBUG
    OGRE_MeshLodGenerator_BINARY_RELEASE
    OGRE_MeshLodGenerator_INCLUDE_DIR
    OGRE_MeshLodGenerator_LIBRARY_DEBUG
    OGRE_MeshLodGenerator_LIBRARY_RELEASE
    
    # OGRE v2
    OGRE_HlmsPbs_BINARY_DEBUG
    OGRE_HlmsPbs_BINARY_RELEASE
    OGRE_HlmsPbs_INCLUDE_DIR
    OGRE_HlmsPbs_LIBRARY_DEBUG
    OGRE_HlmsPbs_LIBRARY_RELEASE
    OGRE_HlmsPbsMobile_BINARY_DEBUG
    OGRE_HlmsPbsMobile_BINARY_RELEASE
    OGRE_HlmsPbsMobile_INCLUDE_DIR
    OGRE_HlmsPbsMobile_LIBRARY_DEBUG
    OGRE_HlmsPbsMobile_LIBRARY_RELEASE 
    OGRE_HlmsUnlit_BINARY_DEBUG
    OGRE_HlmsUnlit_BINARY_RELEASE
    OGRE_HlmsUnlit_INCLUDE_DIR
    OGRE_HlmsUnlit_LIBRARY_DEBUG
    OGRE_HlmsUnlit_LIBRARY_RELEASE
    OGRE_HlmsUnlitMobile_BINARY_DEBUG
    OGRE_HlmsUnlitMobile_BINARY_RELEASE
    OGRE_HlmsUnlitMobile_INCLUDE_DIR
    OGRE_HlmsUnlitMobile_LIBRARY_DEBUG
    OGRE_HlmsUnlitMobile_LIBRARY_RELEASE
)




# ************************************************************
# Create search name
# ************************************************************
if(NOT APPLE)
    set(OGRE_LIBRARY_NAMES "OgreMain")
else()
    set(OGRE_LIBRARY_NAMES "Ogre")
endif()
package_create_debug_names(OGRE_LIBRARY_NAMES)




# ************************************************************
# Find path and file
# ************************************************************
package_find_path(OGRE_PATH_INCLUDE "Ogre.h" "${OGRE_SEARCH_PATH_INCLUDE}" "Ogre;OGRE;Ogre3D;OGRE3D;ogre;ogre3d")
package_find_library(OGRE_LIBRARY_DEBUG "${OGRE_LIBRARY_NAMES_DEBUG}" "${OGRE_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library(OGRE_LIBRARY_RELEASE "${OGRE_LIBRARY_NAMES}" "${OGRE_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
package_make_library(OGRE_LIBRARY OGRE_LIBRARY_DEBUG OGRE_LIBRARY_RELEASE)




# ************************************************************
# Search the components
# ************************************************************
ogre_find_component_library(Bites "OgreBites" "OgreApplicationContext.h" "Bites")
ogre_find_component_library(MeshLodGenerator "OgreMeshLodGenerator" "OgreMeshLodGenerator.h" "MeshLodGenerator")
ogre_find_component_library(Overlay "OgreOverlay" "OgreOverlaySystem.h" "Overlay")
ogre_find_component_library(Paging "OgrePaging" "OgrePaging.h" "Paging")
ogre_find_component_library(Terrain "OgreTerrain" "OgreTerrain.h" "Terrain")
ogre_find_component_library(Volume "OgreVolume" "OgreVolumeSource.h" "Volume")




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

    package_find_file(OGRE_BINARY_DEBUG "${OGRE_BINARY_NAMES_DEBUG}" "${OGRE_SEARCH_BINARIES}" "debug")
    package_find_file(OGRE_BINARY_RELEASE "${OGRE_BINARY_NAMES_RELEASE}" "${OGRE_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel")
    
    unset(OGRE_BINARY_NAMES)
    unset(OGRE_BINARY_NAMES_DEBUG)
    unset(OGRE_BINARY_NAMES_RELEASE)
    
    ogre_find_component_binary(Bites "OgreBites")
    ogre_find_component_binary(MeshLodGenerator "OgreBites")
    ogre_find_component_binary(Overlay "OgreOverlay")
    ogre_find_component_binary(Paging "OgrePaging")
    ogre_find_component_binary(Terrain "OgreTerrain")
    ogre_find_component_binary(Volume "OgreVolume")
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
ogre_find_component_library(Plugin_BSPSceneManager "Plugin_BSPSceneManager" "OgreBspSceneManagerPlugin.h" "Plugins/BSPSceneManager")
ogre_find_component_library(Plugin_CgProgramManager "Plugin_CgProgramManager" "OgreCgProgramManager.h" "Plugins/CgProgramManager")
ogre_find_component_library(Plugin_OctreeSceneManager "Plugin_OctreeSceneManager" "OgreOctreePlugin.h" "Plugins/OctreeSceneManager")
ogre_find_component_library(Plugin_OctreeZone "Plugin_OctreeZone" "OgreOctreeZonePlugin.h" "Plugins/OctreeZone")
ogre_find_component_library(Plugin_PCZSceneManager "Plugin_PCZSceneManager" "OgrePCZPlugin.h" "Plugins/PCZSceneManager")
ogre_find_component_library(Plugin_ParticleFX "Plugin_ParticleFX" "OgreParticleFXPlugin.h" "Plugins/ParticleFX")
ogre_find_component_library(Codec_EXR "Codec_EXR" "OgreEXRCodec.h" "Plugins/EXRCodec")
ogre_find_component_library(Codec_FreeImage "Codec_FreeImage" "OgreFreeImageCodec.h" "Plugins/FreeImageCodec")
ogre_find_component_library(Codec_STBI "Codec_STBI" "OgreSTBICodec.h" "Plugins/STBICodec")
ogre_find_component_library(RenderSystem_GL "RenderSystem_GL" "OgreGLPlugin.h" "RenderSystems/GL")
ogre_find_component_library(RenderSystem_GL3Plus "RenderSystem_GL3Plus" "OgreGL3PlusPlugin.h" "RenderSystems/GL3Plus")
ogre_find_component_library(RenderSystem_Direct3D9 "RenderSystem_Direct3D9" "OgreD3D9Plugin.h" "RenderSystems/Direct3D9")
ogre_find_component_library(RenderSystem_Direct3D11 "RenderSystem_Direct3D11" "OgreD3D11Plugin.h" "RenderSystems/Direct3D11")


# Set plugin paths.
if(OGRE_RenderSystem_GL_LIBRARY_DEBUG)
    get_filename_component(OGRE_RenderSystem_GL_FileName ${OGRE_RenderSystem_GL_LIBRARY_DEBUG} NAME)
    package_find_path(OGRE_PATH_PLUGIN_DEBUG "${OGRE_RenderSystem_GL_FileName}" "${OGRE_SEARCH_PLUGINS}" "debug")
    unset(OGRE_RenderSystem_GL_FileName)
endif()

if(OGRE_RenderSystem_GL_LIBRARY_RELEASE)
    get_filename_component(OGRE_RenderSystem_GL_FileName ${OGRE_RenderSystem_GL_LIBRARY_RELEASE} NAME)
    package_find_path(OGRE_PATH_PLUGIN_RELEASE "${OGRE_RenderSystem_GL_FileName}" "${OGRE_SEARCH_PLUGINS}" "release;relwithdebinfo;minsizerel")
    unset(OGRE_RenderSystem_GL_FileName)
endif()




# ************************************************************
# Finalize package
# ************************************************************
package_validate(OGRE)
package_add_parent_dir(OGRE ADD_PARENT)
package_end(OGRE)
message_footer(OGRE)

