//
//  Shaders.metal
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/21.
//

#include <metal_stdlib>
#include "Uniform.metal"
#include "Vertex.metal"

using namespace metal;

// MARK: - vertex_shader
vertex VertexOut vertex_shader(uint vid [[vertex_id]],
                               constant VertexIn* vertices [[buffer(0)]],
                               constant TransformUniforms& transformUniforms [[buffer(1)]]) {
    VertexOut out;

    //out.fragPosition = (modelViewMatrix * float4(vertices[vid].position, 1.0)).xyz;
    
    out.position = transformUniforms.projectionMatrix * transformUniforms.modelViewMatrix * float4(vertices[vid].position, 1.0);

    // 법선 벡터 변환 (모델 행렬의 상단 3x3만 사용)
    out.normal = normalize((transformUniforms.modelViewMatrix * float4(vertices[vid].normal, 0.0)).xyz);

    return out;
} // vertex_shader

// MARK: - fragment_shader
fragment float4 fragment_shader(VertexOut in [[stage_in]],
                                constant LightUniforms& lightUniform [[buffer(1)]],
                                constant TransformUniforms& transformUniforms [[buffer(2)]],
                                constant float3& ambient [[buffer(3)]]) {
    
    float3 fragPosition = (transformUniforms.modelViewMatrix * in.position).xyz;
    
    // Diffuse
    float3 norm = normalize(in.normal);
    float3 lightDir = normalize(lightUniform.lightPosition - fragPosition);
    float diffuseStrength = max(dot(norm, lightDir), 0.0);
    float3 diffuse = diffuseStrength * lightUniform.lightColor;
    
    // Specular
    float3 viewDir = normalize(lightUniform.cameraPosition - fragPosition);
    float3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);
    float3 specular = spec * lightUniform.lightColor;
    
    return float4(((ambient + diffuse + specular) * lightUniform.lightColor) * lightUniform.objectColor, 1.0);
} // fragment_shader



