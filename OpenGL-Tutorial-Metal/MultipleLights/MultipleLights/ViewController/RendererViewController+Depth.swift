//
//  RendererViewController+Depth.swift
//  MultipleLights
//
//  Created by KyungHeon Lee on 2025/02/18.
//

import UIKit
import Metal

extension RendererViewController {
    // MARK: - setupDepthTexture
    public func setupDepthTexture() -> MTLTexture? {
        guard let drawable = metalLayer.nextDrawable() else {
            fatalError("metalLayer.nextDrawable() 생성 실패")
        }
        let depthTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .depth32Float,
            width: Int(drawable.texture.width),
            height: Int(drawable.texture.height),
            mipmapped: false
        )
        depthTextureDescriptor.usage = .renderTarget
        depthTextureDescriptor.storageMode = .private
        return device.makeTexture(descriptor: depthTextureDescriptor)
    } // setupDepthTexture
    
    // MARK: - setupDepthStencilState
    public func setupDepthStencilState() -> MTLDepthStencilState? {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        return device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    } // setupDepthStencilState
        
}
