import java.net.InetAddress;
import processing.net.*;

float avgX;
float avgY;

  
  int count1;
  //int count2;
  float x_co;
  float y_co;
  // Declare a server


  void temporary()
  {
   if(count1%60 == 0){
   server.write(mouseX+","+mouseY+"\n");
   }
  }