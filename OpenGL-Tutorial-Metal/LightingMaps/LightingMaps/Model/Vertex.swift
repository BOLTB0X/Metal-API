//
//  Vertex.swift
//  LightingMaps
//
//  Created by KyungHeon Lee on 2025/02/06.
//

import Foundation
import simd

// MARK: - BasicVertex
struct BasicVertex {
    let position: simd_float3
    let normal: simd_float3
    let texCoord: simd_float2
    
    init(position: simd_float3, normal: simd_float3, texCoord: simd_float2) {
        self.position = position
        self.normal = normal
        self.texCoord = texCoord
    } // init
    
} // BasicVertex

// MARK: - ColorVertex
struct ColorVertex {
    let lightColor: simd_float3
    let objectColor: simd_float3
    
    init(lightColor: simd_float3, objectColor: simd_float3) {
        self.lightColor = lightColor
        self.objectColor = objectColor
    } // init
    
} // ColorVertex
