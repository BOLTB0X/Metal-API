//
//  main.cpp
//  Metal-Tutorial
//
//  Created by KyungHeon Lee on 2024/05/02.
//

#include "mtl_engine.hpp"

//#include <Metal/Metal.hpp>
//#include <iostream>

int main(int argc, const char * argv[]) {
    // insert code here...
//    MTL::Device* device = MTL::CreateSystemDefaultDevice();
//
//    std::cout << "Hello, World Metal-CPP!\n";
    MTLEngine engine;
    engine.init();
    engine.run();
    engine.cleanup();
    
    return 0;
}
