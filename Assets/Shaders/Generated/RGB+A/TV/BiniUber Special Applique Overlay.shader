Shader "BiniUber/RGB+A/TV/Special: Applique Overlay" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		[NoScaleOffset] _MainTex_Alpha ("Main Texture (Alpha)", 2D) = "white" {}

		_OverlayTex ("Overlay (RGB)", 2D) = "white" {}
		_OverlayCutoff ("Cutoff", Range(0, 1)) = 0.99 // value in the original shader
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
			#define USE_VERTEX_COLOR 1
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)

			DECLARE_TEX_RGBA(_OverlayTex)
			float _OverlayCutoff;

			struct appdata {
				DEFAULT_VERTEX_INPUT
				float2 texcoord1 : TEXCOORD1;
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
				float2 texcoord1 : TEXCOORD1;
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				o.texcoord1 = TRANSFORM_TEX(v.texcoord0, _OverlayTex);
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				fixed4 base = TEX_RGBA(_MainTex, i.texcoord0);
				fixed4 overlay = tex2D(_OverlayTex, i.texcoord1);
				//overlay.rgb = lerp(0.5, overlay.rgb, overlay.a); // probably not needed
				fixed3 combined = lerp(1 - 2 * (1 - base.rgb) * (1 - overlay.rgb), 2 * base.rgb * overlay.rgb, step(base.rgb, 0.5));
				return TINT(fixed4(lerp(base.rgb, combined.rgb, step(_OverlayCutoff, base.a)), base.a));
			}
			ENDCG
		}
	}
}
