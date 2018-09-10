uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;

uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float shininessUniform;
uniform float alphaXUniform;
uniform float alphaYUniform;

varying vec4 V_Normal_VCS;
varying vec4 V_ViewPosition;
varying vec3 viewVector;
varying vec3 normalVector;


void main() {
    
    V_ViewPosition =vec4(position,1.0);
    
    V_Normal_VCS = vec4(normal, 1.0);
    
    viewVector = vec3(modelViewMatrix * V_ViewPosition);
    
    normalVector = normalMatrix * vec3(V_Normal_VCS);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
