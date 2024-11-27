//
//  TriangleView.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/27.
//

import SwiftUI
import MetalKit

struct TriangleView: UIViewRepresentable {
    let renderer: Renderer
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = renderer.device
        mtkView.delegate = renderer
        mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1)
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        /*  */
    }
}
