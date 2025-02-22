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
struct Texture {
    var texture: MTLTexture
    var type: TextureType
    
    static var textureCache: [MDLTexture?: MTLTexture?] = [:] // 텍스처 캐싱을 위한 static dict
    
    // MARK: - loadTexture
    static func loadTexture(mdlMaterial: MDLMaterial?,
                            semantic: MDLMaterialSemantic,
                            textureLoader: MTKTextureLoader) -> MTLTexture? {
        guard let materialProperty = mdlMaterial?.property(with: semantic) else { return nil }
        guard let sourceTexture = materialProperty.textureSamplerValue?.texture else { return nil }
        // 캐시에서 텍스처 검색
        
        if let cachedTexture = textureCache[sourceTexture] {
            return cachedTexture
        }
        
        //let textureLoader = MTKTextureLoader(device: device)
//        let textureURL = URL(fileURLWithPath: texturePath)
//        print("\(textureURL)")
        
        do {
            let texture = try textureLoader.newTexture(texture: sourceTexture, options: nil)
            textureCache[sourceTexture] = texture
            return texture
        } catch {
            print("texture 로드 에러: \(error)")
            return nil
        } // do - catch
        
    } // loadTexture
    
} // Texture
