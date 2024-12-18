//
//  Shaders.metal
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float2 position;
    float3 color;
    float2 texCoord;
};

struct VertexOut {
    float4 position [[position]];
    float3 color;
    float2 texCoord;
};

vertex VertexOut vertexFunction(uint vid [[vertex_id]],
                                constant VertexIn* vertices [[buffer(0)]],
                                constant float4x4 &modelMatrix [[buffer(1)]]) {
    VertexOut out;
    float4 pos = float4(vertices[vid].position, 0.0, 1.0);
    
    out.position = modelMatrix * pos;
    out.color = vertices[vid].color;
    out.texCoord = vertices[vid].texCoord;
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
