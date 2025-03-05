//
//  SetupManager.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/25.
//

import Metal
import MetalKit

// MARK: - VertexDescriptorManager
struct DescriptorManager {
    // MARK: - buildVertexDescriptor
    static func buildVertexDescriptor(attributeLength: Int) -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.layouts[VertexBufferIndex.attributes.rawValue].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[VertexBufferIndex.attributes.rawValue].stepFunction = .perVertex
        vertexDescriptor.layouts[VertexBufferIndex.attributes.rawValue].stepRate = 1
        
        
        for attribute in VertexAttribute.allCases {
            vertexDescriptor.attributes[attribute.rawValue].format = attribute.format
            vertexDescriptor.attributes[attribute.rawValue].offset = attribute.offset
            vertexDescriptor.attributes[attribute.rawValue].bufferIndex = VertexBufferIndex.attributes.rawValue
            
            if attribute.rawValue + 1 == attributeLength {
                break
            }
        } // for
        
        
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
    
    // MARK: - buildDepthStencilDescriptor
    static func buildDepthStencilDescriptor(device: MTLDevice) -> MTLDepthStencilState? {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        
        if let depth = device.makeDepthStencilState(descriptor: depthStencilDescriptor) {
            return depth
        }
        
        print("buildDepthStencilDescriptor 실패")
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
    
    // MARK: - buildSamplerDescriptor
    static func buildSamplerDescriptor(device: MTLDevice,
                                       minFilter: MTLSamplerMinMagFilter,
                                       magFilter: MTLSamplerMinMagFilter,
                                       compareFunction: MTLCompareFunction) -> MTLSamplerState? {
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = minFilter
        samplerDescriptor.magFilter = magFilter
        samplerDescriptor.compareFunction = compareFunction
        
        if let res = device.makeSamplerState(descriptor: samplerDescriptor) {
            return res
        }
        
        print("buildSamplerDescriptor 실패")
        return nil
    } // buildSamplerDescriptor
    
    // MARK: - buildMTLTextureDescriptor
    static func buildMTLTextureDescriptor(device: MTLDevice) -> MTLTexture? {
        let mapDescriptor = MTLTextureDescriptor()
        mapDescriptor.pixelFormat = MTLPixelFormat.depth32Float
        mapDescriptor.usage = [.shaderRead, .renderTarget]
        mapDescriptor.width = 2048
        mapDescriptor.height = 2048
        mapDescriptor.storageMode = MTLStorageMode.private
        
        if let res = device.makeTexture(descriptor: mapDescriptor) {
            return res
        }
        
        print("buildMTLTextureDescriptor 실패")
        return nil
    } // buildMTLTextureDescriptor
    
} // VertexDescriptorManager
