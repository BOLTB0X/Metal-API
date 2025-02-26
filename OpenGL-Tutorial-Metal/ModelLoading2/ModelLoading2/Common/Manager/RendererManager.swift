//
//  Renderer.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import Metal
import MetalKit
import simd

// MARK: - RendererManager
class RendererManager: NSObject, MTKViewDelegate {
    // Metal objects
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var vertexDescriptor: MTLVertexDescriptor
    private var renderPipelineState: MTLRenderPipelineState?
    private var depthStencilState: MTLDepthStencilState?
    
    // Model objects
    private var model: Model?
    
    // property
    private let camera = Camera(position: simd_float3(0.0, 0.0, 3.0))
    private let lightInfo: (ambient: simd_float3, diffuse: simd_float3, specular: simd_float3) = (simd_float3(repeating: 0.4), simd_float3(repeating: 1.0), simd_float3(repeating: 0.8))
    private let vertexFunction: String = "vertexFunction"
    private let fragmentFunction: String = "fragmentFunction"
    private let modelName: String = "backpack"
    private let modelType: String = "obj"
    
    // MARK: - init
    init?(metalKitView: MTKView) {
        self.device = metalKitView.device!
        self.commandQueue = self.device.makeCommandQueue()!
        
        metalKitView.depthStencilPixelFormat = MTLPixelFormat.depth32Float
        
        self.vertexDescriptor = VertexDescriptorManager.buildVertexDescriptor()
        self.renderPipelineState = VertexDescriptorManager.buildPipelineDescriptor(device: self.device,
                                                                                   metalKitView: metalKitView,
                                                                                   vertexDescriptor: self.vertexDescriptor,
                                                                                   vertexFunctionName: self.vertexFunction,
                                                                                   fragmentFunctionName: self.fragmentFunction)
        self.depthStencilState = VertexDescriptorManager.buildDepthStencilDescriptor(device: self.device)
        
        super.init()
        
        self.model = setupModel(device: self.device,
                                vertexDescriptor: self.vertexDescriptor,
                                modelName: self.modelName,
                                modelType: self.modelType)
    } // init
    
    // MARK: - MTKViewDelegate
    // ...
    // MARK: - draw
    func draw(in view: MTKView) {
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        
        let renderPassDescriptor = VertexDescriptorManager.buildMTLRenderPassDescriptor(view: view,
                                                                                        r: 0.0,
                                                                                        g: 0.0,
                                                                                        b: 0.0,
                                                                                        alpha: 1.0)
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(self.renderPipelineState!)
        renderEncoder.setDepthStencilState(self.depthStencilState)
        
        var viewUniform = ViewUniform(viewMatrix: self.camera.getViewMatrix(),
                                      projectionMatrix: self.camera.getProjectionMatrix())
        renderEncoder.setVertexBytes(&viewUniform, length: MemoryLayout<ViewUniform>.size, index: VertexBufferIndex.viewUniform.rawValue)
        
        var lightUniform = LightUniform(position: self.camera.position,
                                        direction: self.camera.front,
                                        ambient: self.lightInfo.ambient,
                                        diffuse: self.lightInfo.diffuse,
                                        specular: self.lightInfo.specular)
        renderEncoder.setFragmentBytes(&lightUniform, length: MemoryLayout<LightUniform>.size, index: FragmentBufferIndex.lightUniform.rawValue)
        
        model?.draw(renderEncoder: renderEncoder)
        
        renderEncoder.endEncoding()
        
        let drawable = view.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
    } // draw
    
    // MARK: - mtkView
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    } // mtkView
    
    //
    
    // MARK: - Private
    // ...
    // MARK: - setupModel
    private func setupModel(device: MTLDevice,
                            vertexDescriptor: MTLVertexDescriptor,
                            modelName: String,
                            modelType: String) -> Model? {
        let textureLoader = MTKTextureLoader(device: device)
        let url = Bundle.main.url(forResource: modelName, withExtension: modelType)!
        let model = Model(device: device, url: url, vertexDescriptor: vertexDescriptor, textureLoader: textureLoader)
        
        return model
    } // setupModel
    
} // RendererManager
