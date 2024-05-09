# Basic Texturing with Metal

## Handling Window Resizing

> Window 크기 조정

Window 크기를 조정할 때 metalLayer.drawableSize의 해상도는 업데이트 되지 않음

1. mtl_engine.hpp

   ```cpp
   class MTLEngine {
       // ...
       static void frameBufferSizeCallback(GLFWwindow *window, int width, int height);
       void resizeFrameBuffer(int width, int height);
       // ...
   };
   ```

   <br/>

2. mtl_engine.cpp

   ```cpp
   void MTLEngine::initWindow() {
       // ...
       glfwSetWindowUserPointer(glfwWindow, this);
       glfwSetFramebufferSizeCallback(glfwWindow, frameBufferSizeCallback);
       // ...
   }
   ```

   - glfwSetWindowUserPointer() 및 glfwGetWindowUserPointer() 함수를 사용하여 metalLayer 변수의 drawableSize 을 업데이트
     <br/>

   - GLFW Window에 MTLEngine 인스턴스에 대한 포인터를 저장한 후, 정적 콜백 함수에서 이를 검색하여 비정적 resizeFramebuffer() 함수에 액세스 가능, 이 코드에선 metalLayer.drawableSize의 크기를 조정

## Applying Textures to our Meshes

- Mesh에 텍스처를 적용하려면 텍스처 이미지가 필요
  <br/>

- 메모리에 로드할 방법이 필요
  <br/>

- 우리는 경량 헤더 전용 이미지 로딩 라이브러리인 stbi_image를 사용

1. stbi_image.cpp

   ```cpp
   #define STB_IMAGE_IMPLEMENTATION
   #include "stb_image.h"
   ```

   <br/>

- 로드하려는 텍스처 이미지의 파일 경로와 Metal Device를 가져오는 생성자를 정의하여 이미지를 MTL::Texture로 GPU에 복사

<br/>

- 로드된 이미지에 포함된 색상 채널의 크기와 수는 물론 Metal Device에 대한 핸들을 저장하기 위해 세 가지 공용 변수인 width, height,channel을 정의
  <br/>

2. Texture.hpp

   ```cpp
   #pragma once
   #include <Metal/Metal.hpp>
   #include <stb/stb_image.h>

   class Texture {
   public:
       Texture(const char* filepath, MTL::Device* metalDevice);
       ~Texture();
       MTL::Texture* texture;
       int width, height, channels;

   private:
       MTL::Device* device;
   };
   ```

<br/>

3. Texture.cpp

   ```cpp
   #include "Texture.hpp"

   Texture::Texture(const char* filepath, MTL::Device* metalDevice) {
       // exture() 생성자에서 먼저 Metal Device 핸들을 설정한 다음 stbi에게 로드 시 이미지를 수직으로 반전
       device = metalDevice;

       stbi_set_flip_vertically_on_load(true);
       unsigned char* image = stbi_load(filepath, &width, &height, &channels, STBI_rgb_alpha);
       assert(image != NULL);

       // 이미지를 로드하고 포인터가 null이 아닌지 확인한 다음 이미지의 픽셀 형식과 너비 및 높이를 지정
       MTL::TextureDescriptor* textureDescriptor = MTL::TextureDescriptor::alloc()->init();
       textureDescriptor->setPixelFormat(MTL::PixelFormatRGBA8Unorm);
       textureDescriptor->setWidth(width);
       textureDescriptor->setHeight(height);

       // device에 지정된 매개변수를 사용하여 텍스처를 생성하도록 요청한 다음 이미지 데이터를 텍스처 버퍼에 복사
       texture = device->newTexture(textureDescriptor);

       // 마지막으로 텍스처 설명자를 해제하고 이미지 버퍼를 해제
       // GPU 메모리에 텍스처가 로
       MTL::Region region = MTL::Region(0, 0, 0, width, height, 1);
       NS::UInteger bytesPerRow = 4 * width;

       texture->replaceRegion(region, 0, image, bytesPerRow);

       textureDescriptor->release();
       stbi_image_free(image);
   }

   Texture::~Texture() {
       texture->release();
   }

   ```

   <br/>

- squareVertexBuffer를 생성
  <br/>

- grassTexture 텍스처 개체를 생성
  <br/>

- 주목해야 할 중요한 점은 여기서 수행한 것처럼 이미지를 로드하기 위해 상대 경로를 지정하려면 Xcode 작업 디렉터리를 프로젝트 디렉터리로 변경 -> $(PROJECT_DIR)을 디렉터리로 지정
  <br/>

- 원하는 경우 텍스처에 대한 전체 경로를 지정하여 로드할 수도 있음
  <br/>

4. mtl_engine.cpp

   ```cpp
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

       grassTexture = new
       Texture("assets/mc_grass.jpeg", metalDevice);
    }
   ```
