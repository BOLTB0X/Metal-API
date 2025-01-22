//
//  Shaders.metal
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/21.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float3 toyColor [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 toyColor;
};

vertex VertexOut vertexFunction(uint vid [[vertex_id]],
                                constant VertexIn* vertices [[buffer(0)]],
                                constant float4x4& projectionMatrix [[buffer(1)]],
                                constant float4x4& modelViewMatrix [[buffer(2)]]) {
    VertexOut out;
    out.position = projectionMatrix * modelViewMatrix * float4(vertices[vid].position, 1.0);
    out.toyColor = vertices[vid].toyColor;
    return out;
}

fragment float4 fragmentFunction(VertexOut in [[stage_in]],
                                 constant float3 &lightColor [[buffer(1)]]) {
 
    return float4(lightColor * in.toyColor, 1.0);
}
