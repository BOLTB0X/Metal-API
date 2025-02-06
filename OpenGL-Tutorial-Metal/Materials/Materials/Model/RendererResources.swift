//
//  RendererResources.swift
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/04.
//

import Foundation
import simd

// MARK: - RendererResources
struct RendererResources {
    // cubeVertices
    static let cubeVertices: [BasicVertex] = [
        // Front
        BasicVertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
        
        // Back
        BasicVertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
        
        // Left
        BasicVertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        
        // Right
        BasicVertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        
        // Top
        BasicVertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        
        // Bottom
        BasicVertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0)),
    ]
    
    // cubeIndices
    static let cubeIndices: [UInt16] = [
        0, 1, 2,  2, 3, 0,        // Front
        4, 5, 6,  6, 7, 4,        // Back
        8, 9, 10,  10, 11, 8,     // Left
        12, 13, 14,  14, 15, 12,  // Right
        16, 17, 18,  18, 19, 16,  // Top
        20, 21, 22,  22, 23, 20   // Bottom
    ]
    
    // cubePositions
    static let cubePositions: [simd_float3] = [
        simd_float3(0.3, 0.0, 0.0),   // 중앙
        //simd_float3(-0.3, 0.3, -1.2)
    ]
        
    // viewMatrix
    static var viewMatrix = simd_float4x4.lookAt(
        eyePosition: simd_float3(5, -5, 8),
        targetPosition: simd_float3(0.0, 0.0, 0.0),
        upVec: simd_float3(0.0, 1.0, 0.0)
    )
    
} // RendererResources
