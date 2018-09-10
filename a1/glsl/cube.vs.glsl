uniform vec3 cubePosition;
uniform float cubeRotation;
varying vec3 color;

void main() {
    float cosine = cos(cubeRotation);
    float sine = sin(cubeRotation);
    
    //rotation on z axis
    mat3 rotationMat1 = mat3(cosine, -sine, 0.0,
                        sine, cosine, 0.0,
                        0.0, 0.0, 1.0);
    // rotation on y axis
    mat3 rotationMat2 = mat3(cosine, 0.0, -sine,
                        0.0, 1, 0.0,
                        sine, 0.0, cosine);
    
    // a rotation of a vector by θ degrees around both y and z axis - > rotation about some third axis
    vec3 newposition =  rotationMat2 * (rotationMat1 * position) + cubePosition;
    
    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
    gl_Position = projectionMatrix * modelViewMatrix * vec4(newposition, 1.0);
    
}

