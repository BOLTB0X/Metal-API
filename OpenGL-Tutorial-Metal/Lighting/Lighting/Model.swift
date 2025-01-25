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
    let position: simd_float3
    let normal: simd_float3
} // Vertex

// MARK: - Colors
struct Colors {
    let lightCoor: simd_float3
    let objectColor: simd_float3
} // Colors

// MARK: - LightUniforms
struct LightUniforms {
    var lightCoor: simd_float3
    var objectColor: simd_float3
    var ambient: simd_float3
} // LightUniforms

// MARK: - RendererResources
struct RendererResources {
    static let cubeVertices: [Vertex] = [
        // Front
        Vertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
        Vertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
        Vertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
        Vertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
        
        // Back
        Vertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
        Vertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
        Vertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
        Vertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
        
        // Left
        Vertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        Vertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        Vertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        Vertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        
        // Right
        Vertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        Vertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        Vertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        Vertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        
        // Top
        Vertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        Vertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        Vertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        Vertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        
        // Bottom
        Vertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        Vertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        Vertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        Vertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0)),
    ]
    
    static let cubeIndices: [UInt16] = [
        0, 1, 2,  2, 3, 0,        // Front
        4, 5, 6,  6, 7, 4,        // Back
        8, 9, 10,  10, 11, 8,     // Left
        12, 13, 14,  14, 15, 12,  // Right
        16, 17, 18,  18, 19, 16,  // Top
        20, 21, 22,  22, 23, 20   // Bottom
    ]
    
    static let cubePositions: [simd_float3] = [
        simd_float3(0.0, 0.0, 0.0),   // 중앙
        simd_float3(-0.3, 0.3, -1.2)
    ]
    
    static var lightColors: [Colors] = [
        Colors(lightCoor: simd_float3(1.0, 1.0, 1.0), objectColor: simd_float3(1.0, 0.5, 0.31)),
        Colors(lightCoor: simd_float3(1.2, 1.0, 2.0),objectColor: simd_float3(1.0, 0.5, 0.31))
    ]
} // RendererResources

