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
# Website: https://www.tcpdump.org/


# ************************************************************
# Start package
# ************************************************************
message_header(PCAP)
package_begin(PCAP)
package_create_home_path(PCAP PCAP_ROOT)




# ************************************************************
# Create search path
# ************************************************************
set(PCAP_PREFIX_PATH ${PCAP_HOME})
package_create_search_path_include(PCAP)
package_create_search_path_library(PCAP)




# ************************************************************
# Clear
# ************************************************************
package_clear_if_changed(PCAP_HOME
    PCAP_FOUND
    PCAP_PATH_INCLUDE
    PCAP_LIBRARY_DEBUG
    PCAP_LIBRARY_RELEASE
)




# ************************************************************
# Create search name
# ************************************************************
set(PCAP_LIBRARY_NAMES "pcap")
package_create_debug_names(PCAP_LIBRARY_NAMES)




# ************************************************************
# Find path and file
# ************************************************************
package_find_path(PCAP_PATH_INCLUDE "pcap.h" "${PCAP_SEARCH_PATH_INCLUDE}" "pcap")
package_find_library(PCAP_LIBRARY_DEBUG "${PCAP_LIBRARY_NAMES_DEBUG}" "${PCAP_SEARCH_PATH_LIBRARY}" "debug" )
package_find_library(PCAP_LIBRARY_RELEASE "${PCAP_LIBRARY_NAMES}" "${PCAP_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
package_make_library(PCAP_LIBRARY PCAP_LIBRARY_DEBUG PCAP_LIBRARY_RELEASE)



# ************************************************************
# Finalize package
# ************************************************************
package_validate(PCAP)
package_add_parent_dir(PCAP ADD_PARENT)
package_end(PCAP)
message_footer(PCAP)

