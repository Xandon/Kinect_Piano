import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;
import peasy.*;
import java.sql.*;
import java.util.*;
import java.io.*;

///**
// *Conf Properties variables
// */
//Properties conf;
//public String url,dbName,driver,userName,password;
//
//
///**
// * MySQL variables
// */             
//Connection conn = null;  

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
int boxes = 26; // one more then are needed so they start at 1 and run through
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
  
//  // load MySQL configuration file
//  try {
//    conf=new Properties();
//    //conf.load(openStream(sketchPath("localhostWarp.conf")));
//    conf.load(openStream(sketchPath("localhostPianoBoxes.conf")));
//    url=conf.getProperty("url");
//    dbName=conf.getProperty("dbName");
//    driver=conf.getProperty("driver");
//    userName=conf.getProperty("userName");
//    password=conf.getProperty("password");
//    println(url); 
//  }   
//    catch (Exception e) {
//    die("Problem reading SquareBoxes.conf: "+e.toString());
//  } 
//  
//  
//  // Connect to MySQL
//  openConnectionToMySQL();
  
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
  //String[] notesFileNames = {"1C.wav","2D.wav","3E.wav","4F.wav","5G.wav"};
  String[] notesFileNames = {"5G.wav","4F.wav", "3E.wav","2D.wav", "1C.wav"};
  
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
//
///**
// * MySQL
// */
//void openConnectionToMySQL() {
//	try {
//		Class.forName(driver).newInstance();
//		conn = DriverManager.getConnection(url+dbName,userName,password);
//		System.out.println("Connected to the database");
//	} catch (Exception e) {
//		e.printStackTrace();
//	}
//}
//
//void closeConnectionToMySQL() {
//	try{
//		conn.close();
//		System.out.println("Disconnected from database");
//	}
//	catch (SQLException s){
//		s.printStackTrace();
//		System.out.println("SQL code does not execute.");
//	}
//}
//
//void readBumperFromMySQL() {          
//	try{
//		Statement st = conn.createStatement();
//		ResultSet res = st.executeQuery("SELECT * FROM  SquareBoxes");
//		System.out.println("SquareBoxes: " + "\t" + "CXS: " + "\t" + "CYS " + "\t" + "CZS: ");
//		while (res.next()) {
//
//			int bumperN = res.getInt("Bumper");
//			int bumperNcenterXStage = res.getInt("centerXStage");
//			int bumperNcenterYStage = res.getInt("centerYStage");
//			int bumperNcenterZStage = res.getInt("centerZStage");
//			int bumperNboxWidth = res.getInt("boxWidth");
//			int bumperNboxHeight = res.getInt("boxHeight");
//			int bumperNboxDepth = res.getInt("boxDepth");
//			int bumperNboxRotateX = res.getInt("boxRotateX");
//			int bumperNboxRotateY = res.getInt("boxRotateY");
//			int bumperNboxRotateZ = res.getInt("boxRotateZ");
//			System.out.println(bumperN + "\t" + bumperNcenterXStage + "\t" + bumperNcenterYStage + "\t" + bumperNcenterZStage + "\t" + 
//					bumperNboxWidth + "\t" + bumperNboxHeight + "\t" + bumperNboxDepth + "\t" + bumperNboxRotateX + "\t" + bumperNboxRotateY + "\t" + bumperNboxRotateZ);
//
//			if(bumperN < boxes){
//				squareBoxTrigger[bumperN].setSize(bumperNboxWidth, bumperNboxHeight, bumperNboxDepth);
//				squareBoxTrigger[bumperN].setCenter(bumperNcenterXStage, bumperNcenterYStage, bumperNcenterZStage);
//				squareBoxTrigger[bumperN].setRotateXYZVal(bumperNboxRotateX, bumperNboxRotateY, bumperNboxRotateZ);
//				System.out.println("LINE "+bumperN+" READ");
//			}
//		}
//		System.out.println("Read Ok");
//	}
//	catch (SQLException s)
//	{
//		s.printStackTrace();
//		System.out.println("SQL statement is not executed!");
//	}
//}

