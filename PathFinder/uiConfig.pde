//Messy Configuration for all the UI Elements.
//See UILibrary for declarations

Page setupGrid = new Page(0,0,0,0);
Button gridBigger;
Button gridSmaller;
Button setupGridNext;


Page setupStart = new Page(0,0,0,0);
Button setupStartNext;
Entry startX;
Entry startY;

Page setupTarget = new Page(0,0,0,0);
Button setupTargetNext;
Entry targetX;
Entry targetY;

Page setupWalls = new Page(0,0,0,0);
Button begin;
Button beginFast;
Entry pensize;

void configurateUI(){

  gridBigger = new Button(width,0,width/20,height/20);
  gridBigger.x-=gridBigger.w*1.5;
  gridBigger.y=int(height/2-gridBigger.h*2.5);
  gridBigger.string("↑");

  gridSmaller = new Button(width,0,width/20,height/20);
  gridSmaller.x-=gridSmaller.w*1.5;
  gridSmaller.y=int(height/2-gridSmaller.h*1.5);
  gridSmaller.string("↓");

  setupGridNext = new Button(gridSmaller.x,int(height-gridSmaller.h*1.5),gridSmaller.w,gridSmaller.h);
  setupGridNext.string("Next");

  setupGrid.add(gridBigger);
  setupGrid.add(gridSmaller);
  setupGrid.add(setupGridNext);
  setupGrid.init();

  setupStartNext = new Button(gridSmaller.x,int(height-gridSmaller.h*1.5),gridSmaller.w,gridSmaller.h);
  setupStartNext.string("Next");

  startX = new Entry(gridBigger.x,gridBigger.y,gridBigger.w,gridBigger.h);
  startX.hintText("Start X");

  startY = new Entry(gridSmaller.x,gridSmaller.y,gridSmaller.w,gridSmaller.h);
  startY.hintText("Start Y");

  setupStart.add(startY);
  setupStart.add(startX);
  setupStart.add(setupStartNext);
  setupStart.init();

  setupTargetNext = new Button(gridSmaller.x,int(height-gridSmaller.h*1.5),gridSmaller.w,gridSmaller.h);
  setupTargetNext.string("Next");

  targetX = new Entry(gridBigger.x,gridBigger.y,gridBigger.w,gridBigger.h);
  targetX.hintText("Target X");

  targetY = new Entry(gridSmaller.x,gridSmaller.y,gridSmaller.w,gridSmaller.h);
  targetY.hintText("Target Y");


  setupTarget.add(targetY);
  setupTarget.add(targetX);
  setupTarget.add(setupTargetNext);
  setupTarget.init();


  begin = new Button(gridSmaller.x,int(height-gridSmaller.h*1.5),gridSmaller.w,gridSmaller.h);
  begin.string("Start");

  beginFast = new Button(gridBigger.x-gridBigger.w,int(height-gridBigger.h*3.5),gridSmaller.w*2,gridSmaller.h);
  beginFast.string("Begin (FAST)");

  pensize = new Entry(gridBigger.x,gridBigger.y,gridBigger.w,gridBigger.h);
  pensize.hintText("PenSize");

  setupWalls.add(beginFast);
  setupWalls.add(pensize);
  setupWalls.add(begin);
  setupWalls.init();



}

void setupGridUIConds(){

  if(gridBigger.clicked()){
    GRIDDIM++;
    setupGrid(GRIDDIM,GRIDDIM);
  }
  if(gridSmaller.clicked()){
    GRIDDIM--;
    setupGrid(GRIDDIM,GRIDDIM);
  }

  if(setupGridNext.clicked()){
    setupGridNext.state=0;
    setupGrid.hide();
    state = State.setupStart;
    delay(500);

  }

}

void setupStartUIConds(){

  if(setupStartNext.clicked()){
    state=State.setupTarget;
    setupStartNext.state=0;
    setupStart.hide();
    OPEN.add(START);
    delay(500);
  }


}

void setupTargetUIConds(){

  if(setupTargetNext.clicked()){
    setupTargetNext.state=0;
    setupTarget.hide();
    state=State.setupWalls;
    delay(500);
  }

}


void setupWallsUIConds(){

  if(begin.clicked()){
    setupWalls.hide();
    begin.state=0;
    state=State.run;
    startTime=now();
  }

  if(beginFast.clicked()){
    setupWalls.hide();
    beginFast.state=0;
    state=State.run;
    startTime=now();
    fastMode=true;
    thread("fastMode");
  }

}
