//
//  Lightings.metal
//  Lighting
//
//  Created by KyungHeon Lee on 2025/02/09.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - diffuseLighting
inline float3 diffuseLighting(float3 normal, float3 lightDir, float3 lightColor) {
    float diffuseStrength = max(dot(normal, -lightDir), 0.0);
    float3 diffuse = diffuseStrength * lightColor;
    
    return diffuse;
} // diffuseLighting

// MARK: - specularLighting
inline float3 specularLighting(float3 fragPosition, float3 viewPosition, float3 lightDir,
                               float3 normal, float3 lightColor) {
    float3 viewDir = normalize(fragPosition - viewPosition);
    float3 reflectDir = reflect(lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    float3 specular = spec * lightColor;
    
    return specular;
} // specularLighting

// MARK: - phongLighting
inline float3 phongLighting(float3 ambient, float3 fragPosition, float3 lightPosition,
                            float3 viewPosition, float3 normal, float3 lightColor) {
    
    float3 lightDir = normalize(fragPosition - lightPosition);
    
    return ambient + diffuseLighting(normal, lightDir, lightColor) + specularLighting(fragPosition, viewPosition, lightDir, normal, lightColor);
} // phongLighting
