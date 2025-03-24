#define TdsSensorPin A1
#define VREF 5.0           // analog reference voltage(Volt) of the ADC
#define SCOUNT 30          // sum of sample point

void setup() {
  Serial.begin(115200);
  pinMode(TdsSensorPin, INPUT);
}
void loop() {
  int temperature = 20; // TODO: Make the real temperature value
  int val = analogRead(TdsSensorPin);  //read the analog value and store into the buffer

  //temperature compensation formula: fFinalResult(25^C) = fFinalResult(current)/(1.0+0.02*(fTP-25.0));
  float compensationCoefficient = 1.0 + 0.02 * (temperature - 25.0);
  //temperature compensation
  float compensationVolatge = val / compensationCoefficient;
  
  //convert voltage value to tds value
  tdsValue = (133.42 * compensationVolatge * compensationVolatge * compensationVolatge - 255.86 * compensationVolatge * compensationVolatge + 857.39 * compensationVolatge) * 0.5;  
  Serial.print("TDS Value:");
  Serial.print(tdsValue, 0);
  Serial.println("ppm");
}
