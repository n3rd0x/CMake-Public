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
# Website: http://seladb.github.io/PcapPlusPlus-Doc/index.html


# ************************************************************
# Start package
# ************************************************************
cm_message_header(PCAPPLUSPLUS)
cm_package_begin(PCAPPLUSPLUS)
cm_package_create_home_path(PCAPPLUSPLUS PCAPPLUSPLUS_ROOT)




# ************************************************************
# Create Search Path
# ************************************************************
set(PCAPPLUSPLUS_PREFIX_PATH ${PCAPPLUSPLUS_HOME})
cm_package_create_search_path_include(PCAPPLUSPLUS)
cm_package_create_search_path_library(PCAPPLUSPLUS)




# ************************************************************
# Clear
# ************************************************************
cm_package_clear_if_changed(PCAPPLUSPLUS_HOME
    PCAPPLUSPLUS_FOUND
    PCAPPLUSPLUS_PATH_INCLUDE
    PCAPPLUSPLUS_LIBRARY_DEBUG
    PCAPPLUSPLUS_LIBRARY_RELEASE
    PCAPPLUSPLUS_COMMON_LIBRARY_DEBUG
    PCAPPLUSPLUS_COMMON_LIBRARY_RELEASE
    PCAPPLUSPLUS_PACKET_LIBRARY_DEBUG
    PCAPPLUSPLUS_PACKET_LIBRARY_RELEASE
    PCAPPLUSPLUS_PCAP_LIBRARY_DEBUG
    PCAPPLUSPLUS_PCAP_LIBRARY_RELEASE
)




# ************************************************************
# Create Search Name
# ************************************************************
set(PCAPPLUSPLUS_COMMON_LIBRARY_NAMES "Common++")
set(PCAPPLUSPLUS_PACKET_LIBRARY_NAMES "Packet++")
set(PCAPPLUSPLUS_PCAP_LIBRARY_NAMES "Pcap++")
cm_package_create_debug_names(PCAPPLUSPLUS_COMMON_LIBRARY_NAMES)
cm_package_create_debug_names(PCAPPLUSPLUS_PACKET_LIBRARY_NAMES)
cm_package_create_debug_names(PCAPPLUSPLUS_PCAP_LIBRARY_NAMES)




# ************************************************************
# Find path and file
# ************************************************************
cm_package_find_path(PCAPPLUSPLUS_PATH_INCLUDE "Packet.h" "${PCAPPLUSPLUS_SEARCH_PATH_INCLUDE}" "pcapplusplus")
cm_package_find_library(PCAPPLUSPLUS_COMMON_LIBRARY_DEBUG "${PCAPPLUSPLUS_COMMON_LIBRARY_NAMES_DEBUG}" "${PCAPPLUSPLUS_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library(PCAPPLUSPLUS_COMMON_LIBRARY_RELEASE "${PCAPPLUSPLUS_COMMON_LIBRARY_NAMES}" "${PCAPPLUSPLUS_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
cm_package_find_library(PCAPPLUSPLUS_PACKET_LIBRARY_DEBUG "${PCAPPLUSPLUS_PACKET_LIBRARY_NAMES_DEBUG}" "${PCAPPLUSPLUS_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library(PCAPPLUSPLUS_PACKET_LIBRARY_RELEASE "${PCAPPLUSPLUS_PACKET_LIBRARY_NAMES}" "${PCAPPLUSPLUS_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
cm_package_find_library(PCAPPLUSPLUS_PCAP_LIBRARY_DEBUG "${PCAPPLUSPLUS_PCAP_LIBRARY_NAMES_DEBUG}" "${PCAPPLUSPLUS_SEARCH_PATH_LIBRARY}" "debug" )
cm_package_find_library(PCAPPLUSPLUS_PCAP_LIBRARY_RELEASE "${PCAPPLUSPLUS_PCAP_LIBRARY_NAMES}" "${PCAPPLUSPLUS_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")

set(PCAPPLUSPLUS_LIBRARY_DEBUG
    "${PCAPPLUSPLUS_COMMON_LIBRARY_DEBUG}"
    "${PCAPPLUSPLUS_PACKET_LIBRARY_DEBUG}"
    "${PCAPPLUSPLUS_PCAP_LIBRARY_DEBUG}"
)
set(PCAPPLUSPLUS_LIBRARY_RELEASE
    "${PCAPPLUSPLUS_COMMON_LIBRARY_RELEASE}"
    "${PCAPPLUSPLUS_PACKET_LIBRARY_RELEASE}"
    "${PCAPPLUSPLUS_PCAP_LIBRARY_RELEASE}"
)
cm_package_make_library(PCAPPLUSPLUS_LIBRARY PCAPPLUSPLUS_LIBRARY_DEBUG PCAPPLUSPLUS_LIBRARY_RELEASE)



# ************************************************************
# Finalize Package
# ************************************************************
cm_package_validate(PCAPPLUSPLUS)
cm_package_include_options(PCAPPLUSPLUS)
cm_package_end(PCAPPLUSPLUS)
cm_message_footer(PCAPPLUSPLUS)

