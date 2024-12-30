//
//  RendererViewController+Camera.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/30.
//

import Foundation
import simd

extension RendererViewController {
    // MARK: - lookAt
    public func lookAt(eye: simd_float3, target: simd_float3, up: simd_float3) -> simd_float4x4 {
        let forward = normalize(target - eye)  // 카메라가 바라보는 방향 벡터
        let right = normalize(cross(up, forward))  // 오른쪽 벡터
        let upAdjusted = cross(forward, right)  // 상단 벡터
        
        return simd_float4x4(
            simd_float4(right.x, upAdjusted.x, -forward.x, 0),
            simd_float4(right.y, upAdjusted.y, -forward.y, 0),
            simd_float4(right.z, upAdjusted.z, -forward.z, 0),
            simd_float4(-dot(right, eye), -dot(upAdjusted, eye), dot(forward, eye), 1)
        )
    } // lookAt
}
