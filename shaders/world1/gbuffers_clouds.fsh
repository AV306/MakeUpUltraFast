#version 120
/* MakeUp Ultra Fast - gbuffers_clouds.fsh
Render: sky, clouds

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NICE_WATER 1  // [0 1] Turn on for reflection and refraction capabilities.

varying vec2 texcoord;
varying vec4 color;

// 'Global' constants from system
uniform int worldTime;
uniform sampler2D texture;
uniform float wetness;
uniform float far;
uniform int current_hour_floor;
uniform int current_hour_ceil;
uniform float current_hour_fract;

#include "/lib/color_utils_end.glsl"

void main() {
  vec4 block_color = texture2D(texture, texcoord) * color;

  float frog_adjust = gl_FogFragCoord / far;
  // Fog intensity calculation
  float fog_density_coeff = mix(
    fog_density[current_hour_floor],
    fog_density[current_hour_ceil],
    current_hour_fract
    );

  block_color.rgb =
    mix(
      block_color.rgb,
      gl_Fog.color.rgb,
      pow(clamp(frog_adjust, 0.0, 1.0), mix(fog_density_coeff, .5, wetness)) * .75
    );

  gl_FragData[0] = block_color;
  #if NICE_WATER == 1
    gl_FragData[5] = block_color;
  #else
    gl_FragData[1] = vec4(0.0);
  #endif
}
