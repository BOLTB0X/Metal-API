//
//  simd_float4x4.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/21.
//

import Foundation
import simd

extension simd_float4x4 {
    // MARK: - perspective
    //aspect: 화면의 종횡비 (가로/세로)
    //fovy: 시야각(Field of View, Y축 기준)
    //near, far: 카메라의 절두체 클리핑 평면 (렌더링 범위)
    static func perspective(aspect: Float, fovy: Float, near: Float, far: Float) -> simd_float4x4 {
        let yScale = 1 / tan(fovy * 0.5)
        let xScale = yScale / aspect
        let zRange = far - near
        let zScale = -(far + near) / zRange
        let wzScale = -2 * far * near / zRange
        
        return simd_float4x4(
            simd_float4(xScale, 0, 0, 0),
            simd_float4(0, yScale, 0, 0),
            simd_float4(0, 0, zScale, -1),
            simd_float4(0, 0, wzScale, 0)
        )
    } // perspective

    // MARK: - lookAt
    static func lookAt(eye: simd_float3, center: simd_float3, up: simd_float3) -> simd_float4x4 {
        let zAxis = normalize(eye - center)
        let xAxis = normalize(cross(up, zAxis))
        let yAxis = cross(zAxis, xAxis)
        
        return simd_float4x4(
            simd_float4(xAxis.x, yAxis.x, zAxis.x, 0),
            simd_float4(xAxis.y, yAxis.y, zAxis.y, 0),
            simd_float4(xAxis.z, yAxis.z, zAxis.z, 0),
            simd_float4(-dot(xAxis, eye), -dot(yAxis, eye), -dot(zAxis, eye), 1)
        )
    } // lookAt

    // MARK: - rotate
    static func rotate(angle: Float, axis: simd_float3) -> simd_float4x4 {
        let normalizedAxis = normalize(axis)
        let x = normalizedAxis.x, y = normalizedAxis.y, z = normalizedAxis.z
        let c = cos(angle), s = sin(angle)
        let t = 1 - c
        
        return simd_float4x4(
            simd_float4(t * x * x + c, t * x * y - s * z, t * x * z + s * y, 0),
            simd_float4(t * x * y + s * z, t * y * y + c, t * y * z - s * x, 0),
            simd_float4(t * x * z - s * y, t * y * z + s * x, t * z * z + c, 0),
            simd_float4(0, 0, 0, 1)
        )
    } // rotate
    
    // MARK: - translate
    static func translate(x: Float, y: Float, z: Float) -> simd_float4x4 {
        return simd_float4x4(
                simd_float4(1, 0, 0, 0),
                simd_float4(0, 1, 0, 0),
                simd_float4(0, 0, 1, 0),
                simd_float4(x, y, z, 1)
            )
    } // translate
}
