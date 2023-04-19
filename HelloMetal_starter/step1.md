https://www.kodeco.com/7475-metal-tutorial-getting-started

## Metal 이란?

[img](https://developer.apple.com/assets/elements/icons/metal/metal-96x96_2x.png)

> Metal powers hardware-accelerated graphics on Apple platforms by providing a low-overhead API
> <br/>

Metal은 낮은 오버헤드 API를 제공하여 Apple 플랫폼에서 하드웨어 가속 그래픽을 지원
<br/>

Metal은 3D 그래픽 하드웨어와 상호 작용하기 위한 저수준 API라는 점에서 OpenGL ES와 유사
<br/>

차이점은 Metal은 크로스 플랫폼이 아니라는 것, 대신 OpenGL ES를 사용할 때보다 속도가 향상되고 오버헤드가 낮아 Apple 하드웨어에서 매우 효율적으로 작동하도록 설계되었음
<br/>

Metal을 사용하면 앱에서 GPU를 활용하여 복잡한 장면을 빠르게 렌더링하고 컴퓨팅 작업을 병렬로 실행 가능
<br/>

## Metal vs SpriteKit, SceneKit or Unity

[img](https://koenig-media.raywenderlich.com/uploads/2014/07/2_Boxes.png)
<br/>

Metal이 SpriteKit, SceneKit 또는 Unity와 같은 상위 수준 프레임워크와 어떻게 비교되는지 이해하는 것이 도움이 된다함
<br/>

Metal은 OpenGL ES와 유사한 저수준 3D 그래픽 API이지만 오버헤드가 낮아 성능이 향상 -> 이것은 GPU 위의 매우 얇은 레이어
<br/>

즉, 스프라이트 또는 3D 모델을 화면에 렌더링하는 것과 같은 거의 모든 작업을 수행하려면 이를 수행하기 위한 모든 코드를 작성해야 함
<br/>

트레이드 오프는 완전한 권한과 제어권을 갖는다는 것, 반대로 SpriteKit, SceneKit 및 Unity와 같은 상위 수준의 게임 프레임워크는 Metal 또는 OpenGL ES와 같은 하위 수준의 3D 그래픽 API 위에 구축
<br/>

스프라이트 또는 3D 모델을 화면에 렌더링하는 것과 같이 일반적으로 게임에서 작성하는 데 필요한 많은 상용구 코드를 제공
<br/>

## Metal을 배워야 하는 두 가지 좋은 이유

1. 하드웨어를 최대한 활용: Metal은 매우 낮은 수준에 있기 때문에 하드웨어를 최대한 활용하고 게임 작동 방식, 카메라 필터 등을 완전히 제어 가능
   <br/>

2. Metal은 3D 그래픽, 자신만의 게임 엔진 작성, 고급 게임 프레임워크 작동 방식
   <br/>
