Shader "Our Game/Landscape Mat"
{
	Properties
    {
        _FlatTex ("Flat Tex", 2D) = "white" {}
        _SlopeTex ("Slope Tex", 2D) = "white" {}

        _FlatGlossiness ("Flat Tex Smoothness", Range(0, 1)) = 0.5
        _SlopeGlossiness ("Slope Tex Smoothness", Range(0, 1)) = 0.5
        
        _FlatMetallic ("Flat Tex Metallic", Range(0, 1)) = 0.5
        _SlopeMetallic ("Slope Tex Metallic", Range(0, 1)) = 0.5
	}
	SubShader
    {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
        
		struct Input
        {
            float2 uv_FlatTex;
            float2 uv_SlopeTex;
            float3 worldNormal;
		};

        sampler2D _FlatTex, _SlopeTex;
        float _FlatGlossiness, _SlopeGlossiness,
              _FlatMetallic, _SlopeMetallic;

		void surf(Input IN, inout SurfaceOutputStandard o)
        {
            //Interpolate from sloped to flat textures.
            float t = abs(IN.worldNormal.y);
            t = pow(t, 3.0);

            float4 col = lerp(tex2D(_SlopeTex, IN.uv_SlopeTex),
                              tex2D(_FlatTex, IN.uv_FlatTex),
                              t);
            float glossiness = lerp(_SlopeGlossiness, _FlatGlossiness, t),
                  metallic = lerp(_SlopeMetallic, _FlatMetallic, t);

            o.Albedo = col.rgb;
            o.Alpha = col.a;
            o.Smoothness = glossiness;
            o.Metallic = metallic;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
