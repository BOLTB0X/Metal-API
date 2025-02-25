//
//  Vertex.metal
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - VertexIn
struct VertexIn {
    float3 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
    float3 normal [[attribute(2)]];
    float4 tangent [[attribute(3)]];
}; // VertexIn

// MARK: - VertexOut
struct VertexOut {
    float4 position [[position]];
    float3 worldPosition;
    float2 texCoord;
    float3 normal;
    float3 T;
    float3 B;
    float3 N;
}; // VertexOut
