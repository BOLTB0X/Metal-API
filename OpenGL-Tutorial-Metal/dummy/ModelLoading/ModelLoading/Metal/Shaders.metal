//
//  Shader.metal
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/19.
//

#include <metal_stdlib>
#include "Vertex.metal"
using namespace metal;

inline float3 phongLighting(float3 worldPosition, float3 diffuseColor, float specularColor, float3 normal, float3 viewPosition) {
    float3 lightDirection = float3(0.5, 0.8, 0.3);
    
    //Ambient
    float3 ambient = float3(0.4) * diffuseColor;
    
    //Diffuse
    float3 diff = max(dot(normal, -lightDirection), 0.0);
    float3 diffuse = float3(1.0) * diff * diffuseColor;
    
    //Specular
    float3 viewDir = normalize(viewPosition - worldPosition);
    float3 reflectDir = reflect(lightDirection, normal);
    float3 spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    float3 specular = float3(1.0) * spec * specularColor;
    
    return ambient + diffuse + specular;
}

// MARK: - vertex_main
// Vertex Shader
vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant float4& modelMatrix [[buffer(0)]],
                             constant float4& viewMatrix [[buffer(1)]],
                             constant float4& projection [[buffer(2)]]) {
    VertexOut out;
    out.position = projection * viewMatrix * modelMatrix * float4(in.position, 1.0);
    out.worldPosition = (modelMatrix * float4(in.position, 1.0)).xyz;
    out.normal = in.normal;
    out.texCoord = in.texCoord;
    return out;
} // vertex_main


// MARK: - fragment_main
// fragment Shader
fragment float4 fragment_main(VertexOut in [[stage_in]],
                              constant float3& viewPosition [[buffer(0)]],
                              texture2d<float> diffuseTexture [[texture(0)]],
                              texture2d<float> specularTexture [[texture(1)]]) {
    constexpr sampler sam(mip_filter::linear, mag_filter::linear, min_filter::linear, address::repeat);

    float4 diffuseColor = diffuseTexture.sample(sam, in.texCoord);
    float4 specularColor = specularTexture.sample(sam, in.texCoord);

    return float4(phongLighting(in.worldPosition, diffuseColor.rgb, specularColor.r, normalize(in.normal), viewPosition), 1.0);
} // fragment_main
