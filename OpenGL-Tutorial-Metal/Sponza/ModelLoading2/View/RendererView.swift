//
//  RendererView.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
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
