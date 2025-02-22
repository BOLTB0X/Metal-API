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

    // MARK: - init
    init(device: MTLDevice,
         path: String,
         vertexDescriptor: MTLVertexDescriptor,
         textureLoader: MTKTextureLoader) {
        
        loadModel(device: device, vertexDescriptor: vertexDescriptor, path: path, textureLoader: textureLoader)
    } // init
    
    // MARK: - draw
    func draw(encoder: MTLRenderCommandEncoder) {
        //print("Model draw 시작")
        
        var modelMatrix = simd_float4x4.identity()
        modelMatrix.translate(position: simd_float3(0.0, 0.0, 0.0))
        modelMatrix.scales(scale: simd_float3(1.0, 1.0, 1.0))
        
        var viewMatrix = simd_float4x4.lookAt(eyePosition: simd_float3(0.0, 0.0, 1.5),
                                              targetPosition: simd_float3(0.0, 0.0, 0.0),
                                              upVec: simd_float3(0.0, 1.0, 0.0))
        
        var projectionMatrix = simd_float4x4.perspective(fov: Float(45).toRadians(),
                                                         aspectRatio: 1.0,
                                                         nearPlane: 0.1,
                                                         farPlane: 100.0)
        
        encoder.setVertexBytes(&modelMatrix, length: MemoryLayout<simd_float4x4>.size, index: 0)
        encoder.setVertexBytes(&viewMatrix, length: MemoryLayout<simd_float4x4>.size, index: 1)
        encoder.setVertexBytes(&projectionMatrix, length: MemoryLayout<simd_float4x4>.size, index: 2)

        //print("메시 개수: \(meshes.count)")
        for mesh in meshes {
            mesh.draw(encoder: encoder)
        }
        //print("Model draw 완료")
        return
    } // draw
    
    // MARK: - loadModel
    private func loadModel(device: MTLDevice,
                           vertexDescriptor: MTLVertexDescriptor,
                           path: String,
                           textureLoader: MTKTextureLoader) {
        let modelVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let attrPosition = modelVertexDescriptor.attributes[0] as! MDLVertexAttribute
        attrPosition.name = MDLVertexAttributePosition
        modelVertexDescriptor.attributes[0] = attrPosition
        
        let attrTexCoord = modelVertexDescriptor.attributes[1] as! MDLVertexAttribute
        attrTexCoord.name = MDLVertexAttributeTextureCoordinate
        modelVertexDescriptor.attributes[1] = attrTexCoord
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: URL(fileURLWithPath: path),
                             vertexDescriptor: modelVertexDescriptor,
                             bufferAllocator: allocator)
        
        asset.loadTextures()

        guard let (mdlMeshes, mtkMeshes) = try? MTKMesh.newMeshes(asset: asset, device: device) else {
            print("Failed to create meshes")
            return
        }
        
        for (mdlMesh, mtkMesh) in zip(mdlMeshes, mtkMeshes) {
            let processedMesh = processMesh(mdlMesh: mdlMesh,
                                            mtkMesh: mtkMesh,
                                            textureLoader: textureLoader)
            meshes.append(processedMesh)
        }
        
        self.meshes.reserveCapacity(mdlMeshes.count)
        
        //print("meshes.count: \(meshes.count)")
        //print("loadModel 완료")
    } // loadModel
    
    // MARK: - processMesh
    private func processMesh(mdlMesh: MDLMesh, mtkMesh: MTKMesh, textureLoader: MTKTextureLoader) -> Mesh {
        var textures: [Texture] = []
        
        for mdlSubmesh in mdlMesh.submeshes as! [MDLSubmesh] {
            //print("mdlSubmesh.material: \(mdlSubmesh.material != nil ? "존재함" : "nil")")
            textures += loadMaterialTextures(material: mdlSubmesh.material, textureLoader: textureLoader)
        } // for
        
        //print("textures.count: \(textures.count)")
        return Mesh(mesh: mtkMesh, textures: textures)
    } // processMesh
    
    // MARK: - loadMaterialTextures
    private func loadMaterialTextures(material: MDLMaterial?, textureLoader: MTKTextureLoader) -> [Texture] {
        var textures: [Texture] = []
        
        guard let material = material else { return textures }
        
        let properties: [MDLMaterialSemantic] = [.baseColor, .specular, .tangentSpaceNormal, .roughness]
        
        for property in properties {
            if let prop = material.property(with: property) {
                //print("\(property) 속성 존재 - 타입: \(prop.type) 값: \(prop.stringValue ?? "nil")")
                
                if let p = prop.stringValue, p.contains("diffuse") {
                    if let diffuseTexture = Texture.loadTexture(mdlMaterial: material,
                                                                semantic: .baseColor,
                                                                textureLoader: textureLoader) {
                        textures.append(Texture(texture: diffuseTexture, type: .diffuse))
                    } else {
                        print("baseColor 텍스처 로드 실패")
                    }
                    //print("diffuse 추출")
                }
                
                if let p = prop.stringValue, p.contains("specular") {
                    if let specularTexture = Texture.loadTexture(mdlMaterial: material,
                                                                 semantic: .specular,
                                                                 textureLoader: textureLoader) {
                        textures.append(Texture(texture: specularTexture, type: .specular))
                    } else {
                        print("specular 텍스처 로드 실패")
                    }
                    //print("specular 추출")
                }
                
            } else {
                print("\(property) 속성 없음")
            }
        }
        
        return textures
    } // loadMaterialTextures
    
} // Model
