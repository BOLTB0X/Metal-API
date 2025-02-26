//
//  SetupManager.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/25.
//

import Metal
import MetalKit

// MARK: - VertexDescriptorManager
struct VertexDescriptorManager {
    // MARK: - buildVertexDescriptor
    static func buildVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.layouts[VertexBufferIndex.attributes.rawValue].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[VertexBufferIndex.attributes.rawValue].stepFunction = .perVertex
        vertexDescriptor.layouts[VertexBufferIndex.attributes.rawValue].stepRate = 1
        
        for attribute in VertexAttribute.allCases {
            vertexDescriptor.attributes[attribute.rawValue].format = attribute.format
            vertexDescriptor.attributes[attribute.rawValue].offset = attribute.offset
            vertexDescriptor.attributes[attribute.rawValue].bufferIndex = VertexBufferIndex.attributes.rawValue
        }
        
        return vertexDescriptor
    } // buildVertexDescriptor
    
    // MARK: - buildPipelineDescriptor
    static func buildPipelineDescriptor(device: MTLDevice,
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
    static func buildDepthStencilDescriptor(device: MTLDevice) -> MTLDepthStencilState? {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        
        if let depth = device.makeDepthStencilState(descriptor: depthStencilDescriptor) {
            return depth
        }
        
        return nil
    } // buildDepthStencil
    
    // MARK: - buildMTLRenderPassDescriptor
    static func buildMTLRenderPassDescriptor(view: MTKView, r: Double, g: Double, b: Double, alpha: Double) -> MTLRenderPassDescriptor {
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: r,
                                                                            green: g,
                                                                            blue: b,
                                                                            alpha: alpha)
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        
        return renderPassDescriptor
    } // buildMTLRenderPassDescriptor
    
    // MARK: - buildMDLVertexDescriptor
    static func buildMDLVertexDescriptor(vertexDescriptor: MTLVertexDescriptor) -> MDLVertexDescriptor {
        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        VertexAttribute.allCases.forEach { attribute in
            if let mdlAttribute = descriptor.attributes[attribute.rawValue] as? MDLVertexAttribute {
                mdlAttribute.name = attribute.name
                descriptor.attributes[attribute.rawValue] = mdlAttribute
            }
        }
        
        return descriptor;
    } // buildMDLVertexDescriptor
    
} // VertexDescriptorManager
