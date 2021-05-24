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
# Website: http://www.cgal.org


# ************************************************************
# Start package
cm_message_header( CGAL )
package_begin( CGAL )
package_create_home_path( CGAL CGAL_ROOT )
set( CGAL_DEPENDENCY_DIR CACHE PATH "Path to the CGAL dependencies directory." )


# ************************************************************
# Create search path
set( CGAL_PREFIX_PATH ${CGAL_HOME} )
package_create_search_path_include( CGAL )
package_create_search_path_library( CGAL )


# ************************************************************
# Clear
if( WIN32 )
    package_clear_if_changed( CGAL_PREFIX_PATH
        CGAL_BINARY_DEBUG
        CGAL_BINARY_RELEASE
        CGAL_BINARY_CORE_DEBUG
        CGAL_BINARY_CORE_RELEASE
        CGAL_DEPENDENCY_BLAS_INCLUDE
        CGAL_DEPENDENCY_BLAS_LIBRARY
        CGAL_DEPENDENCY_GMP_BINARY
        CGAL_DEPENDENCY_GMP_INCLUDE
        CGAL_DEPENDENCY_GMP_LIBRARY
        CGAL_DEPENDENCY_LAPACK_LIBRARY
        CGAL_DEPENDENCY_MPFR_BINARY
        CGAL_DEPENDENCY_MPFR_INCLUDE
        CGAL_DEPENDENCY_MPFR_LIBRARY
        CGAL_DEPENDENCY_TAUCS_INCLUDE
        CGAL_DEPENDENCY_TAUCS_LIBRARY
        CGAL_LIBRARY_DEBUG
        CGAL_LIBRARY_RELEASE
        CGAL_PATH_INCLUDE
    )
else()
    package_clear_if_changed( CGAL_PREFIX_PATH
        CGAL_DEPENDENCY_BLAS_INCLUDE
        CGAL_DEPENDENCY_BLAS_LIBRARY
        CGAL_DEPENDENCY_GMP_INCLUDE
        CGAL_DEPENDENCY_GMP_LIBRARY
        CGAL_DEPENDENCY_LAPACK_LIBRARY
        CGAL_DEPENDENCY_MPFR_INCLUDE
        CGAL_DEPENDENCY_MPFR_LIBRARY
        CGAL_DEPENDENCY_TAUCS_INCLUDE
        CGAL_DEPENDENCY_TAUCS_LIBRARY
        CGAL_LIBRARY_DEBUG
        CGAL_LIBRARY_RELEASE
        CGAL_PATH_INCLUDE
    )
endif()


# TST 2014-01-27
# Maybe we could later build an automatic search for the library.
# Locate the "CGALConfig.cmake" for retrieving version and prefix names.
package_find_file( CGAL_CONFIG "CGALConfig.cmake" "${CGAL_PREFIX_PATH}" "" )
if( CGAL_CONFIG )
    # Include to retrieve variables defined in the file.
    include( ${CGAL_CONFIG} )

    # ************************************************************
    # Define library name
    set( CGAL_LIBRARY_NAMES_DEBUG   "CGAL-${CGAL_DEBUG_PREFIX_NAME}" )
    set( CGAL_LIBRARY_NAMES_RELEASE "CGAL-${CGAL_RELEASE_PREFIX_NAME}" )
    set( CGAL_LIBRARY_CORE_NAMES_DEBUG   "CGAL_Core-${CGAL_DEBUG_PREFIX_NAME}" )
    set( CGAL_LIBRARY_CORE_NAMES_RELEASE "CGAL_Core-${CGAL_RELEASE_PREFIX_NAME}" )


    # ************************************************************
    # Find path and header file
    package_find_path( CGAL_PATH_INCLUDE "version.h" "${CGAL_SEARCH_PATH_INCLUDE}" "CGAL;cgal" )

    # Core
    package_find_library( CGAL_LIBRARY_DEBUG    "${CGAL_LIBRARY_NAMES_DEBUG}"   "${CGAL_SEARCH_PATH_LIBRARY}" "debug"  )
    package_find_library( CGAL_LIBRARY_RELEASE  "${CGAL_LIBRARY_NAMES_RELEASE}" "${CGAL_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )

    # Main
    package_find_library( CGAL_LIBRARY_CORE_DEBUG   "${CGAL_LIBRARY_CORE_NAMES_DEBUG}"      "${CGAL_SEARCH_PATH_LIBRARY}" "debug"  )
    package_find_library( CGAL_LIBRARY_CORE_RELEASE "${CGAL_LIBRARY_CORE_NAMES_RELEASE}"    "${CGAL_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel"  )


    # ************************************************************
    # Make library set
    package_make_library( CGAL_LIBRARY CGAL_LIBRARY_DEBUG CGAL_LIBRARY_RELEASE )
    package_make_library( CGAL_LIBRARY_CORE CGAL_LIBRARY_CORE_DEBUG CGAL_LIBRARY_CORE_RELEASE )

    unset( CGAL_LIBRARY_CORE_DEBUG CACHE )
    unset( CGAL_LIBRARY_CORE_RELEASE CACHE )


    # ************************************************************
    # Dependencies
    # GMP
    set( CGAL_DEPENDENCY_GMP_NAME "libgmp-10" )
    package_find_path( CGAL_DEPENDENCY_GMP_INCLUDE "gmp.h" "${CGAL_DEPENDENCY_DIR}" "include" )
    package_find_library( CGAL_DEPENDENCY_GMP_LIBRARY "${CGAL_DEPENDENCY_GMP_NAME}" "${CGAL_DEPENDENCY_DIR}" "bin;lib" )
    package_create_binary_names( CGAL_DEPENDENCY_GMP_NAME )
    package_find_file( CGAL_DEPENDENCY_GMP_BINARY "${CGAL_DEPENDENCY_GMP_NAME}" "${CGAL_DEPENDENCY_DIR}" "bin;lib" )

    # MPFR
    set( CGAL_DEPENDENCY_MPFR_NAME "libmpfr-4" )
    package_find_path( CGAL_DEPENDENCY_MPFR_INCLUDE "mpfr.h" "${CGAL_DEPENDENCY_DIR}" "include" )
    package_find_library( CGAL_DEPENDENCY_MPFR_LIBRARY "${CGAL_DEPENDENCY_MPFR_NAME}" "${CGAL_DEPENDENCY_DIR}" "bin;lib" )
    package_create_binary_names( CGAL_DEPENDENCY_MPFR_NAME )
    package_find_file( CGAL_DEPENDENCY_MPFR_BINARY "${CGAL_DEPENDENCY_MPFR_NAME}" "${CGAL_DEPENDENCY_DIR}" "bin;lib" )



    # ************************************************************
    # Find binaries
    if( WIN32 )
        package_create_binary_names( CGAL_LIBRARY_NAMES_DEBUG )
        package_create_binary_names( CGAL_LIBRARY_NAMES_RELEASE )
        package_create_binary_names( CGAL_LIBRARY_CORE_NAMES_DEBUG )
        package_create_binary_names( CGAL_LIBRARY_CORE_NAMES_RELEASE )

        package_create_search_path_binary( CGAL )
        set( CGAL_SEARCH_BINARIES
            ${CGAL_SEARCH_PATH_BINARY}
            ${CGAL_SEARCH_PATH_LIBRARY}
        )

        package_find_file( CGAL_BINARY_DEBUG "${CGAL_LIBRARY_NAMES_DEBUG}" "${CGAL_SEARCH_BINARIES}" "debug" )
        package_find_file( CGAL_BINARY_RELEASE "${CGAL_LIBRARY_NAMES_RELEASE}" "${CGAL_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )

        package_find_file( CGAL_BINARY_CORE_DEBUG "${CGAL_LIBRARY_CORE_NAMES_DEBUG}" "${CGAL_SEARCH_BINARIES}" "debug" )
        package_find_file( CGAL_BINARY_CORE_RELEASE "${CGAL_LIBRARY_CORE_NAMES_RELEASE}" "${CGAL_SEARCH_BINARIES}" "release;relwithdebinfo;minsizerel" )

        set( CGAL_BINARY_DEBUG
            ${CGAL_BINARY_DEBUG}
            ${CGAL_BINARY_CORE_DEBUG}
            ${CGAL_DEPENDENCY_GMP_BINARY}
            ${CGAL_DEPENDENCY_MPFR_BINARY}
        )

        set( CGAL_BINARY_RELEASE
            ${CGAL_BINARY_RELEASE}
            ${CGAL_BINARY_CORE_RELEASE}
            ${CGAL_DEPENDENCY_GMP_BINARY}
            ${CGAL_DEPENDENCY_MPFR_BINARY}
        )

        unset( CGAL_BINARY_CORE_DEBUG CACHE )
        unset( CGAL_BINARY_CORE_RELEASE CACHE )
    endif()


    # ************************************************************
    # Validation
    if( NOT CGAL_FOUND )
        if( CGAL_PATH_INCLUDE   AND
            CGAL_LIBRARY        AND
            CGAL_LIBRARY_CORE   AND
            CGAL_DEPENDENCY_GMP_INCLUDE     AND
            CGAL_DEPENDENCY_GMP_LIBRARY     AND
            CGAL_DEPENDENCY_MPFR_INCLUDE    AND
            CGAL_DEPENDENCY_MPFR_LIBRARY
        )
            set( CGAL_FOUND TRUE )
            set( CGAL_LIBRARIES
                ${CGAL_LIBRARY}
                ${CGAL_LIBRARY_CORE}
                ${CGAL_DEPENDENCY_GMP_LIBRARY}
                ${CGAL_DEPENDENCY_MPFR_LIBRARY}
            )
            set( CGAL_INCLUDE_DIR
                #${CGAL_PATH_INCLUDE}
                ${CGAL_DEPENDENCY_GMP_INCLUDE}
                ${CGAL_DEPENDENCY_MPFR_INCLUDE}
            )
        endif()
    endif()


    # ************************************************************
    # Optional Dependencies
    # BLAS
    if( CGAL_DEPENDENCY_BLAS )
        package_find_path( CGAL_DEPENDENCY_BLAS_INCLUDE "blaswrap.h" "${CGAL_DEPENDENCY_DIR}" "include" )
        package_find_library( CGAL_DEPENDENCY_BLAS_LIBRARY "libcblas" "${CGAL_DEPENDENCY_DIR}" "bin;lib" )

        if( CGAL_FOUND AND CGAL_DEPENDENCY_BLAS_INCLUDE AND CGAL_DEPENDENCY_BLAS_LIBRARY)
            set( CGAL_LIBRARIES ${CGAL_LIBRARIES} ${CGAL_DEPENDENCY_BLAS_LIBRARY} )
            set( CGAL_INCLUDE_DIR ${CGAL_INCLUDE_DIR} ${CGAL_DEPENDENCY_BLAS_INCLUDE} )
        endif()
    endif()

    # LAPACK
    if( CGAL_DEPENDENCY_LAPACK )
        package_find_library( CGAL_DEPENDENCY_LAPACK_LIBRARY "liblapack" "${CGAL_DEPENDENCY_DIR}" "bin;lib" )

        if( CGAL_FOUND AND  CGAL_DEPENDENCY_LAPACK_LIBRARY)
            set( CGAL_LIBRARIES ${CGAL_LIBRARIES} ${CGAL_DEPENDENCY_LAPACK_LIBRARY} )
        endif()
    endif()

    # TAUCS
    if( CGAL_DEPENDENCY_TAUCS )
        package_find_path( CGAL_DEPENDENCY_TAUCS_INCLUDE "taucs.h" "${CGAL_DEPENDENCY_DIR}" "include" )
        package_find_library( CGAL_DEPENDENCY_TAUCS_LIBRARY "libtaucs" "${CGAL_DEPENDENCY_DIR}" "bin;lib" )

        if( CGAL_FOUND AND CGAL_DEPENDENCY_TAUCS_INCLUDE AND CGAL_DEPENDENCY_TAUCS_LIBRARY)
            set( CGAL_LIBRARIES ${CGAL_LIBRARIES} ${CGAL_DEPENDENCY_TAUCS_LIBRARY} )
            set( CGAL_INCLUDE_DIR ${CGAL_INCLUDE_DIR} ${CGAL_DEPENDENCY_TAUCS_INCLUDE} )
        endif()
    endif()


    package_add_parent_dir( CGAL )
endif()


# ************************************************************
# Finalize package
package_end( CGAL )
unset( CGAL_CONFIG CACHE )
cm_message_footer( CGAL )