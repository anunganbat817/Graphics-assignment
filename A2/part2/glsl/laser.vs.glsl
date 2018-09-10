uniform vec3 lightPosition;
uniform vec3 eyeposition;

void main() {
    /* HINT: WORK WITH lightPosition HERE! */
    float slaser = length(lightPosition - eyeposition)/2.0;

    mat4 scale = mat4(vec4(1.0, 0.0, 0.0, 0.0),
                  vec4(0.0, slaser, 0.0, 0.0),
                  vec4(0.0, 0.0, 1.0, 0.0),
                  vec4(0.0, 0.0, 0.0, 1.0));

    mat4 translateM = mat4(vec4(1.0, 0.0, 0.0, 0.0),
                          vec4(0.0, 1.0, 0.0, 0.0),
                          vec4(0.0, 0.0, 1.0, 0.0),
                          vec4(eyeposition/2.0, 1.0));

    mat4 rotatex = mat4(vec4(1.0, 0.0, 0.0, 0.0),
                          vec4(0.0, 0.0, -1.0, 0.0),
                          vec4(0.0, 1.0, 0.0, 0.0),
                          vec4(0.0, 0.0, 0.0, 1.0));

    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 z = normalize(eyeposition - lightPosition);
    vec3 x = normalize(cross(up, z));
    vec3 y = cross(x,z);

    mat4 lookAt = mat4(vec4(x, 0.0),
                       vec4(y, 0.0),
                       vec4(z, 0.0),
                       vec4(eyeposition/2.0, 1.0));
    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
//    gl_Position = projectionMatrix * modelViewMatrix * (vec4(position, 1.0) + vec4 (lightPosition,0));
gl_Position = projectionMatrix * modelViewMatrix * translateM * lookAt * rotatex * scale * vec4(position, 1.0);
}


