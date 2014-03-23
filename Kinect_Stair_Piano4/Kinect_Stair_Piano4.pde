import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;
import peasy.*;
import java.sql.*;
import java.util.*;
import java.io.*;
 

/**
 * ReadCVS file
 */ 
ReadCVS cvsRead = null;

SimpleOpenNI kinect;
PeasyCam cam;
Minim minim;

/**
 * Peasy Cam Varaibles
 */
float rotateX = 0;
float rotateY = 0;
float s = 1;

/**
 * Hotpoint Boxes
 */
int boxes = 71; // one more then are needed so they start at 1 and run through
Hotpoint[] squareBoxTrigger = new Hotpoint[boxes];
AudioSnippet[] squareBoxAudio = new AudioSnippet[boxes];

int boxHeight = 0;
int boxWidth = 0;
int boxDepth = 0;
int boxRotateX = 0;
int boxRotateY = 0;
int boxRotateZ = 0;
float centerXStage = 0;
float centerYStage = 0;
float centerZStage = 0;

void setup() {
  size(1024, 768, OPENGL);

  
  // load ReadCVS
  cvsRead = new ReadCVS();
  
  // Load Kinect
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.alternativeViewPointDepthToImage();
  
  // create a camera - arguments set point to look ata distance form point of view
  cam = new PeasyCam(this, 0, 0, 0, 1000);
    
  //initialise minim and player
  minim = new Minim(this);
//  String[] notesFileNames = {"1C.wav","2D.wav","3E.wav","4F.wav","5G.wav"};
// String[] notesFileNames = {"3E.wav","2D.wav", "1C.wav","7B.wav","6A.wav","G.wav","F.wav", "E.wav","D.wav", "C.wav"};
//  String[] notesFileNames = {"5G.wav","4F.wav", "3E.wav","2D.wav", "1C.wav","7B.wav","6A.wav","G.wav","F.wav", "E.wav"};
  String[] notesFileNames = {"7B.wav","6A.wav","5G.wav","4F.wav", "3E.wav","2D.wav", "1C.wav","B.wav","A.wav","G.wav","F.wav", "E.wav","D.wav", "C.wav"};  
  // initilialize hotpoints with their origins and size
  for( int i=1, noteFiles=0; i<boxes; i++){
 	squareBoxTrigger[i] = new Hotpoint(centerXStage,centerYStage,centerZStage, boxWidth, boxHeight, boxDepth, boxRotateX, boxRotateY, boxRotateZ);
        
        if(noteFiles<notesFileNames.length){
          squareBoxAudio[i] = minim.loadSnippet(notesFileNames[noteFiles]);
          //noteFiles += 1;
        }
        else
        {
          noteFiles = 0;
          squareBoxAudio[i] = minim.loadSnippet(notesFileNames[noteFiles]);
        }
        noteFiles += 1;
  }  
}

void draw() {
  background(0); 
  kinect.update();
  
  PImage rgbImage = kinect.rgbImage();
  PImage depthImage = kinect.depthImage();
  rotateX(radians(180));
  
  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();

  
  for(int i = 0; i < depthPoints.length; i+=3)
  {
    PVector currentPoint = depthPoints[i];
    // have each hotpoint check to see if it includes the current point
    for( int j=1; j<boxes; j++){
      squareBoxTrigger[j].check(currentPoint);
    }
    

    //stroke(depthImage.pixels[i]);
    stroke(rgbImage.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z); 
  }
  
  
  for( int i=1; i<boxes; i++){
    // play audio for each box that is hit
    if(squareBoxTrigger[i].isHit()){squareBoxAudio[i].play();}
    if(!squareBoxAudio[i].isPlaying()){squareBoxAudio[i].rewind();}
    
    // display each hotpoint and clear it's points
    squareBoxTrigger[i].draw();
    squareBoxTrigger[i].clear();   
  }
  
}

/**
 * Stop Audio Snippets
 */
void stop()
{
  // make sure to close
  // both audioplayer objects
  for( int i=1; i<boxes; i++){
    squareBoxAudio[i].close();
  } 
  minim.stop();
  super.stop();
}
  
  
/**
 * use keys to control zoom, up arrow zooms in, down out, s gets passed to scale
 */  
void keyPressed(){
  if(keyCode == 38){
    s = s + 0.01;
  }
  else if(keyCode == 40) {
    s = s - 0.01; 
  } else {
		switch (key) {
//		case 'R':
//			readBumperFromMySQL();
//			break;
                case 'C':
			cvsRead.checkCVS();
			break;
                default:
			break; 


                }
  }
}

/**
 * mouseDragged
 * translate mouse movements to camera view
 */ 
void mouseDragged() {
  rotateX += (mouseX - pmouseX) * 0.01;
  rotateY -= (mouseY - pmouseY) * 0.01;
}


