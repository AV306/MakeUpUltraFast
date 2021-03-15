#version 130
/* MakeUp Ultra Fast - final.fsh
Render: Final renderer

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NO_SHADOWS

#include "/lib/config.glsl"

// Do not remove comments. It works!
/*

colortex0 - Main color canvas
colortex1 - Antialiasing auxiliar
colortex2 - Bloom auxiliar
colortex3 - TAA Averages history
gaux1 - Sreen-Space-Reflection texture
colortex5 - Blue noise texture
gaux3 - Perlin noise texture
colortex7 - Not used

const int colortex0Format = R11F_G11F_B10F;
const int colortex1Format = RGBA16F;
const int colortex2Format = R11F_G11F_B10F;
const int colortex3Format = RGBA16F;
const int gaux1Format = RGB8;
const int colortex5Format = R8;
const int gaux3Format = R8;
const int colortex7Format = R8;
*/

// 'Global' constants from system
uniform ivec2 eyeBrightnessSmooth;
uniform int current_hour_floor;
uniform int current_hour_ceil;
uniform float current_hour_fract;
uniform sampler2D colortex0;

// Varyings (per thread shared variables)
varying vec2 texcoord;

#include "/lib/color_utils.glsl"
#include "/lib/basic_utils.glsl"
#include "/lib/tone_maps.glsl"

#if CHROMA_ABER == 1
  #include "/lib/aberration.glsl"
#endif

void main() {
  #if CHROMA_ABER == 1
    vec3 block_color = color_aberration();
  #else
    vec3 block_color = texture(colortex0, texcoord).rgb;
  #endif

  // Tonemaping ---
  // x: Block, y: Sky ---
  float candle_bright = (eyeBrightnessSmooth.x * 0.004166666666666667) * 0.075;
  float exposure_coef =
    mix(
      ambient_exposure[current_hour_floor],
      ambient_exposure[current_hour_ceil],
      current_hour_fract
    );
  float exposure =
    ((eyeBrightnessSmooth.y * 0.004166666666666667) * exposure_coef) + candle_bright;

  // Map from 1.0 - 0.0 to 1.3 - 3.9
  exposure = (exposure * -2.6) + 3.9;

  block_color *= exposure;
  block_color = lottes_tonemap(block_color, exposure);

  gl_FragColor = vec4(block_color, 1.0);
}
