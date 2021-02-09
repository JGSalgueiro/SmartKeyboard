// Instituto Superior Tecnico - Tagus Park
// Bakeoff #3 - Escrita de Texto em Smartwatches
// IPM 2019-20, Semestre 2
// Group 26 - Afonso Bate; David Miranda; João Salgueiro
// Processing reference: https://processing.org/reference/

import java.util.HashMap;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Random;
import processing.sound.*;
import java.util.TreeMap;
import java.lang.Comparable;

char letter = ' '; // Init letter

Keyboard keyboard;

SoundFile keyPressed;  // Key pressed sound
SoundFile switched;
SoundFile deleteKey;

String wordTyped = ""; // Init current word being typed

PrefTree r; // Word associacion Dictionary
PredictWord words; // Dictionary of words

String Prediction1; // Word sugestion num 1
String Prediction2; // Word sugestion num 2

// Screen resolution vars;
float PPI, PPCM;
float SCALE_FACTOR;

// Finger parameters
PImage fingerOcclusion;
int FINGER_SIZE;
int FINGER_OFFSET;

// Arm/watch parameters
PImage arm;
int ARM_LENGTH;
int ARM_HEIGHT;

// Arrow parameters
PImage leftArrow, rightArrow;
int ARROW_SIZE;

// Study properties
String[] phrases;                   // contains all the phrases that can be tested
int NUM_REPEATS            = 2;     // the total number of phrases to be tested
int currTrialNum           = 0;     // the current trial number (indexes into phrases array above)
String currentPhrase       = "";    // the current target phrase
String currentTyped        = "";    // what the user has typed so far
char currentLetter         = 'a';

// Performance variables
float startTime            = 0;     // time starts when the user clicks for the first time
float finishTime           = 0;     // records the time of when the final trial ends
float lastTime             = 0;     // the timestamp of when the last trial was completed
float lettersEnteredTotal  = 0;     // a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0;     // a running total of the number of letters expected (correct phrases)
float errorsTotal          = 0;     // a running total of the number of errors (when hitting next)

String[] typed = new String[NUM_REPEATS];

String removeLastCharacter(String s){
  if(s.length() > 0)
    s = s.substring(0, s.length() - 1);
  return s;
}

String getPreviousWord(String s){
  String[] p = split(currentTyped, ' ');
  if (p.length == 1){
    return "";
  }
  else{
    return p[p.length-2];
  }
}

String deleteWordTyped(String s){
   if(wordTyped.length() == s.length())
     return "";
   else
     return s.substring(0,s.lastIndexOf(" ") + 1);
}

class Keyboard{
   int slice;
   
   Keyboard(){
     slice = 0;
   }
   
   void switchSlice(){
     if(slice == 0)
       slice = 1;
     else 
       slice = 0;
   }
   
   void draw(){
     stroke(0);
     //strokeWeight(0.5);
     fill(255,255,153);
     rect(width/2 - 2.0 * PPCM , height/2 + 1.375 * PPCM, 0.8*PPCM, 0.625*PPCM);
     textFont(createFont("Arial", 23));
     fill(0);
     text("SW", width/2 - 1.6 * PPCM , height/2 + 1.8 * PPCM);
     
     fill(220);
     rect(width/2 - 1.2 * PPCM , height/2 + 1.375 * PPCM, 2.4*PPCM, 0.625*PPCM);
     textFont(createFont("Arial", 30));
     fill(0);
     text("__", width/2 , height/2 + 1.65 * PPCM);
     
     fill(220);
     rect(width/2 + 1.2 * PPCM , height/2 + 1.375 * PPCM, 0.8*PPCM, 0.625*PPCM);
     textFont(createFont("Arial", 30));
     fill(0);
     text("<", width/2 + 1.6 * PPCM , height/2 + 1.85 * PPCM);
     fill(220);
     // 1st Row 
     rect(width/2 - 2.0 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 - 1.2 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 - 0.4 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 + 0.4 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 + 1.2 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM);
     // 2nd Row 
     rect(width/2 - 2.0 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 - 1.2 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 - 0.4 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 + 0.4 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 + 1.2 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM);
     // 3rd Row 
     rect(width/2 - 2.0 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 - 1.2 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 - 0.4 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 + 0.4 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM);
     rect(width/2 + 1.2 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM);
     if(slice == 0){
        textFont(createFont("Arial", 25));
        fill(40);
        //1ST ROW
        text("q", width/2 - 1.6 * PPCM , height/2 - 0.05 * PPCM);
        text("w", width/2 - 0.8 * PPCM , height/2 - 0.05 * PPCM);
        text("e", width/2 , height/2 - 0.05 * PPCM);
        text("r", width/2 + 0.8 * PPCM , height/2 - 0.05 * PPCM);
        text("t", width/2 + 1.6 * PPCM , height/2 - 0.05 * PPCM);
        //2ND ROW
        text("a", width/2 - 1.6 * PPCM , height/2 + 0.575 * PPCM);
        text("s", width/2 - 0.8 * PPCM , height/2 + 0.575 * PPCM);
        text("d", width/2 , height/2 + 0.575 * PPCM);
        text("f", width/2 + 0.8 * PPCM , height/2 + 0.575 * PPCM);
        text("g", width/2 + 1.6 * PPCM , height/2 + 0.575 * PPCM);
        //3RD ROW
        text("z", width/2 - 1.6 * PPCM , height/2 + 1.2 * PPCM);
        text("x", width/2 - 0.8 * PPCM , height/2 + 1.2 * PPCM);
        text("c", width/2 , height/2 + 1.2 * PPCM);
        text("v", width/2 + 0.8 * PPCM , height/2 + 1.2 * PPCM);
        text("b", width/2 + 1.6 * PPCM , height/2 + 1.2 * PPCM);
     }
     else{
        textFont(createFont("Arial", 25));
        fill(40);
        //1ST ROW
        text("y", width/2 - 1.6 * PPCM , height/2 - 0.05 * PPCM);
        text("u", width/2 - 0.8 * PPCM , height/2 - 0.05 * PPCM);
        text("i", width/2 , height/2 - 0.05 * PPCM);
        text("o", width/2 + 0.8 * PPCM , height/2 - 0.05 * PPCM);
        text("p", width/2 + 1.6 * PPCM , height/2 - 0.05 * PPCM);
        //2ND ROW
        text("h", width/2 - 1.6 * PPCM , height/2 + 0.575 * PPCM);
        text("j", width/2 - 0.8 * PPCM , height/2 + 0.575 * PPCM);
        text("k", width/2 , height/2 + 0.575 * PPCM);
        text("l", width/2 + 0.8 * PPCM , height/2 + 0.575 * PPCM);
        text("ç", width/2 + 1.6 * PPCM , height/2 + 0.575 * PPCM);
        //3RD ROW
        text("n", width/2 - 1.6 * PPCM , height/2 + 1.2 * PPCM);
        text("m", width/2 - 0.8 * PPCM , height/2 + 1.2 * PPCM);
        text("´", width/2 , height/2 + 1.2 * PPCM);
        text("!", width/2 + 0.8 * PPCM , height/2 + 1.2 * PPCM);
        text("?", width/2 + 1.6 * PPCM , height/2 + 1.2 * PPCM);   
     }
   }
   
   char click(){
     char c = ' ';
     if(didMouseClick(width/2 - 2.0 * PPCM, height/2 - 1.0 * PPCM, 2*PPCM, 0.5*PPCM)) c = '1';
     else if(didMouseClick(width/2 , height/2 - 1.0 * PPCM, 2*PPCM, 0.5*PPCM)) c = '2';
     else if(didMouseClick(width/2 + 1.2 * PPCM , height/2 + 1.375 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = '<';
     else if(didMouseClick(width/2 - 1.2 * PPCM , height/2 + 1.375 * PPCM, 2.4*PPCM, 0.625*PPCM)) c = '_';
     else if(didMouseClick(width/2 - 2.0 * PPCM , height/2 + 1.375 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = '*';
     
     if(slice == 0){
       if(didMouseClick(width/2 - 2.0 * PPCM, height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'q';
       else if(didMouseClick(width/2 - 1.2 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'w';
       else if(didMouseClick(width/2 - 0.4 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'e';
       else if(didMouseClick(width/2 + 0.4 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'r';
       else if(didMouseClick(width/2 + 1.2 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 't';
       else if(didMouseClick(width/2 - 2.0 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'a';
       else if(didMouseClick(width/2 - 1.2 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 's';
       else if(didMouseClick(width/2 - 0.4 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'd';
       else if(didMouseClick(width/2 + 0.4 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'f';
       else if(didMouseClick(width/2 + 1.2 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'g';
       else if(didMouseClick(width/2 - 2.0 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'z';
       else if(didMouseClick(width/2 - 1.2 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'x';
       else if(didMouseClick(width/2 - 0.4 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'c';
       else if(didMouseClick(width/2 + 0.4 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'v';
       else if(didMouseClick(width/2 + 1.2 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'b';
     }
     else{
       if(didMouseClick(width/2 - 2.0 * PPCM, height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'y';
       else if(didMouseClick(width/2 - 1.2 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'u';
       else if(didMouseClick(width/2 - 0.4 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'i';
       else if(didMouseClick(width/2 + 0.4 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'o';
       else if(didMouseClick(width/2 + 1.2 * PPCM , height/2 - 0.5 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'p';
       else if(didMouseClick(width/2 - 2.0 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'h';
       else if(didMouseClick(width/2 - 1.2 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'j';
       else if(didMouseClick(width/2 - 0.4 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'k';
       else if(didMouseClick(width/2 + 0.4 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'l';
       else if(didMouseClick(width/2 + 1.2 * PPCM , height/2 + 0.125 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'ç';
       else if(didMouseClick(width/2 - 2.0 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'n';
       else if(didMouseClick(width/2 - 1.2 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = 'm';
       else if(didMouseClick(width/2 - 0.4 * PPCM , height/2 + 0.75 * PPCM, 0.8*PPCM, 0.625*PPCM)) c = '´';
     }
     
     return c;
   }
}

// Implementation of a Trie to store the dictionary
class PrefTree implements Comparable<PrefTree>{
  HashMap<Character,PrefTree> children;
  long frequency;
  String name;
  ArrayList<PrefTree> top2;

  PrefTree(){
    children = new HashMap<Character,PrefTree>();
    top2 = new ArrayList<PrefTree>();
    frequency = 0;
    name = null;
  }
  
  PrefTree get(String s){
    PrefTree node =this;
    for(char ch : s.toCharArray()){
      if(node.children.containsKey(ch)){
        node = node.children.get(ch);
      }
      else{
        PrefTree t = new PrefTree();
        node.children.put(ch,t);
        node = t;
      }
    }
    return node;
  }
  
  int compareTo(PrefTree t){
    return Long.compare(this.frequency,t.frequency);
  }

  void addTo(long frequency, String name){
    PrefTree node = this.get(name);
    node.frequency = frequency;
    node.name = name;
  }

  void calculate2Pref(){
    ArrayList<PrefTree> output= new ArrayList<PrefTree>();
    for (PrefTree t: children.values()){
      t.calculate2Pref();
      output.addAll(t.top2);
    }
    if (name!=null){
      output.add(this);
    }
    Collections.sort(output, Collections.reverseOrder());
    int n = 2;
    if (output.size()<n){
      n = output.size();
    }
    for(int i = 0; i<n ;i++){
      this.top2.add(output.get(i));
    }
  }

  String show2Pref(int index){
    try{
      return  top2.get(index).name;
    }catch(IndexOutOfBoundsException e){
      return "";
    }
  }
}

class NextWords{
  String[] names;
  Long[] frequencys;
  int size;

  NextWords(){
    names = new String[2];
    size = 0;
    frequencys = new Long[2];
  }

  void addTo(long frequency, String nextW){
    if (size < 2){
      names[size]=nextW;
      frequencys[size]=frequency;
      size++;
    }
    else{
      int less_frequent_ind = 0;
      Long less_frequent = frequencys[0];
      for(int i = 1; i < 2; i++){
        if(frequencys[i]<less_frequent){
          less_frequent=frequencys[i];
          less_frequent_ind=i;
        }
      }
      if(frequency > less_frequent){
        names[less_frequent_ind]=nextW;
        frequencys[less_frequent_ind]=frequency;
      }
    }
  }
}

class PredictWord{
  HashMap<String, NextWords> map;

  PredictWord(){
    map = new HashMap<String, NextWords>();
  }

  void addTo(long frequency, String current, String next){
    if(map.containsKey(current)){
      map.get(current).addTo(frequency, next);
    }
    else{
      NextWords nexts = new NextWords();
      nexts.addTo(frequency , next);
      map.put(current,nexts);
    }
  }

  String get(String word, int index){
    if (map.containsKey(word) && map.get(word).names[index]!=null) {
      return map.get(word).names[index];
    }
    else{
      return "";
    }
  }
}

//Setup window and vars - runs once
void setup()
{
  keyboard = new Keyboard();
  r = new PrefTree();
  words = new PredictWord();
  
  String[] text1 = loadStrings("count_1w.txt");
  for (String line: text1){
    String[] cont = splitTokens(line);
    long freq = Long.parseLong(cont[1]);
    r.addTo(freq,cont[0]);
  }
  
  r.calculate2Pref();
  
  String[] text2 = loadStrings("count_2w.txt");
  for (String line: text2){
    String[] cont = splitTokens(line);
    Long freq = Long.parseLong(cont[2]);
    words.addTo(freq, cont[0], cont[1]);
  }
  //size(900, 900);
  fullScreen();
  textFont(createFont("Arial", 24));  // set the font to arial 24
  noCursor();                         // hides the cursor to emulate a watch environment
  
  // Load images
  arm = loadImage("arm_watch.png");
  fingerOcclusion = loadImage("finger.png");

  keyPressed = new SoundFile(this, "keyPressed.wav");
  switched = new SoundFile(this, "switch.wav");
  deleteKey = new SoundFile(this, "deleteKey.wav");
  
  // Load phrases
  phrases = loadStrings("phrases.txt");                       // load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases), new Random());  // randomize the order of the phrases with no seed
  
  // Scale targets and imagens to match screen resolution
  SCALE_FACTOR = 1.0 / displayDensity();          // scale factor for high-density displays
  String[] ppi_string = loadStrings("ppi.txt");   // the text from the file is loaded into an array.
  PPI = float(ppi_string[1]);                     // set PPI, we assume the ppi value is in the second line of the .txt
  PPCM = PPI / 2.54 * SCALE_FACTOR;               // do not change this!
  
  FINGER_SIZE = (int)(11 * PPCM);
  FINGER_OFFSET = (int)(0.8 * PPCM);
  ARM_LENGTH = (int)(19 * PPCM);
  ARM_HEIGHT = (int)(11.2 * PPCM);
  ARROW_SIZE = (int)(2.2 * PPCM);
}



void draw()
{ 
  // Check if we have reached the end of the study
  if (finishTime != 0)  return;
 
  background(255);                                                         // clear background
  
  // Draw arm and watch background
  imageMode(CENTER);
  image(arm, width/2, height/2, ARM_LENGTH, ARM_HEIGHT);
  
  // Check if we just started the application
  if (startTime == 0 && !mousePressed)
  {
    fill(0);
    textAlign(CENTER);
    text("Tap to start time!", width/2, height/2);
  }
  else if (startTime == 0 && mousePressed) nextTrial();                    // show next sentence
  
  // Check if we are in the middle of a trial
  else if (startTime != 0)
  {
    fill(240);
    rect(width/2 - 2.0 * PPCM , height/2 - 2.0 * PPCM, 4*PPCM, 4*PPCM);
    
    keyboard.draw();
    letter = keyboard.click();
    
    textAlign(LEFT);
    fill(100);
    text("Phrase " + (currTrialNum + 1) + " of " + NUM_REPEATS, width/2 - 4.0*PPCM, height/2 - 8.1*PPCM);   // write the trial count
    text("Target:    " + currentPhrase, width/2 - 4.0*PPCM, height/2 - 7.1*PPCM);                           // draw the target string
    fill(0);
    text("Entered:  " + currentTyped + "|", width/2 - 4.0*PPCM, height/2 - 6.1*PPCM);                      // draw what the user has entered thus far 
    
    // Draw very basic ACCEPT button - do not change this!
    textAlign(CENTER);
    noStroke();
    fill(0, 250, 0);
    rect(width/2 - 2*PPCM, height/2 - 5.1*PPCM, 4.0*PPCM, 2.0*PPCM);
    fill(0);
    text("ACCEPT >", width/2, height/2 - 4.1*PPCM);
    
    // Draw screen areas
    // simulates text box - not interactive
    noStroke();
    fill(125);
    rect(width/2 - 2.0*PPCM, height/2 - 2.0*PPCM, 4.0*PPCM, 1.0*PPCM);
    textAlign(CENTER);
    fill(0);
    textFont(createFont("Arial", 16));  // set the font to arial 24
    //text("NOT INTERACTIVE", width/2, height/2 - 1.3 * PPCM);            
    textFont(createFont("Arial", 24));  // set the font to arial 24
    
    
    // THIS IS THE ONLY INTERACTIVE AREA (4cm x 4cm); do not change size
    stroke(0, 200, 0);
    noFill();
    rect(width/2 - 2.0*PPCM, height/2 - 1.0*PPCM, 4.0*PPCM, 3.0*PPCM);
   
    // Draws circle that incapsulates the current letter
    stroke(0);
    fill(255);
    circle(width/2, height/2 - 1.5 * PPCM, 0.80*PPCM);
    // Write current letter
    textAlign(CENTER);
    fill(0);
    textFont(createFont("Arial Bold", 30));
    text("" + letter, width/2, height/2 - 1.37 * PPCM);             // draw current letter
    
    stroke(0);
    noFill();
    rect(width/2 - 2.0*PPCM, height/2 - 1.0*PPCM , 4.0*PPCM, 0.5*PPCM);
    
    textFont(createFont("Arial", 20));
    if(currentTyped.length() == 0){
        Prediction1 = r.show2Pref(0);
        Prediction2 = r.show2Pref(1);
        if(Prediction1.length() > 9)
          textFont(createFont("Arial", 18));
        else 
          textFont(createFont("Arial", 20));
        text(Prediction1, width/2 - 1.00 * PPCM, height/2 - 0.6 * PPCM);
        if(Prediction1.length() > 9)
          textFont(createFont("Arial", 17));
        else 
          textFont(createFont("Arial", 20));
        text(Prediction2, width/2 + 1.00 * PPCM, height/2 - 0.6 * PPCM);
    }
    else if(currentTyped.length()>0 && currentTyped.charAt(currentTyped.length()-1)==' '){
        String previous = getPreviousWord(currentTyped);
        Prediction1 = words.get(previous,0);
        Prediction2 = words.get(previous,1);
        if(Prediction1.length() > 9)
          textFont(createFont("Arial", 18));
        else 
          textFont(createFont("Arial", 20));
        text(Prediction1, width/2 - 1.00 * PPCM, height/2 - 0.6 * PPCM);
        if(Prediction2.length() > 9)
          textFont(createFont("Arial", 18));
        else 
          textFont(createFont("Arial", 20));
        text(Prediction2, width/2 + 1.00 * PPCM, height/2 - 0.6 * PPCM);
    }
    else{
        Prediction1 = r.get(wordTyped).show2Pref(0);
        Prediction2 = r.get(wordTyped).show2Pref(1);
        if(Prediction1.length() > 9)
          textFont(createFont("Arial", 18));
        else 
          textFont(createFont("Arial", 20));
        text(Prediction1, width/2 - 1.00 * PPCM, height/2 - 0.6 * PPCM);
        if(Prediction2.length() > 9)
          textFont(createFont("Arial", 18));
        else 
          textFont(createFont("Arial", 20));
        text(Prediction2, width/2 + 1.00 * PPCM, height/2 - 0.6 * PPCM);
    }
    textFont(createFont("Arial", 25));
    
   
  }
  
  // Draw the user finger to illustrate the issues with occlusion (the fat finger problem)
  imageMode(CORNER);
  image(fingerOcclusion, mouseX - FINGER_OFFSET, mouseY - FINGER_OFFSET, FINGER_SIZE, FINGER_SIZE);
}

// Check if mouse click was within certain bounds
boolean didMouseClick(float x, float y, float w, float h)
{
  return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
}


void mousePressed(MouseEvent evt)
{
  if (didMouseClick(width/2 - 2*PPCM, height/2 - 5.1*PPCM, 4.0*PPCM, 2.0*PPCM)) nextTrial();                         // Test click on 'accept' button - do not change this!
  else if(didMouseClick(width/2 - 2.0*PPCM, height/2 - 1.0*PPCM, 4.0*PPCM, 3.0*PPCM))  // Test click on 'keyboard' area - do not change this condition! 
  {
    
    if(letter == '*'){
      keyboard.switchSlice();
    }
    
    if(letter == '<'){
      deleteKey.play();
      deleteKey.amp(0.5);
    }
    else{
      keyPressed.play();
      keyPressed.amp(0.25);
    }
  
    if(didMouseClick(width/2 - 2.0* PPCM, height/2 - 1.0*PPCM, 2.0*PPCM, 0.5*PPCM)){
        currentTyped = deleteWordTyped(currentTyped);
        currentTyped += Prediction1;
        currentTyped += ' ';
        wordTyped = "";
    }
    
    if(didMouseClick(width/2 - 0.0* PPCM, height/2 - 1.0*PPCM, 2.0*PPCM, 0.5*PPCM)){
        currentTyped = deleteWordTyped(currentTyped);
        currentTyped += Prediction2;
        currentTyped += ' ';
        wordTyped = "";
    }
    
    
    if(letter != ' ' && letter != '2' && letter != '1' && letter != '*')
      if(letter == '_'){
        currentTyped += ' ';
        wordTyped = "";
      }
      else if(letter == '<'){
        currentTyped = removeLastCharacter(currentTyped);
        wordTyped = removeLastCharacter(wordTyped);
      }
      else{
        currentTyped += letter;
        wordTyped += letter;
      }
  }
  
  else System.out.println("debug: CLICK NOT ACCEPTED");
}

/*void mouseDragged(){
  if(keyboard == 0){
    keyboard = 1;
  }
  else
    keyboard = 0;
}*/


void nextTrial()
{
  if (currTrialNum >= NUM_REPEATS) return;                                            // check to see if experiment is done
  
  // Check if we're in the middle of the tests
  else if (startTime != 0 && finishTime == 0)                                         
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + NUM_REPEATS);
    System.out.println("Target phrase: " + currentPhrase);
    System.out.println("Phrase length: " + currentPhrase.length());
    System.out.println("User typed: " + currentTyped);
    System.out.println("User typed length: " + currentTyped.length());
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim()));
    System.out.println("Time taken on this trial: " + (millis() - lastTime));
    System.out.println("Time taken since beginning: " + (millis() - startTime));
    System.out.println("==================");
    lettersExpectedTotal += currentPhrase.trim().length();
    lettersEnteredTotal += currentTyped.trim().length();
    errorsTotal += computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
    typed[currTrialNum] = currentTyped;
  }
  
  // Check to see if experiment just finished
  if (currTrialNum == NUM_REPEATS - 1)                                           
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime));
    System.out.println("Total letters entered: " + lettersEnteredTotal);
    System.out.println("Total letters expected: " + lettersExpectedTotal);
    System.out.println("Total errors entered: " + errorsTotal);

    float wpm = (lettersEnteredTotal / 5.0f) / ((finishTime - startTime) / 60000f);   // FYI - 60K is number of milliseconds in minute
    float freebieErrors = lettersExpectedTotal * .05;                                 // no penalty if errors are under 5% of chars
    float penalty = max(0, (errorsTotal - freebieErrors) / ((finishTime - startTime) / 60000f));
    
    float cpm = (lettersEnteredTotal) / ((finishTime - startTime) / 60000f);
    
    System.out.println("Raw WPM: " + wpm);
    System.out.println("Freebie errors: " + freebieErrors);
    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm - penalty));                         // yes, minus, because higher WPM is better: NET WPM
    System.out.println("==================");
    
    printResults(wpm, freebieErrors, penalty, cpm);
    
    currTrialNum++;                                                                   // increment by one so this mesage only appears once when all trials are done
    return;
  }

  else if (startTime == 0)                                                            // first trial starting now
  {
    System.out.println("Trials beginning! Starting timer...");
    startTime = millis();                                                             // start the timer!
  } 
  else currTrialNum++;                                                                // increment trial number

  lastTime = millis();                                                                // record the time of when this trial ended
  currentTyped = "";                                                                  // clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum];                                              // load the next phrase!
}

// Print results at the end of the study
void printResults(float wpm, float freebieErrors, float penalty, float cpm)
{
  background(0);       // clears screen
  
  textFont(createFont("Arial", 16));    // sets the font to Arial size 16
  fill(255);    //set text fill color to white
  text(day() + "/" + month() + "/" + year() + "  " + hour() + ":" + minute() + ":" + second(), 100, 20);   // display time on screen
  
  text("Finished!", width / 2, height / 2); 
  
  int h = 20;
  for(int i = 0; i < NUM_REPEATS; i++, h += 40 ) {
    text("Target phrase " + (i+1) + ": " + phrases[i], width / 2, height / 2 + h);
    text("User typed " + (i+1) + ": " + typed[i], width / 2, height / 2 + h+20);
  }
  
  text("Raw WPM: " + wpm, width / 2, height / 2 + h+20);
  text("Freebie errors: " + freebieErrors, width / 2, height / 2 + h+40);
  text("Penalty: " + penalty, width / 2, height / 2 + h+60);
  text("WPM with penalty: " + max((wpm - penalty), 0), width / 2, height / 2 + h+80);
  text("Character Per Minute : " + cpm, width / 2, height / 2 + h+100);

  saveFrame("results-######.png");    // saves screenshot in current folder    
}

// This computes the error between two strings (i.e., original phrase and user input)
int computeLevenshteinDistance(String phrase1, String phrase2)
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++) distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++) distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
