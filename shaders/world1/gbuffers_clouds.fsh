#version 120
/* MakeUp - gbuffers_clouds.fsh
Render: sky, clouds

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define THE_END
#define NO_SHADOWS
#define CLOUDS_SHADER

#include "/lib/config.glsl"
#include "/lib/color_utils.glsl"

// 'Global' constants from system
uniform sampler2D tex;
uniform float far;
uniform float pixel_size_x;
uniform float pixel_size_y;
uniform sampler2D gaux4;

// Varyings (per thread shared variables)
varying vec2 texcoord;
varying vec4 tint_color;
varying float frog_adjust;

void main() {
  vec4 block_color = texture2D(tex, texcoord) * tint_color;

  #include "/src/cloudfinalcolor.glsl"
  #include "/src/writebuffers.glsl"
}
