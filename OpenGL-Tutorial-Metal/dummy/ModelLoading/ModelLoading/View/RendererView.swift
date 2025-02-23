//
//  RendererView.swift
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/20.
//

import SwiftUI
import UIKit

// MARK: - RendererView
struct RendererView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RendererViewController {
        return RendererViewController()
    }
    
    func updateUIViewController(_ uiViewController: RendererViewController, context: Context) {
    }
    
} // RendererView
