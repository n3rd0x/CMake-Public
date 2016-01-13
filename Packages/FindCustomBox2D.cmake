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
# Website: http://box2d.org


# ************************************************************
# Start package
message_header(BOX2D)
package_begin(BOX2D)
package_create_home_path(BOX2D BOX2D_ROOT)


# ************************************************************
# Create search path
set(BOX2D_PREFIX_PATH ${BOX2D_HOME})
package_create_search_path_include(BOX2D)
package_create_search_path_library(BOX2D)



# ************************************************************
# Create search name
set(BOX2D_LIBRARY_NAMES "Box2D" )
package_create_debug_names(BOX2D_LIBRARY_NAMES)


# ************************************************************
# Clear
package_clear_if_changed(BOX2D_PREFIX_PATH
    BOX2D_LIBRARY_DEBUG
    BOX2D_LIBRARY_RELEASE
    BOX2D_PATH_INCLUDE
)


# ************************************************************
# Find paths
package_find_path(BOX2D_PATH_INCLUDE "Box2D.h" "${BOX2D_SEARCH_PATH_INCLUDE}" "Box2D")
package_find_library(BOX2D_LIBRARY_DEBUG "${BOX2D_LIBRARY_NAMES_DEBUG}" "${BOX2D_SEARCH_PATH_LIBRARY}" "debug")
package_find_library(BOX2D_LIBRARY_RELEASE "${BOX2D_LIBRARY_NAMES}" "${BOX2D_SEARCH_PATH_LIBRARY}" "release;relwithdebinfo;minsizerel")
package_make_library(BOX2D_LIBRARY BOX2D_LIBRARY_DEBUG BOX2D_LIBRARY_RELEASE )


# ************************************************************
# Finalize package
package_validate(BOX2D)
package_add_parent_dir(BOX2D)
package_end(BOX2D)
message_footer(BOX2D)
