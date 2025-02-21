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
    
    static var textureCache: [String: MTLTexture] = [:] // 텍스처 캐싱을 위한 static dict
    
    // MARK: - loadTexture
    static func loadTexture(from property: MDLMaterialProperty?, device: MTLDevice) -> MTLTexture? {
        guard let property = property,
              property.type == .string,
              let texturePath = property.stringValue else { return nil }
        
        // 캐시에서 텍스처 검색
        if let cachedTexture = textureCache[texturePath] {
            return cachedTexture
        }
        
        let textureLoader = MTKTextureLoader(device: device)
        let textureURL = URL(fileURLWithPath: texturePath)
        
        do {
            let texture = try textureLoader.newTexture(URL: textureURL, options: nil)
            textureCache[texturePath] = texture
            return texture
        } catch {
            print("texture 로드 에러: \(error)")
            return nil
        } // do - catch
        
    } // loadTexture
    
} // Texture
