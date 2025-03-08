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
    
    var movementSpeed: Float = 3.0
    var mouseSensitivity: Float = 1.0
    var zoom: Float = 45.0

    // MARK: - init
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

        updateCameraVectors()
    } // init

    // MARK: - Public
    // ...
    // MARK: - processKeyboard
    // 키보드 입력 처리 (WASD 이동)
    func processKeyboard(_ direction: CameraMovement, deltaTime: Float) {
        let velocity = self.movementSpeed * deltaTime

        switch direction {
        case .forward:
            self.position += self.front * velocity
        case .backward:
            self.position -= self.front * velocity
        case .left:
            self.position -= self.right * velocity
        case .right:
            self.position += self.right * velocity
        }
    } // processKeyboard

    // MARK: - processMouseMovement
    // 마우스 이동 처리 (카메라 회전)
    func processMouseMovement(xOffset: Float, yOffset: Float, constrainPitch: Bool = true) {
        let xOffset = xOffset * self.mouseSensitivity
        let yOffset = yOffset * self.mouseSensitivity

        self.yaw += xOffset
        self.pitch += yOffset

        if constrainPitch {
            self.pitch = max(-89.0, min(89.0, self.pitch))
        }

        updateCameraVectors()
    } // processMouseMovement

    // MARK: - processMouseScroll
    // 줌 조절
    func processMouseScroll(yOffset: Float) {
        self.zoom -= yOffset
        self.zoom = max(1.0, min(45.0, self.zoom))
    } // processMouseScroll
    
    // MARK: - getViewMatrix
    func getViewMatrix(eyePosition: simd_float3? = nil) -> simd_float4x4 {
        if let pos = eyePosition {
            return simd_float4x4.identity().lookAt(eyePosition: pos, targetPosition: simd_float3(repeating: 0.0), upVec: simd_float3(0.0, 1.0, 0.0))
        }
        
        return simd_float4x4.identity().lookAt(eyePosition: self.position,
                                               targetPosition: self.position + self.front,
                                               upVec: self.up)
    } // getViewMatrix
    
    // MARK: - getProjectionMatrix
    func getProjectionMatrix() -> simd_float4x4 {
        return simd_float4x4.identity().perspective(fov: Float(45).toRadians(),
                                         aspectRatio: 1.0,
                                         nearPlane: 0.1,
                                         farPlane: 100.0)
    } // getProjectionMatrix

    // MARK: - Private
    // ...
    // MARK: - updateCameraVectors
    // 카메라 벡터 업데이트
    private func updateCameraVectors() {
        let yawRad = self.yaw.toRadians()
        let pitchRad = self.pitch.toRadians()

        let frontX = cos(yawRad) * cos(pitchRad)
        let frontY = sin(pitchRad)
        let frontZ = sin(yawRad) * cos(pitchRad)

        self.front = normalize(simd_float3(frontX, frontY, frontZ))
        self.right = normalize(cross(self.front, self.worldUp))
        self.up = normalize(cross(self.right, self.front))
    } // updateCameraVectors
    
} // Camera

// MARK: - CameraMovement
enum CameraMovement {
    case forward, backward, left, right
} // CameraMovement
