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
#
# This file configure the build system for CMake.
# ************************************************************

# Don't need to define parameters in every state control.
set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)

# Path to the CMake repository.
set(PROJECT_PATH_CMAKE_PUBLIC      "${CMAKE_CURRENT_SOURCE_DIR}/Sub-Repo/CMake-Public")
set(PROJECT_PATH_CMAKE_TEMPLATE    "${PROJECT_PATH_CMAKE_PUBLIC}/Templates")

# Include necessary sub-modules.
set(CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/Source/CMake"
    "${PROJECT_PATH_CMAKE_PUBLIC}"
    "${PROJECT_PATH_CMAKE_PUBLIC}/Packages"
    "${PROJECT_PATH_CMAKE_PUBLIC}/Third-Parties/Ogre"
    "${PROJECT_PATH_CMAKE_PUBLIC}/Utilities"
)

# Include necessary modules.
include(CheckCXXCompilerFlag)
include(CMakeParseArguments)
include(DebugUtils)
include(BuildUtils)
include(PackageUtils)
include(OgreUtils)
include(PreprocessorUtils)
include(QtUtils)
