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

constant float3 lightDirection = float3(0.436436, -0.572872, 0.218218);
constant float3 lightAmbient = float3(0.4);
constant float3 lightDiffuse = float3(1.0);
constant float3 lightSpecular = float3(0.8);

// MARK: - calcPhongLight
inline float4 calcPhongLight(float4 diffuseColor,
                             float4 specularColor,
                             float3 worldPosition,
                             float3 norm,
                             float3 cameraPosition,
                             float visibility) {
    float3 ambient = lightAmbient * diffuseColor.rgb;
    
    float diff = max(dot(norm, -lightDirection), 0.0);
    float3 diffuse = diff * lightDiffuse * diffuseColor.rgb;
    
    float3 viewDir = normalize(cameraPosition - worldPosition);
    float3 reflectDir = reflect(lightDirection, norm);
    float spec = pow(max(dot(reflectDir, viewDir), 0.0), 64.0);
    float3 specular = spec * lightSpecular * specularColor.r;
    
    return float4(ambient + (diffuse + specular) * visibility, 1.0);
} // calcPhongLight

// MARK: - vertexFunction
vertex VertexOut vertexFunction(VertexIn in [[stage_in]],
                                constant ViewUniform& viewUniform [[buffer(vertexBufferIndexView)]],
                                constant ModelUniform& modelUniform [[buffer(vertexBufferIndexModel)]]) {
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

// MARK: - shadow_VertexFunction
vertex float4 shadow_VertexFunction(VertexIn in [[stage_in]],
                                    constant LightUniform& lightUniform [[buffer(vertexBufferIndexView)]],
                                    constant ModelUniform& modelUniform [[buffer(vertexBufferIndexModel)]]) {
    float3 worldPosition = (modelUniform.modelMatrix * float4(in.position, 1.0)).xyz;
    float4 position = (lightUniform.viewMatrix * lightUniform.projectionMatrix) * float4(worldPosition, 1.0);
    
    return position;
} // shadow_VertexFunction

// MARK: - fragmentFunction
fragment float4 fragmentFunction(VertexOut in [[stage_in]],
                                 depth2d<float> shadowMap [[texture(textureIndexShadow)]],
                                 texture2d<float> diffuseTexture [[texture(textureIndexDiffuse)]],
                                 texture2d<float> specularTexture [[texture(textureIndexSpecular)]],
                                 texture2d<float> normalTexture [[texture(textureIndexNormal)]],
                                 sampler shadowSampler [[sampler(0)]],
                                 constant LightUniform& lightUniform [[buffer(fragmentBufferIndexLight)]],
                                 constant MaterialStateUniform& stateUniform [[buffer(fragmentBufferIndexMaterialState)]],
                                 constant float3& cameraPosition [[buffer(fragmentBufferIndexCamera)]]) {
    constexpr sampler colorSampler(mip_filter::linear, mag_filter::linear, min_filter::linear, address::repeat);

    float4 diffuseColor = (stateUniform.hasDiffuseTexture ? diffuseTexture.sample(colorSampler, in.texCoord) : float4(1.0));
    float4 specularColor = (stateUniform.hasSpecularTexture ? specularTexture.sample(colorSampler, in.texCoord) : float4(1.0));
    float4 normalColor = (stateUniform.hasNormalTexture ? normalTexture.sample(colorSampler, in.texCoord) : float4(0.5, 0.5, 1.0, 1.0));
    
    // normal
    normalColor = normalize(normalColor * 2.0 - 1.0);
    float3x3 TBN = float3x3(in.T, in.B, in.N);
    float3 normal = normalize(TBN * normalColor.rgb);
    
    // shadow
    float4 positionInLightSpace = (lightUniform.projectionMatrix * lightUniform.viewMatrix) * float4(in.worldPosition, 1.0);
    positionInLightSpace.xyz /= positionInLightSpace.w;
    float2 lightSpaceCoord = positionInLightSpace.xy * 0.5 + 0.5;
    lightSpaceCoord.y = 1.0 - lightSpaceCoord.y;
    float lightDepth = shadowMap.sample(colorSampler, lightSpaceCoord);
    float visibility = 1.0;
    if (positionInLightSpace.z > lightDepth) {
        visibility = 0.0;
    }
        
    return calcPhongLight(diffuseColor, specularColor, in.worldPosition, normal, cameraPosition, visibility);
} // fragmentFunction

// MARK: - shadow_FragmentFunction
fragment void shadow_FragmentFunction() {
    return;
}
