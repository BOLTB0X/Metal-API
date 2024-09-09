//
//  mtl_engine.h
//  Metal-Tutorial
//
//  Created by KyungHeon Lee on 2024/05/02.
//

#pragma once

#define GLFW_INCLUDE_NONE
#import <GLFW/glfw3.h>
#define GLFW_EXPOSE_NATIVE_COCOA
#import <GLFW/glfw3native.h>

#include <Metal/Metal.hpp>
#include <Metal/Metal.h>
#include <QuartzCore/CAMetalLayer.hpp>
#include <QuartzCore/CAMetalLayer.h>
#include <QuartzCore/QuartzCore.hpp>
#include <iostream>
#include <simd/simd.h>

#include "VertexData.hpp"
#include "Texture.hpp"
#include <stb/stb_image.h>
#include <filesystem>

class MTLEngine {
public:
    void init();
    void run();
    void cleanup();

private:
    void initDevice();
    void initWindow();

    void createSquare();
    void createTriangle();
    void createDefaultLibrary();
    void createCommandQueue();
    void createRenderPipeline();

    void encodeRenderCommand(MTL::RenderCommandEncoder* renderEncoder);
    void sendRenderCommand();
    void draw();
    
    static void frameBufferSizeCallback(GLFWwindow *window, int width, int height);
    void resizeFrameBuffer(int width, int height);
    
    void createCube(); // add

    MTL::Device* metalDevice;
    GLFWwindow* glfwWindow;
    NSWindow* metalWindow;
    CAMetalLayer* metalLayer;
    CA::MetalDrawable* metalDrawable;

    MTL::Library* metalDefaultLibrary;
    MTL::CommandQueue* metalCommandQueue;
    MTL::CommandBuffer* metalCommandBuffer;
    MTL::RenderPipelineState* metalRenderPSO;
    //MTL::Buffer* triangleVertexBuffer;
    MTL::Buffer* squareVertexBuffer;
    // add
    MTL::Buffer* cubeVertexBuffer;
    MTL::Buffer* transformationBuffer;
    //

    Texture* grassTexture;

};

