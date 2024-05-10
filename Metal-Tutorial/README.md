# Basic Texturing with Metal

## Handling Window Resizing

1. mtl_engine.hpp

   ```cpp
   class MTLEngine {
       // ...
       static void frameBufferSizeCallback(GLFWwindow *window, int width, int height);
       void resizeFrameBuffer(int width, int height);
       // ...
   };
   ```

   - Window 크기를 조정할 때 metalLayer.drawableSize의 해상도는 업데이트 되지 않음

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
     <br/>

## Applying Textures to our Meshes

1. stbi_image.cpp

   ```cpp
   #define STB_IMAGE_IMPLEMENTATION
   #include "stb_image.h"
   ```

   - Mesh에 텍스처를 적용하려면 텍스처 이미지와 메모리에 로드할 방법이 필요
     <br/>

   - 우리는 경량 헤더 전용 이미지 로딩 라이브러리인 stbi_image를 사용
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
       MTL::Texture* texture; // MTL::Texture로 GPU에 복사
       int width, height, channels;

   private:
       MTL::Device* device;
   };
   ```

   - 로드하려는 텍스처 이미지의 파일 경로와 Metal Device를 가져오는 생성자를 정의하여 이미지를 MTL::Texture로 GPU에 복사
     <br/>

   - 로드된 이미지에 포함된 색상 채널의 크기와 수와 Metal Device에 대한 핸들을 저장하기 위해 세 가지 공용 변수인 width, height,channel을 정의
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

4. mtl_engine.mm

   ```cpp
   // ...
   void MTLEngine::createSquare() {
       // 정사각형 정의용 -> 6개의 점
       VertexData squareVertices[] {
           {{-0.5, -0.5,  0.5, 1.0f}, {0.0f, 0.0f}},
           {{-0.5,  0.5,  0.5, 1.0f}, {0.0f, 1.0f}},
           {{ 0.5,  0.5,  0.5, 1.0f}, {1.0f, 1.0f}},
           {{-0.5, -0.5,  0.5, 1.0f}, {0.0f, 0.0f}},
           {{ 0.5,  0.5,  0.5, 1.0f}, {1.0f, 1.0f}},
           {{ 0.5, -0.5,  0.5, 1.0f}, {1.0f, 0.0f}}
       };

       // squareVertexBuffer 생성
       squareVertexBuffer = metalDevice->newBuffer(&squareVertices, sizeof(squareVertices), MTL::ResourceStorageModeShared);

       // grassTexture 텍스처 개체를 생성
       grassTexture = new
       Texture("assets/mc_grass.jpeg", metalDevice);
    }
    // ...
   ```

   - 이미지를 로드하기 위해 상대 경로를 지정하려면 Xcode 작업 디렉터리를 프로젝트 디렉터리로 변경 -> $(PROJECT_DIR)을 디렉터리로 지정
     <br/>

```cpp
// ...
void MTLEngine::encodeRenderCommand(MTL::RenderCommandEncoder* renderCommandEncoder) {
     renderCommandEncoder->setRenderPipelineState(metalRenderPSO);
     renderCommandEncoder->setVertexBuffer(squareVertexBuffer, 0, 0); // add
     MTL::PrimitiveType typeTriangle = MTL::PrimitiveTypeTriangle;
     NS::UInteger vertexStart = 0;
     NS::UInteger vertexCount = 6;
     renderCommandEncoder->setFragmentTexture(grassTexture->texture, 0); // add
     renderCommandEncoder->drawPrimitives(typeTriangle, vertexStart, vertexCount);
}
// ...
```

- renderCommandEncoder를 사용하여 정사각형에 대한 Vertex Shader에 로드할 버퍼를 지정
  <br/>

- Fragment Shader에서 사용할 텍스처를 설정
  <br/>

5. square.metal

   ```cpp
   #include <metal_stdlib>
   using namespace metal;

   #include "VertexData.hpp"

   struct VertexOut {
      // Metal에 원근 분할을 적용해야 함, position 멤버의 [[position]] 프로퍼티 선언
      float4 position [[position]];
      float2 textureCoordinate;
   };

   vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
      constant VertexData* vertexData) {
         VertexOut out;
         out.position = vertexData[vertexID].position;
         out.textureCoordinate = vertexData[vertexID].textureCoordinate;

     return out;
   }

   fragment float4 fragmentShader(VertexOut in [[stage_in]],
   // stage_in: in 매개변수가 이전 파이프라인 단계의 입력
   // 텍스처를 index 0에 원하는 *[[texture(0)]] 속성으로 지정하여 텍스처를 Texture2d<float>로 받아들일 것
   texture2d<float> colorTexture [[texture(0)]]) {
        constexpr sampler textureSampler (mag_filter::linear,
      min_filter::linear);

        const float4 colorSample = colorTexture.sample(textureSampler, in.textureCoordinate);

      return colorSample;
   }
   ```

   - 텍스처를 샘플링할 때 보간된 텍스처 좌표 정보가 필요하므로 우리는 조각 셰이더()에 대한 입력으로 VertexOut 정보를 전달할 것
     <br/>

   - Magnification(확대): 텍스처가 원래 크기보다 화면에 더 큰 크기로 표시될 때 발생즉, 텍셀이 두 개 이상의 화면 픽셀을 덮음)
     이 경우 셰이더는 텍셀 사이의 색상 값을 보간하여 텍셀 사이를 부드럽게 전환하고 블록 모양을 방지해야 함
     <br/>

   - Minification(축소): 텍스처가 원래 크기보다 화면에 더 작은 크기로 표시될 때 발생(예: 여러 텍셀이 단일 화면 픽셀에 매핑됨)
     이 경우 셰이더는 단일 화면 픽셀로 결합되는 텍셀 그룹을 나타내는 최상의 색상 값을 결정해야 한
     <br/>

   - TextureSampler와 in.textureCoordinate의 보간된 텍스처 좌표를 이용하여 텍스처에서 색상을 샘플링하고 반환
     <br/>

6. mtl_engine.cpp

   ```cpp
   void MTLEngine::encodeRenderCommand(MTL::RenderCommandEncoder* renderCommandEncoder) {
       renderCommandEncoder->setRenderPipelineState(metalRenderPSO);
       renderCommandEncoder->setVertexBuffer(squareVertexBuffer, 0, 0);
       MTL::PrimitiveType typeTriangle = MTL::PrimitiveTypeTriangle; // add
       NS::UInteger vertexStart = 0;
       NS::UInteger vertexCount = 6; // add
       renderCommandEncoder->setFragmentTexture(grassTexture->texture, 0); // add
       renderCommandEncoder->drawPrimitives(typeTriangle, vertexStart, vertexCount);
   }
   ```

   - squareVertexBuffer, 정점 수를 6으로 업데이트
     <br/>
   - Fragment 셰이더의 텍스처 인덱스 0에 grassTexture를 설정

<img width="797" alt="스크린샷 2024-05-02 오후 5 33 09" src="https://github.com/BOLTB0X/Metal-API/assets/83914919/f02aba09-0285-4de5-ae87-93981a342171">

<img width="799" alt="스크린샷 2024-05-02 오후 5 36 34" src="https://github.com/BOLTB0X/Metal-API/assets/83914919/b62d3f72-8c7f-418c-a02a-70ec7738bf5e">

## 원본

[Basic Texturing with Metal](https://metaltutorial.com/Lesson%201%3A%20Hello%20Metal/3.%20Textures/)
