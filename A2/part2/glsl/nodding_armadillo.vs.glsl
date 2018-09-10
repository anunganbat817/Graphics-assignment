// Shared variable passed to the fragment shader
varying vec3 color;

// Constant set via your javascript code
uniform vec3 lightPosition;
uniform float moving;

void main() {
	// No lightbulb, but we still want to see the armadillo!
	vec3 l = vec3(0.0, 0.0, -1.0);
	color = vec3(1.0) * dot(l, normal);

	// Identifying the head
//    if (position.z < -0.3 && abs(position.y) > 0.7 && abs(position.x) > -0.48)
//        color = vec3(1.0, 0.0, 1.0);
//
//    if (position.z < 0.3 && abs(position.y) > 0.7 && abs(position.x) > 0.48)
//        color = vec3(1.0, 0.0, 1.0);


    mat4 Xrotate = mat4(vec4(1.0, 0.0, 0.0, 0.0),
                        vec4(0.0, cos(moving), sin(moving), 0.0),
                        vec4(0.0, -sin(moving), cos(moving), 0.0),
                        vec4(0.0, 0.0, 0.0, 1.0));
    
//    mat4 Xrotate = mat4(vec4(cos(moving), sin(moving), 0.0, 0.0),
//                        vec4(-sin(moving), cos(moving), 0.0, 0.0),
//                        vec4(0.0, 0.0, 0.0, 0.0),
//                        vec4(0.0, 0.0, 0.0, 1.0));

    mat4 v = mat4(vec4(1.0, 0.0, 0.0, 0.0),
                  vec4(0.0, 1.0, 0.0, 0.0),
                  vec4(0.0, 0.0, 1.0, 0.0),
                  vec4(0.0, 2.5, -0.1, 1.0));
    
    mat4 vinverse = mat4(vec4(1.0, 0.0, 0.0, 0.0),
                         vec4(0.0, 1.0, 0.0, 0.0),
                         vec4(0.0, 0.0, 1.0, 0.0),
                         vec4(0.0, -2.5, 0.1, 1.0));
    
	// Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
//    if (position.z < -0.33 && abs(position.x) < 0.46){
//    gl_Position = projectionMatrix * modelViewMatrix * v * Xrotate * vinverse * vec4(position, 1.0);
//    } else {
//            gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0);
//        }
//}
    
    if (position.z < -0.3 && abs(position.y) > 1.7 && abs(position.x) > -0.53){
        gl_Position = projectionMatrix * modelViewMatrix * v * Xrotate * vinverse * vec4(position, 1.0);
    } else if (position.z < 0.3 && abs(position.y) > 1.7 && abs(position.x) > 0.53){
        gl_Position = projectionMatrix * modelViewMatrix * v * Xrotate * vinverse * vec4(position, 1.0);
    } else {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0);
    }
}

