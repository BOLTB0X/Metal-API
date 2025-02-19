//
//  RendererViewController+RenderCube.swift
//  LightingCasters
//
//  Created by KyungHeon Lee on 2025/02/15.
//

import Foundation
import Metal
import simd

extension RendererViewController {
    // MARK: - renderObjectCube
    public func renderObjectCube(renderEncoder: inout MTLRenderCommandEncoder,
                                 indexBuffer: MTLBuffer,
                                 camera: inout Camera) {
        let projectionMatrix = simd_float4x4.perspective(
            fov: Float(45).toRadians(),
            aspectRatio: 1.0,
            nearPlane: 0.1,
            farPlane: 100.0
        )
        
        for i in RendererResources.cubePositions.indices {
            var modelMatrix = simd_float4x4.identity()
            
            modelMatrix.translate(position: RendererResources.cubePositions[i])
            modelMatrix.rotate(angle: Float(20 * i), axis: simd_float3(1.0, 0.3, 0.5))
            modelMatrix.scales(scale: simd_float3(1.5, 1.5, 1.5))
            
            var inverseTranspose = modelMatrix.conversion_3x3().inverse.transpose
            
            var uniform = LightUniforms(
                position: camera.position,
                direction: camera.front,
                cutOff: simd_float3(cos(Float(12.5).toRadians()), 0.0, 0.0),
                outerCutOff: simd_float3(cos(Float(17.5).toRadians()), 0.0, 0.0),
                ambient: simd_float3(0.1, 0.1, 0.1),
                diffuse: simd_float3(0.8, 0.8, 0.8),
                specular: simd_float3(1.0, 1.0, 1.0),
                constants: simd_float3(1.0, 0.0, 0.0),
                linears: simd_float3(0.09, 0.0, 0.0),
                quadratics: simd_float3(0.032, 0.0, 0.0)
            )
            
            let viewMatrix = camera.getViewMatrix()
            
            var transformUniforms = TransformUniforms(
                projectionMatrix: projectionMatrix,
                modelMatrix: modelMatrix,
                viewMatrix: viewMatrix
            )
            
            // Fragment
            renderEncoder.setFragmentBytes(&transformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 1)
            renderEncoder.setFragmentBytes(&uniform, length: MemoryLayout<LightUniforms>.size, index: 2)
            renderEncoder.setFragmentBytes(&camera.position, length: MemoryLayout<simd_float3>.size, index: 3)

            // Vertex
            renderEncoder.setVertexBytes(&transformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 1)
            renderEncoder.setVertexBytes(&inverseTranspose, length: MemoryLayout<simd_float3x3>.size, index: 2)
            
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: RendererResources.cubeIndices.count,
                indexType: .uint16,
                indexBuffer: indexBuffer,
                indexBufferOffset: 0
            )
        } // for
        
        return
    } // renderObjectCube
    
    // MARK: - renderLightSourceCube
    public func renderLightSourceCube(renderEncoder: inout MTLRenderCommandEncoder,
                                      indexBuffer: MTLBuffer,
                                      camera: inout Camera) {
        let projectionMatrix = simd_float4x4.perspective(
            fov: Float(45).toRadians(),
            aspectRatio: 1.0,
            nearPlane: 0.1,
            farPlane: 100.0
        )
        var lightSourceCubeMatrix = simd_float4x4.identity()
        lightSourceCubeMatrix.translate(position: camera.position)
        lightSourceCubeMatrix.scales(scale: simd_float3(0.2, 0.2, 0.2))
        
        var lightColor = simd_float3(1.0, 1.0, 1.0);
        var inverseTranspose = lightSourceCubeMatrix.conversion_3x3().inverse.transpose
        
        let viewMatrix = camera.getViewMatrix()
        
        var transformUniforms = TransformUniforms(
            projectionMatrix: projectionMatrix,
            modelMatrix: lightSourceCubeMatrix,
            viewMatrix:  viewMatrix
        )
        
        // Fragment
        renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<simd_float3>.size, index: 1)
        
        // Vertex
        renderEncoder.setVertexBytes(&transformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 1)
        renderEncoder.setVertexBytes(&inverseTranspose, length: MemoryLayout<simd_float3x3>.size, index: 2)
        
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
