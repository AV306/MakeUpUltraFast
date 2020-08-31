#version 120
/* MakeUp Ultra Fast - deferred.fsh
Render: Used for ambient occlusion

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NICE_WATER 1  // [0 1] Turn on for reflection and refraction capabilities.
#define AO 1  // [0 1] Turn on for enhanced ambient occlusion (medium performance impact).
#define AOSTEPS 10 // [10 15 20] Ambient occlusion quality

// Varyings (per thread shared variables)
varying vec2 texcoord;

// 'Global' constants from system
uniform sampler2D texture;
uniform sampler2D depthtex0;
uniform float near;
uniform float far;
uniform float aspectRatio;
uniform mat4 gbufferProjection;

#include "/lib/ao.glsl"

void main() {
  // Toma el color puro del bloque
  vec4 block_color = texture2D(texture, texcoord);

  #if AO == 1
    float dither = bayer2(gl_FragCoord.xy);

    // AO distance attenuation
    float d = texture2D(depthtex0, texcoord.xy).r;
    float ao_att = sqrt(ld(d));
    float final_ao = mix(dbao(depthtex0, dither), 1.0, ao_att);
    block_color *= final_ao;
    // block_color = vec4(vec3(final_ao), 1.0);
	#endif

  gl_FragData[0] = block_color;
  #if NICE_WATER == 1
    gl_FragData[5] = block_color;
  #else
    gl_FragData[1] = vec4(0.0);
  #endif
}