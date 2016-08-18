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
# Configure plug-ins
macro( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG Plugins )
    # Help information.
    message_header( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG )
    message_help( "HELP:" )
    message_help( "Variables using in 'plugins_in.cfg':" )
    message_help( "PROJECT_OGRE_SELECTED_PLUGINS : Selected plugins." )
    message_help( "PROJECT_OGRE_PATH_PLUGIN      : Path to the actual plugins." )
    message_help_dash_line()
    message_help( "Variables taken from 'FindCustomOgre.cmake':" )
    message_help( "OGRE_PATH_PLUGIN_DEBUG   : Path to the actual plugins of debug version. " )
    message_help( "OGRE_PATH_PLUGIN_RELEASE : Path to the actual plugins of release version. " )
    message_help_dash_line()
    message_help( "This macro will generate a 'plugins.cfg' from the template 'plugins_in.cfg'" )
    message_help( "located in PROJECT_PATH_TEMPLATE, if [Path] is no specified." )
    message_help_dash_line()
    message_help( "Required:" )
    message_help( "[Plugins]    -> Selected plug-ins." )
    message_help( "Optional:" )
    message_help( "[Path]       -> Location of the templates." )
    message_help( "[SubPath]    -> Sub path of output directory." )
    
    # Default values.
    set( Path "${PROJECT_PATH_TEMPLATE}" )
    
    # Parse options.
    set( options INSTALL )
    set( oneValueArgs Path SubPath )
    cmake_parse_arguments( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG "${options}" "${oneValueArgs}" "" ${ARGN} )
    
    if( NOT OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_INSTALL )
        message_status( STATUS "Configure plugins.cfg."      )
    endif()
    
    if( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_Path )
        set( Path "${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_Path}" )
    endif()
    
    message_status( STATUS "Selected plugins: ${Plugins}"   )
    set( PluginDebug    "" )
    set( PluginRelease  "" )

    # Go through the list and add into correct variable.
    foreach( f ${Plugins} )
        list( APPEND PluginDebug    "\nPlugin=${f}_d"   )
        list( APPEND PluginRelease  "\nPlugin=${f}"     )
    endforeach()

    
    # Generate file for debug.
    # Remove unwanted characters.
    string( REPLACE ";" "" PROJECT_OGRE_SELECTED_PLUGINS ${PluginDebug} )
    set( PROJECT_OGRE_PATH_PLUGIN ${OGRE_PATH_PLUGIN_DEBUG} )
    configure_file( "${Path}/plugins_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/plugins_d.cfg" )
    
    # Generate file for release.
    # Remove unwanted characters.
    string( REPLACE ";" "" PROJECT_OGRE_SELECTED_PLUGINS ${PluginRelease} )
    set( PROJECT_OGRE_PATH_PLUGIN ${OGRE_PATH_PLUGIN_RELEASE} )
    configure_file( "${Path}/plugins_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/plugins.cfg" )
    
    
    # Generate file for install.
    set( PROJECT_OGRE_PATH_PLUGIN "./plugins" )
    string( REPLACE ";" "" PROJECT_OGRE_SELECTED_PLUGINS ${PluginDebug} )
    configure_file( "${Path}/plugins_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/plugins_install_d.cfg" )
    
    string( REPLACE ";" "" PROJECT_OGRE_SELECTED_PLUGINS ${PluginRelease} )
    configure_file( "${Path}/plugins_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/plugins_install.cfg" )
    
    
    # Copy correct file based on the configuration.
    if( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_INSTALL )
        message_status( STATUS "Install plugin.cfg to ${PROJECT_PATH_INSTALL}${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_SubPath}" )
        install(
            FILES
            "${CMAKE_CURRENT_BINARY_DIR}/$<$<CONFIG:debug>:plugins_install_d.cfg>$<$<NOT:$<CONFIG:debug>>:plugins_install.cfg>"
            DESTINATION "${PROJECT_PATH_INSTALL}${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_SubPath}"
            RENAME "plugins.cfg"
        )
    else()
        add_custom_command(
            TARGET ALL_CopyData
            COMMAND ${CMAKE_COMMAND} -E copy
            "${CMAKE_CURRENT_BINARY_DIR}/$<$<CONFIG:debug>:plugins_d.cfg>$<$<NOT:$<CONFIG:debug>>:plugins.cfg>"
            "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_SubPath}/plugins.cfg"
        )
    endif()

    # Clean up.
    unset( oneValueArgs )
    unset( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_INSTALL )
    unset( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_Path )
    unset( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_SubPath )
    unset( SelectedPluginDebug CACHE )
    unset( SelectedPluginRelease CACHE )
    unset( PluginDebug CACHE )
    unset( PluginRelease CACHE )
    
    message_footer( OGRE_CONFIGURE_PLUGIN_CONFIG_CFG )
endmacro()




# ************************************************************
# Configure plugins
macro( OGRE_CONFIGURE_PLUGIN_CONFIG_FILE PLUGINS PATH SUB_PATH)
    message_status( STATUS "Configure plugins.cfg ..." )
    message_status( STATUS "Selected plugins: ${PLUGINS}" )
    set( PLUGIN_DEBUG "" )
    set( PLUGIN_RELEASE "" )

    # Go through the list and add into correct variable.
    foreach( VAR ${PLUGINS} )
        list( APPEND PLUGIN_DEBUG "\nPlugin=${VAR}_d" )
        list( APPEND PLUGIN_RELEASE "\nPlugin=${VAR}" )
    endforeach()


    # Set correct directory and plugins depend on platform and target mode.
    if( MSVC )
        set( PLUGIN_SELECTED_DEBUG ${PLUGIN_DEBUG} )
        set( PLUGIN_SELECTED_RELEASE ${PLUGIN_RELEASE} )
    else()
        if( PROJECT_TARGET_DEBUG )
            set( PLUGIN_SELECTED_DEBUG ${PLUGIN_DEBUG} )
        elseif( PROJECT_TARGET_RELEASE )
            set( PLUGIN_SELECTED_RELEASE ${PLUGIN_RELEASE} )
        else()
            message_status( "" "Couldn't configure plugins.cfg due to invalid target mode." )
        endif()
    endif()


    # Copy files.
    if( PLUGIN_SELECTED_DEBUG )
        # Remove unwanted characters
        string( REPLACE ";" "" PROJECT_OGRE_SELECTED_PLUGINS ${PLUGIN_SELECTED_DEBUG} )
        set( PROJECT_OGRE_PATH_PLUGIN ${OGRE_PATH_PLUGIN_DEBUG} )
        copy_single_file( "${PATH}/plugins_in.cfg" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}${SUB_PATH}/plugins.cfg" "" )
    endif()

    if( PLUGIN_SELECTED_RELEASE )
        # Remove unwanted characters
        string( REPLACE ";" "" PROJECT_OGRE_SELECTED_PLUGINS ${PLUGIN_SELECTED_RELEASE} )
        set( PROJECT_OGRE_PATH_PLUGIN ${OGRE_PATH_PLUGIN_RELEASE} )
        copy_single_file( "${PATH}/plugins_in.cfg" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}${SUB_PATH}/plugins.cfg" "" )
    endif()

    unset( PLUGIN_SELECTED_DEBUG CACHE )
    unset( PLUGIN_SELECTED_RELEASE CACHE )
    unset( PLUGIN_DEBUG CACHE )
    unset( PLUGIN_RELEASE CACHE )
endmacro()
