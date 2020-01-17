Shader "Unlit/CelShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ShadowStrength ("Shadow Strength", Range(0, 1)) = 0.5
        _OutlineWidth ("Outline Width", Range(0, 0.1)) = 0.01
    }
    SubShader
    {
        Tags
        { 
            "RenderType"="Opaque" 
        }
        
        LOD 100

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
                "PassFlags" = "OnlyDirectional"
            }
            
            Cull Off
            
            Stencil 
            {
                Ref 1
                Comp Always
                Pass Replace
            }
 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ShadowStrength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                
                float NdotL = dot(_WorldSpaceLightPos0, normal);
                float lightIntensity = NdotL > 0 ? 1 : _ShadowStrength;
            
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
            
                col *= lightIntensity;
                return col;
            }
            ENDCG
        }
        Pass
        {	
            Cull Off

            Stencil 
            {
                Ref 1
                Comp Greater
            }
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            #include "UnityCG.cginc"
        
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
        
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };
        
            half _OutlineWidth;
            static const half4 OUTLINE_COLOR = half4(0,0,0,0);
        
            v2f vert (appdata v)
            {
                v.vertex.xyz += v.normal * _OutlineWidth;
                        
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                        
                return o;
            }
        
            fixed4 frag () : SV_Target
            {
                return OUTLINE_COLOR;
            }
            ENDCG
        }
    }
}
