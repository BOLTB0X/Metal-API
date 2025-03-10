//
//  Uniform.metal
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/04.
//

#include <metal_stdlib>
using namespace metal;

#ifndef COMMON_METAL
#define COMMON_METAL

// MARK: - TransformUniforms
struct TransformUniforms {
    float4x4 projectionMatrix;
    float4x4 modelMatrix;
    float4x4 viewMatrix;
}; // TransformUniforms

// MARK: - LightUniforms
struct LightUniforms {
    float3 lightPosition;
    float3 cameraPosition;
    float3 ambient;
    float3 diffuse;
    float3 specular;
}; // LightUniforms

// MARK: - MeterialUniforms
struct MaterialUniforms {
    float3 ambient;
    float3 diffuse;
    float3 specular;
}; // MeterialUniforms

#endif // COMMON_METAL
