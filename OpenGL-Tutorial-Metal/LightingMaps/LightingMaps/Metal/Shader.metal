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
                               constant TransformUniforms& transformUniforms [[buffer(1)]],
                               constant float3x3& normalMatrix [[buffer(2)]]) {
    VertexOut out;
    
    float3 worldPosition = (transformUniforms.modelMatrix * float4(vertices[vid].position, 1.0)).xyz;
    
    out.position = transformUniforms.projectionMatrix * transformUniforms.viewMatrix * float4(worldPosition, 1.0);
    out.normal = normalize(normalMatrix * vertices[vid].normal);
    out.texCoord = vertices[vid].texCoord;
    out.fragPosition = worldPosition;
    
    return out;
} // vertex_shader

// MARK: - fragment_shader_main
fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                     texture2d<float> diffTex [[texture(0)]],
                                     texture2d<float> specTex [[texture(1)]],
                                     sampler sam [[sampler(0)]],
                                     constant LightUniforms& lightUniform [[buffer(1)]],
                                     constant TransformUniforms& transformUniforms [[buffer(2)]]) {
    
    float3 diffuseTextureColor = diffTex.sample(sam, in.texCoord).rgb;
    float3 specularTextureColor = specTex.sample(sam, in.texCoord).rgb;
    
    float3 lightDir = normalize(lightUniform.lightPosition - in.fragPosition);
    
    float3 ambient = lightUniform.ambient * diffuseTextureColor;
    
    float diff = max(dot(in.normal, lightDir), 0.0);
    float3 diffuse = lightUniform.diffuse * diff * diffuseTextureColor;
    
    float3 viewDir = normalize(lightUniform.cameraPosition - in.fragPosition);
    float3 reflectDir = reflect(-lightDir, in.normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 64.0);
    float3 specular = lightUniform.specular * spec * specularTextureColor;
    
    float3 lighting = ambient + diffuse + specular;
    return float4(lighting, 1.0);
} // fragment_shader_main

// MARK: - fragment_shader_sub
fragment float4 fragment_shader_sub(VertexOut in [[stage_in]],
                                    constant float3& lightColor [[buffer(1)]]) {
    return float4(lightColor, 1.0);
} // fragment_shader_sub
