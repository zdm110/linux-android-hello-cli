cmake_minimum_required(VERSION 3.6)
project(hello)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")


set(SOURCE_FILES
        ./hello.c
        )


ADD_EXECUTABLE(hello
        ${SOURCE_FILES}
        )
