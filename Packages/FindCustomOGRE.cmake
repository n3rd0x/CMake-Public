# ************************************************************
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the “Software”),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
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
message_header( OGRE )
package_begin( OGRE )
package_create_home_path( OGRE OGRE_ROOT )


# ************************************************************
# Find binary
macro( OGRE_FIND_COMPONENT_BINARY COMPONENT NAME )
	set( OGRE_${COMPONENT}_BINARY_NAMES "${NAME}" )
	package_create_debug_binary_names( OGRE_${COMPONENT}_BINARY_NAMES )
	package_create_release_binary_names( OGRE_${COMPONENT}_BINARY_NAMES )
	package_find_file( OGRE_${COMPONENT}_BINARY_DEBUG "${OGRE_${COMPONENT}_BINARY_NAMES_DEBUG}" "${OGRE_SEARCH_BINARIES}" "debug" )
	package_find_file( OGRE_${COMPONENT}_BINARY_RELEASE "${OGRE_${COMPONENT}_BINARY_NAMES_RELEASE}" "${OGRE_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
	unset( OGRE_${COMPONENT}_BINARY_NAMES )
	unset( OGRE_${COMPONENT}_BINARY_NAMES_DEBUG )
	unset( OGRE_${COMPONENT}_BINARY_NAMES_RELEASE )
endmacro()


# ************************************************************
# Find library
macro( OGRE_FIND_COMPONENT_LIBRARY COMPONENT NAME HEADER SUFFIX )
	set( OGRE_${COMPONENT}_LIBRARY_NAMES "${NAME}" )
	package_create_debug_names( OGRE_${COMPONENT}_LIBRARY_NAMES )
	package_find_path( OGRE_${COMPONENT}_PATH_INCLUDE "${HEADER}" "${OGRE_SEARCH_PATH_INCLUDE}" "${SUFFIX}" )
	package_find_library( OGRE_${COMPONENT}_LIBRARY_DEBUG "${OGRE_${COMPONENT}_LIBRARY_NAMES_DEBUG}" "${OGRE_SEARCH_PATH_LIBRARY}" "debug"  )
	package_find_library( OGRE_${COMPONENT}_LIBRARY_RELEASE "${OGRE_${COMPONENT}_LIBRARY_NAMES}" "${OGRE_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )
	package_make_library( OGRE_${COMPONENT}_LIBRARY OGRE_${COMPONENT}_LIBRARY_DEBUG OGRE_${COMPONENT}_LIBRARY_RELEASE )
	package_validate( OGRE_${COMPONENT} )
	package_end( OGRE_${COMPONENT} )
	unset( OGRE_${COMPONENT}_LIBRARY_NAMES )
	unset( OGRE_${COMPONENT}_LIBRARY_NAMES_DEBUG )
endmacro()


if( OGRE_USE_CUSTOM_PACKAGE )
	# ************************************************************
	# Create search path
	set( OGRE_PREFIX_PATH ${OGRE_HOME} )
	package_create_search_path_binary( OGRE )
	package_create_search_path_include( OGRE )
	package_create_search_path_library( OGRE )
	package_create_search_path_plugin( OGRE )

	
	# ************************************************************
	# Clear
	if( WIN32 )
		package_clear_if_changed( OGRE_PREFIX_PATH
			OGRE_OVERLAY_BINARY_DEBUG
			OGRE_OVERLAY_BINARY_RELEASE
			OGRE_OVERLAY_LIBRARY_DEBUG
			OGRE_OVERLAY_LIBRARY_RELEASE
			OGRE_OVERLAY_PATH_INCLUDE
			OGRE_PAGING_BINARY_DEBUG
			OGRE_PAGING_BINARY_RELEASE
			OGRE_PAGING_LIBRARY_DEBUG
			OGRE_PAGING_LIBRARY_RELEASE
			OGRE_PAGING_PATH_INCLUDE
			OGRE_TERRAIN_BINARY_DEBUG
			OGRE_TERRAIN_BINARY_RELEASE
			OGRE_TERRAIN_LIBRARY_DEBUG
			OGRE_TERRAIN_LIBRARY_RELEASE
			OGRE_TERRAIN_PATH_INCLUDE
			OGRE_VOLUME_BINARY_DEBUG
			OGRE_VOLUME_BINARY_RELEASE
			OGRE_VOLUME_LIBRARY_DEBUG
			OGRE_VOLUME_LIBRARY_RELEASE
			OGRE_VOLUME_PATH_INCLUDE
			OGRE_BINARY_DEBUG
			OGRE_BINARY_RELEASE
			OGRE_LIBRARY_DEBUG
			OGRE_LIBRARY_RELEASE
			OGRE_PATH_INCLUDE
			OGRE_PATH_PLUGIN_DEBUG
			OGRE_PATH_PLUGIN_RELEASE
		)
	else()
		package_clear_if_changed( OGRE_PREFIX_PATH
			OGRE_OVERLAY_LIBRARY_DEBUG
			OGRE_OVERLAY_LIBRARY_RELEASE
			OGRE_OVERLAY_PATH_INCLUDE
			OGRE_PAGING_LIBRARY_DEBUG
			OGRE_PAGING_LIBRARY_RELEASE
			OGRE_PAGING_PATH_INCLUDE
			OGRE_TERRAIN_LIBRARY_DEBUG
			OGRE_TERRAIN_LIBRARY_RELEASE
			OGRE_TERRAIN_PATH_INCLUDE
			OGRE_VOLUME_LIBRARY_DEBUG
			OGRE_VOLUME_LIBRARY_RELEASE
			OGRE_VOLUME_PATH_INCLUDE
			OGRE_LIBRARY_DEBUG
			OGRE_LIBRARY_RELEASE
			OGRE_PATH_INCLUDE
			OGRE_PATH_PLUGIN_DEBUG
			OGRE_PATH_PLUGIN_RELEASE
		)
	endif()
	
	
	# ************************************************************
	# Create search name
	set( OGRE_LIBRARY_NAMES "OgreMain" )
	package_create_debug_names( OGRE_LIBRARY_NAMES )


	# ************************************************************
	# Find path and file
	package_find_path( OGRE_PATH_INCLUDE "Ogre.h" "${OGRE_SEARCH_PATH_INCLUDE}" "Ogre;OGRE;Ogre3D;OGRE3D;ogre;ogre3d" )
	package_find_library( OGRE_LIBRARY_DEBUG "${OGRE_LIBRARY_NAMES_DEBUG}" "${OGRE_SEARCH_PATH_LIBRARY}" "debug"  )
	package_find_library( OGRE_LIBRARY_RELEASE "${OGRE_LIBRARY_NAMES}" "${OGRE_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )
	package_make_library( OGRE_LIBRARY OGRE_LIBRARY_DEBUG OGRE_LIBRARY_RELEASE )


	# ************************************************************
	# Search for path of plug-ins
	set( OGRE_PLUGIN_NAMES "RenderSystem_GL")
	set( OGRE_SEARCH_PLUGIN_PREFIX
		${OGRE_SEARCH_PATH_LIBRARY}
		${OGRE_SEARCH_PATH_BINARY}
		${OGRE_SEARCH_PATH_PLUGIN}
	)
	package_create_debug_binary_names( OGRE_PLUGIN_NAMES )
	package_create_release_binary_names( OGRE_PLUGIN_NAMES )
	package_find_path( OGRE_PATH_PLUGIN_DEBUG "${OGRE_PLUGIN_NAMES_DEBUG}" "${OGRE_SEARCH_PLUGIN_PREFIX}" "debug"  )
	package_find_path( OGRE_PATH_PLUGIN_RELEASE "${OGRE_PLUGIN_NAMES_RELEASE}" "${OGRE_SEARCH_PLUGIN_PREFIX}" "release;relwithdebinfo;minsizerel"  )


	# ************************************************************
	# Search the components
	ogre_find_component_library( OVERLAY "OgreOverlay" "OgreOverlaySystem.h" "Overlay" )
	ogre_find_component_library( PAGING "OgrePaging" "OgrePaging.h" "Paging" )
	ogre_find_component_library( TERRAIN "OgreTerrain" "OgreTerrain.h" "Terrain" )
	ogre_find_component_library( VOLUME "OgreVolume" "OgreVolumeSource.h" "Volume" )


	# ************************************************************
	# Find binaries on Windows
	if( WIN32 )
		set( OGRE_SEARCH_BINARIES 
			${OGRE_SEARCH_PATH_BINARY}
			${OGRE_SEARCH_PATH_LIBRARY}
		)
		
		set( OGRE_BINARY_NAMES "OgreMain" )
		package_create_release_binary_names( OGRE_BINARY_NAMES )
		package_create_debug_binary_names( OGRE_BINARY_NAMES )
		package_find_file( OGRE_BINARY_DEBUG "${OGRE_BINARY_NAMES_DEBUG}" "${OGRE_SEARCH_BINARIES}" "debug" )
		package_find_file( OGRE_BINARY_RELEASE "${OGRE_BINARY_NAMES_RELEASE}" "${OGRE_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
		unset( OGRE_BINARY_NAMES )
		unset( OGRE_BINARY_NAMES_DEBUG )
		unset( OGRE_BINARY_NAMES_RELEASE )
		
		ogre_find_component_binary( OVERLAY "OgreOverlay" )
		ogre_find_component_binary( PAGING "OgrePaging" )
		ogre_find_component_binary( TERRAIN "OgreTerrain" )
		ogre_find_component_binary( VOLUME "OgreVolume" )
	endif()
else()
	# ************************************************************
	# Clear
    package_clear_if_changed( OGRE_HOME
        OGRE_INCLUDE_DIR
        OGRE_BINARY_DBG
        OGRE_BINARY_REL
        OGRE_Overlay_BINARY_DBG
        OGRE_Overlay_BINARY_REL
        OGRE_Paging_BINARY_DBG
        OGRE_Paging_BINARY_REL
        OGRE_Plugin_BSPSceneManager_DBG
        OGRE_Plugin_BSPSceneManager_REL
        OGRE_Plugin_CgProgramManager_DBG
        OGRE_Plugin_CgProgramManager_REL
        OGRE_Plugin_OctreeSceneManager_DBG
        OGRE_Plugin_OctreeSceneManager_REL
        OGRE_Plugin_OctreeZone_DBG
        OGRE_Plugin_OctreeZone_REL
        OGRE_Plugin_PCZSceneManager_DBG
        OGRE_Plugin_PCZSceneManager_REL
        OGRE_Plugin_ParticleFX_DBG
        OGRE_Plugin_ParticleFX_REL
        OGRE_Property_BINARY_DBG
        OGRE_Property_BINARY_REL
        OGRE_Property_INCLUDE_DIR
        OGRE_Property_LIBRARY_DBG
        OGRE_Property_LIBRARY_REL
        OGRE_RTShaderSystem_BINARY_DBG
        OGRE_RTShaderSystem_BINARY_REL
        OGRE_RTShaderSystem_INCLUDE_DIR
        OGRE_RTShaderSystem_LIBRARY_DBG
        OGRE_RTShaderSystem_LIBRARY_REL
        OGRE_RenderSystem_Direct3D11_DBG
        OGRE_RenderSystem_Direct3D11_REL
        OGRE_RenderSystem_Direct3D9_DBG
        OGRE_RenderSystem_Direct3D9_REL
        OGRE_RenderSystem_GL_DBG
        OGRE_RenderSystem_GL_REL
        OGRE_Terrain_BINARY_DBG
        OGRE_Terrain_BINARY_REL
        OGRE_Volume_BINARY_DBG
        OGRE_Volume_BINARY_REL
    )
	
	# ************************************************************
	# Use official package
	find_package( OGRE )
	
    set( OGRE_PATH_INCLUDE          "${OGRE_INCLUDE_DIR}"     )
    set( OGRE_PATH_PLUGIN_DEBUG     "${OGRE_PLUGIN_DIR_DBG}"  )
    set( OGRE_PATH_PLUGIN_RELEASE   "${OGRE_PLUGIN_DIR_REL}"  )
    
	# ************************************************************
	# Find binaries
    set( OGRE_BINARY_DEBUG              "${OGRE_BINARY_DBG}"          )
    set( OGRE_BINARY_RELEASE            "${OGRE_BINARY_REL}"          )
    set( OGRE_Overlay_BINARY_DEBUG      "${OGRE_Overlay_BINARY_DBG}"  )
    set( OGRE_Overlay_BINARY_RELEASE    "${OGRE_Overlay_BINARY_REL}"  )
    set( OGRE_Paging_BINARY_DEBUG       "${OGRE_Paging_BINARY_DBG}"   )
    set( OGRE_Paging_BINARY_RELEASE     "${OGRE_Paging_BINARY_REL}"   )
    set( OGRE_Terrain_BINARY_DEBUG      "${OGRE_Terrain_BINARY_DBG}"  )
    set( OGRE_Terrain_BINARY_RELEASE    "${OGRE_Terrain_BINARY_REL}"  )
    set( OGRE_Volume_BINARY_DEBUG       "${OGRE_Volume_BINARY_DBG}"   )
    set( OGRE_Volume_BINARY_RELEASE     "${OGRE_Volume_BINARY_REL}"   )
    set( OGRE_BSPSceneManager_PLUGIN_DEBUG      "${OGRE_Plugin_BSPSceneManager_DBG}"      )
    set( OGRE_BSPSceneManager_PLUGIN_RELEASE    "${OGRE_Plugin_BSPSceneManager_REL}"      )
    set( OGRE_CgProgramManager_PLUGIN_DEBUG     "${OGRE_Plugin_CgProgramManager_DBG}"     )
    set( OGRE_CgProgramManager_PLUGIN_RELEASE   "${OGRE_Plugin_CgProgramManager_REL}"     )
    set( OGRE_OctreeSceneManager_PLUGIN_DEBUG   "${OGRE_Plugin_OctreeSceneManager_DBG}"   )
    set( OGRE_OctreeSceneManager_PLUGIN_RELEASE "${OGRE_Plugin_OctreeSceneManager_REL}"   )
    set( OGRE_OctreeZone_PLUGIN_DEBUG           "${OGRE_Plugin_OctreeZone_DBG}"           )
    set( OGRE_OctreeZone_PLUGIN_RELEASE         "${OGRE_Plugin_OctreeZone_REL}"           )
    set( OGRE_PCZSceneManager_PLUGIN_DEBUG      "${OGRE_Plugin_PCZSceneManager_DBG}"      )
    set( OGRE_PCZSceneManager_PLUGIN_RELEASE    "${OGRE_Plugin_PCZSceneManager_DBG}"      )
    set( OGRE_ParticleFX_PLUGIN_DEBUG           "${OGRE_Plugin_ParticleFX_DBG}"           )
    set( OGRE_ParticleFX_PLUGIN_RELEASE         "${OGRE_Plugin_ParticleFX_REL}"           )
    
    # Set available plug ins.
    set( OGRE_PLUGINS_DEBUG
        "${OGRE_BSPSceneManager_PLUGIN_DEBUG}"
        "${OGRE_CgProgramManager_PLUGIN_DEBUG}"
        "${OGRE_OctreeSceneManager_PLUGIN_DEBUG}"
        "${OGRE_OctreeZone_PLUGIN_DEBUG}"
        "${OGRE_PCZSceneManager_PLUGIN_DEBUG}"
        "${OGRE_ParticleFX_PLUGIN_DEBUG}"
    )
    
    set( OGRE_PLUGINS_RELEASE
        "${OGRE_BSPSceneManager_PLUGIN_RELEASE}"
        "${OGRE_CgProgramManager_PLUGIN_RELEASE}"
        "${OGRE_OctreeSceneManager_PLUGIN_RELEASE}"
        "${OGRE_OctreeZone_PLUGIN_RELEASE}"
        "${OGRE_PCZSceneManager_PLUGIN_RELEASE}"
        "${OGRE_ParticleFX_PLUGIN_RELEASE}"
    )
    
    set( OGRE_PLUGINS "${OGRE_PLUGINS_DEBUG}" "${OGRE_PLUGINS_RELEASE}" )
endif()


# ************************************************************
# Finalize package
package_add_parent_dir( OGRE )
if( OGRE_USE_CUSTOM_PACKAGE )
	package_validate( OGRE )
endif()
package_end( OGRE )
message_footer( OGRE )

