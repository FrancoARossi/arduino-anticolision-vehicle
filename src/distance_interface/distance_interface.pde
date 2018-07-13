import processing.serial.*;

Serial port;

String serialData;
int distance = 0;
float aux = 0;
float rectWidth = 0;
float colorRange = 0;
float previousColor = 0;
float actualColor = 0;
float previousPos = 0;
float actualPos = 0;
float movement = 0;

void setup() {
  size(800, 600);
  background(0);
  printArray(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  textSize(100);
}

void draw() {
  while (port.available() > 0) { // While there is incoming data in the serial port (measured in bytes)
  serialData = port.readStringUntil(10); //Read the Serial Input until ASCII 10 (new line)
  if (serialData != null) {
    background(0);
		aux = float(serialData);
		distance = int(aux);
		rectWidth = map(distance, 0, 400, 0, 600);
    actualPos = lerp(previousPos, rectWidth, 0.15); // Smooth distance rectangle using Linear Interpolation
		colorRange = map(distance, 0, 400, 0, 255);
    actualColor = lerp(previousColor, colorRange, 0.15); // Smooth color using Linear Interpolation
    stroke(255);
    text(int(distance), 300, 200);
		fill(255 - actualColor, actualColor, 0);
		rect(100, 400, actualPos, 50);
    previousPos = actualPos;
    previousColor = actualColor;
	}
  }
}
