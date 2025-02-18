//
//  RendererViewController+Textures.swift
//  MultipleLights
//
//  Created by KyungHeon Lee on 2025/02/18.
//

import UIKit
import MetalKit
import simd

extension RendererViewController {
    // MARK: - setupSampler
    public func setupSampler() -> MTLSamplerState {
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        
        samplerDescriptor.sAddressMode = .clampToEdge
        samplerDescriptor.tAddressMode = .clampToEdge
        
        guard let sampler = device.makeSamplerState(descriptor: samplerDescriptor) else {
            fatalError("샘플러 state 생성 실패")
        }
        
        return sampler
    } // setupSampler
    
    // MARK: - loadTexture
    public func loadTexture(_ name: String) throws -> MTLTexture? {
        guard let image = UIImage(named: name)?.cgImage else {
            print("\(name) 불러올 수 없음")
            return nil
        }
        
        let width = image.width
        let height = image.height
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = .rgba8Unorm
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.usage = [.shaderRead]
        
        guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
            print("텍스처 생성 실패")
            return nil
        }
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let imageData = UnsafeMutablePointer<UInt8>.allocate(capacity: bytesPerRow * height)
        defer { imageData.deallocate() }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: imageData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let region = MTLRegionMake2D(0, 0, width, height)
        texture.replace(region: region, mipmapLevel: 0, withBytes: imageData, bytesPerRow: bytesPerRow)
        
        return texture
    } // loadTexture
}
