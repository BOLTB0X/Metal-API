//
//  SetupManager.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/25.
//

import Metal
import MetalKit

// MARK: - SetupManager
struct BuildManager {
    // MARK: - buildVertexDescriptor
    static func buildVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.layouts[30].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[30].stepFunction = MTLVertexStepFunction.perVertex
        vertexDescriptor.layouts[30].stepRate = 1
        
        vertexDescriptor.attributes[0].format = MTLVertexFormat.float3
        vertexDescriptor.attributes[0].offset = MemoryLayout.offset(of: \Vertex.position)!
        vertexDescriptor.attributes[0].bufferIndex = 30
        
        vertexDescriptor.attributes[1].format = MTLVertexFormat.float2
        vertexDescriptor.attributes[1].offset = MemoryLayout.offset(of: \Vertex.texCoord)!
        vertexDescriptor.attributes[1].bufferIndex = 30
        
        vertexDescriptor.attributes[2].format = MTLVertexFormat.float3
        vertexDescriptor.attributes[2].offset = MemoryLayout.offset(of: \Vertex.normal)!
        vertexDescriptor.attributes[2].bufferIndex = 30
        
        vertexDescriptor.attributes[3].format = MTLVertexFormat.float4
        vertexDescriptor.attributes[3].offset = MemoryLayout.offset(of: \Vertex.tangent)!
        vertexDescriptor.attributes[3].bufferIndex = 30
        
        return vertexDescriptor
    } // buildVertexDescriptor
    
    // MARK: - buildPipeline
    static func buildPipeline(device: MTLDevice,
                              metalKitView: MTKView,
                              vertexDescriptor: MTLVertexDescriptor,
                              vertexFunctionName: String,
                              fragmentFunctionName: String) -> MTLRenderPipelineState? {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: vertexFunctionName)!
        let fragmentFunction = library.makeFunction(name: fragmentFunctionName)!
        
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
    static func buildDepthStencil(device: MTLDevice) -> MTLDepthStencilState? {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        
        if let depth = device.makeDepthStencilState(descriptor: depthStencilDescriptor) {
            return depth
        }
        
        return nil
    } // buildDepthStencil
    
    // MARK: - buildModel
    static func buildModel(device: MTLDevice,
                           vertexDescriptor: MTLVertexDescriptor,
                           modelName: String,
                           modelType: String) -> Model? {
        let textureLoader = MTKTextureLoader(device: device)
        let url = Bundle.main.url(forResource: modelName, withExtension: modelType)!
        let model = Model()
        
        model.loadModel(device: device, url: url, vertexDescriptor: vertexDescriptor, textureLoader: textureLoader)
        
        return model
    } // buildModel
    
    // MARK: - buildMDLVertexDescriptor
    static func buildMDLVertexDescriptor(vertexDescriptor: MTLVertexDescriptor) -> MDLVertexDescriptor {
        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let attrPosition = descriptor.attributes[0] as! MDLVertexAttribute
        attrPosition.name = MDLVertexAttributePosition
        descriptor.attributes[0] = attrPosition
        
        let attrTexCoord = descriptor.attributes[1] as! MDLVertexAttribute
        attrTexCoord.name = MDLVertexAttributeTextureCoordinate
        descriptor.attributes[1] = attrTexCoord
        
        let attrNormal = descriptor.attributes[2] as! MDLVertexAttribute
        attrNormal.name = MDLVertexAttributeNormal
        descriptor.attributes[2] = attrNormal
        
        let attrTangent = descriptor.attributes[3] as! MDLVertexAttribute
        attrTangent.name = MDLVertexAttributeTangent
        descriptor.attributes[3] = attrTangent
        
        return descriptor;
    } // buildMDLVertexDescriptor
    
    
} // SetupManager
