#include "Arduino.h"
class Motors{
 protected:
  int motorRF = D1;
  int motorRB = D2;
  int motorLF = D3;
  int motorLB = D4;
  int enL=D5;
  int enR=D6;
  
 public:

  void setMode(){
      pinMode(motorRF,OUTPUT);
      pinMode(motorRB,OUTPUT);
      pinMode(motorLF,OUTPUT);
      pinMode(motorLB,OUTPUT);
      pinMode(enL,OUTPUT);
      pinMode(enR,OUTPUT);
     // pinMode(en2,OUTPUT);
      
    }
 
  void brake(int myPwm1,int myPwm2){
      analogWrite(enL,myPwm1);
      analogWrite(enR,myPwm2);
      digitalWrite(motorRF,1);
      digitalWrite(motorRB,1);
      digitalWrite(motorLF,1);
      digitalWrite(motorLB,1);
    }
  void backward(int myPwm1,int myPwm2){
      analogWrite(enL,myPwm1);
      analogWrite(enR,myPwm2);
      digitalWrite(motorRF,1);
      digitalWrite(motorRB,0);
      digitalWrite(motorLF,1);
      digitalWrite(motorLB,0);
    }
   void forward(int myPwm1,int myPwm2){
      analogWrite(enL,myPwm1);
      analogWrite(enR,myPwm2);
      digitalWrite(motorRF,0);
      digitalWrite(motorRB,1);
      digitalWrite(motorLF,0);
      digitalWrite(motorLB,1);  
   }
   
    void spot_left(int myPwm1,int myPwm2){   //right in gree // left in green
      analogWrite(enL,myPwm1);
      analogWrite(enR,myPwm2);
      digitalWrite(motorRF,1);
      digitalWrite(motorRB,0);
      digitalWrite(motorLF,0);
      digitalWrite(motorLB,1); 
      }

      
      void left(int myPwm1,int myPwm2){
      analogWrite(enL,myPwm1);
      analogWrite(enR,myPwm2);
      digitalWrite(motorRF,0);
      digitalWrite(motorRB,1);
      digitalWrite(motorLF,0);
      digitalWrite(motorLB,1);
        
      }
     
     void spot_right(int myPwm1,int myPwm2){         //Left in green // right in red
      analogWrite(enL,myPwm1);
      analogWrite(enR,myPwm2);
      digitalWrite(motorRF,0);
      digitalWrite(motorRB,1);
      digitalWrite(motorLF,1);
      digitalWrite(motorLB,0); 
      }


      void right(int myPwm1, int myPwm2){
      analogWrite(enL,myPwm2);
      analogWrite(enR,myPwm1);
      digitalWrite(motorRF,0);
      digitalWrite(motorRB,1);
      digitalWrite(motorLF,0);
      digitalWrite(motorLB,1); 
        
      }

      void stopBot(){
      //analogWrite(en,0);
      digitalWrite(motorRF,0);
      digitalWrite(motorRB,0);
      digitalWrite(motorLF,0);
      digitalWrite(motorLB,0);
      }
    
  };
/*
class bot : public Motors{
    float bot_x;
    float bot_y;
    float theta;
    float selfAngle=0;  //change when adding the program that recieves co-ordinates

    //Calculating angle between object and robot
    /*void calcAngle(loat ob_x,float ob_y){
        theta = atan((ob_y-bot_y)/(ob_x-bot_x));
      }*/
      
    //Function which rotates the bot till it aligns with object
    /*void rotate(){
        if(theta>0){
            while(selfAngle!=theta){
                bot_left();
              }
          }
         else if(theta<0){
            while(selfAngle!=theta){
                bot_right();
              }
          }
      }//End of rotate function
*/
/*    
  };

class object{
  public: 
    float object_x;
    float object_y;
  };*/
