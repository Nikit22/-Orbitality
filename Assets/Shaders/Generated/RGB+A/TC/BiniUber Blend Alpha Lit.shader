
Shader "BiniUber/RGB+A/TC/Blend: Alpha Lit" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		[NoScaleOffset] _MainTex_Alpha ("Main Texture (Alpha)", 2D) = "white" {}
		
		_LightInfluence ("Light Influence", float) = 1.0
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		//Tags { "LightMode"="ForwardAdd" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha, One One
			BlendOp Add
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			#define USE_SEPARATE_ALPHA 1
			#define USE_CONSTANT_COLOR 1
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			float _LightInfluence;
			float4 _LightPosSize;
			float4 _LightColor;
			
			struct appdata {
				DEFAULT_VERTEX_INPUT
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
				float4 abs_pos : TEXCOORD1;
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				o.abs_pos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				float2 delta = i.abs_pos.xy - _LightPosSize.xy;
				float a = exp(-dot(delta, delta) * _LightPosSize.w);
				fixed4 lc = fixed4(_LightColor.rgb * a * _LightColor.a * _LightInfluence, 0);
				return TINT(TEX_RGBA(_MainTex, i.texcoord0)) + lc;
			}
			ENDCG
		}
	}
}
