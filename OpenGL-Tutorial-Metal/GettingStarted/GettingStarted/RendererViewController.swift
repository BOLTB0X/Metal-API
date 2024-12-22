//
//  RendererViewController.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import UIKit
import Metal
import MetalKit
import simd

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
    
    let cubeIndices: [UInt16] = [
        // Front face
        0, 1, 2, 0, 2, 3,
        // Back face
        4, 5, 6, 4, 6, 7,
        // Left face
        0, 4, 7, 0, 7, 3,
        // Right face
        1, 5, 6, 1, 6, 2,
        // Top face
        3, 2, 6, 3, 6, 7,
        // Bottom face
        0, 1, 5, 0, 5, 4
    ]
    
//    let indices: [UInt16] = [
//        0, 1, 3,
//        1, 2, 3
//    ]
    
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
        
        samplerState = setupSampler()
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
        
        let cubeVertices: [Vertex] = [
            // Front face
            Vertex(position: simd_float3(-0.5, -0.5,  0.5), color: simd_float3(1, 0, 0), texCoord: simd_float2(0, 0)),
            Vertex(position: simd_float3( 0.5, -0.5,  0.5), color: simd_float3(0, 1, 0), texCoord: simd_float2(1, 0)),
            Vertex(position: simd_float3( 0.5,  0.5,  0.5), color: simd_float3(0, 0, 1), texCoord: simd_float2(1, 1)),
            Vertex(position: simd_float3(-0.5,  0.5,  0.5), color: simd_float3(1, 1, 0), texCoord: simd_float2(0, 1)),
            // Back face
            Vertex(position: simd_float3(-0.5, -0.5, -0.5), color: simd_float3(1, 0, 1), texCoord: simd_float2(0, 0)),
            Vertex(position: simd_float3( 0.5, -0.5, -0.5), color: simd_float3(0, 1, 1), texCoord: simd_float2(1, 0)),
            Vertex(position: simd_float3( 0.5,  0.5, -0.5), color: simd_float3(1, 1, 1), texCoord: simd_float2(1, 1)),
            Vertex(position: simd_float3(-0.5,  0.5, -0.5), color: simd_float3(0, 0, 0), texCoord: simd_float2(0, 1)),
        ]
        
//        let rectangleVertices: [Vertex] = [
//            Vertex(position: simd_float2( 0.4,  0.4), color: simd_float3(0.0, 1.0, 0.0), texCoord: simd_float2(1.0, 1.0)),
//            Vertex(position: simd_float2( 0.4, -0.4), color: simd_float3(1.0, 1.0, 1.0), texCoord: simd_float2(1.0, 0.0)),
//            Vertex(position: simd_float2(-0.4, -0.4), color: simd_float3(0.0, 0.0, 1.0), texCoord: simd_float2(0.0, 0.0)),
//            Vertex(position: simd_float2(-0.4,  0.4), color: simd_float3(1.0, 0.0, 0.0), texCoord: simd_float2(0.0, 1.0))
//        ]
        
        vertexBuffer = device.makeBuffer(
            bytes: cubeVertices,
            length: cubeVertices.count * MemoryLayout<Vertex>.stride,
            options: []
        )
        
        indexBuffer = device.makeBuffer(
            bytes: cubeIndices,
            length: cubeIndices.count * MemoryLayout<UInt16>.stride,
            options: []
        )
        
        return
    }
    
    // MARK: - setupPipeline
    private func setupPipeline() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragmentFunction")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        return
    } // setupPipeline
    
    // MARK: - rendering
    private func rendering() {
        commandQueue = device.makeCommandQueue()
        timer = CADisplayLink(target: self, selector: #selector(gameLoop))
        timer.add(to: RunLoop.main, forMode: .default)
    } // rendering
    
    // MARK: - render
    private func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
                
        // 3D 큐브
        let modelMatrix = simd_float4x4.rotate(angle: 0, axis: simd_float3(1, 1, 0)) *
                          simd_float4x4.translate(x: 0.0, y: 0.0, z: -2.0)

        let viewMatrix = simd_float4x4.lookAt(
            eye: simd_float3(0.0, 0.0, 3.0),
            center: simd_float3(0.0, 0.0, 0.0),
            up: simd_float3(0.0, 1.0, 0.0)
        )

        let projectionMatrix = simd_float4x4.perspective(
            aspect: 800.0 / 600.0, fovy: .pi / 4, near: 0.1, far: 100.0
        )

        var mvpMatrix = projectionMatrix * viewMatrix * modelMatrix
        
        // 렌더패스 설정
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
        renderEncoder.setVertexBytes(&mvpMatrix, length: MemoryLayout<simd_float4x4>.stride, index: 1)
        
        renderEncoder.setFragmentTexture(texture1, index: 0)
        renderEncoder.setFragmentTexture(texture2, index: 1)
        renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        
        var blendRatio: Float = 0.3
        renderEncoder.setFragmentBytes(&blendRatio, length: MemoryLayout<Float>.stride, index: 1)
        
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: cubeIndices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    } // render
    
    // MARK: - gameLoop
    @objc private func gameLoop() {
        autoreleasepool {
            render()
        }
    } // gameLoop
}
