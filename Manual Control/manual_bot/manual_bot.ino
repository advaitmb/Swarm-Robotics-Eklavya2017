#include <ESP8266WiFi.h>
#include "Motor_control.h"

Motors bot;
char ssid[] = "a";          //  your network SSID (name) 
char pass[] = "12345678";   // your network password

int pwm1;
int pwm2;
String red;
String blue;
String green;
int smallPwm = 550;
int largePwm = 650;

int status = WL_IDLE_STATUS;
IPAddress server(192,168,43,148);// Google
int port =8080;
// Initialize the client library
WiFiClient client;

int countRec = 0;

void setup() {
  bot.setMode();  
  //bot.enable();
  Serial.begin(9600);
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
 
  WiFi.begin(ssid, pass);
 
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
    Serial.println("\nStarting connection...");
    // if you get a connection, report back via serial:
    if (client.connect(server, port)) {
      Serial.println("connected");

    }

  //bot.setEnable(600);
}

void loop() {
 //red=client.readStringUntil('\n');
 //redLargePwm=client.readStringUntil('\n');
 //redSmallPwm=client.readStringUntil('\n');
 red=client.readStringUntil('\n');
 //redLargePwm=client.readStringUntil('\n');
 //redSmallPwm=client.readStringUntil('\n');
 //blue=client.readStringUntil('\n');
 //blueLargePwm=client.readStringUntil('\n');
 //blueSmallPwm=client.readStringUntil('\n');
 //Serial.println(red);
 //Serial.println(red);
 Serial.println(red);
//Spot_Left
 if(red=="a")
 {
  
    Serial.println("spot_left");
    bot.spot_left(smallPwm,smallPwm);
    
 }

//Left
 if(red=="q")
 {
  
    Serial.println("left");
    bot.left(smallPwm,largePwm);
    
 }

//Spot_Right
 if(red=="d")
 {
    Serial.println("spot_right");
    bot.spot_right(smallPwm,smallPwm);
 }

//Right
 if(red=="e")
 {
    Serial.println("right");
    bot.right(smallPwm,largePwm);
 }



 //Forward 
 if(red=="w")
 {
    Serial.println("forward");
    bot.forward(smallPwm,smallPwm);

 }

//Back
 if(red=="s")
 {
    Serial.println("backward");
    bot.backward(smallPwm,smallPwm);
    
 }

//Stop
if(red=="z")
 {
   Serial.println("hadd");
   bot.stopBot();   
 }

 if(red=="b"){
    Serial.println("brake");
    bot.brake(smallPwm,smallPwm);
  }
} 
