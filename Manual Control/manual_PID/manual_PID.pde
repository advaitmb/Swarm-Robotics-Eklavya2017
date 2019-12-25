import java.net.InetAddress;
import processing.net.*;
InetAddress inet;

int pwmS = 450;
int pwmL = 850;

String myIP;

Server server1;
Server server2;

void setup()
{
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
  size(400,200);
}

void draw(){
  
  //Client client = server.available();
 /*
 if(client!= null)
 {
   print("Client Connected");
 }
*/
}
int keyCount = 0;
void keyPressed()
{
  if(key=='b'){
    server1.write("b\n");
  
  }
  
    if(key=='b'){
    server2.write("b\n");
  
  }
  if(key=='w')
  {
    server1.write("w\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("forward");
  } 
  
  if(key=='a')
  {
    server1.write("a\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("spot_left");
  } 
  
  if(key=='s')
  {
    server1.write("s\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("back");
  } 
  
  if(key=='d')
  {
    server1.write("d\n");
    println("spot_right");
  } 
  
    if(key=='e')
  {
    server1.write("e\n");
    //server.write(str(pwmL)+"\n");
    //server.write(str(pwmS)+"\n");
    println("right");
  } 
  
    
    if(key=='q')
  {
    server1.write("q\n");
    //server.write(str(pwmL)+"\n");
    //server.write(str(pwmS)+"\n");
    println("left");
  }
  
  if(key=='w')
  {
    server2.write("w\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("forward");
  } 
  
  if(key=='a')
  {
    server2.write("a\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("spot_left");
  } 
  
  if(key=='s')
  {
    server2.write("s\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("back");
  } 
  
  if(key=='d')
  {
    server2.write("d\n");
    println("spot_right");
  } 
  
    if(key=='e')
  {
    server2.write("e\n");
    //server.write(str(pwmL)+"\n");
    //server.write(str(pwmS)+"\n");
    println("right");
  } 
  
    
    if(key=='q')
  {
    server2.write("q\n");
    //server.write(str(pwmL)+"\n");
    //server.write(str(pwmS)+"\n");
    println("left");
  }
}


void keyReleased(){
  server1.write("z\n");
  server2.write("z\n");
  //server.write(str(pwmS)+"\n");
  //server.write(str(pwmS)+"\n");
}