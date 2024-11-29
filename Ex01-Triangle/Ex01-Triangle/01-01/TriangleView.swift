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
    
    func makeUIViewController(context: Context) -> Render1ViewController {
        let viewController = Render1ViewController()
        viewController.currentColor = viewModel.currentColor
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: Render1ViewController, context: Context) {
        uiViewController.currentColor = viewModel.currentColor
    }
}
