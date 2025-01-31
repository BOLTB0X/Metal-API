# Space

![OpenGL-Tutorial-coordinate_systems](https://learnopengl.com/img/getting-started/coordinate_systems.png)

```
모델(로컬) 좌표(Model(Local) Space)
   ↓ [월드 변환 (World(Model) Transform)]
월드 좌표(World Space)
   ↓ [뷰 변환 (View Transform)]
뷰 좌표(View Space)
   ↓ [투영 변환 (Projection Transform)]
클립 좌표(Clip Space)
   ↓ [투영 후 정규화 (Perspective Division)]
NDC (Normalized Device Coordinates)
   ↓ [뷰포트 변환 (Viewport Transform)]
스크린 좌표(Screen Space)
```

## Intro (Handed coordinate system)

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EC%99%BC%EC%86%90.png?raw=true" 
             alt="image 1" 
             style="width:200px; height:200px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Metal-API/blob/main/img/%EC%98%A4%EB%A5%B8%EC%86%90.png?raw=true" 
             alt="image 2" 
             style="width:200px; height:200px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center;">
      <p align="center">
      왼손
      </p>
      </td>
      <td style="text-align:center;">
      <p align="center">
      오른손
      </p>
      </td>
    </tr>
  </table>
</p>

- 두 좌표계의 차이는 `+z`축이 진행하는 방향
  - **Left-handed** : `+z`축은 화면 안쪽으로
  - **Right-handed** : `+z`축은 화면 바깥쪽으로
    <br/>

| Space                     |      Metal      |     OpenGL      |
| :------------------------ | :-------------: | :-------------: |
| 모델(Model / Local) Space |     오른손      |     오른손      |
| 월드(World) Space         |     오른손      |     오른손      |
| 뷰(View) Space            |     오른손      |     오른손      |
| 클립(Clip) Space          |      왼손       |     오른손      |
| NDC                       |      왼손       |     오른손      |
| 스크린(Screen) Space      | `(0, 0)` 좌상단 | `(0, 0)` 좌하단 |

<br/>

## 모델 / Local 좌표계 (Model Space / Local Space)

> Object(모델) 자체의 Local(로컬) 좌표계

> Model Space, Local Space

- 객체의 원점이나 로컬 좌표계를 기준으로 한 좌표
- 3D 모델이 월드(world) 좌표로 변환되기 전의 상태
- 모델 내부의 각 Vertex는 이 좌표계에서 표현되는 것
- 일반적으로 `(0,0,0)` 을 기준으로 모델링 됨
  <br/>

## 월드 좌표계 (World Space)

> 모델을 World 안에서 배치한 좌표계

### 정의

- **scene** 전체를 기준으로 하는 공간(좌표계)
- 즉 하나의 월드 공간에서 여러 개의 모델이 존재 가능
- Model Space에서 World Space으로 변환 -> **Model Matrix** 사용
  <br/>

### Model Matrix

> World Transformation Matrix 와 동일한 개념

$$
M = T \times R \times S
$$

- 각 Object가 월드 공간에서 어디에 위치하는지 결정하는 변환 행렬

- **이동(Translation)**, **회전(Rotation)**, **크기 변경(Scaling)** 사용

$$
T =
\begin{bmatrix}
1 & 0 & 0 & t_x \\
0 & 1 & 0 & t_y \\
0 & 0 & 1 & t_z \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

$$
S =
\begin{bmatrix}
s_x & 0 & 0 & 0 \\
0 & s_y & 0 & 0 \\
0 & 0 & s_z & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

$$
R = R_x(\theta_x) \times R_y(\theta_y) \times R_z(\theta_z)
$$

- _ex)_
  - _모델 공간에서 중심이 (0, 0, 0)인 큐브가 월드 공간에서 (5, 3, 2)로 이동_
    <br/>

## 뷰 좌표계 (View Space)

> 카메라를 기준으로 한 좌표계

> View Space / Camera Space / Eye Space

### 정의

- 카메라(또는 관찰자)에서 본 Scene의 위치와 방향을 나타내는 공간 / 좌표계

- 카메라를 World Space에서 이동시키는 것 X, 오히려 Object들이 반대로 움직이는 것처럼 변환
- World Space에서 View Space으로 변환 -> **View Matrix** 사용

$$
V = T \times R
$$

- OpenGL 이나 Metal에선 카메라가 항상 `(0,0,0)` 방향을 바라봄
  <br/>

### View Matrix

> World Space 에 있는 Object들을 View Space(View Space, Camera Space) 로 변환하는 과정

- 카메라(시점)를 `(0,0,0)` 으로 이동하고, 바라보는 방향을 `-Z` 축으로 맞추는 변환 행렬

  - $R_{right}$ : 카메라의 오른쪽(`X`)
  - $R_{up}$ : 위쪽(`Y`)
  - $R_{forward}$ : 바라보는 방향(`-Z`)

$$
V =
\begin{bmatrix}
R*{right} & R*{up} & R\_{forward} & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
\begin{bmatrix}
1 & 0 & 0 & -P_x \\
0 & 1 & 0 & -P_y \\
0 & 0 & 1 & -P_z \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

- 주로 `lookAt` 메서드로 구현

  ```cpp
  // C++(OpenGL)
  glm::mat4 lookAt(glm::vec3 cameraPos, glm::vec3 target, glm::vec3 up) {
      glm::vec3 forward = glm::normalize(cameraPos - target); // -Z 축 (카메라가 보는 방향)
      glm::vec3 right   =
      glm::normalize(glm::cross(up, forward)); // X 축 (오른쪽 벡터)
      glm::vec3 upVec   = glm::cross(forward, right); // Y 축 (업 벡터)

      // 회전 행렬
      glm::mat4 rotation = glm::mat4(
       glm::vec4(right, 0.0),
       glm::vec4(upVec, 0.0),
       glm::vec4(forward, 0.0),
       glm::vec4(0.0, 0.0, 0.0, 1.0)
     );

     // 이동 행렬 (카메라를 원점으로 이동)
     glm::mat4 translation = glm::translate(glm::mat4(1.0), -cameraPos);

     return rotation * translation;
  }
  ```

  ```swift
  // Swift(Metal)
  func lookAt(eyePosition: simd_float3, targetPosition: simd_float3, upVec: simd_float3) -> simd_float4x4 {
      let forward = normalize(targetPosition - eyePosition)
      let rightVec = normalize(simd_cross(upVec, forward))
      let up = simd_cross(forward, rightVec)

      var matrix = matrix_identity_float4x4
          matrix[0][0] = rightVec.x
          matrix[1][0] = rightVec.y
          matrix[2][0] = rightVec.z
          matrix[0][1] = up.x
          matrix[1][1] = up.y
          matrix[2][1] = up.z
          matrix[0][2] = forward.x
          matrix[1][2] = forward.y
          matrix[2][2] = forward.z
          matrix[3][0] = -dot(rightVec, eyePosition)
          matrix[3][1] = -dot(up, eyePosition)
          matrix[3][2] = -dot(forward, eyePosition)

    return matrix
  } // lookAt
  ```

  <br/>

### ViewModel Matrix

> Model Matrix과 View Matrix를 결합한 행렬

> Model(Local) Space를 View Space으로 변환하는 행렬

$$
ViewModel Matrix = View Matrix \times Model Matrix
$$

- 각 Object의 로컬 좌표를 뷰 좌표계로 변환할 때 매번 두 행렬을 곱하는 대신, 하나로 합쳐서 최적화하는 것

  - _Model Matrix_ : _로컬 좌표계를 월드 좌표계로 변환_
  - _View Matrix_ : _월드 좌표계를 뷰(카메라) 좌표계로 변환_
  - **ViewModel Matrix** : **로컬 좌표계를 뷰 좌표계로 한 번에 변환**
    <br/>

## 클립 좌표계 (Clip Space)

> 투영(projection) 변환 후의 좌표계

> 카메라의 visible(가시)영역 내에서 좌표를 표현

> 렌더링 파이프라인에서, 카메라 시점에서 보이는 영역 밖에 있는 정점들을 제거하기 위해 사용

1. **투영 변환(Projection)**
2. **Clipping**

### 정의

> View Space에서 투영 행렬(Projection Matrix)을 곱한 후의 좌표 공간

$$
p_{Clip} = P ⋅ p_{View}
$$

- 3D 좌표를 2D 화면에 투영하기 위한 단계

- 이 공간에서 좌표는 Normalized되지 않은 형태, (`x`, `y` , `z`, `w`의 4차원 동차 좌표)

- 이후 Viewport Transform을 통해 최종 화면에 출력 됨

- View Space에서 Clip Space으로 변환은 **투영 행렬(Projection Matrix)** 이용
  <br/>

### 투영 행렬(Projection Matrix)

> 3D 좌표를 Perspective Projection(원근 투영) 또는 Orthographic Projection(직교 투영)을 이용해 변환하는 Clip Space으로 역할

<br/>

$$
\begin{bmatrix}
x_{clip} \\ y_{clip} \\ z_{clip} \\ w_{clip}
\end{bmatrix} = P ⋅ \begin{bmatrix}
x_{view} \\ y_{view} \\ z_{view} \\ 1
\end{bmatrix}
$$

<br/>

1. **직교 투영(Orthographic Projection)**
   <p align="center">
    <img src="https://learnopengl.com/img/getting-started/orthographic_frustum.png">

   </p>

   - 평행한 광선을 유지하며 객체를 투영하는 방식
   - 단순히 공간을 정규화하는 역할

   $$
   P_{ortho} = \begin{bmatrix}
   \frac{2}{r-l} && 0 && 0 && -\frac{r+l}{r-l} \\ 0 && \frac{2}{t-b} && 0 && -\frac{t+b}{t-b} \\ 0 && 0 && -\frac{2}{f-n} && -\frac{f+b}{f-b} \\ 0 && 0 && 0 && 1
   \end{bmatrix}
   $$

   `(l, r)` : _왼쪽/오른쪽 평면_ , `(b, t)` : _아래/위쪽 평면_ , `(n, f)` : _가까운/먼 평면_
   <br/>

   ```cpp
   // C++ (OpenGL)
   glm::ortho(left, right, bottom, top, near, far);
   ```

   ```swift
   // Swift (Metal)
   func ortho(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> simd_float4x4 {
      let r_l = right - left
      let t_b = top - bottom
      let f_n = far - near

      return simd_float4x4(
        (2.0 / r_l, 0, 0, -(right + left) / r_l),
        (0, 2.0 / t_b, 0, -(top + bottom) / t_b),
        (0, 0, -2.0 / f_n, -(far + near) / f_n),
        (0, 0, 0, 1)
      )
   }
   ```

   - z축 depth 값도 `[-1, 1]` 범위로 변환해서 정규화
   - 원근 효과 없음 (멀리 있는 물체도 크기가 동일)
   - 주로 UI 렌더링, CAD, 2D 게임 등에 사용
     <br/>

2. **원근 투영(Perspective Projection)**
   <p align="center">
    <img src="https://learnopengl.com/img/getting-started/perspective_frustum.png">
   </p>

   - 멀리 있는 물체는 작아지고, 가까운 물체는 커지는 원근법을 적용
   - 이를 위해 `w` 좌표에 깊이 정보를 포함하고, 나중에 `w` 로 나누어 원근감을 적용

   $$
   P_{persp} = \begin{bmatrix}
   \frac{1}{tan(\frac{fov}{2}) ⋅ aspect} && 0 && 0 && 0 \\ 0 && \frac{1}{tan(\frac{fov}{2})} && 0 && 0 \\ 0 && 0 && \frac{(f+n)}{n-f} && \frac{2fn}{n-f} \\ 0 && 0 && -1 && 0
   \end{bmatrix}
   $$

   `fov` : _시야각 (degree)_ , `aspect` : _화면 비율_ , `near` : _가까운 평면_ , `far` : _먼 평면_
   <br/>

   ```cpp
   // C++(OpenGL)
   glm::perspective(glm::radians(fov), aspect, near, far);
   ```

   ```swift
   // Swift (Metal)
   func perspective(fov: Float, aspectRatio: Float, nearPlane: Float, farPlane: Float) -> simd_float4x4 {
        let tanHalfFov = tan(fov / 2.0)

        var matrix = simd_float4x4(0.0)
        matrix[0][0] = 1.0 / (aspectRatio * tanHalfFov)
        matrix[1][1] = 1.0 / (tanHalfFov)
        matrix[2][2] = farPlane / (farPlane - nearPlane)
        matrix[2][3] = 1.0
        matrix[3][2] = -(farPlane * nearPlane) / (farPlane - nearPlane)

        return matrix
    } // perspective
   ```

   - Perspective Projection을 적용하면 `z`축에 따라 원근감이 적용
   - 원근 감이 적용됨 (멀리 있는 물체가 작아짐)
   - 일반적인 3D 게임, 그래픽스에서 사용됨
     <br/>

### 클리핑(Clipping) 과정

> GPU가 클립 공간 좌표를 이용해 뷰 프러스텀(View Frustum) 내부에 있는지 확인하는 과정

- 클립 공간에서는 좌표가 원근 투영을 포함한 4차원 형태를 가짐

- GPU는 이 공간에서 클리핑(Clipping) 연산을 수행해서 보이는 영역만 남긴 후, NDC로 변환하게 되는 것
  |축 |범위 |
  |:---:|:---:|
  |$x_{clip}$| $[-w, w]$ |
  |$y_{clip}$| $[-w, w]$ |
  |$z_{clip}$| $[-w, w]$ |
  |$w_{clip}$| $[-w, w]$ (OpenGL) 또는 $[0,w] $(Metal/Vulkan/Direct3D)|

- 만약 위 조건을 벗어나는 점들은 잘려(Clipping) 사라지거나, 보간(interpolation) 처리
  <br/>

## NDC

> 화면에 출력되기 전에 -1 ~ 1 범위로 정규화된 좌표

- Clip Space에서 얻은 좌표는 GPU에서 자동으로 w로 나누어 NDC로 변환 (`w` 좌표로 나누는 과정)

  $$
  x_{ndc} = \frac{x_{clip}}{w_{clip}} , y_{ndc} = \frac{y_{clip}}{w_{clip}} , z_{ndc} = \frac{z_{clip}}{w_{clip}}
  $$

- 적용한 후, Viewport으로 변환하는 준비가 완료

- [Noramlize Device Coordinate 관련 md 링크](https://github.com/BOLTB0X/Metal-API/blob/main/OpenGL-Tutorial-Metal/StudyMd/NDC.md)
  <br/>

## Screen Space

> 픽셀 단위의 화면 좌표계

- 정규화된 좌표를 실제 화면 크기(해상도)에 맞게 변환

- 픽셀 단위 (`(0,0)` 이 화면의 왼쪽 아래)

- GPU가 래스터화(Rasterization)하여 최종적으로 픽셀을 결정

## 참고 및 이미지

- [OpenGL Tutorial - Coordinate Systems](https://learnopengl.com/Getting-started/Coordinate-Systems)

- [Tistory ally10 - Metal 스터디 (4) - MSL](https://ally10.tistory.com/56)
