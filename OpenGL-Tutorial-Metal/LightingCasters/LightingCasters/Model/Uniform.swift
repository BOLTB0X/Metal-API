//
//  Uniform.swift
//  LightingCasters
//
//  Created by KyungHeon Lee on 2025/02/15.
//

import Foundation
import simd

// MARK: - TransformUniforms
struct TransformUniforms {
    var projectionMatrix: simd_float4x4
    var modelMatrix: simd_float4x4
    var viewMatrix: simd_float4x4
    
    init(projectionMatrix: simd_float4x4, modelMatrix: simd_float4x4, viewMatrix: simd_float4x4) {
        self.projectionMatrix = projectionMatrix
        self.modelMatrix = modelMatrix
        self.viewMatrix = viewMatrix
    } // init
    
} // TransformUniforms

// MARK: - LightUniforms
struct LightUniforms {
    var direction: simd_float3
    //var lightPosition: simd_float3
    var cameraPosition: simd_float3
    var ambient: simd_float3
    var diffuse: simd_float3
    var specular: simd_float3
    
    init(direction: simd_float3, cameraPosition: simd_float3, ambient: simd_float3, diffuse: simd_float3, specular: simd_float3) {
        self.direction = direction
        self.cameraPosition = cameraPosition
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
    } // init
    
} // LightUniforms
