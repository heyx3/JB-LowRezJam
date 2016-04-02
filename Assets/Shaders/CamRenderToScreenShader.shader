Shader "Our Game/Cam Render To Screen"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Depth ("Screen Depth", Float) = 0.5
	}
	SubShader
	{
		// No culling or depth
		Cull Off
		ZWrite Off
		ZTest Off//Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				//float2 depth : TEXCOORD1;
			};

			float _Depth;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = sign(v.vertex);
				o.vertex.z = _Depth;
				o.uv = v.uv;
				//COMPUTE_EYEDEPTH(o.depth);
				return o;
			}
			
			sampler2D _MainTex;
			//sampler2D _CameraDepthTexture;


			float3 projectToLine(float3 pos, float3 pointOnLine, float3 lineDir)
			{
				float distAlongLine = dot(pos - pointOnLine, lineDir);
				return pointOnLine + (lineDir * distAlongLine);
			}
			float3 projectToPlane(float3 pos, float3 pointOnPlane, float3 planeNormal)
			{
				float3 toPos = pos - pointOnPlane;
				float distToPlane = dot(toPos, planeNormal);
				return pos - (distToPlane * planeNormal);
			}
			fixed4 toneMapper(float4 inCol)
			{
				//Think of color as a 3D position in a cube from 0 to 1.

				//This tonemapper projects every color onto a plane in that cube.
				//const float3 planePoint = float3(0.5, 0.5, 0.5),
				//			 planeNormal = normalize(float3(1.0, 2.0, 1.0));
				//return float4(projectToPlane(inCol.rgb, planePoint, planeNormal),
				//			  inCol.a);

				//This tonemapper projects every color onto a line through that cube.
				const float3 linePoint = float3(1.0, 1.0, 1.0),
							 lineDir = normalize(float3(1.0, 1.0, 1.0));
				return float4(projectToLine(inCol.rgb, linePoint, lineDir),
							  inCol.a);
			}

			fixed4 frag (v2f i) : SV_Target
			{
				//float depth = DECODE_EYEDEPTH(tex2D(_CameraDepthTexture, i.uv).r);
				//return fixed4(depth, depth, depth, 1.0);

				return (tex2D(_MainTex, i.uv));
			}
			ENDCG
		}
	}
}
