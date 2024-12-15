//
//  RendererViewController.swift
//  Ex03-Textures
//
//  Created by KyungHeon Lee on 2024/12/10.
//

import UIKit
import Metal
import MetalKit

// MARK: - RendererViewController
class RendererViewController: UIViewController {
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var texture1: MTLTexture!
    var texture2: MTLTexture!

    var samplerState: MTLSamplerState!
    
    var timer: CADisplayLink!
    
    let indices: [UInt16] = [
        0, 1, 2,
        1, 3, 2
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMetal()
        setupVertices()
        setupPipeline()
        rendering()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        metalLayer.frame = view.bounds
    }
    
    // MARK: - setupMetal
    private func setupMetal() {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("MTLCreateSystemDefaultDevice Error")
        }
        
        device = metalDevice
        
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        setupSampler() // 샘플러 생성
        return
    }
    
    // MARK: - setupVertices
    private func setupVertices() {
        do {
            texture1 = try loadTexture("container")
        } catch {
            print("텍스처 로드 실패: \(error)")
            return
        }
        
        do {
            texture2 = try loadTexture("awesomeface")
        } catch {
            print("텍스처 로드 실패: \(error)")
            return
        }
        
        //        let vertices = [
        //            Vertex(position: SIMD2<Float>(0.0, 0.5), color: SIMD3<Float>(1.0, 0.0, 0.0), texCoord: SIMD2<Float>(0.5, 1.0)),
        //            Vertex(position: SIMD2<Float>(-0.5, -0.5), color: SIMD3<Float>(0.0, 1.0, 0.0), texCoord: SIMD2<Float>(0.0, 0.0)),
        //            Vertex(position: SIMD2<Float>(0.5, -0.5), color: SIMD3<Float>(0.0, 0.0, 1.0), texCoord: SIMD2<Float>(1.0, 0.0))
        //        ]
        
        let rectangleVertices = [
            Vertex(position: SIMD2<Float>(-0.85,  0.45), color: SIMD3<Float>(1.0, 0.0, 0.0), texCoord: SIMD2<Float>(0.0, 1.0)),
            Vertex(position: SIMD2<Float>( 0.85,  0.45), color: SIMD3<Float>(0.0, 1.0, 0.0), texCoord: SIMD2<Float>(1.0, 1.0)),
            Vertex(position: SIMD2<Float>(-0.85, -0.5), color: SIMD3<Float>(0.0, 0.0, 1.0), texCoord: SIMD2<Float>(0.0, 0.0)),
            Vertex(position: SIMD2<Float>( 0.85, -0.5), color: SIMD3<Float>(1.0, 1.0, 1.0), texCoord: SIMD2<Float>(1.0, 0.0))
        ]
        
        
        //        vertexBuffer = device.makeBuffer(
        //            bytes: vertices,
        //            length: vertices.count * MemoryLayout<Vertex>.stride,
        //            options: []
        //        )
        
        vertexBuffer = device.makeBuffer(
            bytes: rectangleVertices,
            length: rectangleVertices.count * MemoryLayout<Vertex>.stride,
            options: []
        )
        
        indexBuffer = device.makeBuffer(
            bytes: indices,
            length: indices.count * MemoryLayout<UInt16>.stride,
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
        let fragmentFunction = library?.makeFunction(name: "fragmentFunction2")
        
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
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let renderEncoder = commandBuffer
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // 텍스처 설정
        renderEncoder.setFragmentTexture(texture1, index: 0)
        renderEncoder.setFragmentTexture(texture2, index: 1)
        renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        
        var blendRatio: Float = 0.5
        renderEncoder.setFragmentBytes(&blendRatio, length: MemoryLayout<Float>.stride, index: 1)
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: indices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )
        //renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        return
    }
    
    // MARK: - loadTexture
    private func loadTexture(_ name: String) throws -> MTLTexture {
        let textureLoader = MTKTextureLoader(device: device)
        
        do {
            return try textureLoader.newTexture(name: name, scaleFactor: 1.0, bundle: nil, options: nil)
        } catch {
            fatalError("텍스처 로드 실패: \(error)")
        }
    }
    
    // MARK: - setupSampler
    private func setupSampler() {
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.sAddressMode = .clampToEdge
        samplerDescriptor.tAddressMode = .clampToEdge
        
        samplerState = device.makeSamplerState(descriptor: samplerDescriptor)
    }
    
    @objc private func gameLoop() {
        autoreleasepool {
            self.render()
        }
    }
}
