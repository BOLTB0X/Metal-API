//
//  Shadow.metal
//  ModelLoading2
//
//  Created by KyungHeon Lee on 2025/03/05.
//

#include <metal_stdlib>
using namespace metal;

constant float3 lightDirection = float3(0.436436, -0.872872, 0.218218);
constant float3 lightAmbient = float3(0.4);
constant float3 lightDiffuse = float3(1.0);
constant float3 lightSpecular = float3(0.8);

constant float SHADOW_BIAS = 0.001;
constant int SHADOW_SAMPLE_COUNT = 16;
constant float SHADOW_PENUMBRA_SIZE = 2.0;

constant float2 poissonDisk[16] = {
    float2( -0.94201624, -0.39906216 ),
    float2( 0.94558609, -0.76890725 ),
    float2( -0.094184101, -0.92938870 ),
    float2( 0.34495938, 0.29387760 ),
    float2( -0.91588581, 0.45771432 ),
    float2( -0.81544232, -0.87912464 ),
    float2( -0.38277543, 0.27676845 ),
    float2( 0.97484398, 0.75648379 ),
    float2( 0.44323325, -0.97511554 ),
    float2( 0.53742981, -0.47373420 ),
    float2( -0.26496911, -0.41893023 ),
    float2( 0.79197514, 0.19090188 ),
    float2( -0.24188840, 0.99706507 ),
    float2( -0.81409955, 0.91437590 ),
    float2( 0.19984126, 0.78641367 ),
    float2( 0.14383161, -0.14100790 )
};
