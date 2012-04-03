package nano.minigame
{
	import flash.display.Sprite;
	import flash.events.Event;
	
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
		}
		
		/**
		 * Update this game 
		 * @param dt Seconds passed since last update
		 */		
		public function update(dt:Number):void {
			// nothing
		}
		
		/**
		 * Called when the game moved into the "PLAY" state
		 */
		protected function startMinigame():void {
			
		}
	}
}