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
# Following should be deprecated.
option(QT_COMPILED_WITH_ANGLE "Qt compiled with ANGLE." OFF)
option(QT_HAS_ICU_SUPPORT "Qt has ICU support." OFF)
option(QT_VERSION_5_3_2 "Using QT version 5.3.2 and greater." OFF)


option(QT_DEPLOY_LIBRARY "Flag to deploy QT libraries." OFF)
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

# Copy necessary binaries for both release and debug.
if(QT_DEPLOY_LIBRARY)
    # TODO: Should automatically search using regex to find these files.
    
    # ----------------------------------------
    # - CORE
    # ----------------------------------------
    set(QT_NECESSARY_BINARY_BIN "")
    if(QT_HAS_ICU_SUPPORT)
        # Necessary binary version.
        set(QtIcuVersion "51")
        if(QT_VERSION_5_3_2)
            set(QtIcuVersion "52")
        endif()
        
        set(QT_NECESSARY_BINARY_BIN
            #"d3dcompiler_46.dll"
            "icudt${QtIcuVersion}.dll"
            "icuin${QtIcuVersion}.dll"
            "icuuc${QtIcuVersion}.dll"
        )
    endif()

    # OpenGL.
    if(QT_COMPILED_WITH_ANGLE)
        set(QT_NECESSARY_BINARY_BIN
            "${QT_NECESSARY_BINARY_BIN}"
            "libEGL.dll"
            "libEGLd.dll"
            "libGLESv2.dll"
            "libGLESv2d.dll"
        )
    endif()

    
    # ----------------------------------------
    # - PLUGINS
    # ----------------------------------------
    # Platforms.
    set(QT_Qt5Core_BINARY_PLUGINS
        "platforms/qminimal.dll"
        "platforms/qminimald.dll"
        "platforms/qoffscreen.dll"
        "platforms/qoffscreend.dll"
        "platforms/qwindows.dll"
        "platforms/qwindowsd.dll"
    )

    # SQL (SQLite).
    set(QT_Qt5Sql_Sqlite_BINARY_PLUGINS
        "sqldrivers/qsqlite.dll"
        "sqldrivers/qsqlited.dll"
    )

    # Add .
    set(QT_NECESSARY_BINARY_PLUGINS "${QT_Qt5Core_BINARY_PLUGINS}")
    if(QT_PLUGIN_ENABLE_SQL_DRIVER_SQLITE)
        set(QT_NECESSARY_BINARY_PLUGINS
            "${QT_NECESSARY_BINARY_PLUGINS}"
            "${QT_Qt5Sql_Sqlite_BINARY_PLUGINS}"
        )
    endif()
endif()

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
        QT_BINARY_DIR
        QT_LIBRARY_DIR
        QT_PLUGIN_DIR
        ${QT_AVAILABLE_COMPONENTS}
    )
endforeach()




# ************************************************************
# Continue when the Qt directory is located.
if(QT_HOME)
	# Add the directory to the CMake search path.
	set(CMAKE_PREFIX_PATH ${QT_HOME})
	
	# Tell CMake to run MOC when necessary.
	#set(CMAKE_AUTOMOC ON)
	
	# As MOC files are generated in the binary directory,
	# tell CMake to always look for includes there.
	set(CMAKE_INCLUDE_CURRENT_DIR ON)
	
	# Set paths.
    
	set(QT_BINARY_DIR "${QT_HOME}/bin" CACHE PATH "Path of Qt5 binary directory.")
	set(QT_LIBRARY_DIR "${QT_HOME}/lib" CACHE PATH "Path of Qt5 library directory.")
    set(QT_PLUGIN_DIR "${QT_HOME}/plugins" CACHE PATH "Path of Qt5 plugin directory.")

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
                    package_find_file(DebugFile "${Component}d.dll" "${QT_BINARY_DIR}" "")
                    package_find_file(ReleaseFile "${Component}.dll" "${QT_BINARY_DIR}" "")
                    
                    
                    #find_file(DebugFile NAMES "${Component}d.dll" HINTS "${QT_BINARY_DIR}" PATH_SUFFIXES "" NO_DEFAULT_PATH)
                    #find_file(ReleaseFile NAMES "${Component}.dll" HINTS "${QT_BINARY_DIR}" PATH_SUFFIXES "" NO_DEFAULT_PATH)
                else()
                    package_find_file(DebugFile "lib${Component}d.so" "${QT_LIBRARY_DIR}" "")
                    package_find_file(ReleaseFile "lib${Component}.so" "${QT_LIBRARY_DIR}" "")
                    
                    #find_file(DebugFile NAMES "lib${Component}d.so" HINTS "${QT_LIBRARY_DIR}" PATH_SUFFIXES "" NO_DEFAULT_PATH)
                    #find_file(ReleaseFile NAMES "lib${Component}.so" HINTS "${QT_LIBRARY_DIR}" PATH_SUFFIXES "" NO_DEFAULT_PATH)
                endif()
                
                # Set name.
                if(ReleaseFile)
                    list(APPEND QT_BINARY_RELEASE ${ReleaseFile})
                endif()

                if(DebugFile)
                    list(APPEND QT_BINARY_DEBUG ${DebugFile})
                else()
                    list(APPEND QT_BINARY_DEBUG ${ReleaseFile})
                endif()
            
                unset(DebugFile CACHE)
                unset(ReleaseFile CACHE)
            endif()
            unset(AddComponent)
		endforeach()
		
		if(QT_BINARY_DEBUG OR QT_BINARY_RELEASE)
			set(QT_FOUND TRUE)
			# Add necessary binary libraries.
			# if( WIN32 )
				# # For both release and debug.
				# foreach( BINARY ${QT_NECESSARY_BINARIES} )
					# set( QT_BINARY_DEBUG ${QT_BINARY_DEBUG} "${QT_BINARY_DIR}/${BINARY}" )
					# set( QT_BINARY_RELEASE ${QT_BINARY_RELEASE} "${QT_BINARY_DIR}/${BINARY}" )
				# endforeach()
				
				# # Separate release and debug.
				# foreach( BINARY ${QT_NECESSARY_BINARIES_SEPARATE} )
					# string( REGEX MATCH "d.dll" DEBUG_FOUND ${BINARY} )
					# if( DEBUG_FOUND )
						# set( QT_BINARY_DEBUG ${QT_BINARY_DEBUG} "${QT_BINARY_DIR}/${BINARY}" )
					# else()
						# set( QT_BINARY_RELEASE ${QT_BINARY_RELEASE} "${QT_BINARY_DIR}/${BINARY}" )
					# endif()
					# unset( DEBUG_FOUND )
				# endforeach()
			# endif()
		endif()
	else()
		message_status( "" "At least one of the Qt5 modules must be specified." )
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
        add_data_target("${PROJECT_PATH_CMAKE_TEMPLATE}/qt_in.conf" Name "qt.conf" GENERATE )
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
    if(QT_FOUND AND QT_DEPLOY_LIBRARY AND WIN32)
        foreach(Bin ${QT_NECESSARY_BINARY_BIN})
            if(QT_COMPILED_WITH_ANGLE)
                # Find whether the file is a debug.
                string(REGEX MATCH "d.dll" DebugFound ${Bin})
                if(DebugFound)
                    package_add_runtime_target("${QT_HOME}/bin/${Bin}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
                else()
                    package_add_runtime_target("${QT_HOME}/bin/${Bin}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
                endif()
                unset(DebugFound)
            else()
                package_add_runtime_target("${QT_HOME}/bin/${Bin}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
                package_add_runtime_target("${QT_HOME}/bin/${Bin}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
            endif()
        endforeach()
        
        foreach(Plugin ${QT_NECESSARY_BINARY_PLUGINS})
            # Find whether the file is a debug.
            string(REGEX MATCH "d.dll" DebugFound ${Plugin})
            get_filename_component(Path ${Plugin} PATH)
            if(DebugFound)
                package_add_runtime_target("${QT_HOME}/plugins/${Plugin}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${Path}")
            else()
                package_add_runtime_target("${QT_HOME}/plugins/${Plugin}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${Path}")
            endif()
            unset(Path)
            unset(DebugFound)
        endforeach()
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
    
    if(QT_FOUND AND QT_DEPLOY_LIBRARY AND WIN32)
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

