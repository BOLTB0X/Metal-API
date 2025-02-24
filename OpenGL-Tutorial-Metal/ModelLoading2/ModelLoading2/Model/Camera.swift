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
    var position: simd_float3
    var front: simd_float3
    var up: simd_float3
    var right: simd_float3
    var worldUp: simd_float3
    var yaw: Float
    var pitch: Float
    
    let movementSpeed: Float = 2.5
    let mouseSensitivity: Float = 0.1
    let zoom: Float = 45.0
    
    // init
    init(position: simd_float3,
         up: simd_float3 = simd_float3(0, 1, 0),
         yaw: Float = -90.0,
         pitch: Float = 0.0) {
        self.position = position
        self.worldUp = up
        self.yaw = yaw
        self.pitch = pitch
        self.front = simd_float3(0, 0, -1)
        self.right = simd_float3(1, 0, 0)
        self.up = up
        
        //updateCameraVectors()
    }
    
    // MARK: - getViewMatrix
    func getViewMatrix() -> simd_float4x4 {
        return simd_float4x4.lookAt(eyePosition: position,
                                    targetPosition: position + front,
                                    upVec: up)
    } // getViewMatrix
    
    // MARK: - updateCameraVectors
    private func updateCameraVectors() {
        let yawRad = yaw.toRadians()
        let pitchRad = pitch.toRadians()
        
        let frontX = cos(yawRad) * cos(pitchRad)
        let frontY = sin(pitchRad)
        let frontZ = sin(yawRad) * cos(pitchRad)
        
        front = normalize(simd_float3(frontX, frontY, frontZ))
        right = normalize(cross(front, worldUp))
        up = normalize(cross(right, front))
    } // updateCameraVectors
    
} // Camera
