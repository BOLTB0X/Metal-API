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
    var normalTexture: MTLTexture?
    
    static private var textureMap: [MDLTexture?: MTLTexture?] = [:]
    
    // MARK: - init
    init(mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) {
        diffuseTexture = loadTexture(.baseColor, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        specularTexture = loadTexture(.specular, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        normalTexture = loadTexture(.tangentSpaceNormal, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
    } // init
    
    // MARK: - loadTexture
    private func loadTexture(_ semantic: MDLMaterialSemantic,
                             mdlMaterial: MDLMaterial?,
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

// MARK: - MaterialIndex
enum MaterialIndex: Int, CaseIterable {
    case diffuseTexture = 1
    case specularTexture = 2
    case normalTexture = 3
} // MaterialIndex
