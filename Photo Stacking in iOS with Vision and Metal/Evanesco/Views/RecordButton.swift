/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@IBDesignable
class RecordButton: UIButton {
  var progress: CGFloat = 0.0 {
    didSet {
      DispatchQueue.main.async {
        self.setNeedsDisplay()
      }
    }
  }
  
  override func draw(_ rect: CGRect) {
    // General Declarations
    let context = UIGraphicsGetCurrentContext()!
    // Resize to Target Frame
    context.saveGState()    
    context.translateBy(x: bounds.minX, y: bounds.minY)
    context.scaleBy(x: bounds.width / 218, y: bounds.height / 218)
    // Color Declarations
    let red = UIColor(red: 0.949, green: 0.212, blue: 0.227, alpha: 1.000)
    let white = UIColor(red: 0.996, green: 1.000, blue: 1.000, alpha: 1.000)
    // Variable Declarations
    let expression: CGFloat = -progress * 360
    // Button Drawing
    let buttonPath = UIBezierPath(ovalIn: CGRect(x: 26, y: 26, width: 166, height: 166))
    red.setFill()
    buttonPath.fill()
    // Ring Background Drawing
    let ringBackgroundPath = UIBezierPath(ovalIn: CGRect(x: 8.5, y: 8.5, width: 200, height: 200))
    white.setStroke()
    ringBackgroundPath.lineWidth = 19
    ringBackgroundPath.lineCapStyle = .round
    ringBackgroundPath.stroke()
    // Progress Ring Drawing
    let progressRingRect = CGRect(x: 8.5, y: 8.5, width: 200, height: 200)
    let progressRingPath = UIBezierPath()
    progressRingPath.addArc(withCenter: CGPoint(x: progressRingRect.midX, y: progressRingRect.midY), radius: progressRingRect.width / 2, startAngle: -90 * CGFloat.pi/180, endAngle: -(expression + 90) * CGFloat.pi/180, clockwise: true)
    red.setStroke()
    progressRingPath.lineWidth = 19
    progressRingPath.lineCapStyle = .round
    progressRingPath.stroke()
    context.restoreGState()
  }
  
  func resetProgress() {
    progress = 0.0
  }
}
