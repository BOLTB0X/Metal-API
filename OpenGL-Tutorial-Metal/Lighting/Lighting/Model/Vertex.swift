//
//  Vertex.swift
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/24.
//

import Foundation
import simd

// MARK: - BasicVertex
struct BasicVertex {
    let position: simd_float3
    let normal: simd_float3
} // BasicVertex

// MARK: - ColorVertex
struct ColorVertex {
    let lightColor: simd_float3
    let objectColor: simd_float3
} // ColorVertex

