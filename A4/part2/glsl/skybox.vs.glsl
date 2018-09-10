uniform samplerCube skybox;
uniform vec3 cameraPosition;
uniform mat4 modelMatrix;
varying vec3 pos_world;
void main() {
    
    vec3 pos_world = vec3(modelMatrix * vec4(position,1.0));

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos_world + cameraPosition, 1.0);
    gl_Position.z = gl_Position.w;
}




