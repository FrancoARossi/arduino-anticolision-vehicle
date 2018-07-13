import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class distance_interface extends PApplet {



Serial port;
String serialData;
float aux;
int conversion;
int colorRange;
int distance;

public void setup(){
	
	background(0);
	printArray(Serial.list());
	port = new Serial(this, Serial.list()[0], 9600);
}

public void draw(){
	while (port.available() > 0){
	serialData = port.readStringUntil(10);
	if (serialData != null){
			background(0);
			aux = PApplet.parseFloat(serialData);
			conversion = PApplet.parseInt(aux);
			if(conversion <= 500){
			distance = PApplet.parseInt(map(conversion, 0, 500, 0, 600));
			colorRange = PApplet.parseInt(map(conversion, 0, 500, 0, 255));
			fill(255 - colorRange, colorRange, 0);
			rect(100, 400, distance, 50);
			}
		}
	}
}
  public void settings() { 	size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "distance_interface" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
