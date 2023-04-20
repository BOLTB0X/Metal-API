/// Copyright (c) 2018 Razeware LLC
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
// MARK: 1) Creating an MTLDevice
// 1) 먼저 MTLDevice에 대한 참조를 가져와야 함
// 1) MTLDevice를 GPU에 대한 직접 연결로 생각,
// 1) 이 MTLDevice를 사용하여 필요한 다른 모든 Metal 개체(예: 명령 대기열, 버퍼 및 텍스처)를 생성
import Metal

class ViewController: UIViewController {
  var device: MTLDevice! // 1) add
  // MARK: 2) Creating a CAMetalLayer
  // 2) iOS에서 화면에 보이는 모든 것은 CALayer에 의해 지원
  // 2) gradient layers, shape layers, replicator layers 등과 같은 다양한 효과를 위한 CALayers의 하위 클래스가 있어 이를 활용해야함
  // 2) Metal로 화면에 무언가를 그리려면 CAMetalLayer라는 CALayer의 특수 하위 클래스를 사용해야함
  var metalLayer: CAMetalLayer! // 2) add
  
  // MARK: 3) Creating a Vertex Buffer
  let vertexData: [Float] = [
     0.0,  1.0, 0.0,
    -1.0, -1.0, 0.0,
     1.0, -1.0, 0.0
  ] // 3) 이렇게 하면 CPU에 Float 배열이 생성
  // 3) 이 데이터를 MTLBuffer라는 것으로 이동하여 GPU로 보내야 함
  // 3) 이를 위해 다른 새 속성을 추가
  var vertexBuffer: MTLBuffer!
    
  // 1) 사용하기 전에 확실히 초기화할 것이라는 것을 알고 있으므로 편의를 위해 암시적으로 언래핑된 옵션으로 표시
  // 1) 마지막으로 다음과 같이 viewDidLoad()를 추가하고 장치 속성을 초기화
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1) MTLCreateSystemDefaultDevice는 코드에서 사용해야 하는 기본 MTLDevice에 대한 참조를 반환하는 것
    device = MTLCreateSystemDefaultDevice()
    
    // 2) 새 레이어에 대한 편리한 참조가 저장
    metalLayer = CAMetalLayer()          // 2-1) 새 CAMetalLayer 생성
    metalLayer.device = device           // 2-2) Layer가 사용해야 하는 MTLDevice를 지정해야 함, 이전에 얻은 장치에 이것을 설정하기만 하면 됨
    metalLayer.pixelFormat = .bgra8Unorm // 2-3) 픽셀 형식을 bgra8Unorm으로 지정
    // 이것은 "0과 1 사이의 정규화된 값을 사용하여 파란색, 녹색, 빨간색 및 알파의 순서대로 8바이트" 이것은 CAMetalLayer에 사용할 수 있는 두 가지 형식 중 하나
    metalLayer.framebufferOnly = true    // 2-4) Apple은 이 레이어에 대해 생성된 텍스처에서 샘플링해야 하거나 레이어 드로어블 텍스처에서 컴퓨팅 커널을 활성화해야 하는 경우가 아니면 성능상의 이유로 framebufferOnly를 true로 설정할 것을 권장, 대부분의 경우 다음을 수행할 필요가 X
    metalLayer.frame = view.layer.frame  // 2-5) View의 프레임과 일치하도록 레이어의 프레임을 설정
    view.layer.addSublayer(metalLayer)   // 2-6) 레이어를 뷰의 기본 레이어의 하위 레이어로 추가
    
    let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 3-1) 정점 데이터의 크기를 바이트 단위로 가져와야 함, 첫 번째 요소의 크기에 배열의 요소 수를 곱하면 됌
    vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 3-2) MTLDevice에서 makeBuffer(bytes:length:options:)를 호출하여 GPU에서 새 버퍼를 만들고 CPU에서 데이터를 전달한 뒤 기본 구성을 위해 빈 배열을 전달
  }
}
