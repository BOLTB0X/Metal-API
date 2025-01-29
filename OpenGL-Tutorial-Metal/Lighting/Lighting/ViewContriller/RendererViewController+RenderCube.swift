//
//  RendererViewController+RenderCube.swift
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/28.
//

import Foundation
import Metal
import simd

extension RendererViewController {
    // MARK: - renderObjectCube
    public func renderObjectCube(renderEncoder: inout MTLRenderCommandEncoder,
                                  indexBuffer: MTLBuffer,
                                  projectionMatrix: simd_float4x4) {
        
        for i in RendererResources.cubePositions.indices {
            var modelMatrix = simd_float4x4.identity()
            var ambient: simd_float3 = i == 0 ? simd_float3(0.1, 0.1, 0.1) : simd_float3(0.0, 0.0, 0.0)
            var uniform = LightUniforms(
                lightPosition: simd_float3(0.3, 0.3, 0.3),
                cameraPosition: simd_float3(0.0, 0.0, 0.3),
                lightColor: RendererResources.lightColors[i].lightColor,
                objectColor: RendererResources.lightColors[i].objectColor
            )
            
            modelMatrix.translate(position: RendererResources.cubePositions[i])
            modelMatrix.rotate(rotation: rotation + simd_float3(Float(i), Float(i), Float(i)))
            modelMatrix.scales(scale: simd_float3(0.3, 0.3, 0.3))
            
            var transformUniforms = TransformUniforms(
                projectionMatrix: projectionMatrix,
                modelMatrix: modelMatrix,
                modelViewMatrix: RendererResources.viewMatrix * modelMatrix
            )

            // Fragment
            renderEncoder.setFragmentBytes(&uniform, length: MemoryLayout<LightUniforms>.size, index: 1)
            renderEncoder.setFragmentBytes(&transformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 2)
            renderEncoder.setFragmentBytes(&ambient, length: MemoryLayout<simd_float3>.size, index: 3)
            
            // Vertex
            renderEncoder.setVertexBytes(&transformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 1)
            
            
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: RendererResources.cubeIndices.count,
                indexType: .uint16,
                indexBuffer: indexBuffer,
                indexBufferOffset: 0
            )
        }
        
        return
    } // renderObjectCube
    
    // MARK: - renderLightSourceCube
    public func renderLightSourceCube(renderEncoder: inout MTLRenderCommandEncoder,
                         indexBuffer: MTLBuffer,
                         projectionMatrix: simd_float4x4) {
        var lightSourceCubeMatrix = simd_float4x4.identity()
        lightSourceCubeMatrix.translate(position: simd_float3(0.3, 0.3, 0.3))
        lightSourceCubeMatrix.rotate(rotation: rotation)
        lightSourceCubeMatrix.scales(scale: simd_float3(0.1, 0.1, 0.1))
        var lightColor = simd_float3(1.0, 1.0, 1.0);
        
        var lightTransformUniforms = TransformUniforms(
            projectionMatrix: projectionMatrix,
            modelMatrix: lightSourceCubeMatrix,
            modelViewMatrix: RendererResources.viewMatrix * lightSourceCubeMatrix
        )
        
        // Fragment
        renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<simd_float3>.size, index: 1)
        
        // Vertex
        renderEncoder.setVertexBytes(&lightTransformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 1)
        
        //
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: RendererResources.cubeIndices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )
        
        return
    } // renderLightSourceCube
}
