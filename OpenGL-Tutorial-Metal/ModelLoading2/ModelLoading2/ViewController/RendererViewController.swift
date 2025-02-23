//
//  ViewController.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import UIKit
import MetalKit

// MARK: - RendererViewController
class RendererViewController: UIViewController {
    var metalView: MTKView!
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Metal view 설정
        metalView = MTKView(frame: self.view.bounds)
        metalView.device = MTLCreateSystemDefaultDevice()
        self.view.addSubview(metalView)
        
        // 렌더러 설정
        renderer = Renderer(metalKitView: metalView)
        renderer.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        metalView.delegate = renderer
    }
    
} // RendererViewController
