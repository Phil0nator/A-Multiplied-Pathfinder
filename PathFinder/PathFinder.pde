void setup(){


  fullScreen(P2D); //Initialize window with the Accelerated GPU Renderer
  setupUI(); //See UILibrary

  NODEDIM = height/GRIDDIM;
  
  setupGrid(GRIDDIM,GRIDDIM);
  
  configurateUI();
}


enum State{
  setupGrid, setupStart, setupTarget, setupWalls, run, done;
}

State state = State.setupGrid;
String finishMessage = "";
long startTime = now();
int PENSIZE = 1;
boolean fastMode;
void draw(){

  background(255);

  if(state==State.setupGrid){

    setupGrid.show();
    setupStart.hide();
    setupTarget.hide();
    setupWalls.hide();
    setupGridUIConds();
      drawGrid();
  }else if (state==State.setupStart){
    setupGrid.hide();
    setupStart.show();
    setStart();
    setupStartUIConds();
      drawGrid();
  }else if (state==State.setupTarget){
    setupStart.hide();
    setupTarget.show();
    setTarget();
    setupTargetUIConds();
      drawGrid();
  }else if (state==State.setupWalls){
    setupWalls.show();
      drawGrid();
    setWalls();
    setupWallsUIConds();

  }else if (state == State.run){
    if(!fastMode){
      itorate();
    }


    drawGrid();
  }else if (state == State.done){
    drawGrid();
    fill(PURPLE);
    text(finishMessage,width/2-2,height/2-2);
    fill(BLACK);
    text(finishMessage,width/2,height/2);
  }



  updateUI();

}
void fastMode(){

  while(state==State.run){
    itorate();
  }


}

void setStart(){

  int startx = int(startX.get());
  int starty = int(startY.get());


  if(startx>0&&starty>0&&startx<GRID.size()&&starty<GRID.size()){ //within dims
    if(START!=null){
      START.start=false;

    }
    getNode(startx,starty).start = true;
    START = getNode(startx,starty);

  }

}

void setTarget(){

  int targetx = int(targetX.get());
  int targety = int(targetY.get());


  if(targetx>0&&targety>0&&targetx<GRID.size()&&targety<GRID.size()){ //within dims
    if(TARGET!=null){
      TARGET.target=false;

    }
    getNode(targetx,targety).target = true;
    TARGET = getNode(targetx,targety);


  }


}

void setWalls(){

  PENSIZE = int(pensize.get());
  if(PENSIZE <  1||PENSIZE>10) {
    PENSIZE=1;
  }

  fill(color(100,100,100,100));
  for(int i = 0 ; i < PENSIZE; i++){
    for(int j =0 ; j < PENSIZE; j++){
      rect((int)(((mouseX/NODEDIM)-(PENSIZE/2))+i)*NODEDIM,(int)(((mouseY/NODEDIM)-(PENSIZE/2))+j)*NODEDIM,NODEDIM,NODEDIM);
    }
  }

  if(mousePressed){
    int querriedx = mouseX;
    int querriedy = mouseY;
    querriedx/=NODEDIM;
    querriedy/=NODEDIM;

    if(querriedx>0&&querriedy>0&&querriedx<GRID.size()&&querriedy<GRID.size()){
      querriedx-=PENSIZE/2;
      querriedy-=PENSIZE/2;
      int ogQuerriedy = querriedy;
      for(int i = 0 ; i < PENSIZE;i++){

        for(int j = 0 ; j < PENSIZE;j++){
          if(querriedx>0&&querriedy>0&&querriedx<GRID.size()&&querriedy<GRID.size()){}else{return;}
          getNode(querriedx, querriedy).wall=(mouseButton==LEFT);

          querriedy++;

        }
        querriedx++;
        querriedy=ogQuerriedy;


      }
    }


  }

}







void keyPressed(){

  keyboardInput();
  if(state== State.setupGrid){
    if(keyCode==UP){
      GRIDDIM+=10;
    }else if(keyCode==DOWN){
      GRIDDIM-=10;
    }
    if(keyCode==UP||keyCode==DOWN){
      setupGrid(GRIDDIM,GRIDDIM);
    }

  }

}
