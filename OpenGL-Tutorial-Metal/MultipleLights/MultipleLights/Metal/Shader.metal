//
//  Shader.metal
//  MultipleLights
//
//  Created by KyungHeon Lee on 2025/02/18.
//

#include "Uniform.metal"
#include "Vertex.metal"

using namespace metal;

// MARK: - calcDirLight
inline float3 calcDirLight(DirLight light, float3 norm, float3 viewDir,
                           float3 diffuseTextureColor, float3 specularTextureColor) {
    float3 lightDir = normalize(-light.direction);
    float diff = max(dot(norm, lightDir), 0.0);
    
    float3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);
    
    float3 ambient = light.ambient * diffuseTextureColor;
    float3 diffuse = light.diffuse * diff * diffuseTextureColor;
    float3 specular = light.specular * spec * specularTextureColor;
    
    return (ambient + diffuse + specular);
} // CalcDirLight

// MARK: - calcPointLight
inline float3 calcPointLight(PointLight light, float3 norm, float3 fragPos, float3 viewDir,
                             float3 diffuseTextureColor, float3 specularTextureColor) {
    float3 lightDir = normalize(light.position - fragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    
    float3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);

    float dist = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constants.x + light.linears.x * dist + light.quadratics.x * (dist * dist));

    float3 ambient = light.ambient * diffuseTextureColor;
    float3 diffuse = light.diffuse * diff * diffuseTextureColor;
    float3 specular = light.specular * spec * specularTextureColor;
    
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;
    
    return (ambient + diffuse + specular);
} // calcPointLight

// MARK: - calcSpotLight
inline float3 calcSpotLight(SpotLight light, float3 norm, float3 fragPos, float3 viewDir,
                            float3 diffuseTextureColor, float3 specularTextureColor) {
    float3 lightDir = normalize(light.position - fragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    
    float3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);
    
    float dist = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constants.x + light.linears.x * dist + light.quadratics.x * (dist * dist));
    
    float theta = dot(lightDir, normalize(-light.direction));
    float epsilon = light.cutOff.x - light.outerCutOff.x;
    float intensity = clamp((theta - light.outerCutOff.x) / epsilon, 0.0, 1.0);
    
    float3 ambient = light.ambient * diffuseTextureColor;
    float3 diffuse = light.diffuse * diff * diffuseTextureColor;
    float3 specular = light.specular * spec * specularTextureColor;
    
    ambient *= (attenuation * intensity);
    diffuse *= (attenuation * intensity);
    specular *= (attenuation * intensity);
    
    return (ambient + diffuse + specular);
} // calcSpotLight

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

// spotlight
// MARK: - fragment_shader_main
fragment float4 fragment_shader_main(VertexOut in [[stage_in]],
                                     texture2d<float> diffTex [[texture(0)]],
                                     texture2d<float> specTex [[texture(1)]],
                                     sampler sam [[sampler(0)]],
                                     constant TransformUniforms& transformUniforms [[buffer(1)]],
                                     constant SpotLight& spotLight [[buffer(2)]],
                                     constant DirLight& dirLight [[buffer(3)]],
                                     constant PointLights& pointLights [[buffer(4)]],
                                     constant float3& cameraPosition [[buffer(5)]]) {
    float3 diffuseTextureColor = diffTex.sample(sam, in.texCoord).rgb;
    float3 specularTextureColor = specTex.sample(sam, in.texCoord).rgb;
    
    float3 viewDir = normalize(cameraPosition - in.fragPosition);
    
    float3 result = calcDirLight(dirLight, in.normal, viewDir, diffuseTextureColor, specularTextureColor);
    
    for (uint32_t i = 0; i < 4; ++i) {
        result += calcPointLight(pointLights.pointLightArr[i], in.normal, in.fragPosition, viewDir, diffuseTextureColor, specularTextureColor);
    }
    
    result += calcSpotLight(spotLight, in.normal, in.fragPosition, viewDir, diffuseTextureColor, specularTextureColor);
        
    return float4(result, 1.0);
} // fragment_shader_main

// MARK: - fragment_shader_sub
fragment float4 fragment_shader_sub(VertexOut in [[stage_in]],
                                    constant float3& lightColor [[buffer(1)]]) {
    return float4(lightColor, 1.0);
} // fragment_shader_sub
