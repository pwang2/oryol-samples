//------------------------------------------------------------------------------
@block FSUtil
vec4 gamma(vec4 c) {
    float p = 1.0/2.2;
    return vec4(pow(c.xyz, vec3(p, p, p)), c.w);
}
@end

@block SkinUtil
void skinned_pos(in vec4 pos, in vec4 skin_weights, in vec4 skin_indices, out vec4 skin_pos) {
    vec4 weights = skin_weights / dot(skin_weights, vec4(1.0));
    vec2 step = vec2(1.0 / skin_info.z, 0.0);
    vec2 uv;
    vec4 xxxx, yyyy, zzzz;
    if (weights.x > 0.0) {
        uv = vec2(skin_info.x + (3.0*skin_indices.x)/skin_info.z, skin_info.y);
        xxxx = textureLod(boneTex, uv, 0.0);
        yyyy = textureLod(boneTex, uv + step, 0.0);
        zzzz = textureLod(boneTex, uv + 2.0 * step, 0.0);
        skin_pos.xyz = vec3(dot(pos,xxxx), dot(pos,yyyy), dot(pos,zzzz)) * weights.x;
    }
    else {
        skin_pos.xyz = vec3(0.0);
    }
    if (weights.y > 0.0) {
        uv = vec2(skin_info.x + (3.0*skin_indices.y)/skin_info.z, skin_info.y);
        xxxx = textureLod(boneTex, uv, 0.0);
        yyyy = textureLod(boneTex, uv + step, 0.0);
        zzzz = textureLod(boneTex, uv + 2.0 * step, 0.0);
        skin_pos.xyz += vec3(dot(pos,xxxx), dot(pos,yyyy), dot(pos,zzzz)) * weights.y;
    }
    if (weights.z > 0.0) {
        uv = vec2(skin_info.x + (3.0*skin_indices.z)/skin_info.z, skin_info.y);
        xxxx = textureLod(boneTex, uv, 0.0);
        yyyy = textureLod(boneTex, uv + step, 0.0);
        zzzz = textureLod(boneTex, uv + 2.0 * step, 0.0);
        skin_pos.xyz += vec3(dot(pos,xxxx), dot(pos,yyyy), dot(pos,zzzz)) * weights.z;
    }
    if (weights.w > 0.0) {
        uv = vec2(skin_info.x + (3.0*skin_indices.w)/skin_info.z, skin_info.y);
        xxxx = textureLod(boneTex, uv, 0.0);
        yyyy = textureLod(boneTex, uv + step, 0.0);
        zzzz = textureLod(boneTex, uv + 2.0 * step, 0.0);
        skin_pos.xyz += vec3(dot(pos,xxxx), dot(pos,yyyy), dot(pos,zzzz)) * weights.w;
    }
    skin_pos.w = 1.0;
}
@end

@vs lambertVS
uniform vsParams {
    mat4 mvp;
    mat4 model;
    vec4 vtx_mag;
    vec4 skin_info;
};
uniform sampler2D boneTex;

@include SkinUtil

in vec4 position;
in vec3 normal;
in vec4 weights;
in vec4 indices;
out vec3 N;
void main() {
    vec4 pos;
    skinned_pos(position * vtx_mag, weights, indices * 255.0, pos);
    gl_Position = mvp * pos;
    N = (model * vec4(normal, 0.0)).xyz;
}
@end

@fs lambertFS
/*
@include Util
uniform lightParams {
    vec3 lightDir;
    vec4 lightColor;
};
uniform matParams {
    vec4 diffuseColor;
};
*/
in vec3 N;
out vec4 fragColor;

void main() {
    vec3 n = normalize(N);
    fragColor = vec4(n*0.5+0.5, 1.0);
}
@end

@program LambertShader lambertVS lambertFS



