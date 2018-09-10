//VARYING VAR
varying vec3 Normal_V;
varying vec3 Position_V;
varying vec4 PositionFromLight_V;
varying vec2 Texcoord_V;

//UNIFORM VAR
// Inverse world matrix used to render the scene from the light POV
uniform mat4 lightViewMatrixUniform;
// Projection matrix used to render the scene from the light POV
uniform mat4 lightProjectMatrixUniform;
// starts here
uniform sampler2D nMap;
uniform sampler2D aoMap;

uniform vec3 lightColorUniform;
uniform vec3 ambientColorUniform;
uniform vec3 lightDirectionUniform;
uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float shininessUniform;
varying vec4 shadowcoord;
//varying mat4 bMatrix;
void main() {
    
    Normal_V = normalMatrix * normal;
    Position_V = vec3(modelViewMatrix * vec4(position, 1.0));
    Texcoord_V = uv;
    
    mat4 bMatrix = mat4(0.5, 0.0, 0.0, 0.0,
                        0.0, 0.5, 0.0, 0.0,
                        0.0, 0.0, 0.5, 0.0,
                        0.5, 0.5, 0.5, 1.0);
    
    shadowcoord = bMatrix * lightProjectMatrixUniform * lightViewMatrixUniform * modelMatrix * vec4(position, 1.0);
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
