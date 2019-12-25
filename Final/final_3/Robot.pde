/*What Do we want from the robot:
*Data Members:
*Co-ordinates of its centroid
*It's self angle
*methods:
*sturdy controller, meaning that it does not over shoot
*Obstacle avoiding
*/

//Lets define a class for Robots red,blue and green
class Robot{
//Data Members:
//Centroid
float centroid_x;
float centroid_y;

boolean stopThis = false;
//int serveNo;

float deathRadius = 100;

int id;

int p = 0;

int rightCount=0;
int leftCount=0;
int forwardCount=0;

float head_x;
float head_y;
float tail_x;
float tail_y;

//Direction counts
int stopCount;

float theta;
float selfAngle;

float[] size_storX = new float[100];
float[] size_storY = new float[100];

float[] co_storX = new float[100];
float[] co_storY = new float[100];

//Member Functions
void assign(){
   if(calcSize(size_storX[0],size_storY[0])<calcSize(size_storX[1],size_storY[1])){
   head_x = co_storX[1];
   head_y = co_storY[1];
   tail_x = co_storX[0];
   tail_y = co_storY[0];
   centroid_x = (head_x+ tail_x)/2;
   centroid_y = (head_y+ tail_y)/2;
 }
 
 else if(calcSize(size_storX[0],size_storY[0])>calcSize(size_storX[1],size_storY[1])){
   head_x = co_storX[0];
   head_y = co_storY[0];
   tail_x = co_storX[1];
   tail_y = co_storY[1];
   centroid_x = (head_x+ tail_x)/2;
   centroid_y = (head_y+ tail_y)/2;
 }
}
void angle(){
selfAngle = atan((head_y-tail_y)/(head_x-tail_x));
}

//Theta is the angle of police bot with respect to ideal location
//For now let the origin be the ideal location
void trackTheta(float x,float y){
  theta = atan((y-centroid_y)/(x-centroid_x));
}

void spot_left(int ser){
    if(ser==1){
      server1.write("a\n");
      println("spot_left");
    }
    else if(ser==2){
      server2.write("a\n");
      println("spot_left");
    }
    
}
void spot_right(int ser){
      if(ser==1){
      server1.write("d\n");
      println("spot_right");
    }
    else if(ser==2){
      server2.write("d\n");
      println("spot_right");
    }
}

void right(int ser){

    if(ser==1){
      server1.write("e\n");
      println("right");
    }
    else if(ser==2){
      server2.write("e\n");
      println("right");
    }

}

void left(int ser){
  
  if(ser==1){
      server1.write("q\n");
      println("left");
    }
    else if(ser==2){
      server2.write("q\n");
      println("left");
    }

}

void forward(int ser){
    if(ser==1){
      server1.write("w\n");
      println("forward");
    }
    else if(ser==2){
      server2.write("w\n");
      println("forward");
    }
}
void stopBot(int ser){
    if(ser==1){
      server1.write("z\n");
      println("stop");
    }
    else if(ser==2){
      server2.write("z\n");
      println("stop");
    }
}
void brake(int ser){
    if(ser==1){
      server1.write("b\n");
      println("brake");
    }
    else if(ser==2){
      server2.write("b\n");
      println("brake");
    }  
    
}  
void alignPerp(int servNo){
  int abcd = servNo;
  //When head_x > tail_x, i.e 1st and 4th quadrant
  if(stopCount>=10)stopBot(abcd);
  else if(stopCount<10){
  if(head_x>tail_x){
    if(selfAngle>-1.52&&selfAngle<0)spot_left(abcd);
    else if(selfAngle<1.52&&selfAngle>0)spot_right(abcd);
    else if(selfAngle<-1.52&&selfAngle<0)stopBot(abcd);
    else if(selfAngle>1.52&&selfAngle>0)stopBot(abcd);
  }
  else if(head_x<tail_x){
      if(selfAngle>-1.52&&selfAngle<0)spot_left(abcd);
    else if(selfAngle<1.52&&selfAngle>0)spot_right(abcd);
    else if(selfAngle<-1.52&&selfAngle<0)stopBot(abcd);
    else if(selfAngle>1.52&&selfAngle>0)stopBot(abcd);
  }
  }
}

void travelToOrigin(int servNo){
  //Case 1
  if(selfAngle>0){
    //1st Quadrant
    if(head_x>tail_x){
      println("1st Quadrant,go left");
      spot_left(servNo);
    }
    if(head_x<tail_x){
      if(selfAngle>theta + 0.4){
        println("3rd quadrant, go left");
        spot_left(servNo);
      }
      else if(selfAngle<theta - 0.4){
        println("3rd quadrant, go right");
        spot_right(servNo);
      }
      else if(selfAngle<theta + 0.4||selfAngle>theta-0.4){
        if(centroid_x>=60||centroid_y>=60){
          println("now go forward till origin");
          forward(servNo);
        }
        else if(centroid_x<60&&centroid_y<60){
          println("Okay stop");
          stopBot(servNo);
        }
      }
    }
  }
  //Case 2
  if(selfAngle<0){
    if(head_x<tail_x&&head_y>tail_y){
      println("2nd Quadrant, go right");
      spot_right(servNo);
    }
    if(head_x>tail_x&&head_y<tail_y){
      println("4th Quadrant, go left");
      spot_left(servNo);
    }
  }
}

void travelToXY(float ix,float iy,int servNo){
  if(theta>0){
    if(ix>centroid_x){
      p=1;
      
    }
    else if(ix<centroid_x){
      p=3;
    }
  }
  else if(theta<0){
    if(iy<centroid_y&&ix>centroid_x){
      p=4;
    }else if(ix<centroid_x&&iy>centroid_y){
      p=2;
    }
  }
  println("qudarant"+p);
  switch(p){
      case 1://theta is in 1st quadrant
      if(selfAngle>0){
        if(head_x>tail_x){
          //SubCase 1: selfAngle is also in 1st quadrant
          quadrantMatched(ix,iy,servNo);
        }else if(head_x<tail_x){
          //SubCase 3: selfAngle is in 3rd Quadrant
          spot_left(servNo);
        }
      }else if(selfAngle<0){
        if(head_x<tail_x&&head_y>tail_y){
          //SubCase 2: selfAngle is in 2nd Quadrant
          spot_left(servNo);
        }else if(head_x>tail_x&&head_y<tail_y){
          spot_right(servNo);
        }
      }
      break;
      
      case 2://theta is in second quadrant
      if(selfAngle>0){
        if(head_x>tail_x){
          //SubCase 1: selfAngle is also in 1st quadrant
          println("selfAngle is in 1st quad,go right");
          spot_right(servNo);
        }else if(head_x<tail_x){
          //SubCase 3: selfAngle is in 3rd Quadrant
          println("selfAngle is in 3rd quad,go left");
          spot_left(servNo);
        }
      }else if(selfAngle<0){
        if(head_x<tail_x&&head_y>tail_y){
          //SubCase 2: selfAngle is in 2nd Quadrant
          quadrantMatched(ix,iy,servNo);
        }else if(head_x>tail_x&&head_y<tail_y){
          println("selfAngle is in 4th quad,go right");
          spot_right(servNo);
        }
      }
      break;
      
      case 3:
      if(selfAngle>0){
        if(head_x>tail_x){
          //SubCase 1: selfAngle is also in 1st quadrant
          println("selfAngle is in 1st quad,go right");
          spot_right(servNo);
        }else if(head_x<tail_x){
          //SubCase 3: selfAngle is in 3rd Quadrant
          quadrantMatched(ix,iy,servNo);
        }
      }else if(selfAngle<0){
        if(head_x<tail_x&&head_y>tail_y){
          //SubCase 2: selfAngle is in 2nd Quadrant
          println("selfAngle is in 3rd quad,go right");
          spot_right(servNo);
        }else if(head_x>tail_x&&head_y<tail_y){
          println("selfAngle is in 4th quad,go left");
          spot_left(servNo);
        }
      }
      break;
      
      case 4:
      if(selfAngle>0){
        if(head_x>tail_x){
          //SubCase 1: selfAngle is also in 1st quadrant
          println("selfAngle is in 1st quad,go left");
          spot_left(servNo);
        }else if(head_x<tail_x){
          //SubCase 3: selfAngle is in 3rd Quadrant
          println("selfAngle is in 3rd quad,go right");
          spot_right(servNo);
        }
      }else if(selfAngle<0){
        if(head_x<tail_x&&head_y>tail_y){
          //SubCase 2: selfAngle is in 2nd Quadrant
          println("selfAngle is in 2nd quad,go right");
          spot_left(servNo);
        }else if(head_x>tail_x&&head_y<tail_y){
          quadrantMatched(ix,iy,servNo);
        }
      }
      break;
      
      default : 
      println("this is default");
      stopBot(servNo);
      break;
  }
}

void merryGoRound(int serv1,int serv2){

  spot_right(serv1);
  right(serv2);
}

void quadrantMatched(float ix,float iy, int servNo){
  if(selfAngle>theta+0.65){
  println("same quad, go left");
  //brake(servNo);
  spot_left(servNo);
  }else if(selfAngle<theta-0.65){
   println("same quad,go right");
   //brake(servNo);
   spot_right(servNo);
  }else if(selfAngle<theta+0.65||selfAngle>theta-0.65){
        if(distSq(centroid_x,centroid_y,ix,iy)>60*60){
        println("now go forward till point");
        //brake(servNo);
        forward(servNo);
        }
         else if(distSq(centroid_x,centroid_y,ix,iy)<=60*60){
         println("Okay stop");
         stopBot(servNo);
      
        } 
    }
      
  }    


/*void choiceLeft(float angle1,float angle2){
  if(abs(angle1-angle2)<=1.047){
    spot_left(serveNo);
  }
  else if(abs(angle1-angle2)>1.047){
    left();
  }
}

void choiceRight(float angle1,float angle2){
  if(abs(angle1-angle2)<=1.047){
    right();
  }
  else if(abs(angle1-angle2)>1.047){
    spot_right(serveNo);
  }
}
*/

}



/*void travelToOrigin(){
  println(head_x-tail_x);
  if(selfAngle>0){
      if(head_x>tail_x){
        if(selfAngle<=PI/4)spot_left(serveNo);
        else if(selfAngle>PI/4)spot_right(serveNo);
      }
      else if(head_x<tail_x){
        if(selfAngle<theta-PI/10||selfAngle>theta+PI/10){
        if(selfAngle<=PI/4)spot_right(serveNo);
        else if(selfAngle>PI/4)spot_left(serveNo);
        }
        else if(selfAngle >=theta-PI/10||selfAngle <=theta+PI/10){
          if(centroid_x<50&&centroid_y<50)forward(serveNo);
          else stop();
        }
        forward(serveNo);
      }
    }
    else if(selfAngle<0){
      float p = -(selfAngle);
      if(head_x<tail_x){
        if(p<=PI/4)spot_right(serveNo);
        else if(p>PI/4)spot_left(serveNo);
      }
      else if(head_y<tail_y){
        if(p<=PI/4)spot_right(serveNo);
        else if(p>PI/4)spot_left(serveNo);
      }
    }
  }*/