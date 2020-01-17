Shader "BiniUber/RGB+A/TVC/Compose: Outline" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		[NoScaleOffset] _MainTex_Alpha ("Main Texture (Alpha)", 2D) = "white" {}
		
		_OutlineColor ("Outline Color", Color) = (1,1,1,1)
		_OutlineSize ("Outline Size", Float) = 1
		_TexInfluence ("Texture Influence", Range (0, 1)) = 1
		[Toggle(USE_8_SAMPLES)] _Use8Samples ("Use 8 samples", Float) = 0

		_AlphaMin ("Alpha Min", Float) = 0
		_AlphaMax ("Alpha Max", Float) = 1
		_Sharpness ("Sharpness", Float) = 1
		[Toggle(USE_SHARPNESS)] _UseSharpness ("Use sharpness", Float) = 0
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		Pass {
			Blend One OneMinusSrcAlpha, One One
			BlendOp Add
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#pragma multi_compile __ USE_8_SAMPLES
			#pragma multi_compile __ USE_SHARPNESS
			
			#include "UnityCG.cginc"
			
			#define USE_SEPARATE_ALPHA 1
			#define USE_VERTEX_COLOR 1
			#define USE_CONSTANT_COLOR 1
			#define SEPARATE_VERTEX_CONSTANT_COLOR 1
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			fixed4 _OutlineColor;
			float _OutlineSize;
			fixed _TexInfluence;
			#if USE_SHARPNESS
			float _AlphaMin;
			float _AlphaMax;
			float _Sharpness;
			#endif
			
			struct appdata {
				DEFAULT_VERTEX_INPUT
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
				float4 texcoordH : TEXCOORD1;
				float4 texcoordV : TEXCOORD2;
				#if USE_8_SAMPLES
				float4 texcoordDP : TEXCOORD3;
				float4 texcoordDN : TEXCOORD4;
				#endif
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				float2 uv = o.texcoord0;
				float2 duv = _OutlineSize / _MainTex_TexelSize.zw;
				o.texcoord0 = uv;
				o.texcoordH = float4(uv.x - duv.x, uv.y, uv.x + duv.x, uv.y);
				o.texcoordV = float4(uv.x, uv.y - duv.y, uv.x, uv.y + duv.y);
				#if USE_8_SAMPLES
				o.texcoordDP = float4(uv.x - duv.x, uv.y - duv.y, uv.x + duv.x, uv.y + duv.y);
				o.texcoordDN = float4(uv.x - duv.x, uv.y + duv.y, uv.x + duv.x, uv.y - duv.y);
				#endif
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				fixed min_a, min_s, min_t;
				fixed4 q, r, s;
				
				fixed4 outline = _OutlineColor;
				
				fixed4 texcol = TEX_RGBA(_MainTex, i.texcoord0);
				
				q = fixed4(TEX_ALPHA(_MainTex, i.texcoordH.xy),
						   TEX_ALPHA(_MainTex, i.texcoordH.zw),
						   TEX_ALPHA(_MainTex, i.texcoordV.xy),
						   TEX_ALPHA(_MainTex, i.texcoordV.zw));
				
				r = fixed4((i.texcoordH.x > 0),
						   (i.texcoordH.z < 1),
						   (i.texcoordV.y > 0),
						   (i.texcoordV.w < 1));
				
				s = q * r;
				
				min_s = min(min(s.x, s.y), min(s.z, s.w));
				min_t = texcol.a;
				min_a = min(min_s, min_t);
				
				#if USE_8_SAMPLES
				q = fixed4(TEX_ALPHA(_MainTex, i.texcoordDP.xy),
						   TEX_ALPHA(_MainTex, i.texcoordDP.zw),
						   TEX_ALPHA(_MainTex, i.texcoordDN.xy),
						   TEX_ALPHA(_MainTex, i.texcoordDN.zw));
				
				r = fixed4((i.texcoordDP.x > 0) * (i.texcoordDP.y > 0),
						   (i.texcoordDP.z < 1) * (i.texcoordDP.w < 1),
						   (i.texcoordDN.x > 0) * (i.texcoordDN.y < 1),
						   (i.texcoordDN.z < 1) * (i.texcoordDN.w > 0));
				
				s = q * r;
				
				min_s = min(min(s.x, s.y), min(s.z, s.w));
				min_a = min(min_s, min_a);
				#endif

				#if USE_SHARPNESS
				outline.a *= pow(smoothstep(_AlphaMin, _AlphaMax, texcol.a), _Sharpness);
				#else
				outline.a *= texcol.a;
				#endif
				outline.rgb *= outline.a; // premultiply before interpolation!
				
				texcol = lerp(fixed4(1,1,1,texcol.a), texcol, _TexInfluence) * _CONSTANT_COLOR;
				texcol.rgb *= texcol.a; // premultiply before interpolation!
				
				return lerp(texcol, outline, (1-min_a)*(_OutlineSize != 0)) * _VERTEX_COLOR;
			}
			ENDCG
		}
	}
}
