# Rendering a Triangle to the Screen

Metal API 에선 Pipeline은 3D 그래픽을 렌더링하기 위해 사용

## The Graphics Rendering Pipeline

> Pipeline은 data나 작업이 여러 단계를 거쳐 처리되는 방식을 설명하는 개념

![절차](https://metaltutorial.com/images/graphicsPipeline.png)

_cf Shader: 화면에 출력할 픽셀의 위치와 색상을 계산하는 함수_

- 초록색 단계 (완전히 프로그램 가능한 단계)

  - 여기서는 C++ 애플리케이션 코드 및 GPU에서 실행되는 Vertex(정점) 및 Fragment(프래그먼트) Shader 프로그램을 작성
  - GPU는 대규모 병렬 장치이며, 셰이더 프로그램은 이를 활용하기 위해 특별히 설계되었음
  - Vertex(정점) 셰이더는 씬의 메쉬 정점을 동시에 처리하며, 프래그먼트 셰이더는 화면에 렌더링할 각 픽셀에 대해 작동함
    <br/>

- 빨간색 단계(프로그래밍 X, 구성만 가능한 단계)

1. Metal Application

   > MTLEngine 설정, Metal 장치 초기화, GLFW 창 구성, 셰이더 코드를 라이브러리로 컴파일, 커맨드 버퍼 생성, 그리고 렌더링 루프 관리 등이 수행

   C++ 측면의 작업으로 GPU 명령을 인코딩하여 렌더링이나 컴퓨팅 관련 작업을 위한 환경을 준비하는 단계
   <br/>

2. Vertex Shader

   > GPU가 작동하는 단계로, Vertex 데이터를 처리하고 변환을 적용한 후 렌더링 파이프라인의 다음 단계로 데이터를 전달

   일반적으로 그래픽스 API에서는 파이프라인의 두 번째 단계가 "Input Assembler"로 시작됨, 이 단계는 GPU의 메모리 버퍼에서 정점 데이터를 수집하고 정렬한 다음 이를 렌더링 파이프라인에 공급하는 역할을 한다고 함
   <br/>

   Metal에서는 이 기능이 "정점 셰이더(Vertex Shader)" 단계와 통합되어 있음 정점 셰이더는 정점 데이터를 처리하고 변환을 적용한 다음 결과 데이터를 렌더링 파이프라인의 다음 단계로 전달함
   <br/>

   Metal에서 정점 데이터를 정점 셰이더로 공급하기 위해서는 정점 설명자(vertex descriptor)를 정의가 필요, 이 설명자는 정점 데이터의 레이아웃과 형식을 지정함, 이 설명자는 정점 버퍼에서 정점 데이터를 정점 셰이더의 입력 속성으로 매핑하는 데 사용
   <br/>

   Metal에서 렌더링 파이프라인을 간소화

<br/>

3. Rasterization

   > 벡터 기반의 기하학을 픽셀 기반의 프래그먼트로 변환, 정점 셰이더에서 처리된 변환된 정점을 사용하여 기하학적 도형을 만들고 프래그먼트를 생성

   래스터화 단계에서는 벡터 기반의 기하학(즉, 정점)을 픽셀 기반의 조각(fragment)으로 변환
   <br/>

   이 단계에서는 정점 셰이더에서 변환된 정점들을 처리하고, 이를 기본 요소(primitives)로 조립하며, 속성을 보간하고, 원근 분할을 수행하고, 정점을 뷰 프러스텀(view frustum)에 클리핑하며, 렌더링된 기하학 내에서 셰이딩할 픽셀을 식별

<br/>

4. Fragment Shader

   > 래스터화 단계에서 생성된 프래그먼트를 처리하고 셰이딩하는 단계, 각 화면 픽셀에 대해 실행되며, 주로 최종 픽셀 색상을 계산하는 수학적 작업을 수행

   레스터화 과정 중에 생성된 픽셀 기반의 조각(fragment)을 처리하고 셰이딩하는 역할
   <br/>

   각 화면 픽셀마다 프래그먼트 셰이더가 실행되며, 주로 텍스처 샘플링, 조명 및 소재 속성 계산, 인근 픽셀의 색상과 혼합하는 등의 일련의 수학적인 연산을 수행하여 픽셀의 최종 색상을 계산함
   <br/>

   처리된 후에는 조각들이 결합되어 최종 렌더링된 이미지를 화면에 생성
   <br/>

5. Blending

   > Fragment Shader 단계의 출력을 프레임 버퍼에 이미 있는 데이터와 혼합하여 최종 색상을 계산함, 즉 투명도, 투명성 및 깊이 등의 요소를 고려

   블렌딩 단계는 프래그먼트 셰이더 단계의 출력물을 프레임버퍼에 이미 존재하는 데이터와 혼합하여 최종 색상을 계산하는 역할
   <br/>

   이 단계에서는 투명도, 반투명성 및 깊이와 같은 요소를 고려하며 블렌딩 단계는 들어오는 프래그먼트 색상을 프레임버퍼에 이미 존재하는 색상과 혼합하여 각 픽셀의 최종 색상이 어떻게 계산되는지를 결정
   <br/>

   이러한 과정을 통해 최종 렌더링된 이미지를 화면에 생성

## To render Triangle

> Metal에서는 다른 그래픽 API와는 달리 셰이더를 작성하는 데 사용하는 파일 확장자가 하나뿐이며, 함수 정의를 사용하여 셰이더 함수를 정의하면 됌

### triangle.metal

```cpp
// C++14
#include <metal_stdlib>
using namespace metal;

vertex float4
vertexShader(uint vertexID [[vertex_id]],
             constant simd::float3* vertexPositions)
{
    float4 vertexOutPositions = float4(vertexPositions[vertexID][0],
                                       vertexPositions[vertexID][1],
                                       vertexPositions[vertexID][2],
                                       1.0f);
    return vertexOutPositions;
}

fragment float4 fragmentShader(float4 vertexOutPositions [[stage_in]]) {
    return float4(182.0f/255.0f, 240.0f/255.0f, 228.0f/255.0f, 1.0f);
}
```

1. vertexShader

   > 현재 정점의 위치를 받아서 해당 위치를 반환하는 메서드

   ```cpp
   vertex float4 vertexShader(uint vertexID [[vertex_id]], constant simd::float3* vertexPositions)
   ```

   정점 셰이더 함수를 정의, vertex 키워드는 이 함수가 정점 셰이더임을 나타냄
   <br/>

   vertexID 매개변수는 현재 정점의 인덱스
   <br/>

   vertexPositions 매개변수는 정점 위치 배열을 나타냄
   <br/>

2. fragmentShader

   > 고정된 색상을 반환하여 프래그먼트를 채색함

   ```cpp
   fragment float4 fragmentShader(float4 vertexOutPositions [[stage_in]])
   ```

   fragment 키워드는 이 함수가 프래그먼트 셰이더
   <br/>

   vertexOutPositions 매개변수는 정점 셰이더에서 출력된 정점 위치를 받음
   <br/>

### mtl_engine.hpp

```cpp
CA::MetalDrawable* metalDrawable; // 1
MTL::Library* metalDefaultLibrary; // 2
MTL::CommandQueue* metalCommandQueue; // 3
MTL::CommandBuffer* metalCommandBuffer; // 4
MTL::RenderPipelineState* metalRenderPSO; // 5
MTL::Buffer* triangleVertexBuffer; // 6
```

1. metalDrawable: Metal drawable은 Metal 렌더링 컨텍스트에서 실제 그래픽을 렌더링하는 데 사용
   <br/>

2. metalDefaultLibrary: Metal 라이브러리는 셰이더 코드를 컴파일하고 로드하는 데 사용, 정점 셰이더와 프래그먼트 셰이더를 프로그램에 로드하여 사용할 수 있는 것
   <br/>

3. metalCommandQueue: Metal 커맨드 큐는 GPU에 명령을 전달하고 실행하는 데 사용, 이를 통해 렌더링 명령을 GPU에 전송하여 그래픽을 렌더링이 가능
   <br/>

4. metalCommandBuffer: Metal 커맨드 버퍼는 GPU에 전송할 명령들의 모음을 나타내며 커맨드 버퍼에 그리기 명령을 추가하여 실제로 그래픽을 렌더링할 수 있음
   <br/>

5. metalRenderPSO: Metal 렌더링 파이프라인 상태는 그래픽 파이프라인의 상태를 나타내며, 렌더링 명령을 실행하는 데 사용, 그래픽 파이프라인의 상태를 설정하고 그래픽을 렌더링이 가능
   <br/>

6. triangleVertexBuffer: 정점 버퍼는 그리기 작업에 사용되는 정점 데이터를 저장하는 데 사용, 삼각형의 정점 위치 등의 데이터를 GPU에 전달하여 렌더링이 가능

### mtl_engine.mm

1. createTriangle()

   > 삼각형을 정의하고 GPU로 복사하는 함수

   ```cpp
   void MTLEngine::createTriangle() {
       simd::float3 triangleVertices[] = {
           {-0.5f, -0.5f, 0.0f},
           { 0.5f, -0.5f, 0.0f},
           { 0.0f,  0.5f, 0.0f}
    };

    triangleVertexBuffer = metalDevice->newBuffer(&triangleVertices,
                                                  sizeof(triangleVertices),
                                                  MTL::ResourceStorageModeShared);
   }
   ```

   - simd::float3 벡터 타입을 사용하여 삼각형의 세 꼭지점을 정의
     <br/>
   - simd은 Apple의 <simd/simd.h> 라이브러리에서 제공되는 벡터 타입
     <br/>
   - 그런 다음 Metal 장치에게 Metal 버퍼를 생성하도록 요청하여 삼각형의 정점 데이터를 GPU로 복사
     <br/>
   - Metal 버퍼 객체는 데이터를 저장하기 위해 사용되며, 이 경우 삼각형의 정점 위치 데이터를 저장
     <br/>

   - MTL::ResourceStorageModeShared를 사용하여 CPU 및 GPU 모두에서 이 데이터에 액세스 가능
     <br/>

2. createDefaultLibrary()

   > Metal의 기본 라이브러리를 생성

   ```cpp
   void MTLEngine::createDefaultLibrary() {
       metalDefaultLibrary = metalDevice->newDefaultLibrary();

       if(!metalDefaultLibrary) {
           std::cerr << "Failed to load default library.";
           std::exit(-1);
       }
   }
   ```

   - Metal은 Xcode 프로젝트 내의 모든 Metal 소스 파일을 하나의 기본 라이브러리로 컴파일을 함
     <br/>

3. createCommandQueue()

   > 이 함수는 Metal 커맨드 큐를 생성

   ```cpp
   void MTLEngine::createCommandQueue() {
       metalCommandQueue = metalDevice->newCommandQueue();
   }
   ```

   - Metal 커맨드 큐는 GPU에 명령을 전달하고 실행하는 데 사용
     <br/>

### Metal Flow

![플로우](https://metaltutorial.com/images/metalFlow.png)
위 이미지에서 철로 역할을 하는 "Command Queue"를 만들어야함

여러 철도 차량 또는 "Command Buffers"가 이러한 트랙에서 동시에 실행이 가능

명령 버퍼는 삼각형 그리기와 같이 GPU에 지시하는 개별 "Commands"을 저장

즉 명령은 이전에 논의한 것처럼 셰이더라는 프로그램 내에서 "Shader 코드"를 사용하여 GPU에서 실행 되는 것

### Render Pipeline

> GPU가 정점 및 프래그먼트 데이터를 처리하여 최종 출력 이미지를 생성하는 방법을 지정
> 렌더 파이프라인은 한 번 생성 및 구성한 후에는 비슷한 그래픽 객체를 반복적으로 렌더링하는 데 사용 됌

1. createRenderPipeline()

   > Metal 렌더 파이프라인을 생성하는 역할

   ```cpp
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
   ```

   - Metal의 default 라이브러리에서 정점 및 프래그먼트 셰이더 함수를 가져와서 렌더 파이프라인 디스크립터를 생성
     <br/>
   - 이 Descriptor는 렌더 패스 중에 사용할 설정을 구성하는 데 사용
     <br/>

   - 이름(Label), 정점 함수, 프래그먼트 함수를 설정하고, 출력 이미지의 픽셀 형식을 설정
     <br/>
   - metalDevice를 사용하여 렌더 파이프라인 상태 객체를 생성
     <br/>
   - 생성된 렌더 파이프라인 상태 객체는 렌더링 명령을 인코딩하여 GPU로 전송하여 개체를 렌더링하는 데 사용 되는 것
     <br/>
   - 함수가 종료되면 렌더 파이프라인 디스크립터 객체를 해제
     <br/>

2. sendRenderCommand()

   > 렌더링 명령을 GPU로 전송하는 역할

   ```cpp
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
   ```

   - metalCommandQueue에서 새로운 command buffer를 생성
     <br/>
   - MTL::RenderPassDescriptor 객체를 생성하여 렌더 패스 설정을 초기화, 렌더 패스는 렌더링 작업의 범위와 목표를 정의
     <br/>

   - 렌더 패스에 대한 색상 첨부물 디스크립터를 가져온 후, 텍스처를 설정하고, 초기화 및 저장 작업을 지정
     <br/>

   - clear 작업으로 현재 색상을 지우고, 지정된 색으로 버퍼를 초기화
     <br/>
   - metalCommandBuffer를 사용하여 렌더링 명령 인코더를 생성
     <br/>

   - 렌더링 명령 인코더는 렌더링 명령을 인코딩하여 GPU로 보내는 역할을 함
     <br/>

   - encodeRenderCommand() 함수를 호출하여 실제로 렌더링 명령을 인코딩 이후에는 endEncoding()을 호출하여 렌더링 명령 인코더를 종료
     <br/>

   - metalCommandBuffer를 사용하여 Drawable을 프레젠테이션하고, 커밋하여 GPU에 전달
     <br/>

   - waitUntilCompleted()를 호출하여 렌더링 명령이 완료될 때까지 대기
     <br/>

   - 사용이 끝난 renderPassDescriptor 객체를 해제
     <br/>

3. encodeRenderCommand

   > 렌더 커맨드 인코더를 사용하여 렌더링 커맨드를 인코딩하는 역할

   ```cpp
   void MTLEngine::encodeRenderCommand(MTL::RenderCommandEncoder* renderCommandEncoder) {
       renderCommandEncoder->setRenderPipelineState(metalRenderPSO);
       renderCommandEncoder->setVertexBuffer(triangleVertexBuffer, 0, 0);
       MTL::PrimitiveType typeTriangle = MTL::PrimitiveTypeTriangle;
       NS::UInteger vertexStart = 0;
       NS::UInteger vertexCount = 3;
       renderCommandEncoder->drawPrimitives(typeTriangle, vertexStart, vertexCount);
   }
   ```

   - setRenderPipelineState()를 사용하여 현재의 렌더 파이프라인 상태를 설정 -> 이렇게 함으로써 렌더링 프로세스가 사용할 렌더 파이프라인을 지정
     <br/>

   - setVertexBuffer()를 사용하여 현재의 버텍스 버퍼를 설정 -> 버텍스 데이터를 GPU로 전달하는 데 사용
     <br/>

   - triangleVertexBuffer 변수가 현재 사용 중인 버텍스 버퍼를 나타냄
     <br/>

   - drawPrimitives()를 사용하여 그리기 명령을 설정 -> 렌더링할 기본 도형의 유형, 시작 인덱스 및 버텍스 개수를 지정
     <br/>

   - 삼각형을 그리기 위해 사용되며, vertexStart 및 vertexCount 매개변수를 사용하여 삼각형을 그리는 데 필요한 시작 인덱스와 버텍스의 개수를 지정
     <br/>

<img width="798" alt="스크린샷 2024-05-02 오후 3 00 46" src="https://github.com/BOLTB0X/Metal-API/assets/83914919/b648b870-b5a5-4202-b3b3-a75717db2c52">

## 원본

[Rendering a Triangle to the Screen](https://metaltutorial.com/Lesson%201%3A%20Hello%20Metal/2.%20Hello%20Triangle/#the-metal-flow)
