/// Copyright (c) 2021 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Combine
import CoreGraphics
import UIKit
import Vision

enum CameraViewModelAction {
  // View setup and configuration actions
  case windowSizeDetected(CGRect)

  // Face detection actions
  case noFaceDetected
  case faceObservationDetected(FaceGeometryModel)

  // Other
  case toggleDebugMode
  case toggleHideBackgroundMode
}

enum FaceDetectedState {
  case faceDetected
  case noFaceDetected
  case faceDetectionErrored
}

enum FaceBoundsState {
  case unknown
  case detectedFaceTooSmall
  case detectedFaceTooLarge
  case detectedFaceOffCentre
  case detectedFaceAppropriateSizeAndPosition
}

struct FaceGeometryModel {
  // 이 변경으로 뷰 모델의 면에서 감지된 롤, 피치 및 요 값을 저장할 수 있으
  let boundingBox: CGRect
  let roll: NSNumber
  let pitch: NSNumber
  let yaw: NSNumber
}

// MARK: 전체 앱의 상태를 제어하는 뷰 모델
final class CameraViewModel: ObservableObject {
  // MARK: - Publishers
  @Published var debugModeEnabled: Bool
  @Published var hideBackgroundModeEnabled: Bool

  // MARK: - Publishers of derived state
  @Published private(set) var hasDetectedValidFace: Bool

  // MARK: - Publishers of Vision data directly
  @Published private(set) var faceDetectedState: FaceDetectedState
  @Published private(set) var faceGeometryState: FaceObservation<FaceGeometryModel> {
    didSet {
      processUpdatedFaceGeometry()
    }
  }
  
  // MARK: - hasDetectedValidFace property
  @Published private(set) var isAcceptableRoll: Bool {
    didSet {
      calculateDetectedFaceValidity()
    }
  }
  @Published private(set) var isAcceptablePitch: Bool {
    didSet {
      calculateDetectedFaceValidity()
    }
  }
  @Published private(set) var isAcceptableYaw: Bool {
    didSet {
      calculateDetectedFaceValidity()
    }
  }
  // MARK: - Public properties
  let shutterReleased = PassthroughSubject<Void, Never>()

  // MARK: - Private variables
  var faceLayoutGuideFrame = CGRect(x: 0, y: 0, width: 200, height: 300)

  init() {
    faceDetectedState = .noFaceDetected

    hasDetectedValidFace = true
    faceGeometryState = .faceNotFound
    
    // add
    isAcceptableRoll = false
    isAcceptablePitch = false
    isAcceptableYaw = false

    #if DEBUG
      debugModeEnabled = true
    #else
      debugModeEnabled = false
    #endif
    hideBackgroundModeEnabled = false
  }

  // MARK: Actions
  func perform(action: CameraViewModelAction) {
    switch action {
    case .windowSizeDetected(let windowRect):
      handleWindowSizeChanged(toRect: windowRect)
    case .noFaceDetected:
      publishNoFaceObserved()
    case .faceObservationDetected(let faceObservation):
      publishFaceObservation(faceObservation)
    case .toggleDebugMode:
      toggleDebugMode()
    case .toggleHideBackgroundMode:
      toggleHideBackgroundMode()
    }
  }

  // MARK: Action handlers

  private func handleWindowSizeChanged(toRect: CGRect) {
    faceLayoutGuideFrame = CGRect(
      x: toRect.midX - faceLayoutGuideFrame.width / 2,
      y: toRect.midY - faceLayoutGuideFrame.height / 2,
      width: faceLayoutGuideFrame.width,
      height: faceLayoutGuideFrame.height
    )
  }

  private func publishNoFaceObserved() {
    DispatchQueue.main.async { [self] in
      faceDetectedState = .noFaceDetected
      faceGeometryState = .faceNotFound
    }
  }

  private func publishFaceObservation(_ faceGeometryModel: FaceGeometryModel) {
    DispatchQueue.main.async { [self] in
      faceDetectedState = .faceDetected
      faceGeometryState = .faceFound(faceGeometryModel)
    }
  }

  private func publishFaceQualityObservation() { }

  private func toggleDebugMode() {
    debugModeEnabled.toggle()
  }

  private func toggleHideBackgroundMode() {
    hideBackgroundModeEnabled.toggle()
  }

  private func takePhoto() { }

  private func savePhoto(_ photo: UIImage) { }
}

// MARK: Private instance methods

extension CameraViewModel {
  func invalidateFaceGeometryState() {
    // 감지된 얼굴이 없으므로 허용 가능한 롤, 피치 및 요 값을 false로 설정
    isAcceptableRoll = false
    isAcceptablePitch = false
    isAcceptableYaw = false
  }

  func processUpdatedFaceGeometry() {
    switch faceGeometryState {
    case .faceNotFound:
      invalidateFaceGeometryState()
    case .errored(let error):
      print(error.localizedDescription)
      invalidateFaceGeometryState()
      // 여기에서 감지된 얼굴의 롤, 피치 및 요 값을 faceGeometryModel에서 두 배로 가져옴
    case .faceFound(let faceGeometryModel):
      let roll = faceGeometryModel.roll.doubleValue
      let pitch = faceGeometryModel.pitch.doubleValue
      let yaw = faceGeometryModel.yaw.doubleValue
      updateAcceptableRollPitchYaw(using: roll, pitch: pitch, yaw: yaw)
      return
    }
  }

  func updateAcceptableBounds(using boundingBox: CGRect) { }

  func updateAcceptableRollPitchYaw(using roll: Double, pitch: Double, yaw: Double) {
    isAcceptableRoll = (roll > 1.2 && roll < 1.6)
    isAcceptablePitch = abs(CGFloat(pitch)) < 0.2
    isAcceptableYaw = abs(CGFloat(yaw)) < 0.15
  }

  func processUpdatedFaceQuality() { }

  func calculateDetectedFaceValidity() {
    hasDetectedValidFace =
      isAcceptableRoll &&
      isAcceptablePitch &&
      isAcceptableYaw
  }
}
