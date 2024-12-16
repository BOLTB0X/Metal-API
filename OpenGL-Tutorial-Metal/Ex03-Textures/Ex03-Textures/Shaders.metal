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
    // 텍스처 샘플링
    float4 sampledColor = tex.sample(sam, in.texCoord);
    
    return float4(sampledColor.rgb * in.color * 1.5, sampledColor.a);
}

fragment float4 fragmentFunction2(VertexOut in [[stage_in]],
                                  texture2d<float> tex1 [[texture(0)]],
                                  texture2d<float> tex2 [[texture(1)]],
                                  sampler sam [[sampler(0)]],
                                  constant float &blendRat [[buffer(1)]]) {
    float4 sampledColor1 = tex1.sample(sam, in.texCoord);
    
    float2 upsideDown = float2(in.texCoord.x, 1.0 - in.texCoord.y);
    float4 sampledColor2 = tex2.sample(sam, upsideDown);
    //float4 sampledColor2 = tex2.sample(sam, in.texCoord);
    
    return float4(mix(sampledColor1.rgb, sampledColor2.rgb, blendRat), sampledColor1.a);
}

fragment float4 exercises01(VertexOut in [[stage_in]],
                            texture2d<float> tex1 [[texture(0)]],
                            texture2d<float> tex2 [[texture(1)]],
                            sampler sam [[sampler(0)]],
                            constant float &blendRat [[buffer(1)]]) {
    
    float4 sampledColor1 = tex1.sample(sam, in.texCoord);
    
    float2 upsideDown = float2(1.0 - in.texCoord.x, in.texCoord.y);
    float4 sampledColor2 = tex2.sample(sam, upsideDown);
    //float4 sampledColor2 = tex2.sample(sam, in.texCoord);
    
    return float4(mix(sampledColor1.rgb, sampledColor2.rgb, blendRat), sampledColor1.a);
}
