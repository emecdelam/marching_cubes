#version 330 core

in vec3 fragNormal;
in vec3 fragPosition;

uniform vec3 lightPos;   // Light position (world space)
uniform vec3 viewPos;    // Camera position
uniform vec3 lightColor; // Light color (e.g., white)

out vec4 finalColor;

void main() {
    // Ambient
    float ambientStrength = 0.1;
    vec3 ambient = ambientStrength * lightColor;

    // Diffuse
    vec3 norm = normalize(fragNormal);
    vec3 lightDir = normalize(lightPos - fragPosition);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * lightColor;

    // Combine
    vec3 result = (ambient + diffuse) * vec3(1.0); // Assuming white material
    finalColor = vec4(result, 1.0);
}