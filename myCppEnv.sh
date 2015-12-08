#!/bin/bash
## Creates a folder to hold a basic project with cmake and gtest. Uses the first argument as name for the project and files

if [ $# -eq 0 ] 
then
    echo "Needs argument"
    exit 1
fi


fileName="${1^}"
upperCaseName="$(tr '[:lower:]' '[:upper:]' <<< $1)"
lowerCaseName="$(tr '[:upper:]' '[:lower:]' <<< $1)"
specName=$fileName'Spec'

#Create folders build/include/src/test
mkdir $lowerCaseName
cd $lowerCaseName
mkdir include/ src/ test/ build/


#Create basic header
echo '#ifndef '$upperCaseName'_H
#define '$upperCaseName'_H


#endif' > include/$fileName.h

#Create basic cpp
echo '#include "'$fileName'.h"' > src/$fileName.cpp

#Create example test file
echo '#include <gtest/gtest.h>
#include "'$fileName'.h"

class '$specName' : public testing::Test
{
protected:

    void SetUp()
    {
        
    }

    void TearDown()
    {
        // Teardown ...
    }

};

TEST_F('$specName', fail)
{
    FAIL();
}' > test/$specName.cpp


#Create example CMakeList.txt
echo 'cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project('$fileName')

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wpedantic -Wextra -Weffc++ -g")

include_directories(include)
file(GLOB '$upperCaseName'_SF "src/*")

add_library('$lowerCaseName' SHARED ${'$upperCaseName'_SF})

enable_testing()
find_package(GTest REQUIRED)

include_directories(${GTEST_INCLUDE_DIRS})

add_executable('$specName' test/'$specName'.cpp)
target_link_libraries('$specName' '$lowerCaseName' ${GTEST_BOTH_LIBRARIES})' > CMakeLists.txt

echo '## '$fileName > README.md

git init
cd build/
cmake ..
make

