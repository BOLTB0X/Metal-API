//
//  Vertex.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import Foundation
import simd

// MARK: - Vertex
struct Vertex {
    var position: simd_float3
    var color: simd_float3
    var texCoord: simd_float2
}

// MARK: - Camera
struct Camera {
    var position: simd_float3
    var zoomLevel: Float
    var panDelta: simd_float2
}
