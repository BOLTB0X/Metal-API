//
//  Shaders.metal
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

#include <metal_stdlib>
#include "Vertex.metal"
using namespace metal;

// MARK: - vertexFunction
vertex VertexOut vertexFunction(VertexIn in [[stage_in]],
                                constant float4x4& projectionMatrix [[buffer(0)]],
                                constant float4x4& viewMatrix [[buffer(1)]],
                                constant float4x4& modelMatrix [[buffer(2)]]) {
    VertexOut out;
    out.worldPosition = (modelMatrix * float4(in.position, 1.0)).xyz;
    out.position = projectionMatrix * viewMatrix * float4(out.worldPosition, 1.0);
    out.texCoord = in.texCoord;
    out.normal = in.normal;
    
    return out;
} // vertexFunction

// MARK: - fragmentFunction
fragment float4 fragmentFunction(VertexOut in [[stage_in]],
                                 //constant float3& viewPosition [[buffer(0)]],
                                 texture2d<float> diffuseTexture [[texture(0)]],
                                 texture2d<float> specularTexture [[texture(1)]]) {
    constexpr sampler colorSampler(mip_filter::linear, mag_filter::linear, min_filter::linear, address::repeat);

    float4 diffuseColor  = diffuseTexture.sample(colorSampler, in.texCoord);

    return diffuseColor;
} // fragmentFunction
