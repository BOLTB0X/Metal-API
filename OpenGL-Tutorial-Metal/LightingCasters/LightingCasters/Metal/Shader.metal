//
//  Shader.metal
//  LightingCasters
//
//  Created by KyungHeon Lee on 2025/02/15.
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

// Flashlight
// MARK: - fragment_shader_Flashlight
fragment float4 fragment_shader_Flashlight(VertexOut in [[stage_in]],
                                     texture2d<float> diffTex [[texture(0)]],
                                     texture2d<float> specTex [[texture(1)]],
                                     sampler sam [[sampler(0)]],
                                     constant TransformUniforms& transformUniforms [[buffer(1)]],
                                     constant LightUniforms& lightUniforms [[buffer(2)]],
                                     constant float3& cameraPosition [[buffer(3)]]) {
    float3 result;
    float3 diffuseTextureColor = diffTex.sample(sam, in.texCoord).rgb;
    float3 specularTextureColor = specTex.sample(sam, in.texCoord).rgb;
    
    float3 lightDir = normalize(lightUniforms.position - in.fragPosition);
    float theta = dot(lightDir, normalize(-lightUniforms.direction));
    
    float3 ambient = lightUniforms.ambient * diffuseTextureColor;
            
    if (theta > lightUniforms.cutOff.x) {
        float diff = max(dot(in.normal, lightDir), 0.0);
        float3 diffuse = lightUniforms.diffuse * diff * diffuseTextureColor;
        
        float3 viewDir = normalize(cameraPosition - in.fragPosition);
        float3 reflectDir = reflect(-lightDir, in.normal);
        float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);
        float3 specular = lightUniforms.specular * spec * specularTextureColor;
        
        float dist = length(lightUniforms.position - in.fragPosition);
        float attenuation = 1.0 / (lightUniforms.constants.x + lightUniforms.linears.x * dist + lightUniforms.quadratics.x * (dist * dist));
        
        diffuse *= attenuation;
        specular *= attenuation;
        
        result = ambient + diffuse + specular;
    }
    else {
        result = ambient;
    }
    
    return float4(result, 1.0);
} // fragment_shader_Flashlight

// spotlight
// MARK: - fragment_shader_main
fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                     texture2d<float> diffTex [[texture(0)]],
                                     texture2d<float> specTex [[texture(1)]],
                                     sampler sam [[sampler(0)]],
                                     constant TransformUniforms& transformUniforms [[buffer(1)]],
                                     constant LightUniforms& lightUniforms [[buffer(2)]],
                                     constant float3& cameraPosition [[buffer(3)]]) {
    float3 diffuseTextureColor = diffTex.sample(sam, in.texCoord).rgb;
    float3 specularTextureColor = specTex.sample(sam, in.texCoord).rgb;
    
    float3 ambient = lightUniforms.ambient * diffuseTextureColor;
    
    float3 lightDir = normalize(lightUniforms.position - in.fragPosition);
    float diff = max(dot(in.normal, lightDir), 0.0);
    float3 diffuse = lightUniforms.diffuse * diff * diffuseTextureColor;
        
    float3 viewDir = normalize(cameraPosition - in.fragPosition);
    float3 reflectDir = reflect(-lightDir, in.normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);
    float3 specular = lightUniforms.specular * spec * specularTextureColor;
        
    // spotlight
    float theta = dot(lightDir, normalize(-lightUniforms.direction));
    float epsilon = lightUniforms.cutOff.x - lightUniforms.outerCutOff.x;
    float intensity = clamp((theta - lightUniforms.outerCutOff.x) / epsilon, 0.0, 1.0);
    
    diffuse *= intensity;
    specular *= intensity;
    
    float dist = length(lightUniforms.position - in.fragPosition);
    float attenuation = 1.0 / (lightUniforms.constants.x + lightUniforms.linears.x * dist + lightUniforms.quadratics.x * (dist * dist));
        
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;
        
    return float4(ambient + diffuse + specular, 1.0);
} // fragment_shader_main

// MARK: - fragment_shader_sub
fragment float4 fragment_shader_sub(VertexOut in [[stage_in]],
                                    constant float3& lightColor [[buffer(1)]]) {
    return float4(lightColor, 1.0);
} // fragment_shader_sub

