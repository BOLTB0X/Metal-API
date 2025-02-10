//
//  RendererViewController.swift
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/04.
//

import UIKit
import Metal
import simd

// MARK: - RendererViewController
class RendererViewController: UIViewController {
    public var device: MTLDevice!
    public var metalLayer: CAMetalLayer!
    public var rotation = simd_float3(0, 0, 0)
    public var lightPosition = simd_float3(1.0, 2.5, 2.5)
    public var cameraPosition = simd_float3(5.0, -5.0, 8.0)
    public var lightColor = simd_float3(0.0, 0.0, 0.0)

    private var mainPipelineState: MTLRenderPipelineState!
    private var subPipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    private var vertexBuffer: MTLBuffer!
    private var indexBuffer: MTLBuffer!
    private var modelMatrixBuffer: MTLBuffer!
    private var depthTexture: MTLTexture!
    private var depthStencilState: MTLDepthStencilState!
    private var timer: CADisplayLink!
    
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
            length: RendererResources.cubeVertices.count * MemoryLayout<BasicVertex>.stride,
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
        let fragmentFunction = library?.makeFunction(name: "fragment_shader_main")
        
        // 기존 큐브
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            mainPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError("pipeline 생성 실패: \(error)")
        }
        
        // 광원 큐브
        let fragmentSubFunction = library?.makeFunction(name: "fragment_shader_sub")
        
        let subPipelineDescriptor = MTLRenderPipelineDescriptor()
        subPipelineDescriptor.vertexFunction = vertexFunction //
        subPipelineDescriptor.fragmentFunction = fragmentSubFunction
        subPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        subPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            subPipelineState = try device.makeRenderPipelineState(descriptor: subPipelineDescriptor)
        } catch let error {
            fatalError("광원 큐브 pipeline 생성 실패: \(error)")
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
        var renderEncoder = commandBuffer
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(mainPipelineState)
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(modelMatrixBuffer, offset: 0, index: 1)
        
        renderObjectCube(renderEncoder: &renderEncoder,
                         indexBuffer: indexBuffer)
        
        renderEncoder.setRenderPipelineState(subPipelineState)
        
        renderLightSourceCube(renderEncoder: &renderEncoder,
                              indexBuffer: indexBuffer)
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        return
    } // render
    
    // MARK: - gameLoop
    @objc private func gameLoop() {
        autoreleasepool {
            rotation += simd_float3(Float(1).toRadians(), 0.0, 0.0)
            render()
        }
    } // gameLoop
} // RendererViewController
