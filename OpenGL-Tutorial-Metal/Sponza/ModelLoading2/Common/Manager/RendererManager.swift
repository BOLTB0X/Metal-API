//
//  Renderer.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import Metal
import MetalKit

// MARK: - RendererManager
class RendererManager: NSObject, MTKViewDelegate {
    // Metal objects
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var depthStencilState: MTLDepthStencilState?
    
    // Pass
    private var modelPass: ModelPass
    private var shadowPass: ShadowPass
    
    // Model objects
    private var model: Model?
    
    // 카메라
    public var camera = Camera(position: simd_float3(4.0, 1.0, 0.0))
    
    // property
    private let modelVertexFunction: String = "vertexFunction"
    private let modelFragmentFunction: String = "fragmentFunction"
    private let shadowVertexFunction: String = "shadow_VertexFunction"
    private let shadowFragmentFunction: String = "shadow_FragmentFunction"
    private let modelName: String = "Sponza_Scene"
    private let modelType: String = "usdz"
    
    // MARK: - init
    init?(metalKitView: MTKView) {
        self.device = metalKitView.device!
        self.commandQueue = self.device.makeCommandQueue()!
        
        metalKitView.depthStencilPixelFormat = MTLPixelFormat.depth32Float
        
        self.shadowPass = ShadowPass(device: self.device, mkView: metalKitView, vertexFunction: shadowVertexFunction, fragmentFunction: shadowFragmentFunction)
        self.modelPass = ModelPass(device: self.device, mkView: metalKitView, vertexFunction: modelVertexFunction, fragmentFunction: modelFragmentFunction)
        self.depthStencilState = DescriptorManager.buildDepthStencilDescriptor(device: self.device)
        
        super.init()
        
        self.model = setupModel(device: self.device,
                                vertexDescriptor: self.modelPass.vertexDescriptor,
                                modelName: self.modelName,
                                modelType: self.modelType)
    } // init
    
    // MARK: - MTKViewDelegate
    // ...
    // MARK: - draw
    func draw(in view: MTKView) {
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        
        shadowPass.encode(commandBuffer: commandBuffer,
                          mkView: view,
                          depthStencilState: self.depthStencilState,
                          render: { (renderEncoder: MTLRenderCommandEncoder) in
                                        self.model?.draw(renderEncoder: renderEncoder, bindTextures: false) },
                          camera: self.camera)
        
        modelPass.encode(commandBuffer: commandBuffer,
                         mkView: view,
                         depthStencilState: self.depthStencilState,
                         render: { (renderEncoder: MTLRenderCommandEncoder) in
                                        self.model?.draw(renderEncoder: renderEncoder, bindTextures: true) },
                         camera: &self.camera,
                         shadowMap: self.shadowPass.shadowMap)
    
        let drawable = view.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
    } // draw
    
    // MARK: - mtkView
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    } // mtkView
    
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
