//
//  Shader.metal
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/19.
//

#include <metal_stdlib>
#include "Vertex.metal"
using namespace metal;

// MARK: - vertex_main
// Vertex Shader
vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant float4& modelMatrix [[buffer(0)]],
                             constant float4& viewMatrix [[buffer(1)]],
                             constant float4& projection [[buffer(2)]]) {
    VertexOut out;
    out.position = projection * viewMatrix * modelMatrix * float4(in.position, 1.0);
    out.texCoord = in.texCoord;
    return out;
} // vertex_main


// MARK: - fragment_main
// fragment Shader
fragment float4 fragment_main(VertexOut in [[stage_in]],
                              texture2d<float> diffuseTexture [[texture(0)]],
                              texture2d<float> specularTexture [[texture(1)]],
                              texture2d<float> normalTexture [[texture(2)]],
                              texture2d<float> roughnessTexture [[texture(4)]]) {
    constexpr sampler sam(mip_filter::linear, mag_filter::linear, min_filter::linear, address::repeat);

    float4 diffuseColor = diffuseTexture.sample(sam, in.texCoord);
//    float4 specularColor = specularTexture.sample(sam, in.texCoord);
//    float4 normalColor = normalTexture.sample(sam, in.texCoord);
//    float4 roughnessColor = roughnessTexture.sample(sam, in.texCoord);
    
    return diffuseColor;
} // fragment_main
