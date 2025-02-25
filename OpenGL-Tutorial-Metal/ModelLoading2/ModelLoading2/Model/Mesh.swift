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
        let vertexBuffer = mesh.vertexBuffers[0]
        renderEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 30)
        
        for (submesh, material) in zip(mesh.submeshes, materials) {
            renderEncoder.setFragmentTexture(material.diffuseTexture, index: 0)
            renderEncoder.setFragmentTexture(material.specularTexture, index: 1)
            renderEncoder.setFragmentTexture(material.normalTexture, index: 2)
            
            var stateUniform = MaterialStateUniform(hasDiffuseTexture: material.diffuseTexture != nil,
                                             hasSpecularTexture: material.specularTexture != nil,
                                             hasNormalTexture: material.normalTexture != nil)
            renderEncoder.setFragmentBytes(&stateUniform, length: MemoryLayout<MaterialStateUniform>.size, index: 1)
            
            // Draw
            renderEncoder.drawIndexedPrimitives(type: MTLPrimitiveType.triangle,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        } // for
        
    } // draw
    
} // Mesh
