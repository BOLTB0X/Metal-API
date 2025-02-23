//
//  Model.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/20.
//

import MetalKit
//import ModelIO

// MARK: - Model
class Model {
    var meshes: [Mesh] = []
    
    // MARK: - draw
    func draw(encoder: MTLRenderCommandEncoder) {
        var position = simd_float3(0.0, 0.0, 0.0)
        var modelMatrix = simd_float4x4.identity()
        modelMatrix.translate(position: simd_float3(0.0, 0.0, 0.0))
        modelMatrix.scales(scale: simd_float3(1.0, 1.0, 1.0))
        
        var viewMatrix = simd_float4x4.lookAt(eyePosition: simd_float3(0.0, 1.0, -4.0),
                                              targetPosition: simd_float3(0.0, 1.0, -3.0),
                                              upVec: simd_float3(0.0, 1.0, 0.0))
        
        var projectionMatrix = simd_float4x4.perspective(fov: Float(45).toRadians(),
                                                         aspectRatio: 1.0,
                                                         nearPlane: 0.1,
                                                         farPlane: 100.0)
        
        encoder.setVertexBytes(&modelMatrix, length: MemoryLayout.stride(ofValue: modelMatrix), index: 0)
        encoder.setVertexBytes(&viewMatrix, length: MemoryLayout.stride(ofValue: viewMatrix), index: 1)
        encoder.setVertexBytes(&projectionMatrix, length: MemoryLayout<simd_float4x4>.size, index: 2)
        
        encoder.setFragmentBytes(&position, length: MemoryLayout.stride(ofValue: position), index: 0)

        for mesh in meshes {
            //mesh.draw(encoder: encoder)
            let vertexBuffer = mesh.mesh.vertexBuffers[0]
            encoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 30)

            for (submesh, texture) in zip(mesh.mesh.submeshes, mesh.materials) {
                encoder.setFragmentTexture(texture.diffuseTexture, index: 0)
                encoder.setFragmentTexture(texture.specularTexture, index: 1)
                
                let indexBuffer = submesh.indexBuffer
                encoder.drawIndexedPrimitives(
                    type: MTLPrimitiveType.triangle,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: indexBuffer.buffer,
                    indexBufferOffset: 0
                )
            } // for
        }
        
        return
    } // draw
    
    // MARK: - loadModel
    func loadModel(device: MTLDevice,
                           vertexDescriptor: MTLVertexDescriptor,
                           url: URL,
                           textureLoader: MTKTextureLoader) {
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
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: url,
                             vertexDescriptor: modelVertexDescriptor,
                             bufferAllocator: allocator)
        
        asset.loadTextures()

        guard let (mdlMeshes, mtkMeshes) = try? MTKMesh.newMeshes(asset: asset, device: device) else {
            print("Failed to create meshes")
            return
        }
        
        for (mdlMesh, mtkMesh) in zip(mdlMeshes, mtkMeshes) {
            var materials = [Material]()
            for mdlSubmesh in mdlMesh.submeshes as! [MDLSubmesh] {
                let material = Material(mdlMaterial: mdlSubmesh.material, textureLoader: textureLoader)
                materials.append(material)
            }
            let mesh = Mesh(mesh: mtkMesh, materials: materials)
            self.meshes.append(mesh)
        }
                
        //print("meshes.count: \(meshes.count)")
        //print("loadModel 완료")
    } // loadModel
        
    // MARK: - processMesh
//    private func processMesh(mdlMesh: MDLMesh, mtkMesh: MTKMesh, textureLoader: MTKTextureLoader) -> Mesh {
//        var materials: [Material] = []
//
//        for mdlSubmesh in mdlMesh.submeshes as! [MDLSubmesh] {
//            //print("mdlSubmesh.material: \(mdlSubmesh.material != nil ? "존재함" : "nil")")
//            //textures += loadMaterialTextures(material: mdlSubmesh.material, textureLoader: textureLoader)
//            materials.append(Material(mdlMaterial: mdlSubmesh.material, textureLoader: textureLoader))
//        } // for
//
//        //print("textures.count: \(textures.count)")
//        return Mesh(mesh: mtkMesh, material: materials)
//    } // processMesh

} // Model
