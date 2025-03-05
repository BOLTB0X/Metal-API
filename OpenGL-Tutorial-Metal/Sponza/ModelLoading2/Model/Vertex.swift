//
//  Vertex.swift
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/02/23.
//

import MetalKit

// MARK: - Vertex
struct Vertex {
    var position: simd_float3
    var texCoord: simd_float2
    var normal: simd_float3
    var tangent: simd_float4
} // Vertex

// MARK: - VertexBufferIndex
enum VertexBufferIndex: Int {
    case attributes = 30
    case viewUniform = 0
    case modelUniform = 1
} // VertexBufferIndex

// MARK: - VertexAttribute
enum VertexAttribute: Int, CaseIterable {
    case position
    case texCoord
    case normal
    case tangent
    
    // MARK: - format
    var format: MTLVertexFormat {
        switch self {
        case .position: return .float3
        case .texCoord: return .float2
        case .normal: return .float3
        case .tangent: return .float4
        }
    } // format
    
    // MARK: - offset
    var offset: Int {
        switch self {
        case .position: return MemoryLayout.offset(of: \Vertex.position)!
        case .texCoord: return MemoryLayout.offset(of: \Vertex.texCoord)!
        case .normal: return MemoryLayout.offset(of: \Vertex.normal)!
        case .tangent: return MemoryLayout.offset(of: \Vertex.tangent)!
        }
    } // offset
    
    // MARK: - name
    var name: String {
        switch self {
        case .position: return MDLVertexAttributePosition
        case .texCoord: return MDLVertexAttributeTextureCoordinate
        case .normal: return MDLVertexAttributeNormal
        case .tangent: return MDLVertexAttributeTangent
        }
    } // name
    
} // VertexAttribute
