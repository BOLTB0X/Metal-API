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

</details>

<details>
<summary> Basic Lighting
 </summary>

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
</p>

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
