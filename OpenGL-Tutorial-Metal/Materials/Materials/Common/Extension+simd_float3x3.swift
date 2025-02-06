//
//  Extension+simd_float3x3.swift
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/05.
//

import Foundation
import simd

extension simd_float3x3 {
    // MARK: -  Multiplication
    public func scaled(_ a: Float) -> simd_float3x3 {
        return simd_float3x3(self[0] * a, self[1] * a, self[2] * a)
    }

    // MARK: - inverse_3x3
    mutating func inverse_3x3() {
        let row0 = columns.0
        let row1 = columns.1
        let row2 = columns.2

        let minor0 = simd_cross(row1, row2)
        let minor1 = simd_cross(row2, row0)
        let minor2 = simd_cross(row0, row1)

        let determinant = simd_dot(row0, minor0)
        
        if determinant != 0 {
            let transposeMatrix = simd_float3x3(minor0, minor1, minor2).transpose
            self = transposeMatrix.scaled(1.0 / determinant)
        }
    } // inverse_3x3
    
}
