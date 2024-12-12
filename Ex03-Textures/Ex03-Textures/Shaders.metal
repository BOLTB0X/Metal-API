//
//  Shaders.metal
//  Ex03-Textures
//
//  Created by KyungHeon Lee on 2024/12/12.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float2 position;
    float3 color;
    float2 texCoord;
};

struct VertexOut {
    float4 position [[position]];
    float3 color;
    float2 texCoord;
};

vertex VertexOut vertexFunction(uint vid [[vertex_id]], constant Vertex* vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(vertices[vid].position, 0.0, 1.0); // 2D 좌표를 4D로 변환
    out.color = vertices[vid].color;
    out.texCoord = vertices[vid].texCoord;
    return out;
}

fragment float4 fragmentFunction(VertexOut in [[stage_in]],
                                 texture2d<float> tex [[texture(0)]],
                                 sampler sam [[sampler(0)]]) {
    float4 sampledColor = tex.sample(sam, in.texCoord);
    return sampledColor;
}

