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
  loadFont("LucidaSansUnicode-48.vlw");
}

void draw() {
  while (port.available() > 0) { // While there is incoming data in the serial port (measured in bytes)
  serialData = port.readStringUntil(10); //Read the Serial Input until ASCII 10 (new line)
  if (serialData != null) {
    background(0);
    stroke(255);
		aux = float(serialData);
		distance = int(aux);
    if (distance != 420) {
      text(int(distance)+ "cm", 300, 200);
      inRangeDistance(previousPos, previousColor);
    } else {
      text("> 400cm", 180, 200);
      outOfRangeDistance(previousPos, previousColor);
    }
    fill(255 - actualColor, actualColor, 0);
		rect(100, 400, actualPos, 50);
    previousPos = actualPos;
    previousColor = actualColor;
	}
  }
}

void inRangeDistance(float previousPos, float previousColor){
  rectWidth = map(distance, 0, 400, 0, 600);
  actualPos = lerp(previousPos, rectWidth, 0.15);
  colorRange = map(distance, 0, 400, 0, 255);
  actualColor = lerp(previousColor, colorRange, 0.15);
}

void outOfRangeDistance(float previousPos, float previousColor){ // Using Linear Interpolation to give the animation some "smoothness"
  rectWidth = map(distance, 0, 400, 600, 600);
  actualPos = lerp(previousPos, rectWidth, 0.2);
  colorRange = map(distance, 0, 400, 255, 255);
  actualColor = lerp(previousColor, colorRange, 0.2);
}
