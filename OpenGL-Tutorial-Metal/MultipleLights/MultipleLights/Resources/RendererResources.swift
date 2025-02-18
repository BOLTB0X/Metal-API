//
//  RendererResources.swift
//  MultipleLights
//
//  Created by KyungHeon Lee on 2025/02/18.
//

import Foundation
import simd

// MARK: - RendererResources
struct RendererResources {
    // cubeVertices
    static let cubeVertices: [BasicVertex] = [
        // Front
        BasicVertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0), texCoord: simd_float2(0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0), texCoord: simd_float2(1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0), texCoord: simd_float2(1.0, 1.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0), texCoord: simd_float2(0.0, 1.0)),
        
        // Back
        BasicVertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0), texCoord: simd_float2(0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0), texCoord: simd_float2(1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0), texCoord: simd_float2(1.0, 1.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0), texCoord: simd_float2(0.0, 1.0)),
        
        // Left
        BasicVertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0), texCoord: simd_float2(1.0, 1.0)),
        BasicVertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0), texCoord: simd_float2(1.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0), texCoord: simd_float2(0.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0), texCoord: simd_float2(0.0, 1.0)),
        
        // Right
        BasicVertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0), texCoord: simd_float2(0.0, 1.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0), texCoord: simd_float2(0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0), texCoord: simd_float2(1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0), texCoord: simd_float2(1.0, 1.0)),
        
        // Bottom
        BasicVertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0), texCoord: simd_float2(0.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0), texCoord: simd_float2(1.0, 0.0)),
        BasicVertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0), texCoord: simd_float2(1.0, 1.0)),
        BasicVertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0), texCoord: simd_float2(0.0, 1.0)),
        
        // Top
        BasicVertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0), texCoord: simd_float2(0.0, 1.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0), texCoord: simd_float2(1.0, 1.0)),
        BasicVertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0), texCoord: simd_float2(1.0, 0.0)),
        BasicVertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0), texCoord: simd_float2(0.0, 0.0)),
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
        simd_float3( 0.0,  0.0,  0.0),
        simd_float3( 2.0,  -3.0, -3.0),
        simd_float3(-1.5, -2.2, -2.5),
        simd_float3(-3.8, -2.0, 0.3),
        simd_float3( 2.4, -0.4, -3.5),
        simd_float3(-1.7,  3.0, 2.5),
        simd_float3( 1.3, -2.0, -2.5),
        simd_float3( 1.5,  2.0, -2.5),
        simd_float3( 1.5,  0.2, -1.5),
        simd_float3(-1.3,  1.0, -1.5)
    ]
    
    // pointLights
    static let pointLights: [PointLight] = [
        PointLight(
            position: simd_float3(0.7, 0.2, 2.0),
            constants: simd_float3(1.0, 0.0, 0.0), linears: simd_float3(0.09, 0.0, 0.0),
            quadratics: simd_float3(0.032, 0.0, 0.0),
            ambient: simd_float3(0.05, 0.05, 0.05), diffuse: simd_float3(0.8, 0.8, 0.8),
            specular: simd_float3(1.0, 1.0, 1.0)),
        PointLight(
            position: simd_float3(1.3, -1.7, 0.0),
            constants: simd_float3(1.0, 0.0, 0.0), linears: simd_float3(0.09, 0.0, 0.0),
            quadratics: simd_float3(0.032, 0.0, 0.0),
            ambient: simd_float3(0.05, 0.05, 0.05), diffuse: simd_float3(0.8, 0.8, 0.8),
            specular: simd_float3(1.0, 1.0, 1.0)),
        PointLight(
            position: simd_float3(-2.0, 1.0, -1.0),
            constants: simd_float3(1.0, 0.0, 0.0), linears: simd_float3(0.09, 0.0, 0.0),
            quadratics: simd_float3(0.032, 0.0, 0.0),
            ambient: simd_float3(0.05, 0.05, 0.05), diffuse: simd_float3(0.8, 0.8, 0.8),
            specular: simd_float3(1.0, 1.0, 1.0)),
        PointLight(
            position: simd_float3(0.0, 0.0, -3.0),
            constants: simd_float3(1.0, 0.0, 0.0), linears: simd_float3(0.09, 0.0, 0.0),
            quadratics: simd_float3(0.032, 0.0, 0.0),
            ambient: simd_float3(0.05, 0.05, 0.05), diffuse: simd_float3(0.8, 0.8, 0.8),
            specular: simd_float3(1.0, 1.0, 1.0))
    ] // pointLights
    
    // dirLight
    static let dirLight: DirLight = DirLight(direction: simd_float3(-0.2, -1.0, -0.3), ambient: simd_float3(0.05, 0.05, 0.05), diffuse: simd_float3(0.4, 0.4, 0.4), specular: simd_float3(0.5, 0.5, 0.5))
    
} // RendererResources
