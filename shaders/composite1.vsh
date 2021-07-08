#version 120
/* MakeUp - composite1.fsh
Render: Bloom and DoF

Javier Garduño - GNU Lesser General Public License v3.0
*/

// Varyings (per thread shared variables)
varying vec2 texcoord;

void main() {
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  texcoord = gl_MultiTexCoord0.xy;
}
