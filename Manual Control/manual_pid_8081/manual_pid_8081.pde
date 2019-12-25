import java.net.InetAddress;
import processing.net.*;
InetAddress inet;

int pwmS = 450;
int pwmL = 850;

String myIP;

Server server;

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
  server = new Server(this, 8081); 
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
  
  if(key=='w')
  {
    server.write("w\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("forward");
  } 
  
  if(key=='a')
  {
    server.write("a\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("spot_left");
  } 
  
  if(key=='s')
  {
    server.write("s\n");
    //server.write(str(pwmS)+"\n");
    //server.write(str(pwmS)+"\n");
    println("back");
  } 
  
  if(key=='d')
  {
    server.write("d\n");
    println("spot_right");
  } 
  
    if(key=='e')
  {
    server.write("e\n");
    //server.write(str(pwmL)+"\n");
    //server.write(str(pwmS)+"\n");
    println("right");
  } 
  
    
    if(key=='q')
  {
    server.write("q\n");
    //server.write(str(pwmL)+"\n");
    //server.write(str(pwmS)+"\n");
    println("left");
  }

}


void keyReleased(){
  server.write("z\n");
  //server.write(str(pwmS)+"\n");
  //server.write(str(pwmS)+"\n");
}