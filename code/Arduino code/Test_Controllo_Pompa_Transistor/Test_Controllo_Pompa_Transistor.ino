
const int transistorPin = 3; // connected to the base of the transistor

void setup() { 

pinMode(transistorPin, OUTPUT); 

} 

void loop() { 

  for (int brightness = 66; brightness < 255; brightness++) 
    { 
      analogWrite(transistorPin, brightness); delay(10);
    } 
  
  delay(2000);
  
  for (int brightness = 255; brightness >= 66; brightness--) 
    { 
      analogWrite(transistorPin, brightness); delay(10);
    }
   
  delay(2000);

}

