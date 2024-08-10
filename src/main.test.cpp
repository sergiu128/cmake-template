#include <gtest/gtest.h>

#include "util/init.hpp"

int main(int argc, char *argv[]) {
    Init();

    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
