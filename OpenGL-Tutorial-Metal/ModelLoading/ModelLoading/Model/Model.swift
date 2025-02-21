//
//  Model.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/20.
//

import MetalKit
import ModelIO

// MARK: - Model
class Model {
    var meshes: [Mesh] = []

    // MARK: - init
    init(device: MTLDevice,
         path: String,
         vertexDescriptor: MTLVertexDescriptor) {
        
        loadModel(device: device, vertexDescriptor: vertexDescriptor, path: path)
    } // init
    
    // MARK: - draw
    func draw(encoder: MTLRenderCommandEncoder) {
        print("Model draw 시작")

        print("메시 개수: \(meshes.count)")
        for mesh in meshes {
            mesh.draw(encoder: encoder)
        }
        print("Model draw 완료")
        return
    } // draw
    
    // MARK: - loadModel
    private func loadModel(device: MTLDevice,
                           vertexDescriptor: MTLVertexDescriptor,
                           path: String) {
        let modelVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let attrPosition = modelVertexDescriptor.attributes[0] as! MDLVertexAttribute
        attrPosition.name = MDLVertexAttributePosition
        modelVertexDescriptor.attributes[0] = attrPosition
        
        let attrTexCoord = modelVertexDescriptor.attributes[1] as! MDLVertexAttribute
        attrTexCoord.name = MDLVertexAttributeTextureCoordinate
        modelVertexDescriptor.attributes[1] = attrTexCoord
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: URL(fileURLWithPath: path),
                             vertexDescriptor: nil,
                             bufferAllocator: allocator)
        
        asset.loadTextures()
        
        do {
            let (mdlMeshes, mtkMeshes) = try MTKMesh.newMeshes(asset: asset, device: device)
            
            for (mdlMesh, mtkMesh) in zip(mdlMeshes, mtkMeshes) {
                let processedMesh = processMesh(mdlMesh: mdlMesh,
                                                mtkMesh: mtkMesh,
                                                device: device)
                meshes.append(processedMesh)
            } // for
            
            self.meshes.reserveCapacity(mdlMeshes.count)
        } catch {
            print("MTKMesh 생성 에러: \(error)")
        } // do - catch
        
        print("loadModel 완료")
    } // loadModel
    
    // MARK: - processMesh
    private func processMesh(mdlMesh: MDLMesh, mtkMesh: MTKMesh, device: MTLDevice) -> Mesh {
        var textures: [Texture] = []
        
        // 서브메시별 텍스처 로드
        print("mdlMesh.submeshes: \(mdlMesh.submeshes ?? [])")
        for mdlSubmesh in mdlMesh.submeshes as? [MDLSubmesh] ?? [] {
            if let material = mdlSubmesh.material {
                textures.append(contentsOf: loadMaterialTextures(material: material, device: device))
            }
        } // for
        
        return Mesh(mesh: mtkMesh, textures: textures)
    } // processMesh
    
    // MARK: - loadMaterialTextures
    private func loadMaterialTextures(material: MDLMaterial?, device: MTLDevice) -> [Texture] {
        var textures: [Texture] = []
        guard let material = material else { return textures }
        
        if let diffuseTexture = Texture.loadTexture(from: material.property(with: .baseColor), device: device) {
            textures.append(Texture(texture: diffuseTexture, type: .diffuse))
        }
        
        if let specularTexture = Texture.loadTexture(from: material.property(with: .specular), device: device) {
            textures.append(Texture(texture: specularTexture, type: .specular))
        }
        
        if let normalTexture = Texture.loadTexture(from: material.property(with: .tangentSpaceNormal), device: device) {
            textures.append(Texture(texture: normalTexture, type: .normal))
        }
        
        if let roughnessTexture = Texture.loadTexture(from: material.property(with: .roughness), device: device) {
            textures.append(Texture(texture: roughnessTexture, type: .roughness))
        }
        
        return textures
    } // loadMaterialTextures
    
} // Model
