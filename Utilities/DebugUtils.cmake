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
# Dash horizontal line.
macro(CM_MESSAGE_DASH_LINE)
    message(STATUS "----------------------------------------")
endmacro()


# New line.
macro(CM_MESSAGE_NEW_LINE)
    message(STATUS "")
endmacro()


# Star line.
macro(CM_MESSAGE_STAR_LINE)
    message(STATUS "****************************************")
endmacro()




# ************************************************************
# FOOTER / HEADER MESSAGE
# ************************************************************
# Footer message (All).
macro(CM_MESSAGE_FOOTER_COMMON Footer)
    message("************************************************************")
    message("**** End:   ${Footer}")
    message("************************************************************")
endmacro()


# Footer message (State dependent).
macro(CM_MESSAGE_FOOTER Footer)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG OR PROJECT_CMAKE_ENABLE_HELP_MESSAG)
        cm_message_footer_common(${Footer})
    endif()
endmacro()


# Header message (All).
macro(CM_MESSAGE_HEADER_COMMON Header)
    message("************************************************************")
    message("**** Start: ${Header}")
    message("************************************************************")
endmacro()


# Header message (State dependent).
macro(CM_MESSAGE_HEADER Header)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG OR PROJECT_CMAKE_ENABLE_HELP_MESSAG)
        cm_message_header_common(${Header})
    endif()
endmacro()


# Footer sub message (State dependent).
macro(CM_MESSAGE_SUB_FOOTER Footer)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG OR PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "------------------------------------------------------------")
        message(STATUS "- End:   ${Footer}")
        message(STATUS "------------------------------------------------------------")
    endif()
endmacro()


# Header sub message (State dependent).
macro(CM_MESSAGE_SUB_HEADER Header)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG OR PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "------------------------------------------------------------")
        message(STATUS "- Start: ${Header}")
        message(STATUS "------------------------------------------------------------")
    endif()
endmacro()




# ************************************************************
# MESSAGE (HELP)
# ************************************************************
# Help message.
macro(CM_MESSAGE_HELP Msg)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "[Help]    ${Msg}")
    endif()
endmacro()


# Footer message.
macro(CM_MESSAGE_HELP_FOOTER Footer)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        cm_message_footer_common(${Footer})
    endif()
endmacro()


# Header message.
macro(CM_MESSAGE_HELP_HEADER Header)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        cm_message_header_common(${Header})
    endif()
endmacro()


# Dash horizontal line.
macro(CM_MESSAGE_HELP_DASH_LINE)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "[Help]    ----------------------------------------")
    endif()
endmacro()


# Star horizontal line.
macro(CM_MESSAGE_HELP_STAR_LINE)
    if(PROJECT_CMAKE_ENABLE_HELP_MESSAGE)
        message(STATUS "[Help]    ****************************************")
    endif()
endmacro()




# ************************************************************
# MESSAGE (DEBUG)
# ************************************************************
# Debug message.
macro(CM_MESSAGE_DEBUG State Msg)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG)
        message("${State}" "[Debug]   ${Msg}")
    endif()
endmacro()


# List output.
macro(CM_MESSAGE_DEBUG_OUTPUT State Values)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG)
        foreach(m ${Values})
            cm_message_debug("${State}" "  [*] ${m}")
        endforeach()
    endif()
endmacro()


# Footer message.
macro(CM_MESSAGE_DEBUG_FOOTER Footer)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG)
        cm_message_footer_common(${Footer})
    endif()
endmacro()


# Header message.
macro(CM_MESSAGE_DEBUG_HEADER Header)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG)
        cm_message_header_common(${Header})
    endif()
endmacro()




# ************************************************************
# MESSAGE (STATUS)
# ************************************************************
# Status message.
macro(CM_MESSAGE_STATUS State Msg)
    message("${State}" "[Status]  ${Msg}")
endmacro()


# List output.
macro(CM_MESSAGE_STATUS_OUTPUT State Msg)
    foreach(m ${Msg})
        cm_message_status("${State}" "  [*] ${m}")
    endforeach()
endmacro()




# ************************************************************
# MESSAGE (VERBOSE)
# ************************************************************
# Verbose message.
macro(CM_MESSAGE_VERBOSE State Msg)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_VERBOSE OR PROJECT_CMAKE_ENABLE_MESSAGE_DEBUG)
        message("${State}" "[Verbose] ${Msg}")
    endif()
endmacro()


# List output.
macro(CM_MESSAGE_VERBOSE_OUTPUT State Msg)
    foreach(m ${Msg})
        cm_message_verbose("${State}" "  [*] ${m}")
    endforeach()
endmacro()


# Dash horizontal line.
macro(CM_MESSAGE_VERBOSE_DASH_LINE)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_VERBOSE)
        message(STATUS "[Verbose] ----------------------------------------")
    endif()
endmacro()


# New line.
macro(CM_MESSAGE_VERBOSE_NEW_LINE)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_VERBOSE)
        message(STATUS "[Verbose]")
    endif()
endmacro()


# Star horizontal line.
macro(CM_MESSAGE_VERBOSE_STAR_LINE)
    if(PROJECT_CMAKE_ENABLE_MESSAGE_VERBOSE)
        message(STATUS "[Verbose] ****************************************")
    endif()
endmacro()
