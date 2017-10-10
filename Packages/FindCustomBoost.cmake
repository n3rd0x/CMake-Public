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
# Website: http://www.boost.org


# ************************************************************
# Start package
message_header(Boost)
package_begin(Boost)

# Find the Boost path.
package_get_environment_path(Boost BOOST_ROOT)
if(Boost_ENV_BOOST_ROOT)
    set(BOOST_ROOT "${Boost_ENV_BOOST_ROOT}" CACHE PATH "Path to Boost directory.")
else()
	set(BOOST_ROOT "" CACHE PATH "Path to Boost directory.")
endif()

# Flag to either use static or dynamic linking.
option(Boost_USE_STATIC_LIBS OFF "Flag to static linking with Boost.")

# Set Boost components.
set(Boost_COMPONENTS "${CustomBoost_FIND_COMPONENTS}" CACHE STRING "Boost components.")

message_debug(STATUS "Selected components:")
foreach(comp ${Boost_COMPONENTS})
    message_debug(STATUS " * ${comp}")
endforeach()


# Reset if necessary.
package_clear_if_changed(BOOST_ROOT
    Boost_INCLUDE_DIR
)
package_clear_if_changed(Boost_USE_STATIC_LIBS
    Boost_INCLUDE_DIR
)
package_clear_if_changed(Boost_COMPONENTS
    Boost_INCLUDE_DIR
)

# Locate official Boost package.
find_package(Boost COMPONENTS ${Boost_COMPONENTS})

# Include the library path in order to locate the files.
link_directories(${Boost_LIBRARY_DIRS})


# ************************************************************
# TODO: 2013-08-26 TST
# This hasn't been testet!
# Find binaries on Windows
if( WIN32 )
	# For each founded component, copy binary is neccessary
	if( NOT Boost_USE_STATIC_LIBS )
		# Create search paths
		set( Boost_PREFIX_PATH ${BOOST_ROOT} )
		package_create_search_path_binary( Boost )
		package_create_search_path_library( Boost )
		set( Boost_SEARCH_PATH_BINARIES
			${Boost_SEARCH_PATH_BINARY}
			${Boost_SEARCH_PATH_LIBRARY}
		)
		
		if( NOT "${Boost_PREFIX_PATH}" STREQUAL "${Boost_PREFIX_PATH_INT_CHECK}" )
			set( ${Boost_CHANGED} TRUE )
		else()
			set( ${Boost_CHANGED} FALSE )
		endif()
		
		# Find component
		foreach( component ${Boost_COMPONENTS} )
			message_debug( "" "Search for ${component} component...." )
			string( TOUPPER ${component} COMPONENT )
			if( Boost_${COMPONENT}_FOUND )
				message_debug( "" "${component} is located" )
				
				if( ${Boost_CHANGED} )
					set( Boost_${COMPONENT}_BINARY_DEBUG "${Boost_${COMPONENT}_BINARY_DEBUG}-NOTFOUND" CACHE STRING "" FORCE )
					set( Boost_${COMPONENT}_BINARY_RELEASE "${Boost_${COMPONENT}_BINARY_RELEASE}-NOTFOUND" CACHE STRING "" FORCE )
				endif()
		
				if( Boost_${COMPONENT}_LIBRARY_DEBUG )
					get_filename_component( debug_file ${Boost_${COMPONENT}_LIBRARY_DEBUG} NAME_WE )
					set( filename "${debug_file}.dll" )
					package_find_file( Boost_${COMPONENT}_BINARY_DEBUG "${filename}" "${Boost_SEARCH_PATH_BINARIES}" "debug" )
				endif()
				
				if( Boost_${COMPONENT}_LIBRARY_RELEASE )
					get_filename_component( release_file ${Boost_${COMPONENT}_LIBRARY_RELEASE} NAME_WE )
					set( filename "${release_file}.dll" )
					package_find_file( Boost_${COMPONENT}_BINARY_RELEASE "${filename}" "${Boost_SEARCH_PATH_BINARIES}" "release;relwithdebinfo;minsizerel" )
				endif()
				
				if( Boost_${COMPONENT}_BINARY_DEBUG )
					list( APPEND Boost_BINARY_DEBUG "${Boost_${COMPONENT}_BINARY_DEBUG}" )
					message_debug( "" "Adding ${Boost_${COMPONENT}_BINARY_DEBUG}" )
				endif()
				
				if( Boost_${COMPONENT}_BINARY_RELEASE )
					list( APPEND Boost_BINARY_RELEASE "${Boost_${COMPONENT}_BINARY_RELEASE}" )
					message_debug( "" "Adding ${Boost_${COMPONENT}_BINARY_RELEASE}" )
				endif()
				
			endif()
		endforeach()
	endif()
endif()


# ************************************************************
# Finalize package
package_validate(Boost)
package_end(Boost)
message_footer(Boost)
