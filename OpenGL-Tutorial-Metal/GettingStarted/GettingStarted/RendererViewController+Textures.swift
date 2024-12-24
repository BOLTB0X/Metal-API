//
//  Renderer+Textures.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import Foundation
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
    public func loadTexture(_ name: String) throws -> MTLTexture {
        let textureLoader = MTKTextureLoader(device: device)
        
        do {
            return try textureLoader.newTexture(name: name, scaleFactor: 1.0, bundle: nil, options: nil)
        } catch {
            fatalError("텍스처 로드 실패: \(error)")
        }
    } // loadTexture
    
    // MARK: - setupDepthStencilState
    public func setupDepthStencilState() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    } // setupDepthStencilState
}
