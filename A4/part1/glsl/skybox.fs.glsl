// UNIFORMS
uniform samplerCube skybox;
varying vec3 pos_world;

void main() {
    
    gl_FragColor = textureCube(skybox, pos_world);
}

