// Create shared variable. The value is given as the interpolation between normals computed in the vertex shader
varying vec3 interpolatedNormal;
varying vec3 direction;
float cos;
float dotproduct;

/* HINT: YOU WILL NEED MORE SHARED/UNIFORM VARIABLES TO COLOR ACCORDING TO COS(ANGLE) */

void main() {

  // Set final rendered color according to the surface normal
  //gl_FragColor = vec4(normalize(interpolatedNormal), 1.0); // REPLACE ME
    dotproduct = dot(interpolatedNormal,direction);
    cos = dotproduct / (length(interpolatedNormal) * length(direction));
    
    if(length(direction) < 4.5){
        gl_FragColor = vec4(0,cos,0, 1.0);
    } else {
        gl_FragColor = vec4(cos,cos,cos, 1.0);
    }
    
}

