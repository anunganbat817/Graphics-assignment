uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;
uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float alphaX;
uniform float alphaY;

varying vec3 nor;
varying vec3 view;
uniform vec3 coolColor;
uniform vec3 warmColor;
uniform vec3 objectColor;
void main() {
    
    vec3 n1 = normalize(nor);
    vec3 light = normalize(vec3(viewMatrix * vec4(lightDirection, 0.0)));
    vec3 v1 = normalize(-view);
    
//    float diffuse = max(0.0, dot(n1,light));
    float diffuse = dot(n1, light);
    float interpolationValue = (1.0 + diffuse)/ 2.0;
    
	//TOTAL INTENSITY
	//TODO PART 1D: calculate light intensity	
//    float lightIntensity = diffuse;
//
    vec4 resultingColor = vec4(0.0, 0.0, 0.0, 0.0);
    
    // cool color mixed with color of the object
    vec3 coolColorMod = coolColor + objectColor * 0.5;
    // warm color mixed with color of the object
    vec3 warmColorMod = warmColor + objectColor * 0.5;
    // interpolation of cool and warm colors according
    // to lighting intensity. The lower the light intensity,
    // the larger part of the cool color is used
    vec3 color = mix(coolColorMod, warmColorMod, interpolationValue);
    
    gl_FragColor = vec4(color, 1.0);
}
