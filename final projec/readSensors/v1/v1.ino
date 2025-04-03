#include "GravityTDS.h"

#define pressurePin 14 //A0
#define turbidityPin 15 // A1
#define phPin 16 // A2
#define temperaturePin 17 
#define salinityPin 18


GravityTDS gravityTds;

void setup() {
  // put your setup code here, to run once:
  
  Serial.begin(9600);

  pinMode(pressurePin,INPUT);
  pinMode(turbidityPin,INPUT);
  pinMode(phPin,INPUT);
  pinMode(temperaturePin,INPUT);
  //pinMode(salinityPin,INPUT);


  gravityTds.setPin(salinityPin);
  gravityTds.setAref(3.3);  //reference voltage on ADC, default 5.0V on Arduino UNO
  gravityTds.setAdcRange(1024);  //1024 for 10bit ADC;4096 for 12bit ADC
  gravityTds.begin();

}

void loop() {
  // put your main code here, to run repeatedly:
  double turbidityVoltage = analogRead(turbidityPin) * 3.3/1023;
  double phVoltage = analogRead(turbidityPin) * 3.3/1023;
  double depthVoltage = analogRead(turbidityPin) * 3.3/1023;
  double temperatureVoltage = analogRead(temperaturePin) * 3.3/1023;
  double tdsVoltage = analogRead(temperaturePin) * 3.3/1023;

  double depth = -94.1 * depthVoltage + 310; // m
  double turbidity = -471 * turbidityVoltage + 1498; // NTU ; right now this is linear, when the data shows a skew above and below systematically
  double ph = phVoltage * -2.1429 + 14.5; // PH
  double temperature = temperatureVoltage * -0.0924+3.05;
  double tds = 2.02 *pow(10,-3) * pow(2.71828,2.08)*tdsVoltage;//TODO: exp should be 2.08


  gravityTds.setTemperature(temperature);  // set the temperature and execute temperature compensation
  gravityTds.update();  //sample and calculate 
  double tdsValue = gravityTds.getTdsValue();  // then get the value
  
  Serial.print("Depth: "); Serial.print(depth);
  Serial.print("  Turbidity: "); Serial.print(turbidity);
  Serial.print("  PH: "); Serial.print(ph);
  Serial.print("  Temperature: "); Serial.print(temperature);
  Serial.print("  TDS(ours): "); Serial.print(tds);
  Serial.print("  TDS(lib): "); Serial.print(tdsValue);
  Serial.print("  TDS: ");   Serial.print(tdsValue,0);  Serial.println("ppm");

  Serial.print("Depth V: "); Serial.print(depthVoltage);
  Serial.print("  Turbidity V: "); Serial.print(depthVoltage);
  Serial.print("  PH V: "); Serial.print(depthVoltage);
  Serial.print("  Temperature V: "); Serial.print(temperatureVoltage);
  Serial.print("  TDS V: "); Serial.println(tdsVoltage);
  Serial.println("\n \n \n");
  delay(2000);


  
  delay(100);
}
