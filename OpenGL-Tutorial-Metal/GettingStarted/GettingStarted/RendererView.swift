//
//  RendererView.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2024/12/17.
//

import SwiftUI
import UIKit

struct RendererView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RendererViewController {
         let viewController = RendererViewController()
         return viewController
     }
     
     func updateUIViewController(_ uiViewController: RendererViewController, context: Context) {
     }

}
