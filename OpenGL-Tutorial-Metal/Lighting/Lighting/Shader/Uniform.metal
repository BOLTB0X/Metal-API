//
//  CommonStruct.metal
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/23.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - TransformUniforms
struct TransformUniforms {
    float4x4 projectionMatrix;
    float4x4 modelViewMatrix;
}; // TransformUniforms

// MARK: - LightUniforms
struct LightUniforms {
    float3 lightPosition;
    float3 cameraPosition;
    float3 lightColor;
    float3 objectColor;
}; // LightUniforms
