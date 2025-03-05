//
//  Model.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import MetalKit

// MARK: - Model
class Model {
    // Model propertys
    private var meshes: [Mesh] = []
    
    // propertys
    private let position: simd_float3 = simd_float3(repeating: 0.0)
    private let angle: Float = 0.0
    private let axis: simd_float3 = simd_float3(0.0, 1.0, 0.0)
    private let scales: simd_float3 = simd_float3(repeating: 0.004)
    
    // MARK: - init
    init(device: MTLDevice,
         url: URL,
         vertexDescriptor: MTLVertexDescriptor,
         textureLoader: MTKTextureLoader) {
        loadModel(device: device, url: url, vertexDescriptor: vertexDescriptor, textureLoader: textureLoader)
    } // init
    
    // MARK: - draw
    func draw(renderEncoder: MTLRenderCommandEncoder,
              bindTextures: Bool) {
        var modelUniform = ModelUniform(position: self.position,
                                        angle: self.angle,
                                        axis: self.axis,
                                        scales: self.scales)
        renderEncoder.setVertexBytes(&modelUniform, length: MemoryLayout<ModelUniform>.size, index: VertexBufferIndex.modelUniform.rawValue)
        
        for mesh in self.meshes {
            mesh.draw(renderEncoder: renderEncoder, bindTextures: bindTextures)
        } // for
        
    } // draw
    
    // MARK: - Private
    // ...
    // MARK: - loadModel
    private func loadModel(device: MTLDevice,
                           url: URL,
                           vertexDescriptor: MTLVertexDescriptor,
                           textureLoader: MTKTextureLoader) {
        let modelVertexDescriptor = DescriptorManager.buildMDLVertexDescriptor(vertexDescriptor: vertexDescriptor)
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: url, vertexDescriptor: modelVertexDescriptor, bufferAllocator: bufferAllocator)
        
        asset.loadTextures()
        
        guard let (mdlMeshes, mtkMeshes) = try? MTKMesh.newMeshes(asset: asset, device: device) else {
            print("meshes 생성 실패")
            return
        }
        
        self.meshes.reserveCapacity(mdlMeshes.count)
        
        for (mdlMesh, mtkMesh) in zip(mdlMeshes, mtkMeshes) {
            mdlMesh.addOrthTanBasis(forTextureCoordinateAttributeNamed: MDLVertexAttributeTextureCoordinate,
                                    normalAttributeNamed: MDLVertexAttributeNormal,
                                    tangentAttributeNamed: MDLVertexAttributeTangent)
            let mesh = processMesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh, textureLoader: textureLoader)
            self.meshes.append(mesh)
        } // for
        
    } // loadModel
    
    // MARK: - processMesh
    private func processMesh(mdlMesh: MDLMesh, mtkMesh: MTKMesh, textureLoader: MTKTextureLoader) -> Mesh {
        var materials: [Material] = []
        
        for mdlSubmesh in mdlMesh.submeshes as! [MDLSubmesh] {
            let material = Material(mdlMaterial: mdlSubmesh.material, textureLoader: textureLoader)
            materials.append(material)
        } // for
        
        return Mesh(mesh: mtkMesh, materials: materials)
    } // processMesh
    
} // Model
