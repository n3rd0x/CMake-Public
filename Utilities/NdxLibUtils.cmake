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
# Configure dependency
macro( NDXLIB_CONFIGURE_DEPENDENCY )
    # Log4cplus
	if( NOT DISABLE_LOG4CPLUS )
		find_package( CustomLog4cplus )
    endif()
	
    # Set include directories of the dependencies.
    set( NDXLIB_DEPENDENCY_INCLUDE_DIR
        "${LOG4CPLUS_INCLUDE_DIR}"
    )
    
    # Set dependency libraries.
    set( NDXLIB_DEPENDENCY_LIBRARIES
        "${LOG4CPLUS_LIBRARIES}"
    )
endmacro()


# ************************************************************
# Configure dependency runtime
macro( NDXLIB_CONFIGURE_DEPENDENCY_RUNTIME )
    package_copy_binary( NDXLIB )
    package_copy_binary( LOG4CPLUS )
endmacro()


# ************************************************************
# Configure library
macro( NDXLIB_CONFIGURE_LIBRARY )
	find_package( CustomNdxLib )
	
	# Find which dependency needs to be located.
	if( DEFINED NDXLIB_HOME )
		file( READ "${NDXLIB_PATH_INCLUDE}/ndxBuildLibraries.h" NDXLIB_TMP_LIBRARY_CONTENT)
		get_preprocessor_entry( NDXLIB_TMP_LIBRARY_CONTENT LIBRARY_BUILD_NDXLIB NDXLIB_LIBRARY_STATIC )
		get_preprocessor_entry( NDXLIB_TMP_LIBRARY_CONTENT LIBRARY_BUILD_LOG4CPLUS_STATIC DISABLE_LOG4CPLUS )

		# Enable all dependencies if ndxLib is statically build.
		if( NDXLIB_LIBRARY_STATIC )
            message_verbose( STATUS "ndxLib is statically build." )
			ndxlib_enable_all_dependency()
		endif()
		
		# Locate necessary dependencies.
		ndxlib_configure_dependency()
    endif()
endmacro()


# ************************************************************
# Enable all dependencies
macro( NDXLIB_ENABLE_ALL_DEPENDENCY )
	set( DISABLE_LOG4CPLUS OFF )
endmacro()

