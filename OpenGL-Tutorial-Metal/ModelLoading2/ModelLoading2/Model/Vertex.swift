//
//  Vertex.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import Foundation
import simd

// MARK: - Vertex
struct Vertex {
    var position: simd_float3
    var texCoord: simd_float2
    var normal: simd_float3
    var tangent: simd_float4
} // Vertex
