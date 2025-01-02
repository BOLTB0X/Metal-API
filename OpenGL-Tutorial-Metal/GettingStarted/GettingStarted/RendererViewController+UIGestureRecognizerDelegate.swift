//
//  RendererViewController+UIGestureRecognizerDelegate.swift
//  GettingStarted
//
//  Created by KyungHeon Lee on 2025/01/02.
//

import UIKit

extension RendererViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
