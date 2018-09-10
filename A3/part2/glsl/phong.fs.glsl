uniform vec3 lightColor;
uniform vec3 ambientColor;
uniform vec3 lightDirection;

uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float shininessUniform;

varying vec3 viewVector;
varying vec3 normalVector;

void main() {
    
    vec3 viewVector1 = normalize(-viewVector);
    vec3 normalVector1 = normalize(normalVector);
    
    vec3 lightVector = normalize(vec3(viewMatrix * vec4(lightDirection, 0.0)));
    vec3 lightReflect = normalize(reflect(-lightVector,normalVector1));
    
    float diffuse = max (0.0, dot(normalVector1, lightVector));
    float specular = pow(max(0.0, dot(lightReflect,viewVector1)),shininessUniform);
    
    
    gl_FragColor = vec4(kAmbientUniform * ambientColor+ diffuse * lightColor * kDiffuseUniform + lightColor * specular * kSpecularUniform, 1.0);

}
