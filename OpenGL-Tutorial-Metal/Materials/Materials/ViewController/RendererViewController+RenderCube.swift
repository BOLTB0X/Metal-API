//
//  RendererViewController+RenderCube.swift
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/04.
//

import Foundation
import Metal
import simd
import QuartzCore

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
            
            modelMatrix.translate(position: RendererResources.cubePositions[i])
            modelMatrix.rotate(rotation: rotation)
            modelMatrix.scales(scale: simd_float3(0.5, 0.5, 0.5))
            
            var inverseTranspose = modelMatrix.conversion_3x3().inverse.transpose
            
            lightColor.x = sin(Float(CACurrentMediaTime() * 2.0))
            lightColor.y = sin(Float(CACurrentMediaTime() * 0.7))
            lightColor.z = sin(Float(CACurrentMediaTime() * 1.3))
            
            let diffuse = lightColor * simd_float3(0.5, 0.5, 0.5)
            let ambient = diffuse * simd_float3(0.2, 0.2, 0.2)

            var uniform = LightUniforms(
                lightPosition: lightPosition,
                cameraPosition: cameraPosition,
                ambient: ambient,
                diffuse: diffuse,
                specular: simd_float3(1.0, 1.0, 1.0)
            )
            
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
            
            var materialUniforms = MaterialUniforms(
                ambient: simd_float3(1, 0.5, 0.31),
                diffuse: simd_float3(1.0, 0.5, 0.31),
                specular: simd_float3(1.0, 1.0, 1.0)
            )

            // Fragment
            renderEncoder.setFragmentBytes(&uniform, length: MemoryLayout<LightUniforms>.size, index: 1)
            renderEncoder.setFragmentBytes(&transformUniforms, length: MemoryLayout<TransformUniforms>.size, index: 2)
            renderEncoder.setFragmentBytes(&materialUniforms, length: MemoryLayout<MaterialUniforms>.size, index: 3)
            
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
                         indexBuffer: MTLBuffer) {
        let projectionMatrix = simd_float4x4.perspective(
            fov: Float(45).toRadians(),
            aspectRatio: 1.0,
            nearPlane: 0.1,
            farPlane: 100.0
        )
        
        var lightSourceCubeMatrix = simd_float4x4.identity()
        lightSourceCubeMatrix.translate(position: lightSourceCubeMatrix.conversion_3x3() * lightPosition)
        lightSourceCubeMatrix.scales(scale: simd_float3(0.1, 0.1, 0.1))
        
        var lightColor = simd_float3(1.0, 1.0, 1.0)
        var inverseTranspose = lightSourceCubeMatrix.conversion_3x3().inverse.transpose
        
        let viewMatrix = simd_float4x4.lookAt(
            eyePosition: cameraPosition,
            targetPosition: simd_float3(0.0, 0.0, 0.0),
            upVec: simd_float3(0.0, 1.0, 0.0)
        )

        var transformUniforms = TransformUniforms(
            projectionMatrix: projectionMatrix,
            modelMatrix: lightSourceCubeMatrix,
            viewMatrix: viewMatrix
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
