#version 120
/* MakeUp Ultra Fast - deferred.vsh
Render: Used for ambient occlusion

Javier Garduño - GNU Lesser General Public License v3.0
*/

// Varyings (per thread shared variables)
varying vec2 texcoord;

void main() {
	gl_Position = ftransform();
	texcoord = gl_MultiTexCoord0.xy;
}
