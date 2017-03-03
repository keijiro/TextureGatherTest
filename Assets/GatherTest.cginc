#include "UnityCG.cginc"

#if defined(FRAG_SETUP)

sampler2D _MainTex;
float4 _MainTex_TexelSize;

fixed4 frag_setup(v2f_img i) : SV_Target
{
    // Generates 4x4 matrix pattern
    // +---+---+---+---+
    // | 0 |1/4|1/2|3/4|
    // +---+---+---+---+
    // |1/4|1/2|3/4| 0 |
    // +---+---+---+---+
    // |1/2|3/4| 0 |1/4|
    // +---+---+---+---+
    // |3/4| 0 |1/4|1/2|
    // +---+---+---+---+

    float2 coord = i.uv.xy * _MainTex_TexelSize.zw - 0.5;
    fixed c = frac(floor(dot(coord, 1) + 0.001) * 0.25);

    return fixed4(c, c, c, 1);
}

#endif

#if defined(FRAG_GATHER)

Texture2D _MainTex;
float4 _MainTex_TexelSize;
SamplerState sampler_MainTex;

fixed4 frag_gather(v2f_img i) : SV_Target
{
    float2 uv = _MainTex_TexelSize.xy * float2(0.99, 0.99);

    //
    // The gather instruction collects texels around the sampling point
    // and pack them into a 4-component vector in the following order.
    //
    // (0,0)   (1,0)
    //     +-+-+
    //     |A|B|
    //     +-+-+
    //     |R|G|
    //     +-+-+
    // (0,1)   (1,1)
    //

    fixed4 c = _MainTex.GatherRed(
        sampler_MainTex, uv,
        int2(1, 0), int2(0, 0), int2(0, 1), int2(1, 1)
    );

    // ^^ This must become (0.5, 0.5, 0.5, 0.5).

    float x = i.uv.x;
    fixed h = x < 0.25 ? c.r : (x < 0.5 ? c.g : (x < 0.75 ? c.b : c.a));

    return i.uv.y < h;
}

#endif
