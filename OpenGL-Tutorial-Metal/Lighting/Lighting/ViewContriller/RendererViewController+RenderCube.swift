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
                                 indexBuffer: MTLBuffer) {
        let projectionMatrix = simd_float4x4.perspective(
            fov: Float(30).toRadians(),
            aspectRatio: 1.0,
            nearPlane: 0.1,
            farPlane: 100.0
        )
        
        for i in RendererResources.cubePositions.indices {
            var modelMatrix = simd_float4x4.identity()
            var ambient: simd_float3 = i == 0 ? simd_float3(0.1, 0.1, 0.1) : simd_float3(0.0, 0.0, 0.0)
            renderEncoder.setFragmentBytes(&ambient, length: MemoryLayout<simd_float3>.size, index: 3)

            modelMatrix.translate(position: RendererResources.cubePositions[i])
            modelMatrix.rotate(rotation: simd_float3(0.0, Float(30).toRadians(), 0.0)
)
            modelMatrix.scales(scale: simd_float3(1.5, 1.5, 1.5))

            var uniform = LightUniforms(
                lightPosition: lightPosition,
                cameraPosition: cameraPosition,
                lightColor: RendererResources.lightColors[i].lightColor,
                objectColor: RendererResources.lightColors[i].objectColor
            )
            renderEncoder.setFragmentBytes(&uniform, length: MemoryLayout<LightUniforms>.size, index: 1)
            
            let viewMatrix = simd_float4x4.lookAt(
                eyePosition: cameraPosition,
                targetPosition: simd_float3(0.0, 0.0, 0.0),
                upVec: simd_float3(0.0, 1.0, 0.0)
            )
            var transformUniforms = TransformUniforms(
                projectionMatrix: projectionMatrix,
                modelMatrix: modelMatrix,
                viewMatrix: viewMatrix
            )
            
            renderEncoder.setVertexBytes(&transformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 1)
            renderEncoder.setFragmentBytes(&transformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 2)
            
            var modelMatrix4x4 = modelMatrix
            var inverseTranspose = modelMatrix4x4.conversion_3x3().inverse.transpose
            renderEncoder.setVertexBytes(&inverseTranspose, length: MemoryLayout<simd_float4x4>.size, index: 2)

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
                                      indexBuffer: MTLBuffer) {
        let projectionMatrix = simd_float4x4.perspective(
            fov: Float(30).toRadians(),
            aspectRatio: 1.0,
            nearPlane: 0.1,
            farPlane: 100.0
        )
        var lightSourceCubeMatrix = simd_float4x4.identity()
        lightSourceCubeMatrix.translate(position: lightPosition)
        lightSourceCubeMatrix.rotate(rotation: rotation)
        lightSourceCubeMatrix.scales(scale: simd_float3(0.1, 0.1, 0.1))
        var lightColor = simd_float3(1.0, 1.0, 1.0);
        let viewMatrix = simd_float4x4.lookAt(
            eyePosition: cameraPosition,
            targetPosition: simd_float3(0.0, 0.0, 0.0),
            upVec: simd_float3(0.0, 1.0, 0.0)
        )

        var lightTransformUniforms = TransformUniforms(
            projectionMatrix: projectionMatrix,
            modelMatrix: lightSourceCubeMatrix,
            viewMatrix: viewMatrix
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
