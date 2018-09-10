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

void main() {
    
    vec3 n1 = normalize(nor);
    vec3 light = normalize(vec3(viewMatrix * vec4(lightDirection, 0.0)));
    vec3 v1 = normalize(-view);
    
    float diffuse = max(0.0, dot(n1,light));
    
	//TOTAL INTENSITY
	//TODO PART 1D: calculate light intensity	
    float lightIntensity = diffuse;

    vec4 resultingColor = vec4(0.0, 0.0, 0.0, 0.0);
    
//    if (diffuse > 0.95)
//        resultingColor = vec4(1.0, 0.5, 0.5, 1.0);
//    else if (diffuse > 0.5)
//        resultingColor = vec4(0.6, 0.3, 0.3, 1.0);
//    else if (diffuse > 0.25)
//        resultingColor = vec4(0.4, 0.2, 0.2, 1.0);
//    else
//        resultingColor = vec4(0.2, 0.1, 0.1, 1.0);
//
//    float angle = dot(v1, n1);
//
//    if (angle <=0.25){
//        resultingColor = vec4(0.0, 0.0, 0.0, 0.0);
//    }
//
//    resultingColor = vec4(1.0, 1.0, 1.0, 1.0);
//
    if (diffuse < 0.85)
    {
        // hatch from left top corner to right bottom
        if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0)
        {
            resultingColor = vec4(0.5, 1.0, 0.5, 1.0);
        }
    }
    
    if (diffuse < 0.75)
    {
        // hatch from right top corner to left boottom
        if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0)
        {
            resultingColor = vec4(0.3, 0.6, 0.3, 1.0);
        }
    }
    
    if (diffuse < 0.5)
    {
        // hatch from left top to right bottom
        if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0)
        {
            resultingColor = vec4(0.2, 0.4, 0.2, 1.0);
        }
    }
    
    if (diffuse < 0.25)
    {
        // hatch from right top corner to left bottom
        if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0)
        {
            resultingColor = vec4(0.1, 0.2, 0.1, 1.0);
        }
    }
        gl_FragColor = resultingColor;
}
