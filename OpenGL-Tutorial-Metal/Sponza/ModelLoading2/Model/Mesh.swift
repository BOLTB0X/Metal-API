//
//  Mesh.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import MetalKit

// MARK: - Mesh
class Mesh {
    private var mesh: MTKMesh
    private var materials: [Material]
    
    // MARK: - init
    init(mesh: MTKMesh, materials: [Material]) {
        self.mesh = mesh
        self.materials = materials
    } // init
    
    // MARK: - draw
    func draw(renderEncoder: MTLRenderCommandEncoder, bindTextures: Bool) {
        guard let vertexBuffer = mesh.vertexBuffers.first else {
            return
        }
        
        renderEncoder.setVertexBuffer(vertexBuffer.buffer,
                                      offset: vertexBuffer.offset,
                                      index: VertexBufferIndex.attributes.rawValue)
        
        for (submesh, material) in zip(mesh.submeshes, materials) {
            if bindTextures {
                renderEncoder.setFragmentTexture(material.diffuseTexture, index: MaterialIndex.diffuseTexture.rawValue)
                renderEncoder.setFragmentTexture(material.specularTexture, index: MaterialIndex.specularTexture.rawValue)
                renderEncoder.setFragmentTexture(material.normalTexture, index: MaterialIndex.normalTexture.rawValue)
            } // if
            
            var stateUniform = MaterialStateUniform(diffuseTexture: material.diffuseTexture,
                                                    specularTexture: material.specularTexture,
                                                    normalTexture: material.normalTexture)
            renderEncoder.setFragmentBytes(&stateUniform,
                                           length: MemoryLayout<MaterialStateUniform>.size,
                                           index: FragmentBufferIndex.materialStateUniform.rawValue)
            
            // Draw
            renderEncoder.drawIndexedPrimitives(type: MTLPrimitiveType.triangle,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        } // for
        
    } // draw
    
} // Mesh
