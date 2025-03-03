#ifndef RTXDI_MINIMAL_RTXDI_PARAMETERS
#define RTXDI_MINIMAL_RTXDI_PARAMETERS

#include "RtxdiTypes.hlsl"

#define RTXDI_REGIR_DISABLED 0
#define RTXDI_REGIR_GRID 1
#define RTXDI_REGIR_ONION 2

#ifndef RTXDI_REGIR_MODE
#define RTXDI_REGIR_MODE RTXDI_REGIR_DISABLED
#endif 

// Flag that is used in the RIS buffer to identify that a light is 
// stored in a compact form.
#define RTXDI_LIGHT_COMPACT_BIT 0x80000000u

// Light index mask for the RIS buffer.
#define RTXDI_LIGHT_INDEX_MASK 0x7fffffff

// Reservoirs are stored in a structured buffer in a block-linear layout.
// This constant defines the size of that block, measured in pixels.
#define RTXDI_RESERVOIR_BLOCK_SIZE 16

// Bias correction modes for temporal and spatial resampling:
// Use (1/M) normalization, which is very biased but also very fast.
#define RTXDI_BIAS_CORRECTION_OFF 0
// Use MIS-like normalization but assume that every sample is visible.
#define RTXDI_BIAS_CORRECTION_BASIC 1
// Use pairwise MIS normalization (assuming every sample is visible).  Better perf & specular quality
#define RTXDI_BIAS_CORRECTION_PAIRWISE 2
// Use MIS-like normalization with visibility rays. Unbiased.
#define RTXDI_BIAS_CORRECTION_RAY_TRACED 3

// Select local lights with equal probability from the light buffer during initial sampling
#define ReSTIRDI_LocalLightSamplingMode_UNIFORM 0
// Use power based RIS to select local lights during initial sampling
#define ReSTIRDI_LocalLightSamplingMode_POWER_RIS 1
// Use ReGIR based RIS to select local lights during initial sampling.
#define ReSTIRDI_LocalLightSamplingMode_REGIR_RIS 2

#define RTXDI_INVALID_LIGHT_INDEX (0xffffffffu)

static const uint RTXDI_InvalidLightIndex = RTXDI_INVALID_LIGHT_INDEX;

// Minimal Sample中暂时不用这两个
/*#include "ReGIRParameters.h"
#include "RISBufferSegmentParameters.h"*/

#define ReSTIRDI_LocalLightSamplingMode uint32_t
#define ReSTIRDI_TemporalBiasCorrectionMode uint32_t
#define ReSTIRDI_SpatialBiasCorrectionMode uint32_t

struct RTXDI_LightBufferRegion
{
    uint32_t firstLightIndex;
    uint32_t numLights;
    uint32_t pad1;
    uint32_t pad2;
};

struct RTXDI_EnvironmentLightBufferParameters
{
    uint32_t lightPresent;
    uint32_t lightIndex;
    uint32_t pad1;
    uint32_t pad2;
};

struct RTXDI_RuntimeParameters
{
    uint32_t neighborOffsetMask; // Spatial
    uint32_t activeCheckerboardField; // 0 - no checkerboard, 1 - odd pixels, 2 - even pixels
    uint32_t pad1;
    uint32_t pad2;
};

struct RTXDI_LightBufferParameters
{
    RTXDI_LightBufferRegion localLightBufferRegion;
    RTXDI_LightBufferRegion infiniteLightBufferRegion;
    RTXDI_EnvironmentLightBufferParameters environmentLightParams;
};

struct RTXDI_ReservoirBufferParameters
{
    uint32_t reservoirBlockRowPitch;
    uint32_t reservoirArrayPitch;
    uint32_t pad1;
    uint32_t pad2;
};

struct RTXDI_PackedDIReservoir
{
    uint32_t lightData;
    uint32_t uvData;
    uint32_t mVisibility;
    uint32_t distanceAge;
    float targetPdf;
    float weight;
};

#endif