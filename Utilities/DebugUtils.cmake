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
# MESSAGE
# ************************************************************
# ====================
# Formatted output (Rows)
# ====================
macro(MESSAGE_OUTPUT_ROWS State Msg)
    foreach(m ${Msg})
        message(${State} "  - ${m}")
    endforeach()
endmacro()


# ====================
# Formatted output (Cols)
# ====================
macro(MESSAGE_OUTPUT_COLS State Msg)
    set(_var "")
    foreach(m ${Msg})
        set(_var "${_var} ${m}")
    endforeach()
    message(${State} "${_var}")
    unset(_var)
endmacro()


# ====================
# Dash horizontal line
# ====================
macro(MESSAGE_DASH_LINE)
    message(STATUS "----------------------------------------")
endmacro()


# ====================
# Footer message (Common)
# ====================
macro(MESSAGE_FOOTER_COMMON Footer)
    message("************************************************************")
    message("**** End:   ${Footer}")
    message("************************************************************")
endmacro()


# ====================
# Footer message (All)
# ====================
macro(MESSAGE_FOOTER Footer)
    if(Project_CMAKE_ENABLE_DEBUG_MESSAGE OR PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message_footer_common(${Footer})
    endif()
endmacro()


# ====================
# Footer message (Debug)
# ====================
macro(MESSAGE_FOOTER_DEBUG Footer)
    if(Project_CMAKE_ENABLE_DEBUG_MESSAGE)
        message_footer_common(${Footer})
    endif()
endmacro()




# ************************************************************
# Footer message (Help)
# ************************************************************
macro(MESSAGE_FOOTER_HELP Footer)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message_footer_common(${Footer})
    endif()
endmacro()




# ************************************************************
# Header message (Common)
# ************************************************************
macro(CM_MESSAGE_HEADER_COMMON Header)
    message("************************************************************")
    message("**** Start: ${Header}")
    message("************************************************************")
endmacro()




# ************************************************************
# Header message (All)
# ************************************************************
macro(CM_MESSAGE_HEADER Header)
    if(Project_CMAKE_ENABLE_DEBUG_MESSAGE OR PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        cm_message_header_common(${Header})
    endif()
endmacro()




# ************************************************************
# Header message (Debug)
# ************************************************************
macro(CM_MESSAGE_HEADER_DEBUG Header)
    if(Project_CMAKE_ENABLE_DEBUG_MESSAGE)
        cm_message_header_common(${Header})
    endif()
endmacro()




# ************************************************************
# Header message (Help)
# ************************************************************
macro(CM_MESSAGE_HEADER_HELP Header)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        cm_message_header_common(${Header})
    endif()
endmacro()




# ************************************************************
# Footer sub message
# ************************************************************
macro(MESSAGE_SUB_FOOTER Footer)
    if(Project_CMAKE_ENABLE_DEBUG_MESSAGE OR PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "------------------------------------------------------------")
        message(STATUS "- End:   ${Footer}")
        message(STATUS "------------------------------------------------------------")
    endif()
endmacro()




# ************************************************************
# Header sub message
# ************************************************************
macro(MESSAGE_SUB_HEADER Header)
    if(Project_CMAKE_ENABLE_DEBUG_MESSAGE OR PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "------------------------------------------------------------")
        message(STATUS "- Start: ${Header}")
        message(STATUS "------------------------------------------------------------")
    endif()
endmacro()




# ************************************************************
# New line
# ************************************************************
macro(MESSAGE_NEW_LINE)
    message(STATUS "")
endmacro()




# ************************************************************
# Star horizontal line
# ************************************************************
macro(MESSAGE_STAR_LINE)
    message(STATUS "****************************************")
endmacro()




# ************************************************************
# DEBUG MESSAGE
# ************************************************************
# ----------------------------------------
# Debug message
# ----------------------------------------
macro(CM_MESSAGE_DEBUG State Msg)
    if(Project_CMAKE_ENABLE_DEBUG_MESSAGE)
        message("${State}" "[Debug]   ${Msg}")
    endif()
endmacro()


# ----------------------------------------
# Debug line
# ----------------------------------------
macro(CM_MESSAGE_DEBUG_LINE State)
    cm_message_debug("${State}" "----------------------------------------")
endmacro()


# ----------------------------------------
# Debug footer
# ----------------------------------------
function(CM_MESSAGE_DEBUG_FOOTER State Footer)
    cm_message_debug_line(${State})
    cm_message_debug(${State} "End:   ${Footer}")
    cm_message_debug_line(${State})
endfunction()


# ----------------------------------------
# Debug header
# ----------------------------------------
function(CM_MESSAGE_DEBUG_HEADER State Header)
    cm_message_debug_line(${State})
    cm_message_debug(${State} "Start: ${Header}")
    cm_message_debug_line(${State})
endfunction()


# ----------------------------------------
# Formatted output (debug mode)
# ----------------------------------------
macro(CM_MESSAGE_DEBUG_OUTPUT State Values)
    foreach(v ${Values})
        cm_message_debug("${State}" "  - ${v}")
    endforeach()
endmacro()




# ************************************************************
# HELP MESSAGE
# ************************************************************
# ====================
# Help message
# ====================
macro(MESSAGE_HELP Msg)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "[Help]    ${Msg}")
    endif()
endmacro()


# ====================
# Dash horizontal line (verbose mode)
# ====================
macro(MESSAGE_HELP_DASH_LINE)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "[Help]    ----------------------------------------")
    endif()
endmacro()


# ====================
# Star horizontal line (help mode)
# ====================
macro(MESSAGE_HELP_STAR_LINE)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "[Help]    ****************************************")
    endif()
endmacro()




# ************************************************************
# STATUS MESSAGE
# ************************************************************
# ----------------------------------------
# Status message
# ----------------------------------------
macro(CM_MESSAGE_STATUS State Msg)
    message("${State}" "[Status]  ${Msg}")
endmacro()


# ----------------------------------------
# Formatted output (status mode)
# ----------------------------------------
macro(CM_MESSAGE_STATUS_OUTPUT State Msg)
    foreach(m ${Msg})
        cm_message_status("${State}" "  - ${m}")
    endforeach()
endmacro()




# ************************************************************
# VERBOSE MESSAGE
# ************************************************************
# ----------------------------------------
# Verbose message
# ----------------------------------------
macro(CM_MESSAGE_VERBOSE State Msg)
    if(Project_CMAKE_ENABLE_VERBOSE_MESSAGE OR Project_CMAKE_ENABLE_DEBUG_MESSAGE)
        message("${State}" "[Verbose] ${Msg}")
    endif()
endmacro()


# ----------------------------------------
# Dash line
# ----------------------------------------
macro(CM_MESSAGE_VERBOSE_DASH_LINE State)
    cm_message_verbose("${State}" "----------------------------------------")
endmacro()


# ----------------------------------------
# Formatted output (verbose mode)
# ----------------------------------------
macro(CM_MESSAGE_VERBOSE_OUTPUT State Msg)
    foreach(m ${Msg})
        cm_message_verbose("${State}" "  - ${m}")
    endforeach()
endmacro()





# ====================
# New line (verbose mode)
# ====================
macro(CM_MESSAGE_VERBOSE_NEW_LINE)
    if(PROJECT_CMAKE_ENABLE_VERBOSE_MESSAGE)
        message(STATUS "[Verbose]")
    endif()
endmacro()


# ====================
# Star horizontal line (verbose mode)
# ====================
macro(CM_MESSAGE_VERBOSE_STAR_LINE)
    if(PROJECT_CMAKE_ENABLE_VERBOSE_MESSAGE)
        message(STATUS "[Verbose] ****************************************")
    endif()
endmacro()
