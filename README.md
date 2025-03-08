# Metal-API

<p align="center">

![어어어어어어어어어어어어거아아아아아아아악](https://i1.ruliweb.net/ori/21/04/20/178eac3b4005347ad.gif)

</p>

## Metal

<details>
<summary> Metal 이란?</summary>

> Render advanced 3D graphics and compute data in parallel with graphics processors.

<br/>

<p align="center">
   <img src="https://developer.apple.com/assets/elements/icons/metal/metal-96x96_2x.png" alt="Example Image" width="30%">
</p>

<br/>

- **Metal API**는 **Apple**에서 제공하는 그래픽 및 연산 작업을 위한 저수준 API
  <br/>

  <p align="center">
     <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EB%B9%84%EA%B5%90.png?raw=true" alt="Example Image" width="50%">
  </p>
  <br/>

  1. **저수준 API(Low-Level API)**

     - *Metal*은 HW와의 소통을 직접적으로 처리할 수 있는 API
       <br/>
     - _OpenGL_ 같은 고수준 API(High-Level API)보다 더 세부적인 작업을 제어 가능(ex. GPU 메모리 관리, 렌더링 파이프라인 설정 등을 세밀하게 조작 가능)
       <br/>

  2. **HW 성능 극대화**

     - CPU와 GPU의 성능을 최대한으로 활용할 수 있게 설계되었음
       <br/>

     - 불필요한 오버헤드(비효율적인 처리)를 줄이고, 게임, vr 등 작업을 최적화하여 하드웨어의 최대 성능을 끌어낼 수 있음
       <br/>

  <p align="center">     
    <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/ios.png?raw=true" alt="Example Image" width="50%">
  </p>
  <br/>

- *Vulkan*과 비슷한 역할을 하지만 **iOS**, **macOS** 등 Apple 생태계에 최적화되어 있음
  <br/>

- 3D 그래픽 렌더링뿐 아니라, *GPU*에서 실행할 **병렬 연산** 작업도 지원, 게임의 작동 방식을 제어 가능
  <br/>

</details>

## Intro

<details>
<summary>기본 구성</summary>

<br/>

> Metal API를 이해하려면 세 가지 기본 개념이 필요

1. **Metal Device** (`MTLDevice`)

   - Metal에서 모든 작업의 출발점은 `MTLDevice`

   - 객체는 GPU를 추상화한 것으로, GPU 자원을 관리하고 작업을 실행
   - GPU에 직접 연결하는 인터페이스
     <br/>

2. **Metal Command Queue** (`MTLCommandQueue`)

   - GPU에게 명령을 전달하는 큐
   - 명령이 실행되는 순서를 제어 가능
     <br/>

3. **Metal Buffers** (`MTLBuffer`)

   - GPU와 데이터를 공유하기 위한 메모리
   <br/>
   </details>

<details>

<summary>렌더링 과정</summary>
<br/>

1. **Metal 디바이스, layer 설정, vertex, shader 코딩**

   - `MTLDevice` (**Metal 디바이스**): GPU와 연결해 작업을 수행할 객체를 설정
   - `CAMetalLayer`: 화면 출력용 Metal 레이어를 설정해 렌더링 결과를 디스플레이
   - **vertex data**: 그릴 도형(예: 삼각형, 사각형 등)의 좌표 정보를 정의
   - **shader**: 버텍스(기하학적 변환)와 프래그먼트(픽셀 색상 계산)를 처리하는 GPU 코드 작성
     <br/>

2. **파이프라인(Pipeline) 설정**

   - `MTLRenderPipelineState` **렌더링 파이프라인**:
     - 버텍스 셰이더와 프래그먼트 셰이더를 연결하고 렌더링 규칙을 설정
     - 어떤 그래픽 출력을 원하는지 GPU가 이해할수 있도록 정의
       <br/>
   - **Pipeline**은 커맨드 큐가 실행할 때 GPU의 처리 흐름을 결정
     <br/>

3. **커맨드 큐 & 입력 버퍼**

- `MTLBuffer` (**입력 버퍼**): CPU에서 GPU로 데이터를 전달하는 메모리 공간

  - 예 : _버텍스 데이터_ , _색상 정보_
    <br/>

- `MTLCommandQueue` (**커맨드 큐**):
  - 커맨드 버퍼 안에 명령어를 작성하고 GPU에서 실행
  - 예 : _drawPrimitives로 삼각형 등 기본 도형을 그리기_ , _입력 버퍼와 파이프라인을 연결해 GPU 작업 실행_
    <br/>

</details>

## Study

- [Space](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/StudyMd/Space.md)

  - [NDC](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/StudyMd/NDC.md)

- [Attribute Qualifier](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/StudyMd/Qualifier.md)

## Tutorial

~~[OpenGL 튜토리얼](-->) metal로 실습~~

### Getting started

<details>
<summary> Hello Triangle</summary>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EC%83%89%EB%B3%80%EA%B2%BD.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EC%82%BC%EA%B0%81%ED%98%95%202%EA%B0%9C.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Triangle 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Triangle 2
      </p>
      </td>
    </tr>
  </table>
</p>

- [Renderer 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Ex01-Triangle/Ex01-Triangle/01-02/Render2ViewController.swift)
- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Ex01-Triangle/Ex01-Triangle/Metal-API/Shaders.metal)

</details>

<details>
<summary>Shaders</summary>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Ex02.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Ex02-01.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Ex02-02.png?raw=true" 
             alt="image 3" 
             style="width:200px; height:400px; object-fit:contain;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        Triangle
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        Upside down
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        Right side
      </p>
      </td>
    </tr>
  </table>
</p>

- [Renderer 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Ex02-Shaders/Ex02-Shaders/RendererViewController.swift)
- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Ex02-Shaders/Ex02-Shaders/Shaders.metal)

</details>

<details>
<summary>Textures</summary>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%ED%85%8D%EC%8A%A4%EC%B2%98%20%EC%82%BC%EA%B0%81%ED%98%95.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%ED%85%8D%EC%8A%A4%EC%B3%90%20%EC%82%AC%EA%B0%81%ED%98%95.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Triangle
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Rectangle
      </p>
      </td>
    </tr>
  </table>
</p>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%ED%85%8D%EC%8A%A4%EC%B2%98-mix.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%ED%85%8D%EC%8A%A4%EC%B3%90-%ED%85%8D%EC%8A%A4%EC%B3%90mix1.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%ED%85%8D%EC%8A%A4%EC%B3%90-%ED%85%8D%EC%8A%A4%EC%B3%90mix2.png?raw=true" 
             alt="image 3" 
             style="width:200px; height:400px; object-fit:contain;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        Mixed
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        Mix 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        Mix 2
      </p>
      </td>
    </tr>
  </table>
</p>

- [Renderer 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Ex03-Textures/Ex03-Textures/RendererViewController.swift)
- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Ex03-Textures/Ex03-Textures/Shaders.metal)

</details>

<details>
<summary> Transformations</summary>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%ED%9A%8C%EC%A0%84.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Transformations
      </p>
      </td>
    </tr>
  </table>
</p>

- [Renderer 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/GettingStarted/GettingStarted/RendererViewController.swift)
- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/GettingStarted/GettingStarted/Shaders.metal)

</details>

<details>
<summary> Coordinate Systems</summary>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/3d-%EB%A0%8C%EB%8D%94%EB%A7%81-%ED%96%89%EB%A0%AC.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/3d-%EB%A0%8C%EB%8D%94%EB%A7%81-1.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/3d-dpeth%EC%A0%81%EC%9A%A9.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Coordinate Systems
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Depth X
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Depth O
      </p>
      </td>
    </tr>
  </table>
</p>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/3DCube_depth%ED%9A%8C%EC%A0%84.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/3d%ED%81%90%EB%B8%8C-%EC%97%AC%EB%9F%AC%EA%B0%9C.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      3D Rotate 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      3D Rotate 2
      </p>
      </td>
    </tr>
  </table>
</p>

- [Renderer Depth 추가 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/GettingStarted/GettingStarted/RendererViewController%2BDepth.swift)
- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/GettingStarted/GettingStarted/Shaders.metal)

</details>

<details>
<summary> Camera</summary>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EC%B9%B4%EB%A9%94%EB%9D%BC%20%ED%9A%8C%EC%A0%841.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EC%B9%B4%EB%A9%94%EB%9D%BC--.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Camera Rotate
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Gesture Rotate
      </p>
      </td>
    </tr>
  </table>
</p>

- [Renderer 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/GettingStarted/GettingStarted/RendererViewController.swift)

  <details>
  <summary> 큐브 여러개 build 코드(Swift) </summary>

  ```swift
  let cubePositions: [simd_float3] = [
        simd_float3(-1.0, 1.0, -6.0),  // 상좌
        simd_float3(0.0, 1.0, 2.5),   // 상중앙
        simd_float3(1.0, 1.0, -9.0),   // 상우
        simd_float3(-1.0, 0.5, -8.5),  // 중좌
        simd_float3(1.0, 0.5, -2.8),   // 중우
        simd_float3(0.0, 0.0, 0.0),   // 중앙
        simd_float3(-1.0, -0.5, 3.5), // 하좌
        simd_float3(0.0, -0.5, -3.8),  // 하중앙
        simd_float3(1.0, -0.5, -7.0),  // 하우
        simd_float3(0.5, 0.0, -9.2)    // 중앙 우측
  ]

  for i in cubePositions.indices {
        var modelMatrix = matrix_identity_float4x4
        translate(matrix: &modelMatrix, position: cubePositions[i])
        rotate(matrix: &modelMatrix, rotation: rotation + simd_float3(Float(i), Float(i), Float(i)))
        scale(matrix: &modelMatrix, scale: simd_float3(1.0, 1.0, 1.0))

        var modelViewMatrix = viewMatrix * modelMatrix
        renderEncoder.setVertexBytes(&modelViewMatrix, length: MemoryLayout.stride(ofValue: modelViewMatrix), index: 2)

        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: cubeIndices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )
    }
  ```

  </details>

  <details>
  <summary> 제스처 코드(Swift) </summary>

  ```swift
  // MARK: - Camera
  struct Camera {
     var position: simd_float3
     var zoomLevel: Float
     var panDelta: simd_float2
  }

  // 생략
  // ....

  // MARK: - handlePanGesture
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
     let translation = gesture.translation(in: view)

     let sensitivity: Float = 0.01
     camera.panDelta.x += Float(translation.x) * sensitivity
     camera.panDelta.y += Float(translation.y) * sensitivity

     gesture.setTranslation(.zero, in: view)
   } // handlePanGesture

   // MARK: - handlePinchGesture
   @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
     let zoomSensitivity: Float = 0.05
     if gesture.state == .changed {
         camera.zoomLevel -= Float(gesture.velocity) * zoomSensitivity
         camera.zoomLevel = max(10.0, min(90.0, camera.zoomLevel)) // 줌 레벨 클램프
     }
  } // handlePinchGesture
  ```

  </details>

</details>

### Lighting

<details>
<summary> Colors </summary>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/coral.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/A%20lighting%20scene.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Coral
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      A lighting scene
      </p>
      </td>
    </tr>
  </table>
</p>

- [Renderer Cube 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Lighting/Lighting/ViewContriller/RendererViewController%2BRenderCube.swift)
</details>

<details>
<summary> Basic Lighting </summary>

 <p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/ambient%20lighting.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Diffuse%20lighting.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Ambient lighting
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Diffuse lighting
      </p>
      </td>
    </tr>
  </table>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Specular%20Lighting-32.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Specular%20Lighting-32-rotate.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Specular Lighting
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Specular Lighting 32 rotate
      </p>
      </td>
    </tr>
  </table>
</p>

<table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/phong1.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/basicLight-%EC%9E%AC%EC%88%98%EC%A0%95.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Phong
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Phong rotate
      </p>
      </td>
    </tr>
  </table>
</p>

- [Renderer 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Lighting/Lighting/ViewContriller/RendererViewController.swift)

  <details>
  <summary> Pipeline 2개 이용 </summary>

  ```swift
  // MARK: - setupPipeline
  private func setupPipeline() {
    let library = device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: "vertex_shader")
    let fragmentFunction = library?.makeFunction(name: "fragment_shader_main")

    // 기존 큐브
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float

    do {
      mainPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch let error {
      fatalError("pipeline 생성 실패: \(error)")
    }

    // 광원 큐브
    let fragmentSubFunction = library?.makeFunction(name: "fragment_shader_sub")

    let subPipelineDescriptor = MTLRenderPipelineDescriptor()
    subPipelineDescriptor.vertexFunction = vertexFunction //
    subPipelineDescriptor.fragmentFunction = fragmentSubFunction
    subPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    subPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float

    do {
        subPipelineState = try device.makeRenderPipelineState(descriptor: subPipelineDescriptor)
    } catch let error {
        fatalError("광원 큐브 pipeline 생성 실패: \(error)")
    }

    if let deptSten = setupDepthStencilState() {
        depthStencilState = deptSten
    }
    return
  } // setupPipeline
  ```

  </details>

- [조명 관련 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Lighting/Lighting/Metal/Lightings.metal)
  <details>
  <summary> diffuseLighting </summary>

  ```cpp
  // MARK: - diffuseLighting
  inline float3 diffuseLighting(float3 normal, float3 lightDir, float3 lightColor) {
      float diffuseStrength = max(dot(normal, lightDir), 0.0);
      float3 diffuse = diffuseStrength * lightColor;

      return diffuse;
  } // diffuseLighting
  ```

  </details>

  <details>
  <summary> specularLighting </summary>

  ```cpp
  // MARK: - specularLighting
  inline float3 specularLighting(float3 fragPosition, float3 viewPosition, float3 lightDir,
                                 float3 normal, float3 lightColor) {
      float3 viewDir = normalize(viewPosition - fragPosition);
      float3 reflectDir = reflect(-lightDir, normal);
      float spec = pow(max(dot(viewDir, reflectDir), 0.0), 64);
      float3 specular = spec * lightColor;

      return specular;
  } // specularLighting
  ```

  </details>

  <details>
  <summary> phongLighting </summary>

  ```cpp
  // MARK: - phongLighting
  inline float3 phongLighting(float3 ambient, float3 fragPosition, float3 lightPosition,
                              float3 viewPosition, float3 normal, float3 lightColor) {

      float3 lightDir = normalize(lightPosition - fragPosition);

      return ambient + diffuseLighting(normal, lightDir, lightColor) + specularLighting(fragPosition, viewPosition, lightDir, normal, lightColor);
  } // phongLighting
  ```

  </details>

</details>

<details>
<summary> Materials </summary>

<table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/materials%20-%201.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/materials%20-%203.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Materials 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Materials 2
      </p>
      </td>
    </tr>
  </table>

- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Lighting/Lighting/Metal/Shader.metal)
  <details>
  <summary> Vertex Shader </summary>

  ```swift
  // MARK: - TransformUniforms
  struct TransformUniforms {
      var projectionMatrix: simd_float4x4
      var modelMatrix: simd_float4x4
      var viewMatrix: simd_float4x4

      init(projectionMatrix: simd_float4x4, modelMatrix: simd_float4x4, viewMatrix: simd_float4x4) {
          self.projectionMatrix = projectionMatrix
          self.modelMatrix = modelMatrix
          self.viewMatrix = viewMatrix
      } // init

  } // TransformUniforms
  ```

  월드 좌표계 반영, `normalMatrix` 추가

  ```cpp
  // MARK: - vertex_shader
  vertex VertexOut vertex_shader(uint vid [[vertex_id]],
                                 constant VertexIn* vertices [[buffer(0)]],
                                 constant TransformUniforms& transformUniforms [[buffer(1)]],
                                 constant float3x3& normalMatrix [[buffer(2)]]) {
      VertexOut out;

      float3 worldPosition = (transformUniforms.modelMatrix * float4(vertices[vid].position, 1.0)).xyz;
      out.position = transformUniforms.projectionMatrix * transformUniforms.viewMatrix * float4(worldPosition, 1.0);
      out.normal = normalize(normalMatrix * vertices[vid].normal);
      out.fragPosition = worldPosition;
      return out;
  } // vertex_shader
  ```

  </details>

  <details>
  <summary> Fragment Shader </summary>

  ```swift
  // MARK: - LightUniforms
  struct LightUniforms {
      var lightPosition: simd_float3
      var cameraPosition: simd_float3
      var lightColor: simd_float3
      var objectColor: simd_float3

      init(lightPosition: simd_float3, cameraPosition: simd_float3, lightColor: simd_float3, objectColor: simd_float3) {
          self.lightPosition = lightPosition
          self.cameraPosition = cameraPosition
          self.lightColor = lightColor
          self.objectColor = objectColor
      } // init

  } // LightUniforms
  ```

  `phongLighting` 에 `objectColor` 반영

  ```cpp
  // MARK: - fragment_shader_main
  fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                       constant LightUniforms& lightUniform [[buffer(1)]],
                                       constant TransformUniforms& transformUniforms [[buffer(2)]],
                                       constant float3& ambient [[buffer(3)]]) {
      float3 lighting = phongLighting(ambient, in.fragPosition, lightUniform.lightPosition,
                                      lightUniform.cameraPosition, in.normal, lightUniform.lightColor);

      return float4(lighting * lightUniform.objectColor, 1.0);
  ```

  </details>

</details>

<details>

<summary> Light Map </summary>
<table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Diffuse%20maps.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/LightMap.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Diffuse maps
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Specular maps
      </p>
      </td>
    </tr>
</table>

- [Renderer Textures 관련 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/LightingMaps/LightingMaps/ViewController/RendererViewController%2BTextures.swift)
   <details>
   <summary> loadTexture </summary>

  ```swift
  public func loadTexture(_ name: String) throws -> MTLTexture? {
    guard let image = UIImage(named: name)?.cgImage else {
      print("\(name) 불러올 수 없음")
      return nil
    } // 1

    let width = image.width
    let height = image.height
    let textureDescriptor = MTLTextureDescriptor()
    textureDescriptor.pixelFormat = .rgba8Unorm
    textureDescriptor.width = width
    textureDescriptor.height = height
    textureDescriptor.usage = [.shaderRead]
    // 2

    guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
       print("텍스처 생성 실패")
       return nil
    } // 3

    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel _ width
    let imageData = UnsafeMutablePointer<UInt8>.allocate(capacity: bytesPerRow _ height)
    defer { imageData.deallocate() }
    // 4

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: imageData,
    width: width,
    height: height,
    bitsPerComponent: 8,
    bytesPerRow: bytesPerRow,
    space: colorSpace,
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

    context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
    // 5

    let region = MTLRegionMake2D(0, 0, width, height)
    texture.replace(region: region, mipmapLevel: 0, withBytes: imageData, bytesPerRow: bytesPerRow)
    // 6

    return texture
  } // loadTexture
  ```

  1.  `UIImage` 로 이미지를 로드 후, `cgImage` 로 객체로 얻음
  2.  `width` , `height` 값을 가져오고 `MTLTextureDescriptor` 를 생성하고 텍스처의 속성을 설정

      - `pixelFormat = .rgba8Unorm` : 8비트 RGBA 형식의 픽셀 데이터를 사용
      - `usage = [.shaderRead]` : 셰이더에서 읽기 전용으로 사용할 텍스처임을 지정

  3.  `device.makeTexture(descriptor: textureDescriptor)` Metal 텍스처 생성

  4.  이미지 데이터를 메모리에 로드

      - 픽셀당 4바이트(RGBA)를 사용하므로 `bytesPerPixel = 4` 로 설정
      - `bytesPerRow = 4 * width` 를 계산하여 한 줄당 필요한 바이트 수를 구함
      - `UnsafeMutablePointer<UInt8>` 를 사용하여 `imageData` 버퍼를 할당
      - `defer` 를 사용하여 함수 종료 시 `imageData.deallocate()` 로 메모리를 해제

  5.  `CGContext` 를 사용해 이미지 데이터 복사

      - `CGColorSpaceCreateDeviceRGB()` 를 사용하여 RGB 색 공간을 생성
      - `CGContext` 를 생성하여 `imageData` 에 이미지 데이터를 저장할 준비
      - `context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))` 를 호출하여 이미지를 `imageData` 버퍼에 넣어 그림

  6.  Metal 텍스처에 이미지 데이터 복사
      - `MTLRegionMake2D(0, 0, width, height)` 를 사용해 텍스처의 크기를 지정
      - `texture.replace(region:mipmapLevel:withBytes:bytesPerRow:)` 를 호출하여 `imageData` 를 Metal 텍스처로 복사

   </details>

- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/LightingMaps/LightingMaps/Metal/Shader.metal)
   <details>
   <summary> Fragment shader </summary>

  ```cpp
  // MARK: - fragment_shader_main
  fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                       texture2d<float> diffTex [[texture(0)]],
                                       texture2d<float> specTex [[texture(1)]],
                                       sampler sam [[sampler(0)]],
                                       constant LightUniforms& lightUniform [[buffer(1)]],
                                       constant TransformUniforms& transformUniforms [[buffer(2)]]) {

      float3 diffuseTextureColor = diffTex.sample(sam, in.texCoord).rgb;
      float3 specularTextureColor = specTex.sample(sam, in.texCoord).rgb;

      float3 lightDir = normalize(lightUniform.lightPosition - in.fragPosition);

      float3 ambient = lightUniform.ambient * diffuseTextureColor;

      float diff = max(dot(in.normal, lightDir), 0.0);
      float3 diffuse = lightUniform.diffuse * diff * diffuseTextureColor;

      float3 viewDir = normalize(lightUniform.cameraPosition - in.fragPosition);
      float3 reflectDir = reflect(-lightDir, in.normal);
      float spec = pow(max(dot(viewDir, reflectDir), 0.0), 64.0);
      float3 specular = lightUniform.specular * spec * specularTextureColor;

      float3 lighting = ambient + diffuse + specular;
      return float4(lighting, 1.0);
  } // fragment_shader_main
  ```

   </details>

</details>

<details>
<summary> Light Casters </summary>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Directional%20Light.png?raw=true"
             alt="image 1"
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Attenuation.png?raw=true"
             alt="image 1"
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/Flashlight2.png?raw=true"
             alt="image 2"
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Directional Light
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Point lights
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Spotlight
      </p>
      </td>
    </tr>
  </table>
</p>

- [Light Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/LightingCasters/LightingCasters/Metal/Shader.metal)

  <details>
  <summary> Flashlight </summary>

  ```cpp
  // Flashlight
  // MARK: - fragment_shader_Flashlight
  fragment float4 fragment_shader_Flashlight(VertexOut in [[stage_in]],
                                             texture2d<float> diffTex [[texture(0)]],
                                             texture2d<float> specTex [[texture(1)]],
                                             constant TransformUniforms& transformUniforms [[buffer(1)]],
                                             constant LightUniforms& lightUniforms [[buffer(2)]],
                                             constant float3& cameraPosition [[buffer(3)]]) {
       constexpr sampler sam(mip_filter::linear, mag_filter::linear, min_filter::linear, address::repeat);

       float3 result;
       float3 diffuseTextureColor = diffTex.sample(sam, in.texCoord).rgb;
       float3 specularTextureColor = specTex.sample(sam, in.texCoord).rgb;

       float3 lightDir = normalize(lightUniforms.position - in.fragPosition);
       float theta = dot(lightDir, normalize(-lightUniforms.direction));

       float3 ambient = lightUniforms.ambient * diffuseTextureColor;

       if (theta > lightUniforms.cutOff.x) {
           float diff = max(dot(in.normal, lightDir), 0.0);
           float3 diffuse = lightUniforms.diffuse * diff * diffuseTextureColor;

           float3 viewDir = normalize(cameraPosition - in.fragPosition);
           float3 reflectDir = reflect(-lightDir, in.normal);
           float spec = pow(max(dot(viewDir, reflectDir), 0.0), 64.0);
           float3 specular = lightUniforms.specular * spec * specularTextureColor;

           float dist = length(lightUniforms.position - in.fragPosition);
           float attenuation = 1.0 / (lightUniforms.constants.x + lightUniforms.linears.x * dist + lightUniforms.quadratics.x * (dist * dist));

           diffuse *= attenuation;
           specular *= attenuation;

           result = ambient + diffuse + specular;
       }
       else {
           result = ambient;
       }

       return float4(result, 1.0);

  } // fragment_shader_Flashlight

  ```

  </details>

  <details>
  <summary> Spotlight </summary>

  ```cpp
  float theta = dot(lightDir, normalize(-lightUniforms.direction));
  float epsilon = lightUniforms.cutOff.x - lightUniforms.outerCutOff.x;
  float intensity = clamp((theta - lightUniforms.outerCutOff.x) / epsilon, 0.0, 1.0);

  diffuse _= intensity;
  specular _= intensity;

  float dist = length(lightUniforms.position - in.fragPosition);
  float attenuation = 1.0 / (lightUniforms.constants.x + lightUniforms.linears.x _ dist + lightUniforms.quadratics.x _ (dist \* dist));

  ambient _= attenuation;
  diffuse _= attenuation;
  specular \*= attenuation;

  ```

  </details>

</details>

<details>
<summary> Multiple Lights </summary>

<table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/MultipleLights1.png?raw=true"
             alt="image 2"
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/MultipleLights2.png?raw=true"
             alt="image 2"
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Multiple Lights 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Multiple Lights 2
      </p>
      </td>
    </tr>
</table>

- [Camera 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/MultipleLights/MultipleLights/Model/Camera.swift)
- [Light Uniform 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/MultipleLights/MultipleLights/Model/Uniform.swift)

- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/MultipleLights/MultipleLights/Metal/Shader.metal)

  <details>
  <summary> fragment_shader </summary>

  ```cpp
  // MARK: - fragment_shader_main
  fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                       texture2d<float> diffTex [[texture(0)]],
                                       texture2d<float> specTex [[texture(1)]],
                                       sampler sam [[sampler(0)]],
                                       constant TransformUniforms& transformUniforms [[buffer(1)]],
                                       constant SpotLight& spotLight [[buffer(2)]],
                                       constant DirLight& dirLight [[buffer(3)]],
                                       constant PointLights& pointLights [[buffer(4)]],
                                       constant float3& cameraPosition [[buffer(5)]]) {
      float3 diffuseTextureColor = diffTex.sample(sam, in.texCoord).rgb;
      float3 specularTextureColor = specTex.sample(sam, in.texCoord).rgb;

      float3 viewDir = normalize(cameraPosition - in.fragPosition);

      float3 result = calcDirLight(dirLight, in.normal, viewDir, diffuseTextureColor, specularTextureColor);

      for (uint32_t i = 0; i < 4; ++i) {
          result += calcPointLight(pointLights.pointLightArr[i], in.normal, in.fragPosition, viewDir, diffuseTextureColor, specularTextureColor);
      }

      result += calcSpotLight(spotLight, in.normal, in.fragPosition, viewDir, diffuseTextureColor, specularTextureColor);

      return float4(result, 1.0);
  } // fragment_shader_main
  ```

  </details>

  <details>
  <summary> calcDirLight </summary>

  ```cpp
  // MARK: - calcDirLight
  inline float3 calcDirLight(DirLight light, float3 norm, float3 viewDir,
                             float3 diffuseTextureColor, float3 specularTextureColor) {
      float3 lightDir = normalize(-light.direction);
      float diff = max(dot(norm, lightDir), 0.0);

      float3 reflectDir = reflect(-lightDir, norm);
      float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);

      float3 ambient = light.ambient * diffuseTextureColor;
      float3 diffuse = light.diffuse * diff * diffuseTextureColor;
      float3 specular = light.specular * spec * specularTextureColor;

      return (ambient + diffuse + specular);
  } // CalcDirLight
  ```

  </details>

  <details>
  <summary> calcPointLight </summary>

  ```cpp
  // MARK: - calcPointLight
  inline float3 calcPointLight(PointLight light, float3 norm, float3 fragPos, float3 viewDir,
                               float3 diffuseTextureColor, float3 specularTextureColor) {
      float3 lightDir = normalize(light.position - fragPos);
      float diff = max(dot(norm, lightDir), 0.0);

      float3 reflectDir = reflect(-lightDir, norm);
      float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);

      float dist = length(light.position - fragPos);
      float attenuation = 1.0 / (light.constants.x + light.linears.x * dist + light.quadratics.x * (dist * dist));

      float3 ambient = light.ambient * diffuseTextureColor;
      float3 diffuse = light.diffuse * diff * diffuseTextureColor;
      float3 specular = light.specular * spec * specularTextureColor;

      ambient *= attenuation;
      diffuse *= attenuation;
      specular *= attenuation;

      return (ambient + diffuse + specular);
  } // calcPointLight
  ```

  </details>

  <details>
  <summary> calcSpotLight </summary>

  ```cpp
  // MARK: - calcSpotLight
  inline float3 calcSpotLight(SpotLight light, float3 norm, float3 fragPos, float3 viewDir,
                              float3 diffuseTextureColor, float3 specularTextureColor) {
      float3 lightDir = normalize(light.position - fragPos);
      float diff = max(dot(norm, lightDir), 0.0);

      float3 reflectDir = reflect(-lightDir, norm);
      float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);

      float dist = length(light.position - fragPos);
      float attenuation = 1.0 / (light.constants.x + light.linears.x * dist + light.quadratics.x * (dist * dist));

      float theta = dot(lightDir, normalize(-light.direction));
      float epsilon = light.cutOff.x - light.outerCutOff.x;
      float intensity = clamp((theta - light.outerCutOff.x) / epsilon, 0.0, 1.0);

      float3 ambient = light.ambient * diffuseTextureColor;
      float3 diffuse = light.diffuse * diff * diffuseTextureColor;
      float3 specular = light.specular * spec * specularTextureColor;

      ambient *= (attenuation * intensity);
      diffuse *= (attenuation * intensity);
      specular *= (attenuation * intensity);

      return (ambient + diffuse + specular);
  } // calcSpotLight
  ```

  </details>

</details>

### Model Loading

<details>
<summary> Mesh </summary>

```swift
// MARK: - Material
struct Material {
    var textures: [MTLTexture?] = Array(repeating: nil, count: MaterialIndex.allCases.count)

    static private var textureMap: [MDLTexture?: MTLTexture?] = [:]

    // MARK: - init
    init(mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) {
        MaterialIndex.allCases.forEach { index in
            textures[index.rawValue] = loadTexture(index.semantic, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        } // forEach
    } // init

    // MARK: - loadTexture
    private func loadTexture(_ semantic: MDLMaterialSemantic,
                             mdlMaterial: MDLMaterial?,
                             textureLoader: MTKTextureLoader) -> MTLTexture? {
        guard let materialProperty = mdlMaterial?.property(with: semantic) else { return nil }
        guard let sourceTexture = materialProperty.textureSamplerValue?.texture else { return nil }

        if let texture = Material.textureMap[sourceTexture] {
            return texture
        }

        let texture = try? textureLoader.newTexture(texture: sourceTexture, options: nil)
        Material.textureMap[sourceTexture] = texture

        return texture
    } // loadTexture

} // Material
```

<br/>

```swift
// MARK: - Mesh
class Mesh {
    private var mesh: MTKMesh
    private var materials: [Material]

    // MARK: - init
    init(mesh: MTKMesh, materials: [Material]) {
        self.mesh = mesh
        self.materials = materials
    } // init

    // MARK: - draw
    func draw(renderEncoder: MTLRenderCommandEncoder) {
        guard let vertexBuffer = mesh.vertexBuffers.first else {
            return
        }

        renderEncoder.setVertexBuffer(vertexBuffer.buffer,
                                      offset: vertexBuffer.offset,
                                      index: VertexBufferIndex.attributes.rawValue)

        for (submesh, material) in zip(mesh.submeshes, materials) {
            MaterialIndex.allCases.forEach { index in
                renderEncoder.setFragmentTexture(material.textures[index.rawValue], index: index.rawValue)
            } // forEach

            var stateUniform = MaterialStateUniform(textures: material.textures)
            renderEncoder.setFragmentBytes(&stateUniform,
                                           length: MemoryLayout<MaterialStateUniform>.size,
                                           index: FragmentBufferIndex.materialStateUniform.rawValue)

            // Draw
            renderEncoder.drawIndexedPrimitives(type: MTLPrimitiveType.triangle,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        } // for

    } // draw

} // Mesh
```

<br/>

```swift
// MARK: - Model
class Model {
    // Model property
    private var meshes: [Mesh] = []

    // property
    private let position: simd_float3 = simd_float3(repeating: 0.0)
    private let angle: Float = 30.0
    private let axis: simd_float3 = simd_float3(0.0, 1.0, 0.0)
    private let scales: simd_float3 = simd_float3(repeating: 0.4)

    // MARK: - init
    init(device: MTLDevice,
         url: URL,
         vertexDescriptor: MTLVertexDescriptor,
         textureLoader: MTKTextureLoader) {
        loadModel(device: device, url: url, vertexDescriptor: vertexDescriptor, textureLoader: textureLoader)
    } // init

    // MARK: - draw
    func draw(renderEncoder: MTLRenderCommandEncoder) {
        var modelUniform = ModelUniform(position: self.position,
                                        angle: self.angle,
                                        axis: self.axis,
                                        scales: self.scales)
        renderEncoder.setVertexBytes(&modelUniform, length: MemoryLayout<ModelUniform>.size, index: VertexBufferIndex.modelUniform.rawValue)

        for mesh in self.meshes {
            mesh.draw(renderEncoder: renderEncoder)
        } // for

    } // draw

    // MARK: - Private
    // ...
    // MARK: - loadModel
    private func loadModel(device: MTLDevice, url: URL,
                   vertexDescriptor: MTLVertexDescriptor, textureLoader: MTKTextureLoader) {
        let modelVertexDescriptor = VertexDescriptorManager.buildMDLVertexDescriptor(vertexDescriptor: vertexDescriptor)
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: url, vertexDescriptor: modelVertexDescriptor, bufferAllocator: bufferAllocator)

        asset.loadTextures()

        guard let (mdlMeshes, mtkMeshes) = try? MTKMesh.newMeshes(asset: asset, device: device) else {
            print("meshes 생성 실패")
            return
        }

        self.meshes.reserveCapacity(mdlMeshes.count)

        for (mdlMesh, mtkMesh) in zip(mdlMeshes, mtkMeshes) {
            mdlMesh.addOrthTanBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate,
                                    normalAttributeNamed: MDLVertexAttributeNormal,
                                    tangentAttributeNamed: MDLVertexAttributeTangent)
            let mesh = processMesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh, textureLoader: textureLoader)
            self.meshes.append(mesh)
        } // for

    } // loadModel

    // MARK: - processMesh
    private func processMesh(mdlMesh: MDLMesh, mtkMesh: MTKMesh, textureLoader: MTKTextureLoader) -> Mesh {
        var materials: [Material] = []

        for mdlSubmesh in mdlMesh.submeshes as! [MDLSubmesh] {
            let material = Material(mdlMaterial: mdlSubmesh.material, textureLoader: textureLoader)
            materials.append(material)
        } // for

        return Mesh(mesh: mtkMesh, materials: materials)
    } // processMesh

} // Model
```

</details>

<details>
<summary> Model </summary>

**Survival BackPack**

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/model%20loading.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/model%20loading2.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EB%AA%A8%EB%8D%B8%EB%A7%811.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Model 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Model 2
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Model 3
      </p>
      </td>
    </tr>
  </table>
</p>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EC%A1%B0%EB%AA%85%EC%A0%81%EC%9A%A9.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EB%85%B8%EB%A7%90%EB%A7%B5%EC%A0%81%EC%9A%A9.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/roughness-ao-%EC%A0%81%EC%9A%A9.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      조명 적용
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Normal map
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Roughness + AO
      </p>
      </td>
    </tr>
  </table>
</p>

- [Mesh 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/ModelLoading2/ModelLoading2/Model/Mesh.swift)
- [Material 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/ModelLoading2/ModelLoading2/Model/Material.swift)
- [Model 코드(Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/ModelLoading2/ModelLoading2/Model/Model.swift)
- [Shader 코드(Metal)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/ModelLoading2/ModelLoading2/Metal/Shaders.metal)

  <details>
  <summary> Vertex Shader </summary>

  ```cpp
  vertex VertexOut vertexFunction(VertexIn in [[stage_in]],
                                constant ViewUniform& viewUniform [[buffer(vertexBufferIndexView)]],
                                constant ModelUniform& modelUniform [[buffer(vertexBufferIndexModel)]]) {
    VertexOut out;
    out.worldPosition = (modelUniform.modelMatrix * float4(in.position, 1.0)).xyz;
    out.position = viewUniform.projectionMatrix * viewUniform.viewMatrix * float4(out.worldPosition, 1.0);
    out.texCoord = in.texCoord;
    out.normal = in.normal;

    float3 T = normalize(modelUniform.normalMatrix * in.tangent.xyz);
    float3 N = normalize(modelUniform.normalMatrix * in.normal);

    T = normalize(T - dot(T, N) * N);

    float3 B = cross(N, T) * in.tangent.w;

    out.T = T;
    out.B = B;
    out.N = N;

    return out;
  } // vertexFunction
  ```

  </details>

  <details>
  <summary> Fragment Shader </summary>

  ```cpp
  fragment float4 fragmentFunction(VertexOut in [[stage_in]],
                                   texture2d<float> diffuseTexture [[texture(textureIndexDiffuse)]],
                                   texture2d<float> specularTexture [[texture(textureIndexSpecular)]],
                                   texture2d<float> normalTexture [[texture(textureIndexNormal)]],
                                   texture2d<float> roughnessTexture [[texture(textureIndexRoughness)]],
                                   texture2d<float> aoTexture [[texture(textureIndexAo)]],
                                   constant LightUniform& lightUniform [[buffer(fragmentBufferIndexLight)]],
                                   constant MaterialStateUniform& stateUniform [[buffer(fragmentBufferIndexMaterialState)]]) {
    constexpr sampler colorSampler(mip_filter::linear, mag_filter::linear, min_filter::linear, address::repeat);

    float4 diffuseColor = (stateUniform.hasDiffuseTexture ? diffuseTexture.sample(colorSampler, in.texCoord) : float4(1.0));
    float4 specularColor = (stateUniform.hasSpecularTexture ? specularTexture.sample(colorSampler, in.texCoord) : float4(1.0));
    float4 normalColor = (stateUniform.hasNormalTexture ? normalTexture.sample(colorSampler, in.texCoord) : float4(1.0));
    float roughnessColor = (stateUniform.hasRoughnessTexture ? roughnessTexture.sample(colorSampler, in.texCoord) : float4(1.0)).r;
    float aoColor = (stateUniform.hasAoTexture ? aoTexture.sample(colorSampler, in.texCoord) : float4(1.0)).r;

    return applyNormalmaps(lightUniform, diffuseColor, specularColor, normalColor, float3x3(in.T, in.B, in.N), in.worldPosition, roughnessColor, aoColor);
  } // fragmentFunction
  ```

  </details>

<br/>

**Sponza**

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/sponza-1.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
        <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/sponza-2.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Sponza 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Sponza 2
      </p>
      </td>
    </tr>
  </table>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/sponza%20%EC%88%98%EC%A0%951.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/sponza%20%EC%88%98%EC%A0%952.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/sponza%20%EC%88%98%EC%A0%953.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Sponza 조명 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Sponza 조명 2
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
      Sponza 조명 3
      </p>
      </td>
    </tr>
  </table>
</p>

- [제스처 (Pan, Pin) 코드 (Swift)](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/Sponza/ModelLoading2/ViewController/RendererViewController%2BGesture.swift)

  <details>
  <summary> Camera </summary>

  ```swift
  // MARK: - Camera
  class Camera {
      var position: simd_float3
      var front: simd_float3
      var up: simd_float3
      var right: simd_float3
      var worldUp: simd_float3
      var yaw: Float
      var pitch: Float

      var movementSpeed: Float = 3.0
      var mouseSensitivity: Float = 1.0
      var zoom: Float = 45.0

      // MARK: - init
      init(position: simd_float3,
           up: simd_float3 = simd_float3(0, 1, 0),
           yaw: Float = -90.0,
           pitch: Float = 0.0) {
          self.position = position
          self.worldUp = up
          self.yaw = yaw
          self.pitch = pitch
          self.front = simd_float3(0, 0, -1)
          self.right = simd_float3(1, 0, 0)
          self.up = up

          updateCameraVectors()
      } // init

      // MARK: - Public
      // ...
      // MARK: - processKeyboard
      // 키보드 입력 처리 (WASD 이동)
      func processKeyboard(_ direction: CameraMovement, deltaTime: Float) {
          let velocity = self.movementSpeed * deltaTime

          switch direction {
          case .forward:
            self.position += self.front * velocity
          case .backward:
            self.position -= self.front * velocity
          case .left:
            self.position -= self.right * velocity
          case .right:
            self.position += self.right * velocity
          }
      } // processKeyboard

      // MARK: - processMouseMovement
      // 마우스 이동 처리 (카메라 회전)
      func processMouseMovement(xOffset: Float, yOffset: Float, constrainPitch: Bool = true) {
          let xOffset = xOffset * self.mouseSensitivity
          let yOffset = yOffset * self.mouseSensitivity

          self.yaw += xOffset
          self.pitch += yOffset

          if constrainPitch {
              self.pitch = max(-89.0, min(89.0, self.pitch))
          }

          updateCameraVectors()
      } // processMouseMovement

      // MARK: - processMouseScroll
      // 줌 조절
      func processMouseScroll(yOffset: Float) {
        self.zoom -= yOffset
        self.zoom = max(1.0, min(45.0, self.zoom))
      } // processMouseScroll

      // MARK: - getViewMatrix
      func getViewMatrix(eyePosition: simd_float3? = nil) -> simd_float4x4 {
          if let pos = eyePosition {
            return simd_float4x4.identity().lookAt(eyePosition: pos, targetPosition: simd_float3(repeating: 0.0), upVec: simd_float3(0.0, 1.0, 0.0))
          }

          return simd_float4x4.identity().lookAt(eyePosition: self.position,
                                               targetPosition: self.position + self.front,
                                               upVec: self.up)
      } // getViewMatrix

      // MARK: - getProjectionMatrix
      func getProjectionMatrix() -> simd_float4x4 {
          return simd_float4x4.identity().perspective(fov: Float(45).toRadians(),
                                                      aspectRatio: 1.0,
                                                      nearPlane: 0.1,
                                                      farPlane: 100.0)
      } // getProjectionMatrix

      // MARK: - Private
      // ...
      // MARK: - updateCameraVectors
      // 카메라 벡터 업데이트
      private func updateCameraVectors() {
          let yawRad = self.yaw.toRadians()
          let pitchRad = self.pitch.toRadians()

          let frontX = cos(yawRad) * cos(pitchRad)
          let frontY = sin(pitchRad)
          let frontZ = sin(yawRad) * cos(pitchRad)

          self.front = normalize(simd_float3(frontX, frontY, frontZ))
          self.right = normalize(cross(self.front, self.worldUp))
          self.up = normalize(cross(self.right, self.front))
      } // updateCameraVectors

  } // Camera

  // MARK: - CameraMovement
  enum CameraMovement {
      case forward, backward, left, right
  } // CameraMovement
  ```

  </details>

- [Renderer 코드(Swift)](https://github.com/BOLTB0X/Metal-API/tree/main/OpenGL-Tutorial-Metal/Sponza/ModelLoading2/Common/Manager)

  <details>
  <summary> Model Pass </summary>

  ```swift
  // MARK: - ModelPass
  class ModelPass {
      // Propertys
      var vertexDescriptor: MTLVertexDescriptor
      private var renderPipelineState: MTLRenderPipelineState?
      private var shadowSampler: MTLSamplerState?

      private let lightDir : simd_float3 = simd_float3(0.436436, -0.572872, 0.218218)

      // MARK: - init
      init(device: MTLDevice, mkView: MTKView,
           vertexFunction: String, fragmentFunction: String) {
          self.vertexDescriptor = DescriptorManager.buildVertexDescriptor(attributeLength: 4)
          self.renderPipelineState = DescriptorManager.buildPipelineDescriptor(device: device,
                                                                               metalKitView: mkView,
                                                                               vertexDescriptor: self.vertexDescriptor,
                                                                               vertexFunctionName: vertexFunction,
                                                                               fragmentFunctionName: fragmentFunction)
          self.shadowSampler = DescriptorManager.buildSamplerDescriptor(device: device,
                                                                        minFilter: .linear,
                                                                        magFilter: .linear,
                                                                        compareFunction: .less)
      } // init

      // MARK: - encode
      func encode(commandBuffer: MTLCommandBuffer,
                  mkView: MTKView,
                  depthStencilState: MTLDepthStencilState?,
                  render: (MTLRenderCommandEncoder) -> Void,
                  camera: inout Camera,
                  shadowMap: MTLTexture?) {
            let renderPassDescriptor = DescriptorManager.buildMTLRenderPassDescriptor(view: mkView,
                                                                                      r: 0.416,
                                                                                      g: 0.636,
                                                                                      b: 0.722,
                                                                                      alpha: 1.0)
          let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
          renderEncoder.setRenderPipelineState(self.renderPipelineState!)
          renderEncoder.setDepthStencilState(depthStencilState)


          var viewUniform = ViewUniform(viewMatrix: camera.getViewMatrix(),
                                        projectionMatrix: camera.getProjectionMatrix())
          renderEncoder.setVertexBytes(&viewUniform, length: MemoryLayout<ViewUniform>.size, index: VertexBufferIndex.viewUniform.rawValue)

          var lightUniform = LightUniform(viewMatrix: camera.getViewMatrix(eyePosition: lightDir),
                                          projectionMatrix: simd_float4x4.identity().orthographicProjection(l: -10.0, r: 10.0, bottom: -10.0, top: 10.0, zNear: -25.0, zFar: 25.0))
          renderEncoder.setFragmentBytes(&lightUniform, length: MemoryLayout<LightUniform>.size, index: FragmentBufferIndex.lightUniform.rawValue)

          renderEncoder.setFragmentBytes(&camera.position, length: MemoryLayout<simd_float3>.size, index: FragmentBufferIndex.cameraPosition.rawValue)

          renderEncoder.setFragmentTexture(shadowMap!, index: 0)
          renderEncoder.setFragmentSamplerState(self.shadowSampler, index: 0)

          render(renderEncoder)

          renderEncoder.endEncoding()
      } // encode
  } // ModelPass
  ```

  </details>

  <details>
  <summary> Shadow Pass </summary>

  ![Shadow Map ](https://github.com/BOLTB0X/Metal-API/blob/main/img/metal%20%EC%BA%A1%EC%B2%98.png?raw=true)

  현재 제대로 Shadow Map 생성되지 않음

  ```swift
  // MARK: - ShadowPass
  class ShadowPass {
      // Propertys
      var shadowMap: MTLTexture?
      private var vertexDescriptor: MTLVertexDescriptor
      private var renderPipelineState: MTLRenderPipelineState?

      private let lightDir : simd_float3 = simd_float3(0.436436, -0.572872, 0.218218)

      // MARK: - init
      init(device: MTLDevice, mkView: MTKView,
           vertexFunction: String, fragmentFunction: String) {
          self.vertexDescriptor = DescriptorManager.buildVertexDescriptor(attributeLength: 1)
          self.shadowMap = DescriptorManager.buildMTLTextureDescriptor(device: device)
          self.renderPipelineState = DescriptorManager.buildShadowPipelineDescriptor(device: device,
                                                                                     shadowMap: self.shadowMap,
                                                                                     vertexDescriptor: self.vertexDescriptor,
                                                                                     vertexFunctionName: vertexFunction,
                                                                                     fragmentFunctionName: fragmentFunction)
      } // init

      // MARK: - encode
      func encode(commandBuffer: MTLCommandBuffer,
                  mkView: MTKView,
                  depthStencilState: MTLDepthStencilState?,
                  render: (MTLRenderCommandEncoder) -> Void,
                  camera: Camera) {
          let renderPassDescriptor = MTLRenderPassDescriptor()
          renderPassDescriptor.depthAttachment.texture = self.shadowMap
          renderPassDescriptor.depthAttachment.loadAction = .clear
          renderPassDescriptor.depthAttachment.storeAction = .store
          renderPassDescriptor.depthAttachment.clearDepth = 1.0

          let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
          renderEncoder.setRenderPipelineState(self.renderPipelineState!)
          renderEncoder.setDepthStencilState(depthStencilState)

           var lightUniform = LightUniform(viewMatrix: camera.getViewMatrix(eyePosition: lightDir),
                                           projectionMatrix: simd_float4x4.identity().orthographicProjection(l: -10.0, r: 10.0, bottom: -10.0, top: 10.0, zNear: -25.0, zFar: 25.0))
           renderEncoder.setVertexBytes(&lightUniform, length: MemoryLayout<LightUniform>.size, index: VertexBufferIndex.viewUniform.rawValue)

           render(renderEncoder)

           renderEncoder.endEncoding()
       } // encode

  } // ShadowPass
  ```

  </details>

</details>

<!--

- Lesson 1: Hello Metal

  - [Hello Window](https://github.com/BOLTB0X/Metal-API/tree/Lesson-1-Hello-Window/Metal-Tutorial)

  - [Hello Triangle](https://github.com/BOLTB0X/Metal-API/tree/Lesson-1-Hello-Triangle/Metal-Tutorial)

  - [Textures](https://github.com/BOLTB0X/Metal-API/tree/Lesson-1-Textures/Metal-Tutorial)
    -->

## 참고

- [공식 developer apple - Metal](https://developer.apple.com/metal/)

- [공식문서 - Using a Render Pipeline to Render Primitives](https://developer.apple.com/documentation/metal/using_a_render_pipeline_to_render_primitives)

- [공식문서 - Metal](https://developer.apple.com/documentation/metal)

- [공식문서 - Model I/O](https://developer.apple.com/documentation/modelio)

- [공식문서 - MetalKit](https://developer.apple.com/documentation/metalkit)

- [Metal Tutorial](https://metaltutorial.com/)

- [kodeco - metal tutorial](https://www.kodeco.com/7475-metal-tutorial-getting-started#toc-anchor-011)

- [WWDC 2019](https://developer.apple.com/videos/play/wwdc2019/611/?time=180)

- [medium - Apple’s Metal API tutorial](https://medium.com/@samuliak/apples-metal-api-tutorial-part-3-textures-ff41873dfb67)

- [medium - What’s Metal Shading Language (MSL)?](https://medium.com/@shoheiyokoyama/whats-metal-shading-language-msl-96fe63257994)

- [블로그 참조 - zeddios(Metal이 뭔지 궁금해서 쓰는 글)](https://zeddios.tistory.com/932)

- [블로그 참조 - eunjin3786(샘플러에 대해 알아보자)](https://eunjin3786.tistory.com/190)

- [블로그 참조 - ally10(Metal 스터디)](https://ally10.tistory.com/57)

- [블로그 참조 - Rendering Physically-Based ModelIO Materials](https://metalbyexample.com/modelio-materials/)
