package nano.minigame
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nano.AssetLoader;
	import nano.Assets;
	import nano.ui.DialogBox;
	
	/**
	 * Superclass for all minigames comiled for Nanogame. Provide simple win/loss hooks 
	 * @author devin
	 * 
	 */
	
	/**
	 * Send out when a minigame has reached the successful completion state 
	 */	
	[Event(name="complete", type="flash.events.Event")]
	
	public class Minigame extends Sprite
	{
		
		private var failAlert:MovieClip;
		private var winAlert:MovieClip;
		
		/** State: Game is ready to play. */		
		public static const STATE_READY:String = "ready";
		/** State: Game is currently being played and simulated */
		public static const STATE_PLAY:String = "play";
		/** Player has failed, game is ready to be reset to READY */
		public static const STATE_FAIL:String = "fail";
		/** Player has won the game, game is ready to be reset to READY */
		public static const STATE_SUCCESS:String = "success";
		
		/**
		 * The state of the minigame 
		 */		
		private var _state:String = STATE_READY;
		public function get state():String {
			return this._state;
		}
		public function set state(val:String):void {
			var oldState:String = this._state;
			this._state = val;
			
			switch(this._state) {
				case STATE_PLAY:
					this.startMinigame();
					break;
				case STATE_SUCCESS:
					this.dispatchEvent(new Event(Event.COMPLETE));
					this.winAlert.visible = true;
					this.winAlert.play();
					break;
				
				case STATE_FAIL:
					this.failAlert.visible = true;
					this.failAlert.play();
					break;
			}
		}
		
		public function Minigame()
		{
			super();
			
			// Setup mask.
			var gameMask:Sprite = new Sprite();
			gameMask.graphics.beginFill(0x0);
			gameMask.graphics.drawRect(0, 0, DialogBox.CUTSCENE_WIDTH, DialogBox.CUTSCENE_HEIGHT);
			this.mask = gameMask;
			
			this.buildAssets();
		}
		
		protected function buildAssets():void {
			// Setup success and fail animations
			var _this:Minigame = this;
			var failLoader:AssetLoader = new AssetLoader(Assets.instance.minigameMinus);
			failLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
				_this.failAlert = (event.target).asset;
				_this.failAlert.stop();
				_this.failAlert.visible = false;
				_this.failAlert.x = 340;
				_this.addChild(_this.failAlert);
			});
			
			var winLoader:AssetLoader = new AssetLoader(Assets.instance.minigameCheck);
			winLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
				_this.winAlert = (event.target).asset;
				_this.winAlert.stop();
				_this.winAlert.visible = false;
				_this.winAlert.x = 340;
				_this.addChild(_this.winAlert);
			});
		}
		
		/**
		 * Update this game 
		 * @param dt Seconds passed since last update
		 */		
		public function update(dt:Number):void {
			// nothing
		}
		
		/**
		 * Draw procedural assets
		 */
		public function render():void {
			// nothing
		}
		
		/**
		 * Called when the game moved into the "PLAY" state
		 */
		protected function startMinigame():void {
			
		}
		
		/**
		 * A math helper function
		 */
		protected function isClose(a:Number, b:Number, radius:Number = 2):Boolean {
			return Math.abs(a - b) <= radius;
		}
	}
}