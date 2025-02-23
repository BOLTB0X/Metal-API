//
//  Extension+simd_float4x4.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/19.
//

import Foundation
import simd

extension simd_float4x4 {
    // MARK: - Identity Matrix 생성
    static func identity() -> simd_float4x4 {
        return matrix_identity_float4x4
    } // identity
    
    // MARK: - conversion_3x3
    mutating func conversion_3x3() -> simd_float3x3 {
        return simd_float3x3(
            simd_float3(columns.0.x, columns.0.y, columns.0.z),
            simd_float3(columns.1.x, columns.1.y, columns.1.z),
            simd_float3(columns.2.x, columns.2.y, columns.2.z)
        )
    } // conversion_3x3
    
    // MARK: - translate
    mutating func translate(position: simd_float3) {
        self[3] = self[0] * position.x + self[1] * position.y + self[2] * position.z + self[3];
    } // translate
    
    // MARK: - rotate
    mutating func rotate(angle: Float, axis: simd_float3) {
        let normalizedAxis = normalize(axis)
        let cosTheta = cos(angle)
        let sinTheta = sin(angle)
        
        let ux = normalizedAxis.x
        let uy = normalizedAxis.y
        let uz = normalizedAxis.z
        
        let rotationMatrix = simd_float4x4(
            simd_float4(
                cosTheta + ux * ux * (1 - cosTheta),
                ux * uy * (1 - cosTheta) - uz * sinTheta,
                ux * uz * (1 - cosTheta) + uy * sinTheta,
                0
            ),
            simd_float4(
                uy * ux * (1 - cosTheta) + uz * sinTheta,
                cosTheta + uy * uy * (1 - cosTheta),
                uy * uz * (1 - cosTheta) - ux * sinTheta,
                0
            ),
            simd_float4(
                uz * ux * (1 - cosTheta) - uy * sinTheta,
                uz * uy * (1 - cosTheta) + ux * sinTheta,
                cosTheta + uz * uz * (1 - cosTheta),
                0
            ),
            simd_float4(0, 0, 0, 1)
        )
        
        self *= rotationMatrix
        return
    } // rotate
    
    // MARK: - scales
    mutating func scales(scale: simd_float3) {
        self[0] *= scale.x
        self[1] *= scale.y
        self[2] *= scale.z
        return
    } // scales
    
    // MARK: - lookAt
    // 카메라의 View Matrix를 생성하는 함수
    // eyePosition: 카메라 위치
    // targetPosition: 타겟 위치(카메라가 바라보는 위치
    // upVec: 위쪽
    static func lookAt(eyePosition: simd_float3, targetPosition: simd_float3, upVec: simd_float3) -> simd_float4x4 {
        let forward = normalize(targetPosition - eyePosition)
        let rightVec = normalize(simd_cross(upVec, forward))
        let up = simd_cross(forward, rightVec)
        
        var matrix = matrix_identity_float4x4
        matrix[0][0] = rightVec.x
        matrix[1][0] = rightVec.y
        matrix[2][0] = rightVec.z
        matrix[0][1] = up.x
        matrix[1][1] = up.y
        matrix[2][1] = up.z
        matrix[0][2] = forward.x
        matrix[1][2] = forward.y
        matrix[2][2] = forward.z
        matrix[3][0] = -dot(rightVec, eyePosition)
        matrix[3][1] = -dot(up, eyePosition)
        matrix[3][2] = -dot(forward, eyePosition)
        
        return matrix
    } // lookAt
    
    // MARK: - perspective
    // 투영 행렬(Projection Matrix)을 생성하는 함수
    static func perspective(fov: Float, aspectRatio: Float, nearPlane: Float, farPlane: Float) -> simd_float4x4 {
        let tanHalfFov = tan(fov / 2.0)
        
        var matrix = simd_float4x4(0.0)
        matrix[0][0] = 1.0 / (aspectRatio * tanHalfFov)
        matrix[1][1] = 1.0 / (tanHalfFov)
        matrix[2][2] = farPlane / (farPlane - nearPlane)
        matrix[2][3] = 1.0
        matrix[3][2] = -(farPlane * nearPlane) / (farPlane - nearPlane)
        
        return matrix
    } // perspective
    
}
