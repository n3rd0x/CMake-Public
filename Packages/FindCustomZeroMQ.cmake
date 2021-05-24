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
# Website: http://zeromq.org/


# ************************************************************
# Start package
# ************************************************************
cm_message_header(ZEROMQ)
package_begin(ZEROMQ)
package_create_home_path(ZEROMQ ZEROMQ_ROOT)




# ************************************************************
# Create search path
# ************************************************************
set(ZEROMQ_PREFIX_PATH ${ZEROMQ_HOME})
package_create_search_path_include(ZEROMQ)
package_create_search_path_library(ZEROMQ)




# ************************************************************
# Clear
# ************************************************************
package_clear_if_changed(ZEROMQ_HOME
    ZEROMQ_FOUND
    ZEROMQ_PATH_INCLUDE
    ZEROMQ_LIBRARY_DEBUG
    ZEROMQ_LIBRARY_RELEASE
)




# ************************************************************
# Create search name
# ************************************************************
set(ZEROMQ_LIBRARY_NAMES "zmq")
package_create_debug_names(ZEROMQ_LIBRARY_NAMES)




# ************************************************************
# Find path and file
# ************************************************************
package_find_path(ZEROMQ_PATH_INCLUDE "zmq.h" "${ZEROMQ_SEARCH_PATH_INCLUDE}" "zmq")
package_find_library(ZEROMQ_LIBRARY_DEBUG "${ZEROMQ_LIBRARY_NAMES_DEBUG}" "${ZEROMQ_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library(ZEROMQ_LIBRARY_RELEASE "${ZEROMQ_LIBRARY_NAMES}" "${ZEROMQ_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
package_make_library(ZEROMQ_LIBRARY ZEROMQ_LIBRARY_DEBUG ZEROMQ_LIBRARY_RELEASE)



# ************************************************************
# Finalize package
# ************************************************************
package_validate(ZEROMQ)
package_add_parent_dir(ZEROMQ)
package_end(ZEROMQ)
cm_message_footer(ZEROMQ)

