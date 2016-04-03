Shader "Our Game/Enemy"
{
	Properties
	{
        _NoiseTex ("Noise", 2D) = "white" {}
        _Color ("Color", Color) = (0.0, 0.0, 0.0, 0.0)
        _OscSpeed ("Oscillate Speed", Float) = 4.0
        _TexStrength ("Noise Strength", Float) = 5.0
        _OscStrength ("Oscillate Strength", Float) = 0.1
        _OscVertical ("Oscillate Vertical Scale", Float) = 0.1
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM

            #pragma target 3.0
            #pragma glsl

			#pragma vertex vert
			#pragma fragment frag

			// make fog work
			#pragma multi_compile_fog
			

			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float3 uv : TEXCOORD1;
				UNITY_FOG_COORDS(2)
			};

            float4 _Color;
            sampler2D _NoiseTex;
            float _OscSpeed, _TexStrength, _OscStrength, _OscVertical;

			
			v2f vert (appdata v)
			{
				v2f o;

                o.normal = v.normal;
                o.uv = v.uv;

                float n = tex2Dlod(_NoiseTex, v.uv).r;
                float3 delta = v.normal * _OscStrength * sin(_OscSpeed * _Time.y + (n * _TexStrength));
                delta.y *= _OscVertical;
                v.vertex += float4(delta, 1.0);

				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			
			fixed4 frag (v2f i) : SV_Target
			{
                fixed4 col = _Color * tex2D(_NoiseTex, i.uv);

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
