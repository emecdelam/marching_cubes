#version 330

// Input from vertex shader
in vec3 fragPosition;
in vec2 fragTexCoord;
in vec4 fragColor;



uniform mat4 mvp;


out vec4 finalColor;

void main() {
    float normalizedHeight = clamp(fragPosition.y/ 10.0, 0.0, 1.0);
    
    vec3 color;
    if (normalizedHeight < 0.2) {
        color = vec3(1.0, normalizedHeight * 5.0, 0.0);
    } else if (normalizedHeight < 0.4) {
        color = vec3(1.0 - (normalizedHeight - 0.2) * 5.0, 1.0, 0.0);
    } else if (normalizedHeight < 0.6) {
        color = vec3(0.0, 1.0, (normalizedHeight - 0.4) * 5.0);
    } else if (normalizedHeight < 0.8) {
        color = vec3(0.0, 1.0 - (normalizedHeight - 0.6) * 5.0, 1.0);
    } else {
        color = vec3((normalizedHeight - 0.8) * 5.0, 0.0, 1.0);
    }
    
    
    finalColor = vec4(color, 1.0);
    
}