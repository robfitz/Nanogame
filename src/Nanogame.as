package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import nano.TmxLoader;
	import nano.World;
	
	/**
	 * Nanogame.as
	 * Top level control flow and execution for Nanogame
	 */

	[SWF(width='760', height='570')]
	public class Nanogame extends Sprite
	{
		
		/** Current frame time in milliseconds since game start */
		private var now:int = 0;
		
		/** Last frame time in milliseconds */
		private var then:int = 0;
		
		/** The isometric world our main character lives in */
		private var world:World;
		
		public function Nanogame()
		{
			this.world = new World(this);
			
			// load the world!
			var loader:TmxLoader = new TmxLoader();
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				var scenes:Object = loader.scenes;
				world.background = scenes["background"];
				world.objects = scenes["objects"];
				world.foreground = scenes["foreground"];
				
				//var bmp:Bitmap = new Bitmap(loader._bitmapCache[5].bitmapData); //loader.map.getGidOwner(10).image);
				//addChild(bmp);
				startLoop();
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
		 * Update game updates and ai 
		 * @param dt Time (in seconds) since the last frame
		 */		
		public function update(dt:Number):void {
			
		}
		
		/**
		 * Render game object that need to be blitted to the screen
		 */		
		public function render():void {
			this.world.render();
		} 
	}
}
