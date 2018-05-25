// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Sdf"
{
	Properties
	{
		_Center("Center", Vector) = (0.5, 0.5, 0.5, 0.5)
		_Radius("Radius", Range(0.0, 5.0)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;        // Clip space 
				float3 wPos : TEXCOORD1;        // World position  
			};
			
			float3 _Center;
			float _Radius;
			bool sphereHit(float3 p)
			{
				return distance(p, _Center.xyz) < _Radius;
			}
#define STEPS 64
#define STEP_SIZE 0.01

			fixed4 raymarch(float3 position, float3 direction)
			{
				for (int i = 0; i < STEPS; i++)
				{
					if (sphereHit(position))
						return fixed4(1, 0, 0, 1); // Red

					position += direction * STEP_SIZE;
				}

				return fixed4(0, 0, 0, 1); // White 
			}
			// Vertex function
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}

			// Fragment function
			fixed4 frag(v2f i) : SV_Target
			{
				float3 worldPosition = i.wPos;
				float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
				return raymarch(worldPosition, viewDirection);
			}

			ENDCG
		}
	}
}
