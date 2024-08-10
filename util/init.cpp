#include "util/init.hpp"

#include <unistd.h>

#include <iostream>

void Init() {
    std::cout << "pid=" << getpid() << std::endl;

#ifndef TEMPLATE_VERSION
    std::termindate("TEMPLATE_VERSION undefined");
#endif
    std::cout << "version=" << TEMPLATE_VERSION << std::endl;

#ifndef TEMPLATE_REVISION
    std::terminate("TEMPLATE_REVISION undefined");
#endif
    std::cout << "revision=" << TEMPLATE_REVISION << std::endl;

#ifdef NDEBUG
    std::cout << "NDEBUG defined, running a release build, assertions do nothing" << std::endl;
#else
    std::cout << "NDEBUG not defined, running a debug build, assertions turned on" << std::endl;
#endif
}
