#include <iostream>
#include "hellor.h"

void hellor(){
    #ifdef NDEBUG
    std::cout << "Hello World libR Release!" <<std::endl;
    #else
    std::cout << "Hello World libR Debug!" <<std::endl;
    #endif
}
