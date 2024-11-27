//
//  Renderer.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/27.
//

import SwiftUI
import MetalKit

// MARK: - Renderer
class Renderer: NSObject, MTKViewDelegate, ObservableObject {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    
    @Published var currentColor: SIMD4<Float> = SIMD4(1, 0, 0, 1)
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        
        super.init()
        setupPipeline()
        setupVertexBuffer()
    }
    
    // MARK: - draw
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 1, green: 1, blue: 1, alpha: 1 // 배경색
        )
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentBytes(&currentColor,
                                       length: MemoryLayout<SIMD4<Float>>.stride,
                                       index: 1) // currentColor 값을 Fragment Shader로 전달
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    // MARK: - mtkView
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // 크기 변경 이벤트
    }
    
    private func setupPipeline() {
        let library = device.makeDefaultLibrary()!
        
        // 셰이더 연결
        let vertexFunction = library.makeFunction(name: "basic_vertex")!
        let fragmentFunction = library.makeFunction(name: "basic_fragment")!
                
        // 렌더 파이프라인 설정
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
                
        // 파이프라인 상태 생성
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    private func setupVertexBuffer() {
        let vertexData: [Float] = [
           0.0,  0.5, 0.0,
          -0.5, -0.5, 0.0,
           0.5, -0.5, 0.0
        ]
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        // 버택스 설정
        vertexBuffer = device.makeBuffer(bytes: vertexData,
                                         length: dataSize,
                                         options: [])
    }
}
