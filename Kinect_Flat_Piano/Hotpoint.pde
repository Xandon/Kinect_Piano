/**
 * 131215
 */

/**
 * @author Xandon Frogget
 * Hotpoint
 */
public class Hotpoint {

	public PVector center;
	public color fillColor;
	public color strokeColor;
	//int size;
	public int sizeW;
	public int sizeH;
	public int sizeD;
	public float centerX;
	public float centerY;
	public float centerZ;
	public int rotateXVal;
	public int rotateYVal;
	public int rotateZVal;
	public int pointsIncluded;
	public int maxPoints;
	public boolean wasJustHit;
	public int threshold;

	/**
	 * Hotpoint Constructor
	 * @param centerX
	 * @param centerY
	 * @param centerZ
	 * @param sizeW
	 * @param sizeH
	 * @param sizeD
	 * @param rotateXVal
	 * @param rotateYVal
	 * @param rotateZVal
	 * @param center
	 * @param fillColor
	 * @param strokeColor
	 * @param pointsIncluded
	 * @param maxPoints
	 * @param threshold
	 */
	public Hotpoint(float centerX, float centerY, float centerZ, int sizeW,
			int sizeH, int sizeD, int rotateXVal, int rotateYVal,
			int rotateZVal) {
		this.centerX = centerX;
		this.centerY = centerY;
		this.centerZ = centerZ;
		this.sizeW = sizeW;
		this.sizeH = sizeH;
		this.sizeD = sizeD;
		this.rotateXVal = rotateXVal;
		this.rotateYVal = rotateYVal;
		this.rotateZVal = rotateZVal;
		center = new PVector(centerX, centerY, centerZ);
		fillColor = strokeColor = color(0,255,0);
		pointsIncluded = 0;
		maxPoints = 1000;
		threshold = 10;
	}

	/**
	 * setThreshold
	 * @param threshold
	 */

	public void setThreshold(int threshold){
		this.threshold = threshold;
	}

	/**
	 * setSize
	 * @param sizeW
	 * @param sizeH
	 * @param sizeD
	 */

	public void setSize(int sizeW, int sizeH, int sizeD){
		this.sizeW = sizeW;
		this.sizeH = sizeH;
		this.sizeD = sizeD;
	}

	/**
	 * setCenter
	 * @param centerX
	 * @param centerY
	 * @param centerZ
	 */

	public void setCenter(float centerX, float centerY, float centerZ){
		this.centerX = centerX;
		this.centerY = centerY;
		this.centerZ = centerZ;
		center.set(centerX, centerY, centerZ);
	}

	/**
	 * setMaxPoints
	 * @param maxPoints
	 */

	public void setMaxPoints(int maxPoints) {
		this.maxPoints = maxPoints;
	}

	/**
	 * setMaxPoints
	 * @param rotateXVal
	 * @param rotateYVal
	 * @param rotateZVal
	 */

	public void setRotateXYZVal(int rotateXVal, int rotateYVal, int rotateZVal) {
		this.rotateXVal = rotateXVal;
		this.rotateYVal = rotateYVal;
		this.rotateZVal = rotateZVal;
	}

	/**
	 * setColor
	 * @param red
	 * @param blue
	 * @param green
	 */

	public void setColor(float red, float blue, float green){
		fillColor = strokeColor = color(red, blue, green);
	}  

	public int getSizeH() { return sizeH; }
	public int getSizeW() { return sizeW; }
	public int getSizeD() { return sizeD; }

	public float getCenterX() { return centerX; }
	public float getCenterY() { return centerY; }
	public float getCenterZ() { return centerZ; }

	public int getRotateXVal() { return rotateXVal; }
	public int getRotateYVal() { return rotateYVal; }
	public int getRotateZVal() { return rotateZVal; }

	/**
	 * check
	 * @param point
	 */

	public boolean check(PVector point) {
		boolean result = false;

		if (point.x > center.x - sizeW/2 && point.x < center.x + sizeW/2) {
			if (point.y > center.y - sizeH/2 && point.y < center.y + sizeH/2) {
				if (point.z > center.z - sizeD/2 && point.z < center.z + sizeD/2) {
					result = true;
					pointsIncluded++;
				}
			}
		}

		return result;
	}

	/**
	 * draw
	 */

	void draw() {
		pushMatrix();
		translate(center.x, center.y, center.z);
		rotateX(radians(rotateXVal));
		rotateY(radians(rotateYVal));
		rotateZ(radians(rotateZVal));

		fill(red(fillColor), blue(fillColor), green(fillColor), 10 * percentIncluded());
		//stroke(red(strokeColor) , blue(strokeColor), green(strokeColor), 255);
		stroke(255 * percentIncluded() , blue(strokeColor), green(strokeColor), 255);
		box(sizeW, sizeH, sizeD);
		popMatrix();
	}

	/**
	 * percentIncluded
	 */

	public float percentIncluded() {
		return map(pointsIncluded, 0, maxPoints, 0, 1);
	}

	/**
	 * currentlyHit
	 */

	public boolean currentlyHit() {
		return (pointsIncluded > threshold);
	}

	/**
	 * currentlyEmpty
	 */

	public boolean currentlyEmpty() {
		return (pointsIncluded < threshold);
	}

	/**
	 * isHit
	 */

	public boolean isHit() {
		return (currentlyHit() && !wasJustHit);
	}

	/**
	 * clear
	 */

	public void clear() {
		wasJustHit = currentlyHit();
		pointsIncluded = 0;
	}


}

