//
//  Uniform.swift
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/26.
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
    var lightPosition: simd_float3
    var cameraPosition: simd_float3
    var lightColor: simd_float3
    var objectColor: simd_float3
    
    init(lightPosition: simd_float3, cameraPosition: simd_float3, lightColor: simd_float3, objectColor: simd_float3) {
        self.lightPosition = lightPosition
        self.cameraPosition = cameraPosition
        self.lightColor = lightColor
        self.objectColor = objectColor
    } // init
    
} // LightUniforms
