#version 330

uniform mat4 mvp; // Required for 3D rendering

out vec4 finalColor;

void main() {
    finalColor = vec4(1.0, 0.0, 0.0, 1.0); // Solid red as test
}