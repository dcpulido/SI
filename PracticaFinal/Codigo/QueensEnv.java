import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.GridWorldModel;
import jason.environment.grid.GridWorldView;
import jason.environment.grid.Location;

import java.awt.BorderLayout;
import java.awt.Canvas;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;

import javax.imageio.*;

import java.io.*;

import java.util.Random;
import java.util.logging.Logger;


public class QueensEnv extends Environment {

    public static final int GSize  =   8; // grid size
    public static final int EMPTY  =   8; // empty cell code in grid model
    public static final int ATACK  =  16; // empty cell code in grid model
    public static final int HOLE   =  32; // hole in a cell code in grid model
    public static final int QUEEN  =  64; // queen code in grid model
    public static final int BLOCK  = 128; // block in a cell code in grid model

    public static final Term    pq = Literal.parseLiteral("put(queen)");

    static Logger logger = Logger.getLogger(QueensEnv.class.getName());

    private QueensModel model;
    private QueensView  view;
	private int queensPlaced;
	private int blocksPlaced;
	private int holesPlaced;
	private Location[] wQueens;
	private Location[] bQueens;
	
    
    @Override
    public void init(String[] args) {
        model = new QueensModel();
        view  = new QueensView(model);
        model.setView(view);
        updatePercepts();
		queensPlaced = 0;
		blocksPlaced = 0;
		holesPlaced = 0;
		wQueens = new Location[GSize/2];
		bQueens = new Location[GSize/2];
    }
    
    @Override
    public boolean executeAction(String ag, Structure action) {
        logger.info(ag+" doing: "+ action);
        try {
			if (action.getFunctor().equals("move_towards")) {
                int x = (int)((NumberTerm)action.getTerm(0)).solve();
                int y = (int)((NumberTerm)action.getTerm(1)).solve();
                model.moveTowards(x,y);
            } else if (action.getFunctor().equals("queen")) {
                int x = (int)((NumberTerm)action.getTerm(0)).solve();
				int y = (int)((NumberTerm)action.getTerm(1)).solve();
				model.putQueen(x,y);
            	} else if (action.getFunctor().equals("freeBB")) {
                	int x = (int)((NumberTerm)action.getTerm(0)).solve();
					int y = (int)((NumberTerm)action.getTerm(1)).solve();
                	model.freeAttack(x,y);
            		} else if (action.getFunctor().equals("clean")) {
                		int x = (int)((NumberTerm)action.getTerm(0)).solve();
						int y = (int)((NumberTerm)action.getTerm(1)).solve();
						model.clean(x,y);
            			} else if (action.getFunctor().equals("block")) {
							int x = (int)((NumberTerm)action.getTerm(0)).solve();
							int y = (int)((NumberTerm)action.getTerm(1)).solve();
							model.putBlock(x,y);
							} else if (action.getFunctor().equals("hole")) {
								int x = (int)((NumberTerm)action.getTerm(0)).solve();
								int y = (int)((NumberTerm)action.getTerm(1)).solve();
								model.putHole(x,y);
								} else {
									return false;
								}
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        updatePercepts();

        try {
            Thread.sleep(200);
        } catch (Exception e) {}
        informAgsEnvironmentChanged();
        return true;
    }
    
    /** creates the agents perception based on the QueensModel */
    void updatePercepts() {
        //clearPercepts();
        
        //Location r1Loc = model.getAgPos(0);
        //Location r2Loc = model.getAgPos(1);
        
        //Literal pos1 = Literal.parseLiteral("pos(r1," + r1Loc.x + "," + r1Loc.y + ")");
		
		Literal sizeBB = Literal.parseLiteral("size(" + GSize + ")");

        //addPercept(pos1);
		
		addPercept(sizeBB);
    }

    class QueensModel extends GridWorldModel {
        
        public static final int MErr = 2; // max error in pick garb
        int nerr; // number of tries of pick garb
        boolean r1HasGarb = false; // whether r1 is carrying garbage or not

        Random random = new Random(System.currentTimeMillis());

        private QueensModel() {
            super(GSize, GSize, 3); //Now the environment play with 3 agents
            
            // initial location of agents
            try {
                setAgPos(0, 0, 0);
                Location r2Loc = new Location(GSize/2, GSize/2);
            } catch (Exception e) {
                e.printStackTrace();
            }
            
 			for (int x = 0; x < GSize; x++) {
                for (int y = 0; y < GSize; y++) {
                    add(EMPTY,x,y);
                }
            };
			
        }
        
		
        void moveTowards(int x, int y) throws Exception {
            Location r1 = getAgPos(0);
			r1.x = x;
			r1.y = y;
            setAgPos(0, r1);
        }
        
		void putQueen(int x, int y) throws Exception {
			Literal turn = Literal.parseLiteral("player(" + queensPlaced%2 + ")");
			removePercept(turn);
            add(QUEEN, x, y);
			Literal queen = Literal.parseLiteral("queen(" + x + "," + y + ")");
			addPercept(queen);
			if (queensPlaced%2  == 0) {
				wQueens[queensPlaced/2] = new Location(x,y);
				try {
					Thread.sleep(5000);
        		} catch (Exception e) {}
			} else {
				bQueens[queensPlaced/2] = new Location(x,y);
			}; 
			queensPlaced++;
			turn = Literal.parseLiteral("player(" + queensPlaced%2 + ")");
			addPercept(turn);
			//cellAttacked(x,y);
        }
		
		void putBlock(int x, int y) throws Exception {
            add(BLOCK, x, y);
			Literal block = Literal.parseLiteral("block(" + x + "," + y + ")");
			addPercept(block);
			blocksPlaced++;
        }
		
		void putHole(int x, int y) throws Exception {
            add(HOLE, x, y);
			Literal hole = Literal.parseLiteral("hole(" + x + "," + y + ")");
			addPercept(hole);
			holesPlaced++;
        }
		
        /*
		void redo(int x, int y) {
			for (int i = 0; i < GSize; i++) {
				if (hasObject(ATACK,i,y)) {freeAttack(i, y);};
			};
			for (int i = 0; i < GSize; i++) {
				if (hasObject(ATACK,x,i)) {freeAttack(x, i);};
			};			
			for (int i = 0; i < GSize; i++) {
				for (int j = 0; j < GSize; j++) {
				}
			};
			for (int i = 0; i < GSize; i++) {
				for (int j = 0; j < GSize; j++) {
				}
			};
			for (int i = 0; i < GSize/2; i++) {
				if (wQueens[i].x = x) {
				}
			}

        }
		*/

		void cellAttacked(int x, int y) {
 			Literal attackCell;
			int col;
			for (int i = 0; i < GSize; i++) {
				if (i != x) {
					add(ATACK, i, y);
					attackCell = Literal.parseLiteral("attack(" + i + "," + y + ")");
					addPercept(attackCell);
				};
				if (i != y) {
					add(ATACK, x, i);
					attackCell = Literal.parseLiteral("attack(" + x + "," + i + ")");
					addPercept(attackCell);
					if ((0 <= x-i+y) & (GSize > x-i+y)) {
						col= x-i+y;
						add(ATACK, col, i);
						attackCell = Literal.parseLiteral("attack(" + col + "," + i + ")");
						addPercept(attackCell);
					};
					if ((GSize > x+i-y) & (0 <= x+i-y)){
						col= x+i-y;
						add(ATACK, col, i);
						attackCell = Literal.parseLiteral("attack(" + col + "," + i + ")");
						addPercept(attackCell);
					};
				}
			};
			try {
				Thread.sleep(100);
       		} catch (Exception e) {};

        }
        
		void clean(int x, int y) throws Exception {
            remove(QUEEN,x,y);
			Literal queen = Literal.parseLiteral("queen(" + x + "," + y + ")");
			removePercept(queen);
        }
        
		void freeAttack(int x, int y) throws Exception {
            remove(ATACK,x,y);
			Literal attackedCell = Literal.parseLiteral("attack(" + x + "," + y + ")");
			removePercept(attackedCell);
        }
    }
    
    class QueensView extends GridWorldView {
	
		public QueensView(QueensModel model) {
            super(model, "Queen's World", 400);
			this.model = model;
			defaultFont = new Font("Arial", Font.BOLD, 18); // change default font
			setVisible(true);
			Graphics g = this.getCanvas().getGraphics();
			model.setView(this);
			//repaint();
        }

		/** draw application objects */
        @Override
        public void draw(Graphics g, int x, int y, int object) {
            switch (object) {
                case QueensEnv.EMPTY: drawEmpty(g, x, y);  break;
                case QueensEnv.QUEEN: drawQueen(g, x, y);  break;
                case QueensEnv.ATACK: drawAtack(g, x, y);  break;
                case QueensEnv.BLOCK: drawObstacle(g, x, y);  break;
                case QueensEnv.HOLE:  drawHole(g, x, y);  break;
            }
        }
		
        /** draw application objects */
        @Override
        public void drawEmpty(Graphics g, int x, int y) {
			if ((x+y)%2==0){
				g.setColor(Color.yellow);
			} else {
				g.setColor(Color.cyan);
			};
			g.fillRect(x * cellSizeW + 1, y * cellSizeH+1, cellSizeW-1, cellSizeH-1);
			g.drawRect(x * cellSizeW, y * cellSizeH, cellSizeW, cellSizeH);
		}

        @Override
        public void drawAgent(Graphics g, int x, int y, Color c, int id) {
			if ((x+y)%2==0){
				c = Color.black;
			} else {
				c = Color.white;
			};
         }

		public void drawAtack(Graphics g, int x, int y) {
			if (queensPlaced%2==0){
				g.setColor(Color.white);
			} else {
				g.setColor(Color.black);
			};
			g.fillOval(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW - 4, cellSizeH - 4);
        }
		
        public void drawHole(Graphics g, int x, int y) {
			g.setColor(Color.white);
			g.fillRect(x * cellSizeW, y * cellSizeH, cellSizeW-1, cellSizeH-1);
			g.drawRect(x * cellSizeW, y * cellSizeH, cellSizeW, cellSizeH);
		}

        public void drawQueen(Graphics g, int x, int y) {
			BufferedImage bqImg = null;
			BufferedImage wqImg = null;
			try {
				bqImg = ImageIO.read(new File("img/bq.png"));
				wqImg = ImageIO.read(new File("img/wq.png"));
				} catch (IOException e) {
			}
			
			//if ((x+y)%2==0){ 
			if (queensPlaced%2==1){ 
				g.drawImage(bqImg, x * cellSizeW + 2, y * cellSizeH + 2, null);
			} else {
				g.drawImage(wqImg, x * cellSizeW + 2, y * cellSizeH + 2, null);
			};
			
        }

    }    
}
