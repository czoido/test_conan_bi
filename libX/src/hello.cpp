#include <iostream>
#include "hello.h"

void hello(){
    #ifdef NDEBUG
    std::cout << "Hello World libX Release!" <<std::endl;
    #else
    std::cout << "Hello World libX Debug!" <<std::endl;
    #endif
}
