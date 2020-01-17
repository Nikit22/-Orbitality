
Shader "BiniUber/RGB+A/TC/Compose: Mask" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		[NoScaleOffset] _MainTex_Alpha ("Main Texture (Alpha)", 2D) = "white" {}
		
		_MaskedColor ("Masked Color", Color) = (1,1,1,1)
		_MaskedTex ("Masked (RGBA)", 2D) = "black" {}
		
		_PosScale ("Pos & Scale", Vector) = (0,0,1,1)
		_Angle ("Angle", Float) = 0.0
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
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
			
			// We expect that _MaskedTex does not need separate alphamap
			DECLARE_TEX_RGBA(_MaskedTex)
			
			fixed4 _MaskedColor;
			float4 _PosScale;
			float _Angle;
			
			struct appdata {
				DEFAULT_VERTEX_INPUT
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
				float2 texcoord1 : TEXCOORD1;
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				float4 abs_pos = mul(unity_ObjectToWorld, v.vertex);
				float4 rel_pos = mul(unity_WorldToObject, abs_pos);
				float _sin, _cos;
				sincos(radians(_Angle), _sin, _cos);
				float2x2 texmat = { {_cos, _sin}, {-_sin, _cos} };
				float2 tex_xy = mul(texmat, rel_pos.xy - _PosScale.xy);
				o.texcoord1 = tex_xy / (_MaskedTex_TexelSize.zw * _PosScale.zw);
				return o;
			}
			
			const half a_min = 1.0/255.0;
			fixed4 frag(v2f i) : COLOR0 {
				fixed4 main_color = TEX_RGBA(_MainTex, i.texcoord0);
				fixed mask_a = main_color.a;
				main_color *= _TINT;
				
				fixed4 masked_color = tex2D(_MaskedTex, i.texcoord1) * _MaskedColor;
				masked_color.a *= (i.texcoord1.y >= 0) * (i.texcoord1.y < 1);
				
				fixed3 rgb;
				half a, kIN, kBKG;
				
				rgb = main_color.rgb;
				a = main_color.a;
				
				kIN = masked_color.a;
				kBKG = a * (1 - kIN);
				a = kIN + kBKG;
				rgb = (masked_color.rgb*kIN + rgb*kBKG)/max(a, a_min);
				
				return fixed4(rgb, min(a, mask_a));
			}
			ENDCG
		}
	}
}
