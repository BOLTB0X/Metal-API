//
//  Uniform.swift
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/04.
//

import Foundation
import simd

// MARK: - TransformUniforms
struct TransformUniforms {
    var projectionMatrix: simd_float4x4
    var normalMatrix: simd_float3x3
    var modelMatrix: simd_float4x4
    var modelViewMatrix: simd_float4x4
    
    init(projectionMatrix: simd_float4x4, normalMatrix: simd_float3x3, modelMatrix: simd_float4x4, modelViewMatrix: simd_float4x4) {
        self.projectionMatrix = projectionMatrix
        self.normalMatrix = normalMatrix
        self.modelMatrix = modelMatrix
        self.modelViewMatrix = modelViewMatrix
    } // init
    
} // TransformUniforms

// MARK: - LightUniforms
struct LightUniforms {
    var lightPosition: simd_float3
    var cameraPosition: simd_float3
    var ambient: simd_float3
    var diffuse: simd_float3
    var specular: simd_float3
    
    init(lightPosition: simd_float3, cameraPosition: simd_float3, ambient: simd_float3, diffuse: simd_float3, specular: simd_float3) {
        self.lightPosition = lightPosition
        self.cameraPosition = cameraPosition
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
    } // init
    
} // LightUniforms

// MARK: - MaterialUniforms
struct MaterialUniforms {
    var ambient: simd_float3
    var diffuse: simd_float3
    var specular: simd_float3
    
    init(ambient: simd_float3, diffuse: simd_float3, specular: simd_float3) {
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
    } // init
} // MaterialUniforms
