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

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
  @IBOutlet var previewView: UIView!
  @IBOutlet var containerView: UIView!
  @IBOutlet var combinedImageView: UIImageView!
  @IBOutlet var recordButton: RecordButton!
  var previewLayer: AVCaptureVideoPreviewLayer!
  let session = AVCaptureSession()
  var isRecording = false
  let maxFrameCount = 20
  
  var saver: ImageSaver?


  override func viewDidLoad() {
    super.viewDidLoad()
    containerView.isHidden = true
    configureCaptureSession()
    session.startRunning()
  }
}

// MARK: - Configuration Methods

extension CameraViewController {
  func configureCaptureSession() {
    guard let camera = AVCaptureDevice.default(for: .video) else {
      fatalError("No video camera available")
    }
    do {
      let cameraInput = try AVCaptureDeviceInput(device: camera)
      session.addInput(cameraInput)
      try camera.lockForConfiguration()
      // 첫 번째 줄은 최대 프레임 속도를 초당 5프레임으로 설정
      camera.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 5)
      // 두 번째 줄은 최소 프레임 속도를 동일하게 정의
      camera.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 5)
      camera.unlockForConfiguration()
    } catch {
      fatalError(error.localizedDescription)
    }
    // Define where the video output should go
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video data queue"))
    //videoOutput.alwaysDiscardsLateVideoFrames = true
    videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    // Add the video output to the capture session
    session.addOutput(videoOutput)
    let videoConnection = videoOutput.connection(with: .video)
    videoConnection?.videoOrientation = .portrait
    // Configure the preview layer
    previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.videoGravity = .resizeAspectFill
    previewLayer.frame = view.bounds
    previewView.layer.addSublayer(previewLayer)
  }
}

// MARK: - UI Methods

extension CameraViewController {
  @IBAction func recordTapped(_ sender: UIButton) {
    recordButton.isEnabled = false
    isRecording = true
  }
  
  @IBAction func closeButtonTapped(_ sender: UIButton) {
    containerView.isHidden = true
    recordButton.isEnabled = true
    session.startRunning()
  }

  func stopRecording() {
    isRecording = false
    recordButton.progress = 0.0
  }
  
  func displayCombinedImage(_ image: CIImage) {
    session.stopRunning()
    combinedImageView.image = UIImage(ciImage: image)
    containerView.isHidden = false
  }
}

// MARK: - Capture Video Data Delegate Methods

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    if !isRecording {
      return
    }
    let currentFrame = recordButton.progress * CGFloat(maxFrameCount)
    recordButton.progress = (currentFrame + 1.0) / CGFloat(maxFrameCount)
    if recordButton.progress >= 1.0 {
      stopRecording()
    }
  }
}
