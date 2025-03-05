//
//  Uniforms.metal
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/25.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - ModelUniform
struct ModelUniform {
    float4x4 modelMatrix;
    float3x3 normalMatrix;
}; // ModelUniform

// MARK: - ViewUniform
struct ViewUniform {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
}; // ViewUniform

// MARK: - LightUniform
struct LightUniform {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
}; // LightUniform

// MARK: - MaterialStateUniform
struct MaterialStateUniform {
    bool hasDiffuseTexture;
    bool hasSpecularTexture;
    bool hasNormalTexture;
}; // MaterialStateUniform

// MARK: - TextureIndex
enum TextureIndex {
    textureIndexShadow,
    textureIndexDiffuse,
    textureIndexSpecular,
    textureIndexNormal,
}; // TextureIndex

// MARK: - FragmentBufferIndex
enum FragmentBufferIndex {
    fragmentBufferIndexLight,
    fragmentBufferIndexMaterialState,
    fragmentBufferIndexCamera
}; // FragmentBufferIndex
