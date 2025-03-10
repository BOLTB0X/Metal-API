//
//  ModelPass.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/03/05.
//

import Metal
import MetalKit

// MARK: - ModelPass
class ModelPass {
    // Propertys
    var vertexDescriptor: MTLVertexDescriptor
    private var renderPipelineState: MTLRenderPipelineState?
    private var shadowSampler: MTLSamplerState?

    private let lightDir : simd_float3 = simd_float3(0.436436, -0.572872, 0.218218)
    
    // MARK: - init
    init(device: MTLDevice, mkView: MTKView,
         vertexFunction: String, fragmentFunction: String) {
        self.vertexDescriptor = DescriptorManager.buildVertexDescriptor(attributeLength: 4)
        self.renderPipelineState = DescriptorManager.buildPipelineDescriptor(device: device,
                                                                             metalKitView: mkView,
                                                                             vertexDescriptor: self.vertexDescriptor,
                                                                             vertexFunctionName: vertexFunction,
                                                                             fragmentFunctionName: fragmentFunction)
        self.shadowSampler = DescriptorManager.buildSamplerDescriptor(device: device,
                                                                      minFilter: .linear,
                                                                      magFilter: .linear,
                                                                      compareFunction: .less)
    } // init
    
    // MARK: - encode
    func encode(commandBuffer: MTLCommandBuffer,
                mkView: MTKView,
                depthStencilState: MTLDepthStencilState?,
                render: (MTLRenderCommandEncoder) -> Void,
                camera: inout Camera,
                shadowMap: MTLTexture?) {
        let renderPassDescriptor = DescriptorManager.buildMTLRenderPassDescriptor(view: mkView,
                                                                                        r: 0.416,
                                                                                        g: 0.636,
                                                                                        b: 0.722,
                                                                                        alpha: 1.0)
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(self.renderPipelineState!)
        renderEncoder.setDepthStencilState(depthStencilState)
        
//        renderEncoder.setFrontFacing(.clockwise)
//        renderEncoder.setCullMode(.back)
        
        var viewUniform = ViewUniform(viewMatrix: camera.getViewMatrix(),
                                      projectionMatrix: camera.getProjectionMatrix())
        renderEncoder.setVertexBytes(&viewUniform, length: MemoryLayout<ViewUniform>.size, index: VertexBufferIndex.viewUniform.rawValue)
        
        var lightUniform = LightUniform(viewMatrix: camera.getViewMatrix(eyePosition: lightDir),
                                        projectionMatrix: simd_float4x4.identity().orthographicProjection(l: -10.0, r: 10.0, bottom: -10.0, top: 10.0, zNear: -25.0, zFar: 25.0))
        renderEncoder.setFragmentBytes(&lightUniform, length: MemoryLayout<LightUniform>.size, index: FragmentBufferIndex.lightUniform.rawValue)
        
        renderEncoder.setFragmentBytes(&camera.position, length: MemoryLayout<simd_float3>.size, index: FragmentBufferIndex.cameraPosition.rawValue)
        
        renderEncoder.setFragmentTexture(shadowMap!, index: 0)
        renderEncoder.setFragmentSamplerState(self.shadowSampler, index: 0)
        
        render(renderEncoder)
        
        renderEncoder.endEncoding()
    } // encode
} // ModelPass
