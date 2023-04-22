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
  
  // MARK: 6) Creating a Render Pipeline
  // 6) 이제 버텍스 및 프래그먼트 셰이더를 만들었으므로 다른 구성 데이터와 함께 렌더 파이프라인이라는 특수 개체에 결합
  // 6) Metal의 멋진 점 중 하나는 셰이더가 사전 컴파일되고 렌더 파이프라인 구성이 처음 설정한 후 컴파일된다는 것
  // 6) 이것은 모든 것을 매우 효율적으로 만듬
  var pipelineState: MTLRenderPipelineState!
  
  // MARK: 7) Creating a Command Queue
  // 7) 수행해야 하는 마지막 일회성 설정 단계는 MTLCommandQueue를 생성하는 것
  // 7) 이것을 한 번에 하나씩 실행하도록 GPU에 지시하는 순서가 지정된 명령 목록으로 생각
  // 7) 명령 대기열을 만들려면 새 속성을 추가하기만 하면 됨
  var commandQueue: MTLCommandQueue!
  
  // MARK: 8) Creating a Display Link
  // 8) CADisplayLink는 디스플레이 재생 빈도에 동기화된 타이머
  var timer: CADisplayLink!

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
    
    // 6-1)
    // device.makeDefaultLibrary()!를 호출하여 얻은 MTLLibrary 개체를 통해 프로젝트에 포함된 미리 컴파일된 셰이더에 액세스할 수 있음
    // 그런 다음 이름별로 각 셰이더를 조회할 수 있음
    let defaultLibrary = device.makeDefaultLibrary()!
    let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
    let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
    // 6-2)
    // 렌더 파이프라인 구성을 설정
    // 여기에는 사용하려는 셰이더와 색상 첨부를 위한 픽셀 형식, 즉 CAMetalLayer 자체인 렌더링 대상 출력 버퍼가 포함됨
    let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    pipelineStateDescriptor.vertexFunction = vertexProgram
    pipelineStateDescriptor.fragmentFunction = fragmentProgram
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
    // 6-3)
    // 마지막으로 파이프라인 구성을 여기에서 사용하기에 효율적인 파이프라인 상태로 컴파일
    pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

    // 7)
    commandQueue = device.makeCommandQueue()
    
    // 8)
    timer = CADisplayLink(target: self, selector: #selector(gameloop))
    timer.add(to: RunLoop.main, forMode: .default)
  }
  
  // MARK: 9) Creating a Render Pass Descriptor
  // 9) MTLRenderPassDescriptor를 생성하는 것
  // 9) MTLRenderPassDescriptor는 렌더링되는 텍스처, 명확한 색상 및 약간의 기타 구성을 구성하는 개체
  func render() {
    // 9) 생성한 Metal 레이어에서 nextDrawable()을 호출하여 화면에 무언가를 표시하기 위해 그려야 하는 텍스처를 반환
    guard let drawable = metalLayer?.nextDrawable() else { return }
    // 9) 다음으로 해당 텍스처를 사용하도록 렌더 패스 설명자를 구성
    // 9) 불러오기 동작을 Clear로 설정합니다. 즉, “그리기 전에 텍스처를 선명한 색상으로 설정”한다는 의미이며,
    // Clear 색상은 사이트에서 사용하는 녹색 색상으로 설정
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .clear
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
      red: 0.0,
      green: 104.0/255.0,
      blue: 55.0/255.0,
      alpha: 1.0)
    
    // MARK: 10) Creating a Command Buffer
    // 10) 색상과 선을 그렸으면 명령 버퍼를 만들어야 함
    // 10) 버퍼를 이 프레임에 대해 실행하려는 렌더링 명령 목록이라고 생각
    // 10) 명령 버퍼를 커밋하기 전까지는 실제로 아무 일도 일어나지 X
    // 10) 즉 세밀하게 제어 가능
    
    // 10) 이 코드를 추가하는 것이 명령 버퍼를 생성하는 것
    let commandBuffer = commandQueue.makeCommandBuffer()!
    
    // MARK: 11) Creating a Render Command Encoder
    // 11) 명령 버퍼에는 하나 이상의 렌더링 명령이 포함되어야 함
    // 11) 렌더링 명령을 만들려면 렌더링 명령 인코더라는 도우미 개체를 사용
    // 11) 여기에서 명령 인코더를 생성하고 이전에 생성한 파이프라인 및 정점 버퍼를 지정
    let renderEncoder = commandBuffer
      .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder
      .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1) // 11-1) 가장 중요한 부분
    // 11-1) 여기에서 정점 버퍼를 기반으로 삼각형 집합을 그리도록 GPU에 지시
    // 11-1) 메서드 인수는 각 삼각형이 꼭짓점 버퍼 내부의 인덱스 0에서 시작하는 세 개의 꼭짓점으로 구성되고
    // 11-1) 총 하나의 삼각형이 있음을 Metal에게 전달
    renderEncoder.endEncoding() // 11-1) 완료되면 endEncoding()을 호출하기만 하면 됨
    
    // MARK: 12) Committing Your Command Buffer
    // 12) 그리기가 완료되는 즉시 GPU가 새 텍스처를 제공하는지 확인하려면 첫 번째 줄이 필요
    // 12) 그런 다음 트랜잭션을 커밋하여 작업을 GPU로 보냄
    commandBuffer.present(drawable)
    
    // 12) 완료
    commandBuffer.commit()
  }
  
  // 8) 여기서 gameloop()는 매 프레임마다 단순히 render()를 호출
  @objc func gameloop() {
    autoreleasepool {
      self.render()
    }
  }
  
}
