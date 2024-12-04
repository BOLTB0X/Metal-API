//
//  RendererViewController.swift
//  Ex02-Shaders
//
//  Created by KyungHeon Lee on 2024/12/04.
//

import UIKit
import Metal

// MARK: - RendererViewController
class RendererViewController: UIViewController {
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var vertexBuffer: MTLBuffer!
    
    var timer: CADisplayLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMetal()
        setupVertices()
        setupPipeline()
        rendering()
    }
    
    // MARK: - setupMetal
    private func setupMetal() {
        device = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        return
    }
    
    // MARK: - setupVertices
    private func setupVertices() {
        let vertices = [
            Vertex(position: SIMD2<Float>(0.0, 0.5), color: SIMD3<Float>(1.0, 0.0, 0.0)), // 빨강
            Vertex(position: SIMD2<Float>(-0.5, -0.5), color: SIMD3<Float>(0.0, 1.0, 0.0)),  // 초록
            Vertex(position: SIMD2<Float>(0.5,  -0.5), color: SIMD3<Float>(0.0, 0.0, 1.0))   // 파랑
        ]
        
        vertexBuffer = device.makeBuffer(
            bytes: vertices,
            length: vertices.count * MemoryLayout<Vertex>.stride,
            options: []
        )
        
        return
    }
    
    // MARK: - rendering
    private func rendering() {
        commandQueue = device.makeCommandQueue()
        timer = CADisplayLink(target: self, selector: #selector(gameLoop))
        timer.add(to: RunLoop.main, forMode: .default)
        return
    }
    
    // MARK: - setupPipeline
    private func setupPipeline() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexFunction")
        let fragmentFunction = library?.makeFunction(name: "fragmentFunction")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        return
    }
    
    // MARK: - render
    private func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.5
        )
        //renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let renderEncoder = commandBuffer
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        renderEncoder
            .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        return
    }
    
    @objc private func gameLoop() {
        autoreleasepool {
            self.render()
        }
    }
}
