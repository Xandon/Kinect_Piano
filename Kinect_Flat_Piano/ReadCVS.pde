public class ReadCVS {
  
  
  public void ReadCVS() {

  }
  
  public void checkCVS(){
	BufferedReader br = null;
	String line = "";
	String cvsSplitBy = ",";
        String csvFile = "boxes.tab";
 
	try {
 
		//br = new BufferedReader(new FileReader(csvFile));
                br = createReader(csvFile);
		while ((line = br.readLine()) != null) {
 
		        // use comma as separator
			String[] boxvalue = split(line, TAB);
                        int bumperN = int(boxvalue[0]);
			int bumperNcenterXStage = int(boxvalue[1]);
			int bumperNcenterYStage = int(boxvalue[2]);
			int bumperNcenterZStage = int(boxvalue[3]);
			int bumperNboxWidth = int(boxvalue[4]);
			int bumperNboxHeight = int(boxvalue[5]);
			int bumperNboxDepth = int(boxvalue[6]);
			int bumperNboxRotateX = int(boxvalue[7]);
			int bumperNboxRotateY = int(boxvalue[8]);
			int bumperNboxRotateZ = int(boxvalue[9]);
                        
 
			System.out.println("Box Value [code= " + boxvalue[0] + " , " + boxvalue[1] + " , " + boxvalue[2] + " , " + boxvalue[3] + " , " + boxvalue[4] + " , " +
                                            boxvalue[5] + " , " +boxvalue[6] + " , " +boxvalue[7] + " , " +boxvalue[8] + " , " +boxvalue[9] +"]");
                                            
                                            
                        System.out.println(bumperN + "\t" + bumperNcenterXStage + "\t" + bumperNcenterYStage + "\t" + bumperNcenterZStage + "\t" + 
		                        bumperNboxWidth + "\t" + bumperNboxHeight + "\t" + bumperNboxDepth + "\t" + bumperNboxRotateX + "\t" + bumperNboxRotateY + "\t" + bumperNboxRotateZ);


                                 
                         if(bumperN < boxes){
				squareBoxTrigger[bumperN].setSize(bumperNboxWidth, bumperNboxHeight, bumperNboxDepth);
				squareBoxTrigger[bumperN].setCenter(bumperNcenterXStage, bumperNcenterYStage, bumperNcenterZStage);
				squareBoxTrigger[bumperN].setRotateXYZVal(bumperNboxRotateX, bumperNboxRotateY, bumperNboxRotateZ);
				System.out.println("LINE "+bumperN+" READ");
                         }
 
		}
 
	} catch (FileNotFoundException e) {
		e.printStackTrace();
	} catch (IOException e) {
		e.printStackTrace();
	} finally {
		if (br != null) {
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
 
	System.out.println("Done");
  }
 
}
