//
//  TwintriangleView.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/29.
//

import SwiftUI
import UIKit

struct TwintriangleView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Render2ViewController {
        let viewController = Render2ViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: Render2ViewController, context: Context) {
    }
}

