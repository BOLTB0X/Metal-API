//
//  ContentView.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var renderer = Renderer(device: MTLCreateSystemDefaultDevice()!)
    
    var body: some View {
        VStack {
            TriangleView(renderer: renderer)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Button("Red") {
                    renderer.currentColor = SIMD4(1, 0, 0, 1)
                }
                .buttonStyle(.bordered)
                
                Button("Blue") {
                    renderer.currentColor = SIMD4(0, 0, 1, 1)
                }
                .buttonStyle(.bordered)
                
                Button("Green") {
                    renderer.currentColor = SIMD4(0, 1, 0, 1)
                }
                .buttonStyle(.bordered)

            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
