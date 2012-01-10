package {
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
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
		
		/** The isometric would our main character lives in */
		private var world:World;
		
		public function Nanogame()
		{
			world = new World(this);
		}
		
		public function loopdeloop():void {
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
