//
//  Vertex.metal
//  Lighting
//
//  Created by KyungHeon Lee on 2025/01/26.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - VertexIn
struct VertexIn {
    float3 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
}; // VertexIn

// MARK: - VertexOut
struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float3 fragPosition;
}; // VertexOut
