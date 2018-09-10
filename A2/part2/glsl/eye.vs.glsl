// Shared variable passed to the fragment shader
varying vec3 color;
uniform vec3 eyeposition;
uniform vec3 lightPosition;

#define MAX_EYE_DEPTH 0.15

void main() {
  // simple way to color the pupil where there is a concavity in the sphere
  // position is in local space, assuming radius 1
  float d = min(1.0 - length(position), MAX_EYE_DEPTH);
  color = mix(vec3(1.0), vec3(0.0), d * 1.0 / MAX_EYE_DEPTH);
    // scaling first
    mat4 M = mat4(vec4(0.2, 0.0, 0.0, 0.0),
                  vec4(0.0, 0.2, 0.0, 0.0),
                  vec4(0.0, 0.0, 0.2, 0.0),
                  vec4(0.0, 0.0, 0.0, 1.0));
    
    mat4 translate = mat4(vec4(1.0, 0.0, 0.0, 0.0),
                            vec4(0.0, 1.0, 0.0, 0.0),
                            vec4(0.0, 0.0, 1.0, 0.0),
                            vec4(eyeposition, 1.0));
    

    mat4 rotatebyx = mat4(vec4(1.0, 0.0, 0.0, 0.0),
                          vec4(0.0, 0.0, -1.0, 0.0),
                          vec4(0.0, 1.0, 0.0, 0.0),
                          vec4(0.0, 0.0, 0.0, 1.0));
    
    mat4 rotatebyy = mat4(vec4(0.0, 0.0, -1.0, 0.0),
                          vec4(0.0, 1.0, 0.0, 0.0),
                          vec4(1.0, 0.0, 0.0, 0.0),
                          vec4(0.0, 0.0, 0.0, 1.0));
    
    
    
    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 n = normalize(eyeposition - lightPosition);
    vec3 u = normalize(cross(up, n));
    vec3 v = cross(n,u);
    
    mat4 lookAt = mat4(vec4(n, 0.0),
                       vec4(u, 0.0),
                       vec4(v, 0.0),
                       vec4(eyeposition, 1.0));
    
  // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
  gl_Position = projectionMatrix * modelViewMatrix * translate * lookAt * rotatebyy * rotatebyx * M * vec4(position, 1.0);
}
