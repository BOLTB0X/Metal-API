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
    
    public var cameraPosition = simd_float3(0.0, 0.0, 3.0)
    
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
        vertexBuffer = device.makeBuffer(
            bytes: RendererResources.cubeVertices,
            length: RendererResources.cubeVertices.count * MemoryLayout<Vertex>.stride,
            options: []
        )
        
        indexBuffer = device.makeBuffer(
            bytes: RendererResources.cubeIndices,
            length: RendererResources.cubeIndices.count * MemoryLayout<UInt16>.stride,
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
        
        var projectionMatrix = simd_float4x4.perspective(
            fov: Float(30).toRadians(),
            aspectRatio: Float(view.bounds.width / view.bounds.height),
            nearPlane: 0.1,
            farPlane: 100.0
        )

        let viewMatrix = simd_float4x4.lookAt(
            eyePosition: simd_float3(0.0, 0.0, 3.0),
            targetPosition: simd_float3(0.0, 0.0, 0.0),
            upVec: simd_float3(0.0, 1.0, 0.0)
        )
        
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
        
        for i in RendererResources.cubePositions.indices {
            var modelMatrix = simd_float4x4.identity()
            let ambient: simd_float3 = i == 0 ? simd_float3(0.1, 0.1, 0.1) : simd_float3(0.0, 0.0, 0.0)
            var uniform = LightUniforms(
                lightCoor: RendererResources.lightColors[i].lightCoor,
                objectColor: RendererResources.lightColors[i].objectColor,
                ambient: ambient)
            modelMatrix.translate(position: RendererResources.cubePositions[i])
                
            modelMatrix.rotate(
                rotation: simd_float3(Float(30).toRadians(), Float(30).toRadians(), 0.0))
            
            modelMatrix.scales(scale: simd_float3(0.2, 0.2, 0.2))

                        
            var modelViewMatrix = viewMatrix * modelMatrix
            
            renderEncoder.setFragmentBytes(&cameraPosition, length: MemoryLayout<simd_float3>.size, index: 1)
            renderEncoder.setFragmentBytes(&uniform, length: MemoryLayout<LightUniforms>.size, index: 2)
            renderEncoder.setVertexBytes(&modelViewMatrix, length: MemoryLayout.stride(ofValue: modelViewMatrix), index: 2)
            
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: RendererResources.cubeIndices.count,
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
