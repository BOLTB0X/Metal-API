## METAl Tutorial

[img](https://github.com/dehesa/Metal/raw/master/docs/assets/Metal.svg)

> 정말 해보고 싶어 튜토리얼을 보고 진행해봄

Kodeco의 [Metal Tutorial: Getting Started](https://www.kodeco.com/7475-metal-tutorial-getting-started)을 보고 첫 걸음을 때 보려함
<br/>

**_이 튜토리얼에서는 Metal API를 사용하여 bare-bones app(간단한 삼각형 그리기)을 만드는 실습_**
<br/>

devices, command queues등과 같은 Metal에서 가장 중요한 일부 클래스를 배우기도 함
<br/>

## Metal 이란?

[img](https://developer.apple.com/assets/elements/icons/metal/metal-96x96_2x.png)

> Metal powers hardware-accelerated graphics on Apple platforms by providing a low-overhead API
> <br/>

Metal은 낮은 오버헤드 API를 제공하여 Apple 플랫폼에서 하드웨어 가속 그래픽을 지원
<br/>

Metal은 3D 그래픽 하드웨어와 상호 작용하기 위한 저수준 API라는 점에서 OpenGL ES와 유사
<br/>

차이점은 Metal은 크로스 플랫폼이 아니라는 것, 대신 OpenGL ES를 사용할 때보다 속도가 향상되고 오버헤드가 낮아 Apple 하드웨어에서 매우 효율적으로 작동하도록 설계되었음
<br/>

Metal을 사용하면 앱에서 GPU를 활용하여 복잡한 장면을 빠르게 렌더링하고 컴퓨팅 작업을 병렬로 실행 가능
<br/>

## Metal vs SpriteKit, SceneKit or Unity

[img](https://koenig-media.raywenderlich.com/uploads/2014/07/2_Boxes.png)
<br/>

Metal이 SpriteKit, SceneKit 또는 Unity와 같은 상위 수준 프레임워크와 어떻게 비교되는지 이해하는 것이 도움이 된다함
<br/>

Metal은 OpenGL ES와 유사한 저수준 3D 그래픽 API이지만 오버헤드가 낮아 성능이 향상 -> 이것은 GPU 위의 매우 얇은 레이어
<br/>

즉, 스프라이트 또는 3D 모델을 화면에 렌더링하는 것과 같은 거의 모든 작업을 수행하려면 이를 수행하기 위한 모든 코드를 작성해야 함
<br/>

트레이드 오프는 완전한 권한과 제어권을 갖는다는 것, 반대로 SpriteKit, SceneKit 및 Unity와 같은 상위 수준의 게임 프레임워크는 Metal 또는 OpenGL ES와 같은 하위 수준의 3D 그래픽 API 위에 구축
<br/>

스프라이트 또는 3D 모델을 화면에 렌더링하는 것과 같이 일반적으로 게임에서 작성하는 데 필요한 많은 상용구 코드를 제공
<br/>

## Metal을 배워야 하는 두 가지 좋은 이유

1. 하드웨어를 최대한 활용: Metal은 매우 낮은 수준에 있기 때문에 하드웨어를 최대한 활용하고 게임 작동 방식, 카메라 필터 등을 완전히 제어 가능
   <br/>

2. Metal은 3D 그래픽, 자신만의 게임 엔진 작성, 고급 게임 프레임워크 작동 방식
   <br/>

## 이 튜토리얼의 핵심

<img width="327" alt="스크린샷 2023-04-23 오후 9 38 56" src="https://user-images.githubusercontent.com/83914919/233840577-2c849f05-9b37-47ee-a36f-b05509d09b98.png">
<br/>

viewController swift파일과 metel파일을 순차적으로 작성함
<br/>

1. **_MTLDevice를 GPU에 대한 직접 연결과 Metal 개체(예: 명령 대기열, 버퍼 및 텍스처)를 생성 _**
   <br/>
   대부분은 한 번 초기화되고 앱 수명 동안 재사용되도록 설계 되어있음
   <br/>

```swift
var device: MTLDevice!
```

<br/>

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // 1) MTLCreateSystemDefaultDevice는 코드에서 사용해야 하는 기본 MTLDevice에 대한 참조를 반환하는 것
    device = MTLCreateSystemDefaultDevice()
}
```

<br/>

2. **_CAMetalLayer_**
   <br/>

   iOS에서 화면에 보이는 모든 것은 CALayer에 의해 지원받으므로 Metal로 화면에 무언가를 그리려면 CAMetalLayer라는 CALayer의 특수 하위 클래스를 사용해야함
   <br/>

3. **_Vertex Buffer_**
   Metal의 모든 것은 삼각형, 다른 앱에서 복잡한 3D 도형도 일련의 삼각형으로 분해
   <br/>

   정규화된 좌표계 즉, 기본적으로 (0, 0, 0.5)를 중심
   <br/>

   | ![image.png1](https://i.stack.imgur.com/NKcsk.png) | ![image.png2](https://i.stack.imgur.com/CE593.png) |
   | -------------------------------------------------- | -------------------------------------------------- |

   <br/>

   [img](https://koenig-media.raywenderlich.com/uploads/2014/07/4_vertices.jpg)
   <br/>

```swift
// 삼각형의 꼭지점
let vertexData: [Float] = [
   0.0,  1.0, 0.0,
  -1.0, -1.0, 0.0,
   1.0, -1.0, 0.0
]
```

<br/>

```swift
var vertexBuffer: MTLBuffer!
```

```swift
let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 꼭짓점 data size를 byte 단위로 가져와야한다함 그리고 vertexData 요소의 크기에 배열의 요소 수를 곱해야된다 함
vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 2 MTLDevice객체세어 makeBuffer를 호출하여 MTLBuffer를 초기화
```

<br/>

4. **_Vertex Shader_**
   <br/>

   생성한 꼭지점은 꼭지점 셰이더라고 하는 작은 프로그램의 입력이 된다함
   <br/>
   버텍스 쉐이더는 Metal Shading Language라고 하는 C++과 유사한 언어로 작성된 GPU에서 실행되는 작은 프로그램
   <br/>

   [img](https://koenig-media.raywenderlich.com/uploads/2014/07/5_matrix.jpg)
   <br/>

   **_정점 셰이더는 정점당 한 번 호출_**되며 위치와 같은 정점의 정보와 색상 또는 텍스처 좌표와 같은 기타 정보를 가져와 잠재적으로 수정된 위치 및 기타 데이터를 반환하는 것
   <br/>

   Shaders.metal
   <br/>

```cpp
#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex(
  const device packed_float3* vertex_array [[ buffer(0) ]],
  unsigned int vid [[ vertex_id ]]) {
  return float4(vertex_array[vid], 1.0); //  float4로 변환함 여기서 최종 값은 1.0, 간단히 말해 3D 수학에 필요
}
```

5. Fragment Shader
   vertex shader를 만들었으면, Metal은 화면의 각 fragment 대해 다른 shader를 호출해야함
   <br/>
   [img](https://koenig-media.raywenderlich.com/uploads/2014/07/6_points.jpg)
   <br/>
   텍스 셰이더가 완료된 후 Metal은 화면의 각 조각(픽셀 생각)
   <br/>
   함수는 (최소한) 조각의 최종 색상을 반환
   <br/>

```cpp
fragment half4 basic_fragment() {
  return half4(1.0);     // half4는 4성분 색상 값이라고 생각하면 되고 결국 흰색이 반환
}
```

6. Render Pipeline
   이제 버텍스 및 프래그먼트 셰이더를 만들었으므로 다른 구성 데이터와 함께 렌더 파이프라인이라는 특수 개체에 결합해야 함
   <br/>

   ```swift
   var pipelineState: MTLRenderPipelineState!
   ```

   <br/>

   Metal의 멋진 점? 중 하나는 셰이더가 사전 컴파일되고 렌더 파이프라인 구성이 처음 설정한 후 컴파일된다는 것
   <br/>

7. MTLCommandQueue
   MTLCommandQueue는 GPU에서 실행 할 명령 버퍼를 구성하는 대기열(queue)
   <br/>

   요걸 또 넣어줘야함(지금 내가 삼각형 하나 그릴려하는 게 맞나 싶음)
   <br/>

   ```swift
   var commandQueue: MTLCommandQueue! // viewController에 넣어줌
   ```

      <br/>

   ```swift
   commandQueue = device.makeCommandQueue() // viewDidLoad() 에 넣어줌
   ```

   <br/>

**_8번부터 진짜 삼각형 그리기(이전 까지 셋업..?)_**
<br/>

## 진짜 삼각형 그리기

장치 화면이 새로 고쳐질 때마다 화면을 다시 그리는 방법이 필요하다함 -> CADisplayLink는 디스플레이 재생 빈도에 동기화된 타이머
<br/>

```swift
var timer: CADisplayLink!
```

<br/>

```swift
timer = CADisplayLink(target: self, selector: #selector(gameloop))
timer.add(to: RunLoop.main, forMode: .default)
```

<br/>

여기서 gameloop()는 매 프레임마다 단순히 render()를 호출
<br/>

```swift
@objc func gameloop() {
    autoreleasepool {
      self.render()
    }
}
```

이제 순차적으로
<br/>
Render Pass Descriptor: 렌더링 할 texture, clear color, 기타 configuration을 구성하는 객체
<br/>

Command Buffer: 이 프레임에 대해 실행하려는 렌더링 명령 목록이라고 생각, 명령 버퍼를 커밋하기 전까지는 실제로 아무 일도 일어나지 X

<br/>

```swift
let commandBuffer = commandQueue.makeCommandBuffer()!
```

<br/>

Render Command Encoder: 렌더링 명령을 만들려면 렌더링 명령 인코더라는 도우미 개체를 사용해야함
<br/>

```swift
drawPrimitives(type:vertexStart:vertexCount:instanceCount:)
```

호출하는 코드인데 여기에서 정점 버퍼를 기반으로 삼각형 집합을 그리도록 GPU에 지시
<br/>

Commit your Command Buffer: 커밋하여 작업을 GPU
<br/>

```swift
commandBuffer.present(drawable)
commandBuffer.commit()
```

### 전체 render 코드

아래 주석 참조

```swift
// MARK: 9) Creating a Render Pass Descriptor
// 9) MTLRenderPassDescriptor를 생성하는 것
// 9) MTLRenderPassDescriptor는 렌더링되는 텍스처, 명확한 색상 및 약간의 기타 구성을 구성하는 개체
func render() {
    // 9) 생성한 Metal 레이어에서 nextDrawable()을 호출하여 화면에 무언가를 표시하기 위해 그려야 하는 텍스처를 반환
    guard let drawable = metalLayer?.nextDrawable() else { return }
    // 9) 다음으로 해당 텍스처를 사용하도록 렌더 패스 설명자를 구성
    // 9) 불러오기 동작을 Clear로 설정합니다. 즉, “그리기 전에 텍스처를 선명한 색상으로 설정”한다는 의미이며,
    // Clear 색상은 사이트에서 사용하는 녹색 색상으로 설정
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .clear
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
      red: 0.0,
      green: 104.0/255.0,
      blue: 55.0/255.0,
      alpha: 1.0)

    // MARK: 10) Creating a Command Buffer
    // 10) 색상과 선을 그렸으면 명령 버퍼를 만들어야 함
    // 10) 버퍼를 이 프레임에 대해 실행하려는 렌더링 명령 목록이라고 생각
    // 10) 명령 버퍼를 커밋하기 전까지는 실제로 아무 일도 일어나지 X
    // 10) 즉 세밀하게 제어 가능

    // 10) 이 코드를 추가하는 것이 명령 버퍼를 생성하는 것
    let commandBuffer = commandQueue.makeCommandBuffer()!

    // MARK: 11) Creating a Render Command Encoder
    // 11) 명령 버퍼에는 하나 이상의 렌더링 명령이 포함되어야 함
    // 11) 렌더링 명령을 만들려면 렌더링 명령 인코더라는 도우미 개체를 사용
    // 11) 여기에서 명령 인코더를 생성하고 이전에 생성한 파이프라인 및 정점 버퍼를 지정
    let renderEncoder = commandBuffer
      .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder
      .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1) // 11-1) 가장 중요한 부분
    // 11-1) 여기에서 정점 버퍼를 기반으로 삼각형 집합을 그리도록 GPU에 지시
    // 11-1) 메서드 인수는 각 삼각형이 꼭짓점 버퍼 내부의 인덱스 0에서 시작하는 세 개의 꼭짓점으로 구성되고
    // 11-1) 총 하나의 삼각형이 있음을 Metal에게 전달
    renderEncoder.endEncoding() // 11-1) 완료되면 endEncoding()을 호출하기만 하면 됨

    // MARK: 12) Committing Your Command Buffer
    // 12) 그리기가 완료되는 즉시 GPU가 새 텍스처를 제공하는지 확인하려면 첫 번째 줄이 필요
    // 12) 그런 다음 트랜잭션을 커밋하여 작업을 GPU로 보냄
    commandBuffer.present(drawable)

    // 12) 완료(command buffer를 커밋할 때 까지는 실제로 아무일도 일어나지 X)
    commandBuffer.commit()
  }

  // 8) 여기서 gameloop()는 매 프레임마다 단순히 render()를 호출
  @objc func gameloop() {
    autoreleasepool {
      self.render()
    }
  }
```
