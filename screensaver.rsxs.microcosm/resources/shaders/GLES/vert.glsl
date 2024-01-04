#version 100

precision mediump float;

struct LightSource
{
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  vec4 position;
};

// Attributes
attribute vec4 a_position;
attribute vec3 a_normal;

// Uniforms
uniform mat4 u_projectionMatrix;
uniform mat4 u_modelViewMatrix;
uniform mat3 u_transposeAdjointModelViewMatrix;
uniform vec3 u_texCoordMix;
uniform LightSource u_light0;
uniform LightSource u_light1;

// Varyings
varying vec4 vsPosition;
varying vec3 vsNormal;
varying vec3 vsLight0Vec;
varying vec3 vsLight1Vec;
varying vec3 vsEyeVec;
varying vec4 vsTexCoord;

void main(void)
{
  vsNormal = u_transposeAdjointModelViewMatrix * a_normal;
  vsLight0Vec = u_light0.position.xyz;
  vsLight1Vec = u_light1.position.xyz;
  vsPosition = u_modelViewMatrix * a_position;
  vsEyeVec = -vsPosition.xyz;
  vec3 vsNormalNormalized = normalize(vsNormal);
  vsTexCoord.xyz = vec3(mix(length(a_position.xyz), a_position.x + a_position.y + a_position.z + 2.0, u_texCoordMix.x),
  mix(dot(normalize(-vsPosition.xyz), vsNormalNormalized) * 0.5 + 0.49, vsNormalNormalized.x * 0.49 + 0.5, u_texCoordMix.y), u_texCoordMix.z);
  gl_Position = u_projectionMatrix * vsPosition;
}
