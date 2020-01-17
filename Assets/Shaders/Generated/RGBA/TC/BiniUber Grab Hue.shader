Shader "BiniUber/RGBA/TC/Grab: Hue" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGBA)", 2D) = "white" {}
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off
		ZTest Always
		ZWrite Off
		Lighting Off
		Fog { Mode Off }
		
		GrabPass { } // default: "_GrabTexture"
		
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
			
			sampler2D _GrabTexture;
			
			struct appdata {
				DEFAULT_VERTEX_INPUT
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
				float4 grabUV : TEXCOORD1;
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				o.grabUV = ComputeGrabScreenPos(o.pos);
				return o;
			}
			
			fixed4 frag(v2f i) : COLOR0 {
				fixed4 texcol = TINT(TEX_RGBA(_MainTex, i.texcoord0));
				fixed4 grabcol = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabUV));
				float3 texhsv = rgb2hsv(texcol.rgb);
				float3 grabhsv = rgb2hsv(grabcol.rgb);
				texhsv.yz = grabhsv.yz;
				texcol.rgb = hsv2rgb(texhsv);
				return texcol;
			}
			ENDCG
		}
	}
}
