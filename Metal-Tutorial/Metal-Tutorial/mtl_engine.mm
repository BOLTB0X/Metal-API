//
//  mtl_engine.cpp
//  Metal-Tutorial
//
//  Created by KyungHeon Lee on 2024/05/02.
//

#include "mtl_engine.hpp"

void MTLEngine::init() {
    initDevice();
    initWindow();
    
    createSquare();
    //createTriangle();
    createDefaultLibrary();
    createCommandQueue();
    createRenderPipeline();
}

void MTLEngine::run() {
    while (!glfwWindowShouldClose(glfwWindow)) {
        @autoreleasepool {
            metalDrawable = (__bridge CA::MetalDrawable*)[metalLayer nextDrawable];
            draw();
        }
        glfwPollEvents();
    }
}

void MTLEngine::cleanup() {
    glfwTerminate();
    metalDevice->release();
}

void MTLEngine::initDevice() {
    metalDevice = MTL::CreateSystemDefaultDevice();
}

void MTLEngine::frameBufferSizeCallback(GLFWwindow *window, int width, int height) {
    MTLEngine* engine = (MTLEngine*)glfwGetWindowUserPointer(window);
    engine->resizeFrameBuffer(width, height);
}

void MTLEngine::resizeFrameBuffer(int width, int height) {
    metalLayer.drawableSize = CGSizeMake(width, height);
}

void MTLEngine::initWindow() {
    glfwInit();
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindow = glfwCreateWindow(800, 600, "Metal Engine", NULL, NULL);
    
    if (!glfwWindow) {
        glfwTerminate();
        exit(EXIT_FAILURE);
    }
    
    int width, height;
    glfwGetFramebufferSize(glfwWindow, &width, &height);
    
    metalWindow = glfwGetCocoaWindow(glfwWindow);
    metalLayer = [CAMetalLayer layer];
    metalLayer.device = (__bridge id<MTLDevice>)metalDevice;
    metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    metalLayer.drawableSize = CGSizeMake(width, height);
    metalWindow.contentView.layer = metalLayer;
    metalWindow.contentView.wantsLayer = YES;
    
    glfwSetWindowUserPointer(glfwWindow, this);
    glfwSetFramebufferSizeCallback(glfwWindow, frameBufferSizeCallback);
}

//void MTLEngine::createTriangle() {
//    simd::float3 triangleVertices[] = {
//        {-0.5f, -0.5f, 0.0f},
//        { 0.5f, -0.5f, 0.0f},
//        { 0.0f,  0.5f, 0.0f}
//    };
//
//    triangleVertexBuffer = metalDevice->newBuffer(&triangleVertices,
//                                                  sizeof(triangleVertices),
//                                                  MTL::ResourceStorageModeShared);
//}

void MTLEngine::createDefaultLibrary() {
    metalDefaultLibrary = metalDevice->newDefaultLibrary();
    if(!metalDefaultLibrary){
        std::cerr << "Failed to load default library.";
        std::exit(-1);
    }
}

void MTLEngine::createCommandQueue() {
    metalCommandQueue = metalDevice->newCommandQueue();
}

void MTLEngine::createRenderPipeline() {
    MTL::Function* vertexShader = metalDefaultLibrary->newFunction(NS::String::string("vertexShader", NS::ASCIIStringEncoding));
    assert(vertexShader);
    MTL::Function* fragmentShader = metalDefaultLibrary->newFunction(NS::String::string("fragmentShader", NS::ASCIIStringEncoding));
    assert(fragmentShader);
    
    MTL::RenderPipelineDescriptor* renderPipelineDescriptor = MTL::RenderPipelineDescriptor::alloc()->init();
    renderPipelineDescriptor->setLabel(NS::String::string("Triangle Rendering Pipeline", NS::ASCIIStringEncoding));
    renderPipelineDescriptor->setVertexFunction(vertexShader);
    renderPipelineDescriptor->setFragmentFunction(fragmentShader);
    assert(renderPipelineDescriptor);
    MTL::PixelFormat pixelFormat = (MTL::PixelFormat)metalLayer.pixelFormat;
    renderPipelineDescriptor->colorAttachments()->object(0)->setPixelFormat(pixelFormat);
    
    NS::Error* error;
    metalRenderPSO = metalDevice->newRenderPipelineState(renderPipelineDescriptor, &error);
    
    renderPipelineDescriptor->release();
}

void MTLEngine::draw() {
    sendRenderCommand();
}

void MTLEngine::sendRenderCommand() {
    metalCommandBuffer = metalCommandQueue->commandBuffer();

    MTL::RenderPassDescriptor* renderPassDescriptor = MTL::RenderPassDescriptor::alloc()->init();
    MTL::RenderPassColorAttachmentDescriptor* cd = renderPassDescriptor->colorAttachments()->object(0);
    cd->setTexture(metalDrawable->texture());
    cd->setLoadAction(MTL::LoadActionClear);
    cd->setClearColor(MTL::ClearColor(41.0f/255.0f, 42.0f/255.0f, 48.0f/255.0f, 1.0));
    cd->setStoreAction(MTL::StoreActionStore);

    MTL::RenderCommandEncoder* renderCommandEncoder = metalCommandBuffer->renderCommandEncoder(renderPassDescriptor);
    encodeRenderCommand(renderCommandEncoder);
    renderCommandEncoder->endEncoding();

    metalCommandBuffer->presentDrawable(metalDrawable);
    metalCommandBuffer->commit();
    metalCommandBuffer->waitUntilCompleted();

    renderPassDescriptor->release();
}

void MTLEngine::encodeRenderCommand(MTL::RenderCommandEncoder* renderCommandEncoder) {
    renderCommandEncoder->setRenderPipelineState(metalRenderPSO);
    renderCommandEncoder->setVertexBuffer(squareVertexBuffer, 0, 0);
    //renderCommandEncoder->setVertexBuffer(triangleVertexBuffer, 0, 0);
    MTL::PrimitiveType typeTriangle = MTL::PrimitiveTypeTriangle;
    NS::UInteger vertexStart = 0;
    NS::UInteger vertexCount = 6;
    //NS::UInteger vertexCount = 3;
    renderCommandEncoder->setFragmentTexture(grassTexture->texture, 0);
    renderCommandEncoder->drawPrimitives(typeTriangle, vertexStart, vertexCount);
}

void MTLEngine::createSquare() {
    VertexData squareVertices[] {
        {{-0.5, -0.5,  0.5, 1.0f}, {0.0f, 0.0f}},
        {{-0.5,  0.5,  0.5, 1.0f}, {0.0f, 1.0f}},
        {{ 0.5,  0.5,  0.5, 1.0f}, {1.0f, 1.0f}},
        {{-0.5, -0.5,  0.5, 1.0f}, {0.0f, 0.0f}},
        {{ 0.5,  0.5,  0.5, 1.0f}, {1.0f, 1.0f}},
        {{ 0.5, -0.5,  0.5, 1.0f}, {1.0f, 0.0f}}
    };

    squareVertexBuffer = metalDevice->newBuffer(&squareVertices, sizeof(squareVertices), MTL::ResourceStorageModeShared);

    grassTexture = new Texture("assets/tom.jpg", metalDevice);
}
