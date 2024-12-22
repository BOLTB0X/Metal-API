//
//  Vertex.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import Foundation
import Metal
import simd

struct Vertex {
    var position: simd_float3
    var color: simd_float3
    var texCoord: simd_float2
}
