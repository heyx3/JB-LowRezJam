Shader "Our Game/Cam Render To Screen"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Depth ("Screen Depth", Float) = 0.5

        _DistanceToEnemy ("Distance to Enemy (lerp)", Float) = 1.0
        _EnemyOverlay ("Enemy Overlay", 2D) = "white" {}
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
			};

			float _Depth;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = sign(v.vertex);
				o.vertex.z = _Depth;
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex, _EnemyOverlay;
            float _DistanceToEnemy;


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
			fixed3 toneMapper(float3 inCol)
			{
				//Think of color as a 3D position in a cube from 0 to 1.

				//This tonemapper projects every color onto a plane in that cube.
				//const float3 planePoint = float3(0.5, 0.5, 0.5),
				//			 planeNormal = normalize(float3(1.0, 2.0, 1.0));
				//return projectToPlane(inCol.rgb, planePoint, planeNormal);

				//This tonemapper projects every color onto a line through that cube.
				//const float3 linePoint = float3(0.0, 0.0, 0.0),
				//			 lineDir = normalize(float3(1.0, 1.0, 1.0));
				//return projectToLine(inCol.rgb, linePoint, lineDir);

                //This tonemapper just ups the contrast in the scene.
                return smoothstep(0.0, 1.0, inCol);
			}

			fixed4 frag (v2f i) : SV_Target
			{
                float4 gameRender = tex2D(_MainTex, i.uv),
                       enemyTex = tex2D(_EnemyOverlay, i.uv);
                float a = smoothstep(0.0, 1.0,
                                     smoothstep(0.0, 1.0, enemyTex.a * (1.0 - _DistanceToEnemy)));

                float3 outCol = lerp(gameRender, enemyTex, a);
                return fixed4(toneMapper(outCol), 1.0);
			}
			ENDCG
		}
	}
}
