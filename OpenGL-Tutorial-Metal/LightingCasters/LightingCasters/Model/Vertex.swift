//
//  Vertex.swift
//  LightingCasters
//
//  Created by KyungHeon Lee on 2025/02/15.
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
