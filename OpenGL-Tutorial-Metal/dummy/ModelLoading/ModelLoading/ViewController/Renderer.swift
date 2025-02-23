//
//  Renderer.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/20.
//

import UIKit
import Metal
import MetalKit
import simd

// MARK: - Renderer
class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    var vertexDescriptor: MTLVertexDescriptor
    
    var library: MTLLibrary
    var vertexFunction: MTLFunction
    var fragmentFunction: MTLFunction
    
    var pipelineState: MTLRenderPipelineState
    var depthStencilState: MTLDepthStencilState?

    var model: Model?
    
    // MARK: - init
    init?(mtkView: MTKView) {
        self.device = mtkView.device!
        self.commandQueue = self.device.makeCommandQueue()!
        
        mtkView.depthStencilPixelFormat = MTLPixelFormat.depth32Float
        
        // Vertex descriptor
        self.vertexDescriptor = MTLVertexDescriptor()
        
        self.vertexDescriptor.layouts[30].stride = MemoryLayout<Vertex>.stride
        self.vertexDescriptor.layouts[30].stepFunction = .perVertex
        self.vertexDescriptor.layouts[30].stepRate = 1
        
        self.vertexDescriptor.attributes[0].format = .float3
        self.vertexDescriptor.attributes[0].offset = MemoryLayout.offset(of: \Vertex.position)!
        self.vertexDescriptor.attributes[0].bufferIndex = 30
        
        self.vertexDescriptor.attributes[1].format = .float3
        self.vertexDescriptor.attributes[1].offset = MemoryLayout.offset(of: \Vertex.normal)!
        self.vertexDescriptor.attributes[1].bufferIndex = 30

        self.vertexDescriptor.attributes[2].format = .float2
        self.vertexDescriptor.attributes[2].offset = MemoryLayout.offset(of: \Vertex.texCoord)!
        self.vertexDescriptor.attributes[2].bufferIndex = 30
        
        self.library = device.makeDefaultLibrary()!
        self.vertexFunction = library.makeFunction(name: "vertex_main")!
        self.fragmentFunction = library.makeFunction(name: "fragment_main")!
        
        // 렌더 파이프라인 설정
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat
        
        do {
            self.pipelineState = try self.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("파이프라인 상태 생성 실패: \(error)")
        }
        
        // depth 설정
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = MTLCompareFunction.less
        depthStencilDescriptor.isDepthWriteEnabled = true
        self.depthStencilState = self.device.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
        // 모델 로딩
        let textureLoader = MTKTextureLoader(device: self.device)
        let url = Bundle.main.url(forResource: "backpack", withExtension: "obj")!
        self.model = Model()
        self.model?.loadModel(device: device, vertexDescriptor: vertexDescriptor, url: url, textureLoader: textureLoader)
        
        //lastTime = Date().timeIntervalSince1970
        
        super.init()
        
    } // init
        
    // MARK: - MTKViewDelegate
    // ....
    
    // MARK: - draw
    func draw(in view: MTKView) {
        //print("Renderer Draw")
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.416, green: 0.636, blue: 0.722, alpha: 1.0)
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        encoder.setRenderPipelineState(self.pipelineState)
        encoder.setDepthStencilState(self.depthStencilState)
        
        model?.draw(encoder: encoder)
        
        encoder.endEncoding()
        let drawable = view.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
    } // draw
    
    // MARK: - mtkView
    // 화면 크기 변경 대응
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    } // mtkView
    
    // .....
    
    // MARK: - loadModel
//    private func loadModel(name: String, textureLoader: MTKTextureLoader) {
//        guard let modelPath = Bundle.main.path(forResource: name, ofType: "obj") else {
//            print("모델 파일을 찾을 수 없음")
//            return
//        }
//
//        self.model = Model(device: device, path: modelPath,
//                           vertexDescriptor: vertexDescriptor, textureLoader: textureLoader)
//    } // loadModel
//
} // Renderer
