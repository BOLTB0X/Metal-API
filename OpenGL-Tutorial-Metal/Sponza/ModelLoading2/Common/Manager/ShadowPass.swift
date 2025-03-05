//
//  ShadowPass.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/03/05.
//

import MetalKit

// MARK: - ShadowPass
class ShadowPass {
    // Propertys
    var shadowMap: MTLTexture?
    private var vertexDescriptor: MTLVertexDescriptor
    private var renderPipelineState: MTLRenderPipelineState?
    
    // MARK: - init
    init(device: MTLDevice, mkView: MTKView,
         vertexFunction: String, fragmentFunction: String) {
        self.vertexDescriptor = DescriptorManager.buildVertexDescriptor(attributeLength: 1)
        self.shadowMap = DescriptorManager.buildMTLTextureDescriptor(device: device)
        self.renderPipelineState = DescriptorManager.buildPipelineDescriptor(device: device,
                                                                             metalKitView: mkView,
                                                                             vertexDescriptor: self.vertexDescriptor,
                                                                             vertexFunctionName: vertexFunction,
                                                                             fragmentFunctionName: fragmentFunction)
    } // init
    
    // MARK: - encode
    func encode(commandBuffer: MTLCommandBuffer,
                mkView: MTKView,
                depthStencilState: MTLDepthStencilState?,
                render: (MTLRenderCommandEncoder) -> Void,
                camera: Camera) {
        let renderPassDescriptor = DescriptorManager.buildMTLRenderPassDescriptor(view: mkView,
                                                                                        r: 0.0,
                                                                                        g: 0.0,
                                                                                        b: 0.0,
                                                                                        alpha: 1.0)
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(self.renderPipelineState!)
        renderEncoder.setDepthStencilState(depthStencilState)
        
        var viewUniform = ViewUniform(viewMatrix: camera.getViewMatrix(),
                                      projectionMatrix: camera.getProjectionMatrix())
        renderEncoder.setVertexBytes(&viewUniform, length: MemoryLayout<ViewUniform>.size, index: VertexBufferIndex.viewUniform.rawValue)
        
        render(renderEncoder)
        
        renderEncoder.endEncoding()
    } // encode
    
} // ShadowPass
