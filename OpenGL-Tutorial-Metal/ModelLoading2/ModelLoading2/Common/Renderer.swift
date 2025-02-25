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
        
        self.vertexDescriptor = BuildManager.buildVertexDescriptor()
        self.renderPipelineState = BuildManager.buildPipeline(device: self.device,
                                                          metalKitView: metalKitView,
                                                          vertexDescriptor: self.vertexDescriptor,
                                                          vertexFunctionName: "vertexFunction",
                                                          fragmentFunctionName: "fragmentFunction")
        self.depthStencilState = BuildManager.buildDepthStencil(device: self.device)
        self.model = BuildManager.buildModel(device: self.device,
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
        
        var viewUniform = ViewUniform(viewMatrix: self.camera.getViewMatrix(),
                                      projectionMatrix: simd_float4x4.perspective(fov: self.camera.zoom.toRadians(),
                                                                                  aspectRatio: 1.0,
                                                                                  nearPlane: 0.1,
                                                                                  farPlane: 100.0))
        renderEncoder.setVertexBytes(&viewUniform, length: MemoryLayout<ViewUniform>.size, index: 0)
        
        var lightUniform = LightUniform(position: self.camera.position,
                                        direction: self.camera.front,
                                        ambient: simd_float3(repeating: 0.4),
                                        diffuse: simd_float3(repeating: 1.0),
                                        specular: simd_float3(repeating: 0.8))
        renderEncoder.setFragmentBytes(&lightUniform, length: MemoryLayout<LightUniform>.size, index: 0)
        
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
