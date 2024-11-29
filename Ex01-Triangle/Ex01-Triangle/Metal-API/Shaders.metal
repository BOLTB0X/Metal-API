//
//  Shaders.metal
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/27.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
};

vertex float4 basic_vertex(
  const device packed_float3* vertex_array [[ buffer(0) ]],
  unsigned int vid [[ vertex_id ]]) {
  return float4(vertex_array[vid], 1.0);
}

fragment float4 basic_fragment(
        VertexOut in [[stage_in]],
        constant float4 &color [[buffer(1)]]) {
    return color;
}
