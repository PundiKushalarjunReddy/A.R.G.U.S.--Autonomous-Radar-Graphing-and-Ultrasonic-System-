import processing.serial.*; 

// --- ARGUS: Autonomous Radar Graphing and Ultrasonic System ---
Serial myPort; 
String data="", angle="", distance="";
int iAngle, iDistance;
int lastLoggedDist = 0;
float pixsDistance; 
Table logTable;
int maxRows = 22; 

void setup() {
  size(1500, 750); 
  smooth();
  
  logTable = new Table();
  logTable.addColumn("Date");
  logTable.addColumn("Time");
  logTable.addColumn("Angle");
  logTable.addColumn("Distance");

  try {
    myPort = new Serial(this, "COM8", 9600); 
    myPort.bufferUntil('.'); 
  } catch (Exception e) {
    println("SERIAL ERROR: Connection to ARGUS hardware failed on COM8.");
  }
}

void draw() {
  background(0); 
  
  // HUD Title Header
  drawHeader();
  
  drawRadarInterface();
  drawLogTable();
}

void drawHeader() {
  fill(98, 245, 31, 50);
  rect(0, 0, width, 50); // Top bar background
  
  fill(98, 245, 31);
  textSize(30);
  textAlign(CENTER);
  text("A.R.G.U.S. SYSTEM ONLINE", 500, 35);
  textAlign(LEFT);
  
  stroke(98, 245, 31, 150);
  line(0, 50, width, 50); // Decorative separator
}

void serialEvent (Serial myPort) { 
  if (logTable == null) return; 
  try {
    data = myPort.readStringUntil('.');
    if (data != null) {
      data = data.substring(0, data.length()-1);
      String[] list = split(data, ',');
      if (list.length == 2) {
        iAngle = int(trim(list[0]));
        iDistance = int(trim(list[1]));
        
        if (iDistance < 40 && iDistance > 1 && abs(iDistance - lastLoggedDist) > 3) {
          logObject(iAngle, iDistance);
          lastLoggedDist = iDistance;
        }
      }
    }
  } catch (Exception e) { }
}

void logObject(int ang, int dist) {
  if (logTable != null) {
    TableRow newRow = logTable.addRow();
    newRow.setString("Date", year()+"/"+month()+"/"+day());
    newRow.setString("Time", nf(hour(),2)+":"+nf(minute(),2)+":"+nf(second(),2));
    newRow.setInt("Angle", ang);
    newRow.setInt("Distance", dist);
    if (logTable.getRowCount() > 200) logTable.removeRow(0);
  }
}

void drawRadarInterface() {
  pushMatrix();
  translate(0, 50); // Move everything down to accommodate header
  noStroke();
  fill(0, 25); 
  rect(0, 0, 1000, height-50); 
  
  drawRadar();
  drawLine();
  drawObject();
  drawText();
  popMatrix();
}

void drawLogTable() {
  int startX = 1020;
  translate(0, 50); // Match header offset
  
  fill(15);
  stroke(98, 245, 31, 100);
  rect(startX, 20, 460, height-90, 8);
  
  fill(98, 245, 31);
  textSize(22);
  text("DATA ARCHIVE: LOGGED TRACKS", startX + 25, 60);
  
  if (logTable != null) {
    int rowCount = logTable.getRowCount();
    int displayCount = min(rowCount, maxRows);
    for (int i = 0; i < displayCount; i++) {
      TableRow r = logTable.getRow((rowCount - 1) - i);
      int yPos = 135 + (i * 26);
      textSize(14);
      fill(98, 245, 31, 200);
      text(r.getString("Time") + "    " + r.getInt("Angle") + "°    " + r.getInt("Distance") + " cm", startX + 25, yPos);
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(500, height-150); 
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31, 100);
  arc(0, 0, 900, 900, PI, TWO_PI);
  arc(0, 0, 700, 700, PI, TWO_PI);
  arc(0, 0, 500, 500, PI, TWO_PI);
  arc(0, 0, 300, 300, PI, TWO_PI);
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(500, height-150);
  strokeWeight(6); 
  stroke(255, 40, 40); 
  pixsDistance = iDistance * 11.25; 
  if(iDistance < 40 && iDistance > 1){
    float x = pixsDistance * cos(radians(iAngle));
    float y = -pixsDistance * sin(radians(iAngle));
    line(x, y, (pixsDistance+3)*cos(radians(iAngle)), -(pixsDistance+3)*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  translate(500, height-150);
  strokeWeight(3);
  stroke(30, 250, 60);
  line(0, 0, 450*cos(radians(iAngle)), -450*sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  fill(98, 245, 31);
  textSize(24);
  text("SCANNER ANGLE: " + iAngle + "°", 50, height-100);
  text("TARGET DISTANCE: " + (iDistance < 40 ? iDistance + " cm" : "SCANNING..."), 400, height-100);
}

void exit() {
  try {
    if (logTable != null && logTable.getRowCount() > 0) {
      saveTable(logTable, "data/argus_log.csv");
      println("ARGUS data successfully archived to CSV.");
    }
  } catch (Exception e) { }
  super.exit();
}
