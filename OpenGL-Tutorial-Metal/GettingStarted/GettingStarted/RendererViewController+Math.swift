//
//  RendererViewController+Matrix.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import Foundation
import simd

extension RendererViewController {
    // MARK: - toRadians
    public func toRadians(from angle: Float) -> Float {
        return angle * .pi / 180.0;
    } // toRadians
    
    // MARK: - translate
    public func translate(matrix: inout simd_float4x4, position: simd_float3) {
        matrix[3] = matrix[0] * position.x + matrix[1] * position.y + matrix[2] * position.z + matrix[3];
    } // translate
    
    // MARK: - rotate
    public func rotate(matrix: inout simd_float4x4, rotation: simd_float3) {
        let quat = simd_quatf(angle: length(rotation), axis: normalize(rotation))
        let rotationMatrix = simd_float4x4(quat)
        matrix *= rotationMatrix
        return
    } // rotate
    
    // MARK: - scale
    public func scale(matrix: inout simd_float4x4, scale: simd_float3) {
        matrix[0] *= scale.x
        matrix[1] *= scale.y
        matrix[2] *= scale.z
        return
    } // scale
    
    // MARK: - lookAt
    public func lookAt(eyePosition: simd_float3, targetPosition: simd_float3, upVec: simd_float3) -> simd_float4x4 {
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
    public func perspective(fov: Float, aspectRatio: Float, nearPlane: Float, farPlane: Float) -> simd_float4x4 {
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
