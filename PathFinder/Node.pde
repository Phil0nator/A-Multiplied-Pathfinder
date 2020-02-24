
public Node TARGET; //The current target node of the algorithm
public Node START; //The current Start node of the algorithm
ArrayList<ArrayList<Node>> GRID = new ArrayList<ArrayList<Node>>();
ArrayList<Node> OPEN = new ArrayList<Node>(); //all nodes opened (indexed in no particular order)
ArrayList<Node> CLOSED = new ArrayList<Node>(); // all nodes closed  (indexed in no particular order)


public int GRIDDIM = 25;
public int NODEDIM;


public class Node{
  //Costs under their standard names for an A* algorithm:
  int fcost;
  int gcost;
  int hcost;
  //Index in the grid
  int x;
  int y;

  boolean open;
  boolean closed;
  boolean target;
  boolean start;
  boolean wall;
  boolean path;
  
  //Neighbors and parent:
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


  int distTo(Node alpha){ //find approxomate distance from any other node
    //NOTE:
    //distTo is a very Heuristical approach, and basically assumes that no walls are present.
    //This works fine for A* algorithms because it will use the costs and the wall boolean adapt.
    int dx = abs(x-alpha.x);
    int dy = abs(y-alpha.y);

    return 10 * (dx+dy) + (4) + min(dx, dy);

  }

  Node simpleCopy(){ //Quick Copy Constructor
    Node out = new Node(x,y);
    out.parent=parent;
    return out;
  }

  int pathToStart(){ //Finds a path back to start
     ////////////////
     // --Explination:
     //    -Creates a copy of self
     //    -While none of the Parents of that copy equal the starter node:
     //      +Add Geometric distance from start to total,
     //      +Set the copy equal to    a copy of the copy's parents
     //      +Try again until one of the parents is the starter node
     /////////////////
  
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
              //at this point, we have each valid neighbor
              if(neighbor.target){
                //for when the program has completed its task
                state = State.done;
                neighbor.parent=this;
                finishMessage = "Fastest Path Found in ";
                backProp();

              }


              //now the neighbor has been accessed, so it is open
              neighbor.open=true;
              OPEN.add(neighbor);
              neighbor.parent=this;
              neighbor.findCosts();
            }else{
              if(neighbor.gcost>gcost+distTo(neighbor)){ //If this node was already done, BUT is still a better option:
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
    //Now the Node has been accessed, and operated on. It is now closed

  }



  void d(){ //visualize
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
      
      gcost = parent.gcost+distTo(parent); // geometric distance
      hcost = distTo(TARGET); //Geometric distance
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



public void setupGrid(int x, int y){ //Fill in all the ArrayLists properly
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

Node lowestCost(){ //Find the cheapest option out of all available(open) nodes
  //NOTE: Basically just a min() function, just for open nodes
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


void itorate(){ //iterate

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
  //once the path has been found, the algorithm backtracks to the start, setting the FASTEST route to path (making them blue)
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
