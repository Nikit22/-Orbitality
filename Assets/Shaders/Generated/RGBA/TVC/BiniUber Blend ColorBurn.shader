
Shader "BiniUber/RGBA/TVC/Blend: ColorBurn" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGBA)", 2D) = "white" {}
	}
	
    // Actual burn is impossible with conventional shader,
    // since a color is divided by color (in other words,
    // a color has to be multiplied by something greater than 1).
    
    // burn: result = 1 - (1 - base) / blend
    // base' = 1-base
    // tmp = k * base' + base' = base' / blend
    // result = 1 - tmp
    // k = (1 / blend) - 1
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		Pass {
			Blend OneMinusDstColor Zero
			BlendOp Add
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			struct appdata {
				float4 vertex : POSITION;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
			};
			
			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				return fixed4(1, 1, 1, 1);
			}
			ENDCG
		}
		
		Pass {
			Blend DstColor One
			BlendOp Add
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			#define USE_VERTEX_COLOR 1
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
				half4 final = TINT(TEX_RGBA(_MainTex, i.texcoord0));
				final.rgb = lerp(half3(1,1,1), final.rgb, final.a);
				final.rgb = (1/max(final.rgb, 0.001)) - 1;
				return final;
			}
			ENDCG
		}
		
		Pass {
			Blend OneMinusDstColor Zero
			BlendOp Add
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			struct appdata {
				float4 vertex : POSITION;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
			};
			
			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				return fixed4(1, 1, 1, 1);
			}
			ENDCG
		}
	}
}
