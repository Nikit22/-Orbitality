Shader "BiniUber/RGBA/T/Color: HSV" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGBA)", 2D) = "white" {}
		
		_H ("Hue", Float) = 0
		_S ("Saturation", Float) = 0
		_V ("Value", Float) = 0
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
			
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			float _H, _S, _V;
			
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
				fixed4 texcol = TEX_RGBA(_MainTex, i.texcoord0);
				float3 tmp = rgb2hsv(texcol.rgb);
				tmp.x += _H;
				tmp.x -= floor(tmp.x);
				tmp.y = saturate(tmp.y + _S);
				tmp.z = saturate(tmp.z + _V);
				//tmp = saturate(tmp);
				texcol.rgb = hsv2rgb(tmp);
				return TINT(texcol);
			}
			ENDCG
		}
	}
}
