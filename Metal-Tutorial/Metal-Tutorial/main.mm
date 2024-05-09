//
//  main.cpp
//  Metal-Tutorial
//
//  Created by KyungHeon Lee on 2024/05/02.
//

#include "mtl_engine.hpp"

int main(int argc, const char * argv[]) {
    MTLEngine engine;
    engine.init();
    engine.run();
    engine.cleanup();
    
    return 0;
}
