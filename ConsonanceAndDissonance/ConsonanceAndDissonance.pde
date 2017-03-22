import controlP5.*;
ControlP5 cp5;


float numberboxValue = 200;
float numberboxValue2 = 300;
import processing.sound.*;

SinOsc sine1, sine2;
SqrOsc square1, square2;

float freq1=200;
float freq2 = 300;
float amp=0.5;
float pos;
controlP5.Numberbox b, b2;

boolean isSquares = false;


void setup() {
  size(800, 600);
  noStroke();
  cp5 = new ControlP5(this);

  PFont pfont = createFont("Arial", 20, true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 80);
  color red = color(255, 0, 0);

  cp5.addToggle("toggle")
    .setPosition(50, 10)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    .setColorLabel(0)
    .setLabel("Sin/Square");
  ;


  b = cp5.addNumberbox("numberboxValue")
    .setPosition(50, 50)
    .setRange(0, 200)
    .setMultiplier(-1.0) // set the sensitifity of the numberbox
    .setScrollSensitivity(1.1)

    .setValue(200)
    .setMax(1000)
    .setMin(100)
    .setSize(200, 100)
    .setColorBackground(red);
  ;



  b2 = cp5.addNumberbox("numberboxValue2")
    .setPosition(400, 50)
    .setRange(0, 200)
    .setMultiplier(-1.0) // set the sensitifity of the numberbox
    .setScrollSensitivity(1.1)

    .setValue(200)
    .setMax(1000)
    .setMin(100)
    .setSize(200, 100)
    ;

  cp5.getController("numberboxValue")
    .getCaptionLabel()
    .setFont(font)
    .toUpperCase(false)
    .setSize(50)
    .setText("");
  ;

  cp5.getController("numberboxValue")
    .getValueLabel()
    .setFont(font)
    .toUpperCase(false)
    .setSize(50)
    ;

  cp5.getController("numberboxValue2")
    .getCaptionLabel()
    .setFont(font)
    .toUpperCase(false)
    .setSize(50)
    .setText("");
  ;

  cp5.getController("numberboxValue2")
    .getValueLabel()
    .setFont(font)
    .toUpperCase(false)
    .setSize(50)
    ;

  //b.getControlWindow().getCaptionLabel().setFont(font);
  //cp5.getController("numberboxValue").setControlFont(font);
  //cp5.setControlFont(font);

  final NumberboxInput nin = new NumberboxInput( b );

  b.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_RELEASED) { 
        nin.setActive( true );
      } else if (theEvent.getAction()==ControlP5.ACTION_LEAVE) { 
        nin.setActive( false ); 
        nin.submit();
      }
    }
  }
  );

  final NumberboxInput nin2 = new NumberboxInput( b2 );

  b2.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_RELEASED) { 
        nin2.setActive( true );
      } else if (theEvent.getAction()==ControlP5.ACTION_LEAVE) { 
        nin2.setActive( false ); 
        nin2.submit();
      }
    }
  }
  );


  sine1 = new SinOsc(this);

  //Start the Sine Oscillator. 
  sine1.play();
  sine1.amp(0.5);


  sine2 = new SinOsc(this);
  sine2.play();
  sine2.amp(0.5);

  square1 = new SqrOsc(this);
  square1.play();
  square2 = new SqrOsc(this);
  square2.play();
  square1.amp(0);
  square2.amp(0);
}

void draw() {
  background(255);

  sine1.freq(numberboxValue);
  sine2.freq(numberboxValue2);
  square1.freq(numberboxValue);
  square2.freq(numberboxValue2);
  drawLines();
}


public class NumberboxInput {

  String text = "";

  Numberbox n;

  boolean active;

  int col;

  NumberboxInput(Numberbox theNumberbox) {
    n = theNumberbox;
    registerMethod("keyEvent", this );
    col = n.getColor().getValueLabel();
  }

  public void keyEvent(KeyEvent k) {
    // only process key event if input is active 
    if (k.getAction()==KeyEvent.PRESS && active) {
      if (k.getKey()=='\n') { // cofirm input with enter
        submit();
        return;
      } else if (k.getKeyCode()==BACKSPACE) { 
        text = text.isEmpty() ? "":text.substring(0, text.length()-1);
        //text = ""; // clear all text with backspace
      } else if (k.getKey()<255) {
        // check if the input is a valid (decimal) number
        final String regex = "\\d+([.]\\d{0,2})?";
        if ( java.util.regex.Pattern.matches(regex, text + k.getKey()) ) {
          text += k.getKey();
        }
      }
      n.getValueLabel().setText(this.text);
    }
  }

  public void setActive(boolean b) {
    active = b;
    if (active) {
      col = n.getColor().getValueLabel();
      n.setColorValueLabel(n.getColor().getActive());
      text = n.getValueLabel().getText();
    }
  }
  public void submit() {
    if (!text.isEmpty()) {
      n.setValue( float( text ) );
      text = "";
    } else {
      n.getValueLabel().setText(""+n.getValue());
    }
    n.setColorValueLabel(col);
  }
}

public void numbers(float f) {
  println("received "+f+" from Numberbox numbers ");
}

public void drawLines() {
  strokeWeight(5);
  stroke(255, 0, 0);
  boolean done = false;
  int i = 1;
  while (!done) {
    float freq1height = map(numberboxValue*i++, 0, 2000, 600, 200);
    if (freq1height < 0) {
      done = true;
    } else {
      line(0, freq1height, width/2, freq1height);
      if (!isSquares)
        done = true;
    }
  }

  stroke(0, 0, 255);

  done = false;
  i = 1;
  while (!done) {
    float freq2height = map(numberboxValue2*i++, 0, 2000, 600, 200);
    if (freq2height < 0) {
      done = true;
    } else {
      line(width/2, freq2height, width, freq2height);
      if (!isSquares) 
        done = true;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    isSquares = !isSquares; 
    updateWaveType();
  } else if (key == 'a') {
    b.setValue(numberboxValue * pow(2, 1./12));
  } else if (key == 's') {
    b.setValue(numberboxValue / pow(2, 1./12));
  } else if (key == 'd') {
    b2.setValue(numberboxValue2 * pow(2, 1./12));
  } else if (key == 'f') {
    b2.setValue(numberboxValue2 / pow(2, 1./12));
  }
}

void toggle(boolean theFlag) {
  if (theFlag) {
    isSquares = false;
    updateWaveType();
  } else {
    isSquares = true;
    updateWaveType();
  }
}

void updateWaveType() {
  if (isSquares) {
    sine1.amp(0);
    sine2.amp(0);
    square1.amp(0.5);
    square2.amp(0.5);
  } else {
    square1.amp(0);
    square2.amp(0);
    sine1.amp(0.5);
    sine2.amp(0.5);
  }
}