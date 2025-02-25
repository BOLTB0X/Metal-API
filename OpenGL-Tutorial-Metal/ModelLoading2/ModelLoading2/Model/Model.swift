//
//  Model.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import MetalKit

// MARK: - Model
class Model {
    // Model property
    private var meshes: [Mesh] = []
    private let position: simd_float3 = simd_float3(repeating: 0.0)
    private let rotate: (angle: Float, axis: simd_float3) = (30.0, simd_float3(0.0, 1.0, 0.0))
    private let sacles: simd_float3 = simd_float3(repeating: 0.4)
    
    // MARK: - loadModel
    func loadModel(device: MTLDevice, url: URL,
                   vertexDescriptor: MTLVertexDescriptor, textureLoader: MTKTextureLoader) {
        let modelVertexDescriptor = BuildManager.buildMDLVertexDescriptor(vertexDescriptor: vertexDescriptor)
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
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(position: self.position)
        modelMatrix.rotate(angle: self.rotate.angle.toRadians(), axis: self.rotate.axis)
        modelMatrix.scales(scale: self.sacles)
        let normalMatrix = modelMatrix.conversion_3x3().inverse.transpose
        var modelUniform = ModelUniform(modelMatrix: modelMatrix, normalMatrix: normalMatrix)
        
        renderEncoder.setVertexBytes(&modelUniform, length: MemoryLayout<ModelUniform>.size, index: 1)
        
        for mesh in self.meshes {
            mesh.draw(renderEncoder: renderEncoder)
        } // for
        
    } // draw
    
} // Model
