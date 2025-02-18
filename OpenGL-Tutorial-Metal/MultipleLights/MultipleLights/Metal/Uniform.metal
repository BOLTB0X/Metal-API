//
//  Uniform.metal
//  MultipleLights
//
//  Created by KyungHeon Lee on 2025/02/18.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - TransformUniforms
struct TransformUniforms {
    float4x4 projectionMatrix;
    float4x4 modelMatrix;
    float4x4 viewMatrix;
}; // TransformUniforms

// MARK: - SpotLight
struct SpotLight {
    float3 position;
    float3 direction;
    float3 cutOff;
    float3 outerCutOff;
    
    float3 ambient;
    float3 diffuse;
    float3 specular;
    
    float3 constants;
    float3 linears;
    float3 quadratics;
}; // SpotLight

// MARK: - DirLight
struct DirLight {
    float3 direction;
    
    float3 ambient;
    float3 diffuse;
    float3 specular;
}; // DirLight

// MARK: - PointLight
struct PointLight {
    float3 position;
    
    float3 constants;
    float3 linears;
    float3 quadratics;

    float3 ambient;
    float3 diffuse;
    float3 specular;
}; // PointLight

// MARK: - PointLights
struct PointLights {
    PointLight pointLightArr[4];
}; // PointLights
