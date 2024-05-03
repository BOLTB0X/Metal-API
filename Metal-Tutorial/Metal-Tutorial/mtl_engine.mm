//
//  mtl_engine.cpp
//  Metal-Tutorial
//
//  Created by KyungHeon Lee on 2024/05/02.
//

#include "mtl_engine.hpp"

// MARK: - init
void MTLEngine::init() {
    initDevice();
    initWindow();
}

// MARK: - run
void MTLEngine::run() {
    while (!glfwWindowShouldClose(glfwWindow)) {
        glfwPollEvents();
    }
}

// MARK: - cleanup
void MTLEngine::cleanup() {
    glfwTerminate();
    metalDevice->release();
}

// MARK: - initDevice
void MTLEngine::initDevice() {
    metalDevice = MTL::CreateSystemDefaultDevice();
}

// MARK: - initWindow
void MTLEngine::initWindow() {
    glfwInit();
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindow = glfwCreateWindow(800, 600, "Metal Engine", NULL, NULL);
    if (!glfwWindow) {
        glfwTerminate();
        exit(EXIT_FAILURE);
    }

    metalWindow = glfwGetCocoaWindow(glfwWindow);
    metalLayer = [CAMetalLayer layer];
    metalLayer.device = (__bridge id<MTLDevice>)metalDevice;
    metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    metalWindow.contentView.layer = metalLayer;
    metalWindow.contentView.wantsLayer = YES;
}

