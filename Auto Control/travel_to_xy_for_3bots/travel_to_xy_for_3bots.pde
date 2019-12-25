  import processing.video.*;
import java.net.InetAddress.*;
import processing.net.*;

//float theta = PI/2;
int countFaltugiri=1;
//Internet Part
InetAddress inet;
Server server1;
Server server2;
String myIP;

//Used to start the process
float accessCount=0;

//Boolean variable to check if bots are about to collide
boolean collision = false;

//This is the ID for pixel detection for R G or B
int currentId=1;

//Blobs
Blob r;
Blob g;
Blob b;

//Bots
Robot red;
Robot green;
Robot blue;

//Video Object
Capture video;

//Track Color variables
color trackColorR;
color trackColorB;
color trackColorG;

//The thresholds
float blueThreshold = 15;
float greenThreshold = 15;  //This is the color threshold
float redThreshold = 15;

float distThreshold = 25;

//array lists of blobs
ArrayList<Blob> blobsR = new ArrayList<Blob>();
ArrayList<Blob> blobsG = new ArrayList<Blob>();
ArrayList<Blob> blobsB = new ArrayList<Blob>();

float blah,bluh;

//Setup function
void setup() {
  red = new Robot();
  green = new Robot();
  blue = new Robot();
  
  size(640,480);
  
  //Wifi Setup
  frameRate(60);
    try {
      inet = InetAddress.getLocalHost();
      myIP = inet.getHostAddress();
    }
    catch (Exception e) {
      e.printStackTrace();
      myIP = "couldnt get IP"; 
    }
    println(myIP);
    server1 = new Server(this, 8080);
    server2 = new Server(this,8081);
    
  //Camera setup
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[15]);
  video.start();
  
  //Initializing Track colours
  trackColorR = color(230, 0, 0);  //Change here
  
  trackColorG = color(0, 255, 0);
  trackColorB = color(0, 0, 255);
  
  red.id = 1;
  green.id = 2;
  blue.id = 3;
}

//Trigger event
void captureEvent(Capture video) {
  video.read();
}

void draw() {
  
  //if(begin==1){
 /* Client client = server.available();
  
  if(client!= null)jjjjjjj
   {  ssssssss
     println("Client Connected");
   }*/
  blobsR.clear();
  blobsG.clear();
  blobsB.clear(); 
  
  //clear();
  //Start video
  video.loadPixels();
  image(video,0,0);
  
  //clear blobs
 
  

  //Set color threshold

  if(accessCount>=1){
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
     
      float r2 = red(trackColorR);
      float g2 = green(trackColorR);
      float b2 = blue(trackColorR);
      
      float r3 = red(trackColorG);
      float g3 = green(trackColorG);
      float b3 = blue(trackColorG);
      
      float r4 = red(trackColorB);
      float g4 = green(trackColorB);
      float b4 = blue(trackColorB);

      float dR = distSq(r1, g1, b1, r2, g2, b2); 
      float dG = distSq(r1, g1, b1, r3, g3, b3); 
      float dB = distSq(r1, g1, b1, r4, g4, b4); 
      
      //Making Red Blobs
      if (dR < redThreshold*redThreshold) {
        boolean found = false;
        for(Blob r: blobsR)
        {
          if(r.isNear(x,y)){
            r.add(x,y);
            found = true;
            break;
          }
        }
        
        if(!found)
        {
          Blob r = new Blob(x,y);
          blobsR.add(r);
        }
      }
      
      //Making Green Blobs
      if (dG < greenThreshold*greenThreshold) {
        boolean found = false;
        for(Blob g: blobsG)
        {
          if(g.isNear(x,y)){
            g.add(x,y);
            found = true;
            break;
          }
        }
        
        if(!found)
        {
          Blob g = new Blob(x,y);
          blobsG.add(g);
        }
      }
      
      //Making Blue Blobs
      if (dB < blueThreshold*blueThreshold) {
        boolean found = false;
        for(Blob b: blobsB)
        {
          if(b.isNear(x,y)){
            b.add(x,y);
            found = true;
            break;
          }
        }
        
        if(!found)
        {
          Blob b = new Blob(x,y);
          blobsB.add(b);
        }
      }
   
    }
  }
  //For red color
  
   int i =0;
   for(Blob r : blobsR){
   //fill(255,0,0);
   
   r.calcCen();
   red.co_storX[i] = r.cenx;
   red.size_storX[i] = r.maxx - r.minx;
   red.co_storY[i] = r.ceny;
   red.size_storY[i] = r.maxy - r.miny;
   i++;
   r.show(); 
   
 //}
 
    int k =0;
   for(Blob g : blobsG){
   //fill(255,0,0);
   
   g.calcCen();
   green.co_storX[k] = g.cenx;
   green.size_storX[k] = g.maxx - g.minx;
   green.co_storY[k] = g.ceny;
   green.size_storY[k] = g.maxy - g.miny;
   k++;
   g.show(); 
   
 }
 //For Blue color
 
   int j = 0;
   for(Blob b : blobsB){
   
   b.calcCen();
   blue.co_storX[j] = b.cenx;
   blue.size_storX[j] = b.maxx - b.minx;
   blue.co_storY[j] = b.ceny;
   blue.size_storY[j] = b.maxy - b.miny;
   j++;
   b.show(); 
   }
  }
  
   //Position assign for Red
   red.trackTheta(mouseX,mouseY);
   red.angle();
   red.assign();
   
   //Position assign for Green
   green.trackTheta(mouseX,mouseY);
   green.angle();
   green.assign();

   //Position assign for Blue     
   /*blue.trackTheta(mouseX,mouseY);
   blue.angle();
   blue.assign();
   */
   
     if(blobsG.size()<=2){
       println("Red:");
       green.travelToXY(mouseX,mouseY,green.id);
     }else if(blobsR.size()>2){
       red.stopBot(red.id);
     }
          println("Green:");
     if(blobsR.size()<=2){
       red.travelToXY(mouseX,mouseY,red.id);
     }else if(blobsR.size()>2){
       red.stopBot(red.id);
     }
   }
  }
 /*  if(checkCollision()==false){

   
     /*println("Blue:");
     blue.travelToXY(mouseX,mouseY);
   }
   else{
     avoidCollision();
   }*/
   
 


float distSq(float x1, float y1, float x2, float y2)
{
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}
float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

float calcSize(float x,float y){
  return x*y;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  if(currentId==1){
  int loc = mouseX + mouseY*video.width;
  trackColorR = video.pixels[loc];
  currentId = green.id;
  }
  
  else if(currentId==2){
  int loc = mouseX + mouseY*video.width;
  trackColorG = video.pixels[loc];
  currentId = red.id;
  }
  
  /*else if(currentId==3){
  int loc = mouseX + mouseY*video.width;
  trackColorB = video.pixels[loc];
  currentId = red.id;
  }*/
}

boolean checkCollision(){
  if(distSq(red.centroid_x,red.centroid_y,green.centroid_x,green.centroid_y)<20*20 ){
    collision = true;
  }
  else {
    collision = false;
  }
  return collision;
}

//Obstacle Avoidance Program
void avoidCollision(){
   //Check proximity for red with blue and green
   if(distSq(red.centroid_x,red.centroid_y,green.centroid_x,green.centroid_y)<20*20) /*distSq(red.centroid_x,red.centroid_y,blue.centroid_x,blue.centroid_y)>40*40
   && distSq(green.centroid_x,green.centroid_y,blue.centroid_x,blue.centroid_y)>40*40)*/{
     println("hagla");
     if(red.centroid_x>green.centroid_x){
       red.right(red.id);
       green.left(green.id);
       //blue.travelToXY(mouseX,mouseY);
     }else if(red.centroid_x>green.centroid_x){
       red.left(red.id);
       green.right(green.id);
       //blue.travelToXY(mouseX,mouseY);
     }
   }/*
     }else if(distSq(red.centroid_x,red.centroid_y,green.centroid_x,green.centroid_y)<=40*40 && distSq(red.centroid_x,red.centroid_y,blue.centroid_x,blue.centroid_y)<=40*40 && 
     distSq(green.centroid_x,green.centroid_y,blue.centroid_x,blue.centroid_y)<=40*40){
           println("hagla");
     if(red.centroid_x>green.centroid_x){
       red.right();
       green.left();
       blue.stopBot();
     }else if(red.centroid_x>green.centroid_x){
       red.left();
       green.right();
       blue.stopBot();  
     }
     
   }else if(distSq(red.centroid_x,red.centroid_y,blue.centroid_x,blue.centroid_y)<40*40){
     println("hagla");
     red.spot_left();
     green.travelToXY(mouseX,mouseY);
     blue.stopBot();
   }else if(distSq(blue.centroid_x,blue.centroid_y,green.centroid_x,green.centroid_y)<40*40){
     println("hagla");
     red.travelToXY(mouseX,mouseY);
     green.spot_right();
     blue.stopBot();
   }
   */
}

void keyPressed(){
  accessCount = 1;
  currentId=1;
  if(key=='j'){
    redThreshold--;

  } else if(key=='k'){
    redThreshold++;
  
  }else if(key=='o'){
    blueThreshold--;
  } else if(key=='p'){
    blueThreshold++;
  }else if(key=='n'){
    greenThreshold--;
    
  } else if(key=='m'){
    greenThreshold++;
  }
  else if(key=='s'){
    accessCount=0;
    red.stopBot(red.id);
    //red.stopBot();
    green.stopBot(green.id);
    //green.stopBot();
    //blue.stopBot();
  }
}




//Arrays to store co-ordinates for blobs' centoids
/*float[] co_storxR = new float[100];
float[] co_storyR = new float[100];

float[] co_storxG = new float[100];
float[] co_storyG = new float[100];

float[] co_storxB = new float[100];
float[] co_storyB = new float[100];*/