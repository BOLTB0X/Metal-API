//
//  RendererViewController+Depth.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/26.
//

import Foundation
import Metal

extension RendererViewController {
    // MARK: - setupDepthTexture
    public func setupDepthTexture() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        let depthTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .depth32Float,
            width: Int(drawable.texture.width),
            height: Int(drawable.texture.height),
            mipmapped: false
        )
        depthTextureDescriptor.usage = .renderTarget
        depthTextureDescriptor.storageMode = .private
        depthTexture = device.makeTexture(descriptor: depthTextureDescriptor)
    } // setupDepthTexture
    
    // MARK: - setupDepthStencilState
    public func setupDepthStencilState() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    } // setupDepthStencilState
    
    // MARK: - setupDepthBuffer
    public func setupDepthBuffer() {
        let depthTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .depth32Float,
            width: Int(view.bounds.width),
            height: Int(view.bounds.height),
            mipmapped: false
        )
        depthTextureDescriptor.usage = .renderTarget
        depthTextureDescriptor.storageMode = .private
        
        depthTexture = device.makeTexture(descriptor: depthTextureDescriptor)
    } // setupDepthBuffer
    
}
