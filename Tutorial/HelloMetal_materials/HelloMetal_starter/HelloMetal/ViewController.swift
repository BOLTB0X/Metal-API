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
import Metal

class ViewController: UIViewController {
  var device: MTLDevice!
  // Metal을 사용하여 화면에 무언가를 그리려면 CAMetalLayer라는 특별한 CALayer 하위 클래스를 사용해야 합
  var metalLayer: CAMetalLayer!
  
  let vertexData: [Float] = [
     0.0,  1.0, 0.0,
    -1.0, -1.0, 0.0,
     1.0, -1.0, 0.0
  ]
  
  var vertexBuffer: MTLBuffer! // CPU에 부동 소수점 배열이 생성, 이 data를 MTLBuffer라는 것으로 이동하여 GPU로 보내야 함
  var pipelineState: MTLRenderPipelineState!
  
  /// 마지막 설정 단계는 MTLCommandQueue를 생성
  /// 이것을 GPU에 한 번에 하나씩 실행하라고 지시하는 명령 목록 같은 것
  var commandQueue: MTLCommandQueue!
  
  /// CADisplayLink는 디스플레이 새로 고침 빈도에 동기화된 타이머
  ///
  var timer: CADisplayLink!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    device = MTLCreateSystemDefaultDevice() // 0 코드에서 사용해야 하는 기본 MTLDevice에 대한 참조를 반환
    
    metalLayer = CAMetalLayer()          // 1 생성
    metalLayer.device = device           // 2 layer가 사용해야 하는 MTLDevice를 지정해야 하므로 0을 대입
    metalLayer.pixelFormat = .bgra8Unorm // 3 픽셀 형식을 bgra8Unorm으로 설정
    metalLayer.framebufferOnly = true    // 4 Apple에서는 이 layer에 대해 생성된 텍스처에서 샘플링해야 하거나 layer 드로어블 텍스처에서 컴퓨팅 커널을 활성화해야 하는 경우가 아니면 성능상의 이유로 FramebufferOnly를 true로 설정할 것을 권장, 대부분의 경우 이 작업을 수행할 필요 X
    metalLayer.frame = view.layer.frame  // 5 뷰의 프레임과 일치하도록 layer의 프레임을 설정
    view.layer.addSublayer(metalLayer)   // 6 뷰의 기본 layer의 하위 layer로 layer를 추가
    
    let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 7 vertex data의 크기를 바이트 단위로 가져와야 함, 첫 번째 요소의 크기에 배열의 요소 수를 곱하여 이를 수행
    vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 2 GPU에 새 버퍼를 생성하고 CPU의 데이터를 전달, 기본 구성을 위해 빈 배열을 전달
    
    // vertex shader는 꼭짓점당 한 번씩 호출되며, 그 역할은 위치와 같은 해당 꼭짓점의 정보와 색상이나 텍스처 좌표와 같은 기타 정보를 가져와 잠재적으로 수정된 위치와 기타 데이터를 반환하는 것
    // 작업을 단순하게 유지하기 위해 간단한 vertex shader는 전달된 위치와 동일한 위치를 반환
    
    
    // vertex 및 fragment 셰이더와 다른 구성들을 렌더 파이프라인이라는 특수 객체로 결합해야 함
    // 셰이더가 사전 컴파일되고 렌더 파이프라인 구성이 처음 설정된 후에 컴파일된다
    
    /// 1
    /// device.makeDefaultLibrary()!를 호출하여 얻은 MTLLibrary 객체를 통해 프로젝트에 포함된 사전 컴파일된 셰이더에 액세스
    /// 그런 다음 각 셰이더를 이름으로 검색 가능
    let defaultLibrary = device.makeDefaultLibrary()!
    let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
    let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
    /// 2
    /// 여기에서 렌더 파이프라인 구성을 설정
    /// 여기에는 사용하려는 셰이더와 색상 첨부를 위한 픽셀 형식(즉, 렌더링하려는 출력 버퍼, 즉 CAMetalLayer 자체)이 포함되어 있음
    let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    pipelineStateDescriptor.vertexFunction = vertexProgram
    pipelineStateDescriptor.fragmentFunction = fragmentProgram
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
    // 3
    // 마지막으로 파이프라인 구성을 여기에서 사용하기에 효율적인 파이프라인 상태로 컴파일함
    pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    
    // 명령 입력
    commandQueue = device.makeCommandQueue()
    
    /// 디스플레이 새로 고침 빈도에 동기화된 타이머
    timer = CADisplayLink(target: self, selector: #selector(gameloop))
    timer.add(to: RunLoop.main, forMode: .default)
  }
  
  /// 렌더링되는 텍스처, 선명한 색상 및 기타 구성을 구성하는 개체인 MTLRenderPassDescriptor
  func render() {
    guard let drawable = metalLayer?.nextDrawable() else { return } // 먼저 앞서 생성한 Metal 레이어에서 nextDrawable()을 호출하여 화면에 무언가를 표시하기 위해 그려야 하는 텍스처를 반환
    
    /// 다음으로 해당 텍스처를 사용하도록 렌더 PassDescriptor를 구성
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .clear /// load 동작을 Clear로 설정
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
      red: 0.0,
      green: 0.0,
      blue: 1.0,
      alpha: 0.5) /// 즉, "그림을 그리기 전에 텍스처를 선명한 색상으로 설정"하고 투명 색상을 사이트에서 사용되는 파랑으로 설정
    
    // 커맨드 버퍼: 이 프레임에 대해 실행하려는 렌더링 명령 목록들
    // 명령 버퍼를 커밋할 때까지 아무 일도 일어나지 않아 상황이 발생하는 시점을 세밀하게 제어 가능
    let commandBuffer = commandQueue.makeCommandBuffer()!
    
    let renderEncoder = commandBuffer // 렌더링 명령을 만들려면 렌더링 명령 인코더라는 도우미 개체를 사용
      .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder
      .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1) /// 여기서는 정점 버퍼를 기반으로 삼각형 세트를 그리도록 GPU에 지시
    /// 작업을 단순하게 유지하기 위해 하나만 그리면 됨
    /// 메서드 인수는 각 삼각형이 꼭지점 버퍼 내부의 인덱스 0에서 시작하여 세 개의 꼭지점으로 구성되어 있으며 총 삼각형이 하나 있다는 것을 Metal에 알림
    renderEncoder.endEncoding()
    
    /// 첫 번째 라인은 드로잉이 완료되자마자 GPU가 새로운 텍스처를 제공하는지 확인하는 데 필요
    /// 트랜잭션을 커밋하여 작업을 GPU로 보냄
    ///
    commandBuffer.present(drawable)
    commandBuffer.commit()

  }

  @objc func gameloop() {
    autoreleasepool {
      self.render()
    }
  }
}
