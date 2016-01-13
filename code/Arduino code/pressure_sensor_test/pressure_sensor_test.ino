
int CZPO[2]={0}; 
int SP[2]={0};
int level[2]={0};
int sensorPin[2]={A0};
int sensorValue[2]={0};
int i;

//int sensorPin_0 = A0;
//int sensorPin_1 = A1;  
//int sensorValue_0 = 0;
//int sensorValue_1 = 0;

/*int CZPO_0 = 0;
int CZPO_1 = 0;
int SP_0 = 0;
int SP_1 = 0;
int level_0 = 0;
int level_1 = 0;*/

void setup() {

  Serial.begin(9600);
  for (i=0; i<1; i++)
    CZPO[i] = autozero(sensorPin[i]);
    //CZPO_1 = autozero(sensorPin_1); 
  
}

void loop() {
  for (i=0; i<1; i++){
  sensorValue[i] = analogRead(sensorPin[i]);
  //sensorValue_1 = analogRead(sensorPin_1); 

  SP[i] = analogRead(sensorPin[i]);
  //SP_1 = analogRead(sensorPin_1);
  
  level[i] = SP[i] - CZPO[i];
  //level_1 = SP_1 - CZPO_1;
  if (level[i]<0)
    level[i]=0;
  }
  
  for (i=0; i<1; i++) {

  Serial.print("Livello tank = ");
  Serial.print(level[i]);
  //Serial.print(" ml");
  Serial.print("    ");
  //Serial.println(level_1);
  }
  Serial.println();
         
  delay(400);
}

int autozero(int sensor_pin)
{
  int CZPO = analogRead(sensor_pin);
  return CZPO;
}
