#include "lib/lib.hpp"

#include <sbe/SampleSimple.h>

#include <iostream>

namespace lib {

void Foo::operator()() {
    char buf[4096];
    sbe::SampleSimple simple{buf, 4096};
    simple.putMessage(std::string{"sbe message"});
    simple.sbeRewind();
    std::cout << simple.getMessageAsString() << std::endl;
    std::cout << "called Foo" << std::endl;
}

}  // namespace lib
