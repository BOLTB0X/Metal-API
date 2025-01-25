//
//  Shaders.metal
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/21.
//

#include <metal_stdlib>
#include "CommonStruct.metal"

using namespace metal;

// MARK: - vertex_shader
vertex VertexOut vertex_shader(uint vid [[vertex_id]],
                               constant VertexIn* vertices [[buffer(0)]],
                               constant float4x4& projectionMatrix [[buffer(1)]],
                               constant float4x4& modelViewMatrix [[buffer(2)]]) {
    VertexOut out;

    out.position = projectionMatrix * modelViewMatrix * float4(vertices[vid].position, 1.0);

    // 법선 벡터 변환 (모델 행렬의 상단 3x3만 사용)
    out.normal = normalize((modelViewMatrix * float4(vertices[vid].normal, 0.0)).xyz);

    return out;
} // vertex_shader

// MARK: - fragment_shader
fragment float4 fragment_shader(VertexOut in [[stage_in]],
                                constant float3 &cameraPosition [[buffer(1)]],
                                constant LightUniforms &lightUniform [[buffer(2)]]) {
    float3 lightDirection = normalize(-cameraPosition);
    float diffuse = max(dot(in.normal, lightDirection), 0.0);

    return float4(((lightUniform.ambient + diffuse) * lightUniform.lightColor) * lightUniform.objectColor , 1.0);
} // fragment_shader



