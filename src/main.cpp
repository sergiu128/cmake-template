#include <iostream>

#include "lib/lib.hpp"
#include "util/init.hpp"

int main() {
    Init();
    lib::Foo foo{};
    foo();
    std::cout << "hello, world!" << "\n";
}
