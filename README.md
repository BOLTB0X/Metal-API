# Metal-API

![어어어어어어어어어어어어거아아아아아아아악](https://i1.ruliweb.net/ori/21/04/20/178eac3b4005347ad.gif)

<br/>

## Metal

> Render advanced 3D graphics and compute data in parallel with graphics processors.

<br/>

<div style="text-align: center;">
<img src="https://developer.apple.com/assets/elements/icons/metal/metal-96x96_2x.png" alt="Example Image" width="50%">
</div>

<br/>

- **Metal API**는 **Apple**에서 제공하는 그래픽 및 연산 작업을 위한 저수준 API
  <br/>

  <div style="text-align: center;">
  <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EB%B9%84%EA%B5%90.png?raw=true" alt="Example Image" width="70%">
  </div>
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

  <br/>

  <div style="text-align: center;">
  <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/ios.png?raw=true" alt="Example Image" width="70%">
  </div>
  <br/>

- *Vulkan*과 비슷한 역할을 하지만 **iOS**, **macOS** 등 Apple 생태계에 최적화되어 있음
  <br/>

- 3D 그래픽 렌더링뿐 아니라, *GPU*에서 실행할 **병렬 연산** 작업도 지원, 게임의 작동 방식을 제어 가능
  <br/>

## Intro

> Metal API를 이해하려면 세 가지 기본 개념이 필요

<br/>

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

## Tutorial

- Lesson 1: Hello Metal

  - [Hello Window](https://github.com/BOLTB0X/Metal-API/tree/Lesson-1-Hello-Window/Metal-Tutorial)

  - [Hello Triangle](https://github.com/BOLTB0X/Metal-API/tree/Lesson-1-Hello-Triangle/Metal-Tutorial)

  - [Textures](https://github.com/BOLTB0X/Metal-API/tree/Lesson-1-Textures/Metal-Tutorial)

## 참고

- [공식 developer apple - Metal](https://developer.apple.com/metal/)

- [공식문서 - Metal](https://developer.apple.com/documentation/metal)

- [Metal Tutorial](https://metaltutorial.com/)

- [kodeco - metal tutorial](https://www.kodeco.com/7475-metal-tutorial-getting-started#toc-anchor-011)

- [WWDC 2019](https://developer.apple.com/videos/play/wwdc2019/611/?time=180)

- [블로그 참조 - zeddios(Metal이 뭔지 궁금해서 쓰는 글)](https://zeddios.tistory.com/932)
