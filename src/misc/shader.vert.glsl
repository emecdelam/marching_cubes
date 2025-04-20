#version 330 core
in vec3 vertexPosition;
in vec3 vertexNormal;  // Must be passed from your mesh data!

uniform mat4 mvp;
uniform mat4 matModel;

out vec3 FragPos;
out vec3 Normal;

void main() {
    FragPos = vec3(matModel * vec4(vertexPosition, 1.0));
    Normal = mat3(transpose(inverse(matModel))) * vertexNormal;
    gl_Position = mvp * vec4(vertexPosition, 1.0);
}