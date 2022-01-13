
# how to build the result of the library

# create a target out of the library compilation result

# create an library target out of the library compilation result

# Ensure FindHaskell is run and GHC has been found (or make a custom target ;))
# Windows only atm
function(add_haskell_library target_name header_dir)
  list(LENGTH ARGN num_source_files)
  if(num_source_files LESS 1)
    message(FATAL_ERROR "No SOURCES given to target: ${target_name}")
  endif()
  set(library_file "${CMAKE_CURRENT_BINARY_DIR}/${target_name}.dll")
  set(library_link_file "${CMAKE_CURRENT_BINARY_DIR}/${target_name}.dll.a")
  
  # if
  
  add_custom_command(OUTPUT ${library_file} ${library_link_file}
                     COMMAND ${HASKELL_EXECUTABLE} 
                     ARGS -shared 
                     -o ${library_file} 
                     -outputdir ${CMAKE_CURRENT_BINARY_DIR}
                     -stubdir ${header_dir} 
                     ${ARGN}
                     WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  
  add_custom_target("${target_name}_target" DEPENDS ${library_file} ${library_link_file})
 
  add_library(${target_name} SHARED IMPORTED GLOBAL)
  add_dependencies(${target_name} "${target_name}_target")

  # specify where the library is, where the import lib is and where to find the headers
  set_target_properties(${target_name}
    PROPERTIES
    IMPORTED_LOCATION ${library_file}
    IMPORTED_IMPLIB ${library_link_file}
    INTERFACE_INCLUDE_DIRECTORIES ${header_dir} ${HASKELL_INCLUDE_DIR})

endfunction()
