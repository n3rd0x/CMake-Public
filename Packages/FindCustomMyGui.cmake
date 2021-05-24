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
# Website: http://mygui.info


# ************************************************************
# Start package
cm_message_header( MYGUI )
package_begin( MYGUI )
package_create_home_path( MYGUI MYGUI_ROOT )


# ************************************************************
# Create search path
set( MYGUI_PREFIX_PATH ${MYGUI_HOME} )
package_create_search_path_include( MYGUI )
package_create_search_path_media( MYGUI )
package_create_search_path_library( MYGUI )


# ************************************************************
# Define library name
set( MYGUI_LIBRARY_ENGINE_NAMES "MyGUIEngine" )
set( MYGUI_LIBRARY_PLATFORM_NAMES "MyGUI.OgrePlatform" )
package_create_debug_names( MYGUI_LIBRARY_ENGINE_NAMES )
package_create_debug_names( MYGUI_LIBRARY_PLATFORM_NAMES )


# ************************************************************
# Clear
package_clear_if_changed( MYGUI_PREFIX_PATH
    MYGUI_LIBRARY_ENGINE_RELEASE
    MYGUI_LIBRARY_ENGINE_DEBUG
    MYGUI_LIBRARY_PLATFORM_RELEASE
    MYGUI_LIBRARY_PLATFORM_DEBUG
    MYGUI_PATH_INCLUDE
    MYGUI_PATH_MEDIA
)


# ************************************************************
# Find path and header file
package_find_path( MYGUI_PATH_INCLUDE "MyGUI.h" "${MYGUI_SEARCH_PATH_INCLUDE}" "MYGUI;MyGui;mygui" )

package_find_library( MYGUI_LIBRARY_ENGINE_DEBUG "${MYGUI_LIBRARY_ENGINE_NAMES_DEBUG}" "${MYGUI_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( MYGUI_LIBRARY_ENGINE_RELEASE "${MYGUI_LIBRARY_ENGINE_NAMES}" "${MYGUI_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )

package_find_library( MYGUI_LIBRARY_PLATFORM_DEBUG "${MYGUI_LIBRARY_PLATFORM_NAMES_DEBUG}" "${MYGUI_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( MYGUI_LIBRARY_PLATFORM_RELEASE "${MYGUI_LIBRARY_PLATFORM_NAMES}" "${MYGUI_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )


# ************************************************************
# Make library set
package_make_library( MYGUI_LIBRARY_ENGINE MYGUI_LIBRARY_ENGINE_DEBUG MYGUI_LIBRARY_ENGINE_RELEASE )
package_make_library( MYGUI_LIBRARY_PLATFORM MYGUI_LIBRARY_PLATFORM_DEBUG MYGUI_LIBRARY_PLATFORM_RELEASE )


# ************************************************************
# Locate media path
package_find_path( MYGUI_PATH_MEDIA "MyGUI_Pointers.png" "${MYGUI_HOME};${MYGUI_SEARCH_PATH_MEDIA}" "Media/MyGUI_Media;share/MYGUI/Media/MyGUI_Media" )


# ************************************************************
# Find binaries
if( WIN32 )
	set( MYGUI_BINARY_NAMES "MyGUIEngine" )
	package_create_release_binary_names( MYGUI_BINARY_NAMES )
	package_create_debug_binary_names( MYGUI_BINARY_NAMES )
	package_create_search_path_binary( MYGUI )

	set( MYGUI_SEARCH_BINARIES
		${MYGUI_SEARCH_PATH_BINARY}
		${MYGUI_SEARCH_PATH_LIBRARY}
	)

	package_clear_if_changed( MYGUI_PREFIX_PATH
		MYGUI_BINARY_RELEASE
		MYGUI_BINARY_DEBUG
	)

	package_find_file( MYGUI_BINARY_DEBUG "${MYGUI_BINARY_NAMES_DEBUG}" "${MYGUI_SEARCH_BINARIES}" "debug" )
	package_find_file( MYGUI_BINARY_RELEASE "${MYGUI_BINARY_NAMES_RELEASE}" "${MYGUI_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )
endif()


# ************************************************************
# Validation
if( NOT MYGUI_FOUND )
    if( MYGUI_PATH_INCLUDE AND MYGUI_LIBRARY_ENGINE AND MYGUI_LIBRARY_PLATFORM )
        set( MYGUI_FOUND TRUE )
        set( MYGUI_LIBRARIES ${MYGUI_LIBRARY_ENGINE} ${MYGUI_LIBRARY_PLATFORM} )
        set( MYGUI_INCLUDE_DIR ${MYGUI_PATH_INCLUDE} )
    endif()
endif()


# ************************************************************
# Finalize package
package_add_parent_dir( MYGUI )
package_end( MYGUI )
cm_message_footer( MYGUI )

