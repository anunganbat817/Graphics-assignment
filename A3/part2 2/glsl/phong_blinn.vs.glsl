uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;

uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float shininessUniform;

varying vec3 viewVector;
varying vec3 normalVector;


void main() {

    viewVector = vec3(modelViewMatrix * vec4(position,1.0));
    
    normalVector = normalMatrix * normal;
   
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
