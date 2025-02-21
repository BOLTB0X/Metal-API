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
    float2 texCoord [[attribute(1)]];
}; // VertexIn

// MARK: - VertexOut
struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
}; // VertexOut
