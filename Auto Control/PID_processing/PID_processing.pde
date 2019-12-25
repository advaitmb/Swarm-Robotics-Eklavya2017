import processing.video.*;
import java.net.InetAddress.*;
import processing.net.*;

//float theta = PI/2;
int countFaltugiri=1;
//Internet Part
InetAddress inet;
Server server;
String myIP;

float accessCount=0;


float begin=0;

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
float threshold = 30;  //This is the color threshold
float distThreshold = 25;

//array lists of blobs
ArrayList<Blob> blobsR = new ArrayList<Blob>();
ArrayList<Blob> blobsG = new ArrayList<Blob>();
ArrayList<Blob> blobsB = new ArrayList<Blob>();

//Arrays to store co-ordinates for blobs' centoids
/*float[] co_storxR = new float[100];
float[] co_storyR = new float[100];

float[] co_storxG = new float[100];
float[] co_storyG = new float[100];

float[] co_storxB = new float[100];
float[] co_storyB = new float[100];*/

float blah,bluh;

//Setup function
void setup() {
  red = new Robot();
  green = new Robot();
  blue = new Robot();
  
  size(640, 480);
  
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
    server = new Server(this, 8080); 
    
  //Camera setup
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[15]);
  video.start();
  
  //Initializing Track colours
  trackColorR = color(255, 0, 0);
  trackColorG = color(0, 255, 0);
  trackColorB = color(0, 0, 255);
}

//Trigger event
void captureEvent(Capture video) {
  video.read();
}

void draw() {
  
  
 /* Client client = server.available();
  
  if(client!= null)
   {  
     println("Client Connected");
   }
   */
     //Start video
  video.loadPixels();
  image(video, 0, 0);
  
  //Set color threshold
  threshold = 20;
   
  if(accessCount==1){ 
  blobsR.clear();
  blobsG.clear();
  blobsB.clear(); 
  
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
      if (dR < threshold*threshold) {
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
      if (dG < threshold*threshold) {
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
      if (dB < threshold*threshold) {
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
   red.co_storY[i] = r.ceny;
   i++;
   r.show(); 
   
 }
 
    int k =0;
   for(Blob g : blobsG){
   //fill(255,0,0);
   if(r.size()>30){
   g.calcCen();
   red.co_storX[k] = g.cenx;
   red.co_storY[k] = g.ceny;
   k++;
   g.show(); 
   }
 }
 //For Blue color
 
   int j = 0;
   for(Blob b : blobsB){
     if(r.size()>30){
     //fill(255);
     b.calcCen();
     blue.co_storX[j] = b.cenx;
     blue.co_storY[j] = b.ceny;
     j++;
     b.show();
     }
 }
  red.trackTheta(0,0);
  red.assign();
 //Traversing function
 
  red.travelToOrigin();
 
 
/* 
 red.trackTheta();
 green.trackTheta();
 blue.trackTheta();

 
 //Centroid and self Angle for red Color 
  red.assign();
  blue.assign();
  green.assign();
  
*/
  }
}

float distSq(float x1, float y1, float x2, float y2)
{
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

float distSqRt(float x1, float y1, float x2, float y2)
{
  float d = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
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
  int loc = mouseX + mouseY*video.width;
  trackColorR = video.pixels[loc];
  
}

void keyPressed(){
  accessCount = 1;
}