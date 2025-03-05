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
    var viewMatrix: simd_float4x4
    var projectionMatrix: simd_float4x4
    
    init(viewMatrix: simd_float4x4,
         projectionMatrix: simd_float4x4) {
        self.viewMatrix = viewMatrix
        self.projectionMatrix = projectionMatrix
    } // init
    
} // LightUniform

// MARK: - MaterialStateUniform
struct MaterialStateUniform {
    var hasDiffuseTexture: Bool
    var hasSpecularTexture: Bool
    var hasNormalTexture: Bool
    
    init(diffuseTexture: MTLTexture?,
         specularTexture: MTLTexture?,
         normalTexture: MTLTexture?) {
        self.hasDiffuseTexture = diffuseTexture != nil
        self.hasSpecularTexture = specularTexture != nil
        self.hasNormalTexture = normalTexture != nil
    } // init

} // MaterialStateUniform

// MARK: - FragmentBufferIndex
enum FragmentBufferIndex: Int {
    case lightUniform
    case materialStateUniform
    case cameraPosition
} // FragmentBufferIndex
