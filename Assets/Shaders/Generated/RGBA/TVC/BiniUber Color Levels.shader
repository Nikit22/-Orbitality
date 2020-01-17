Shader "BiniUber/RGBA/TVC/Color: Levels" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGBA)", 2D) = "white" {}
		
		_Power ("Power", Range(-1, 1)) = 0
		_Contrast ("Contrast", Range(-1, 1)) = 0
		_Brightness ("Brightness", Range(-1, 1)) = 0
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
			
			#define USE_VERTEX_COLOR 1
			#define USE_CONSTANT_COLOR 1
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			half _Power, _Contrast, _Brightness;
			
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
				half4 texcol = TEX_RGBA(_MainTex, i.texcoord0);
				
				texcol.rgb = lerp(texcol.rgb, half3(1,1,1), clamp(_Power, 0, 1));
				texcol.rgb = power_curve(texcol.rgb, _Power);
				
				texcol.rgb = lerp(texcol.rgb, half3(0.5,0.5,0.5), -clamp(_Contrast, -1, 0));
				texcol.rgb = power_curve(texcol.rgb*2-1, _Contrast)*0.5+0.5;
				
				texcol.rgb += _Brightness;
				
				return TINT(texcol);
			}
			ENDCG
		}
	}
}
