//
//  RendererView.swift
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/04.
//

import SwiftUI
import UIKit

// MARK: - RendererView
struct RendererView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RendererViewController {
        let viewController = RendererViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: RendererViewController, context: Context) {
    }
    
} // RendererView
