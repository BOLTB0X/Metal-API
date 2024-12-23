# Transformations

1. **Local to World**: 로컬 space - **Model Matrix** -> 월드 space
   <br/>

2. **World to View**: 월드 space - **View Matrix** -> 뷰 space
   <br/>

3. **View to Clip**: 뷰 space - **Projection Matrix** -> 클립 space
   <br/>

4. **Clip to Screen**: 클립 cpace - **Perspective(원근) 나누기** + **Viewport Transform** -> Screen
   <br/>

## Local Space(Object Space)

- **정의**
  객체의 원점이나 로컬 좌표계를 기준으로 한 좌표 sys
  <br/>
- **목적**
  변환이 적용되기 전, 객체 자체의 고유한 좌표를 표현
  ex) _큐브 모델의 정점 좌표가 (-1, -1, -1)부터 (1, 1, 1)로 정의되어 있는 경우_
  -> **큐브의 중심을 기준으로 한 로컬 공간에서의 좌표**
  <br/>

- **활용**
  객체가 독립적으로 정의되도록 하여 이후 변환(이동, 회전 등)에 유연하게 대응
  <br/>

## World Space

- **정의**
  scene(장면) 전체를 기준으로 한 좌표 sys
  <br/>

- **목적**
  객체를 세계 좌표계 상에서 특정 위치에 배치
  <br/>

- **변환**
  로컬 공간에서 월드 공간으로의 변환은 **Model Matrix(모델 행렬)** 을 사용
  - Model Matrix
    객체를 **이동(Translation)**, **회전(Rotation)**, **크기 변경(Scaling)** 하는 행렬
  - ex) _로컬 공간에서 중심이 (0, 0, 0)인 큐브가 월드 공간에서 (5, 3, 2)로 이동_
    <br/>

## View Space(Eye Space)

- **정의**
  카메라(또는 관찰자)를 기준으로 한 좌표 sys
  <br/>

- **목적**
  카메라 시점에서 본 scene의 위치와 방향을 정의
  <br/>

- **변환**
  월드 공간에서 뷰 공간으로의 변환은 **뷰 행렬(View Matrix)**을 사용
  - 뷰 행렬: 카메라의 **위치**, **방향**, **회전** 정보를 포함
  - ex) _카메라가 (0, 0, 5)에 위치하고 (0, 0, 0)을 바라본다면, 객체들은 이 카메라 시점에 맞게 변환됨_
    <br/>

## Clip Space

- **정의**
  카메라의 **visible(가시) 영역(프러스텀, Frustum)** 내에서 좌표를 표현하는 sys
  <br/>

- **목적**
  렌더링 파이프라인에서, 카메라 시점에서 보이는 영역 밖에 있는 **vertices(좌표)**을 **제거**하기 위해 사용
  <br/>

- **변환**
  뷰 공간에서 클립 공간으로의 변환은 **투영 행렬(Projection Matrix)**을 사용

  - Projection Matrix(투영 행렬): 3D 좌표를 원근법(Perspective) 또는 Orthographic Projection(직교 투영)으로 변환

  - ex) _카메라가 볼 수 있는 영역(프러스텀) 밖에 있는 좌표(x > 1.0 또는 z < -1.0 등)은 제거됨_
    <br/>

## Screen Space

- **정의**
  화면(디스플레이)의 2D 좌표계를 기준으로 한 sys
  <br/>

- **목적**
  정규화된 장치 좌표(NDC)를 픽셀 좌표로 변환하여 렌더링
  <br/>

- **변환**
  클립 공간에서 스크린 공간으로의 변환 과정
  - **원근 나누기(Perspective Division)** : 정점의 x, y, z 좌표를 w로 나눠 정규화된 장치 좌표(NDC)로 변환
  - **뷰포트 변환(Viewport Transformation)** : 정규화된 좌표를 화면 해상도 및 뷰포트 설정에 따라 픽셀 단위로 변환
