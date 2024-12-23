//
//  RendererViewController.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import UIKit
import Metal
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
    
    let indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
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
        
        samplerState = setupSampler()
        return
    }
    
    // MARK: - setupVertices
    private func setupVertices() {
        do {
            texture1 = try loadTexture("container")
            print("텍스처 1 로드 성공")
        } catch {
            print("텍스처 로드 실패: \(error)")
            return
        }
        
        do {
            texture2 = try loadTexture("awesomeface")
            print("텍스처 2 로드 성공")
        } catch {
            print("텍스처 로드 실패: \(error)")
            return
        }
        
        
        let rectangleVertices: [Vertex] = [
            Vertex(position: simd_float3(-0.5, -0.5,  0.5), color: simd_float3(1, 0, 0), texCoord: simd_float2(0, 0)),
            Vertex(position: simd_float3( 0.5, -0.5,  0.5), color: simd_float3(0, 1, 0), texCoord: simd_float2(1, 0)),
            Vertex(position: simd_float3( 0.5,  0.5,  0.5), color: simd_float3(0, 0, 1), texCoord: simd_float2(1, 1)),
            Vertex(position: simd_float3(-0.5,  0.5,  0.5), color: simd_float3(1, 1, 0), texCoord: simd_float2(0, 1))
        ]
        
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
    
    // MARK: - setupPipeline
    private func setupPipeline() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexFunction")
        let fragmentFunction = library?.makeFunction(name: "fragmentFunction")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[0].stepRate = 1
        vertexDescriptor.layouts[0].stepFunction = .perVertex
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset =  MemoryLayout.offset(of: \Vertex.position)!
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float3 // color
        vertexDescriptor.attributes[1].offset = MemoryLayout.offset(of: \Vertex.color)!
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2 // texCoord
        vertexDescriptor.attributes[2].offset = MemoryLayout.offset(of: \Vertex.texCoord)!
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError("pipeline 생성 실패: \(error)")
        }
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
        
        var projectionMatrix = createPerspectiveMatrix(
            fov: toRadians(from: 45.0),
            aspectRatio: Float(view.bounds.width / view.bounds.height),
            nearPlane: 0.1,
            farPlane: 100.0)
        
        let viewMatrix = createViewMatrix(
            eyePosition: simd_float3(0.0, 5.0, -5.0),
            targetPosition: simd_float3(0.0, 0.0, 0.0),
            upVec: simd_float3(0.0, 1.0, 0.0))
        
        var modelMatrix = matrix_identity_float4x4
        translate(matrix: &modelMatrix, position: simd_float3(0.0, 0.0, 0.0))
        rotate(matrix: &modelMatrix, rotation: simd_float3(0.0, toRadians(from: 60.0), 0.0))
        scale(matrix: &modelMatrix, scale: simd_float3(1.0, 1.0, 1.0))
        
        // 렌더패스 설정
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 1
        )
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setVertexBytes(&projectionMatrix, length: MemoryLayout.stride(ofValue: projectionMatrix), index: 0)
        var modelViewMatrix = viewMatrix * modelMatrix
        renderEncoder.setVertexBytes(&modelViewMatrix, length: MemoryLayout.stride(ofValue: modelViewMatrix), index: 1)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        renderEncoder.setFragmentTexture(texture1, index: 0)
        renderEncoder.setFragmentTexture(texture2, index: 1)
        renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        
        var blendRatio: Float = 0.3
        renderEncoder.setFragmentBytes(&blendRatio, length: MemoryLayout<Float>.stride, index: 1)
        
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: indices.count,
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
