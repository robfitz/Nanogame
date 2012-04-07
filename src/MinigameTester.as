package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import nano.minigame.CancerMinigame;
	import nano.minigame.CircuitMinigame;
	import nano.minigame.Minigame;
	import nano.minigame.SpinMinigame;
	
	[SWF(width='760', height='346')]
	public class MinigameTester extends Sprite
	{
		
		private var now:int = 0;
		private var then:int = 0;
		private var game:Minigame;
		
		public function MinigameTester()
		{
			super();
			
			this.game = new CircuitMinigame();
			this.addChild(this.game);

			this.now = flash.utils.getTimer();
			this.addEventListener(Event.ENTER_FRAME, this.loopdeloop);
			
			this.game.state = Minigame.STATE_PLAY;
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
			this.game.update(dt);
		}
		
		/**
		 * Render game object that need to be blitted to the screen
		 */		
		public function render():void {
			this.game.render();
		}
	}
}