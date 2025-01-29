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

float3x3 conversion_3x3(float4x4 m) {
    return float3x3(m[0].xyz, m[1].xyz, m[2].xyz);
}

float3x3 inverse_3x3(float3x3 m) {
    float3 row0 = m[0];
    float3 row1 = m[1];
    float3 row2 = m[2];

    float3 minor0 = cross(row1, row2);
    float3 minor1 = cross(row2, row0);
    float3 minor2 = cross(row0, row1);

    float determinant = dot(row0, minor0);
    return float3x3(minor0, minor1, minor2) / determinant;
}

// MARK: - vertex_shader
vertex VertexOut vertex_shader(uint vid [[vertex_id]],
                               constant VertexIn* vertices [[buffer(0)]],
                               constant TransformUniforms& transformUniforms [[buffer(1)]]) {
    VertexOut out;
    
    out.position = transformUniforms.projectionMatrix * transformUniforms.modelViewMatrix * float4(vertices[vid].position, 1.0);
    
    // Normal Matrix 계산
    float3x3 normalMatrix = conversion_3x3(transformUniforms.modelViewMatrix);
    normalMatrix = transpose(inverse_3x3(normalMatrix));
    
    out.normal = normalize(normalMatrix * vertices[vid].normal).xyz;
    out.fragPosition = (transformUniforms.modelMatrix * float4(vertices[vid].position, 1.0)).xyz;
    return out;
} // vertex_shader

// MARK: - fragment_shader_main
fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                     constant LightUniforms& lightUniform [[buffer(1)]],
                                     constant TransformUniforms& transformUniforms [[buffer(2)]],
                                     constant float3& ambient [[buffer(3)]]) {
    
    // 1. 프래그먼트 위치 (월드 좌표)
    float3 fragPosition = in.fragPosition;
    
    // 2. 법선 변환 (월드 좌표 기준)
    float3 norm = normalize(in.normal);
    
    // 3. 광원 방향 계산 (Point Light)
    float3 lightDir = normalize(lightUniform.lightPosition - fragPosition);
    
    // 4. Diffuse (확산광)
    float diffuseStrength = max(dot(norm, lightDir), 0.0);
    float3 diffuse = diffuseStrength * lightUniform.lightColor;
    
    // 5. Specular (반사광)
    float3 viewDir = normalize(lightUniform.cameraPosition - fragPosition);
    float3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);
    float3 specular = spec * lightUniform.lightColor;
    
    // 6. 조명 값 계산
    float3 lighting = ambient + diffuse + specular;
    return float4(lighting * lightUniform.objectColor, 1.0);
} // fragment_shader_main

// MARK: - fragment_shader_sub
fragment float4 fragment_shader_sub(VertexOut in [[stage_in]],
                                    constant float3& lightColor [[buffer(1)]]) {
    return float4(lightColor, 1.0);
} // fragment_shader_sub
