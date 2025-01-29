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
    
    init(position: simd_float3, normal: simd_float3) {
        self.position = position
        self.normal = normal
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

