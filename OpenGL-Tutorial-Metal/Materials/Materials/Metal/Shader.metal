//
//  Shader.metal
//  Materials
//
//  Created by KyungHeon Lee on 2025/02/04.
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
        
    out.position = transformUniforms.projectionMatrix * transformUniforms.modelViewMatrix * float4(vertices[vid].position, 1.0);

    out.normal = normalize(transformUniforms.normalMatrix * vertices[vid].normal).xyz;
    out.fragPosition = (transformUniforms.modelMatrix * float4(vertices[vid].position, 1.0)).xyz;
    
    return out;
} // vertex_shader

// MARK: - fragment_shader_main
fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                     constant LightUniforms& lightUniform [[buffer(1)]],
                                     constant TransformUniforms& transformUniforms [[buffer(2)]],
                                     constant MaterialUniforms& materialUniforms [[buffer(3)]]) {
    float3 ambient = lightUniform.ambient * materialUniforms.ambient;
    
    float3 lightDir = normalize(in.fragPosition - lightUniform.lightPosition);
    float diffuseStrength = max(dot(normalize(in.normal), lightDir), 0.0);
    float3 diffuse = lightUniform.diffuse * (diffuseStrength * materialUniforms.diffuse);
    
    float3 viewDir = normalize(in.fragPosition - lightUniform.cameraPosition);
    float3 reflectDir = reflect(lightDir, in.normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 16.0);
    float3 specular = (spec * materialUniforms.specular) * lightUniform.specular;
    
    float3 lighting = ambient + diffuse + specular;
    return float4(lighting, 1.0);
} // fragment_shader_main

// MARK: - fragment_shader_sub
fragment float4 fragment_shader_sub(VertexOut in [[stage_in]],
                                    constant float3& lightColor [[buffer(1)]]) {
    return float4(lightColor, 1.0);
} // fragment_shader_sub
