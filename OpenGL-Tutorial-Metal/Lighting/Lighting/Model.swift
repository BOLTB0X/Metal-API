//
//  Model.swift
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/24.
//

import Foundation
import simd

// MARK: - Vertex
struct Vertex {
    var position: simd_float3
    var normal: simd_float3
} // Vertex

// MARK: - Colors
struct Colors {
    var lightCoor: simd_float3
    var objectColor: simd_float3
} // Colors

// MARK: - Uniforms
struct Uniforms {
    var modelMatrix: simd_float4x4
    var viewProjectionMatrix: simd_float4x4
    var lightDirection: simd_float3 // 조명의 방향
} // Uniforms
