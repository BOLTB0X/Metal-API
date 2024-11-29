//
//  Render2ViewController.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/29.
//

import UIKit
import Metal

// MARK: - Render2ViewController
class Render2ViewController: UIViewController {
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    
    let vertexData1: [Float] = [
        -0.8, -0.5, 0.0,
         -0.3, -0.5, 0.0,
         -0.55, 0.5, 0.0
    ]
    
    let vertexData2: [Float] = [
        0.3, -0.5, 0.0,
        0.8, -0.5, 0.0,
        0.55, 0.5, 0.0
    ]
    
    var vertexBuffer1: MTLBuffer!
    var vertexBuffer2: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    
    var timer: CADisplayLink!
    
    var color1 = SIMD4<Float>(1, 0, 0, 1)
    var color2 = SIMD4<Float>(0, 0, 1, 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialMetal()
        setupRenderPipeline()
        rendering()
    }
    
    // MARK: - setupInitialMetal
    private func setupInitialMetal() {
        device = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        let dataSize1 = vertexData1.count * MemoryLayout.size(ofValue: vertexData1[0])
        vertexBuffer1 = device.makeBuffer(bytes: vertexData1, length: dataSize1, options: [])
        
        let dataSize2 = vertexData2.count * MemoryLayout.size(ofValue: vertexData2[0])
        vertexBuffer2 = device.makeBuffer(bytes: vertexData2, length: dataSize2, options: [])
        return;
    }
    
    // MARK: - setupRenderPipeline
    private func setupRenderPipeline() {
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        return
    }
    
    // MARK: - rendering
    private func rendering() {
        commandQueue = device.makeCommandQueue()
        timer = CADisplayLink(target: self, selector: #selector(gameLoop))
        timer.add(to: RunLoop.main, forMode: .default)
        return
    }
    
    // MARK: - render
    private func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 0.5)
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let renderEncoder = commandBuffer
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // 1
        renderEncoder.setVertexBuffer(vertexBuffer1, offset: 0, index: 0)
        renderEncoder.setFragmentBytes(&color1,
                                       length: MemoryLayout<SIMD4<Float>>.stride,
                                       index: 1)
        renderEncoder
            .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        
        // 2
        renderEncoder.setVertexBuffer(vertexBuffer2, offset: 0, index: 0)
        renderEncoder.setFragmentBytes(&color2,
                                       length: MemoryLayout<SIMD4<Float>>.stride,
                                       index: 1)
        renderEncoder
            .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        return
    }
    
    // MARK: - gameLoop
    @objc private func gameLoop() {
        autoreleasepool {
            self.render()
        }
    }
    
}
