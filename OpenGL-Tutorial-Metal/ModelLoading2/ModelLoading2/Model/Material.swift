//
//  Material.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import MetalKit

// MARK: - Material
struct Material {
    var textures: [MTLTexture?] = Array(repeating: nil, count: MaterialIndex.allCases.count)
    
    static private var textureMap: [MDLTexture?: MTLTexture?] = [:]
    
    // MARK: - init
    init(mdlMaterial: MDLMaterial?, textureLoader: MTKTextureLoader) {
        MaterialIndex.allCases.forEach { index in
            textures[index.rawValue] = loadTexture(index.semantic, mdlMaterial: mdlMaterial, textureLoader: textureLoader)
        } // forEach
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
    case diffuseTexture
    case specularTexture
    case normalTexture
    case roughnessTexture
    case aoTexture
    
    var semantic: MDLMaterialSemantic {
        switch self {
        case .diffuseTexture: return .baseColor
        case .specularTexture: return .specular
        case .normalTexture: return .tangentSpaceNormal
        case .roughnessTexture: return .roughness
        case .aoTexture: return .ambientOcclusion
        }
    } // semantic
    
} // MaterialIndex
