PFont font;
float[] buffer;
float stringLength, time, amplitude, tension, massPerUnitLength, waveLength, harmonicNumber;
float fundamentalFrequency, harmonicFrequency;
int displayMode;
String[] displayNames;

void setup(){
  size(480, 320);
  frameRate(60);
  noSmooth();
  
  //load and assign font
  font = loadFont("tempestaSeven.vlw");
  textFont(font, 8);
  
  //init variables
  //main waveform buffer
  buffer = new float[width];
  //display mode related
  displayMode = 0;//0 - separate harmonic modes, 1 - summed harmonics up to harmonicNumber
  displayNames = new String[2];
  displayNames[0] = "current harmonic";
  displayNames[1] = "sum of all harmonics";
  //parameters
  stringLength = width;//in pixels
  time = 0;//in sec
  amplitude = 20;//pixels
  tension = 10;
  massPerUnitLength = 0;
  harmonicNumber = 1;
  fundamentalFrequency = 1;
  harmonicFrequency = fundamentalFrequency;//current harmonic frequency
  //perform initial calculations
  calculateU();
  calculateFundamental();
}

void draw(){
  background(240);
  
  //increment time
  time += 1/frameRate;
  
  calculateFundamental();
  
  if(displayMode == 0){
    buffer = calculateBuffer();
  }else if(displayMode == 1){
    buffer = calculateBufferSum();
  }
  
  displayBuffer(buffer);
  displayInfo();
}

void calculateU(){
  massPerUnitLength = tension/pow((fundamentalFrequency*(stringLength*2)), 2);
}

void calculateFundamental(){
  fundamentalFrequency = 1/(stringLength*2)*sqrt(tension/massPerUnitLength);
}

float calculateFrequency(float n){
  float freq = n/(stringLength*2)*sqrt(tension/massPerUnitLength);
  return freq;
}

float[] calculateBuffer(){
  float[] buff = new float[width];
  float freq = calculateFrequency(harmonicNumber);
  for(int i = 0; i < buff.length; i ++){
    buff[i] = amplitude*sin((harmonicNumber*PI)/stringLength*i)*cos(TWO_PI*freq*time);
  }
  return buff;
}

float[] calculateBufferSum(){
  float[] buff = new float[width];
  for(int j = 1; j < harmonicNumber+1; j ++){
    for(int i = 0; i < buff.length; i ++){
      buff[i] += amplitude/j*sin((j*PI)/stringLength*i)*cos(TWO_PI*fundamentalFrequency*j*time);
    }
  }
  return buff;
}

void displayBuffer(float[] buff){
  stroke(220, 30, 30);
  strokeWeight(1);
  for(int i = 0; i < buff.length-1; i ++){
    line(i, round(buff[i]) + height/2, i+1, round(buff[i+1]) + height/2);
  }
}

void displayInfo(){
  fill(30);
  text("display mode: "+displayNames[displayMode]+"  (press m to switch between modes)", 2, 10);
  text("harmonic number: "+int(harmonicNumber)+"  (press up or down to increase/decrease)", 2, 20);
  text("fundamental frequency: "+fundamentalFrequency, 2, 40);
  text("tension: "+tension+"  (press left or right to increase/decrease)", 2, 50);
  text("maximum amplitude: "+amplitude+"  (press + or - to increase/decrease)", 2, 60);
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == RIGHT){
      tension += 0.5;
    }else if(keyCode == LEFT){
      if(tension > 0.5){
        tension -= 0.5;
      }
    }
    
    if(keyCode == UP){
      harmonicNumber ++;
    }else if(keyCode == DOWN){
      if(harmonicNumber > 1){
        harmonicNumber --;
      }
    }
  }
  
  if(key == '='){
    amplitude += 5;
  }else if(key == '-'){
    amplitude -= 5;
  }
}

void keyReleased(){
  if(key == 'm'){
    if(displayMode == 0){
      displayMode = 1;
    }else if(displayMode == 1){
      displayMode = 0;
    }
  }
}