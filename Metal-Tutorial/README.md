# Lesson 1 : Hello Window (Setting up our Window)

> 그래픽 애플리케이션의 창이 Window

<br/>

- _Metal_ 자체는 윈도우 생성 및 관리 기능 제공 X
  <br/>

- *Metal*이 그릴 수 있는 **Window** 를 생성하고 화면에 표시하는 과정을 처리해 주기 위해 **GLFW** 또한 이용
  <br/>

## GLFW

> 크로스 플랫폼 OpenGL/Metal/Vulkan 등 그래픽 API를 사용하는 응용 프로그램에서 Window 관리와 event 처리를 쉽게 할 수 있도록 돕는 라이브러리

- 그래픽 API와 독립적으로 동작하며, 윈도우 생성, 키보드/마우스 입력 관리, 컨텍스트 설정 등을 지원
  <br/>

- GLFW의 대안

  - **Cocoa**: macOS 네이티브 프레임워크로, 직접 윈도우를 생성하고 Metal과 연동
    <br/>

  - **MetalKit**: macOS 전용, Metal과 더 밀접하게 연동된 윈도우 생성 및 렌더링 관리 기능을 제공
    <br/>

## mtl_engine.hpp

> In mtl_engine.hpp, we're first going to include the necessary headers for GLFW and metal-cpp

```cpp
#pragma once

#define GLFW_INCLUDE_NONE  // 1 - 1
#import <GLFW/glfw3.h> // 2 - 1
#define GLFW_EXPOSE_NATIVE_COCOA // 1 - 2
#import <GLFW/glfw3native.h> // 2 - 2

// 3
#include <Metal/Metal.hpp>
#include <Metal/Metal.h>
#include <QuartzCore/CAMetalLayer.hpp>
#include <QuartzCore/CAMetalLayer.h>
#include <QuartzCore/QuartzCore.hpp>

// 4
// MARK: - MTLEngine
class MTLEngine {
public:
    void init();
    void run();
    void cleanup();

private:
    void initDevice();
    void initWindow();

    MTL::Device* metalDevice;
    GLFWwindow* glfwWindow;
    NSWindow* metalWindow;
    CAMetalLayer* metalLayer;
};
```

1.  `#define`

    1. GLFW 라이브러리의 내용을 포함하기 전에 `GLFW_INCLUDE_NONE` 매크로를 정의 -> GLFW의 모든 내용을 포함하지 않음
    2. GLFW에서 Cocoa 네이티브 API를 노출
       <br/>

2.  `#import`

    1. GLFW 라이브러리의 기능을 사용하기 위해 해당 헤더 파일을 포함
    2. GLFW 네이티브 플랫폼의 특정 기능을 사용하기 위한 헤더 파일을 포함
       <br/>

3.  `#include`

    - Metal 그래픽 API , **QuartzCore** 내 **CAMetalLayer** 클래스 등 사용을 위해 header 파일 포함

    <br/>

4.  `class MTLEngine`

    - 클래스는 그래픽을 렌더링하기 위한 *Window*을 설정하고 관리
    - `init()`: 그래픽 렌더링 엔진을 초기화
    - `run()`

      - 그래픽 렌더링 루프를 실행
      - 그래픽 렌더링하고 사용자 입력을 처리하는 데 필요한 작업을 반복적으로 수행
        <br/>

    - `cleanup()`

      - 그래픽 렌더링 엔진을 정리하고 종료
      - 할당된 리소스를 해제하고 *Window*를 `close` 하는 등의 정리 작업을 수행
        <br/>

    - `MTL::Device\* metalDevice`

      - Metal API를 사용하여 그래픽 처리를 수행하는 데 필요한 장치
      - GPU에 대한 액세스를 제공하고 그래픽 및 계산 작업을 수행할 수 있는 인터페이스를 제공
        <br/>

    - `GLFWwindow\* glfwWindow`

      - GLFW 라이브러리를 사용하여 생성된 _Window_
      - 그래픽을 표시하고 사용자 입력을 처리하는 데 사용
        <br/>

    - `NSWindow\* metalWindow`

      - Metal에서 사용되는 특정한 Window 객체
      - Metal API와 함께 사용되며, 일반적으로 GLFW 라이브러리를 통해 생성된 Window와는 별도로 사용
        <br/>

    - `CAMetalLayer\* metalLayer`
      - Metal 프레임워크에서 사용되는 특정한 레이어 객체
      - Metal API와 함께 사용되며, 일반적으로 그래픽을 렌더링하기 위한 뷰의 레이어로 사용
      - Metal 그래픽 API와 함께 사용하여 그래픽을 표시하고 관리하는 데 필요한 인터페이스를 제공
        <br/>

## mtl_engine.mm

```cpp
#include "mtl_engine.hpp"

void MTLEngine::init() { // 1
    initDevice();
    initWindow();
}

void MTLEngine::run() {
    while (!glfwWindowShouldClose(glfwWindow)) {
        glfwPollEvents();
    }
}

void MTLEngine::cleanup() { // 4
    glfwTerminate();
    metalDevice->release();
}

void MTLEngine::initDevice() { // 2
    metalDevice = MTL::CreateSystemDefaultDevice();
}

void MTLEngine::initWindow() { // 3
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
```

<br/>

1. `MTLEngine::init()`: 객체를 초기화하는 데 사용

   ```cpp
   void MTLEngine::init() {
       initDevice();
       initWindow();
   }
   ```

   - 함수 내부에서는 `initDevice()`와 `initWindow()` 메서드를 호출
     <br/>

   - `initDevice()`와 `initWindow()` 메서드는 **Metal 디바이스**와 **GLFW Window**를 설정하는 데 사용
     <br/>

   - `MTLEngine::init()` 함수는 Metal API와 GLFW를 초기화하고 필요한 Window를 생성하는 역할
     <br/>

<br/>

2. `initDevice()`: Metal 디바이스를 초기화하는 역할

   ```cpp
   // initDevice
   void MTLEngine::initDevice() {
       metalDevice =
       MTL::CreateSystemDefaultDevice();
   }
   ```

   - `metal-cpp` 라이브러리를 사용하여 Metal 디바이스 핸들러를 생성, 이 핸들러는 GPU에 대한 액세스를 제공
     <br/>

   - Metal 디바이스는 여러 가지 작업에 사용

     1. **Shader Library(셰이더 라이브러리) 생성**
        셰이더 코드를 컴파일하고 로드하여 GPU에서 실행할 수 있는 형식으로 변환하는 데 사용
        <br/>
     2. **버퍼 및 텍스처 리소스 생성 및 CPU와 GPU 간 data 전송**

        - 메모리 버퍼나 이미지 텍스처와 같은 GPU 리소스를 생성하고 이를 CPU와 GPU 간에 데이터를 전송하는 데 사용
          <br/>

     3. **렌더링 및 컴퓨트 파이프라인 생성**
        그래픽 렌더링이나 병렬 계산을 위한 파이프라인을 생성하는 데 사용
        <br/>

<br/>

3. `initWindow()`: Window를 초기화

   ```cpp
   void MTLEngine::initWindow() {
       glfwInit(); // 1
       glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
       glfwWindow = glfwCreateWindow(800, 600, "Metal Engine", NULL, NULL); // 2

       if (!glfwWindow) {
           glfwTerminate();
           exit(EXIT_FAILURE);
       }

       metalWindow = glfwGetCocoaWindow(glfwWindow); // 3
       metalLayer = [CAMetalLayer layer]; // 4
       metalLayer.device = (__bridge id<MTLDevice>)metalDevice; // 5
       metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm; // 6
       metalWindow.contentView.layer = metalLayer; // 7
       metalWindow.contentView.wantsLayer = YES; // 8
   }
   ```

   1. `glfwInit()`, `glfwWindowHint`

      - GLFW 라이브러리를 초기화 -> `glfwInit()` 호출
        <br/>
      - 일반적으로 OpenGL을 사용하여 그래픽을 렌더링하려면 먼저 OpenGL 그래픽 컨텍스트를 생성해야 하지만 **Metal**을 사용하는 경우 OpenGL 그래픽 컨텍스트가 필요 X
        <br/>
      - GLFW 라이브러리를 사용하여 *Window*를 생성할 때 원하는 옵션을 설정하는 데 사용하는게 -> `glfwWindowHint`
        <br/>

      - OpenGL 관련 옵션을 비활성화하기 위해 `glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API)` 호출
        <br/>

   2. `glfwWindow = glfwCreateWindow(800, 600, "Metal Engine", NULL, NULL)`

      - GLFW를 사용하여 Window를 생성
        <br/>

      - 너비가 800이고 높이가 600이며 이름이 `"Metal Engine"`인 Window 생성
        <br/>

      - Window 생성에 실패한 경우에는 GLFW를 정리하고`(EXIT_FAILURE)` 프로그램을 종료
        <br/>

   3. `metalWindow = glfwGetCocoaWindow(glfwWindow)`

      - `glfwGetCocoaWindow()`: GLFW Window의 **Cocoa 윈도우 핸들** 반환
        <br/>
      - 이 핸들은 macOS에서 실제 Window을 관리하는 Cocoa 프레임워크의 객체
        <br/>
      - Metal API를 사용하는 동안 Metal을 Cocoa Window에 연결하기 위해 이 핸들을 사용
        <br/>

   4. `metalLayer = [CAMetalLayer layer]`

      - `[CAMetalLayer layer]`: **Objective-C**에서 Metal 레이어를 생성하는 방법
        <br/>
      - CAMetalLayer는 Metal과 Cocoa 프레임워크 간의 인터페이스 역할을 하고 이 레이어를 통해 Metal 그래픽 컨텍스트를 생성하고 그리기 작업을 수행할 수 있음
        <br/>

   5. `metalLayer.device = (\_\_bridge id<MTLDevice>)metalDevice`

      - `metalLayer.device` 속성에는 Metal 디바이스가 설정
        <br/>

      - Metal 디바이스는 GPU에 대한 접근을 제공하며, Metal API를 사용하여 그래픽 및 컴퓨팅 작업을 수행할 때 필요 함
        <br/>

      - 이 코드는 **C++**에서 **Objective-C**로 객체를 변환하는 데 사용되는 `\_\_bridge` 키워드를 사용하여 **Metal** 디바이스를 **Objective-C** 객체로 변환하도록 함
        <br/>

   6. `metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm`

      - `metalLayer.pixelFormat`: Metal 레이어의 픽셀 형식을 설정
        <br/>
      - BGRA8Unorm 형식, 32비트의 픽셀당 4개의 구성 요소를 가지며, 각 구성 요소는 0에서 1 사이의 값으로 표현
        <br/>

   7. `metalWindow.contentView.layer = metalLayer`

      - Cocoa 창의 콘텐츠 뷰 레이어로 설정
        <br/>
      - Metal 레이어가 실제로 창에 렌더링되는 콘텐츠를 표시하도록 설정
        <br/>

   8. `metalWindow.contentView.wantsLayer = YES`
      - Cocoa Window의 콘텐츠 View가 레이어를 사용하도록 설정
        <br/>

<br/>

4. `MTLEngine::run()`: 프로그램의 메인 루프를 설정하는 함수

   ```cpp
   void MTLEngine::run() {
       while (!glfwWindowShouldClose(glfwWindow)) {
           glfwPollEvents(); // 키보드 입력을 처리하는 데 사용될 것
       }
   }
   ```

   - Window의 업데이트를 처리하고 화면에 그리는 작업을 수행
     <br/>

   - 이 루프는 `glfwWindowShouldClose(glfwWindow)` 함수가 true를 반환할 때까지 계속 실행 됌
     <br/>

   - 현재는 창 상단의 빨간 닫기 버튼을 클릭할 때만 발생
     <br/>

<br/>

5. `cleanup()`: 종료 시 초기화 및 자원 할당 해제를 처리

   ```cpp
   void MTLEngine::cleanup() {
       glfwTerminate();
   }
   ```

   - `glfwTerminate()` 함수는 GLFW 라이브러리를 정리하고 종료하는 역할

<br/>

## main.mm

```cpp
#include "mtl_engine.hpp"

int main() {

    MTLEngine engine;
    engine.init();
    engine.run();
    engine.cleanup();

    return 0;
}
```

<img width="799" alt="스크린샷 2024-05-02 오후 1 32 35" src="https://github.com/BOLTB0X/Metal-API/assets/83914919/92f3a93b-c5de-4de2-83dc-6f21c9a3390e">

## 원본

[Setting up our Window](https://metaltutorial.com/Lesson%201%3A%20Hello%20Metal/1.%20Hello%20Window/)
