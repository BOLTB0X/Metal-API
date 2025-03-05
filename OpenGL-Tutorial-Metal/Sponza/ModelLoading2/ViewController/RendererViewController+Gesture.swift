//
//  RendererViewController+Gesture.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/03/05.
//

import UIKit
import simd

// MARK: - RendererViewController+Gesture
extension RendererViewController: UIGestureRecognizerDelegate {
    // MARK: - gestureRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    } // gestureRecognizer
    
    // MARK: - objc Methods
    // ...
    // MARK: - handlePinchGesture
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        let direction = normalize(self.renderer.camera.front)
        let movement = direction * Float(gesture.velocity) * self.renderer.camera.movementSpeed
        let newPosition = self.renderer.camera.position + movement
        let distanceToCenter = simd_length(newPosition - simd_float3(repeating: 0.0))
        
        if distanceToCenter > 2.0 && distanceToCenter < 50.0 {
            self.renderer.camera.position = newPosition
        }
        
    } // handlePinchGesture
    
    // MARK: - handlePanGesture
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        
        if gesture.state == .began {
            self.lastPanLocation = location
        } else if gesture.state == .changed, let lastLocation = lastPanLocation {
            let xOffset = Float(location.x - lastLocation.x) * 0.1
            let yOffset = Float(lastLocation.y - location.y) * 0.1
            
            self.renderer.camera.processMouseMovement(xOffset: xOffset, yOffset: yOffset)
            self.lastPanLocation = location
        } // if - else if
 
    } // handlePanGesture
    
} // RendererViewController+Gesture
