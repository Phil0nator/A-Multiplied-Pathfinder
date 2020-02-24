
public Node TARGET;
public Node START;
ArrayList<ArrayList<Node>> GRID = new ArrayList<ArrayList<Node>>();
ArrayList<Node> OPEN = new ArrayList<Node>();
ArrayList<Node> CLOSED = new ArrayList<Node>();


public int GRIDDIM = 25;
public int NODEDIM;


public class Node{

  int fcost;
  int gcost;
  int hcost;

  int x;
  int y;

  boolean open;
  boolean closed;
  boolean target;
  boolean start;
  boolean wall;
  boolean path;

  Node parent;
  Node up;
  Node upRight;
  Node right;
  Node downRight;
  Node down;
  Node downLeft;
  Node left;
  Node upLeft;
  Node[] neighbors;


  void setNeighbors(){
    Node[] n = {up, upRight,right, downRight, down,downLeft, left, upLeft};
    neighbors=n;
  }


  int distTo(Node alpha){

    int dx = abs(x-alpha.x);
    int dy = abs(y-alpha.y);

    return 10 * (dx+dy) + (4) + min(dx, dy);

  }

  Node simpleCopy(){
    Node out = new Node(x,y);
    out.parent=parent;
    return out;
  }

  int pathToStart(){
    if(start)return 0;
    boolean finished = false;
    int total = 0;
    Node tester = simpleCopy();
    int maxout = 0;
    while(!finished){
      maxout++;
      if(maxout>1000){
        break;
      }


      total+=(tester.distTo(tester.parent));
      if(tester.parent==START){
        finished=true;
      }
      tester=tester.parent.simpleCopy();


    }
    return total;


  }


  void check(){


    for(Node neighbor : neighbors){
      if(neighbor!=null){

        if(!neighbor.wall){

          if(!neighbor.closed){
            if(!neighbor.open){

              if(neighbor.target){
                state = State.done;
                neighbor.parent=this;
                finishMessage = "Fastest Path Found in ";
                backProp();

              }



              neighbor.open=true;
              OPEN.add(neighbor);
              neighbor.parent=this;
              neighbor.findCosts();
            }else{
              if(neighbor.gcost>gcost+distTo(neighbor)){
                neighbor.parent=this;
                neighbor.gcost = gcost+distTo(neighbor);
              }



            }
          }
        }
      }

    }
    open=false;
    closed=true;


  }



  void d(){
    pushMatrix();
    translate(x*NODEDIM, y*NODEDIM);
    if(!open&&!target&&!start&&!closed&&!wall){
      fill(WHITE);
    }else if (target){
      fill(YELLOW);
    }else if (start){
      fill(PURPLE);
    }else if (open){
      fill(GREEN);
    }else if (!open&&closed){
      fill(RED);
    }else if (wall){
      fill(BLACK);
    }
    if (path){
      fill(BLUE);
    }
    rect(0,0,NODEDIM,NODEDIM);
    popMatrix();
  }


  Node(int i, int j){
    x=i;
    y=j;

  }


  void setParent(Node parent){
    this.parent =parent;
  }



  void findCosts(){

      gcost = parent.gcost+distTo(parent);
      hcost = distTo(TARGET);
      fcost = gcost+hcost;

  }

}


void drawGrid(){
  for(ArrayList<Node> layer : GRID){
    for(Node node : layer){
      node.d();
    }
  }


}


Node getNode(int x, int y){
  if(x<GRID.size()&&y<GRID.size()&&x>0&&y>0){
    return GRID.get(x).get(y);
  }else{
    return null;

  }

}



public void setupGrid(int x, int y){
  GRID.clear();

  for(int i = 0; i < x;i++){
    GRID.add(new ArrayList<Node>());
    for(int j = 0; j < y; j++){
      GRID.get(i).add(new Node(i, j));
    }
  }

  for(ArrayList<Node> layer : GRID){
    for(Node node : layer){

      //setup directional awareness
      node.up = getNode(node.x, node.y-1);
      node.upRight = getNode(node.x+1, node.y-1);
      node.right = getNode(node.x+1, node.y);
      node.downRight = getNode(node.x+1, node.y+1);
      node.down = getNode(node.x, node.y+1);
      node.downLeft = getNode(node.x-1, node.y+1);
      node.left= getNode(node.x-1, node.y);
      node.upLeft = getNode(node.x-1, node.y-1);
      node.setNeighbors();

    }


  }

  NODEDIM = height/GRIDDIM;



}

Node lowestCost(){

  int lowest = OPEN.get(0).fcost;
  Node lowestNode = OPEN.get(0);
  for(Node n : OPEN){

    if(n.fcost<lowest){
      lowest=n.fcost;
      lowestNode = n;
    }

  }

  return lowestNode;

}


void itorate(){

  Node tester = lowestCost();
  tester.check();
  OPEN.remove(tester);
  CLOSED.add(tester);
  if(OPEN.size()<1){
    state=State.done;
    finishMessage = "NO POSSIBLE SOLUTION";
  }

}

void backProp(){

  boolean finished = false;
  Node current = TARGET;
  while(!finished){
    current.path=true;
    current.open=false;
    current.closed=false;
    current=current.parent;
    if(current==START){
      finished=true;
    }



  }
  float runtime = float(int((now())-(startTime)))/1000;
  finishMessage = finishMessage + runtime + " Seconds";


}
