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
# Configure Plug-ins
# ************************************************************
macro(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG Plugins)
    # Help information.
    cm_message_header(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG)
    message_help("HELP:")
    message_help("This macro will generate a 'plugins.cfg' from the template 'plugins_in.cfg'.")
    message_help("Variables using in 'plugins_in.cfg':")
    message_help("PROJECT_TEMPLATE_SELECTED_PLUGIN_OGRE  : Selected plugins.")
    message_help("PROJECT_TEMPLATE_PLUGIN_PATH_OGRE      : Path to the actual plugins.")
    message_help_dash_line()
    message_help("Variables taken from 'FindCustomOgre.cmake':")
    message_help("OGRE_PATH_PLUGIN_DEBUG   : Path to the actual plugins of debug version.")
    message_help("OGRE_PATH_PLUGIN_RELEASE : Path to the actual plugins of release version.")
    message_help_dash_line()
    message_help("This macro will generate a 'plugins.cfg' from the template 'plugins_in.cfg'")
    message_help("located in PROJECT_PATH_TEMPLATE, if [Path] is no specified.")
    message_help_dash_line()
    message_help("Required:")
    message_help("[Plugins]")
    message_help("      Selected plug-ins.")
    message_help("Optional:")
    message_help("[Path]")
    message_help("      Define the location of the template (plugins_in.cfg).")
    message_help("      Otherwise default location is used, defined in PROJECT_PATH_TEMPLATE.")
    message_help("[SubPath]")
    message_help("      Sub path of output directory.")
    message_help("[InstallPath]")
    message_help("      Define the install path of the file.")
    message_help("      Otherwise default location is used defined in PROJECT_PATH_INSTALL.")
    message_help("[InstallLocation]")
    message_help("      Define the install location in the template.")
    message_help("      Otherwise default location is used (./plugins).")
    message_help("[INSTALL]")
    message_help("      Also adding into the INSTALL target.")
    
    # Default values.
    set(Path "${PROJECT_PATH_TEMPLATE}")
    set(InstallLocation "./plugins")
    set(InstallPath "${PROJECT_PATH_INSTALL}")
    
    # Parse options.
    cm_message_status(STATUS "Configure plugins.cfg.")
    set(options INSTALL)
    set(oneValueArgs Path SubPath InstallPath InstallLocation)
    cmake_parse_arguments(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG "${options}" "${oneValueArgs}" "" ${ARGN})
    
    if(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_Path)
        set(Path "${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_Path}")
    endif()
    
    cm_message_status(STATUS "Selected plugins:")
    foreach(Var ${Plugins})
        cm_message_status(STATUS " * ${Var}")
    endforeach()
    unset(Var)
    
    # Work vars.
    set(PluginDebug "")
    set(PluginRelease "")

    # Go through the list and add into correct variable.
    foreach(Var ${Plugins})
        if(APPLE)
            list(APPEND PluginDebug "\nPlugin=${Var}")
        else()
            list(APPEND PluginDebug "\nPlugin=${Var}_d")
        endif()
        list(APPEND PluginRelease "\nPlugin=${Var}")
    endforeach()
    unset(Var)


    # ----------------------------------------
    # Debug
    # ----------------------------------------
    # Remove unwanted characters.
    string(REPLACE ";" "" PROJECT_TEMPLATE_SELECTED_PLUGIN_OGRE ${PluginDebug})
    if(APPLE)
        set(PROJECT_TEMPLATE_PLUGIN_PATH_OGRE "")
    else()
        set(PROJECT_TEMPLATE_PLUGIN_PATH_OGRE ${OGRE_PATH_PLUGIN_DEBUG})
    endif()
    configure_file("${Path}/plugins_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/plugins_d.cfg")
    
    
    # ----------------------------------------
    # Release
    # ----------------------------------------
    # Remove unwanted characters.
    string(REPLACE ";" "" PROJECT_TEMPLATE_SELECTED_PLUGIN_OGRE ${PluginRelease})
    if(APPLE)
        set(PROJECT_TEMPLATE_PLUGIN_PATH_OGRE "")
    else()
        set(PROJECT_TEMPLATE_PLUGIN_PATH_OGRE ${OGRE_PATH_PLUGIN_RELEASE})
    endif()
    configure_file("${Path}/plugins_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/plugins.cfg")


    # Add to copy target.
    if(MSVC OR XCODE)
        add_custom_command(
            TARGET ALL_CopyData
            COMMAND ${CMAKE_COMMAND} -E copy
            "${CMAKE_CURRENT_BINARY_DIR}/$<$<CONFIG:debug>:plugins_d.cfg>$<$<NOT:$<CONFIG:debug>>:plugins.cfg>"
            "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_SubPath}/plugins.cfg"
        )
    else()
        add_custom_command(
            TARGET ALL_CopyData
            COMMAND ${CMAKE_COMMAND} -E copy
            "${CMAKE_CURRENT_BINARY_DIR}/$<$<CONFIG:debug>:plugins_d.cfg>$<$<NOT:$<CONFIG:debug>>:plugins.cfg>"
            "${PROJECT_PATH_OUTPUT_EXECUTABLE}/${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_SubPath}/plugins.cfg"
        )
    endif()
    
    
    # ----------------------------------------
    # Install
    # ----------------------------------------
    if(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_INSTALL)
        if(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_InstallLocation)
            set(InstallLocation ${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_InstallLocation})
        endif()

        if(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_InstallPath)
            set(InstallPath ${OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_InstallPath})
        endif()

        if(APPLE)
            set(PROJECT_TEMPLATE_PLUGIN_PATH_OGRE "")
        else()
            set(PROJECT_TEMPLATE_PLUGIN_PATH_OGRE ${InstallLocation})
        endif()
        string(REPLACE ";" "" PROJECT_TEMPLATE_SELECTED_PLUGIN_OGRE ${PluginDebug})
        configure_file("${Path}/plugins_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/plugins_install_d.cfg")
        
        string(REPLACE ";" "" PROJECT_TEMPLATE_SELECTED_PLUGIN_OGRE ${PluginRelease})
        configure_file("${Path}/plugins_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/plugins_install.cfg")
        
        # Copy correct file based on the configuration.
        cm_message_status(STATUS "Adding 'plugins.cfg' into the INSTALL target at destination ${InstallPath}")

        install(
            FILES
            "${CMAKE_CURRENT_BINARY_DIR}/plugins_install_d.cfg"
            DESTINATION "${InstallPath}"
            CONFIGURATIONS "debug"
            RENAME "plugins.cfg"
        )
        install(
            FILES
            "${CMAKE_CURRENT_BINARY_DIR}/plugins_install.cfg"
            DESTINATION "${InstallPath}"
            CONFIGURATIONS "release"
            RENAME "plugins.cfg"
        )
    endif()


    # Clean up.
    unset(oneValueArgs )
    unset(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_INSTALL)
    unset(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_Path)
    unset(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG_SubPath)
    unset(SelectedPluginDebug CACHE)
    unset(SelectedPluginRelease CACHE)
    unset(PluginDebug CACHE)
    unset(PluginRelease CACHE)
    
    message_footer(OGRE_CONFIGURE_PLUGIN_CONFIG_CFG)
endmacro()



# ************************************************************
# Configure Resources
# ************************************************************
macro(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG)
    # Help information.
    cm_message_header(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG)
    message_help("HELP:")
    message_help("This macro will generate a 'resources.cfg' from the template 'resources_in.cfg'.")
    message_help("Variables using in 'resources_in.cfg':")
    message_help("PROJECT_TEMPLATE_MEDIA_OGRE: Path to the actual media.")
    message_help_dash_line()
    message_help("Optional:")
    message_help("[Path]")
    message_help("      Define the location of the template (resources_in.cfg).")
    message_help("      Otherwise default location is used, defined in PROJECT_PATH_TEMPLATE.")
    message_help("[SubPath]")
    message_help("      Sub path of output directory.")
    message_help("[InstallPath]")
    message_help("      Define the install path of the file.")
    message_help("      Otherwise default location is used defined in PROJECT_PATH_INSTALL.")
    message_help("[MediaLocation]")
    message_help("      Define actual media location in the template.")
    message_help("      Otherwise default location is used, defined in PROJECT_PATH_MEDIA_OGRE.")
    message_help("[InstallLocation]")
    message_help("      Define the install location in the template.")
    message_help("      Otherwise default location is used (./data/media/ogre).")
    message_help("[INSTALL]")
    message_help("      Also adding into the INSTALL target.")
    
    # Default values.
    set(Path "${PROJECT_PATH_TEMPLATE}")
    set(MediaLocation "${PROJECT_PATH_MEDIA_OGRE}")
    set(InstallLocation "./data/media/ogre")
    set(InstallPath "${PROJECT_PATH_INSTALL}")
    
    # Parse options.
    cm_message_status(STATUS "Configure resources.cfg.")
    set(options INSTALL)
    set(oneValueArgs Path SubPath InstallPath MediaLocation InstallLocation)
    cmake_parse_arguments(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG "${options}" "${oneValueArgs}" "" ${ARGN})

    if(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_Path)
        set(Path "${OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_Path}")
    endif()

    if(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_MediaLocation)
        set(MediaLocation "${OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_MediaLocation}")
    endif()

    
    # Add to ALL_CopyData target.
    set(PROJECT_TEMPLATE_MEDIA_OGRE "${MediaLocation}")
    configure_file("${Path}/resources_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/resources.cfg")
    if(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_SubPath)
        add_data_target("${CMAKE_CURRENT_BINARY_DIR}/resources.cfg" SubPath "${OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_SubPath}")
    else()
        add_data_target("${CMAKE_CURRENT_BINARY_DIR}/resources.cfg")
    endif()


    # Add to INSTALL target.
    if(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_INSTALL)
        if(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_InstallLocation)
            set(InstallLocation "${OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_InstallLocation}")
        endif()
        set(PROJECT_TEMPLATE_MEDIA_OGRE "${InstallLocation}")
        configure_file("${Path}/resources_in.cfg" "${CMAKE_CURRENT_BINARY_DIR}/resources_install.cfg")

        if(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_InstallPath)
            set(InstallPath "${OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_InstallPath}")
        endif()
        cm_message_status(STATUS "Adding 'resources.cfg' into the INSTALL target at destination ${InstallPath}")
        install(FILES "${CMAKE_CURRENT_BINARY_DIR}/resources_install.cfg" DESTINATION "${InstallPath}" RENAME "resources.cfg")
    endif()

    
    # Clean up.
    unset(oneValueArgs)
    unset(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_INSTALL)
    unset(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_Path)
    unset(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_SubPath)
    unset(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_InstallPath)
    unset(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_MediaLocation)
    unset(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG_InstallLocation)
    
    message_footer(OGRE_CONFIGURE_RESOURCE_CONFIG_CFG)
endmacro()

