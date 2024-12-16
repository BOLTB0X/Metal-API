//
//  Triangle-01.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/29.
//

import SwiftUI

struct Triangle_01: View {
    @StateObject private var viewModel = TriangleViewModel()
    
    var body: some View {
        VStack {
            TriangleView(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Button("Red") {
                    viewModel.currentColor = SIMD4(1, 0, 0, 1)
                }
                .buttonStyle(.bordered)
                
                Button("Blue") {
                    viewModel.currentColor = SIMD4(0, 0, 1, 1)
                }
                .buttonStyle(.bordered)
                
                Button("Green") {
                    viewModel.currentColor = SIMD4(0, 1, 0, 1)
                }
                .buttonStyle(.bordered)

            }
            .padding()
        } // VStack
    }
}

