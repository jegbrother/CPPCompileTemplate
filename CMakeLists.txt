cmake_minimum_required(VERSION 2.8) # 指定cmake的最小版本
cmake_policy(SET CMP0015 NEW) # 解决Policy CMP0015 is not set错误

message(STATUS "$ENV{HOME}")

if(UNIX)
    message(STATUS "[Linux env usage]: cd cmakebuild && cmake -DCMAKE_BUILD_TYPE=Debug ../ ")
elseif(WIN32)
    message(STATUS "[Windows env MinGW usage]: cd cmakebuild && cmake -G \"MinGW Makefiles\" ../ ")
    set_property(GLOBAL PROPERTY USE_FOLDERS On)
elseif(APPLE)
    message(STATUS "This operating system is APPLE.")
endif(UNIX)


set(DEMO_NAME cppcompiletemplate)
set(PROJECT_SOURCE_DIR ".")
set(EXECUTABLE_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/sbin") # 指定可执行程序编译输出目录
set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/lib") # 指定静态库或者动态库编译输出目录

project(${DEMO_NAME} CXX C)  # 指定C++和C都参与编译


set(CMAKE_CXX_COMPILER "g++")
set(CMAKE_C_COMPILER ${CMAKE_CXX_COMPILER})  # 使用g++来编译.c文件，否则c的函数就需要extern "C"导出

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")
#set(CMAKE_CXX_STANDARD 98)
#set(CMAKE_CXX_STANDARD 11)
# 自动检测编译器是否支持C++11
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
    message(WARNING "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()



#set(CMAKE_BUILD_TYPE "Release") # 相当于cmake -DCMAKE_BUILD_TYPE=Release ../
#set(CMAKE_BUILD_TYPE "Debug") # 相当于cmake -DCMAKE_BUILD_TYPE=Debug ../

#add_definitions(-DNDEBUG) # 设置宏定义，-D宏名称，也可以用来添加编译选项，比如add_definitions(-pthread)

# add_compile_options命令添加的编译选项是针对所有编译器的(包括c和c++编译器)
add_compile_options(-W -Wall -Wfatal-errors -fpermissive)  # add_compile_options在末尾添加参数，不能加双引号

set(LFLAGS_DEBUG "-O0 -g")  # Debug模式 
set(LFLAGS_RELEASE "-O2 -s -static-libstdc++ -static-libgcc")  # Release模式

# set命令设置CMAKE_C_FLAGS或CMAKE_CXX_FLAGS变量则是分别只针对c和c++编译器的
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${LFLAGS_DEBUG}") # 使用 cmake -DCMAKE_BUILD_TYPE=Debug ../
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${LFLAGS_DEBUG}")

set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${LFLAGS_RELEASE}") # 使用 cmake -DCMAKE_BUILD_TYPE=Release ../
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${LFLAGS_RELEASE}")


###############################################################################################################

add_definitions() # 额外的宏定义
add_compile_options() # 额外的编译选项
set(SRC_DIR_ROOT ) # 设置源文件目录，这里不能用双引号
include_directories() # 设置包含目录
link_directories() # 设置动态和静态链接库搜索目录
link_libraries() # 静态链接link_libraries用在add_executable之前，需要结合link_directories使用

###############################################################################################################


include_directories(./ ${SRC_DIR_ROOT})
FOREACH(SRC_DIR ${SRC_DIR_ROOT})
    file(GLOB_RECURSE USER_FILE_PATH ${USER_FILE_PATH} ${SRC_DIR}/*.cc ${SRC_DIR}/*.cpp ${SRC_DIR}/*.hpp)
ENDFOREACH(SRC_DIR)

aux_source_directory(. SRC_LIST) # 编译源文件
add_executable(${DEMO_NAME} ${SRC_LIST} ${USER_FILE_PATH}) # 编译可执行程序

#target_link_libraries(${DEMO_NAME} rt) # 动态链接target_link_libraries用在add_executable之后，需要结合link_directories使用


# -pthread既是编译指令，也是链接指令。编译只能指定-pthread，也可以不指定。
# 链接时：-pthread参数最终是-pthread指令，pthread是参数会转换成-lpthread，和直接指定-lpthread一样的效果。
# set_target_properties一次性强制指定编译和链接-pthread，需要放到add_executable之后
set_target_properties(${DEMO_NAME} PROPERTIES COMPILE_FLAGS "-pthread" LINK_FLAGS "-pthread")

message(STATUS "${SRC_LIST} ${USER_FILE_PATH}")
#add_library(${DEMO_NAME} STATIC ${SRC_LIST}) # 编译静态库
#add_library(${DEMO_NAME} SHARED ${SRC_LIST}) # 编译动态库

