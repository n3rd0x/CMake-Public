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
# Website: https://www.qt.io


# ************************************************************
# Start Package
# ************************************************************
cm_message_header(QT)
cm_package_begin(QT)
cm_package_create_home_path(QT QT5_ROOT)


# Options.
# Enable auto linking to 'qtmain' (new for Qt5).
cmake_policy(SET CMP0020 NEW)

option(QT_ENABLE_AUTOMOC "Enable auto MOC." OFF)
option(QT_ENABLE_AUTORCC "Enable auto RCC." OFF)
option(QT_ENABLE_AUTOUIC "Enable auto UIC." OFF)
option(QT_DEPLOY_LIBRARY "Flag to deploy QT libraries into binary directory." OFF)
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

# component to skip to copy binaries, due the component doesn't
# contain a binary library.
set(QT_SKIP_BINARY_COMPONENT
    Qt5LinguistTools
)


# ************************************************************
# Clear
# ************************************************************
set(_clear
    QT_HOME
    QT_COMPONENTS
)
foreach(var ${_clear})
    cm_package_clear_if_changed(${var}
        QT_PATH_BINARY
        QT_PATH_CMAKE
        QT_PATH_LIBRARY
        QT_PATH_PLUGIN
        ${QT_AVAILABLE_COMPONENTS}
    )
endforeach()
unset(_clear)


# ************************************************************
# Create Search _path
# ************************************************************
set(QT_PREFIX_PATH ${QT_HOME})
cm_package_create_search_path_include(QT)
cm_package_create_search_path_library(QT)
#cm_package_create_search_path_binary(QT)


# ************************************************************
# Find _path
# ************************************************************
set(_qmake "qmake")
set(_qlibs "libQt5Core.so" "Qt5Core.lib" "QtCore.framework")
cm_create_executable_extension(_qmake)
cm_package_find_path(QT_PATH_BINARY "${_qmake}" "${QT_HOME}" "bin;qt5/bin")
cm_package_find_path(QT_PATH_CMAKE "Qt5" "${QT_SEARCH_PATH_LIBRARY}" "cmake")
cm_package_find_path(QT_PATH_LIBRARY "${_qlibs}" "${QT_SEARCH_PATH_LIBRARY}" "")
cm_package_find_path(QT_PATH_PLUGIN "platforms" "${QT_HOME}" "plugins;qt5/plugins")

# Add the directory to the CMake search path.
set(CMAKE_PREFIX_PATH ${QT_PATH_CMAKE})


# ************************************************************
# Setup QT configuration
# ************************************************************
# Tell CMake to run MOC when necessary.
if(QT_ENABLE_AUTOMOC)
    set(CMAKE_AUTOMOC ON)
    cm_message_verbose(STATUS "Enable AUTO MOC.")
endif()

# Tell CMake to run RCC when necessary.
if(QT_ENABLE_AUTORCC)
    set(CMAKE_AUTORCC ON)
    cm_message_verbose(STATUS "Enable AUTO RCC.")
endif()

# Tell CMake to run UIC when necessary.
if(QT_ENABLE_AUTOUIC)
    set(CMAKE_AUTOUIC ON)
    cm_message_verbose(STATUS "Enable AUTO UIC.")
endif()

# As MOC files are generated in the binary directory,
# tell CMake to always look for includes there.
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Set components.
set(QT_COMPONENTS "${CustomQt5_FIND_COMPONENTS}" CACHE STRING "Qt5 components.")


# ************************************************************
# Find Dynamic Libraris
# ************************************************************
set(QT_BINARY_DEBUG "")
set(QT_BINARY_RELEASE "")

# Find the packages based on defined components.
if(QT_COMPONENTS)
    # Setup search configurations.
    set(_pathSearch ${QT_PATH_BINARY})
    if(APPLE)
        set(_pathSearch ${QT_HOME})
    elseif(UNIX)
        set(_pathSearch ${QT_PATH_LIBRARY})
    endif()


    foreach(component ${QT_COMPONENTS})
        find_package("${component}")

        if(NOT APPLE)
            # Find out whether we will skip adding the binary component.
            set(_add TRUE)
            foreach(skip ${QT_SKIP_BINARY_COMPONENT})
                if(${skip} STREQUAL ${component})
                    set(_add FALSE)
                endif()
            endforeach()

            # Update binaries.
            if(_add)
                # Find files.
                if(MSVC)
                    cm_package_find_file(_debug "${component}d.dll" "${_pathSearch}" "")
                    cm_package_find_file(_release "${component}.dll" "${_pathSearch}" "")
                else()
                    cm_package_find_file(_debug "lib${component}d.so" "${_pathSearch}" "")
                    cm_package_find_file(_release "lib${component}.so" "${_pathSearch}" "")
                endif()

                # Set name.
                if(_release)
                    list(APPEND QT_BINARY_RELEASE ${_release})
                endif()

                if(_debug)
                    list(APPEND QT_BINARY_DEBUG ${_debug})
                else()
                    if(_release)
                        list(APPEND QT_BINARY_DEBUG ${_release})
                    endif()
                endif()

                unset(_debug CACHE)
                unset(_release CACHE)
            endif()
            unset(_add)
        elseif(APPLE)
            # Simply to TRUE if component is found.
            if(${component}_LIBRARIES)
                list(APPEND QT_BINARY_RELEASE ${${component}_LIBRARIES})
                list(APPEND QT_BINARY_DEBUG ${${component}_LIBRARIES})
            endif()
        endif()
    endforeach()


    if(QT_BINARY_DEBUG OR QT_BINARY_RELEASE)
        set(QT_FOUND TRUE)
        cm_message_debug(STATUS "Qt is located.")


        # Copy necessary binaries for both release and debug.
        if(QT_DEPLOY_LIBRARY)
            cm_message_debug(STATUS "Search for necessary files.")
            cm_generate_dynamic_extension(_extSuffix)

            # Automatic search for files.
            # set(SearchFiles
                # "${_pathSearch}/*icu*.${_extSuffix}"
                # "${_pathSearch}/*EGL*.${_extSuffix}"
                # "${_pathSearch}/*GLES*.${_extSuffix}"
                # "${QT_PATH_PLUGIN}/platforms/*"
            # )

            # if(QT_PLUGIN_ENABLE_SQL_DRIVER_SQLITE)
                # list(APPEND SearchFiles "${QT_PATH_PLUGIN}/sqldrivers/*")
            # endif()


            # Search for files.
            # file(GLOB mQtNecessaryBinaries ${SearchFiles})


            # Manually defined search files. In this way we can determind
            # wether to copy separately into debug and release directory.
            if(NOT APPLE)
                # ----------------------------------------
                # - CORE
                # ----------------------------------------
                # Icu files.
                file(GLOB mQtIcuFiles "${_pathSearch}/*icu*.${_extSuffix}")

                # Core files.
                set(mQtNecessaryBinaries
                    "libEGL"
                    "libGLESv2"
                )
            endif()


            # ----------------------------------------
            # - PLUGINS
            # ----------------------------------------
            # Platform plugins.
            set(mQtNecessaryPlugins
                "platforms/qminimal"
                "platforms/qoffscreen"
            )
            if(MSVC)
                list(APPEND mQtNecessaryPlugins
                    "platforms/qwindows"
                )
            elseif(APPLE)
                list(APPEND mQtNecessaryPlugins
                    "platforms/qcocoa"
                )
            endif()

            # Image format plugins.
            if(QT_PLUGIN_ENABLE_IMAGE_FORMAT)
                if(NOT APPLE)
                    list(APPEND mQtNecessaryPlugins
                        "imageformats/qdds"
                    )
                elseif(APPLE)
                    list(APPEND mQtNecessaryPlugins
                        "imageformats/qmacheif"
                        "imageformats/qmacjp2"
                    )
                endif()

                list(APPEND mQtNecessaryPlugins
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
                list(APPEND mQtNecessaryPlugins
                    "sqldrivers/qsqlite"
                )
            endif()

            unset(_extSuffix)
        endif()
    endif()
    unset(_pathSearch)
else()
    cm_message_status("" "At least one of the Qt5 modules must be specified.")
endif()




# ************************************************************
# Finalize Package
# ************************************************************
if(QT_FOUND)
    cm_message_status(STATUS "The Qt5 library is located.")
else()
    cm_message_status("" "Failed to locate the Qt5 library.")
endif()
cm_message_footer(QT)




# ************************************************************
# Copy QT Configuration File
# ************************************************************
macro(QT_COPY_CONFIGURATION_FILE)
    if(QT_FOUND)
        add_data_target(
            "${PROJECT_PATH_CMAKE_TEMPLATE}/qt_in.conf"
            Name "qt.conf"
            GENERATE
        )
    endif()
endmacro()




# ************************************************************
# Copy Necessary Binaries
# ************************************************************
macro(QT_COPY_NECESSARY_BINARIES)
    if(QT_FOUND AND QT_DEPLOY_LIBRARY AND WIN32)
        foreach(plugin ${QT_NECESSARY_BINARY_PLUGINS})
            # Find whether the file is a debug.
            string(REGEX MATCH "d.dll" _debug ${plugin})
            if(_debug)
                cm_copy_single_file(
                    "${QT_PATH_PLUGIN}/${plugin}"
                    "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${plugin}"
                    "COPYONLY"
                )
            else()
                cm_copy_single_file(
                    "${QT_PATH_PLUGIN}/${plugin}"
                    "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${plugin}"
                    "COPYONLY"
                )
            endif()
            unset(_debug)
        endforeach()
    endif()
endmacro()




# ************************************************************
# Copy Necessary Binaries from Target
# ************************************************************
# Help information.
# Optional:
# [INSTALL]    -> Enable install configuration.
# [SubPath]    -> Sub path of install directory.
macro(QT_COPY_NECESSARY_BINARY_FROM_TARGET)
    cm_message_header(QT_COPY_NECESSARY_BINARY_FROM_TARGET)

    if(QT_FOUND AND QT_DEPLOY_LIBRARY)
        cm_generate_dynamic_extension(_extSuffix)
        #foreach(var ${mQtNecessaryBinaries})
        #    # Find whether the file is a debug.
        #    string(REGEX MATCH "d.${_extSuffix}" DebugFound ${var})
        #    if(DebugFound)
        #        cm_package_add_runtime_target("${var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
        #    else()
        #        cm_package_add_runtime_target("${var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
        #    endif()
        #    unset(DebugFound)
        #endforeach()


        # ----------------------------------------
        # Parse Options
        # ----------------------------------------
        set(_options INSTALL)
        set(_oneValueArgs Name SubPath)
        cmake_parse_arguments(QT_COPY_NECESSARY_BINARY_FROM_TARGET "${_options}" "${_oneValueArgs}" "" ${ARGN})

        set(_installPath "${PROJECT_PATH_INSTALL}${QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath}")
        set(_debugSuffix "d")
        set(_preSuffix "")
        if(APPLE)
            set(_debugSuffix "_debug")
            set(_preSuffix "lib")
        endif()


        # ----------------------------------------
        # Icu Files
        # ----------------------------------------
        foreach(var ${mQtIcuFiles})
            if(MSVC OR XCODE)
                cm_package_add_runtime_target("${var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}")
                cm_package_add_runtime_target("${var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}")
            else()
                cm_package_add_runtime_target("${var}" "${PROJECT_PATH_OUTPUT_EXECUTABLE}")
            endif()

            if(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
                install(FILES "${var}" DESTINATION "${_installPath}")
                cm_message_verbose(STATUS "Install [${var}] to ${_installPath}.")
            endif()
        endforeach()


        # ----------------------------------------
        # Binary Files
        # ----------------------------------------
        foreach(var ${mQtNecessaryBinaries})
            get_filename_component(_name ${var} NAME)
            get_filename_component(_path ${var} PATH)

            cm_package_find_file(_debug "${_preSuffix}${_name}${_debugSuffix}.${_extSuffix}" "${_pathSearch}" "${_path}")
            cm_package_find_file(_release "${_preSuffix}${_name}.${_extSuffix}" "${_pathSearch}" "${_path}")

            if(_release)
                qt_copy_necessary_binary_from_target_helper(
                    _release
                    _debug
                    _path
                    QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL
                    _installPath
                )
            else()
                cm_message_status(STATUS "Missing Qt necessary binary: ${var}")
            endif()

            unset(_name)
            unset(_path)
            unset(_debug CACHE)
            unset(_release CACHE)
        endforeach()


        # ----------------------------------------
        # Plugin Files
        # ----------------------------------------
        foreach(var ${mQtNecessaryPlugins})
            get_filename_component(_name ${var} NAME)
            get_filename_component(_path ${var} PATH)

            cm_package_find_file(_debug "${_preSuffix}${_name}${_debugSuffix}.${_extSuffix}" "${QT_PATH_PLUGIN}" "${_path}")
            cm_package_find_file(_release "${_preSuffix}${_name}.${_extSuffix}" "${QT_PATH_PLUGIN}" "${_path}")

            if(_release)
                qt_copy_necessary_binary_from_target_helper(
                    _release
                    _debug
                    _path
                    QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL
                    _installPath
                )
            else()
                cm_message_status(STATUS "Missing Qt necessary plugin: ${var}")
            endif()

            unset(_name)
            unset(_path)
            unset(_debug CACHE)
            unset(_release CACHE)
        endforeach()

        # Cleaning up.
        unset(_debugtSuffix)
        unset(_extSuffix)
        unset(_options)
        unset(_oneValueArgs)
        unset(QT_COPY_NECESSARY_BINARY_FROM_TARGET_INSTALL)
        unset(QT_COPY_NECESSARY_BINARY_FROM_TARGET_SubPath)
    endif()

    cm_message_footer(QT_COPY_NECESSARY_BINARY_FROM_TARGET)
endmacro()



# ************************************************************
# Helper Function of (QT_COPY_NECESSARY_BINARY_FROM_TARGET)
# ************************************************************
macro(QT_COPY_NECESSARY_BINARY_FROM_TARGET_HELPER ReleaseFile DebugFile SubPath INSTALL InstallPath)
    # ----------------------------------------
    # Multiple Configurations
    # ----------------------------------------
    if(MSVC OR XCODE)
        cm_package_add_runtime_target("${${ReleaseFile}}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${${SubPath}}")
        if(INSTALL)
            install(FILES "${${ReleaseFile}}" DESTINATION "${${InstallPath}}/${${SubPath}}" CONFIGURATIONS Release)
            cm_message_verbose(STATUS "Install [${${ReleaseFile}}] to ${${InstallPath}}/${${SubPath}} for Debug.")
        endif()

        if(${DebugFile})
            cm_package_add_runtime_target("${${DebugFile}}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${${SubPath}}")
            if(INSTALL)
                install(FILES "${${DebugFile}}" DESTINATION "${${InstallPath}}/${${SubPath}}" CONFIGURATIONS Debug)
                cm_message_verbose(STATUS "Install [${${DebugFile}}] to ${${InstallPath}}/${${SubPath}} for Debug.")
            endif()
        else()
            cm_package_add_runtime_target("${${ReleaseFile}}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${${SubPath}}")
            if(INSTALL)
                install(FILES "${${ReleaseFile}}" DESTINATION "${${InstallPath}}/${${SubPath}}" CONFIGURATIONS Debug)
                cm_message_verbose(STATUS "Install [${${ReleaseFile}}] to ${${InstallPath}}/${${SubPath}} for Debug.")
            endif()
        endif()
    # ----------------------------------------
    # Single Configurations
    # ----------------------------------------
    else()
        set(_debugMode FALSE)
        if(CMAKE_BUILD_TYPE MATCHES Debug)
            set(_debugMode TRUE)
        endif()

        if(_debugMode)
            if(${DebugFile})
                cm_package_add_runtime_target("${${DebugFile}}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${${SubPath}}")
                if(INSTALL)
                    install(FILES "${${DebugFile}}" DESTINATION "${${InstallPath}}/${${SubPath}}" CONFIGURATIONS Debug)
                    cm_message_verbose(STATUS "Install [${${DebugFile}}] to ${${InstallPath}}/${${SubPath}} for Debug.")
                endif()
            else()
                cm_package_add_runtime_target("${${ReleaseFile}}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_DEBUG}/${${SubPath}}")
                if(INSTALL)
                    install(FILES "${${ReleaseFile}}" DESTINATION "${${InstallPath}}/${${SubPath}}" CONFIGURATIONS Debug)
                    cm_message_verbose(STATUS "Install [${${ReleaseFile}}] to ${${InstallPath}}/${${SubPath}} for Debug.")
                endif()
            endif()
        else()
            cm_package_add_runtime_target("${${ReleaseFile}}" "${PROJECT_PATH_OUTPUT_EXECUTABLE_RELEASE}/${${SubPath}}")
            if(INSTALL)
                install(FILES "${${ReleaseFile}}" DESTINATION "${${InstallPath}}/${${SubPath}}" CONFIGURATIONS Release)
                cm_message_verbose(STATUS "Install [${${ReleaseFile}}] to ${${InstallPath}}/${${SubPath}} for Debug.")
            endif()
        endif()

        unset(_debugMode)
    endif()
endmacro()




# ************************************************************
# Copy QT Configuration File
# ************************************************************
macro(QT_DEPLOY_RUNTIME_FILES)
    if(QT_FOUND)
        if(QT_DEPLOY_LIBRARY)
            cm_package_copy_binary_from_target(QT)
            qt_copy_necessary_binary_from_target()
        else()
            qt_copy_configuration_file()
        endif()
    endif()
endmacro()




# ************************************************************
# Install necessary binaries.
macro(QT_INSTALL_NECESSARY_BINARIES)
    # Help information.
    cm_message_header(QT_INSTALL_NECESSARY_BINARIES)
    cm_message_help("Optional:")
    cm_message_help("[SubPath]    -> Sub path of output directory.")

    # Parse _options.
    set(_oneValueArgs SubPath)
    cmake_parse_arguments(QT_INSTALL_NECESSARY_BINARIES "" "${_oneValueArgs}" "" ${ARGN})

    if(NOT_USED AND QT_FOUND AND QT_DEPLOY_LIBRARY AND WIN32)
        foreach(Bin ${QT_NECESSARY_BINARY_BIN})
            install(FILES "${QT_HOME}/bin/${Bin}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}")
            cm_message_verbose(STATUS "Install [${QT_HOME}/bin/${Bin}] to ${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}.")
        endforeach()

        foreach(Plugin ${QT_NECESSARY_BINARY_PLUGINS})
            # Find whether the file is a debug.
            string(REGEX MATCH "d.dll" DebugFound ${Plugin})
            get_filename_component(_path ${Plugin} PATH)
            if(DebugFound)
                install(FILES "${QT_HOME}/plugins/${Plugin}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}/${_path}" CONFIGURATIONS Debug)
            else()
                install(FILES "${QT_HOME}/plugins/${Plugin}" DESTINATION "${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}/${_path}" CONFIGURATIONS Release)
            endif()
            cm_message_verbose(STATUS "Install [${QT_HOME}/plugins/${Plugin}] to ${PROJECT_PATH_INSTALL}${QT_INSTALL_NECESSARY_BINARIES_SubPath}/${_path}.")
            unset(_path)
            unset(DebugFound)
        endforeach()
    endif()

    # Clean up.
    unset(_oneValueArgs)
    unset(QT_INSTALL_NECESSARY_BINARIES_SubPath)

    cm_message_footer(QT_INSTALL_NECESSARY_BINARIES)
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
