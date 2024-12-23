//
//  Shaders.metal
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float3 color [[attribute(1)]];
    float2 texCoord [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 color;
    float2 texCoord;
};

vertex VertexOut vertexFunction(VertexIn in [[stage_in]],
                                constant float4x4& projectionMatrix [[buffer(0)]],
                                constant float4x4& modelViewMatrix [[buffer(1)]]) {
    VertexOut out;
    out.position = projectionMatrix * modelViewMatrix * float4(in.position, 1.0);
    out.color = in.color;
    out.texCoord = in.texCoord;
    
    return out;
}


fragment float4 fragmentFunction(VertexOut in [[stage_in]],
                                  texture2d<float> tex1 [[texture(0)]],
                                  texture2d<float> tex2 [[texture(1)]],
                                  sampler sam [[sampler(0)]],
                                  constant float &blendRat [[buffer(1)]]) {
    float4 sampledColor1 = tex1.sample(sam, in.texCoord);
    float4 sampledColor2 = tex2.sample(sam, in.texCoord);
    
    return float4(mix(sampledColor1.rgb, sampledColor2.rgb, blendRat), sampledColor1.a);
}
