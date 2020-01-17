
Shader "BiniUber/RGBA/TVC/Compose: Multi Step Knife" {
	Properties {
		[Header(Bini Uber)]
		[BiniUberHeader] _BiniUber ("BiniUber", Float) = 0
		[Space]
		
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_MainTex ("Main Texture (RGBA)", 2D) = "white" {}
		
		_MaskSteps ("Mask Step Sizes", Vector) = (0,0,0,0)
		_MaskLevels ("Mask Levels", Vector) = (0,0,0,0)
		[NoScaleOffset] _MaskTex ("Mask Tex", 2D) = "white" {}

		_PosScale ("Pos & Scale", Vector) = (0,0,1,1)
		_Angle ("Angle", Float) = 0.0
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
			
			// We expect that _MaskedTex does not need separate alphamap
			DECLARE_TEX_RGBA(_MaskTex)
			
			float4 _MaskSteps;
			float4 _MaskLevels;

			float4 _PosScale;
			float _Angle;
			
			struct appdata {
				DEFAULT_VERTEX_INPUT
			};
			
			struct v2f {
				DEFAULT_FRAGMENT_INPUT
				float2 texcoord1 : TEXCOORD1;
				float4 maskStepsInv : TEXCOORD2;
			};
			
			v2f vert(appdata v) {
				v2f o;
				DEFAULT_VERTEX_CODE
				float _sin, _cos;
				sincos(radians(_Angle), _sin, _cos);
				float2x2 texmat = { {_cos, _sin}, {-_sin, _cos} };
				// -+0.5 to rotate around the center
				float2 tex_xy = mul(texmat, v.texcoord0 - _PosScale.xy - 0.5) + 0.5;
				o.texcoord1 = (tex_xy / _PosScale.zw);
				//o.texcoord1 = TRANSFORM_TEX((tex_xy / _PosScale.zw), _MaskTex);
				o.maskStepsInv = 1 / max(_MaskSteps, 1.0/255.0);
				return o;
			}
			
			const half a_min = 1.0/255.0;
			fixed4 frag(v2f i) : COLOR0 {
				fixed4 main_color = TEX_RGBA(_MainTex, i.texcoord0);
				fixed4 mask = tex2D(_MaskTex, i.texcoord1);
				mask = saturate((mask - _MaskLevels) * i.maskStepsInv);
				main_color.a *= min(min(mask.r, mask.g), min(mask.b, mask.a));
				return TINT(main_color);
			}
			ENDCG
		}
	}
}
