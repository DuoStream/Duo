#include "ReShade.fxh"

uniform float ia_target_gamma <
	ui_type = "drag";
	ui_min = 0.1;
	ui_max = 5.0;
	ui_step = 0.1;
	ui_label = "Target Gamma [Image Adjustment]";
> = 2.2;

uniform float ia_monitor_gamma <
	ui_type = "drag";
	ui_min = 0.1;
	ui_max = 5.0;
	ui_step = 0.1;
	ui_label = "Monitor Gamma [Image Adjustment]";
> = 2.2;


uniform float ia_overscan_percent_x <
	ui_type = "drag";
	ui_min = -25.0;
	ui_max = 25.0;
	ui_step = 1.0;
	ui_label = "Horizontal Overscan % [Image Adjustment]";
> = 0.0;

uniform float ia_overscan_percent_y <
	ui_type = "drag";
	ui_min = -25.0;
	ui_max = 25.0;
	ui_step = 1.0;
	ui_label = "Vertical Overscan % [Image Adjustment]";
> = 0.0;

uniform float ia_saturation <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.01;
	ui_label = "Saturation [Image Adjustment]";
> = 1.0;

uniform float ia_contrast <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 10.0;
	ui_step = 0.05;
	ui_label = "Contrast [Image Adjustment]";
> = 1.0;

uniform float ia_luminance <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.03;
	ui_label = "Luminance [Image Adjustment]";
> = 1.0;

uniform float ia_black_level <
	ui_type = "drag";
	ui_min = -0.30;
	ui_max = 0.30;
	ui_step = 0.01;
	ui_label = "Black Level [Image Adjustment]";
> = 0.01;

uniform float ia_bright_boost <
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Brightness Boost [Image Adjustment]";
> = 0.0;

uniform float ia_R <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Red Channel [Image Adjustment]";
> = 1.0;

uniform float ia_G <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Green Channel [Image Adjustment]";
> = 1.0;

uniform float ia_B <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Blue Channel [Image Adjustment]";
> = 1.0;

uniform float ia_ZOOM <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 4.0;
	ui_step = 0.01;
	ui_label = "Zoom Factor [Image Adjustment]";
> = 1.0;

uniform float ia_XPOS <
	ui_type = "drag";
	ui_min = -2.0;
	ui_max = 2.0;
	ui_step = 0.005;
	ui_label = "X Modifier [Image Adjustment]";
> = 0.0;

uniform float ia_YPOS <
	ui_type = "drag";
	ui_min = -2.0;
	ui_max = 2.0;
	ui_step = 0.005;
	ui_label = "Y Modifier [Image Adjustment]";
> = 0.0;

uniform float ia_TOPMASK <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.0025;
	ui_label = "Overscan Mask Top [Image Adjustment]";
> = 0.0;

uniform float ia_BOTMASK <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.0025;
	ui_label = "Overscan Mask Bottom [Image Adjustment]";
> = 0.0;

uniform float ia_LMASK <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.0025;
	ui_label = "Overscan Mask Left [Image Adjustment]";
> = 0.0;

uniform float ia_RMASK <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.0025;
	ui_label = "Overscan Mask Right [Image Adjustment]";
> = 0.0;

uniform float ia_GRAIN_STR <
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 72.0;
	ui_step = 6.0;
	ui_label = "Film Grain [Image Adjustment]";
> = 0.0;

//Tools

uniform int ia_framecount  < source = "framecount"; >;

float fmod(float a, float b) {
	float c = frac(abs(a / b)) * abs(b);
	return a < 0 ? -c : c;
}

#define mod(x,y) (x-y*floor(x/y))

//Actual Shader Code

//https://www.shadertoy.com/view/4sXSWs strength= 16.0
float3 filmGrain(float2 uv, float strength, float frameCount ){       
    float x = (uv.x + 4.0 ) * (uv.y + 4.0 ) * ((fmod(frameCount, 800.0) + 10.0) * 10.0);
    float v = fmod((mod(x, 13.0) + 1.0) * (fmod(x, 123.0) + 1.0), 0.01)-0.005;
	return  float3(v, v, v) * strength;
}

float3 grayscale(float3 col)
{
   // ATSC grayscale standard
   float b = dot(col, float3(0.2126, 0.7152, 0.0722));
   return float3(b, b, b);
}

float3 rgb2hsv(float3 c)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = c.g < c.b ? float4(c.bg, K.wz) : float4(c.gb, K.xy);
    float4 q = c.r < p.x ? float4(p.xyw, c.r) : float4(c.r, p.yzx);

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

float3 hsv2rgb(float3 c)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float4 PS_ImageAdjustment(float4 pos : SV_Position, float2 coords : TEXCOORD0) : SV_Target
{

   float2 shift = 0.5 * ReShade::ScreenSize / ReShade::ScreenSize;
   float2 overscan_coord = ((coords - shift) / ia_ZOOM) * (1.0 - float2(ia_overscan_percent_x / 100.0, ia_overscan_percent_y / 100.0)) + shift;
   float2 coord_final = overscan_coord + float2(ia_XPOS, ia_YPOS);
   
   float2 texCoord = coord_final;

   float3 film_grain = filmGrain(texCoord.xy, ia_GRAIN_STR, ia_framecount);
   float2 fragcoord = texCoord.xy * (ReShade::ScreenSize.xy / ReShade::ScreenSize.xy);
   float3 res = tex2D(ReShade::BackBuffer, texCoord).rgb; // sample the texture
   res += film_grain;
   float gamma_ratio = ia_monitor_gamma / ia_target_gamma;
   float3 gamma = float3(gamma_ratio, gamma_ratio, gamma_ratio); // setup ratio of display's gamma vs desired gamma

//saturation and luminance
   float3 satColor = clamp(hsv2rgb(rgb2hsv(res) * float3(1.0, ia_saturation, ia_luminance)), 0.0, 1.0);

//contrast and brightness
   float3 conColor = clamp((satColor - 0.5) * ia_contrast + 0.5 + ia_bright_boost, 0.0, 1.0);

   conColor -= float3(ia_black_level, ia_black_level, ia_black_level); // apply black level
   float min_black = 1.0-ia_black_level;
   conColor *= (1.0 / float3(min_black, min_black, min_black));
   conColor = pow(conColor, 1.0 / float3(gamma)); // Apply gamma correction
   conColor *= float3(ia_R, ia_G, ia_B);
   if (fragcoord.y > ia_TOPMASK && fragcoord.y < (1.0 - ia_BOTMASK))
      conColor = conColor;
   else
     conColor = 0.0;

   if (fragcoord.x > ia_LMASK && fragcoord.x < (1.0 - ia_RMASK))
      conColor = conColor;
   else
      conColor = 0.0;
   return float4(conColor, 1.0);
}

technique RA_ImageAdjustment
{
	pass ImageAdjustment_1
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_ImageAdjustment;
	}
}