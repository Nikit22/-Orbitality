Shader "BiniUber/RGBA/TC/Color: Tone" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGBA)", 2D) = "white" {}
		
		[BiniUberGrayscale] _Grayscale ("Mode", Vector) = (1,1,1,-1)
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
			
			#define USE_CONSTANT_COLOR 1
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			half4 _Grayscale;
			
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
				fixed factor_minmax = (max(max(texcol.r, texcol.g), texcol.b) + min(min(texcol.r, texcol.g), texcol.b)) * 0.5;
				fixed factor_dot = dot(texcol.rgb, _Grayscale.rgb);
				fixed factor_len = length(texcol.rgb * _Grayscale.rgb);
				texcol.rgb = dot(fixed3(factor_minmax, factor_dot, factor_len), fixed3(_Grayscale.a < 0, _Grayscale.a == 0, _Grayscale.a > 0));
				return TINT(texcol);
			}
			ENDCG
		}
	}
}
