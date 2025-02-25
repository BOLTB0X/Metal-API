//
//  Shaders.metal
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

#include <metal_stdlib>
#include "Vertexs.metal"
#include "Uniforms.metal"
using namespace metal;

// MARK: - calcPhongLight
inline float4 calcPhongLight(LightUniform light,
                             float4 diffuseColor,
                             float4 specularColor,
                             float3 norm,
                             float3 viewDir) {
    float3 ambient = light.ambient * diffuseColor.rgb;
    
    float3 lightDir = normalize(light.direction);
    float diff = max(dot(norm, lightDir), 0.0);
    float3 diffuse = diff * light.diffuse * diffuseColor.rgb;
    
    float3 reflectDir = reflect(lightDir, norm);
    float spec = pow(max(dot(reflectDir, viewDir), 0.0), 32.0);
    float3 specular = spec * light.specular * specularColor.rgb;
    
    return float4(ambient + diffuse + specular, 1.0);
} // calcPhongLight

// MARK: - applyLight
inline float4 applyLight(LightUniform light,
                         float4 diffuseColor,
                         float4 specularColor,
                         float3 norm,
                         float3 worldPosition) {
    float3 viewDir = normalize(light.position - worldPosition);
    return calcPhongLight(light, diffuseColor, specularColor, norm, viewDir);
} // applyLight

// MARK: - applyNormalmaps
inline float4 applyNormalmaps(LightUniform light,
                              float4 diffuseColor,
                              float4 specularColor,
                              float4 normalColor,
                              float3x3 TBN,
                              float3 worldPosition) {
    float3 viewDir = normalize(light.position - worldPosition);
    normalColor = normalize(normalColor * 2.0 - 1.0); // Transform from [0...1] to [-1...1]
    float3 norm = normalize(TBN * normalColor.rgb);
    
    return calcPhongLight(light, diffuseColor, specularColor, norm, viewDir);
} // applyNormalmaps

// MARK: - vertexFunction
vertex VertexOut vertexFunction(VertexIn in [[stage_in]],
                                constant ViewUniform& viewUniform [[buffer(0)]],
                                constant ModelUniform& modelUniform [[buffer(1)]]) {
    VertexOut out;
    out.worldPosition = (modelUniform.modelMatrix * float4(in.position, 1.0)).xyz;
    out.position = viewUniform.projectionMatrix * viewUniform.viewMatrix * float4(out.worldPosition, 1.0);
    out.texCoord = in.texCoord;
    out.normal = in.normal;
    
    float3 T = normalize(modelUniform.normalMatrix * in.tangent.xyz);
    float3 N = normalize(modelUniform.normalMatrix * in.normal);
    
    T = normalize(T - dot(T, N) * N);
    
    float3 B = cross(N, T) * in.tangent.w;
    
    out.T = T;
    out.B = B;
    out.N = N;
    
    return out;
} // vertexFunction

// MARK: - fragmentFunction
fragment float4 fragmentFunction(VertexOut in [[stage_in]],
                                 texture2d<float> diffuseTexture [[texture(0)]],
                                 texture2d<float> specularTexture [[texture(1)]],
                                 texture2d<float> normalTexture [[texture(2)]],
                                 constant LightUniform& lightUniform [[buffer(0)]],
                                 constant MaterialStateUniform& stateUniform [[buffer(1)]]) {
    constexpr sampler colorSampler(mip_filter::linear, mag_filter::linear, min_filter::linear, address::repeat);

    float4 diffuseColor = (stateUniform.hasDiffuseTexture ? diffuseTexture.sample(colorSampler, in.texCoord) : float4(1.0));
    float4 specularColor = (stateUniform.hasSpecularTexture ? specularTexture.sample(colorSampler, in.texCoord) : float4(1.0));
    float4 normalColor = (stateUniform.hasNormalTexture ? normalTexture.sample(colorSampler, in.texCoord) : float4(1.0));
        
    //float4 res1 = applyLight(lightUniform, diffuseColor, specularColor, normalize(in.normal), in.worldPosition);
    float4 res2 = applyNormalmaps(lightUniform, diffuseColor, specularColor, normalColor, float3x3(in.T, in.B, in.N), in.worldPosition);

    return res2;
} // fragmentFunction
