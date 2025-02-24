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
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var vertexDescriptor: MTLVertexDescriptor
    private var renderPipelineState: MTLRenderPipelineState?
    private var depthStencilState: MTLDepthStencilState?
    
    // Model objects
    private var model: Model?
    private var camera = Camera(position: simd_float3(0.0, 0.0, 3.0))
    
    // MARK: - init
    init?(metalKitView: MTKView) {
        self.device = metalKitView.device!
        self.commandQueue = self.device.makeCommandQueue()!
        
        metalKitView.depthStencilPixelFormat = MTLPixelFormat.depth32Float
        
        self.vertexDescriptor = Renderer.buildVertexDescriptor()
        self.renderPipelineState = Renderer.buildPipeline(device: self.device,
                                                          metalKitView: metalKitView,
                                                          vertexDescriptor: self.vertexDescriptor,
                                                          vertexFunctionName: "vertexFunction",
                                                          fragmentFunctionName: "fragmentFunction")
        self.depthStencilState = Renderer.buildDepthStencil(device: self.device)
        self.model = Renderer.buildModel(device: self.device,
                                         vertexDescriptor: self.vertexDescriptor,
                                         modelName: "backpack",
                                         modelType: "obj")
        super.init()
    } // init
    
    // MARK: - MTKViewDelegate
    // ...
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
        
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(position: simd_float3(repeating: 0.0))
        modelMatrix.scales(scale: simd_float3(repeating: 0.3))
        var viewMatrix = self.camera.getViewMatrix()
        var projectionMatrix = simd_float4x4.perspective(fov: camera.zoom.toRadians(),
                                                         aspectRatio: Float(view.drawableSize.width / view.drawableSize.height),
                                                         nearPlane: 0.1,
                                                         farPlane: 100.0)
        
        renderEncoder.setVertexBytes(&modelMatrix, length: MemoryLayout<simd_float4x4>.size, index: 0)

        renderEncoder.setVertexBytes(&viewMatrix, length: MemoryLayout<simd_float4x4>.size, index: 1)
        renderEncoder.setVertexBytes(&projectionMatrix, length: MemoryLayout<simd_float4x4>.size, index: 2)
                
        model?.draw(renderEncoder: renderEncoder)
        
        renderEncoder.endEncoding()
        
        let drawable = view.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
    } // draw

    // MARK: - mtkView
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    } // mtkView
    
} // Renderer

// MARK: - build Setup
extension Renderer {
    // MARK: - buildVertexDescriptor
    static private func buildVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.layouts[30].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[30].stepFunction = MTLVertexStepFunction.perVertex
        vertexDescriptor.layouts[30].stepRate = 1

        vertexDescriptor.attributes[0].format = MTLVertexFormat.float3
        vertexDescriptor.attributes[0].offset = MemoryLayout.offset(of: \Vertex.position)!
        vertexDescriptor.attributes[0].bufferIndex = 30
        
        vertexDescriptor.attributes[1].format = MTLVertexFormat.float3
        vertexDescriptor.attributes[1].offset = MemoryLayout.offset(of: \Vertex.normal)!
        vertexDescriptor.attributes[1].bufferIndex = 30

        vertexDescriptor.attributes[2].format = MTLVertexFormat.float2
        vertexDescriptor.attributes[2].offset = MemoryLayout.offset(of: \Vertex.texCoord)!
        vertexDescriptor.attributes[2].bufferIndex = 30
        
        return vertexDescriptor
    } // buildVertexDescriptor
    
    // MARK: - buildPipeline
    static private func buildPipeline(device: MTLDevice,
                                      metalKitView: MTKView,
                                      vertexDescriptor: MTLVertexDescriptor,
                                      vertexFunctionName: String,
                                      fragmentFunctionName: String) -> MTLRenderPipelineState? {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: vertexFunctionName)!
        let fragmentFunction = library.makeFunction(name: fragmentFunctionName)!
        
        // Render pipeline state
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        renderPipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        renderPipelineStateDescriptor.depthAttachmentPixelFormat = metalKitView.depthStencilPixelFormat
        
        do {
            return try device.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
        } catch {
            fatalError("renderPipelineState 생성 실패 \(error)")
        } // do - catch
        
    } // buildPipeline
    
    // MARK: - buildDepthStencil
    static private func buildDepthStencil(device: MTLDevice) -> MTLDepthStencilState? {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        
        if let depth = device.makeDepthStencilState(descriptor: depthStencilDescriptor) {
            return depth
        }
        
        return nil
    } // buildDepthStencil
    
    // MARK: - buildModel
    static private func buildModel(device: MTLDevice, vertexDescriptor: MTLVertexDescriptor,
                                   modelName: String, modelType: String) -> Model? {
        let textureLoader = MTKTextureLoader(device: device)
        let url = Bundle.main.url(forResource: modelName, withExtension: modelType)!
        let model = Model()
        
        model.loadModel(device: device, url: url, vertexDescriptor: vertexDescriptor, textureLoader: textureLoader)
        
        return model
    } // buildModel
}
