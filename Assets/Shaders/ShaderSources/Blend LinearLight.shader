Shader "BiniUberTemplate/Blend: LinearLight" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		//UBER# RGBA
		//_MainTex ("Main Texture (RGBA)", 2D) = "white" {}
		//UBER# RGB+A
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		[NoScaleOffset] _MainTex_Alpha ("Main Texture (Alpha)", 2D) = "white" {}
		//UBER#
	}
	
	// linear_light = lerp(burn, dodge, src)
	
	// linear_burn = dst + src - 1 = dst - (1 - src)
	// linear_dodge = dst + src
	
	// linear_light = (dst + src - 1) + src*(dst + src - (dst + src - 1))
	// = dst + src - 1 + src
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		// Same as Burn
		Pass {
			Blend One One
			BlendOp RevSub
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			//UBER# RGB+A
			#define USE_SEPARATE_ALPHA 1
			//UBER# TV | TVC
			#define USE_VERTEX_COLOR 1
			//UBER# TC | TVC
			#define USE_CONSTANT_COLOR 1
			//UBER#
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			struct appdata {
				DEFAULT_VERTEX_INPUT
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				fixed4 final = TINT(TEX_RGBA(_MainTex, i.texcoord0));
				return fixed4((1 - final.rgb) * final.a, final.a);
			}
			ENDCG
		}
		
		// Same as Add
		Pass {
			Blend SrcAlpha One
			BlendOp Add
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			//UBER# RGB+A
			#define USE_SEPARATE_ALPHA 1
			//UBER# TV | TVC
			#define USE_VERTEX_COLOR 1
			//UBER# TC | TVC
			#define USE_CONSTANT_COLOR 1
			//UBER#
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			struct appdata {
				DEFAULT_VERTEX_INPUT
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				return TINT(TEX_RGBA(_MainTex, i.texcoord0));
			}
			ENDCG
		}
	}
}
