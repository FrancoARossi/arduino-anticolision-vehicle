import processing.serial.*;

Serial port;
PImage gitHubLogo;

int distance = 0;
float aux = 0;
float rectWidth = 0;
float actualPos = 0;
float previousPos = 0;
float colorRange = 0;
float actualColor = 0;
float previousColor = 0;

void setup() {
  size(800, 600);
  background(0);
  stroke(255);
  printArray(Serial.list()); // Prints the COM ports availables in console
  port = new Serial(this, Serial.list()[0], 9600); // Serial.list()[0] is the first COM port thats find by the Serial.list() function,
  gitHubLogo = loadImage("github_logo.png");       // it ussually is the one that's connected to Arduino, if you have your Arduino plugged in
}                                                  // and the program dosn't show anything (not even the down left corner watermark) or if it crashes
                                                   // it probably means that the COM port isn't the right one, in that case you should check
                                                   // on which COM is your Arduino then replace Serial.list()[0] in line 20
                                                   // for "COMx" (x beign your COM port number)
void draw() {
  while (port.available() > 0) { // While there is incoming data in the serial port (measured in bytes)
    String serialData = port.readStringUntil(10); //Read the Serial Input until ASCII 10 (new line)
    background(0);
    tint(255, 127);
    image(gitHubLogo, 40, 550, 30, 30);
    textSize(16);
    fill(255);
    text("FrancoARossi", 85, 570);
    tint(255);
    fill(255 - actualColor, actualColor, 0);
    if (serialData != null) {
  		aux = float(serialData); // For some reason if I use int() to convert the number in serialData directly it always returns 0
  		distance = int(aux);     // but converting it to float first works
      textSize(90);
      if (distance != 420) {
        text(int(distance)+ "cm", 280, 200);
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

void inRangeDistance(float previousPos, float previousColor){ // Using Linear Interpolation (lerp) to give the animation some "smoothness"
  rectWidth = map(distance, 0, 400, 0, 600); // Mapping the distance to the rectangle width in pixels
  actualPos = lerp(previousPos, rectWidth, 0.2);
  colorRange = map(distance, 0, 400, 0, 255); // Mapping the distance to the color in RGB mode
  actualColor = lerp(previousColor, colorRange, 0.2);
}

void outOfRangeDistance(float previousPos, float previousColor){ 
  rectWidth = map(distance, 0, 400, 600, 600);
  actualPos = lerp(previousPos, rectWidth, 0.2);
  colorRange = map(distance, 0, 400, 255, 255);
  actualColor = lerp(previousColor, colorRange, 0.2);
}
