//
//  Material.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import MetalKit

// MARK: - Material
struct Material {
    var diffuseTexture: MTLTexture?
    var specularTexture: MTLTexture?
    
    static var textureMap: [MDLTexture?: MTLTexture?] = [:]
    
    // MARK: - init
    init(mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) {
        self.diffuseTexture  = loadTexture(.baseColor, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        self.specularTexture = loadTexture(.specular,  mdlMaterial: mdlMaterial, textureLoader: textureLoader)
    } // init
    
    // MARK: - loadTexture
    func loadTexture(_ semantic: MDLMaterialSemantic, mdlMaterial: MDLMaterial?,
                     textureLoader: MTKTextureLoader) -> MTLTexture? {
        guard let materialProperty = mdlMaterial?.property(with: semantic) else { return nil }
        guard let sourceTexture = materialProperty.textureSamplerValue?.texture else { return nil }
        
        if let texture = Material.textureMap[sourceTexture] {
            return texture
        }
        
        let texture = try? textureLoader.newTexture(texture: sourceTexture, options: nil)
        Material.textureMap[sourceTexture] = texture
        
        return texture
    } // loadTexture
    
} // Material
