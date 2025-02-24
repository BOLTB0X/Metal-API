//
//  Model.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import MetalKit

// MARK: - Model
class Model {
    var meshes: [Mesh] = []

    // MARK: - loadModel
    func loadModel(device: MTLDevice, url: URL,
                   vertexDescriptor: MTLVertexDescriptor, textureLoader: MTKTextureLoader) {
        let modelVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let attrPosition = modelVertexDescriptor.attributes[0] as! MDLVertexAttribute
        attrPosition.name = MDLVertexAttributePosition
        modelVertexDescriptor.attributes[0] = attrPosition

        let attrNormal = modelVertexDescriptor.attributes[1] as! MDLVertexAttribute
        attrNormal.name = MDLVertexAttributeNormal
        modelVertexDescriptor.attributes[1] = attrNormal
        
        let attrTexCoord = modelVertexDescriptor.attributes[2] as! MDLVertexAttribute
        attrTexCoord.name = MDLVertexAttributeTextureCoordinate
        modelVertexDescriptor.attributes[2] = attrTexCoord
        
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: url, vertexDescriptor: modelVertexDescriptor, bufferAllocator: bufferAllocator)
        
        asset.loadTextures()
        
        guard let (mdlMeshes, mtkMeshes) = try? MTKMesh.newMeshes(asset: asset, device: device) else {
            print("meshes 생성 실패")
            return
        }
                
        for (mdlMesh, mtkMesh) in zip(mdlMeshes, mtkMeshes) {
            var materials: [Material] = []
            for mdlSubmesh in mdlMesh.submeshes as! [MDLSubmesh] {
                let material = Material(mdlMaterial: mdlSubmesh.material, textureLoader: textureLoader)
                materials.append(material)
            } // for
            
            let mesh = Mesh(mesh: mtkMesh, materials: materials)
            self.meshes.append(mesh)
            
        } // for
        
    } // loadModel
    
    // MARK: - draw
    func draw(renderEncoder: MTLRenderCommandEncoder) {        
        for mesh in self.meshes {
            let vertexBuffer = mesh.mesh.vertexBuffers[0]
            renderEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 30)

            for (submesh, material) in zip(mesh.mesh.submeshes, mesh.materials) {
                renderEncoder.setFragmentTexture(material.diffuseTexture, index: 0)
                renderEncoder.setFragmentTexture(material.specularTexture, index: 1)
                
                // Draw
                renderEncoder.drawIndexedPrimitives(type: MTLPrimitiveType.triangle,
                                                    indexCount: submesh.indexCount,
                                                    indexType: submesh.indexType,
                                                    indexBuffer: submesh.indexBuffer.buffer,
                                                    indexBufferOffset: submesh.indexBuffer.offset)
            } // for
        } // for
        
    } // draw
    
} // Model
