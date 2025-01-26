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
    var modelViewMatrix: simd_float4x4
} // TransformUniforms

// MARK: - LightUniforms
struct LightUniforms {
    var lightPosition: simd_float3
    var cameraPosition: simd_float3
    var lightColor: simd_float3
    var objectColor: simd_float3
} // LightUniforms
