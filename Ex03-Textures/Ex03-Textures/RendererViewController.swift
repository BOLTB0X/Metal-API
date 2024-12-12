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
    var texture: MTLTexture!
    var samplerState: MTLSamplerState!
    
    var timer: CADisplayLink!
    
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
            texture = try loadTexture()
        } catch {
            print("텍스처 로드 실패: \(error)")
            return
        }
        
        let vertices = [
            Vertex(position: SIMD2<Float>(0.0, 0.5), color: SIMD3<Float>(1.0, 0.0, 0.0), texCoord: SIMD2<Float>(0.5, 1.0)),
            Vertex(position: SIMD2<Float>(-0.5, -0.5), color: SIMD3<Float>(0.0, 1.0, 0.0), texCoord: SIMD2<Float>(0.0, 0.0)),
            Vertex(position: SIMD2<Float>(0.5, -0.5), color: SIMD3<Float>(0.0, 0.0, 1.0), texCoord: SIMD2<Float>(1.0, 0.0))
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
        let vertexFunction = library?.makeFunction(name: "vertexFunction") // 기본
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
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let renderEncoder = commandBuffer
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // 텍스처 설정
        renderEncoder.setFragmentTexture(texture, index: 0)
        renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        
        renderEncoder
            .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        return
    }
    
    // MARK: - loadTexture
    private func loadTexture() throws -> MTLTexture {
        let textureLoader = MTKTextureLoader(device: device)
        
        do {
            return try textureLoader.newTexture(name: "wall", scaleFactor: 1.0, bundle: nil, options: nil)
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
