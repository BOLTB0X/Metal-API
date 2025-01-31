# Attribute Qualifier

- MSL(Metal Shading Language)에서 셰이더와 GPU data를 연결하는 **인터페이스**
  <br/>

- 셰이더의 input data를 GPU 메모리로부터 가져오는 역할을 수행

GPU가 data를 **어디서** 가져와야 하고, 그것이 셰이더에서 **무슨 역할**을 하는지 알려주는 규칙

## Attribute vs Qualifier

- **Qualifier**는 GPU가 data를 어떻게 해석하고 처리할지를 정의
- **Attribute**는 data 자체의 특성이나 구조를 정의
  <br/>

1. **Qualifier** (한정자)

   - 정의

     - 변수나 함수의 동작 방식 또는 사용 범위를 정의하는 데 사용되는 키워드
     - GPU에서 데이터의 처리와 전달 방식을 제어하는 데 사용
       <br/>

   - 목적

     - 데이터의 메모리 위치, 접근 방식, 또는 특별한 속성을 정의
     - 변수나 함수에 대해 GPU가 데이터를 처리하는 방법을 명시
       <br/>

   - 특징
     - 특정 셰이더, 버퍼, 쓰레드 등 에서만 작동
     - 범용적으로 사용되며, GPU가 변수나 함수를 어떻게 해석할지 알려줌
       <br/>

   ```cpp
   // [[buffer(n)]]: 변수에 특정 GPU 버퍼 슬롯을 매핑
   constant Vertex* vertices [[buffer(0)]];

   // [[position]]: 셰이더 출력에서 GPU의 위치 데이터를 명시
   struct VertexOut {
   float4 position [[position]];
   };
   ```

   <br/>

2. **Attribute** (속성)

   - 정의

     - Attribute는 데이터 자체의 속성 또는 특성을 정의
     - 주로 셰이더의 입력 데이터를 정의하는 데 사용
       <br/>

   - 목적

     - data의 레이아웃 또는 속성을 정의.
     - Vertex data를 Vertex Shader로 전달할 때 정점 데이터의 속성을 명시
       <br/>

   - 특징
     - Vertex data의 속성을 정의하고, 이를 셰이더에 전달
     - 보통 Vertex 데이터와 관련된 입력 레이아웃을 정의
     - OpenGL에서는 attribute라는 키워드를 사용했지만, Metal에서는 구조체 정의와 `[[buffer(n)]]` 같은 **Qualifier**를 함께 사용하여 이를 처리
       <br/>

   ```cpp
   // Metal에서는 전통적인 OpenGL에서 사용되던 attribute 키워드를 직접적으로 사용하지 않지만
   // 속성을 명시적으로 정의할 수 있는 구조체와 버퍼 매핑 방식을 통해 동일한 효과를 냄
   struct Vertex {
    float2 position;
    float3 color;
   };
   ```

   <br/>

| **특징**         | **Qualifier**                                  | **Attribute**                          |
| ---------------- | ---------------------------------------------- | -------------------------------------- |
| **정의**         | 변수/함수의 동작과 data를 처리하는 방식을 명시 | data 자체의 속성이나 특성을 명시       |
| **목적**         | GPU가 data를 어떻게 해석할지 지정              | 셰이더에 전달될 input data의 속성 정의 |
| **사용 위치**    | 함수 인자, 변수, 또는 출력 구조체              | Vertex Data에 사용                     |
| **예시 (Metal)** | `[[buffer(0)]]`, `[[position]]`                | `struct Vertex { float2 position; }`   |
| **유래**         | Metal, CUDA, HLSL 등                           | OpenGL, WebGL, GLSL                    |

<br/>

## 주요 Attribute Qualifier

### Vertex and Fragment Shader Input Attributes

셰이더의 input data를 GPU에서 전달받을 때 사용

1. `[[buffer(n)]]`

   - 용도: 버퍼에 바인딩된 data를 가져옴

   - 사용 위치:셰이더 함수의 인자

   ```cpp
   vertex VertexOut vertexFunction(
      constant Vertex* vertices [[buffer(0)]]
   ) {
         // vertices 배열을 0번 버퍼에서 가져옴
   }
   ```

   <br/>

2. `[[position]]`

   - 용도: GPU가 계산한 최종 정점 위치 data를 전달
   - 사용 위치: vertex 셰이더의 출력 구조체

   ```cpp
   struct VertexOut {
       float4 position [[position]]; // GPU가 (lip space에서 사용하는 위치
   };
   ```

   <br/>

3. `[[stage_in]]`
   - 용도: vertex 셰이더 output data를 fragment 셰이더의 입력으로 전달할 때 사용
   - 사용 위치: fragment 셰이더의 인자
   ```cpp
   fragment float4 fragmentFunction(VertexOut in [[stage_in]]) {
       return float4(in.color, 1.0); // `vertex` 셰이더 출력 데이터 사용
   }
   ```
   <br/>

### Indexing and IDs

정점이나 인스턴스의 ID를 GPU로부터 가져올 때 사용

1. `[[vertex_id]]`

   - 용도: 정점의 ID를 가져오며 이는 정점 배열에서 현재 처리 중인 정점의 인덱스를 나타냄

   ```cpp
   vertex VertexOut vertexFunction(
       uint vid [[vertex_id]]
   ) {
       // vid는 현재 정점의 인덱스
   }
   ```

   <br/>

2. `[[instance_id]]`
   - 용도: 인스턴스 ID를 가져오며 이는 현재 그리기 호출에서 몇 번째 인스턴스를 처리 중인지 나타냄
   ```cpp
   vertex VertexOut vertexFunction(
       uint iid [[instance_id]]
   ) {
       // iid는 현재 인스턴스의 ID
   }
   ```
   <br/>

### Textures and Samplers

Texture data를 셰이더로 전달할 때 사용

1. `[[texture(n)]]`

   - 용도: 특정 인덱스 n의 텍스처를 참조

   ```cpp
   fragment float4 textureFragment(
       texture2d<float> texture [[texture(0)]]
   ) {
       // 텍스처를 0번 슬롯에서 가져옴
   }
   ```

   <br/>

2. `[[sampler(n)]]`
   - 용도: 샘플러 객체를 전달, 이는 텍스처 data를 샘플링할 때 사용
   ```cpp
   fragment float4 samplerFragment(
       texture2d<float> texture [[texture(0)]],
       sampler textureSampler [[sampler(0)]]
   ) {
       return texture.sample(textureSampler,
       float2(0.5, 0.5));
   }
   ```
      <br/>

### Thread Group and Dispatch Attributes

병렬 처리를 위한 쓰레드와 쓰레드 그룹 관련 정보를 전달

1. `[[thread_position_in_grid]]`

   - 용도: 전체 그리드에서 현재 쓰레드의 위치를 나타냄

   ```cpp
   kernel void computeKernel(
       uint3 gid [[thread_position_in_grid]]
   ) {
       // gid는 현재 쓰레드의 그리드 내 위치
   }
   ```

2. `[[thread_index_in_threadgroup]]`
   - 용도: 현재 쓰레드 그룹 내에서의 위치를 나타냄
   ```cpp
   kernel void computeKernel(
       uint3 tid [[thread_index_in_threadgroup]]
   ) {
       // tid는 쓰레드 그룹 내 위치
   }
   ```
   <br/>

### Constant Buffers and Uniforms

상수 data를 전달할 때 사용

- `[[buffer(n)]]`
  용도: 동일하게 버퍼에서 data를 가져오며 상수 data로 사용 가능

  ```cpp
  fragment float4 fragmentFunction(
      constant float4& uniformColor [[buffer(1)]]
  ) {
      return uniformColor; // 상수 데이터를 색상으로 반환
  }
  <br/>


  ```

  <br/>

### 요약

- `[[buffer(n)]]`, `[[texture(n)]]`, `[[sampler(n)]]`: 데이터를 GPU로 전달하는 주요 인터페이스
  <br/>

- `[[vertex_id]]`, `[[instance_id]]`: 현재 처리 중인 정점/인스턴스의 정보를 제공
  <br/>

- `[[position]]`, `[[stage_in]]`: 셰이더 간 데이터 전달
  <br/>

- `[[thread_*]]`: 병렬 처리 시 쓰레드 정보 전달

## 참고

- [공식문서 - Using a Render Pipeline to Render Primitives](https://developer.apple.com/documentation/metal/using_a_render_pipeline_to_render_primitives)

- [medium 참조 - What’s Metal Shading Language (MSL)?](https://medium.com/@shoheiyokoyama/whats-metal-shading-language-msl-96fe63257994)
