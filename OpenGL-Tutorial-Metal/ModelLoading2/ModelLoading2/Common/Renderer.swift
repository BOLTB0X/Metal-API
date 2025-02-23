//
//  Renderer.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import Metal
import MetalKit
import simd

// MARK: - Renderer
class Renderer: NSObject, MTKViewDelegate {
    // Metal objects
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    var vertexDescriptor: MTLVertexDescriptor
    var library: MTLLibrary
    var vertexFunction: MTLFunction
    var fragmentFunction: MTLFunction
    var renderPipelineState: MTLRenderPipelineState?
    var depthStencilState: MTLDepthStencilState?
    
    var model: Model?
    var camera = Camera()
    
    // MARK: - init
    init?(metalKitView: MTKView) {
        self.device = metalKitView.device!
        self.commandQueue = self.device.makeCommandQueue()!
        
        metalKitView.depthStencilPixelFormat = MTLPixelFormat.depth32Float
        
        vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.layouts[30].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[30].stepRate = 1
        vertexDescriptor.layouts[30].stepFunction = MTLVertexStepFunction.perVertex

        vertexDescriptor.attributes[0].format = MTLVertexFormat.float3
        vertexDescriptor.attributes[0].offset = MemoryLayout.offset(of: \Vertex.position)!
        vertexDescriptor.attributes[0].bufferIndex = 30
        
        vertexDescriptor.attributes[1].format = MTLVertexFormat.float3
        vertexDescriptor.attributes[1].offset = MemoryLayout.offset(of: \Vertex.normal)!
        vertexDescriptor.attributes[1].bufferIndex = 30

        vertexDescriptor.attributes[2].format = MTLVertexFormat.float2
        vertexDescriptor.attributes[2].offset = MemoryLayout.offset(of: \Vertex.texCoord)!
        vertexDescriptor.attributes[2].bufferIndex = 30
        
        self.library = device.makeDefaultLibrary()!
        self.vertexFunction = library.makeFunction(name: "vertexFunction")!
        self.fragmentFunction = library.makeFunction(name: "fragmentFunction")!
        
        // Render pipeline state
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        renderPipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        renderPipelineStateDescriptor.depthAttachmentPixelFormat = metalKitView.depthStencilPixelFormat
        
        do {
            self.renderPipelineState = try self.device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
        } catch {
            print("renderPipelineState 생성 실패")
        }
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = MTLCompareFunction.less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = self.device.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
        let textureLoader = MTKTextureLoader(device: self.device)
        let url = Bundle.main.url(forResource: "backpack", withExtension: "obj")!
        self.model = Model()
        
        self.model?.loadModel(device: device, url: url, vertexDescriptor: vertexDescriptor, textureLoader: textureLoader)
        
        super.init()
    } // init

    // MARK: - draw
    func draw(in view: MTKView) {
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0,
                                                                            green: 0.0,
                                                                            blue: 0.0,
                                                                            alpha: 1.0)
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(self.renderPipelineState!)
        renderEncoder.setDepthStencilState(self.depthStencilState)
        
        var projectionMatrix = simd_float4x4.perspective(fov: Float(45.0).toRadians(),
                                                         aspectRatio: 1.0,
                                                         nearPlane: 0.1,
                                                         farPlane: 100.0)
        var viewMatrix = self.camera.getViewMatrix()
        
        renderEncoder.setVertexBytes(&projectionMatrix, length: MemoryLayout.stride(ofValue: projectionMatrix), index: 0)
        renderEncoder.setVertexBytes(&viewMatrix, length: MemoryLayout.stride(ofValue: viewMatrix), index: 1)
        //renderEncoder.setFragmentBytes(&self.camera.position, length: MemoryLayout.stride(ofValue: self.camera.position), index: 0)
        
        model?.render(renderEncoder: renderEncoder)
        
        renderEncoder.endEncoding()
        
        let drawable = view.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
    } // draw

    // MARK: - mtkView
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    } // mtkView
}
