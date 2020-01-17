// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#if USE_CONSTANT_COLOR
    #define DECLARE_CONSTANT_COLOR fixed4 _Color;
#else
    #define DECLARE_CONSTANT_COLOR
#endif

#if ETC1_EXTERNAL_ALPHA
	// Note: this is strictly for Unity sprites support.
	// On Android, sprite atlases are separated into RGB and Alpha
	// textures, which are both compressed using ETC1 (so Alpha
	// has to be accessed via one of the .rgb vector components)
    #define DECLARE_TEX(TEX) sampler2D TEX; sampler2D _AlphaTex; uniform float4 TEX ## _ST; uniform float4 TEX ## _TexelSize;
#elif USE_SEPARATE_ALPHA
    #define DECLARE_TEX(TEX) sampler2D TEX; sampler2D TEX ## _Alpha; uniform float4 TEX ## _ST; uniform float4 TEX ## _TexelSize;
#else
    #define DECLARE_TEX(TEX) sampler2D TEX; uniform float4 TEX ## _ST; uniform float4 TEX ## _TexelSize;
#endif

#define DECLARE_TEX_RGBA(TEX) sampler2D TEX; uniform float4 TEX ## _ST; uniform float4 TEX ## _TexelSize;

#if USE_VERTEX_COLOR
    #define DEFAULT_VERTEX_INPUT float4 vertex : POSITION; float2 texcoord0 : TEXCOORD0; fixed4 color : COLOR;
    #define DEFAULT_FRAGMENT_INPUT float4 pos : SV_POSITION; float2 texcoord0 : TEXCOORD0; fixed4 color : COLOR;
#else
    #define DEFAULT_VERTEX_INPUT float4 vertex : POSITION; float2 texcoord0 : TEXCOORD0;
    #define DEFAULT_FRAGMENT_INPUT float4 pos : SV_POSITION; float2 texcoord0 : TEXCOORD0;
#endif

#if USE_VERTEX_COLOR
    #if USE_CONSTANT_COLOR
    	#ifdef SEPARATE_VERTEX_CONSTANT_COLOR
    		#define DEFAULT_VERTEX_CODE o.pos = UnityObjectToClipPos(v.vertex); o.texcoord0 = TRANSFORM_TEX(v.texcoord0, _MainTex); o.color = v.color;
    	#else
        	#define DEFAULT_VERTEX_CODE o.pos = UnityObjectToClipPos(v.vertex); o.texcoord0 = TRANSFORM_TEX(v.texcoord0, _MainTex); o.color = v.color * _Color;
        #endif
    #else
        #define DEFAULT_VERTEX_CODE o.pos = UnityObjectToClipPos(v.vertex); o.texcoord0 = TRANSFORM_TEX(v.texcoord0, _MainTex); o.color = v.color;
    #endif
#else
    #define DEFAULT_VERTEX_CODE o.pos = UnityObjectToClipPos(v.vertex); o.texcoord0 = TRANSFORM_TEX(v.texcoord0, _MainTex);
#endif

#if ETC1_EXTERNAL_ALPHA
    #define TEX_RGBA(TEX, UV) (fixed4(tex2D((TEX), (UV)).rgb, tex2D((_AlphaTex), (UV)).r))
    #define TEX_ALPHA(TEX, UV) (tex2D((_AlphaTex), (UV)).r)
#elif USE_SEPARATE_ALPHA
    #define TEX_RGBA(TEX, UV) (fixed4(tex2D((TEX), (UV)).rgb, tex2D((TEX ## _Alpha), (UV)).a))
    #define TEX_ALPHA(TEX, UV) (tex2D((TEX ## _Alpha), (UV)).a)
#else
    #define TEX_RGBA(TEX, UV) (tex2D((TEX), (UV)))
    #define TEX_ALPHA(TEX, UV) (tex2D((TEX), (UV)).a)
#endif

#if USE_VERTEX_COLOR
    #define _TINT (i.color)
    #define _TINT_RGB (i.color.rgb)
    #define _TINT_A (i.color.a)
    #define TINT(VALUE) ((VALUE) * i.color)
#elif USE_CONSTANT_COLOR
    #define _TINT (_Color)
    #define _TINT_RGB (_Color.rgb)
    #define _TINT_A (_Color.a)
    #define TINT(VALUE) ((VALUE) * _Color)
#else
    #define _TINT (fixed4(1,1,1,1))
    #define _TINT_RGB (fixed3(1,1,1))
    #define _TINT_A (1)
    #define TINT(VALUE) (VALUE)
#endif

#ifdef SEPARATE_VERTEX_CONSTANT_COLOR
	#if USE_VERTEX_COLOR
		#define _VERTEX_COLOR (i.color)
	#else
		#define _VERTEX_COLOR (fixed4(1,1,1,1))
	#endif
	#if USE_CONSTANT_COLOR
		#define _CONSTANT_COLOR (_Color)
	#else
		#define _CONSTANT_COLOR (fixed4(1,1,1,1))
	#endif
#endif

/////////////////////////////////////////////////////
// (see also http://www.chilliant.com/rgb2hsv.html)
// http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
float3 rgb2hsv(float3 c) {
    const float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    //float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
    //float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
    // ​Emil Persson suggests using the ternary operator explicitly
    // to force compilers into using a fast conditional move instruction:
    float4 p = c.g < c.b ? float4(c.bg, K.wz) : float4(c.gb, K.xy);
    float4 q = c.r < p.x ? float4(p.xyw, c.r) : float4(c.r, p.yzx);
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
float3 hsv2rgb(float3 c) {
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
}

// -1: infinity
// 0: 1
// 1: 0
half3 power_curve(half3 value, half power) {
	power = clamp(power, -1, 1);
	return sign(value) * pow(abs(value), (1-power)/(1+power));
}
/////////////////////////////////////////////////////
