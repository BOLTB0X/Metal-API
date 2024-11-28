//
//  TriangleView.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/27.
//

import SwiftUI
import UIKit

struct TriangleView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: TriangleViewModel
    
    func makeUIViewController(context: Context) -> RenderViewController {
        let viewController = RenderViewController()
        viewController.currentColor = viewModel.currentColor
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: RenderViewController, context: Context) {
        uiViewController.currentColor = viewModel.currentColor
    }
}
