//
//  Lightings.metal
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/09.
//

#include <metal_stdlib>
#include "Uniform.metal"

using namespace metal;

// MARK: - ambient_Lighting
inline float3 ambient_Lighting(float3 ambientOfLight, float3 ambientOfMaterial) {
    return ambientOfLight * ambientOfMaterial;
} // ambient_Lighting

// MARK: - diffuse_Lighting
inline float3 diffuse_Lighting(float3 normal, float3 lightDir, float3 diffuseOfLight, float3 diffuseOfMaterial) {
    float diffuseStrength = max(dot(normal, lightDir), 0.0);
    float3 diffuse = diffuseOfLight * (diffuseStrength * diffuseOfMaterial);
    
    return diffuse;
} // diffuse_Lighting

// MARK: - specular_Lighting
inline float3 specular_Lighting(float3 fragPosition, float3 viewPosition, float3 lightDir,
                               float3 normal, float3 specularOfLight, float3 specularOfMaterial) {
    float3 viewDir = normalize(viewPosition - fragPosition);
    float3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 64);
    float3 specular = (spec * specularOfMaterial) * specularOfLight;
    
    return specular;
} // specular_Lighting

// MARK: - phong_Lighting
inline float3 phong_Lighting(float3 fragPosition, float3 viewPosition, float3 normal,
                            float3 lightPosition, LightUniforms lightUniforms, MaterialUniforms materialUniforms) {
    
    float3 lightDir = normalize(lightPosition - fragPosition);
    
    return ambient_Lighting(lightUniforms.diffuse, materialUniforms.diffuse) + diffuse_Lighting(normal, lightDir, lightUniforms.diffuse, materialUniforms.diffuse) + specular_Lighting(fragPosition, viewPosition, lightDir, normal, lightUniforms.specular, materialUniforms.specular);
} // phong_Lighting
