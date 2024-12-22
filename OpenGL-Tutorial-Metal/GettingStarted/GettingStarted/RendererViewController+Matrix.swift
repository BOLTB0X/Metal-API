//
//  RendererViewController+Matrix.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import Foundation
import MetalKit
import simd

extension RendererViewController {
    // MARK: - createProjectionMatrix
    func createProjectionMatrix(aspect: Float) -> simd_float4x4 {
        let fovy: Float = 45.0 * (.pi / 180.0) // 수직 시야각
        let near: Float = 0.1
        let far: Float = 100.0
        
        let yScale = 1 / tan(fovy / 2) // y축 스케일
        let xScale = yScale / aspect   // x축 스케일
        let zRange = far - near
        let zScale = -(far + near) / zRange
        let wzScale = -2 * far * near / zRange
        
        return simd_float4x4(
            simd_float4(xScale, 0, 0, 0),
            simd_float4(0, yScale, 0, 0),
            simd_float4(0, 0, zScale, -1),
            simd_float4(0, 0, wzScale, 0)
        )
    } // createProjectionMatrix

    // MARK: - createViewMatrix
    func createViewMatrix() -> simd_float4x4 {
        let eye = simd_float3(0.0, 0.0, 3.0)  // 카메라 위치
        let center = simd_float3(0.0, 0.0, 0.0) // 카메라가 바라보는 지점
        let up = simd_float3(0.0, 1.0, 0.0)  // 카메라 상단 방향
        return simd_float4x4.lookAt(eye: eye, center: center, up: up)
    } // createViewMatrix

    // MARK: - createModelMatrix
    func createModelMatrix() -> simd_float4x4 {
        return simd_float4x4(1.0) * simd_float4x4.rotate(angle: .pi / 4, axis: simd_float3(1, 0, 0))
    } // createModelMatrix
    
}
