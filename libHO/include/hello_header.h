#pragma once

#include "hello.h"
#include <string>

inline void hello_header()
{
    #ifdef NDEBUG
    std::cout << "Hello World Header Only Release!" <<std::endl;
    #else
    std::cout << "Hello World Header Only Debug!" <<std::endl;
    #endif
    hello();
}
