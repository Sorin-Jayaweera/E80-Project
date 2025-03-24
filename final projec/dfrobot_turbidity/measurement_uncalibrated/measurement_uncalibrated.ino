// Sorin Jayaweera 3/24/2025
//This code assumes linearity

// needs 5v power supply
// in digital mode, sends 5V signal when passing the threshold, "railing out". Adjustable on the ADC
// We want the actual values, not a threshold. Thus, this code is for Analog Mode
#define DFROBOT_TURBIDITY_ANALOG_PIN 5

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(DFROBOT_TURBIDITY_ANALOG_PIN,INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  int val = analogRead(DFROBOT_TURBIDITY_ANALOG_PIN);

  //this assumes that the max voltage would be 3.3. We need to change this.
  float voltage = val * 3.3/1023.0
  
  // Once we have the op amp circuit done, we can do a calibration to find the percentage covered.
  const float gain = 0;
  const float shift = 0;
  const uint8_t lowest = 0;
  const uint16_t highest = 0;
  
  // Honestly I don't know if we even need to do this. We can just take our highest and lowest at the amplified to find the ratio...
  // TODO: Check if we divide or shift first!!!
  float origionalVoltage = val / gain - shift;

  //normalizing our value 
  float percentage = (origionalVoltage - lowest) / (highest - lowest);
  Serial.print("Val "); Serial.print(val); 
    Serial.print(" Raw Voltage "); Serial.print(voltage);
    Serial.print(" Origional Voltage "); Serial.print(origionalVoltage);
    Serial.print(" Percentage "); Serial.println(percentage);
  
}
