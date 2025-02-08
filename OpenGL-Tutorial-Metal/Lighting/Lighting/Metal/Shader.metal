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
                               constant TransformUniforms& transformUniforms [[buffer(1)]],
                               constant float3x3& normalMatrix [[buffer(2)]]) {
    VertexOut out;
    
    float3 worldPosition = (transformUniforms.modelMatrix * float4(vertices[vid].position, 1.0)).xyz;
    out.position = transformUniforms.projectionMatrix * transformUniforms.viewMatrix * float4(worldPosition, 1.0);
    out.normal = normalize(normalMatrix * vertices[vid].normal);
    out.fragPosition = worldPosition;
    return out;
} // vertex_shader

// MARK: - fragment_shader_main
fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                     constant LightUniforms& lightUniform [[buffer(1)]],
                                     constant TransformUniforms& transformUniforms [[buffer(2)]],
                                     constant float3& ambient [[buffer(3)]]) {
    float3 worldLightPosition = (float4(lightUniform.lightPosition, 1.0) * transformUniforms.modelMatrix).xyz;

    // 1. 광원 방향 (Point Light)
    float3 lightDir = normalize(in.fragPosition - worldLightPosition);
    
    // 2. Diffuse
    float diffuseStrength = max(dot(in.normal, -lightDir), 0.0);
    float3 diffuse = diffuseStrength * lightUniform.lightColor;
    
    // 3. Specular
    float3 viewDir = normalize(in.fragPosition - lightUniform.cameraPosition);
    float3 reflectDir = reflect(lightDir, in.normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 128);
    float3 specular = spec * lightUniform.lightColor;
    
    // 4. 조명 값
    float3 lighting = ambient + diffuse + specular;
    return float4(lighting * lightUniform.objectColor, 1.0);
} // fragment_shader_main

// MARK: - fragment_shader_sub
fragment float4 fragment_shader_sub(VertexOut in [[stage_in]],
                                    constant float3& lightColor [[buffer(1)]]) {
    return float4(lightColor, 1.0);
} // fragment_shader_sub
