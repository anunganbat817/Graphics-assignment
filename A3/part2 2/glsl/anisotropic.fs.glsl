uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;

varying vec4 V_ViewPosition;
varying vec4 V_Normal_VCS;
uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float shininessUniform;
uniform float alphaXUniform;
uniform float alphaYUniform;

varying vec3 viewVector;
varying vec3 normalVector;

void main() {
    
    vec3 lightVector = normalize(vec3(viewMatrix * vec4(lightDirection, 0.0)));
    vec3 normalVector2 = normalize(normalVector);
    vec3 lightReflect = normalize(reflect(-lightVector,normalVector2));
    vec3 halfVector = normalize(lightVector + viewVector);
    vec3 viewVector2 = -1.0 * normalize(viewVector);
 
    
    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 T = cross(normalVector, up);
    vec3 B = normalize(cross(normalVector2,T));
    float dotLN = max(0.0, dot(lightVector, normalVector2));
    float dotHN = max(0.0, dot(halfVector, normalVector2));
	float dotVN = max(0.0, dot(viewVector2, normalVector2));
    
	float dotHTAlphaX = dot(halfVector, T) / alphaXUniform;
	float dotHBAlphaY = dot(halfVector, B) / alphaYUniform;
    
    float specular =  sqrt(max(0.0, dotLN / dotVN)) * exp(-2.0 * (dotHTAlphaX * dotHTAlphaX
                      + dotHBAlphaY * dotHBAlphaY) / (1.0 + dotHN));
    
    float diffuse = max (0.0, dot(normalVector2, lightVector));
    //float specular = pow(max(0.0, dot(halfVector,normalVector)),shininessUniform);
    
    
gl_FragColor = vec4(kAmbientUniform * ambientColor+ diffuse * lightColor * kDiffuseUniform+ lightColor * specular * kSpecularUniform, 1.0);
    
}

//    //AMBIENT
//    vec3 light_AMB = vec3(0.1, 0.1, 0.1);
//
//    //DIFFUSE
//    vec3 light_DFF = vec3(0.1, 0.1, 0.1);
//
//    //SPECULAR
//    vec3 light_SPC = vec3(0.1, 0.1, 0.1);
//
//    //TOTAL
//    vec3 TOTAL = light_AMB + light_DFF + light_SPC;
//    gl_FragColor = vec4(TOTAL, 0.0);


