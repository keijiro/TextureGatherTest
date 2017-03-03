#include "UnityCG.cginc"

#if defined(FRAG_SETUP)

sampler2D _MainTex;
float4 _MainTex_TexelSize;

fixed4 frag_setup(v2f_img i) : SV_Target
{
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
    float2 uv = _MainTex_TexelSize.xy * float2(1, 1);
    fixed4 c = _MainTex.Gather(sampler_MainTex, uv, int2(1, 1));

    float x = i.uv.x;
    fixed h = x < 0.25 ? c.r : (x < 0.5 ? c.g : (x < 0.75 ? c.b : c.a));

    return i.uv.y < h;
}

#endif
