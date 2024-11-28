//
//  TriangleViewmodel.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/28.
//

import Foundation

class TriangleViewModel: ObservableObject {
    @Published var currentColor: SIMD4<Float> = SIMD4(1, 0, 0, 1)
    
}
