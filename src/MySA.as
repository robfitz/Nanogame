package {
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.Stroke;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import nano.TmxLoader;
	import nano.World;
	
	/**
	 * Nanogame.as
	 * Top level control flow and execution for Nanogame
	 */
	
	[SWF(width='760', height='570')]
	public class MySA extends Sprite
	{
		
		/** Current frame time in milliseconds since game start */
		private var now:int = 0;
		
		/** Last frame time in milliseconds */
		private var then:int = 0;
		
		/** The isometric world our main character lives in */
		private var world:World;
		
		public function MySA()
		{
			this.world = new World(this);
			
			// load the world!
			var loader:TmxLoader = new TmxLoader();
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				world.initWorldFromLoader(loader);
				startLoop();
				
				// DEBUG GRID
				var g:IsoGrid = new IsoGrid();
				g.gridlines = new Stroke(0, 0xCCCCCC, 0);
				g.showOrigin = false;
				g.cellSize = 32;
				g.setGridSize(30, 30);
				if (world.foreground) {
					world.foreground.addChild(g);
				}
				// END DEBUG GRID 
				
				stage.addEventListener(MouseEvent.MOUSE_DOWN, grid_mouseHandler);
                stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                    
				
			});
//			loader.load("./assets/demo_001_reformat.tmx");
			loader.load("assets/mysa/frontier_outpost_mysa.tmx");
            
					
		}
		
		/**
		 * Starts the game loop and subsequently the interactive game 
		 */		
		public function startLoop():void {
			this.now = flash.utils.getTimer();
			this.addEventListener(Event.ENTER_FRAME, this.loopdeloop);
		}
		
		/**
		 * Stops the game for the time being
		 */
		public function stopGame():void {
			this.removeEventListener(Event.ENTER_FRAME, this.loopdeloop);
		}
		
		public function loopdeloop(event:Event):void {
			this.then = this.now;
			this.now = flash.utils.getTimer();
			var dt:Number = (this.now - this.then) / 1000.0;
			this.update(dt);
			
			this.move_character();
			
			this.render();
		}
		
		/**
		 * Update game logic 
		 * @param dt Time (in seconds) since the last frame
		 */		
		public function update(dt:Number):void {
			this.world.update(dt);
		}
		
		/**
		 * Render game object that need to be blitted to the screen
		 */		
		public function render():void {
			this.world.render();
		} 
		 
        private function grid_mouseHandler (event:MouseEvent):void
        {
        	isMouseDown = true;
        	onMouseMove(event);
        }
        
        private function onMouseUp(event:MouseEvent):void {
        	isMouseDown = false;
        }
        
        private function onMouseMove(event:MouseEvent):void {
        	
        }
        
        private var isMouseDown:Boolean = false;
                
        private function followMouse():void {
        	if (isMouseDown) {
				var pt:Pt = new Pt(stage.mouseX - stage.stageWidth / 2 + world.view.currentX, stage.mouseY - stage.stageHeight / 2 + world.view.currentY);
				
				IsoMath.screenToIso(pt);
				world.player.walkTo(pt);
				
//				clickTarget.x = pt.x;
//				clickTarget.y = pt.y;
			}
        }
                
                
        private function move_character():void
        {
        	if (isMouseDown) {
        		followMouse();
        	}
			
            world.view.centerOnIso(world.player);
        }
	}
}
