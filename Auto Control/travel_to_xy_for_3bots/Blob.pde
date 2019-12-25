class Blob
{
 float x,y,minx,miny,maxx,maxy;
 float[] xc;
 float[] yc;
 float cenx;
 float ceny;
 
 Blob(float x,float y)
 {
   minx = x;
   miny = y;
   maxx = x;
   maxy = y;
 }
 
float size()
{
  return abs((maxx-minx)*(maxy-miny));
}
 
/* void getCordinates(float a, float b)
 {
  int i =0;
  xc = new float[2];
  xc[i] = a;
  yc = new float[2];
  yc[i] = b;
  println(xc[i]+","+yc[i]);
  i++;
 }*/
 
  void show()
 {
   //stroke(0);
   //fill(255);
   //strokeWeight(2);
   rectMode(CORNERS);
   rect(minx,miny,maxx,maxy);
 }
 
 
 void add(float x,float y)
 {
   minx = min(x,minx);
   miny = min(y,miny);
   maxx = max(x,maxx);
   maxy = max(y,maxy);
 }

 boolean isNear(float x,float y)
 {
     float cx = (maxx + minx)/2;
     float cy = (maxy+ miny)/2;
     
     float d = distSq(cx,cy,x,y);
     if(d<distThreshold*distThreshold) return true;
     else return false;
 }
 
 void calcCen()
 {
   cenx = (maxx + minx)/2;
   ceny = (maxy + miny)/2;
 }
}