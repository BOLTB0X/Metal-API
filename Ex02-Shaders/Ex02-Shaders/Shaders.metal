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

// Adjust the vertex shader so that the triangle is upside down
vertex VertexOut exercises01(uint vid [[vertex_id]], constant Vertex* vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(vertices[vid].position.x, -vertices[vid].position.y, 0.0, 1.0);
    out.color = vertices[vid].color;
    return out;
}

// Specify a horizontal offset via a uniform and move the triangle to the right side of the screen in the vertex shader using this offset value
vertex VertexOut exercises02(uint vid [[vertex_id]],
                             constant Vertex* vertices [[buffer(0)]],
                             constant float* offset [[buffer(1)]]) {
    VertexOut out;
    out.position = float4(vertices[vid].position.x + offset[0], vertices[vid].position.y, 0.0, 1.0);
    out.color = vertices[vid].color;
    return out;
}

vertex VertexOut vertexFunction(uint vid [[vertex_id]], constant Vertex* vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(vertices[vid].position, 0.0, 1.0); // 2D 좌표를 4D로 변환
    out.color = vertices[vid].color;
    return out;
}

fragment float4 fragmentFunction(VertexOut in [[stage_in]]) {
    return float4(in.color, 1.0);
}
