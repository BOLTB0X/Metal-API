//
//  Material.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/20.
//

import MetalKit

// MARK: - TextureType
enum TextureType {
    case diffuse
    case specular
    case normal
    case roughness
} // TextureType

// MARK: - Texture
struct Material {
    var diffuseTexture: MTLTexture?
    var specularTexture: MTLTexture?
    
    static var textureCache: [MDLTexture?: MTLTexture?] = [:]
    
    init(mdlMaterial: MDLMaterial?,
         textureLoader: MTKTextureLoader) {
        self.diffuseTexture = loadTexture(mdlMaterial: mdlMaterial, semantic: .baseColor, textureLoader: textureLoader)
        self.specularTexture = loadTexture(mdlMaterial: mdlMaterial, semantic: .specular, textureLoader: textureLoader)
    }
    
    // MARK: - loadTexture
    private func loadTexture(mdlMaterial: MDLMaterial?,
                            semantic: MDLMaterialSemantic,
                            textureLoader: MTKTextureLoader) -> MTLTexture? {
        guard let materialProperty = mdlMaterial?.property(with: semantic) else { return nil }
        guard let sourceTexture = materialProperty.textureSamplerValue?.texture else { return nil }
        
        if let cachedTexture = Material.textureCache[sourceTexture] {
            return cachedTexture
        }
                
        let texture = try? textureLoader.newTexture(texture: sourceTexture, options: nil)
        Material.textureCache[sourceTexture] = texture
        
        return texture
        
    } // loadTexture
    
} // Texture
