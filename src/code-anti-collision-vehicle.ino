#include <Servo.h>

#define IN1 6
#define IN2 7
#define IN3 8
#define IN4 9
#define TRIG 10
#define ECHO 11
#define SERV 5

// Prototipos
word ultraSonicRead(void);
byte scan(void);
void rightTurn(void);
void leftTurn(void);
void forward(void);
void stop(void);

Servo scanServo;

void setup()
{
	pinMode(IN1, OUTPUT);
	pinMode(IN2, OUTPUT);
	pinMode(IN3, OUTPUT);
	pinMode(IN4, OUTPUT);
	pinMode(TRIG, OUTPUT);
	pinMode(ECHO, INPUT);
	Serial.begin(9600);
	scanServo.attach(SERV);
}

void loop()
{
	if (ultraSonicRead() <= 23)
	{
		stop();
		switch (scan())
		{
			case 0 : rightTurn();
					break;
			case 1 : leftTurn();
					break;
		}
		forward();
	}
	else
	{
		forward();
	}
}

word ultraSonicRead(void)
{
	word distance = 0;
	digitalWrite(TRIG, LOW);
	delayMicroseconds(2);
	digitalWrite(TRIG, HIGH);
	delayMicroseconds(10);
	digitalWrite(TRIG, LOW); // Envio una señal de 10 microsegundos y corto
	distance = word((pulseIn(ECHO, HIGH) * 0.0343) / 2); // El tiempo que tarda en volver la señal por la velocidad del sonido

	return distance;
}

void forward(void)
{
	digitalWrite(IN1, HIGH);
	digitalWrite(IN2, LOW);
	digitalWrite(IN3, HIGH);
	digitalWrite(IN4, LOW);
}

void stop(void)
{
	digitalWrite(IN1, LOW);
	digitalWrite(IN2, LOW);
	digitalWrite(IN3, LOW);
	digitalWrite(IN4, LOW);
}

void rightTurn(void)
{
	digitalWrite(IN1, HIGH);
	digitalWrite(IN2, LOW);
	digitalWrite(IN3, LOW);
	digitalWrite(IN4, LOW);
}

void leftTurn(void)
{
	digitalWrite(IN1, LOW);
	digitalWrite(IN2, LOW);
	digitalWrite(IN3, HIGH);
	digitalWrite(IN4, LOW);
}

byte scan(void)
{
	scanServo.write(90);
	delay(175);
	word leftDistance = ultraSonicRead();
	scanServo.write(-90);
	delay(350);
	word rightDistance = ultraSonicRead();
	scanServo.write(0);
	delay(175);
	if (rightDistance >= leftDistance)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}