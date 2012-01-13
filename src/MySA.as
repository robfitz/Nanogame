package {
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.graphics.Stroke;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import nano.CollisionLayer;
	import nano.TmxLoader;
	import nano.World;
	
	/**
	 * Nanogame.as
	 * Top level control flow and execution for Nanogame
	 */
	
	[SWF(width='1000', height='800')]
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
				g.gridlines = new Stroke(1, 0xCCCCCC, 1);
				g.showOrigin = false;
				g.cellSize = 32;
				g.setGridSize(30, 30);
				world.foreground.addChild(g);
				// END DEBUG GRID
				
			});
			loader.load("./assets/demo_001_reformat.tmx");
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
	}
}