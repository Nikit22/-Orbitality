Shader "BiniUber/RGB+A/TC/Blend: HardLight" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		[NoScaleOffset] _MainTex_Alpha ("Main Texture (Alpha)", 2D) = "white" {}
	}
	
	// overlay = lerp(multiply, screen, dst)
	// hard_light = lerp(multiply, screen, src)
	
	// multiply = src*dst
	// screen = 1 - (1-src)*(1-dst) = src + dst - src*dst = add - multiply
	
	// overlay or hard_light = f*src + f*dst - 2*f*src*dst + src*dst
	// hard_light = src*src + 2*src*dst*(1 - src)
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		Pass {
			Blend Zero SrcColor
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
				final.rgb *= 2*(1 - final.rgb);
				final.rgb = lerp(fixed3(1,1,1), final.rgb, final.a);
				return final;
			}
			ENDCG
		}
		
		Pass {
			Blend One One
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
				return fixed4(final.rgb * final.rgb * final.a, final.a);
			}
			ENDCG
		}
	}
}
