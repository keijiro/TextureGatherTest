Shader "Hidden/GatherTest"
{
    Properties
    {
        _MainTex("", 2D) = "white" {}
    }
    SubShader
    {
        ZWrite Off ZTest Always
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_setup
            #define FRAG_SETUP
            #include "GatherTest.cginc"
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert_img
            #pragma fragment frag_gather
            #define FRAG_GATHER
            #include "GatherTest.cginc"
            ENDCG
        }
    }
}
