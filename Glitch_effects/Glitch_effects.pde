PImage img;
PImage g;
PImage s;
void setup() {
  //img = loadImage("Logo.png");
  g = loadImage("g.jpg");
  s = loadImage("Untitled.png");

  //size(500,500);
  fullScreen();
}
color transitionToCol(color current, color newCol, int speed) {
  color col = current;

  if (red(col) > red(newCol)) {
    col = color(red(col+speed), green(col), blue(col), alpha(col));
  } else {
    col = color(red(col-speed), green(col), blue(col), alpha(col));
  }

  if (green(col) > green(newCol)) {
    col = color(red(col), green(col+speed), blue(col), alpha(col));
  } else {
    col = color(red(col), green(col-speed), blue(col), alpha(col));
  }
  if (blue(col) > blue(newCol)) {
    col = color(red(col), green(col), blue(col+speed), alpha(col));
  } else {
    col = color(red(col), green(col), blue(col-speed), alpha(col));
  }
  if (alpha(col) > alpha(newCol)) {
    col = color(red(col), green(col), blue(col), alpha(col-speed));
  } else {
    col = color(red(col), green(col), blue(col), alpha(col+speed));
  }

  return col;
}



PImage glitchColorSplit(PImage inputImg, int size, int sensitivity) {

  //final int INTENDEDIMGWIDTH = inputImg.width;
  //final int INTENDEDIMGHEIGHT = inputImg.height;

  final int IMGWIDTH = inputImg.width;
  final int IMGHEIGHT = inputImg.height;
  PImage ramImg = createImage(IMGWIDTH, IMGHEIGHT, ARGB);

  PImage RramImg = createImage(IMGWIDTH, IMGHEIGHT, ARGB);

  PImage GramImg = createImage(IMGWIDTH, IMGHEIGHT, ARGB);
  PImage BramImg = createImage(IMGWIDTH, IMGHEIGHT, ARGB);

  //ramImg = inputImg.copy();

  for (int i = 0; i < IMGHEIGHT; i++) {
    for (int j = 0; j < IMGWIDTH; j++) {
      color ramCol;
      ramCol = inputImg.get(j, i);

      //int sensitivity = 255;
      if (red(ramCol) < sensitivity && green(ramCol) < sensitivity && blue(ramCol) < sensitivity) {
        //for (int s = 0; s < size*3; s++) {
        ramCol = color(red(ramCol), green(ramCol)-255, blue(ramCol)-255, alpha(ramCol));   
        RramImg.set(j+1*size, i, ramCol);

        ramCol = inputImg.get(j+1, i);
        ramCol = color(red(ramCol)-255, green(ramCol), blue(ramCol)-255, alpha(ramCol));   
        GramImg.set(j+2*size, i, ramCol);

        ramCol = inputImg.get(j+2, i);
        ramCol = color(red(ramCol)-255, green(ramCol)-255, blue(ramCol), alpha(ramCol));   
        BramImg.set(j+3*size, i, ramCol);
        //}
      }else{
        
        ramCol = inputImg.get(j, i);
        ramImg.set(j, i, ramCol); 
      }

      //println((red(ramCol)+" " + green(ramCol)+" " + blue(ramCol)));

      //}
    }
  }
  ramImg.blend(RramImg, 0, 0, RramImg.width, RramImg.height, 0, 0, RramImg.width, RramImg.height, ADD); 
  ramImg.blend(GramImg, 0, 0, RramImg.width, RramImg.height, 0, 0, RramImg.width, RramImg.height, ADD); 
  ramImg.blend(BramImg, 0, 0, RramImg.width, RramImg.height, 0, 0, RramImg.width, RramImg.height, ADD); 


  ramImg.updatePixels();
  return ramImg;
}
PImage glitchBlockDisplace(PImage inputImg, int intensity, String type) {

  final int INTENDEDIMGWIDTH = inputImg.width;
  final int INTENDEDIMGHEIGHT = inputImg.height;

  int IMGWIDTH = inputImg.width;
  int IMGHEIGHT = inputImg.height;

  if (type.contains("DontContain")) {
    IMGWIDTH = inputImg.width + intensity;
    IMGHEIGHT = inputImg.height + intensity;
  }

  PImage ramImg = createImage(IMGWIDTH, IMGHEIGHT, ARGB);

  int randPosY = round(random(ramImg.height));

  int randStretch = round(random(2));


  for (int i = 0; i < IMGHEIGHT; i++) {
    int rowOffset = round(random(-intensity, intensity));
    int colOffset = round(random(-intensity, intensity));

    for (int j = 0; j < IMGWIDTH; j++) {



      color ramCol = 0;

      if (type.contains("BOTH")) {
        ramCol = inputImg.get(j+rowOffset, i+colOffset);
      } else if (type.contains("BOTHDIAG")) {
        ramCol = inputImg.get(j+rowOffset, i+rowOffset);
      } else if (type.contains("CropGlitch2")) {
        ramCol = inputImg.get(j-abs(intensity - randPosY), i);
      } else if (type.contains("CropGlitch")) {
        ramCol = inputImg.get(j+abs(randPosY), i);
      } else if (type.contains("None")) {
        ramCol = inputImg.get(j, i);
      } else if (type.contains("StretchRows")) {
        ramCol = inputImg.get(j+rowOffset, i);
      }

      if (type.contains("GlitchSides")) {
        ramImg.set(j+rowOffset, i, ramCol);
      } else if (type.contains("Wonk")) {
        ramImg.set(j*(randPosY/(intensity+ramImg.height/2)), i, ramCol);
      } else if (type.contains("stretch")) {
        ramImg.set(j*randStretch, i, ramCol);
      } else if (type.contains("ScanLines")) {
        ramImg.set(j, i, ramCol);
        //ramImg.set(j, mouseY, color(0));
      } else {
        ramImg.set(j, i, ramCol);
        //ramImg.set(mouseX, i, color(mouseX, mouseX, mouseY));
      }
    }
  }
  //ramImg.updatePixels();
  return ramImg;
}

PImage Interlace(PImage file) {

  int cropWStart = 0;
  int cropHStart = 0;
  int cropWStop = file.width;
  int cropHStop = file.height;
  Boolean Rot90 = false;


  PImage ramImg = createImage(cropWStop, cropHStop, ARGB);

  int ramCount = 0;


  for (int i = 0; i < cropWStop; i++) {
    for (int j = 0; j < cropHStop; j++) {

      color ramCol = file.get(cropWStart+j, cropHStart+i);
      if (Rot90 == false) {
        ramCol = file.get(cropWStart+j, cropHStart+i);
      } else {
        ramCol = file.get(cropWStart+i, cropHStart+j);
      }

      try {
        //fiter this color out
        if (ramCol != -9568146) {
          ramImg.pixels[ramCount] = ramCol;
        }
        ramCount++;
      }
      catch(Exception e) {
        //TODO: optimise this so the try catch is not needed, try print out ramCount
      }
    }
  }
  ramImg.updatePixels();
  return ramImg;
}

void draw() {
  background(0);
  image(glitchColorSplit(g, round(random(-12,12)),256), 0, 0,400,400);
  
  image(glitchBlockDisplace(glitchColorSplit(g, round(random(-120,120)),256),12,"BOTHDIAG DontContain"), 400, 0,400,400);
  
  image(glitchColorSplit(g, round(random(-120,120)),256), 800, 0,400,400);

  
  image(glitchColorSplit(g, 50,100), 400, 400,400,400);

  image(glitchBlockDisplace(glitchColorSplit(g, 50,100),12,"StretchRows DontContain"), 0, 400,400,400);


  //image((glitchBlockDisplace(glitchColorSplit(g, 10), mouseX/20, "ScanLines BOTHDIAG")), 0, 0, width-200, height-200);
  //image((glitchBlockDisplace(glitchColorSplit(g, 10), mouseX/20, "ScanLines BOTHDIAG")), 0, 0, width-200, height-200);

  //image(Interlace(s), 0, 0);





  //stroke(255);
  //noFill();
  //rect(100, 10, 800, 800);
}
