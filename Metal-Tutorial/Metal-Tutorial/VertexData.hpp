//
//  VertexData.hpp
//  Metal-Tutorial
//
//  Created by KyungHeon Lee on 2024/05/02.
//

#pragma once
#include <simd/simd.h>

using namespace simd;

struct VertexData {
    float4 position;
    float2 textureCoordinate;
};

struct TransformationData {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 perspectiveMatrix;
};
