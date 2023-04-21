/// Copyright (c) 2023 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

#include <metal_stdlib>
using namespace metal;

// MARK: 4) Creating a Vertex Shader
// 이전 섹션에서 생성한 꼭지점은 꼭지점 셰이더라고 하는 작은 프로그램의 입력이 됨
// vertex shader는 Metal Shading Language라고 하는 C++과 유사한 언어로 작성된 GPU에서 실행되는 작은 프로그램
// vertex shader는 정점당 한 번 호출되며 위치와 같은 정점의 정보와 색상 또는 텍스처 좌표와 같은 기타 정보를 가져와 잠재적으로 수정된 위치 및 기타 데이터를 반환하는 것

vertex float4 basic_vertex(                           // 4-1)
  const device packed_float3* vertex_array [[ buffer(0) ]], // 4-2)
  unsigned int vid [[ vertex_id ]]) {                 // 4-3)
  return float4(vertex_array[vid], 1.0);              // 4-4)
}

// 4-1) 모든 버텍스 셰이더는 키워드 vertex로 시작해야 함
// 함수는 정점의 최종 위치를 (최소한) 반환해야 함, 여기서는 float4(플로트 4개로 구성된 벡터)를 표시하여 이 작업을 수행
// 그런 다음 정점 셰이더의 이름을 지정함 나중에 이 이름을 사용하여 셰이더를 조회

// 4-2) 첫 번째 매개변수는 packed_float3(3개의 부동 소수점으로 구성된 압축된 벡터)의 배열에 대한 포인터
// 즉, 각 정점의 위치 [[ ... ]] 구문을 사용하여 리소스 위치, 셰이더 입력 및 기본 제공 변수와 같은 추가 정보를 지정하는 데 사용할 수 있는 특성을 선언
// 여기에서 이 매개변수를 [[ buffer(0) ]]로 표시하여 Metal 코드에서 버텍스 셰이더로 보내는 데이터의 첫 번째 버퍼가 이 매개변수를 채울 것임을 나타냄

// 4-3) vertex shader는 vertex_id 속성과 함께 특수 매개변수를 사용함
// 즉, Metal이 버텍스 배열 내부의 이 특정 버텍스의 인덱스로 채울 것

// 4-4) 여기에서 정점 ID를 기반으로 정점 배열 내부의 위치를 ​​찾아 반환
// 또한 벡터를 float4로 변환함 여기서 최종 값은 1.0, 간단히 말해 3D 수학에 필요

// MARK: 5) Creating a Fragment Shader
// 버텍스 셰이더가 완료된 후 Metal은 화면의 각 조각(픽셀 생각)에 대해 다른 셰이더인 조각 셰이더를 호출
// 조각 셰이더는 정점 셰이더의 출력 값을 보간하여 입력 값을 가져옴
fragment half4 basic_fragment() { // 5-1)
  return half4(1.0);              // 5-2)
}

// 5-1) 모든 조각 셰이더는 조각 키워드로 시작해야 함
// 함수는 (최소한) 조각의 최종 색상을 반환
// half4(4개 구성 요소 색상 값 RGBA)를 표시, 더 적은 GPU 메모리에 쓰기 때문에 half4가 float4보다 더 메모리 효율적

// 5-2) 여기에 흰색인 색상에 대해 (1, 1, 1, 1)을 반환
