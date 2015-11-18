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




# ************************************************************
# Generate resource file
macro( QT_GENERATE_RESOURCE SrcFile DstFile )
    # Verify that the 'rcc' do exists.
    if( WIN32 )
        set( Program "rcc.exe" )
    else()
        set( Program "rcc" )
    endif()
    
    # Parse options.
    set( oneValueArgs SubPath )
    cmake_parse_arguments( QT_GENERATE_RESOURCE "${options}" "${oneValueArgs}" "" ${ARGN} )
    
    # Working members.
    set( FileToCopy "${CMAKE_CURRENT_BINARY_DIR}/${DstFile}" )
    if( MSVC )
        set( OutputPath "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>" )
    else()
        set( OutputPath "${PROJECT_PATH_OUTPUT_EXECUTABLE}" )
    endif()
    
    if( QT_GENERATE_RESOURCE_SubPath )
        set( OutputPath "${OutputPath}/${QT_GENERATE_RESOURCE_SubPath}" )
    endif()
    
    # Execute.
    find_file( ProgramFound NAMES "${Program}" HINTS "${QT_BINARY_DIR}" )
    if( ProgramFound )
        execute_process( COMMAND "${ProgramFound}" -binary ${SrcFile} -o "${FileToCopy}" )
        message_verbose( STATUS "Generate binary resource file: ${DstFile}" )
    endif()
    
    # Copy to output directory.
    copy_file_to_output_directory( "${FileToCopy}" "${DstFile}" )
    # Add command.
    # add_custom_command(
        # TARGET All_CopyData
        # COMMAND ${CMAKE_COMMAND} -E copy_if_different
        # ${FileToCopy}
        # "${OutputPath}/${DstFile}"
    # )
    
    

    
    # Clean up.
    unset( oneValueArgs )
    unset( QT_GENERATE_RESOURCE_SubPath )
    unset( ProgramFound CACHE )
endmacro()




# ************************************************************
# Generate source translation file
macro( QT_GENERATE_TRANSLATION TranslationFiles SrcFiles )
    # Verify that the 'lupdate' do exists.
    if( WIN32 )
        set( Program "lupdate.exe" )
    else()
        set( Program "lupdate" )
    endif()
    
    find_file( ProgramFound NAMES "${Program}" HINTS "${QT_BINARY_DIR}" )
    if( ProgramFound )
        foreach( LanguageFile ${TranslationFiles} )	
            # Update language file.
            execute_process( COMMAND "${ProgramFound}" -I ${SrcFiles} -ts ${LanguageFile} -no-obsolete )
            message_verbose( STATUS "Update language file: ${LanguageFile}" )
        endforeach()
    endif()
    
    unset( ProgramFound CACHE )
endmacro()




# ************************************************************
# Copy (and install) translation files
macro( QT_COPY_OR_INSTALL_TRANSLATION TRANSLATION_FILES SUBPATH INSTALL )
    foreach( LANGUAGE_FILE ${TRANSLATION_FILES} )
        # Set sub path based on OS platform.
        if( WIN32 )
            set( PATH "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>${SUBPATH}" )
        else()
            set( PATH "${PROJECT_PATH_OUTPUT_EXECUTABLE}${SUBPATH}" )
        endif()
        
        # Get file name.
        get_filename_component( FILENAME ${LANGUAGE_FILE} NAME )
       
        # Create directory if not exists.
        # get_filename_component( DST_PATH ${PATH} ABSOLUTE )
        # if( NOT DST_PATH )
            # execute_process( COMMAND ${CMAKE_COMMAND} -E make_directory ${DST_PATH} )
            # message_verbose( STATUS "Create directory: ${DST_PATH}" )
        # endif()
        
        # Copy the file into destination.
        add_custom_command( TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${LANGUAGE_FILE} "${PATH}/${FILENAME}" )
        
        if( INSTALL )
            install( FILES ${LANGUAGE_FILE} DESTINATION "${PROJECT_PATH_INSTALL}${SUBPATH}" CONFIGURATIONS "release" )
        endif()
        
        #unset( DST_PATH CACHE )
        unset( FILENAME CACHE )
    endforeach()
endmacro()




# ************************************************************
# Copy (and install) translation files
macro( QT_COPY_TRANSLATION_FROM_TARGET TranslationFiles )
    # Help information.
    message_header( QT_COPY_TRANSLATION_FROM_TARGET )
    message_help( "Required options:" )
    message_help( "[TranslationFiles] -> The translation files." )
    message_help( "Optional:" )
    message_help( "[Install]    -> Flag to also install the files." )
    message_help( "[SubPath]    -> Sub path of output directory." )
        
    # Parse options.
    set( options INSTALL )
    set( oneValueArgs SubPath )
    cmake_parse_arguments( QT_COPY_TRANSLATION_FROM_TARGET "${options}" "${oneValueArgs}" "" ${ARGN} )
    
    
    foreach( LanguageFile ${TranslationFiles} )
        # Set sub path based on OS platform.
        if( WIN32 )
            set( Path "${PROJECT_PATH_OUTPUT_EXECUTABLE}/$<CONFIGURATION>${QT_COPY_TRANSLATION_FROM_TARGET_SubPath}" )
        else()
            set( Path "${PROJECT_PATH_OUTPUT_EXECUTABLE}${QT_COPY_TRANSLATION_FROM_TARGET_SubPath}" )
        endif()
        
        # Get file name.
        get_filename_component( FileName ${LanguageFile} NAME )
       
        # Copy the file into destination.
        add_custom_command(
            TARGET ALL_CopyData
            POST_BUILD COMMAND
            ${CMAKE_COMMAND} -E copy ${LanguageFile} "${Path}/${FileName}"
        )
        
        if( QT_COPY_TRANSLATION_FROM_TARGET_INSTALL )
            install( FILES ${LanguageFile} DESTINATION "${PROJECT_PATH_INSTALL}${QT_COPY_TRANSLATION_FROM_TARGET_SubPath}" )
        endif()
        
        unset( FileName CACHE )
    endforeach()
endmacro()

