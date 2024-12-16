//
//  ShadersView.swift
//  Ex02-Shaders
//
//  Created by KyungHeon Lee on 2024/12/04.
//

import SwiftUI
import UIKit

struct ShadersView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RendererViewController {
        let viewController = RendererViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: RendererViewController, context: Context) {
    }
}
