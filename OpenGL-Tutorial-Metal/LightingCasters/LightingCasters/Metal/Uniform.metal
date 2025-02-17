//
//  Uniform.metal
//  LightingCasters
//
//  Created by KyungHeon Lee on 2025/02/15.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - TransformUniforms
struct TransformUniforms {
    float4x4 projectionMatrix;
    float4x4 modelMatrix;
    float4x4 viewMatrix;
}; // TransformUniforms

// MARK: - LightUniforms
struct LightUniforms {
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
}; // LightUniforms
