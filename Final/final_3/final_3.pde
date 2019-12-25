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

boolean trueRed;
boolean trueGreen;
boolean trueBlue;

//What to do
boolean xy;
boolean origin;

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
float redHueThreshold = 2;
float greenHueThreshold = 2;
float blueHueThreshold = 2;

float redSaturationThreshold = 10;
float greenSaturationThreshold = 10;
float blueSaturationThreshold = 10;

float redBrightnessThreshold = 15;
float greenBrightnessThreshold = 15;
float blueBrightnessThreshold = 15;


float distThreshold = 25;

//array lists of blobs
ArrayList<Blob> blobsR = new ArrayList<Blob>();
ArrayList<Blob> blobsG = new ArrayList<Blob>();
ArrayList<Blob> blobsB = new ArrayList<Blob>();

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
  colorMode(HSB,360,100,100);
  trackColorR = color(0, 50, 50);  //Change here
  colorMode(HSB,360,100,100);
  trackColorG = color(120,50,50);
  colorMode(HSB,360,100,100);
  trackColorB = color(240, 0, 0);
  
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
  
  if(client!= null)
   { 
     println("Client Connected");
   }*/
  blobsR.clear();
  blobsG.clear();
  blobsB.clear(); 
  
  //clear();
  //Start video
  video.loadPixels();
  image(video,0,0);

  if(accessCount>=1){
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float h1 = hue(currentColor);
      float s1 = saturation(currentColor);
      float b1 = brightness(currentColor);
     
      float h2 = hue(trackColorR);
      float s2 = saturation(trackColorR);
      float b2 = brightness(trackColorR);
      
      float h3 = hue(trackColorG);
      float s3 = saturation(trackColorG);
      float b3 = brightness(trackColorG);
      
      float h4 = hue(trackColorB);
      float s4 = saturation(trackColorB);
      float b4 = brightness(trackColorB);

      /*float dR = distSq(r1, g1, b1, r2, g2, b2); 
      float dG = distSq(r1, g1, b1, r3, g3, b3); 
      float dB = distSq(r1, g1, b1, r4, g4, b4);*/
      
      if(h2>2){
      if(abs(h2-h1)<redHueThreshold && abs(s2-s1)<redSaturationThreshold &&abs(b2-b1)<redBrightnessThreshold){
        trueRed = true;
      }else trueRed = false;
      }else trueRed = false;
      
      if(h3>2){
      if(abs(h3-h1)<greenHueThreshold && abs(s3-s1)<redSaturationThreshold && abs(b3-b1)<greenBrightnessThreshold){
        trueGreen = true;
      }else trueGreen = false;
      }else trueGreen = false;
      
      if(h4>2){
      if(abs(h4-h1)<blueHueThreshold && abs(s4-s1)<redSaturationThreshold &&abs(b4-b1)<blueBrightnessThreshold){
        trueBlue = true;
      }else trueBlue = false;
      }else trueBlue = false;
      
      //Making Red Blobs
      if (trueRed) {
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
      if (trueGreen) {
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
      if (trueBlue) {
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
   for(int smallBlobs=blobsR.size()-1;smallBlobs>=0;smallBlobs--){
     if(blobsR.get(smallBlobs).size()<10){
       blobsR.remove(smallBlobs);
     }
   }
   for(int smallBlobs=blobsG.size()-1;smallBlobs>=0;smallBlobs--){
     if(blobsG.get(smallBlobs).size()<10){
       blobsG.remove(smallBlobs);
     }
   }
   for(int smallBlobs=blobsB.size()-1;smallBlobs>=0;smallBlobs--){
     if(blobsB.get(smallBlobs).size()<10){
       blobsB.remove(smallBlobs);
     }
   }
   int i =0;
   for(Blob r : blobsR){
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
  
     

   
   //red.merryGoRound(green.id,red.id);

   //Position assign for Blue     
   /*blue.trackTheta(mouseX,mouseY);
   blue.angle();
   blue.assign();
   */
   
   blue.angle();
   blue.assign();
   //Position assign for Red
   red.trackTheta(mouseX,mouseY);
   red.angle();
   red.assign();
   
   //Position assign for Green
   green.trackTheta(mouseX,mouseY);
   green.angle();
   green.assign();
   
   if(checkCollision()==false){
     
     
     if(blobsR.size()<=2){
       println("Red:");
       println("redTheta: "+red.theta);
       println("redselfAngle: "+red.selfAngle);
       red.travelToXY(mouseX,mouseY,red.id);
     }else if(blobsR.size()==2){
       red.stopBot(red.id);
     }
  
     
     
     if(blobsG.size()==2){
       println("Green:");
       println("GreenTheta: "+green.theta);
       println("GreenTselfAngle: "+green.selfAngle);
       green.travelToXY(mouseX,mouseY,green.id);
     }else if(blobsR.size()!=2){
       green.stopBot(green.id);
     }
 
   }
   else{
     avoidCollision();
   }
  //End of travel to XY
  
   if(origin){
     blue.angle();
     blue.assign();
     //Position assign for Red
     red.trackTheta(0,0);
     red.angle();
     red.assign();
   
     //Position assign for Green
     green.trackTheta(0,0);
     green.angle();
     green.assign();
     if(checkCollision()==false){
       red.travelToOrigin(red.id);
       green.travelToOrigin(green.id);
     }else avoidCollision();
   }//End of travel to XY
   
 }

}


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
  colorMode(HSB,350,100,100);
  trackColorR = video.pixels[loc];
  currentId = green.id;
  }
  
  else if(currentId==2){
  int loc = mouseX + mouseY*video.width;
  colorMode(HSB,350,100,100);
  trackColorG = video.pixels[loc];
  currentId = blue.id;
  }
  
  else if(currentId==3){
  int loc = mouseX + mouseY*video.width;
  colorMode(HSB,350,100,100);
  trackColorB = video.pixels[loc];
  currentId = red.id;
  }
}

boolean checkCollision(){
  if(distSq(red.centroid_x,red.centroid_y,green.centroid_x,green.centroid_y)<80*80 ){
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
   if(distSq(red.centroid_x,red.centroid_y,green.centroid_x,green.centroid_y)<80*80) /*distSq(red.centroid_x,red.centroid_y,blue.centroid_x,blue.centroid_y)>40*40
   && distSq(green.centroid_x,green.centroid_y,blue.centroid_x,blue.centroid_y)>40*40)*/{
     println("hagla");
     if(red.centroid_x>green.centroid_x && red.centroid_y<green.centroid_y){
       red.right(red.id);
       green.stopBot(green.id);
       //blue.travelToXY(mouseX,mouseY);
     }else if(red.centroid_x<green.centroid_x&&red.centroid_y<green.centroid_y){
       red.left(red.id);
       green.stopBot(green.id);
       //blue.travelToXY(mouseX,mouseY);
     }else if(red.centroid_x>green.centroid_x && red.centroid_y>green.centroid_y){
       red.left(red.id);
       green.stopBot(green.id);
     }else if(red.centroid_x<green.centroid_x && red.centroid_y>green.centroid_y){
       red.right(red.id);
       green.stopBot(green.id);
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
  if(key=='o'){
    redSaturationThreshold--;

  } else if(key=='p'){
    redSaturationThreshold++;
  
  }else if(key=='n'){
    blueSaturationThreshold--;
  } else if(key=='m'){
    blueSaturationThreshold++;
  }else if(key=='j'){
    greenSaturationThreshold--;
    
  } else if(key=='k'){
    greenSaturationThreshold++;
  }else if(key=='1'){
    redBrightnessThreshold--;

  } else if(key=='2'){
    redBrightnessThreshold++;
  
  }else if(key=='3'){
    greenBrightnessThreshold--;
  } else if(key=='4'){
    greenBrightnessThreshold++;
  }else if(key=='5'){
    blueBrightnessThreshold--;
    
  } else if(key=='6'){
    blueBrightnessThreshold++;
  }else if(key=='s'){
    accessCount=0;
    red.stopBot(red.id);
    green.stopBot(green.id);
  }else if(key=='u'){
    origin = true;
  }else if(key=='i'){
    origin=false;
  }else if(key=='x'){
    xy = true;
  }else if(key == 'y'){
    xy = false;
  }
}