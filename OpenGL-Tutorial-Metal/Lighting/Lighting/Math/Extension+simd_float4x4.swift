//
//  Extension+simd_float4x4.swift
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/25.
//

import Foundation
import simd

extension simd_float4x4 {
    // MARK: - Identity Matrix 생성
    static func identity() -> simd_float4x4 {
        return matrix_identity_float4x4
    }
    
    // MARK: - translate
    mutating func translate(position: simd_float3) {
        self[3] = self[0] * position.x + self[1] * position.y + self[2] * position.z + self[3];
    } // translate
    
    // MARK: - rotate
    // 회전 변환 (축과 각도를 기반으로)
    mutating func rotate(rotation: simd_float3) {
        let quat = simd_quatf(angle: length(rotation), axis: normalize(rotation))
        let rotationMatrix = simd_float4x4(quat)
        self *= rotationMatrix
        return
    } // rotate
    
    // MARK: - scale
    mutating func scales(scale: simd_float3) {
        self[0] *= scale.x
        self[1] *= scale.y
        self[2] *= scale.z
        return
    } // scale
    
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
