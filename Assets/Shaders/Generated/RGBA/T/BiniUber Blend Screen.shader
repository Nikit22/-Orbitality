Shader "BiniUber/RGBA/T/Blend: Screen" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGBA)", 2D) = "white" {}
		
		_SubFactor ("Factor", Color) = (0,0,0,1)
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		Pass {
			Blend SrcAlpha OneMinusSrcColor, One One
			BlendOp Add
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			#include "BiniUber.cginc"
			
			DECLARE_CONSTANT_COLOR
			DECLARE_TEX(_MainTex)
			
			fixed4 _SubFactor;
			
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
				return fixed4(lerp(_SubFactor.rgb, final.rgb, final.a), _SubFactor.a);
			}
			ENDCG
		}
	}
}
