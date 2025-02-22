//
//  RendererViewController.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/19.
//

import UIKit
import MetalKit

// MARK: - RendererViewController
class RendererViewController: UIViewController {
    private var renderer: Renderer!
    private var mtkView: MTKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Metal view 설정
        mtkView = MTKView(frame: self.view.bounds)
        mtkView.device = MTLCreateSystemDefaultDevice()
        self.view.addSubview(mtkView)
        
        // 렌더러 설정
        renderer = Renderer(mtkView: mtkView)
        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = renderer
    }
    
} // RendererViewController
