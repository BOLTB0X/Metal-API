//
//  Extension+simd_float3x3.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/19.
//

import Foundation
import simd

extension simd_float3x3 {
    // MARK: - inverse_3x3
    mutating func inverse_3x3() {
        let col0 = columns.0
        let col1 = columns.1
        let col2 = columns.2

        let minor0 = simd_float3(
            col1.y * col2.z - col1.z * col2.y,
            col1.z * col2.x - col1.x * col2.z,
            col1.x * col2.y - col1.y * col2.x
        )
        
        let minor1 = simd_float3(
            col0.z * col2.y - col0.y * col2.z,
            col0.x * col2.z - col0.z * col2.x,
            col0.y * col2.x - col0.x * col2.y
        )

        let minor2 = simd_float3(
            col0.y * col1.z - col0.z * col1.y,
            col0.z * col1.x - col0.x * col1.z,
            col0.x * col1.y - col0.y * col1.x
        )

        // 행렬식 (Determinant)
        let determinant = simd_dot(col0, minor0)

        if determinant != 0 {
            let cofactorMatrix = simd_float3x3(minor0, minor1, minor2)
            let adjugateMatrix = cofactorMatrix.transpose
            self = adjugateMatrix * (1.0 / determinant)
        }
    } // inverse_3x3
    
}
