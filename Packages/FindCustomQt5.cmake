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
message_header(QT)
package_begin(QT)
package_create_home_path(QT QT5_ROOT)

# Options.
option(QT_DEPLOY_LIBRARY "Flag to deploy QT libraries." OFF)
option(QT_PLUGIN_ENABLE_IMAGE_FORMAT "Enable image formats (Ex. jpg, svg, tiff)." OFF)
option(QT_PLUGIN_ENABLE_SQL_DRIVER_SQLITE "Enable SQLite plug-in driver." OFF)


# Set components.
set(QT_AVAILABLE_COMPONENTS
	Qt5
	Qt5AxBase_DIR
	Qt5AxContainer_DIR
	Qt5AxServer_DIR
	Qt5Concurrent_DIR
	Qt5Core_DIR
	Qt5Declarative_DIR
	Qt5Designer_DIR
	Qt5Gui_DIR
	Qt5Help_DIR
	Qt5LinguistTools_DIR
	Qt5Multimedia_DIR
	Qt5MultimediaWidgets_DIR
	Qt5Network_DIR
	Qt5OpenGL_DIR
	Qt5OpenGLExtensions_DIR
	Qt5PrintSupport_DIR
	Qt5Qml_DIR
	Qt5Quick_DIR
	Qt5QuickTest_DIR
	Qt5Script_DIR
	Qt5ScriptTools_DIR
	Qt5Sensors_DIR
	Qt5SerialPort_DIR
	Qt5Sql_DIR
	Qt5Svg_DIR
	Qt5Test_DIR
	Qt5UiTools_DIR
	Qt5WebKit_DIR
	Qt5WebKitWidgets_DIR
	Qt5Widgets_DIR
	Qt5Xml_DIR
	Qt5XmlPatterns_DIR
)

# Component to skip to copy binaries, due the component doesn't
# contain a binary library.
set(QT_SKIP_BINARY_COMPONENT
    Qt5LinguistTools
)



# ************************************************************
# Clear
set(QT_CLEAR_IF_CHANGED 
    QT_HOME
    QT_COMPONENTS
)
foreach(VAR ${QT_CLEAR_IF_CHANGED})
    package_clear_if_changed(${VAR}
        QT_PATH_BINARY
        QT_PATH_CMAKE
        QT_PATH_LIBRARY
        QT_PATH_PLUGIN
        ${QT_AVAILABLE_COMPONENTS}
    )
endforeach()



# ************************************************************
# Continue when the Qt directory is located.
if(QT_HOME)
    # Create search path
    set(QT_PREFIX_PATH ${QT_HOME})
    package_create_search_path_include(QT)
    package_create_search_path_library(QT)

	# Find paths.
    if(WIN32)
        package_find_path(QT_PATH_BINARY "qmake.exe" "${QT_SEARCH_PATH_LIBRARY}" "bin")
    else()
        package_find_path(QT_PATH_BINARY "qmake" "${QT_SEARCH_PATH_LIBRARY}" "bin;qt5/bin")
    endif()
    package_find_path(QT_PATH_CMAKE "Qt5" "${QT_SEARCH_PATH_LIBRARY}" "cmake")
    package_find_path(QT_PATH_LIBRARY "libQt5Core.so;Qt5Core.lib" "${QT_SEARCH_PATH_LIBRARY}" "lib")
    package_find_path(QT_PATH_PLUGIN "platforms" "${QT_SEARCH_PATH_LIBRARY}" "plugins;qt5/plugins")
    
    # Add the directory to the CMake search path.
	set(CMAKE_PREFIX_PATH ${QT_PATH_CMAKE})
	
	# Tell CMake to run MOC when necessary.
	#set(CMAKE_AUTOMOC ON)
	
	# As MOC files are generated in the binary directory,
	# tell CMake to always look for includes there.
	set(CMAKE_INCLUDE_CURRENT_DIR ON)
    
	# Set components.
	set(QT_COMPONENTS "${CustomQt5_FIND_COMPONENTS}" CACHE STRING "Qt5 components.")
	
	# Initialise
	set(QT_BINARY_DEBUG    "")
	set(QT_BINARY_RELEASE  "")
	
	# Find the packages based on defined components.
	if(QT_COMPONENTS)
		foreach(Component ${QT_COMPONENTS})
			find_package("${Component}")
			
			# Find out whether we will skip adding the binary component.
            set(AddComponent TRUE)
            foreach(SkipComponent ${QT_SKIP_BINARY_COMPONENT})
                if(${SkipComponent} STREQUAL ${Component})
                    set(AddComponent FALSE)
                endif()
            endforeach()
            
            # Update binaries.
            if(AddComponent)
                # Find files.
                if(MSVC)
                    # TODO: Why it fails when using DebugFile or ReleaseFile, because it been used in foreach??
                    package_find_file(QtDebugFile "${Component}d.dll" "${QT_PATH_BINARY}" "")
                    package_find_file(QtReleaseFile "${Component}.dll" "${QT_PATH_BINARY}" "")
                else()
                    package_find_file(QtDebugFile "lib${Component}d.so" "${QT_PATH_LIBRARY}" "")
                    package_find_file(QtReleaseFile "lib${Component}.so" "${QT_PATH_LIBRARY}" "")
                endif()

                # Set name.
                if(QtReleaseFile)
                    list(APPEND QT_BINARY_RELEASE ${QtReleaseFile})
                endif()

                if(QtDebugFile)
                    list(APPEND QT_BINARY_DEBUG ${QtDebugFile})
                else()
                    if(QtReleaseFile)
                        list(APPEND QT_BINARY_DEBUG ${QtReleaseFile})
                    endif()
                endif()
            
                unset(QtDebugFile CACHE)
                unset(QtReleaseFile CACHE)
            endif()
            unset(AddComponent)
		endforeach()

		if(QT_BINARY_DEBUG OR QT_BINARY_RELEASE)
			set(QT_FOUND TRUE)
            message_debug(STATUS "Qt is located.")
			
            # Copy necessary binaries for both release and debug.
            if(QT_DEPLOY_LIBRARY)
                message_debug(STATUS "Search for necessary files.")
                
                
                # Setup search configurations.
                set(PathSearchBinary ${QT_PATH_BINARY})
                if(UNIX)
                    set(PathSearchBinary ${QT_PATH_LIBRARY})
                endif()
                create_dynamic_extension(DynamicSuffix)
                
                # Automatic search for files.
                # set(SearchFiles 
                    # "${PathSearchBinary}/*icu*.${DynamicSuffix}"
                    # "${PathSearchBinary}/*EGL*.${DynamicSuffix}"
                    # "${PathSearchBinary}/*GLES*.${DynamicSuffix}"
                    # "${QT_PATH_PLUGIN}/platforms/*"
                # )
                
                # if(QT_PLUGIN_ENABLE_SQL_DRIVER_SQLITE)
                    # list(APPEND SearchFiles "${QT_PATH_PLUGIN}/sqldrivers/*")
                # endif()
                
                
                # Search for files.
                # file(GLOB QtNecessaryBinaries ${SearchFiles})
                
                # Manually defined search files. In this way we can determind
                # wheter to copy separately into debug and release directory.
                # ----------------------------------------
                # - CORE
                # ----------------------------------------
                # Icu files.
                file(GLOB QtIcuFiles "${PathSearchBinary}/*icu*.${DynamicSuffix}")
                
                # Core files.
                set(QtNecessaryBinaries
                    "libEGL"
                    "libGLESv2"
                )
                
                # ----------------------------------------
                # - PLUGINS
                # ----------------------------------------
                # Platform plugins.
                set(QtNecessaryPlugins
                    "platforms/qminimal"
                    "platforms/qoffscreen"
                )
                if(MSVC)
                    list(APPEND QtNecessaryPlugins
                        "platforms/qwindows"
                    )
                endif()
                
                # Image format plugins.
                if(QT_PLUGIN_ENABLE_IMAGE_FORMAT)
                    list(APPEND QtNecessaryPlugins
                        "imageformats/qdds"
                        "imageformats/qgif"
                        "imageformats/qicns"
                        "imageformats/qico"
                        "imageformats/qjpeg"
                        "imageformats/qsvg"
                        "imageformats/qtga"
                        "imageformats/qtiff"
                        "imageformats/qwbmp"
                        "imageformats/qwebp"
                    )
                endif()
                
                # SQL plugins.
                if(QT_PLUGIN_ENABLE_SQL_DRIVER_SQLITE)
                    list(APPEND QtNecessaryPlugins
                        "sqldrivers/qsqlite"
                    )
                endif()
            endif()
		endif()
	else()
		message_status("" "At least one of the Qt5 modules must be specified.")
	endif()
endif()




# ************************************************************
# Finalize package
if(QT_FOUND)
	message_status(STATUS "The Qt5 library is located.")
else()
	message_status("" "Failed to locate the Qt5 library.")
endif()
message_footer(QT)




# ************************************************************
# Copy QT configuration file.
macro(QT_COPY_CONFIGURATION_FILE)
    if(QT_FOUND)
        add_data_target("${PROJECT_PATH_CMAKE_TEMPLATE}/qt_in.conf" Name "qt.conf" GENERATE)
    endif()
endmacro()




# ************************************************************
# Copy necessary binaries.
macro(QT_COPY_NECESSARY_BINARIES)
    if(QT_FOUND AND QT_DEPLOY_LIBRARY AND WIN32)
        foreach(Plugin ${QT_NECESSARY_BINARY_PLUGINS})
            # Find whether the file is a debug.
            string(REGEX MATCH "d.dll" DEBUG_FOUND ${Plugin})
            if(DEBUG_FOUND)
                copy_single_file("${QT_HOME}/plugins/${Plugin}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${Plugin}" "COPYONLY")
            else()
                copy_single_file("${QT_HOME}/plugins/${Plugin}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${Plugin}" "COPYONLY")
            endif()
            unset(DEBUG_FOUND)
        endforeach()
    endif()
endmacro()




# ************************************************************
# Copy necessary binaries from target.
macro(QT_COPY_NECESSARY_BINARY_FROM_TARGET)
    message_header(QT_COPY_NECESSARY_BINARY_FROM_TARGET)
    message_help("Optional:")
    message_help("[INSTALL]    -> Enable install configuration." )
    message_help("[SubPath]    -> Sub path of output directory.")
    
    
    if(QT_FOUND AND QT_DEPLOY_LIBRARY)
        create_dynamic_extension(DynamicSuffix)
        #foreach(Var ${QtNecessaryBinaries})
        #    # Find whether the file is a debug.
        #    string(REGEX MATCH "d.${DynamicSuffix}" DebugFound ${Var})
        #    if(DebugFound)
        #        package_add_runtime_target("${Var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
        #    else()
        #        package_add_runtime_target("${Var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
        #    endif()
        #    unset(DebugFound)
        #endforeach()
        
        
        # Parse options.
        set(options INSTALL)
        set(oneValueArgs Name SubPath)
        cmake_parse_arguments(QT_COPY_NECESSARY_BINARY_FROM_TARGET "${options}" "${oneValueArgs}" "" ${ARGN})
        
        # Icu files.
        foreach(Var ${QtIcuFiles})
            package_add_runtime_target("${Var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
            package_add_runtime_target("${Var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
            
            if(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
                install(FILES "${Var}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}")
                message_verbose(STATUS "Install [${Var}] to ${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}.")
            endif()
        endforeach()
        
        # Binary files.
        foreach(Var ${QtNecessaryBinaries})
            package_find_file(QtDebugFile "${Var}d.${DynamicSuffix}" "${PathSearchBinary}" "")
            package_find_file(QtReleaseFile "${Var}.${DynamicSuffix}" "${PathSearchBinary}" "")
            
            if(QtReleaseFile)
                package_add_runtime_target("${QtReleaseFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
                if(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
                    install(FILES "${QtReleaseFile}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}" CONFIGURATIONS Release)
                    message_verbose(STATUS "Install [${QtReleaseFile}] to ${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath} for Release.")
                endif()
                
                if(QtDebugFile)
                    package_add_runtime_target("${QtDebugFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
                    
                    if(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
                        install(FILES "${QtDebugFile}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}" CONFIGURATIONS Debug)
                        message_verbose(STATUS "Install [${QtDebugFile}] to ${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath} for Debug.")
                    endif()
                else()
                    package_add_runtime_target("${QtReleaseFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
                    
                    if(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
                        install(FILES "${QtReleaseFile}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}" CONFIGURATIONS Debug)
                        message_verbose(STATUS "Install [${QtReleaseFile}] to ${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath} for Debug.")
                    endif()
                endif()
            else()
                message_status(STATUS "Missing Qt necessary binary: ${Var}")
            endif()
            unset(QtDebugFile CACHE)
            unset(QtReleaseFile CACHE)
        endforeach()
        
        # Plugin files.
        foreach(Var ${QtNecessaryPlugins})
            package_find_file(QtDebugFile "${Var}d.${DynamicSuffix}" "${QT_PATH_PLUGIN}" "")
            package_find_file(QtReleaseFile "${Var}.${DynamicSuffix}" "${QT_PATH_PLUGIN}" "")
            
            if(QtReleaseFile)
                get_filename_component(Path ${Var} PATH)
                package_add_runtime_target("${QtReleaseFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${Path}")
                
                if(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
                    install(FILES "${QtReleaseFile}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}/${Path}" CONFIGURATIONS Release)
                    message_verbose(STATUS "Install [${QtReleaseFile}] to ${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}/${Path} for Release.")
                endif()
                
                if(QtDebugFile)
                    package_add_runtime_target("${QtDebugFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${Path}")
                    
                    if(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
                        install(FILES "${QtDebugFile}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}/${Path}" CONFIGURATIONS Release)
                        message_verbose(STATUS "Install [${QtDebugFile}] to ${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}/${Path} for Debug.")
                    endif()
                else()
                    package_add_runtime_target("${QtReleaseFile}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${Path}")
                    
                    if(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
                        install(FILES "${QtReleaseFile}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}/${Path}" CONFIGURATIONS Release)
                        message_verbose(STATUS "Install [${QtReleaseFile}] to ${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}/${Path} for Debug.")
                    endif()
                endif()
                unset(Path)
            else()
                message_status(STATUS "Missing Qt necessary binary: ${Var}")
            endif()
            unset(QtDebugFile CACHE)
            unset(QtReleaseFile CACHE)
        endforeach()
        
        # Cleaning up.
        unset(Var)
        unset(options)
        unset(oneValueArgs)
        unset(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
        unset(QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath)
    endif()
    
    message_footer(QT_COPY_NECESSARY_BINARY_FROM_TARGET)
endmacro()




# ************************************************************
# Copy QT configuration file.
macro(QT_DEPLOY_RUNTIME_FILES)
    if(QT_FOUND)
        if(QT_DEPLOY_LIBRARY)
            package_copy_binary_from_target(QT)
            qt_copy_necessary_binary_from_target()
        else()
            add_data_target("${PROJECT_PATH_CMAKE_TEMPLATE}/qt_in.conf" Name "qt.conf" GENERATE)
        endif()
    endif()
endmacro()




# ************************************************************
# Install necessary binaries.
macro(QT_INSTALL_NECESSARY_BINARIES)
    # Help information.
    message_header(QT_INSTALL_NECESSARY_BINARIES)
    message_help("Optional:")
    message_help("[SubPath]    -> Sub path of output directory.")
    
    # Parse options.
    set(oneValueArgs SubPath)
    cmake_parse_arguments(QT_INSTALL_NECESSARY_BINARIES "" "${oneValueArgs}" "" ${ARGN})
    
    if(NOT_USED AND QT_FOUND AND QT_DEPLOY_LIBRARY AND WIN32)
        foreach(Bin ${QT_NECESSARY_BINARY_BIN})
            install(FILES "${QT_HOME}/bin/${Bin}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}")
            message_verbose(STATUS "Install [${QT_HOME}/bin/${Bin}] to ${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}.")
        endforeach()
        
        foreach(Plugin ${QT_NECESSARY_BINARY_PLUGINS})
            # Find whether the file is a debug.
            string(REGEX MATCH "d.dll" DebugFound ${Plugin})
            get_filename_component(Path ${Plugin} PATH)
            if(DebugFound)
                install(FILES "${QT_HOME}/plugins/${Plugin}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}/${Path}" CONFIGURATIONS Debug)
            else()
                install(FILES "${QT_HOME}/plugins/${Plugin}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}/${Path}" CONFIGURATIONS Release)
            endif()
            message_verbose(STATUS "Install [${QT_HOME}/plugins/${Plugin}] to ${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}/${Path}.")
            unset(Path)
            unset(DebugFound)
        endforeach()
    endif()
    
    # Clean up.
    unset(oneValueArgs)
    unset(QT_INSTALL_NECESSARY_BINARIES_SubPath)
    
    message_footer(QT_INSTALL_NECESSARY_BINARIES)
endmacro()


# ************************************************************
# Available modules in Qt5
# Qt5
# Qt5AxBase
# Qt5AxContainer
# Qt5AxServer
# Qt5Concurrent
# Qt5Core
# Qt5Declarative
# Qt5Designer
# Qt5Gui
# Qt5Help
# Qt5LinguistTools
# Qt5Multimedia
# Qt5MultimediaWidgets
# Qt5Network
# Qt5OpenGL
# Qt5OpenGLExtensions
# Qt5PrintSupport
# Qt5Qml
# Qt5Quick
# Qt5QuickTest
# Qt5Script
# Qt5ScriptTools
# Qt5Sensors
# Qt5SerialPort
# Qt5Sql
# Qt5Svg
# Qt5Test
# Qt5UiTools
# Qt5WebKit
# Qt5WebKitWidgets
# Qt5Widgets
# Qt5Xml
# Qt5XmlPatterns

