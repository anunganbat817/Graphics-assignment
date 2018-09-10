//VARYING VAR
varying vec3 Normal_V;
varying vec3 Position_V;
varying vec4 PositionFromLight_V;
varying vec2 Texcoord_V;

//UNIFORM VAR
uniform vec3 lightColorUniform;
uniform vec3 ambientColorUniform;
uniform vec3 lightDirectionUniform;

uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;

uniform float shininessUniform;

uniform sampler2D colorMap;
uniform sampler2D normalMap;
uniform sampler2D aoMap;
uniform sampler2D shadowMap;


varying mat3 tbn;
varying vec4 shadowcoord;
varying vec3 shadowcoord2;

// PART D)
// Use this instead of directly sampling the shadowmap, as the float
// value is packed into 4 bytes as WebGL 1.0 (OpenGL ES 2.0) doesn't
// support floating point bufffers for the packing see depth.fs.glsl
float getShadowMapDepth(vec2 texCoord)
{
	vec4 v = texture2D(shadowMap, texCoord);
	const vec4 bitShift = vec4(1.0, 1.0/256.0, 1.0/(256.0 * 256.0), 1.0/(256.0*256.0*256.0));
	return dot(v, bitShift);
}

void main() {
	// PART B) TANGENT SPACE NORMAL
    vec3 N_1 = normalize(texture2D(normalMap, Texcoord_V).xyz * 2.0 - 1.0);
    
// Transform the normal vector in the RGB channels to tangent space
//    vec3 N_1 = texture2D(normalMap, Texcoord_V).xyz * 2.0 - 1.0;
//    vec3 normal = normalize(tbn * N_1.rgb);
    
    vec3 texcolor = texture2D(colorMap, Texcoord_V).xyz;
    vec3 texcolor2 = texture2D(aoMap, Texcoord_V).xyz;
    
	// PRE-CALCS
	vec3 N = normalize(Normal_V);
    
    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 tangent= normalize(cross(N,up));
    vec3 bitangent = normalize(cross(N, tangent));
    mat3 tbn = mat3(tangent,bitangent,N);
    
	vec3 L = normalize(vec3(viewMatrix * vec4(lightDirectionUniform, 0.0))) * tbn;
	vec3 V = normalize(-Position_V) * tbn;
	vec3 H = normalize(V + L);
    

	// AMBIENT
	vec3 light_AMB = (ambientColorUniform * kAmbientUniform) * texcolor2;

	// DIFFUSE
	vec3 diffuse = kDiffuseUniform * lightColorUniform;
	vec3 light_DFF = (diffuse * max(0.0, dot(N_1, L))) * texcolor;

	// SPECULAR
	vec3 specular = kSpecularUniform * lightColorUniform;
	vec3 light_SPC = specular * pow(max(0.0, dot(H, N_1)), shininessUniform);

	// TOTAL
	vec3 TOTAL = light_AMB + light_DFF  + light_SPC;
    
    
	// SHADOW
	// Fill in attenuation for shadow here
    vec3 shadowcoord2;
//    vec2 Texcoord_V;
    
    shadowcoord2.x = shadowcoord.x/shadowcoord.w;
    shadowcoord2.y = shadowcoord.y/shadowcoord.w;
    shadowcoord2.z = shadowcoord.z/shadowcoord.w;
    
//    Texcoord_V.x = 0.5 * shadowcoord2.x + 0.5;
//    Texcoord_V.y = 0.5 * shadowcoord2.y + 0.5;
//    float zz = 0.5 * shadowcoord2.z + 0.5;
    // shadow coordinate: if shadowcoordinate 2 is less than the depth of the shadowcoordinate, then the object is in shadow 
    float visibility = 1.0;
    float depth = getShadowMapDepth(shadowcoord2.xy);
//    float depth = texture(shadowMap, Texcoord_V).x;
    
    if(depth < shadowcoord2.z){
        visibility = 0.5;
    };
    
    gl_FragColor = vec4(TOTAL*visibility, 1.0);
}
