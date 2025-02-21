//
//  Renderer.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/20.
//

import UIKit
import Metal
import MetalKit
import simd

// MARK: - Renderer
class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState
    var vertexDescriptor: MTLVertexDescriptor
    var pipelineDescriptor: MTLRenderPipelineDescriptor
    var depthStencilState: MTLDepthStencilState?
    var depthTexture: MTLTexture!

    var model: Model?
    
    // MARK: - init
    init(mtkView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal 지원 불가")
        }
        
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        mtkView.depthStencilPixelFormat = MTLPixelFormat.depth32Float
        
        self.vertexDescriptor = MTLVertexDescriptor()
        
        self.vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        self.vertexDescriptor.layouts[0].stepFunction = .perVertex
        self.vertexDescriptor.layouts[0].stepRate = 1
        
        self.vertexDescriptor.attributes[0].format = .float3
        self.vertexDescriptor.attributes[0].offset = MemoryLayout.offset(of: \Vertex.position)!
        self.vertexDescriptor.attributes[0].bufferIndex = 0

        self.vertexDescriptor.attributes[1].format = .float2
        self.vertexDescriptor.attributes[1].offset = MemoryLayout.offset(of: \Vertex.texCoord)!
        self.vertexDescriptor.attributes[1].bufferIndex = 0
        
        // 렌더 파이프라인 설정
        self.pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertex_main")!
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragment_main")!
        
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        pipelineDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("파이프라인 상태 생성 실패: \(error)")
        }
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = MTLCompareFunction.less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = self.device.makeDepthStencilState(descriptor: depthStencilDescriptor)

        super.init()
        
        mtkView.delegate = self
        mtkView.device = device

        loadModel(name: "backpack")
    } // init
        
    // MARK: - MTKViewDelegate
    // ....
    
    // MARK: - draw
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0,
                                                                            green: 0.0,
                                                                            blue: 0.0,
                                                                            alpha: 1.0)
        renderPassDescriptor.depthAttachment.texture = depthTexture
        renderPassDescriptor.depthAttachment.loadAction = .clear
        renderPassDescriptor.depthAttachment.storeAction = .dontCare
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        encoder.setRenderPipelineState(self.pipelineState)
        encoder.setDepthStencilState(self.depthStencilState)
        
        var modelMatrix = simd_float4x4.identity()
        //modelMatrix.translate(position: simd_float3(repeating: 0.0))
        modelMatrix.scales(scale: simd_float3(repeating: 5.0))
        
        var viewMatrix = simd_float4x4.lookAt(eyePosition: simd_float3(0.0, 0.0, 3.0),
                                              targetPosition: simd_float3(repeating: 0.0),
                                              upVec: simd_float3(0.0, 1.0, 0.0))
        
        var projectionMatrix = simd_float4x4.perspective(fov: Float(45).toRadians(),
                                                         aspectRatio: 1.0,
                                                         nearPlane: 0.1,
                                                         farPlane: 100.0)
        
        encoder.setVertexBytes(&modelMatrix, length: MemoryLayout<simd_float4x4>.size, index: 0)
        encoder.setVertexBytes(&viewMatrix, length: MemoryLayout<simd_float4x4>.size, index: 1)
        encoder.setVertexBytes(&projectionMatrix, length: MemoryLayout<simd_float4x4>.size, index: 2)
        
        model?.draw(encoder: encoder)
        
        encoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    } // draw
    
    // MARK: - mtkView
    // 화면 크기 변경 대응
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    } // mtkView
    
    // .....
    
    // MARK: - loadModel
    private func loadModel(name: String) {
        guard let modelPath = Bundle.main.path(forResource: name, ofType: "obj") else {
            print("모델 파일을 찾을 수 없음")
            return
        }
        print("Model load 시작")
        self.model = Model(device: device, path: modelPath, vertexDescriptor: vertexDescriptor)
    } // loadModel
    
} // Renderer
