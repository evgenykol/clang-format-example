# Copyright Tomas Zeman 2019.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

# https://github.com/zemasoft/clangformat-cmake

function(add_target_wrap target_name)
  if(TARGET ${target_name})
    add_dependencies(${target_name} ${PROJECT_NAME}_${target_name})
  else()
    add_custom_target(${target_name} DEPENDS ${PROJECT_NAME}_${target_name})
  endif()
endfunction()


function(clangformat_setup)
  if(NOT CLANGFORMAT_EXECUTABLE)
    set(CLANGFORMAT_EXECUTABLE clang-format)
  endif()

  if(NOT EXISTS ${CLANGFORMAT_EXECUTABLE})
    find_program(clangformat_executable_tmp ${CLANGFORMAT_EXECUTABLE})
    if(clangformat_executable_tmp)
      set(CLANGFORMAT_EXECUTABLE ${clangformat_executable_tmp})
      unset(clangformat_executable_tmp)
    else()
      message(FATAL_ERROR "ClangFormat: ${CLANGFORMAT_EXECUTABLE} not found! Aborting")
    endif()
  endif()

  foreach(clangformat_source ${ARGV})
    get_filename_component(clangformat_source ${clangformat_source} ABSOLUTE)
    list(APPEND clangformat_sources ${clangformat_source})
  endforeach()

  add_custom_target(${PROJECT_NAME}_clangformat
    COMMAND
      ${CLANGFORMAT_EXECUTABLE}
      -style=file
      -i
      ${clangformat_sources}
    COMMENT
      "Formating with ${CLANGFORMAT_EXECUTABLE} ..."
  )

  add_custom_target(${PROJECT_NAME}_clangformat_check
    COMMAND
      ${CLANGFORMAT_EXECUTABLE}
      -style=file
      -output-replacements-xml
      ${clangformat_sources}
      #print output
      | tee ${CMAKE_BINARY_DIR}/check_format_file.txt | grep -c "replacement " |
                tr -d "[:cntrl:]" && echo " replacements necessary"

    # stop with error if there are problems
    COMMAND ! grep -c "replacement "
                ${CMAKE_BINARY_DIR}/check_format_file.txt > /dev/null
    COMMENT
      "Checking format compliance"
  )

  add_target_wrap(clangformat)
  add_target_wrap(clangformat_check)

endfunction()

function(target_clangformat_setup target)
  get_target_property(target_sources ${target} SOURCES)
  clangformat_setup(${target_sources})
endfunction()
