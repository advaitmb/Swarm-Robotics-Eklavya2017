import processing.video.*;



Capture video;

color c;



void setup(){
  String[]cameras = Capture.list();
  size(640,480);
  video = new Capture(this,cameras[3]);
  video.start();
  
  colorMode(HSB,360,100,100);
}

void captureEvent(Capture video){
  video.read();
}

void draw(){
  
  video.loadPixels();
  image(video,0,0);
  colorMode(HSB,360,100,100);
  c=get(mouseX,mouseY);
  println("hue: "+hue(c));
  println("saturation: "+saturation(c));
  println("brightness: "+brightness(c));
}