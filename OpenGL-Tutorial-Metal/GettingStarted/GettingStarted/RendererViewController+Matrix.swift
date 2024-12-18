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
    // MARK: - createModelMatrix
    func createModelMatrix(rotation: Float, translation: simd_float2) -> simd_float4x4 {
        let rotationMatrix = simd_float4x4([
            simd_float4(cos(rotation), -sin(rotation), 0, 0),
            simd_float4(sin(rotation),  cos(rotation), 0, 0),
            simd_float4(0,             0,             1, 0),
            simd_float4(0,             0,             0, 1)
        ])
        
        let translationMatrix = simd_float4x4([
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, 0),
            simd_float4(translation.x, translation.y, 0, 1)
        ])
        
        return translationMatrix * rotationMatrix
    }
}
