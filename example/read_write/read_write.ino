char Message; 

void setup() {
  Serial.begin(115200);

}

void loop() {
 if (Serial.available()) {
  Message = Serial.read();
  Serial.print(Message);
 }
}
