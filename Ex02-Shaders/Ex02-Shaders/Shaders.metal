//
//  Vertex.metal
//  Ex02-Shaders
//
//  Created by KyungHeon Lee on 2024/12/04.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float2 position;
    float3 color;
};

struct VertexOut {
    float4 position [[position]];
    float3 color;
};

vertex VertexOut vertexFunction(uint vid [[vertex_id]], constant Vertex* vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(vertices[vid].position, 0.0, 1.0); // 2D 좌표를 4D로 변환
    out.color = vertices[vid].color;                         // 색상 전달
    return out;
}

fragment float4 fragmentFunction(VertexOut in [[stage_in]]) {
    return float4(in.color, 1.0); // 색상 값 반환
}
