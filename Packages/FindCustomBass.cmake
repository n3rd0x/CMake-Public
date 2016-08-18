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
# Website: http://www.un4seen.com

# ************************************************************
# Start package
message_header( BASS )
package_begin( BASS )
package_home_path( BASS BASS_ROOT )


# ************************************************************
# Create search path
set( BASS_PREFIX_PATH ${BASS_HOME} )
package_create_search_path_include( BASS )
package_create_search_path_library( BASS )
package_create_search_path_plugin( BASS )


# ************************************************************
# Create search name
set( BASS_LIBRARY_NAMES "bass" )
package_create_debug_names( BASS_LIBRARY_NAMES )


# ************************************************************
# Clear
package_clear_if_changed( BASS_PREFIX_PATH
    BASS_LIBRARY_RELEASE
    BASS_LIBRARY_DEBUG
    BASS_PATH_INCLUDE
)


# ************************************************************
# Find path and file
package_find_path( BASS_PATH_INCLUDE "bass.h" "${BASS_SEARCH_PATH_INCLUDE}" "" )
package_find_library( BASS_LIBRARY_DEBUG "${BASS_LIBRARY_NAMES_DEBUG}" "${BASS_SEARCH_PATH_LIBRARY}" "debug"  )
package_find_library( BASS_LIBRARY_RELEASE "${BASS_LIBRARY_NAMES}" "${BASS_SEARCH_PATH_LIBRARY}" "release relwithdebinfo minsizerel"  )
package_make_library( BASS_LIBRARY BASS_LIBRARY_DEBUG BASS_LIBRARY_RELEASE )


# ************************************************************
# Finalize package
package_validate( BASS )
package_add_parent_dir( BASS )
package_end( BASS )
message_footer( BASS )
