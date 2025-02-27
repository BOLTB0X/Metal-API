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
    func draw(renderEncoder: MTLRenderCommandEncoder) {
        guard let vertexBuffer = mesh.vertexBuffers.first else {
            return
        }
        
        renderEncoder.setVertexBuffer(vertexBuffer.buffer,
                                      offset: vertexBuffer.offset,
                                      index: VertexBufferIndex.attributes.rawValue)
        
        for (submesh, material) in zip(mesh.submeshes, materials) {
            MaterialIndex.allCases.forEach { index in
                renderEncoder.setFragmentTexture(material.textures[index.rawValue], index: index.rawValue)
            } // forEach
                        
            var stateUniform = MaterialStateUniform(textures: material.textures)
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
