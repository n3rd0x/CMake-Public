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
message_header( GTK )
package_begin( GTK )
package_create_home_path( GTK GTK_ROOT )


# ************************************************************
# Options
option( GTK_VERSION_2.24.10 "GTK version 2.24.10." OFF )
option( GTK_VERSION_3.6.4 "GTK version 3.6.4." ON )
if( GTK_VERSION_3.6.4 )
    set( GTK_VERSION "3.6.4" )
elseif( GTK_VERSION_2.24.10 )
    set( GTK_VERSION "2.24.10" )
else()
    set( GTK_VERSION "" )
endif()


# Only search if specified.
if( NOT GTK_VERSION STREQUAL "")
    message_status( STATUS "Selected version: ${GTK_VERSION}" )
    set( GTK_ROOT "${GTK_HOME}/${GTK_VERSION}-prebuild-x86" )
    set( GTK_PATH_INCLUDE "${GTK_ROOT}/include" )
    set( GTK_PATH_LIBRARY "${GTK_ROOT}/lib" )
    set( GTK_PATH_BINARY "${GTK_ROOT}/bin" )
    
    # At the moment we use GTK+ for Cairo and LibRSVG.
    if( GTK_VERSION STREQUAL "3.6.4" )
        set( GTK_INCLUDE_DIR
            "${GTK_PATH_INCLUDE}/cairo"
            "${GTK_PATH_INCLUDE}/gdk-pixbuf-2.0"
            "${GTK_PATH_INCLUDE}/glib-2.0"
            "${GTK_PATH_INCLUDE}/librsvg-2.0/librsvg"
        )
        set( GTK_LIBRARIES
            "${GTK_PATH_LIBRARY}/cairo.lib"
            "${GTK_PATH_LIBRARY}/gdk_pixbuf-2.0.lib"
            "${GTK_PATH_LIBRARY}/glib-2.0.lib"
            "${GTK_PATH_LIBRARY}/gio-2.0.lib"
            "${GTK_PATH_LIBRARY}/gmodule-2.0.lib"
            "${GTK_PATH_LIBRARY}/gobject-2.0.lib"
            "${GTK_PATH_LIBRARY}/gthread-2.0.lib"
            "${GTK_PATH_LIBRARY}/librsvg-2-2.lib"
            "${GTK_PATH_LIBRARY}/pango-1.0.lib"
            "${GTK_PATH_LIBRARY}/pangocairo-1.0.lib"
            "${GTK_PATH_LIBRARY}/pangowin32-1.0.lib"
        )
        set( GTK_DEPENDENCIES
            "libcairo-2.dll"
            "libiconv-2.dll"
            "libcroco-0.6-3.dll"
            "libffi-6.dll"
            "libfontconfig-1.dll"
            "libfreetype-6.dll"
            "libgdk_pixbuf-2.0-0.dll"
            "libgio-2.0-0.dll"
            "libglib-2.0-0.dll"
            "libgthread-2.0-0.dll"
            "libintl-8.dll"
            "liblzma-5.dll"
            "libgmodule-2.0-0.dll"
            "libgobject-2.0-0.dll"
            "libpixman-1-0.dll"
            "libpng15-15.dll"
            "libpango-1.0-0.dll"
            "libpangocairo-1.0-0.dll"
            "libpangoft2-1.0-0.dll"
            "libpangowin32-1.0-0.dll"
            "librsvg-2-2.dll"
            "libxml2-2.dll"
            "pthreadGC2.dll"
            "zlib1.dll"
        )
        set( GTK_FOUND TRUE )
    elseif( GTK_VERSION STREQUAL "2.24.10" )
        set( GTK_INCLUDE_DIR
            "${GTK_PATH_INCLUDE}/cairo"
        )
        set( GTK_LIBRARIES
            "${GTK_PATH_LIBRARY}/cairo.lib"
        )
        set( GTK_DEPENDENCIES
            "freetype6.dll"
            "libexpat-1.dll"
            "libfontconfig-1.dll"
            "libpixman-1-0.dll"
            "libpng14-14.dll"
            "zlib1.dll"
        )
        set( GTK_FOUND TRUE )
    else()
        set( GTK_FOUND FALSE )
    endif()
    
    foreach( VAR ${GTK_DEPENDENCIES} )
        package_find_file( GTK_${VAR}_BINARY_DEBUG "${VAR}" "${GTK_PATH_BINARY}" "debug" )
        if( GTK_${VAR}_BINARY_DEBUG )
            set( GTK_BINARY_DEBUG ${GTK_BINARY_DEBUG} ${GTK_${VAR}_BINARY_DEBUG} )
        endif()
        
        package_find_file( GTK_${VAR}_BINARY_RELEASE "${VAR}" "${GTK_PATH_BINARY}" "release;relwithdebinfo;minsizerel" )
        if( GTK_${VAR}_BINARY_RELEASE )
            set( GTK_BINARY_RELEASE ${GTK_BINARY_RELEASE} ${GTK_${VAR}_BINARY_RELEASE} )
        endif()
        unset( GTK_${VAR}_BINARY_DEBUG CACHE )
        unset( GTK_${VAR}_BINARY_RELEASE CACHE )
    endforeach()
endif()



# ************************************************************
# Finalize package
package_end( GTK )
message_footer( GTK )
