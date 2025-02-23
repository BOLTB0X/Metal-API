//
//  Mesh.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import MetalKit

// MARK: - Mesh
class Mesh {
    var mesh: MTKMesh
    var materials: [Material]
    
    // MARK: - init
    init(mesh: MTKMesh, materials: [Material]) {
        self.mesh = mesh
        self.materials = materials
    } // init
    
}
