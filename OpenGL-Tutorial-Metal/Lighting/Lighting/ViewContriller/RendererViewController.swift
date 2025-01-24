//
//  RendererViewController.swift
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/21.
//

import UIKit
import Metal
import simd

// MARK: - RendererViewController
class RendererViewController: UIViewController {
    public var device: MTLDevice!
    public var metalLayer: CAMetalLayer!
    
    private var pipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    private var vertexBuffer: MTLBuffer!
    private var indexBuffer: MTLBuffer!
    private var modelMatrixBuffer: MTLBuffer!
    private var depthTexture: MTLTexture!
    private var depthStencilState: MTLDepthStencilState!
    private var timer: CADisplayLink!
    private let cubeIndices: [UInt16] = [
        0, 1, 2,  2, 3, 0,        // Front
        4, 5, 6,  6, 7, 4,        // Back
        8, 9, 10,  10, 11, 8,     // Left
        12, 13, 14,  14, 15, 12,  // Right
        16, 17, 18,  18, 19, 16,  // Top
        20, 21, 22,  22, 23, 20   // Bottom
    ]
    
    private let cubePositions: [simd_float3] = [
        simd_float3(0.0, 0.0, 0.0),   // 중앙
        simd_float3(-0.3, 0.3, -1.2)
    ]
    
    private var lightColors: [Colors] = [
        Colors(lightCoor: simd_float3(1.0, 1.0, 1.0), objectColor: simd_float3(1.0, 0.5, 0.31)),
        Colors(lightCoor: simd_float3(1.2, 1.0, 2.0),objectColor: simd_float3(1.0, 0.5, 0.31))
    ]
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMetal()
        setupVertices()
        setupPipeline()
        rendering()
    } // viewDidLoad
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        metalLayer.frame = view.bounds
    } // viewDidLayoutSubviews
    
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
        
        if let depTex = setupDepthTexture() {
            depthTexture = depTex
        }
        
        return
    } // setupMetal
    
    // MARK: - setupVertices
    private func setupVertices() {
        let cubeVertices: [Vertex] = [
            // Front
            Vertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
            Vertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
            Vertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
            Vertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 0.0, -1.0)),
            
            // Back
            Vertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
            Vertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
            Vertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
            Vertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 0.0, 1.0)),
            
            // Left
            Vertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
            Vertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
            Vertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
            Vertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(-1.0, 0.0, 0.0)),
            
            // Right
            Vertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0)),
            Vertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0)),
            Vertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(1.0, 0.0, 0.0)),
            Vertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(1.0, 0.0, 0.0)),
            
            // Top
            Vertex(position: simd_float3(-0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0)),
            Vertex(position: simd_float3(0.5, 0.5, -0.5), normal: simd_float3(0.0, 1.0, 0.0)),
            Vertex(position: simd_float3(0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0)),
            Vertex(position: simd_float3(-0.5, 0.5, 0.5), normal: simd_float3(0.0, 1.0, 0.0)),
            
            // Bottom
            Vertex(position: simd_float3(-0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0)),
            Vertex(position: simd_float3(0.5, -0.5, -0.5), normal: simd_float3(0.0, -1.0, 0.0)),
            Vertex(position: simd_float3(0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0)),
            Vertex(position: simd_float3(-0.5, -0.5, 0.5), normal: simd_float3(0.0, -1.0, 0.0)),
        ]
        
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
    } // setupVertices
    
    // MARK: - setupPipeline
    private func setupPipeline() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError("pipeline 생성 실패: \(error)")
        }
        
        if let deptSten = setupDepthStencilState() {
            depthStencilState = deptSten
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
        
        var projectionMatrix = perspective(
            fov: toRadians(from: 30.0),
            aspectRatio: Float(view.bounds.width / view.bounds.height),
            nearPlane: 0.1,
            farPlane: 100.0
        )
        
        let viewMatrix = lookAt(
            eyePosition: simd_float3(0.0, 0.0, 3.0), // 카메라 위치
            targetPosition: simd_float3(0.0, 0.0, 0.0), // 타겟 위치(카메라가 바라보는 위치)
            upVec: simd_float3(0.0, 1.0, 0.0)) // 위쪽
        
        // 렌더패스 설정
        // 색상 텍스처 설정
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 1.0
        )
        
        // 깊이 텍스처 설정
        renderPassDescriptor.depthAttachment.texture = depthTexture
        renderPassDescriptor.depthAttachment.loadAction = .clear
        renderPassDescriptor.depthAttachment.storeAction = .dontCare
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(modelMatrixBuffer, offset: 0, index: 1)
        
        renderEncoder.setVertexBytes(&projectionMatrix, length: MemoryLayout.stride(ofValue: projectionMatrix), index: 1)
        
//        let cubePositions: [simd_float3] = [
//            simd_float3(0.0, 0.0, 0.0),   // 중앙
//            simd_float3(-0.3, 0.3, -1.2)
//        ]
//
//        var lightColors: [simd_float3] = [
//            simd_float3(1.0, 1.0, 1.0),
//            simd_float3(1.2, 1.0, 2.0)
//        ]
        
        for i in cubePositions.indices {
            var modelMatrix = matrix_identity_float4x4
            translate(matrix: &modelMatrix, position: cubePositions[i])
            rotate(matrix: &modelMatrix, rotation: simd_float3(toRadians(from: 30.0), toRadians(from: 30.0), 0.0))
            scale(matrix: &modelMatrix, scale: simd_float3(0.2, 0.2, 0.2))
                        
            var modelViewMatrix = viewMatrix * modelMatrix
            var ambient: simd_float3 = i == 0 ? simd_float3(0.1, 0.1, 0.1) : simd_float3(0.0, 0.0, 0.0)
            var cameraPosition = simd_float3(0.0, 0.0, 3.0)
            
            renderEncoder.setFragmentBytes(&cameraPosition, length: MemoryLayout<simd_float3>.size, index: 1)
            renderEncoder.setFragmentBytes(&lightColors[i].lightCoor, length: MemoryLayout<simd_float3>.size, index: 2)
            renderEncoder.setFragmentBytes(&lightColors[i].objectColor, length: MemoryLayout<simd_float3>.size, index: 3)
            renderEncoder.setFragmentBytes(&ambient, length: MemoryLayout<simd_float3>.size, index: 4)
            
            renderEncoder.setVertexBytes(&modelViewMatrix, length: MemoryLayout.stride(ofValue: modelViewMatrix), index: 2)
            
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: cubeIndices.count,
                indexType: .uint16,
                indexBuffer: indexBuffer,
                indexBufferOffset: 0
            )
        }
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        return
    } // render
    
    // MARK: - gameLoop
    @objc private func gameLoop() {
        autoreleasepool {
            render()
        }
    } // gameLoop
    
} //
