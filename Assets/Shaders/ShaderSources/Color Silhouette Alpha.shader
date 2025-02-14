﻿Shader "BiniUberTemplate/Color: Silhouette Alpha" {
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
				return fixed4(_TINT_RGB, _TINT_A * TEX_ALPHA(_MainTex, i.texcoord0));
			}
			ENDCG
		}
	}
}
