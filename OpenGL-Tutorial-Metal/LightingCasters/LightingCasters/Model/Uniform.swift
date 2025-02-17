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
    var position: simd_float3
    var direction: simd_float3
    var cutOff: simd_float3
    var outerCutOff: simd_float3
    
    var ambient: simd_float3
    var diffuse: simd_float3
    var specular: simd_float3
    
    var constants: simd_float3
    var linears: simd_float3
    var quadratics: simd_float3
    
    init(position: simd_float3, direction: simd_float3, cutOff: simd_float3, outerCutOff: simd_float3,
         ambient: simd_float3, diffuse: simd_float3, specular: simd_float3,
         constants: simd_float3, linears: simd_float3, quadratics: simd_float3) {
        self.position = position
        self.direction = direction
        self.cutOff = cutOff
        self.outerCutOff = outerCutOff
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
        self.constants = constants
        self.linears = linears
        self.quadratics = quadratics
    } // init
    
} // LightUniforms
