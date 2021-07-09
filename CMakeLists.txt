# CMakeLists.txt
cmake_minimum_required(VERSION 3.14)
set (CMAKE_CXX_STANDARD 17)

project(main)


find_package(sdbus-c++ REQUIRED)

file(GLOB SERVERSOURCES  
     ./apps/server.cpp
)

file(GLOB CLIENTSOURCES  
     ./apps/client.cpp
)

list(APPEND includePath "" )


add_executable(server ${SERVERSOURCES} )
add_executable(client ${CLIENTSOURCES} )


target_include_directories(server PUBLIC ${includePath}  )
target_include_directories(client PUBLIC ${includePath}  )


target_link_libraries(server PUBLIC  SDBusCpp::sdbus-c++)
target_link_libraries(client PUBLIC  SDBusCpp::sdbus-c++)

