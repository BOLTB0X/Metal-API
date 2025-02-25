//
//  Uniforms.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/25.
//

import Foundation
import simd

// MARK: - ModelUniform
struct ModelUniform {
    var modelMatrix: simd_float4x4
    var normalMatrix: simd_float3x3
    
    init(modelMatrix: simd_float4x4, normalMatrix: simd_float3x3) {
        self.modelMatrix = modelMatrix
        self.normalMatrix = normalMatrix
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
    
    init(hasDiffuseTexture: Bool, hasSpecularTexture: Bool, hasNormalTexture: Bool) {
        self.hasDiffuseTexture = hasDiffuseTexture
        self.hasSpecularTexture = hasSpecularTexture
        self.hasNormalTexture = hasNormalTexture
    }
} // MaterialStateUniform
