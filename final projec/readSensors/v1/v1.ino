#define pressurePin 14 //A0
#define turbidityPin 15 // A1
#define phPin 16 // A2
void setup() {
  // put your setup code here, to run once:
  
  Serial.begin(9600);

  pinMode(pressurePin,INPUT);
  pinMode(turbidityPin,INPUT);
  pinMode(phPin,INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  double turbidityVoltage = analogRead(turbidityPin) * 3.3/1023;
  double phVoltage = analogRead(turbidityPin) * 3.3/1023;
  double pressureVoltage = analogRead(turbidityPin) * 3.3/1023;

  double depth = -94.1 * pressureVoltage + 310; // m
  double turbidity = -471 * turbidityVoltage + 1498; // NTU ; right now this is linear, when the data shows a skew above and below systematically
  double ph = phVoltage * -2.1429 + 14.5; // PH

  Serial.print("Depth: "); Serial.print(depth);
  Serial.print("Turbidity: "); Serial.print(turbidity);
  Serial.print("PH: "); Serial.print(ph);


  
  delay(100);
}
