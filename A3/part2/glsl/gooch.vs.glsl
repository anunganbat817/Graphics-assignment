uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;
uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float alphaX;
uniform float alphaY;
uniform vec3 coolColor;
uniform vec3 warmColor;
uniform vec3 objectColor;
varying vec3 nor;
varying vec3 view;

void main() {
    
    nor = normalMatrix * normal;
    view = vec3(modelViewMatrix * vec4(position, 1.0));
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}


