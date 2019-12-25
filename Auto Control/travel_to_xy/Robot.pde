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

float deathRadius = 100;

int id;

int p = 0;

int rightCount;
int leftCount;
int forwardCount;

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

void spot_left(){
    server.write("a\n");
    println("spot_left");
}
void spot_right(){
    server.write("d\n");
    println("spot_right");
}

void right(){
    server.write("e\n");
    println("right");  
}

void left(){
    server.write("q\n");
    println("left");  
}

void forward(){
  server.write("w\n");
  println("forward");
}
void stopBot(){
  server.write("z\n");
  println("stop");
}

void alignPerp(){
  //When head_x > tail_x, i.e 1st and 4th quadrant
  if(stopCount>=10)stopBot();
  else if(stopCount<10){
  if(head_x>tail_x){
    if(selfAngle>-1.52&&selfAngle<0)spot_left();
    else if(selfAngle<1.52&&selfAngle>0)spot_right();
    else if(selfAngle<-1.52&&selfAngle<0)stopBot();
    else if(selfAngle>1.52&&selfAngle>0)stopBot();
  }
  else if(head_x<tail_x){
      if(selfAngle>-1.52&&selfAngle<0)spot_left();
    else if(selfAngle<1.52&&selfAngle>0)spot_right();
    else if(selfAngle<-1.52&&selfAngle<0)stopBot();
    else if(selfAngle>1.52&&selfAngle>0)stopBot();
  }
  }
}

void travelToOrigin(){
  //Case 1
  if(selfAngle>0){
    //1st Quadrant
    if(head_x>tail_x){
      println("1st Quadrant,go left");
      spot_left();
    }
    if(head_x<tail_x){
      if(selfAngle>theta + 0.4){
        println("3rd quadrant, go left");
        spot_left();
      }
      else if(selfAngle<theta - 0.4){
        println("3rd quadrant, go right");
        spot_right();
      }
      else if(selfAngle<theta + 0.4||selfAngle>theta-0.4){
        if(centroid_x>=60||centroid_y>=60){
          println("now go forward till origin");
          forward();
        }
        else if(centroid_x<60&&centroid_y<60){
          println("Okay stop");
          stopBot();
        }
      }
    }
  }
  //Case 2
  if(selfAngle<0){
    if(head_x<tail_x&&head_y>tail_y){
      println("2nd Quadrant, go right");
      spot_right();
    }
    if(head_x>tail_x&&head_y<tail_y){
      println("4th Quadrant, go left");
      spot_left();
    }
  }
}

void travelToXY(float ix,float iy){
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
  switch(p){
      case 1://theta is in 1st quadrant
      if(selfAngle>0){
        if(head_x>tail_x){
          //SubCase 1: selfAngle is also in 1st quadrant
          quadrantMatched(ix,iy);
        }else if(head_x<tail_x){
          //SubCase 3: selfAngle is in 3rd Quadrant
          spot_left();
        }
      }else if(selfAngle<0){
        if(head_x<tail_x&&head_y>tail_y){
          //SubCase 2: selfAngle is in 2nd Quadrant
          spot_left();
        }else if(head_x>tail_x&&head_y<tail_y){
          spot_right();
        }
      }
      break;
      
      case 2://theta is in second quadrant
      if(selfAngle>0){
        if(head_x>tail_x){
          //SubCase 1: selfAngle is also in 1st quadrant
          println("selfAngle is in 1st quad,go right");
          spot_right();
        }else if(head_x<tail_x){
          //SubCase 3: selfAngle is in 3rd Quadrant
          println("selfAngle is in 3rd quad,go left");
          spot_left();
        }
      }else if(selfAngle<0){
        if(head_x<tail_x&&head_y>tail_y){
          //SubCase 2: selfAngle is in 2nd Quadrant
          quadrantMatched(ix,iy);
        }else if(head_x>tail_x&&head_y<tail_y){
          println("selfAngle is in 4th quad,go right");
          spot_right();
        }
      }
      break;
      
      case 3:
      if(selfAngle>0){
        if(head_x>tail_x){
          //SubCase 1: selfAngle is also in 1st quadrant
          println("selfAngle is in 1st quad,go right");
          spot_right();
        }else if(head_x<tail_x){
          //SubCase 3: selfAngle is in 3rd Quadrant
          quadrantMatched(ix,iy);
        }
      }else if(selfAngle<0){
        if(head_x<tail_x&&head_y>tail_y){
          //SubCase 2: selfAngle is in 2nd Quadrant
          println("selfAngle is in 3rd quad,go right");
          spot_right();
        }else if(head_x>tail_x&&head_y<tail_y){
          println("selfAngle is in 4th quad,go left");
          spot_left();
        }
      }
      break;
      
      case 4:
      if(selfAngle>0){
        if(head_x>tail_x){
          //SubCase 1: selfAngle is also in 1st quadrant
          println("selfAngle is in 1st quad,go left");
          spot_left();
        }else if(head_x<tail_x){
          //SubCase 3: selfAngle is in 3rd Quadrant
          println("selfAngle is in 3rd quad,go right");
          spot_right();
        }
      }else if(selfAngle<0){
        if(head_x<tail_x&&head_y>tail_y){
          //SubCase 2: selfAngle is in 2nd Quadrant
          println("selfAngle is in 2nd quad,go right");
          spot_left();
        }else if(head_x>tail_x&&head_y<tail_y){
          quadrantMatched(ix,iy);
        }
      }
      break;
      
      default : 
      println("this is default");
      stopBot();
      break;
  }
}
/*
int checkQuadrant(float ix, float iy){
  int p=0;
  
  return p;
}
*/
void quadrantMatched(float ix,float iy){
  if(distSq(centroid_x,centroid_y,ix,iy)>60*60){
  if(selfAngle>theta+0.3){
  println("same quad, go left");
  choiceLeft(theta,selfAngle);
  }else if(selfAngle<theta-0.3){
   println("same quad,go right");
   choiceRight(theta,selfAngle);
  }else if(selfAngle<theta+0.3||selfAngle>theta-0.3){
        println("now go forward till point");
        forward();
    }
  }else if(distSq(centroid_x,centroid_y,ix,iy)<=60*60){
         println("Okay stop");
         stopBot();
        }       
  }    


void choiceLeft(float angle1,float angle2){
  if(abs(angle1-angle2)<=1.047){
    spot_left();
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
    spot_right();
  }
}


}



/*void travelToOrigin(){
  println(head_x-tail_x);
  if(selfAngle>0){
      if(head_x>tail_x){
        if(selfAngle<=PI/4)spot_left();
        else if(selfAngle>PI/4)spot_right();
      }
      else if(head_x<tail_x){
        if(selfAngle<theta-PI/10||selfAngle>theta+PI/10){
        if(selfAngle<=PI/4)spot_right();
        else if(selfAngle>PI/4)spot_left();
        }
        else if(selfAngle >=theta-PI/10||selfAngle <=theta+PI/10){
          if(centroid_x<50&&centroid_y<50)forward();
          else stop();
        }
        forward();
      }
    }
    else if(selfAngle<0){
      float p = -(selfAngle);
      if(head_x<tail_x){
        if(p<=PI/4)spot_right();
        else if(p>PI/4)spot_left();
      }
      else if(head_y<tail_y){
        if(p<=PI/4)spot_right();
        else if(p>PI/4)spot_left();
      }
    }
  }*/