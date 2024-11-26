/// Copyright (c) 2024 Razeware LLC
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

vertex float4 basic_vertex(                           // 1
  const device packed_float3* vertex_array [[ buffer(0) ]], // 2
  unsigned int vid [[ vertex_id ]]) {                 // 3
  return float4(vertex_array[vid], 1.0);              // 4
}

fragment half4 basic_fragment() { // 1
  return half4(1.0);              // 2
}

/// Vertex Shader
/// 1
/// 모든 꼭지점 셰이더는 키워드 vertex로 시작해야 함, 여기서 이 함수는 꼭지점의 최소한이라도 최종 위치를 반환해야 함,
/// 여기에서는 float4(4개의 부동 소수점으로 구성된 벡터)를 지정하여 이를 수행하고 다음 정점 셰이더의 이름을 지정 함
/// 이 이름(basic_vertex)을 사용하여 셰이더를 검색하고 사용하는 것

/// 2
/// 첫 번째 파라미터: Packed_float3(세 개의 부동 소수점으로 구성된 벡터) 배열에 대한 포인터 -> 각 정점의 위치
/// [[ ... ]] 구문을 사용하여 리소스 위치, 셰이더 입력 및 내장 변수와 같은 추가 정보를 지정하는 데 사용할 수 있는 프로퍼티를 선언함
/// 여기에서 이 매개변수를 [[ buffer(0) ]]로 표시하여 Metal 코드에서 정점 셰이더로 보내는 data의 첫 번째 버퍼가 이 매개변수를 채울 것임을 나타냄

/// 3
/// 정점 셰이더는 vertex_id 속성과 함께 특수 매개변수도 사용. 즉, Metal이 정점 배열 내부의 특정 정점 인덱스로 이를 채운다는 뜻

/// 4
/// 여기서는 정점 ID를 기반으로 정점 배열 내부의 위치를 ​​찾아 반환, 또한 벡터를 float4로 변환하기도 함 여기서 최종 값은 1.0
