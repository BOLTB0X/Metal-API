//
//  RendererViewController.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import UIKit
import Metal
import simd

// MARK: - RendererViewController
class RendererViewController: UIViewController {
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var modelMatrixBuffer: MTLBuffer!
    var texture1: MTLTexture!
    var texture2: MTLTexture!
    var samplerState: MTLSamplerState!
    var depthTexture: MTLTexture!
    var depthStencilState: MTLDepthStencilState!
    var timer: CADisplayLink!
    var rotation = simd_float3(0, 0, 0)
        
    let cubeIndices: [UInt16] = [
        0, 1, 2,  2, 3, 0,        // Front
        4, 5, 6,  6, 7, 4,        // Back
        8, 9, 10,  10, 11, 8,     // Left
        12, 13, 14,  14, 15, 12,  // Right
        16, 17, 18,  18, 19, 16,  // Top
        20, 21, 22,  22, 23, 20   // Bottom
    ]
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMetal()
        setupVertices()
        setupPipeline()
        rendering()
    } // viewDidLoad
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        metalLayer.frame = view.bounds
        //metalLayer.drawableSize = view.bounds.size
    } // viewDidLayoutSubviews
    
    // MARK: - setupMetal
    private func setupMetal() {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("MTLCreateSystemDefaultDevice Error")
        }
        
        device = metalDevice
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        setupDepthTexture()
        samplerState = setupSampler()

        return
    } // setupMetal
    
    // MARK: - setupVertices
    private func setupVertices() {
        do {
            texture1 = try loadTexture("container")
            print("텍스처 1 로드 성공")
        } catch {
            print("텍스처 로드 실패: \(error)")
            return
        }
        
        do {
            texture2 = try loadTexture("awesomeface")
            print("텍스처 2 로드 성공")
        } catch {
            print("텍스처 로드 실패: \(error)")
            return
        }
        
        //        let rectangleVertices: [Vertex] = [
        //            Vertex(position: simd_float3(-0.8, 0.8,  0.0), color: simd_float3(0, 0, 0), texCoord: simd_float2(0, 1)),
        //            Vertex(position: simd_float3( 0.8, 0.8,  0.0), color: simd_float3(0, 0, 0), texCoord: simd_float2(1, 1)),
        //            Vertex(position: simd_float3( -0.8,  -0.8,  0.0), color: simd_float3(0, 0, 0), texCoord: simd_float2(0, 0)),
        //            Vertex(position: simd_float3(0.8,  -0.8,  0.0), color: simd_float3(0, 0, 0), texCoord: simd_float2(1, 0))
        //        ]
        
        let cubeVertices: [Vertex] = [
            // Front
            Vertex(position: simd_float3(-0.5, -0.5,  -0.5), color: simd_float3(0, 0, 0), texCoord: simd_float2(0, 1.0)),
            Vertex(position: simd_float3(0.5, -0.5,  -0.5), color: simd_float3(0, 0, 0), texCoord: simd_float2(1.0, 1.0)),
            Vertex(position: simd_float3(0.5, 0.5,  -0.5), color: simd_float3(0, 0, 0), texCoord: simd_float2(1.0, 0)),
            Vertex(position: simd_float3(-0.5, 0.5,  -0.5), color: simd_float3(0, 0, 0), texCoord: simd_float2(0, 0)),
            
            // Back
            Vertex(position: simd_float3(-0.5, -0.5,  0.5), color: simd_float3(1, 0, 0), texCoord: simd_float2(0, 1.0)),
            Vertex(position: simd_float3(0.5, -0.5,  0.5), color: simd_float3(1, 0, 0), texCoord: simd_float2(1.0, 1.0)),
            Vertex(position: simd_float3(0.5, 0.5,  0.5), color: simd_float3(1, 0, 0), texCoord: simd_float2(1.0, 0)),
            Vertex(position: simd_float3(-0.5, 0.5,  0.5), color: simd_float3(1, 0, 0), texCoord: simd_float2(0, 0)),
            
            // Left
            Vertex(position: simd_float3(-0.5, -0.5,  0.5), color: simd_float3(0, 1, 0), texCoord: simd_float2(0, 1.0)),
            Vertex(position: simd_float3(-0.5, -0.5, -0.5), color: simd_float3(0, 1, 0), texCoord: simd_float2(1.0, 1.0)),
            Vertex(position: simd_float3(-0.5, 0.5, -0.5), color: simd_float3(0, 1, 0), texCoord: simd_float2(1.0, 0)),
            Vertex(position: simd_float3(-0.5, 0.5,  0.5), color: simd_float3(0, 1, 0), texCoord: simd_float2(0, 0)),
            
            // Right
            Vertex(position: simd_float3(0.5, -0.5, -0.5), color: simd_float3(0, 0, 1), texCoord: simd_float2(0, 1.0)),
            Vertex(position: simd_float3(0.5, -0.5,  0.5), color: simd_float3(0, 0, 1), texCoord: simd_float2(1.0, 1.0)),
            Vertex(position: simd_float3(0.5, 0.5,  0.5), color: simd_float3(0, 0, 1), texCoord: simd_float2(1.0, 0)),
            Vertex(position: simd_float3(0.5, 0.5, -0.5), color: simd_float3(0, 0, 1), texCoord: simd_float2(0, 0)),
            
            // Top
            Vertex(position: simd_float3(-0.5, 0.5, -0.5), color: simd_float3(1, 1, 0), texCoord: simd_float2(0, 1.0)),
            Vertex(position: simd_float3(0.5, 0.5, -0.5), color: simd_float3(1, 1, 0), texCoord: simd_float2(1.0, 1.0)),
            Vertex(position: simd_float3(0.5, 0.5,  0.5), color: simd_float3(1, 1, 0), texCoord: simd_float2(1.0, 0)),
            Vertex(position: simd_float3(-0.5, 0.5,  0.5), color: simd_float3(1, 1, 0), texCoord: simd_float2(0, 0)),
            
            // Bottom
            Vertex(position: simd_float3(-0.5, -0.5, -0.5), color: simd_float3(0, 1, 1), texCoord: simd_float2(0, 1.0)),
            Vertex(position: simd_float3(0.5, -0.5, -0.5), color: simd_float3(0, 1, 1), texCoord: simd_float2(1.0, 1.0)),
            Vertex(position: simd_float3(0.5, -0.5,  0.5), color: simd_float3(0, 1, 1), texCoord: simd_float2(1.0, 0)),
            Vertex(position: simd_float3(-0.5, -0.5,  0.5), color: simd_float3(0, 1, 1), texCoord: simd_float2(0, 0)),
        ]
        
        // 큐브 위치에 대한 변환 행렬 계산
        //        var modelMatrices: [matrix_float4x4] = []
        //        for i in 0..<cubePositions.count {
        //            var modelMatrix = matrix_identity_float4x4
        //            translate(matrix: &modelMatrix, position: cubePositions[i])
        //            rotate(matrix: &modelMatrix, rotation: simd_float3(1.0, 0.3, 0.5) + simd_float3(0.0, toRadians(from: Float(i) * 20.0), 0.0))
        //            modelMatrices.append(modelMatrix)
        //        }
        
        //        modelMatrixBuffer = device.makeBuffer(
        //            bytes: modelMatrices,
        //            length: modelMatrices.count * MemoryLayout<matrix_float4x4>.size,
        //            options: .storageModeShared
        //        )
        
        vertexBuffer = device.makeBuffer(
            bytes: cubeVertices,
            length: cubeVertices.count * MemoryLayout<Vertex>.stride,
            options: []
        )
        
        indexBuffer = device.makeBuffer(
            bytes: cubeIndices,
            length: cubeIndices.count * MemoryLayout<UInt16>.stride,
            options: []
        )
        
        return
    } // setupVertices
    
    // MARK: - setupPipeline
    private func setupPipeline() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexFunction")
        let fragmentFunction = library?.makeFunction(name: "fragmentFunction")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError("pipeline 생성 실패: \(error)")
        }
        
        setupDepthStencilState()
        return
    } // setupPipeline
    
    // MARK: - rendering
    private func rendering() {
        commandQueue = device.makeCommandQueue()
        timer = CADisplayLink(target: self, selector: #selector(gameLoop))
        timer.add(to: RunLoop.main, forMode: .default)
    } // rendering
    
    // MARK: - render
    private func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        
        //updateCameraPosition()
        
        var projectionMatrix = createPerspectiveMatrix(
            fov: toRadians(from: 30.0), // 시야걱
            aspectRatio: Float(view.bounds.width / view.bounds.height), // 화면 비율
            nearPlane: 0.1, // 근평면
            farPlane: 100.0) // 원평면
        
        let camX: Float = sin(Float(CACurrentMediaTime())) * 20.0
        let camZ: Float = cos(Float(CACurrentMediaTime())) * 20.0
        
        let viewMatrix = createViewMatrix(
            eyePosition: simd_float3(camX, 0.0, camZ), // 카메라 위치
            targetPosition: simd_float3(0.0, 0.0, 0.0), // 타겟 위치(카메라가 바라보는 위치)
            upVec: simd_float3(0.0, 1.0, 0.0)) // 위쪽
//
//        var modelMatrix = matrix_identity_float4x4
//        translate(matrix: &modelMatrix, position: simd_float3(0.0, 0.0, 0.0))
//        rotate(matrix: &modelMatrix, rotation: rotation)
//        scale(matrix: &modelMatrix, scale: simd_float3(1.0, 1.0, 1.0))
        
        // 렌더패스 설정
        // 색상 텍스처 설정
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.5
        )
        
        // 깊이 텍스처 설정
        renderPassDescriptor.depthAttachment.texture = depthTexture
        renderPassDescriptor.depthAttachment.loadAction = .clear
        renderPassDescriptor.depthAttachment.storeAction = .dontCare
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(modelMatrixBuffer, offset: 0, index: 1)
        
        renderEncoder.setFragmentTexture(texture1, index: 0)
        renderEncoder.setFragmentTexture(texture2, index: 1)
        renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        
        var blendRatio: Float = 0.3
        renderEncoder.setFragmentBytes(&blendRatio, length: MemoryLayout<Float>.stride, index: 1)
        renderEncoder.setVertexBytes(&projectionMatrix, length: MemoryLayout.stride(ofValue: projectionMatrix), index: 1)
        
        let cubePositions: [simd_float3] = [
            simd_float3(-1.0, 1.0, -6.0),  // 상좌
            simd_float3(0.0, 1.0, 2.5),   // 상중앙
            simd_float3(1.0, 1.0, -9.0),   // 상우
            simd_float3(-1.0, 0.5, -8.5),  // 중좌
            simd_float3(1.0, 0.5, -2.8),   // 중우
            simd_float3(0.0, 0.0, 0.0),   // 중앙
            simd_float3(-1.0, -0.5, 3.5), // 하좌
            simd_float3(0.0, -0.5, -3.8),  // 하중앙
            simd_float3(1.0, -0.5, -7.0),  // 하우
            simd_float3(0.5, 0.0, -9.2)    // 중앙 우측
        ]
        
        for i in cubePositions.indices {
            var modelMatrix = matrix_identity_float4x4
            translate(matrix: &modelMatrix, position: cubePositions[i])
            rotate(matrix: &modelMatrix, rotation: simd_float3(toRadians(from: 30.0), toRadians(from: 30.0), 0.0) + simd_float3(Float(i), Float(i), Float(i)))
            scale(matrix: &modelMatrix, scale: simd_float3(1.0, 1.0, 1.0))
            
            var modelViewMatrix = viewMatrix * modelMatrix
            renderEncoder.setVertexBytes(&modelViewMatrix, length: MemoryLayout.stride(ofValue: modelViewMatrix), index: 2)
            
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: cubeIndices.count,
                indexType: .uint16,
                indexBuffer: indexBuffer,
                indexBufferOffset: 0
            )
        }
        
        //        var modelViewMatrix = viewMatrix * modelMatrix
        //        renderEncoder.setVertexBytes(&modelViewMatrix, length: MemoryLayout.stride(ofValue: modelViewMatrix), index: 2)
        //
        //        renderEncoder.drawIndexedPrimitives(
        //                type: .triangle,
        //                indexCount: cubeIndices.count,
        //                indexType: .uint16,
        //                indexBuffer: indexBuffer,
        //                indexBufferOffset: 0
        //            )
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        return
    } // render
        
    // MARK: - gameLoop
    @objc private func gameLoop() {
        autoreleasepool {
            //rotation += simd_float3(toRadians(from: -1.0), toRadians(from: -1.0), 0.0)
            render()
        }
    } // gameLoop
}
