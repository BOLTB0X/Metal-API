//
//  RendererResources.swift
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/26.
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
        BasicVertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
        
        // Right
        BasicVertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0)),
        
        // Bottom
        BasicVertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        
        // Top
        BasicVertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0)),
    ]
    
    // cubeIndices
    static let cubeIndices: [UInt16] = [
        //Front
        0, 3, 2,
        2, 1, 0,
        
        //Back
        4, 5, 6,
        6, 7 ,4,
        
        //Left
        11, 8, 9,
        9, 10, 11,
        
        //Right
        12, 13, 14,
        14, 15, 12,
        
        //Bottom
        16, 17, 18,
        18, 19, 16,
        
        //Top
        20, 21, 22,
        22, 23, 20
    ]
    
    // cubePositions
    static let cubePositions: [simd_float3] = [
        simd_float3(0.0, 0.0, 0.0),   // 중앙
        simd_float3(0.5, -0.5, -0.5)
    ]
    
    // lightColors
    static let lightColors: [ColorVertex] = [
        ColorVertex(lightColor: simd_float3(1.0, 1.0, 1.0), objectColor: simd_float3(1.0, 0.5, 0.31)),
        ColorVertex(lightColor: simd_float3(1.2, 1.0, 2.0),objectColor: simd_float3(1.0, 0.5, 0.31))
    ]
    
} // RendererResources

