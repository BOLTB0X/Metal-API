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
    
    private let lightDir : simd_float3 = simd_float3(0.436436, -0.572872, 0.218218)

    // MARK: - init
    init(device: MTLDevice, mkView: MTKView,
         vertexFunction: String, fragmentFunction: String) {
        self.vertexDescriptor = DescriptorManager.buildVertexDescriptor(attributeLength: 1)
        self.shadowMap = DescriptorManager.buildMTLTextureDescriptor(device: device)
        self.renderPipelineState = DescriptorManager.buildShadowPipelineDescriptor(device: device,
                                                                                   shadowMap: self.shadowMap,
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
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.depthAttachment.texture = self.shadowMap
        renderPassDescriptor.depthAttachment.loadAction = .clear
        renderPassDescriptor.depthAttachment.storeAction = .store
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(self.renderPipelineState!)
        renderEncoder.setDepthStencilState(depthStencilState)
        
//        renderEncoder.setFrontFacing(.clockwise)
//        renderEncoder.setCullMode(.back)

        var lightUniform = LightUniform(viewMatrix: camera.getViewMatrix(eyePosition: lightDir),
                                        projectionMatrix: simd_float4x4.identity().orthographicProjection(l: -10.0, r: 10.0, bottom: -10.0, top: 10.0, zNear: -25.0, zFar: 25.0))
        renderEncoder.setVertexBytes(&lightUniform, length: MemoryLayout<LightUniform>.size, index: VertexBufferIndex.viewUniform.rawValue)
        
        render(renderEncoder)
        
        renderEncoder.endEncoding()
    } // encode
    
} // ShadowPass
