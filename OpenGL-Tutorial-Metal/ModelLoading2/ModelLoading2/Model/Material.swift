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
    var roughnessTexture: MTLTexture?
    var aoTexture: MTLTexture?
    
    static private var textureMap: [MDLTexture?: MTLTexture?] = [:]
    
    // MARK: - init
    init(mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) {
        self.diffuseTexture = loadTexture(.baseColor, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        self.specularTexture = loadTexture(.specular, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        self.normalTexture = loadTexture(.tangentSpaceNormal, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        self.roughnessTexture = loadTexture(.roughness, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        self.aoTexture = loadTexture(.ambientOcclusion, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
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
enum MaterialIndex: Int {
    case diffuseTexture
    case specularTexture
    case normalTexture
    case roughnessTexture
    case aoTexture
} // MaterialIndex
