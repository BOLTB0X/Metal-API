//
//  Mesh.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/19.
//

import MetalKit

// MARK: - Mesh
struct Mesh {
    var mesh: MTKMesh
    var textures: [Texture]

    // MARK: - init
    init(mesh: MTKMesh, textures: [Texture]) {
        self.mesh = mesh
        self.textures = textures
    } // init
    
    // MARK: - draw
    func draw(encoder: MTLRenderCommandEncoder) {
        guard let vertexBuffer = self.mesh.vertexBuffers.first else {
            print("mesh vertexBuffer 생성 실패")
            return
        }
            
        encoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)

        for (submesh, texture) in zip(mesh.submeshes, textures) {
            let frgIndex = getFragmentTextureIndex(texture.type)

            encoder.setFragmentTexture(texture.texture, index: frgIndex)
                    
            encoder.drawIndexedPrimitives(
                type: MTLPrimitiveType.triangle,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: 0
            )
        } // for
        
        print("mesh draw 완료")
        return
    } // draw
    
    // MARK: - getFragmentTextureIndex
    private func getFragmentTextureIndex(_ type: TextureType) -> Int {
        if type == .diffuse {
            return 0
        } else if type == .specular {
            return 1
        } else if type == .normal {
            return 2
        }
        return 3
    } // getFragmentTextureIndex
    
} // Mesh
