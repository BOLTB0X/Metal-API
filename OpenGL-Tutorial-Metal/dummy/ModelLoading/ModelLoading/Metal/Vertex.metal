//
//  Vertex.metal
//  ModelLoading
//
//  Created by KyungHeon Lee on 2025/02/19.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - VertexIn
struct VertexIn {
    float3 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
    float2 texCoord [[attribute(2)]];
}; // VertexIn

// MARK: - VertexOut
struct VertexOut {
    float4 position [[position]];
    float3 worldPosition;
    float3 normal;
    float2 texCoord;
}; // VertexOut
