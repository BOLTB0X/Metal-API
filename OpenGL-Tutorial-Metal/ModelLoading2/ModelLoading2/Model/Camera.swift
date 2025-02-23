//
//  Camera.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import Foundation
import simd

// MARK: - Camera
class Camera {
    var position = simd_float3(0.0, 0.0, -3.0)
    var direction = simd_float3(0.0, 0.0, 1.0)
    var up = simd_float3(0.0, 1.0, 0.0)
    
    // MARK: - getViewMatrix
    func getViewMatrix() -> simd_float4x4 {
        return simd_float4x4.lookAt(eyePosition: position, targetPosition: position + direction, upVec: up)
    } // getViewMatrix
    
} // Camera
