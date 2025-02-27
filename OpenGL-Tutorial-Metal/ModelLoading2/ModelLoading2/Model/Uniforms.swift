//
//  Uniforms.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/25.
//

import MetalKit

// MARK: - ModelUniform
struct ModelUniform {
    var modelMatrix: simd_float4x4
    var normalMatrix: simd_float3x3
    
    init(position: simd_float3,
         angle: Float,
         axis: simd_float3,
         scales: simd_float3) {
        self.modelMatrix = matrix_identity_float4x4
        self.modelMatrix.translate(position: position)
        self.modelMatrix.rotate(angle: angle.toRadians(), axis: axis)
        self.modelMatrix.scales(scale: scales)
        self.normalMatrix = self.modelMatrix.conversion_3x3().inverse.transpose
    } // init
    
} // ModelUniform

// MARK: - ViewUniform
struct ViewUniform {
    var viewMatrix: simd_float4x4
    var projectionMatrix: simd_float4x4
    
    init(viewMatrix: simd_float4x4,
         projectionMatrix: simd_float4x4) {
        self.viewMatrix = viewMatrix
        self.projectionMatrix = projectionMatrix
    } // init
    
} // ViewUniform

// MARK: - LightUniform
struct LightUniform {
    var position: simd_float3
    var direction: simd_float3
    var ambient: simd_float3
    var diffuse: simd_float3
    var specular: simd_float3
    
    init(position: simd_float3, direction: simd_float3, ambient: simd_float3,
         diffuse: simd_float3, specular: simd_float3) {
        self.position = position
        self.direction = direction
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
    } // init
    
} // LightUniform

// MARK: - MaterialStateUniform
struct MaterialStateUniform {
    var hasDiffuseTexture: Bool
    var hasSpecularTexture: Bool
    var hasNormalTexture: Bool
    var hasRoughnessTexture: Bool
    var hasAoTexture: Bool
    
    init(textures: [MTLTexture?]) {
        self.hasDiffuseTexture = textures[MaterialIndex.diffuseTexture.rawValue] != nil
        self.hasSpecularTexture = textures[MaterialIndex.specularTexture.rawValue] != nil
        self.hasNormalTexture = textures[MaterialIndex.normalTexture.rawValue] != nil
        self.hasRoughnessTexture = textures[MaterialIndex.roughnessTexture.rawValue] != nil
        self.hasAoTexture = textures[MaterialIndex.aoTexture.rawValue] != nil
    } // init

} // MaterialStateUniform

// MARK: - FragmentBufferIndex
enum FragmentBufferIndex: Int {
    case lightUniform
    case materialStateUniform
} // FragmentBufferIndex
