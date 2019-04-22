//Bert Love
//FOCS Period 2 Capstone Project: Baseball Bonanza

PImage baseballbat; //setting up image variables
PImage rotatebat;
PImage baseball;
PImage arrow;
PImage batter;

float ballxPos;  //baseball's X position
float ballyPos;  //baseball's Y position
float ballxSpeed;  //ball's horizontal speed
float ballySpeed;  //ball's vertical speed
float ballspeed;  //ball's horizontal speed (randomly generated)
float randomYspeed;  //vert speed (randomly generated)
float rememberXspeed; //set to equal ballspeed for pausing purposes
float rememberYspeed; //set to equal ball's yspeed for pausing
float curvefactor; //how sharp the ball curves

String tips[] = {"Tip: Swing Early!", "Tip: Curveballs start moving up!", "Tip: Start on easy difficulty!"};
String tip; //variable to be set equal to one of the above tips
String runsscored; //runs scored on each play
String lastplay; //displays outcome of last play

int strikes; //counting variables
int balls;
int outs;
int innings;
int teamruns;
int oppruns;
int oppscoring;

int runner1 = 0; //runner variables
int runner2 = 0;
int runner3 = 0;

int screen; //determines startscreen or game
int difficulty; //determines difficulty
int tsl; //lines of outcome slots
int bsl; //change according to difficulty
int tdl;
int bdl;
int thrl;
int bhrl;
int holdtimer; //counts when mouse is pressed
int timerlimit; //how long bat is allowed to be swung
int balldiff; //difference between ball's actual and perceived Ypos
boolean pause; //whether or not game is paused
boolean curve; //whether or not difficulty will have curveballs


void setup() {
  size(850, 650);
  background(0);
  noStroke();
  
  //initializing images
  baseballbat = loadImage("bb2.png");
  rotatebat = loadImage("bb2.png");
  baseball = loadImage("baseball.png");
  arrow = loadImage("arrow.png");
  batter = loadImage("swingitfam.png");
  
  //setting up first pitch
  ballxPos = 750; //always starts ball at 750
  ballyPos = (int) random(440, 540); //random y position
  ballySpeed = 0; //first pitch is flat
  ballxSpeed = 12;  //first pitch moves at speed 12
  rememberXspeed = ballxSpeed;
  balldiff = 20;
  
  lastplay = "NEW GAME!"; //initializing counting/text variables
  runsscored = " ";
  innings = 1;
  oppruns = 0;
  teamruns = 0;
  
  screen = 0; //set to startscreen
  difficulty = 0; //no difficulty chosen yet
  pause = false; //game cannot start paused
  
  for(int i = (int) random(0, 3); i < 4; i = i + 4){
    tip = tips[i]; //randomly selects a tip to be displayed
  }
}


void draw() {
  if(screen == 0){
    startscreen(); //runs start screen at beginning of game
  }
  
  if(screen == 1){ //runs the actual game functions
    drawbat(); 
    drawball();
    variablecounters();
    outcomeslots();
    screentext();
    drawbases();
    startover();
    mercyrule();
    
    if(innings > 9){
      enddisplay(); //when innings exceed 9, end game program runs
    }
  }
}


void startscreen(){
  //all text and images shown on screen
  background(0);
  fill(255);
  textFont(createFont("Calibri", 35));
  textAlign(CENTER);
  text("Are you ready to play BASEBALL BONANZA?", width/2, height/2 - 220);
  text(tip, width/2, 550);
  textFont(createFont("Calibri", 25));
  text("Left-click your mouse to hit the ball.", width/2, height/2 - 150);
  text("Where the ball hits on the screen determines the hit result.", width/2, height/2 - 110);
  text("First, choose your difficulty:", width/2, height/2 - 20);
  text("Press 'p' to pause.", width/2, 600);
  image(batter, 640, 450, 190, 180);
  
  if(difficulty == 0){ //when a difficulty hasn't been selected (= 0),
    fill(0, 255, 0); //difficulty selection buttons aren't shown
    text("Easy", 180, height/2 + 30);
    fill(255, 255, 0);
    text("Medium", 330, height/2 + 30);
    fill(255, 100, 0);
    text("Hard", 477, height/2 + 30);
    fill(255, 0, 0);
    text("EXTREME", 632, height/2 + 30);
    
    //easy
    fill(255, 0, 0);
    rect(140, height/2, 80, 2);
    rect(140, height/2 + 40, 80, 2);
    rect(140, height/2, 2, 40);
    rect(220, height/2, 2, 42);
    if(mousePressed == true && mouseButton == LEFT && mouseX > 140 && mouseX < 220 && mouseY > height/2 && mouseY < height/2 + 40){
      difficulty = 1; //if user clicks on easy button, difficulty is set
    }
    
    //medium
    rect(270, height/2, 120, 2);
    rect(270, height/2 + 40, 120, 2);
    rect(270, height/2, 2, 40);
    rect(390, height/2, 2, 42);
    if(mousePressed == true && mouseButton == LEFT && mouseX > 270 && mouseX < 390 && mouseY > height/2 && mouseY < height/2 + 40){
      difficulty = 2; //if user clicks on medium button, difficulty is set
    }
    
    //hard
    rect(437, height/2, 80, 2);
    rect(437, height/2 + 40, 80, 2);
    rect(437, height/2, 2, 40);
    rect(517, height/2, 2, 42);
    if(mousePressed == true && mouseButton == LEFT && mouseX > 437 && mouseX < 517 && mouseY > height/2 && mouseY < height/2 + 40){
      difficulty = 3; //if user clicks on hard button, difficulty is set
    }
    
    //extreme
    rect(565, height/2, 132, 2);
    rect(565, height/2 + 40, 132, 2);
    rect(565, height/2, 2, 40);
    rect(697, height/2, 2, 42);
    if(mousePressed == true && mouseButton == LEFT && mouseX > 565 && mouseX < 667 && mouseY > height/2 && mouseY < height/2 + 40){
      difficulty = 4; //if user clicks on extreme button, difficulty is set
    }
  }
  
  if(difficulty > 0){ //after difficulty is selected, chosen difficulty
    fill(255, 0, 0); //is shown and "start game" option is available
    rect(width/2 - 70, height/2 + 96, 2, 45);
    rect(width/2 + 66, height/2 + 96, 2, 47);
    rect(width/2 - 70, height/2 + 96, 136, 2);
    rect(width/2 - 70, height/2 + 141, 136, 2);
    fill(255);
    text("Let's Go!", width/2, height/2+130);
    text("You chose:", 370, height/2+40);
    //sets text to be shown after "you chose"
    if(difficulty == 1){
      fill(0, 255, 0);
      text("Easy", 495, height/2+40);
    }
  
    if(difficulty == 2){
      fill(255, 255, 0);
      text("Medium", 495, height/2+40);
    }
  
    if(difficulty == 3){
      fill(255, 100, 0);
      text("Hard", 495, height/2+40);
    }
    
    if(difficulty == 4){
      fill(255, 0, 0);
      text("Extreme", 500, height/2+40);
    }
    
    if(mousePressed == true && mouseButton == LEFT && mouseX > width/2 - 70 && mouseX < width/2 + 66 && mouseY > height/2 + 96 && mouseY < height/2 + 141){
      screen = 1; //when user selects "lets go", screen is set to 1, which runs the game
    }
  }
}


void drawbat() {
  if(mousePressed == true && mouseButton == LEFT){
    holdtimer++; //counts when mouse is pressed
  }
  else{
    holdtimer = 0; //resets when mouse isn't pressed
  }
    
  background(0); //bat follows mouse if game isn't paused and mouse is on left half of screen
  if(mouseX < 400 && pause == false){
    image(baseballbat, mouseX-12, mouseY-15, 23, 230);
    //swings bat when mouse is pressed
    if(mousePressed == true && mouseButton == LEFT && holdtimer < timerlimit && pause == false){
      background(0);
      image(rotatebat, mouseX-90, mouseY-10, 250, 230);
    }
  }
  //if bat is on right half of screen, doesn't follow mouseX
  else if (pause == false){
    image(baseballbat, 400, mouseY, 23, 230);
  }
}


void resetball(){ //used to reset ball after each play
  delay(750); //pause in game
  ballxPos = 750; //resets ball's x position
  ballyPos = (int) random(440, 540); //random ball yPos
  ballxSpeed = ballspeed; //sets xSpeed equal to a variable generated later
  ballySpeed = randomYspeed; //sets ySpeed equal to a variable generated later
}


void drawball() {
  if(difficulty == 1){ //different factors based on difficulty
    ballspeed = (int) random(8, 12); //range of random ballspeeds
    randomYspeed = random(-.2, .2); //range of random yspeeds
    curve = false; //ball won't curve
    timerlimit = 80; //how long bat can be swung
  }
  
  if(difficulty == 2){
    ballspeed = (int) random(12, 18);
    randomYspeed = random(-.2, 1);
    curve = true; //ball will curve
    curvefactor = random(1, 2); //range of how much ball can curve
    timerlimit = 60;
  }
  
  if(difficulty == 3){
    ballspeed = (int) random(16, 22);
    randomYspeed = random(-.2, 1);
    curve = true;
    curvefactor = random(2, 3);
    timerlimit = 50;
  }
  
  if(difficulty == 4){
    ballspeed = (int) random(24, 32);
    randomYspeed = random(-.2, 1.2);
    curve = true;
    curvefactor = random(3, 5);
    timerlimit = 40;
  }
  
  //Setting up ball & variables
  image(baseball, ballxPos, ballyPos, 25, 25);
  ballxPos = ballxPos - ballxSpeed; //ball moves horizontally
  ballyPos = ballyPos - ballySpeed; //ball moves vertically
  
  if(ballxPos < 400 && ballySpeed > .4 && curve == true  && ballxSpeed > 0){ //if ySpeed is high enough and difficulty allows curving,
    ballySpeed = ballySpeed - curvefactor; //yspeed decreases gradually, causing the ball to curve
    rememberYspeed = ballySpeed; //remembers yspeed if game is paused
  }
  
  //ball hits left side of screen (strike)
  if(ballxPos <= -20){  //strike
    resetball(); //resets ball
    rememberXspeed = ballxSpeed;
    rememberYspeed = ballySpeed;
    strikes++; //adds to strikes
    lastplay = "Strike!";
    runsscored = " "; //no runs were scored
  }
  
  //ball hits bat if bat is swung
  if(mouseX <= ballxPos + 10 && mouseX >= ballxPos-(ballxSpeed + 55) && mouseY <= ballyPos+35 && mouseY >= ballyPos-70 && mousePressed == true && mouseButton == LEFT && holdtimer < timerlimit && mouseX < 400 && pause == false){
    ballxSpeed = -ballxSpeed-5; //reverses ball's xspeed
    ballySpeed = (((mouseY+37)-ballyPos)/3.5); //sets yspeed based on difference between bat and ball position
    ballxPos = ballxPos+30; //ball jumps forward a bit to prevent hitting it twice
  }
  
  //ball hits top of screen
  if(ballyPos+20 <= 0){
    resetball();
    outs++; //adds to outs
    lastplay = "Out";
    runsscored = " ";
  }
  
  //ball hits bottom of screen
  if(ballyPos-20 >= 650){
    resetball();
    outs++;
    lastplay = "Out";
    runsscored = " ";
  }
}


void outcomeslots(){
  //sets up outcome lines based on difficulty
  if(difficulty == 1){
    tsl = 90; //top single line
    bsl = 410; //bottom single line
    tdl = 175; //top double line
    bdl = 325; //bottom double line
    thrl = 230; //top home run line
    bhrl = 270; //bottom home run line
  }
  
  if(difficulty == 2){
    tsl = 145;
    bsl = 385;
    tdl = 210;
    bdl = 320;
    thrl = 250;
    bhrl = 280;
    balldiff = 21;
  }
  
  if(difficulty == 3){
    tsl = 185;
    bsl = 355;
    tdl = 230;
    bdl = 310;
    thrl = 260;
    bhrl = 280;
    balldiff = 25;
  }
    
  if(difficulty == 4){
    tsl = 210;
    bsl = 350;
    tdl = 255;
    bdl = 305;
    thrl = 275;
    bhrl = 285;
    balldiff = 25;
  }

  //Out/Single Lines
  textAlign(800);
  fill(255);
  rect(800, tsl, 50, 3);
  rect(800, bsl, 50, 3);
  //single text
  fill(255);
  textFont(createFont("Calibri", 16));
  text("Single", 808, tsl+((tdl-tsl)/2)+5);
  text("Single", 808, bsl-((bsl-bdl)/2)+5);
  
  //Single/Double Lines
  fill(255, 255, 0);
  rect(800, tdl, 50, 3);
  rect(800, bdl, 50, 3);
  //double text
  fill(255, 255, 0);
  text("Double", 800, tdl+((thrl-tdl)/2)+5);
  text("Double", 800, bdl-((bdl-bhrl)/2)+5);
  
  //Double/HR Lines
  fill(255, 0, 255);
  rect(800, bhrl, 50, 3);
  rect(800, thrl, 50, 3);
  //home run text
  fill(255, 0, 255);
  if(difficulty < 4){
    text("Home Run", 780, thrl-((thrl-bhrl)/2)+5);
  }
  if(difficulty == 4){
    text("Home Run", 730, thrl-((thrl-bhrl)/2)+5);
  }
  
  //Outs
  if(ballxPos > 850+ballspeed && ballyPos >= bsl-balldiff || ballxPos > 850+ballspeed && ballyPos <= tsl-balldiff){
    outs++; //if ball hits outside of lines, outs is increased
    strikes = 0; //strikes reset
    lastplay = "Out";
    runsscored = " ";
    resetball(); //ball reset
  }
  
  //text
  fill(255, 0, 0);
  text("Out", 820, (tsl/2)+5);
  text("Out", 820, bsl+((650-bsl)/2));
  
  //RUNNERS
   
  if(runner1 == 0 && runner2 == 0 && runner3 == 0 ){  //nobody on
    //Single
    if(ballxPos > 850+ballspeed && ballyPos >= bdl-balldiff && ballyPos < bsl-balldiff || ballxPos > 850+ballspeed && ballyPos > tsl-balldiff && ballyPos <= tdl-balldiff){
      lastplay = "Single"; //ball (minus balldiff) hits within single lines
      runsscored = " ";
      runner1++; //lead runner is put on first
      resetball(); //ball is reset
    }
    
    //Double
    if(ballxPos > 850+ballspeed && ballyPos >= bhrl-balldiff && ballyPos < bdl-balldiff || ballxPos > 850+ballspeed && ballyPos > tdl-balldiff && ballyPos <= thrl-balldiff){
      lastplay = "Double"; //ball hits between double lines
      runsscored = " ";
      strikes = 0;
      runner1 = 2; //lead runner is put on second
      resetball(); //ball is reset
    }
      
    //Home Run
    if(ballxPos > 860 && ballyPos > thrl-balldiff && ballyPos < bhrl-balldiff){
      lastplay = "HOME RUN!"; //ball hits between home run lines
      strikes = 0;
      teamruns++; //one is added to your team's runs
      runsscored = "1 run scored!";
      resetball(); //ball is reset
    }
  }
  
  if(runner1 == 1 && runner2 == 0 && runner3 == 0){  //runner on 1st
   //Single
    if(ballxPos > 860 && ballyPos >= bdl-balldiff && ballyPos < bsl-balldiff || ballxPos > 860 && ballyPos > tsl-balldiff && ballyPos <= tdl-balldiff){
      lastplay = "Single";
      runsscored = " ";
      strikes = 0;
      runner1++; //lead runner moves to second
      runner2++; //second runner on first
      resetball();
    }
    
    //Double
    if(ballxPos > 860 && ballyPos >= bhrl-balldiff && ballyPos < bdl-balldiff || ballxPos > 860 && ballyPos > tdl-balldiff && ballyPos <= thrl-balldiff){
      lastplay = "Double";
      runsscored = " ";
      strikes = 0;
      runner1 = 3; //lead runner moves to third
      runner2 = 2; //second runner moves to second
      resetball();
    }
      
    //Home Run
    if(ballxPos > 860 && ballyPos > thrl-balldiff && ballyPos < bhrl-balldiff){
      lastplay = "HOME RUN!";
      strikes = 0;
      teamruns = teamruns + 2;
      runsscored = "2 runs scored!";
      runner1 = 0; //runners are reset
      resetball();
      }
    }
    
  if(runner1 == 2 && runner2 == 0 && runner3 == 0){  //runner on 2nd
   //Single
    if(ballxPos > 860 && ballyPos >= bdl-balldiff && ballyPos < bsl-balldiff || ballxPos > 860 && ballyPos > tsl-balldiff && ballyPos <= tdl-balldiff){
      lastplay = "Single";
      runsscored = " ";
      strikes = 0;
      runner1++;
      runner2++;
      resetball();
    }
    
    //Double
    if(ballxPos > 860 && ballyPos >= bhrl-balldiff && ballyPos < bdl-balldiff || ballxPos > 860 && ballyPos > tdl-balldiff && ballyPos <= thrl-balldiff){
      lastplay = "Double";
      strikes = 0;
      teamruns++;
      runsscored = "1 run scored!";
      resetball();
    }
      
    //Home Run
    if(ballxPos > 860 && ballyPos > thrl-balldiff && ballyPos < bhrl-balldiff){
      lastplay = "HOME RUN!";
      strikes = 0;
      teamruns = teamruns + 2;
      runsscored = "2 runs scored!";
      runner1 = 0;
      resetball();
      }
    }
    
  if(runner1 == 2 && runner2 == 1 && runner3 == 0){  //runners on 1st and 2nd
   //Single
    if(ballxPos > 860 && ballyPos >= bdl-balldiff && ballyPos < bsl-balldiff || ballxPos > 860 && ballyPos > tsl-balldiff && ballyPos <= tdl-balldiff){
      lastplay = "Single";
      runsscored = " ";
      strikes = 0;
      runner1++;
      runner2++;
      runner3++;
      resetball();
    }
    
    //Double
    if(ballxPos > 860 && ballyPos >= bhrl-balldiff && ballyPos < bdl-balldiff || ballxPos > 860 && ballyPos > tdl-balldiff && ballyPos <= thrl-balldiff){
      lastplay = "Double";
      strikes = 0;
      teamruns++;
      runsscored = "1 run scored!";
      runner1 = 3;
      runner2 = 2;
      resetball();
    }
      
    //Home Run
    if(ballxPos > 860 && ballyPos > thrl-balldiff && ballyPos < bhrl-balldiff){
      lastplay = "HOME RUN!";
      strikes = 0;
      teamruns = teamruns + 3;
      runsscored = "3 runs scored!";
      runner1 = 0;
      runner2 = 0;
      resetball();
      }
    }
  
  if(runner1 == 3 && runner2 == 2 && runner3 == 1){  //bases loaded
  //Single
    if(ballxPos > 860 && ballyPos >= bdl-balldiff && ballyPos < bsl-balldiff || ballxPos > 860 && ballyPos > tsl-balldiff && ballyPos <= tdl-balldiff){
      lastplay = "Single";
      strikes = 0;
      teamruns++;
      runsscored = "1 run scored!";
      resetball();
    }
    
    //Double
    if(ballxPos > 860 && ballyPos >= bhrl-balldiff && ballyPos < bdl-balldiff || ballxPos > 860 && ballyPos > tdl-balldiff && ballyPos <= thrl-balldiff){
      lastplay = "Double";
      strikes = 0;
      teamruns = teamruns + 2;
      runsscored = "2 runs scored!";
      runner1 = 3;
      runner2 = 2;
      runner3 = 0;
      resetball();
    }
      
    //Home Run
    if(ballxPos > 860 && ballyPos > thrl-balldiff && ballyPos < bhrl-balldiff){
      lastplay = "GRAND SLAM!";
      strikes = 0;
      teamruns = teamruns + 4;
      runsscored = "4 runs scored!";
      runner1 = 0;
      runner2 = 0;
      runner3 = 0;
      resetball();
      }
    }
  
  if(runner1 == 3 && runner2 == 1 && runner3 == 0){  //runners on 1st and 3rd
   //Single
    if(ballxPos > 860 && ballyPos >= bdl-balldiff && ballyPos < bsl-balldiff || ballxPos > 860 && ballyPos > tsl-balldiff && ballyPos <= tdl-balldiff){
      lastplay = "Single";
      strikes = 0;
      runner1 = 2;
      runner2 = 1;
      teamruns++;
      runsscored = "1 run scored!";
      resetball();
    }
    
    //Double
    if(ballxPos > 860 && ballyPos >= bhrl-balldiff && ballyPos < bdl-balldiff || ballxPos > 860 && ballyPos > tdl-balldiff && ballyPos <= thrl-balldiff){
      lastplay = "Double";
      strikes = 0;
      teamruns++;
      runsscored = "1 run scored!";
      runner1 = 3;
      runner2 = 2;
      resetball();
    }
      
    //Home Run
    if(ballxPos > 860 && ballyPos > thrl-balldiff && ballyPos < bhrl-balldiff){
      lastplay = "HOME RUN!";
      strikes = 0;
      teamruns = teamruns + 3;
      runsscored = "3 runs scored!";
      runner1 = 0;
      runner2 = 0;
      resetball();
      }
    }
  
  if(runner1 == 3 && runner2 == 2 && runner3 == 0){  //runners on 2nd and 3rd
  //Single
    if(ballxPos > 860 && ballyPos >= bdl-balldiff && ballyPos < bsl-balldiff || ballxPos > 860 && ballyPos > tsl-balldiff && ballyPos <= tdl-balldiff){
      lastplay = "Single";
      strikes = 0;
      runner1 = 3;
      runner2 = 1;
      teamruns++;
      runsscored = "1 run scored!";
      resetball();
    }
    
    //Double
    if(ballxPos > 860 && ballyPos >= bhrl-balldiff && ballyPos < bdl-balldiff || ballxPos > 860 && ballyPos > tdl-balldiff && ballyPos <= thrl-balldiff){
      lastplay = "Double";
      strikes = 0;
      teamruns = teamruns + 2;
      runsscored = "2 runs scored!";
      runner1 = 2;
      runner2 = 0;
      resetball();
    }
      
    //Home Run
    if(ballxPos > 860 && ballyPos > thrl-balldiff && ballyPos < bhrl-balldiff){
      lastplay = "HOME RUN!";
      strikes = 0;
      teamruns = teamruns + 3;
      runsscored = "3 runs scored!";
      runner1 = 0;
      runner2 = 0;
      resetball();
      }
    }
    
  if(runner1 == 3 && runner2 == 0 && runner3 == 0){  //runner on 3rd
  //Single
    if(ballxPos > 860 && ballyPos >= bdl-balldiff && ballyPos < bsl-balldiff || ballxPos > 860 && ballyPos > tsl-balldiff && ballyPos <= tdl-balldiff){
      lastplay = "Single";
      strikes = 0;
      teamruns++;
      runsscored = "1 run scored!";
      runner1 = 1;
      resetball();
    }
    
    //Double
    if(ballxPos > 860 && ballyPos >= bhrl-balldiff && ballyPos < bdl-balldiff || ballxPos > 860 && ballyPos > tdl-balldiff && ballyPos <= thrl-balldiff){
      lastplay = "Double";
      strikes = 0;
      teamruns++;
      runsscored = "1 run scored!";
      runner1 = 2;
      resetball();
    }
      
    //Home Run
    if(ballxPos > 860 && ballyPos > thrl-balldiff && ballyPos < bhrl-balldiff){
      lastplay = "HOME RUN!";
      strikes = 0;
      teamruns = teamruns + 2;
      runsscored = "2 runs scored!";
      runner1 = 0;
      resetball();
    }
  }
}


void variablecounters(){
  if(difficulty == 1){ //sets random opponent scoring based on difficulty
    oppscoring = (int) random(0, 2); //range of how many runs can be scored per inning
  }
  
  if(difficulty == 2){
    oppscoring = (int) random(0, 3);
  }
  
  if(difficulty == 3){
    oppscoring = (int) random(0, 4);
  }
  
  if(difficulty == 4){
    oppscoring = (int) random(0, 5);
  }
  
  if(strikes > 2){ //when strikes exceed 2
    outs++; //an out is added
    strikes = 0; //and strikes are reset
    lastplay = "Strikeout!";
  }
  
  if(outs > 2){ //when outs exceed 2
    innings++; //an inning is added
    outs = 0; //and outs are reset
    oppruns = oppruns + oppscoring;
    runsscored = "Opponent Scored " + oppscoring + " runs";
    lastplay = "New inning!";
    //runners reset
    runner1 = 0;
    runner2 = 0;
    runner3 = 0;
  }
}


void screentext(){ //all text shown on screen
  textFont(createFont("Calibri", 24)); //sets up text parameters
  textAlign(CENTER);
  //Last Play
  fill(255);
  text("Last Play:", width/2, 80);
  text(lastplay, width/2, 120);
  text(runsscored, width/2, 160);
  
  //# Strikes
  textFont(createFont("Calibri", 18));
  textAlign(100);
  fill(255);
  text("Strikes:  " + strikes, 20, 150);
  
  //# Outs
  fill(255);
  text("Outs:  " + outs, 20, 200);
  
  //# Innings
  fill(255);
  text("Inning:  " + innings, 20, 250);
  
  //Opponent Runs
  fill(50, 255, 255);
  text("Opp. Score = " + oppruns, 270, 35);
  
  //Team Runs
  fill(50, 255, 255);
  text("Your Score = " + teamruns, 430, 35);
  
  //Hold Bat
  if(holdtimer > timerlimit){
    textFont(createFont("Calibri", 24));
    fill(255); //if bat is held too long, text is shown
    text("Don't swing the bat for too long!", width/2-190, height/2);
  }
}


void drawbases(){ //displays state of runners on base
  if(runner1 == 0 && runner2 == 0 && runner3 == 0 ){  //nobody on
    fill(200);  //2nd base
    rect(55, 20, 25, 25);
    fill(200);  //3rd base
    rect(20, 50, 25, 25);
    fill(200);  //1st base
    rect(90, 50, 25, 25);
    fill(200);  //home plate
    rect(55, 80, 25, 25);
  }
  
  if(runner1 == 1 && runner2 == 0 && runner3 == 0){  //runner on 1st
    fill(200);  //2nd base
    rect(55, 20, 25, 25);
    fill(200);  //3rd base
    rect(20, 50, 25, 25);
    fill(255, 155, 0);  //1st base
    rect(90, 50, 25, 25);
    fill(200);  //home plate
    rect(55, 80, 25, 25);
  }
  
  if(runner1 == 2 && runner2 == 0 && runner3 == 0){  //runner on 2nd
    fill(255, 155, 0);  //2nd base
    rect(55, 20, 25, 25);
    fill(200);  //3rd base
    rect(20, 50, 25, 25);
    fill(200);  //1st base
    rect(90, 50, 25, 25);
    fill(200);  //home plate
    rect(55, 80, 25, 25);
  }
  
  if(runner1 == 2 && runner2 == 1 && runner3 == 0){  //runners on 1st and 2nd
    fill(255, 155, 0);  //2nd base
    rect(55, 20, 25, 25);
    fill(200);  //3rd base
    rect(20, 50, 25, 25);
    fill(255, 155, 0);  //1st base
    rect(90, 50, 25, 25);
    fill(200);  //home plate
    rect(55, 80, 25, 25);
  }

  if(runner1 == 3 && runner2 == 2 && runner3 == 1){  //bases loaded
    fill(255, 155, 0);  //2nd base
    rect(55, 20, 25, 25);
    fill(255, 155, 0);  //3rd base
    rect(20, 50, 25, 25);
    fill(255, 155, 0);  //1st base
    rect(90, 50, 25, 25);
    fill(200);  //home plate
    rect(55, 80, 25, 25);
  }

  if(runner1 == 3 && runner2 == 1 && runner3 == 0){  //runners on 1st and 3rd
    fill(200);  //2nd base
    rect(55, 20, 25, 25);
    fill(255, 155, 0);  //3rd base
    rect(20, 50, 25, 25);
    fill(255, 155, 0);  //1st base
    rect(90, 50, 25, 25);
    fill(200);  //home plate
    rect(55, 80, 25, 25);
  }

  if(runner1 == 3 && runner2 == 2 && runner3 == 0){  //runners on 2nd and 3rd
    fill(255, 155, 0);  //2nd base
    rect(55, 20, 25, 25);
    fill(255, 155, 0);  //3rd base
    rect(20, 50, 25, 25);
    fill(200);  //1st base
    rect(90, 50, 25, 25);
    fill(200);  //home plate
    rect(55, 80, 25, 25);
  }
  
  if(runner1 == 3 && runner2 == 0 && runner3 == 0){  //runner on 3rd
    fill(200);  //2nd base
    rect(55, 20, 25, 25);
    fill(255, 155, 0);  //3rd base
    rect(20, 50, 25, 25);
    fill(200);  //1st base
    rect(90, 50, 25, 25);
    fill(200);  //home plate
    rect(55, 80, 25, 25);
  }
}

//pause & startover functions
void startover(){
  fill(255); //displays text for buttons
  textFont(createFont("Calibri", 16));
  text("Start Over", 750, 570);
  text("Pause", 767, 620);
  
  //pause lines
  fill(255, 0, 0);
  rect(740, 598, 2, 30);
  rect(840, 598, 2, 32);
  rect(740, 598, 100, 2);
  rect(740, 628, 100, 2);
  //start over lines
  rect(740, 548, 2, 30);
  rect(840, 548, 2, 32);
  rect(740, 548, 100, 2);
  rect(740, 578, 100, 2);
  
  //start over
  if(mousePressed == true && mouseButton == LEFT && mouseX > 740 && mouseX < 840 && mouseY > 548 && mouseY < 578){
    background(0); //if mouse is pressed within startover box,
    ballxPos = 750; //all game variables are reset
    ballyPos = (int) random(400, 500);
    ballySpeed = 0;
    ballxSpeed = ballspeed;
  
    lastplay = "NEW GAME!";
    runsscored = " ";
    innings = 1;
    oppruns = 0;
    teamruns = 0;
    strikes = 0;
    outs = 0;
    runner1 = 0;
    runner2 = 0;
    runner3 = 0;
      
    screen = 0; //back to start screen
    difficulty = 0; //back to no difficulty
    pause = false;
    
  for(int i = (int) random(0, 3); i < 4; i = i + 4){
    tip = tips[i]; //generates a new tip
  }
  }
  
  if(pause == false && mousePressed == true && mouseButton == LEFT && mouseX > 740 && mouseX < 840 && mouseY > 598 && mouseY < 628 || pause == false && keyPressed == true && key == 'p'){
    pause = true;  //if the game isnt paused and the mouse presses in the pause button area or presses "p", the pause variable becomes true
  }
  
  if(pause == true){
    ballspeed = 0;
    ballxSpeed = 0;
    ballySpeed = 0;
    fill(255); //if pause is true, ball stays still
    rect(width/2-50, height/2-50, 30, 100);
    rect(width/2+20, height/2-50, 30, 100);
    textAlign(CENTER); //shows pause instructions
    text("Press space to resume", width/2, height/2 + 100);
  }
  
  if(pause == true && keyPressed == true && key == ' '){
    pause = false; //when game is paused and space is pressed, game becomes unpaused
    ballxSpeed = rememberXspeed; //ball is set to the remember variables as ballxspeed,
    ballySpeed = rememberYspeed; //ballyspeed, and ballspeed were set to zero
  }
}

//if difference between team and opponent runs becomes too high,
void mercyrule(){ //game is stopped
  if(teamruns > oppruns + 20 && innings < 8 || oppruns > teamruns + 20 && innings < 8){
    textFont(createFont("Calibri", 35));
    textAlign(CENTER);
    fill(0, 255, 100);
    text("MERCY RULE! Try another difficulty!", width/2, height/2);
    //stops ball, shows arrow pointing to "start over"
    image(arrow, 660, 546, 70, 35);
    ballspeed = 0;
    ballxSpeed = 0;
    ballySpeed = 0;
  }
}


void enddisplay(){
  lastplay = "End of Game!";
  //win
  if(teamruns > oppruns){
    textFont(createFont("Calibri", 70));
    textAlign(CENTER);
    fill(0, 255, 0);
    text("YOU WIN!", width/2, height/2 - 50);
    //shows text after winning
    textFont(createFont("Calibri", 35));
    fill(255);
    text("Great job! Think you can do it again?", width/2, height/2 + 20);
  }
  
  //lose
  if(oppruns > teamruns){
    textFont(createFont("Calibri", 70));
    textAlign(CENTER);
    fill(255, 0, 0);
    text("YOU LOSE!", width/2, height/2 - 50);
    //shows text after losing
    textFont(createFont("Calibri", 35));
    fill(255);
    text("Better luck next time!", width/2, height/2 + 20);
  }
  
  //tie
  if(oppruns == teamruns){
    textFont(createFont("Calibri", 70));
    textAlign(CENTER);
    fill(255, 255, 0);
    text("YOU TIED!", width/2, height/2 - 50);
    //shows text after tying
    textFont(createFont("Calibri", 30));
    fill(255);
    text("I thought ties didn't happen in baseball?", width/2, height/2 + 20);
  }
  //reset ball
  ballxSpeed = 0;
  ballySpeed = 0;
  ballyPos = 450;
  ballxPos = 750;
  //arrow pointing to "start over"
  image(arrow, 660, 546, 70, 35);
}