//
//  TexturesView.swift
//  Ex03-Textures
//
//  Created by KyungHeon Lee on 2024/12/12.
//

import SwiftUI
import UIKit

struct TexturesView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RendererViewController {
        let viewController = RendererViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: RendererViewController, context: Context) {
    }
}

