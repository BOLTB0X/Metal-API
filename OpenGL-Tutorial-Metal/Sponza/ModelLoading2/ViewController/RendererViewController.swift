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
    // Metal
    var metalView: MTKView!
    var renderer: RendererManager!
    
    // Gesture
    var lastPanLocation: CGPoint?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMetalView()
        setupRenderer()
        setupGestures()
        
    } // viewDidLoad
    
    // MARK: - setupMetalView
    private func setupMetalView() {
        self.metalView = MTKView(frame: self.view.bounds)
        self.metalView.device = MTLCreateSystemDefaultDevice()
        self.view.addSubview(self.metalView)
    } // setupMetalView
    
    // MARK: - setupRenderer
    private func setupRenderer() {
        self.renderer = RendererManager(metalKitView: self.metalView)
        self.renderer.mtkView(self.metalView, drawableSizeWillChange: self.metalView.drawableSize)
        self.metalView.delegate = self.renderer
    } // setupRenderer
    
    // MARK: - setupGestures
    private func setupGestures() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        self.metalView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        self.metalView.addGestureRecognizer(panGesture)
    } // setupGestures
    
} // RendererViewController

