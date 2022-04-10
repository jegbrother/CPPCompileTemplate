#include "helloworld.h"
#include <thread>
#include <iostream>

int main(int argc, char *argv[])
{
    for (int n = 0; n < argc; n++)
    {
        std::cout << argv[n] << std::endl;
    }
    SayHelloWorld();
    return 0;
}
