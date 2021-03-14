#version 130
/* MakeUp Ultra Fast - final.fsh
Render: Bloom

Javier Garduño - GNU Lesser General Public License v3.0
*/

// #include "/lib/config.glsl"

// Varyings (per thread shared variables)
varying vec2 texcoord;

void main() {
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  texcoord = gl_MultiTexCoord0.xy;
}
